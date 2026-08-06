"! Engine de conversão para migração via BAPIs.
"! Usa ALPHA = IN do ABAP string template para campos com exit ALPHA.
"! Para exits não-ALPHA (MATN1, CUNIT, etc.), chama o FM dinamicamente.
"! Descobre automaticamente quais campos têm exit via DDIC (DD04L/DD01L).
"! Zero configuração. Funciona com qualquer estrutura BAPI.
CLASS zcl_mig_conv_engine DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_field_convexit,
        field_name TYPE fieldname,
        domname    TYPE domname,
        convexit   TYPE convexit,
        intlen     TYPE ddleng,
      END OF ty_field_convexit,
      ty_field_convexits TYPE STANDARD TABLE OF ty_field_convexit WITH KEY field_name.

    TYPES:
      BEGIN OF ty_log_entry,
        field_name   TYPE fieldname,
        convexit     TYPE convexit,
        source_value TYPE string,
        target_value TYPE string,
        success      TYPE abap_bool,
        message      TYPE string,
      END OF ty_log_entry,
      ty_log TYPE STANDARD TABLE OF ty_log_entry WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_result,
        success   TYPE abap_bool,
        converted TYPE i,
        skipped   TYPE i,
        errors    TYPE i,
        log       TYPE ty_log,
      END OF ty_result.

    METHODS:
      "! Aplica conversion exits em todos os campos da estrutura que possuem exit no domínio.
      "! Modifica a estrutura IN PLACE.
      "! @parameter iv_structure_name | Nome DDIC da estrutura (ex: BAPIMEPOHEADER)
      "! @parameter ir_data           | Referência à estrutura de dados
      "! @parameter rs_result         | Resultado com log
      convert
        IMPORTING
          iv_structure_name TYPE clike
          ir_data           TYPE REF TO data
        RETURNING
          VALUE(rs_result)  TYPE ty_result,

      "! Retorna quais campos da estrutura possuem conversion exit (introspection).
      "! @parameter iv_structure_name | Nome DDIC da estrutura
      "! @parameter rt_fields         | Campos com exit
      get_fields_with_exit
        IMPORTING
          iv_structure_name TYPE clike
        RETURNING
          VALUE(rt_fields)  TYPE ty_field_convexits.

  PRIVATE SECTION.
    " Cache por estrutura
    DATA mt_cache TYPE HASHED TABLE OF ty_field_convexits WITH UNIQUE KEY table_line.

    TYPES:
      BEGIN OF ty_struct_cache,
        structure_name TYPE string,
        fields         TYPE ty_field_convexits,
      END OF ty_struct_cache.
    DATA mt_struct_cache TYPE STANDARD TABLE OF ty_struct_cache WITH KEY structure_name.

    METHODS:
      discover_exits
        IMPORTING
          iv_structure_name     TYPE clike
        RETURNING
          VALUE(rt_fields)      TYPE ty_field_convexits,

      apply_exit
        IMPORTING
          iv_convexit    TYPE convexit
          iv_input       TYPE string
          iv_output_len  TYPE ddleng
        RETURNING
          VALUE(rv_output) TYPE string.

ENDCLASS.

CLASS zcl_mig_conv_engine IMPLEMENTATION.

  METHOD convert.
    FIELD-SYMBOLS <fs_struct> TYPE any.
    FIELD-SYMBOLS <fs_field>  TYPE any.

    ASSIGN ir_data->* TO <fs_struct>.

    DATA(lt_fields) = get_fields_with_exit( iv_structure_name ).

    LOOP AT lt_fields INTO DATA(ls_field).
      ASSIGN COMPONENT ls_field-field_name OF STRUCTURE <fs_struct> TO <fs_field>.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      DATA(lv_source) = CONV string( <fs_field> ).

      " Pular campos vazios
      IF lv_source IS INITIAL OR lv_source CO ' 0'.
        rs_result-skipped = rs_result-skipped + 1.
        CONTINUE.
      ENDIF.

      " Aplicar conversão
      DATA(lv_target) = apply_exit(
        iv_convexit   = ls_field-convexit
        iv_input      = lv_source
        iv_output_len = ls_field-intlen
      ).

      IF lv_target IS NOT INITIAL.
        <fs_field> = lv_target.
        rs_result-converted = rs_result-converted + 1.
        APPEND VALUE #(
          field_name   = ls_field-field_name
          convexit     = ls_field-convexit
          source_value = lv_source
          target_value = lv_target
          success      = abap_true
        ) TO rs_result-log.
      ELSE.
        rs_result-errors = rs_result-errors + 1.
        APPEND VALUE #(
          field_name   = ls_field-field_name
          convexit     = ls_field-convexit
          source_value = lv_source
          success      = abap_false
          message      = |Conversion failed for exit { ls_field-convexit }|
        ) TO rs_result-log.
      ENDIF.
    ENDLOOP.

    rs_result-success = xsdbool( rs_result-errors = 0 ).
  ENDMETHOD.

  METHOD get_fields_with_exit.
    " Check cache
    READ TABLE mt_struct_cache INTO DATA(ls_cache)
      WITH KEY structure_name = iv_structure_name.
    IF sy-subrc = 0.
      rt_fields = ls_cache-fields.
      RETURN.
    ENDIF.

    rt_fields = discover_exits( iv_structure_name ).

    " Cache
    APPEND VALUE #(
      structure_name = CONV #( iv_structure_name )
      fields         = rt_fields
    ) TO mt_struct_cache.
  ENDMETHOD.

  METHOD discover_exits.
    DATA(lo_struct) = CAST cl_abap_structdescr(
      cl_abap_typedescr=>describe_by_name( iv_structure_name )
    ).

    LOOP AT lo_struct->get_components( ) INTO DATA(ls_comp).
      CHECK ls_comp-type->kind = cl_abap_typedescr=>kind_elem.

      DATA(lo_elem) = CAST cl_abap_elemdescr( ls_comp-type ).
      DATA(lv_rollname) = CONV rollname( lo_elem->help_id ).
      CHECK lv_rollname IS NOT INITIAL.

      " Buscar domínio e exit
      SELECT SINGLE d~domname, d~convexit, d~leng
        FROM dd04l AS e
        INNER JOIN dd01l AS d ON d~domname = e~domname
                              AND d~as4local = 'A'
        WHERE e~rollname = @lv_rollname
          AND e~as4local = 'A'
          AND d~convexit <> ''
        INTO @DATA(ls_dom).

      IF sy-subrc = 0.
        APPEND VALUE #(
          field_name = ls_comp-name
          domname    = ls_dom-domname
          convexit   = ls_dom-convexit
          intlen     = ls_dom-leng
        ) TO rt_fields.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD apply_exit.
    " ALPHA = IN nativo do ABAP — cobre 80%+ dos casos
    IF iv_convexit = 'ALPHA'.
      rv_output = |{ iv_input ALPHA = IN WIDTH = iv_output_len }|.
      RETURN.
    ENDIF.

    " Para exits não-ALPHA (MATN1, CUNIT, ISOLA, etc.) — chamar FM
    DATA(lv_fm) = CONV rs38l_fnam( |CONVERSION_EXIT_{ iv_convexit }_INPUT| ).

    TRY.
        DATA lv_raw TYPE c LENGTH 255.

        CALL FUNCTION lv_fm
          EXPORTING
            input  = iv_input
          IMPORTING
            output = lv_raw
          EXCEPTIONS
            OTHERS = 1.

        IF sy-subrc = 0.
          rv_output = lv_raw.
        ENDIF.

      CATCH cx_root.
        CLEAR rv_output.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
