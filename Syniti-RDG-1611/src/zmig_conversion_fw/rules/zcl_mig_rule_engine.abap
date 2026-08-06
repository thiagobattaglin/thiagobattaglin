"! Engine genérico de regras de derivação para field mappings.
"! Suporta os padrões comuns do Migration Cockpit sem criar classes por regra.
"! Tudo via configuração em tabela.
"!
"! Tipos de regra suportados:
"!   VALUE_MAP  → Mapeia valor de entrada para valor de saída (CASE/WHEN)
"!   FALLBACK   → Usa o primeiro campo não-vazio de uma lista ordenada
"!   FIXED      → Sempre seta um valor fixo
"!   COPY       → Copia valor de outro campo
"!   CONDITIONAL→ Se campo X = valor, então campo Y recebe valor Z
"!
"! Exemplos do Migration Cockpit que são cobertos:
"!   CVT_BSART (VALUE_MAP): BSTYP 'F' → BSART 'NB'
"!   SET_OUR_REF_2 (FALLBACK): UNSEZ → EBELN (primeiro não-vazio)
CLASS zcl_mig_rule_engine DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS:
      c_type_value_map   TYPE string VALUE 'VALUE_MAP',
      c_type_fallback    TYPE string VALUE 'FALLBACK',
      c_type_fixed       TYPE string VALUE 'FIXED',
      c_type_copy        TYPE string VALUE 'COPY',
      c_type_conditional TYPE string VALUE 'CONDITIONAL'.

    TYPES:
      BEGIN OF ty_rule,
        rule_id      TYPE string,
        bapi_name    TYPE string,
        rule_type    TYPE string,
        target_field TYPE fieldname,
        sequence     TYPE i,
        is_active    TYPE abap_bool,
      END OF ty_rule,
      ty_rules TYPE SORTED TABLE OF ty_rule WITH UNIQUE KEY rule_id.

    " Para VALUE_MAP: source_value → target_value
    " Para FALLBACK: source_fields em ordem de prioridade (sequence)
    " Para FIXED: fixed_value é o valor a setar
    " Para COPY: source_field é o campo de origem
    " Para CONDITIONAL: condition_field/condition_value definem o IF, source_field/fixed_value o THEN
    TYPES:
      BEGIN OF ty_rule_detail,
        rule_id         TYPE string,
        sequence        TYPE i,
        source_field    TYPE fieldname,
        condition_field TYPE fieldname,
        condition_value TYPE string,
        source_value    TYPE string,
        target_value    TYPE string,
        fixed_value     TYPE string,
      END OF ty_rule_detail,
      ty_rule_details TYPE SORTED TABLE OF ty_rule_detail WITH NON-UNIQUE KEY rule_id sequence.

    TYPES:
      BEGIN OF ty_log_entry,
        rule_id      TYPE string,
        rule_type    TYPE string,
        target_field TYPE fieldname,
        result_value TYPE string,
        success      TYPE abap_bool,
        message      TYPE string,
      END OF ty_log_entry,
      ty_log TYPE STANDARD TABLE OF ty_log_entry WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_result,
        success TYPE abap_bool,
        applied TYPE i,
        skipped TYPE i,
        errors  TYPE i,
        log     TYPE ty_log,
      END OF ty_result.

    METHODS:
      "! Executa todas as regras configuradas para a BAPI contra a estrutura.
      "! @parameter iv_bapi_name | Nome da BAPI
      "! @parameter ir_data      | Referência à estrutura (modificada in place)
      "! @parameter rs_result    | Resultado
      execute
        IMPORTING
          iv_bapi_name    TYPE clike
          ir_data         TYPE REF TO data
        RETURNING
          VALUE(rs_result) TYPE ty_result,

      "! Adiciona uma regra em memória (sem DB).
      "! @parameter is_rule    | Definição da regra
      "! @parameter it_details | Detalhes (value maps, sources, etc.)
      add_rule
        IMPORTING
          is_rule    TYPE ty_rule
          it_details TYPE ty_rule_details,

      "! Carrega regras do banco de dados.
      "! @parameter iv_bapi_name | Filtro opcional por BAPI
      load_from_db
        IMPORTING
          iv_bapi_name TYPE clike OPTIONAL.

  PRIVATE SECTION.
    DATA mt_rules   TYPE ty_rules.
    DATA mt_details TYPE ty_rule_details.

    METHODS:
      execute_value_map
        IMPORTING
          is_rule  TYPE ty_rule
          ir_data  TYPE REF TO data
        RETURNING
          VALUE(rs_log) TYPE ty_log_entry,

      execute_fallback
        IMPORTING
          is_rule  TYPE ty_rule
          ir_data  TYPE REF TO data
        RETURNING
          VALUE(rs_log) TYPE ty_log_entry,

      execute_fixed
        IMPORTING
          is_rule  TYPE ty_rule
          ir_data  TYPE REF TO data
        RETURNING
          VALUE(rs_log) TYPE ty_log_entry,

      execute_copy
        IMPORTING
          is_rule  TYPE ty_rule
          ir_data  TYPE REF TO data
        RETURNING
          VALUE(rs_log) TYPE ty_log_entry,

      execute_conditional
        IMPORTING
          is_rule  TYPE ty_rule
          ir_data  TYPE REF TO data
        RETURNING
          VALUE(rs_log) TYPE ty_log_entry,

      read_field
        IMPORTING
          iv_field_name  TYPE fieldname
          ir_data        TYPE REF TO data
        RETURNING
          VALUE(rv_value) TYPE string,

      write_field
        IMPORTING
          iv_field_name TYPE fieldname
          iv_value      TYPE string
          ir_data       TYPE REF TO data
        RETURNING
          VALUE(rv_success) TYPE abap_bool.

ENDCLASS.

CLASS zcl_mig_rule_engine IMPLEMENTATION.

  METHOD execute.
    LOOP AT mt_rules INTO DATA(ls_rule)
      WHERE bapi_name = iv_bapi_name
        AND is_active = abap_true.

      DATA(ls_log) = VALUE ty_log_entry( ).

      CASE ls_rule-rule_type.
        WHEN c_type_value_map.
          ls_log = execute_value_map( is_rule = ls_rule ir_data = ir_data ).
        WHEN c_type_fallback.
          ls_log = execute_fallback( is_rule = ls_rule ir_data = ir_data ).
        WHEN c_type_fixed.
          ls_log = execute_fixed( is_rule = ls_rule ir_data = ir_data ).
        WHEN c_type_copy.
          ls_log = execute_copy( is_rule = ls_rule ir_data = ir_data ).
        WHEN c_type_conditional.
          ls_log = execute_conditional( is_rule = ls_rule ir_data = ir_data ).
        WHEN OTHERS.
          ls_log-success = abap_false.
          ls_log-message = |Unknown rule type: { ls_rule-rule_type }|.
      ENDCASE.

      APPEND ls_log TO rs_result-log.

      CASE ls_log-success.
        WHEN abap_true.
          rs_result-applied = rs_result-applied + 1.
        WHEN abap_false.
          IF ls_log-message CS 'skipped'.
            rs_result-skipped = rs_result-skipped + 1.
          ELSE.
            rs_result-errors = rs_result-errors + 1.
          ENDIF.
      ENDCASE.
    ENDLOOP.

    rs_result-success = xsdbool( rs_result-errors = 0 ).
  ENDMETHOD.

  METHOD execute_value_map.
    " Padrão CVT_BSART: lê source_field, busca na tabela de mapeamento.
    " O source_field está no primeiro detail com source_field preenchido.
    rs_log-rule_id      = is_rule-rule_id.
    rs_log-rule_type    = is_rule-rule_type.
    rs_log-target_field = is_rule-target_field.

    " Achar qual campo é o source (o que tem source_field preenchido e source_value vazio)
    DATA(lv_input_value) = VALUE string( ).
    LOOP AT mt_details INTO DATA(ls_det)
      WHERE rule_id = is_rule-rule_id
        AND source_field IS NOT INITIAL
        AND source_value IS INITIAL.
      lv_input_value = read_field( iv_field_name = ls_det-source_field ir_data = ir_data ).
      EXIT. " Primeiro source encontrado
    ENDLOOP.

    " Se target field já preenchido, skip (comportamento original do Migration Cockpit)
    DATA(lv_current) = read_field( iv_field_name = is_rule-target_field ir_data = ir_data ).
    IF lv_current IS NOT INITIAL.
      rs_log-success      = abap_true.
      rs_log-result_value = lv_current.
      rs_log-message      = |Target already set, skipped|.
      RETURN.
    ENDIF.

    IF lv_input_value IS INITIAL.
      rs_log-success = abap_false.
      rs_log-message = |Source value is empty, skipped|.
      RETURN.
    ENDIF.

    " Buscar mapeamento source_value → target_value
    READ TABLE mt_details INTO DATA(ls_map)
      WITH KEY rule_id      = is_rule-rule_id
               source_value = lv_input_value.
    IF sy-subrc = 0.
      write_field( iv_field_name = is_rule-target_field iv_value = ls_map-target_value ir_data = ir_data ).
      rs_log-success      = abap_true.
      rs_log-result_value = ls_map-target_value.
      rs_log-message      = |'{ lv_input_value }' → '{ ls_map-target_value }'|.
    ELSE.
      rs_log-success = abap_false.
      rs_log-message = |No mapping for value '{ lv_input_value }'|.
    ENDIF.
  ENDMETHOD.

  METHOD execute_fallback.
    " Padrão SET_OUR_REF_2: usa primeiro campo não-vazio da lista ordenada.
    rs_log-rule_id      = is_rule-rule_id.
    rs_log-rule_type    = is_rule-rule_type.
    rs_log-target_field = is_rule-target_field.

    LOOP AT mt_details INTO DATA(ls_det)
      WHERE rule_id = is_rule-rule_id.

      DATA(lv_value) = VALUE string( ).
      IF ls_det-source_field IS NOT INITIAL.
        lv_value = read_field( iv_field_name = ls_det-source_field ir_data = ir_data ).
      ELSEIF ls_det-fixed_value IS NOT INITIAL.
        lv_value = ls_det-fixed_value.
      ENDIF.

      IF lv_value IS NOT INITIAL.
        write_field( iv_field_name = is_rule-target_field iv_value = lv_value ir_data = ir_data ).
        rs_log-success      = abap_true.
        rs_log-result_value = lv_value.
        rs_log-message      = |Using field { ls_det-source_field }: '{ lv_value }'|.
        RETURN.
      ENDIF.
    ENDLOOP.

    " Nenhum campo com valor
    rs_log-success = abap_false.
    rs_log-message = |All source fields empty, skipped|.
  ENDMETHOD.

  METHOD execute_fixed.
    " Seta valor fixo no campo target.
    rs_log-rule_id      = is_rule-rule_id.
    rs_log-rule_type    = is_rule-rule_type.
    rs_log-target_field = is_rule-target_field.

    READ TABLE mt_details INTO DATA(ls_det)
      WITH KEY rule_id = is_rule-rule_id.
    IF sy-subrc = 0 AND ls_det-fixed_value IS NOT INITIAL.
      write_field( iv_field_name = is_rule-target_field iv_value = ls_det-fixed_value ir_data = ir_data ).
      rs_log-success      = abap_true.
      rs_log-result_value = ls_det-fixed_value.
      rs_log-message      = |Fixed value set|.
    ELSE.
      rs_log-success = abap_false.
      rs_log-message = |No fixed value configured|.
    ENDIF.
  ENDMETHOD.

  METHOD execute_copy.
    " Copia valor de source_field para target_field.
    rs_log-rule_id      = is_rule-rule_id.
    rs_log-rule_type    = is_rule-rule_type.
    rs_log-target_field = is_rule-target_field.

    READ TABLE mt_details INTO DATA(ls_det)
      WITH KEY rule_id = is_rule-rule_id.
    IF sy-subrc = 0 AND ls_det-source_field IS NOT INITIAL.
      DATA(lv_value) = read_field( iv_field_name = ls_det-source_field ir_data = ir_data ).
      IF lv_value IS NOT INITIAL.
        write_field( iv_field_name = is_rule-target_field iv_value = lv_value ir_data = ir_data ).
        rs_log-success      = abap_true.
        rs_log-result_value = lv_value.
        rs_log-message      = |Copied from { ls_det-source_field }|.
      ELSE.
        rs_log-success = abap_false.
        rs_log-message = |Source field { ls_det-source_field } is empty, skipped|.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD execute_conditional.
    " Se condition_field = condition_value, então aplica source_field ou fixed_value.
    rs_log-rule_id      = is_rule-rule_id.
    rs_log-rule_type    = is_rule-rule_type.
    rs_log-target_field = is_rule-target_field.

    LOOP AT mt_details INTO DATA(ls_det)
      WHERE rule_id = is_rule-rule_id.

      " Avaliar condição
      DATA(lv_cond_value) = read_field( iv_field_name = ls_det-condition_field ir_data = ir_data ).

      IF lv_cond_value = ls_det-condition_value.
        " Condição atendida → aplicar valor
        DATA(lv_result) = VALUE string( ).
        IF ls_det-fixed_value IS NOT INITIAL.
          lv_result = ls_det-fixed_value.
        ELSEIF ls_det-source_field IS NOT INITIAL.
          lv_result = read_field( iv_field_name = ls_det-source_field ir_data = ir_data ).
        ENDIF.

        IF lv_result IS NOT INITIAL.
          write_field( iv_field_name = is_rule-target_field iv_value = lv_result ir_data = ir_data ).
          rs_log-success      = abap_true.
          rs_log-result_value = lv_result.
          rs_log-message      = |Condition { ls_det-condition_field }='{ ls_det-condition_value }' met|.
          RETURN.
        ENDIF.
      ENDIF.
    ENDLOOP.

    rs_log-success = abap_false.
    rs_log-message = |No condition matched, skipped|.
  ENDMETHOD.

  METHOD add_rule.
    INSERT is_rule INTO TABLE mt_rules.
    INSERT LINES OF it_details INTO TABLE mt_details.
  ENDMETHOD.

  METHOD load_from_db.
    IF iv_bapi_name IS NOT INITIAL.
      SELECT rule_id, bapi_name, rule_type, target_field, sequence, is_active
        FROM zmig_rule_cfg
        WHERE bapi_name = @iv_bapi_name
          AND is_active = @abap_true
        INTO CORRESPONDING FIELDS OF TABLE @mt_rules.
    ELSE.
      SELECT rule_id, bapi_name, rule_type, target_field, sequence, is_active
        FROM zmig_rule_cfg
        WHERE is_active = @abap_true
        INTO CORRESPONDING FIELDS OF TABLE @mt_rules.
    ENDIF.

    IF mt_rules IS NOT INITIAL.
      SELECT rule_id, sequence, source_field, condition_field,
             condition_value, source_value, target_value, fixed_value
        FROM zmig_rule_detail
        FOR ALL ENTRIES IN @mt_rules
        WHERE rule_id = @mt_rules-rule_id
        INTO CORRESPONDING FIELDS OF TABLE @mt_details.
    ENDIF.
  ENDMETHOD.

  METHOD read_field.
    FIELD-SYMBOLS <fs_struct> TYPE any.
    FIELD-SYMBOLS <fs_field>  TYPE any.

    ASSIGN ir_data->* TO <fs_struct>.
    ASSIGN COMPONENT iv_field_name OF STRUCTURE <fs_struct> TO <fs_field>.
    IF sy-subrc = 0.
      rv_value = condense( CONV string( <fs_field> ) ).
    ENDIF.
  ENDMETHOD.

  METHOD write_field.
    FIELD-SYMBOLS <fs_struct> TYPE any.
    FIELD-SYMBOLS <fs_field>  TYPE any.

    ASSIGN ir_data->* TO <fs_struct>.
    ASSIGN COMPONENT iv_field_name OF STRUCTURE <fs_struct> TO <fs_field>.
    IF sy-subrc = 0.
      <fs_field> = iv_value.
      rv_success = abap_true.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
