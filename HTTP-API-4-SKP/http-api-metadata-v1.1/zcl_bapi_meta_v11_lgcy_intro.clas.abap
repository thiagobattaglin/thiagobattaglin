CLASS zcl_bapi_meta_v11_lgcy_intro DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

* ============================================================================
* LEGACY ADAPTER \u2014 NAO Clean Core.
* ============================================================================
* Implementa zif_bapi_meta_v11_introspector usando APIs cl\u00e1ssicas do DDIC
* que NAO est\u00e3o released em ABAP Cloud:
*   - FUNCTION_IMPORT_INTERFACE
*   - DDIF_FIELDINFO_GET
*
* Destinado a on-premise, embedded Steampunk ou private cloud.
* Para ABAP Cloud puro, substituir por uma implementa\u00e7\u00e3o baseada em:
*   - Whitelist de BAPIs released (JSON/tabela de config)
*   - cl_abap_typedescr=>describe_by_name (released) para os types
*   - xco_cp_abap_dictionary para introspec\u00e7\u00e3o adicional
* ============================================================================

  PUBLIC SECTION.
    INTERFACES zif_bapi_meta_v11_introspector.

  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_struct_ref,
        param_name TYPE string,
        type_name  TYPE string,
      END OF ty_struct_ref,
      tt_struct_ref TYPE STANDARD TABLE OF ty_struct_ref WITH DEFAULT KEY.

    METHODS collect_params
      IMPORTING iv_bapi_name TYPE rs38l_fnam
      EXPORTING et_imports   TYPE tt_struct_ref
                et_tables    TYPE tt_struct_ref
      RAISING   cx_static_check.

    METHODS build_struct
      IMPORTING iv_param      TYPE csequence
                iv_type       TYPE csequence
                iv_json_name  TYPE csequence
      RETURNING VALUE(rs_out) TYPE zif_bapi_meta_v11_introspector=>ty_struct_meta.

    METHODS resolve_type_name
      IMPORTING iv_primary          TYPE csequence
                iv_fallback         TYPE csequence
      RETURNING VALUE(rv_type_name) TYPE string.

ENDCLASS.


CLASS zcl_bapi_meta_v11_lgcy_intro IMPLEMENTATION.

  METHOD zif_bapi_meta_v11_introspector~describe.

    DATA lt_imports TYPE tt_struct_ref.
    DATA lt_tables  TYPE tt_struct_ref.

    DATA(lv_bapi) = CONV rs38l_fnam( to_upper( iv_bapi_name ) ).

    IF lv_bapi IS INITIAL.
      RAISE EXCEPTION TYPE cx_parameter_invalid_range
        EXPORTING parameter = `bapi_name`
                  value     = ``.
    ENDIF.

    CALL FUNCTION 'FUNCTION_EXISTS'
      EXPORTING funcname = lv_bapi
      EXCEPTIONS function_not_exist = 1 OTHERS = 2.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_parameter_invalid_range
        EXPORTING parameter = `bapi_name`
                  value     = CONV #( lv_bapi ).
    ENDIF.

    rs_meta-bapi_name = lv_bapi.

    collect_params(
      EXPORTING iv_bapi_name = lv_bapi
      IMPORTING et_imports   = lt_imports
                et_tables    = lt_tables ).

    LOOP AT lt_imports INTO DATA(ls_imp).
      APPEND build_struct( iv_param     = ls_imp-param_name
                           iv_type      = ls_imp-type_name
                           iv_json_name = `structure` )
             TO rs_meta-headers.
    ENDLOOP.

    LOOP AT lt_tables INTO DATA(ls_tab).
      APPEND build_struct( iv_param     = ls_tab-param_name
                           iv_type      = ls_tab-type_name
                           iv_json_name = `table` )
             TO rs_meta-items.
    ENDLOOP.

  ENDMETHOD.

  METHOD collect_params.
    DATA: lt_import TYPE STANDARD TABLE OF rsimp,
          lt_export TYPE STANDARD TABLE OF rsexp,
          lt_change TYPE STANDARD TABLE OF rscha,
          lt_tables TYPE STANDARD TABLE OF rstbl,
          lt_except TYPE STANDARD TABLE OF rsexc.

    CALL FUNCTION 'FUNCTION_IMPORT_INTERFACE'
      EXPORTING  funcname           = iv_bapi_name
      TABLES     exception_list     = lt_except
                 export_parameter   = lt_export
                 import_parameter   = lt_import
                 changing_parameter = lt_change
                 tables_parameter   = lt_tables
      EXCEPTIONS error_message      = 1
                 function_not_found = 2
                 invalid_name       = 3
                 OTHERS             = 4.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_parameter_invalid_range
        EXPORTING parameter = `bapi_name`
                  value     = CONV #( iv_bapi_name ).
    ENDIF.

    LOOP AT lt_import INTO DATA(ls_imp).
      DATA(lv_type_i) = resolve_type_name( iv_primary  = ls_imp-typ
                                           iv_fallback = ls_imp-dbfield ).
      IF lv_type_i IS NOT INITIAL.
        APPEND VALUE #( param_name = to_upper( ls_imp-parameter )
                        type_name  = lv_type_i ) TO et_imports.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_tables INTO DATA(ls_tab).
      DATA(lv_type_t) = resolve_type_name( iv_primary  = ls_tab-dbstruct
                                           iv_fallback = ls_tab-typ ).
      IF lv_type_t IS NOT INITIAL.
        APPEND VALUE #( param_name = to_upper( ls_tab-parameter )
                        type_name  = lv_type_t ) TO et_tables.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD resolve_type_name.
    IF iv_primary IS NOT INITIAL.
      rv_type_name = to_upper( iv_primary ).
      RETURN.
    ENDIF.
    IF iv_fallback IS NOT INITIAL.
      rv_type_name = to_upper( iv_fallback ).
    ENDIF.
  ENDMETHOD.

  METHOD build_struct.
    DATA lt_fields TYPE STANDARD TABLE OF dfies.

    rs_out-param_name = iv_param.
    rs_out-json_name  = iv_json_name.

    CALL FUNCTION 'DDIF_FIELDINFO_GET'
      EXPORTING  tabname        = CONV ddobjname( iv_type )
      TABLES     dfies_tab      = lt_fields
      EXCEPTIONS not_found      = 1
                 internal_error = 2
                 OTHERS         = 3.
    IF sy-subrc <> 0 OR lt_fields IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT lt_fields INTO DATA(ls_f).
      APPEND VALUE #( name    = ls_f-fieldname
                      type    = to_lower( CONV string( ls_f-datatype ) )
                      length  = CONV i( ls_f-leng )
                      size    = CONV i( ls_f-leng )
                      decimal = CONV i( ls_f-decimals ) ) TO rs_out-fields.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
