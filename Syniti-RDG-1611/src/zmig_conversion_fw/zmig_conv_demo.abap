"! Demo: Conversão automática de campos com ALPHA = IN e exits do domínio.
REPORT zmig_conv_demo.

DATA(lo_engine) = NEW zcl_mig_conv_engine( ).

" === BAPI_PO_CREATE1 ===
DATA ls_poheader TYPE bapimepoheader.
ls_poheader-vendor    = '1000'.       " ALPHA = IN → '0000001000'
ls_poheader-comp_code = '100'.        " ALPHA = IN → '0100'
ls_poheader-purch_org = '100'.        " ALPHA = IN → '0100'

DATA(ls_r1) = lo_engine->convert(
  iv_structure_name = 'BAPIMEPOHEADER'
  ir_data           = REF #( ls_poheader )
).
WRITE: / |PO Header - Vendor: { ls_poheader-vendor }, Converted: { ls_r1-converted }|.

" === BAPI_ACC_DOCUMENT_POST ===
DATA ls_glaccount TYPE bapiacgl09.
ls_glaccount-gl_account = '400000'.   " ALPHA = IN → '0000400000'
ls_glaccount-cost_center = '100'.     " ALPHA = IN → '0000000100'

DATA(ls_r2) = lo_engine->convert(
  iv_structure_name = 'BAPIACGL09'
  ir_data           = REF #( ls_glaccount )
).
WRITE: / |FI GL - Account: { ls_glaccount-gl_account }, Cost Center: { ls_glaccount-cost_center }|.

" === BAPI_SALESORDER_CREATEFROMDAT2 ===
DATA ls_soitem TYPE bapisditm.
ls_soitem-material = 'MAT001'.        " MATN1 exit (não-ALPHA, chama FM)

DATA(ls_r3) = lo_engine->convert(
  iv_structure_name = 'BAPISDITM'
  ir_data           = REF #( ls_soitem )
).
WRITE: / |SO Item - Material: { ls_soitem-material }|.

" === Introspection ===
WRITE: / .
WRITE: / |=== Campos com exit em BAPIMEPOHEADER ===|.
DATA(lt_fields) = lo_engine->get_fields_with_exit( 'BAPIMEPOHEADER' ).
LOOP AT lt_fields INTO DATA(ls_f).
  WRITE: / |  { ls_f-field_name WIDTH = 20 } | { ls_f-domname WIDTH = 12 } | { ls_f-convexit }|.
ENDLOOP.
