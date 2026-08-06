"! Demo: Engine genérico de regras — cobre qualquer padrão via configuração.
REPORT zmig_rule_demo.

" Estrutura simulando dados PO vindos do arquivo de migração
TYPES:
  BEGIN OF ty_po_source,
    ebeln TYPE ebeln,      " Legacy PO Number
    bstyp TYPE ebstyp,    " Document Category (input para derivação)
    bsart TYPE esart,     " Document Type (target - será derivado)
    bukrs TYPE bukrs,     " Company Code
    lifnr TYPE elifn,     " Vendor
    unsez TYPE char20,    " Our Reference
  END OF ty_po_source.

DATA ls_po TYPE ty_po_source.
ls_po-ebeln = '4500001234'.
ls_po-bstyp = 'F'.
ls_po-bsart = ' '.        " Vazio → será derivado
ls_po-bukrs = '1000'.
ls_po-lifnr = '1000'.
ls_po-unsez = ' '.        " Vazio → fallback para EBELN

" ================================================================
" Configurar regras (em produção, vem da tabela ZMIG_RULE_CFG)
" ================================================================
DATA(lo_rules) = NEW zcl_mig_rule_engine( ).

" --- Regra 1: VALUE_MAP (equivale ao CVT_BSART) ---
" Se BSTYP = 'F' → BSART = 'NB', se 'K' → 'MK', etc.
lo_rules->add_rule(
  is_rule = VALUE #(
    rule_id      = 'R001'
    bapi_name    = 'BAPI_PO_CREATE1'
    rule_type    = zcl_mig_rule_engine=>c_type_value_map
    target_field = 'BSART'
    sequence     = 1
    is_active    = abap_true
  )
  it_details = VALUE #(
    " Primeiro: indicar qual campo é o source de input
    ( rule_id = 'R001' sequence = 0 source_field = 'BSTYP' )
    " Depois: os mapeamentos de valor
    ( rule_id = 'R001' sequence = 1 source_value = 'F' target_value = 'NB' )
    ( rule_id = 'R001' sequence = 2 source_value = 'K' target_value = 'MK' )
    ( rule_id = 'R001' sequence = 3 source_value = 'L' target_value = 'LP' )
    ( rule_id = 'R001' sequence = 4 source_value = 'A' target_value = 'AN' )
  )
).

" --- Regra 2: FALLBACK (equivale ao SET_OUR_REF_2) ---
" Usa primeiro não-vazio: UNSEZ → EBELN
lo_rules->add_rule(
  is_rule = VALUE #(
    rule_id      = 'R002'
    bapi_name    = 'BAPI_PO_CREATE1'
    rule_type    = zcl_mig_rule_engine=>c_type_fallback
    target_field = 'UNSEZ'
    sequence     = 2
    is_active    = abap_true
  )
  it_details = VALUE #(
    ( rule_id = 'R002' sequence = 1 source_field = 'UNSEZ' )
    ( rule_id = 'R002' sequence = 2 source_field = 'EBELN' )
  )
).

" --- Regra 3: FIXED (exemplo: setar valor fixo) ---
" Sempre setar BUKRS = '2000' independente do input
*lo_rules->add_rule(
*  is_rule = VALUE #(
*    rule_id = 'R003' bapi_name = 'BAPI_PO_CREATE1'
*    rule_type = zcl_mig_rule_engine=>c_type_fixed
*    target_field = 'BUKRS' sequence = 3 is_active = abap_true
*  )
*  it_details = VALUE #(
*    ( rule_id = 'R003' sequence = 1 fixed_value = '2000' )
*  )
*).

" --- Regra 4: CONDITIONAL (exemplo: se BSTYP = 'F', copiar LIFNR para outro campo) ---
*lo_rules->add_rule(
*  is_rule = VALUE #(
*    rule_id = 'R004' bapi_name = 'BAPI_PO_CREATE1'
*    rule_type = zcl_mig_rule_engine=>c_type_conditional
*    target_field = 'UNSEZ' sequence = 4 is_active = abap_true
*  )
*  it_details = VALUE #(
*    ( rule_id = 'R004' sequence = 1 condition_field = 'BSTYP' condition_value = 'F'
*      source_field = 'EBELN' )
*  )
*).

" ================================================================
" Executar
" ================================================================
WRITE: / '=== Antes ==='.
WRITE: / |BSART: '{ ls_po-bsart }', UNSEZ: '{ ls_po-unsez }'|.

DATA(ls_result) = lo_rules->execute(
  iv_bapi_name = 'BAPI_PO_CREATE1'
  ir_data      = REF #( ls_po )
).

WRITE: / .
WRITE: / '=== Depois ==='.
WRITE: / |BSART: '{ ls_po-bsart }', UNSEZ: '{ ls_po-unsez }'|.
WRITE: / |Applied: { ls_result-applied }, Errors: { ls_result-errors }|.

WRITE: / .
WRITE: / '=== Log ==='.
LOOP AT ls_result-log INTO DATA(ls_log).
  WRITE: / |[{ ls_log-rule_type }] { ls_log-target_field } = '{ ls_log-result_value }' — { ls_log-message }|.
ENDLOOP.
