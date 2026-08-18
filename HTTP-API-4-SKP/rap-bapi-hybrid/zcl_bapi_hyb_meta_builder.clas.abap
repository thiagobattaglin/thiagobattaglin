CLASS zcl_bapi_hyb_meta_builder DEFINITION
  PUBLIC
  CREATE PUBLIC.

* Introspects a classic BAPI (FUNCTION_IMPORT_INTERFACE + DDIF_FIELDINFO_GET)
* and returns a flat metadata table with one row per DDIC field.
*
* Row shape (matches ZD_BAPI_HYB_META abstract entity):
*   BapiName, BapiSection ('H' | 'I'), ParamName, FieldName,
*   DocumentIdx, ParamOrder, FieldOrder, FieldType
*
* BapiSection:
*   'H' -> IMPORT parameters typed against a DDIC structure (heders_values)
*   'I' -> TABLES parameters (line type = DDIC structure)   (items_values)
*
* Clean Core caveat: FUNCTION_IMPORT_INTERFACE and DDIF_FIELDINFO_GET are
* not released for ABAP Cloud. Intended for on-premise / embedded Steampunk
* / private cloud, aligned with zcl_bapi_hyb_caller.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_row,
        bapi_name    TYPE c LENGTH 30,
        section      TYPE c LENGTH 1,
        param_name   TYPE c LENGTH 30,
        field_name   TYPE c LENGTH 30,
        document_idx TYPE i,
        param_order  TYPE i,
        field_order  TYPE i,
        field_type   TYPE c LENGTH 30,
      END OF ty_row,
      tt_rows TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    CONSTANTS:
      c_section_header TYPE c LENGTH 1 VALUE 'H',
      c_section_item   TYPE c LENGTH 1 VALUE 'I'.

    METHODS build
      IMPORTING iv_bapi_name   TYPE csequence
      RETURNING VALUE(rt_rows) TYPE tt_rows
      RAISING   cx_static_check.

  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_struct_ref,
        param_name TYPE string,
        type_name  TYPE string,
      END OF ty_struct_ref,
      tt_struct_ref TYPE STANDARD TABLE OF ty_struct_ref WITH EMPTY KEY.

    METHODS collect_params
      IMPORTING iv_bapi_name TYPE rs38l_fnam
      EXPORTING et_imports   TYPE tt_struct_ref
                et_tables    TYPE tt_struct_ref
      RAISING   cx_static_check.

    METHODS append_struct_rows
      IMPORTING iv_bapi_name TYPE csequence
                iv_section   TYPE c
                iv_param     TYPE csequence
                iv_type      TYPE csequence
                iv_param_ord TYPE i
      CHANGING  ct_rows      TYPE tt_rows.

    METHODS map_type
      IMPORTING is_dfies       TYPE dfies
      RETURNING VALUE(rv_type) TYPE string.

    METHODS resolve_type_name
      IMPORTING iv_primary          TYPE csequence
                iv_fallback         TYPE csequence
      RETURNING VALUE(rv_type_name) TYPE string.

ENDCLASS.


CLASS zcl_bapi_hyb_meta_builder IMPLEMENTATION.

  METHOD build.
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

    collect_params(
      EXPORTING iv_bapi_name = lv_bapi
      IMPORTING et_imports   = lt_imports
                et_tables    = lt_tables ).

    DATA(lv_ord) = 0.
    LOOP AT lt_imports INTO DATA(ls_imp).
      lv_ord = lv_ord + 1.
      append_struct_rows(
        EXPORTING iv_bapi_name = lv_bapi
                  iv_section   = c_section_header
                  iv_param     = ls_imp-param_name
                  iv_type      = ls_imp-type_name
                  iv_param_ord = lv_ord
        CHANGING  ct_rows      = rt_rows ).
    ENDLOOP.

    lv_ord = 0.
    LOOP AT lt_tables INTO DATA(ls_tab).
      lv_ord = lv_ord + 1.
      append_struct_rows(
        EXPORTING iv_bapi_name = lv_bapi
                  iv_section   = c_section_item
                  iv_param     = ls_tab-param_name
                  iv_type      = ls_tab-type_name
                  iv_param_ord = lv_ord
        CHANGING  ct_rows      = rt_rows ).
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

  METHOD append_struct_rows.
    DATA lt_fields TYPE STANDARD TABLE OF dfies.

    CALL FUNCTION 'DDIF_FIELDINFO_GET'
      EXPORTING  tabname        = CONV ddobjname( iv_type )
      TABLES     dfies_tab      = lt_fields
      EXCEPTIONS not_found      = 1
                 internal_error = 2
                 OTHERS         = 3.
    IF sy-subrc <> 0 OR lt_fields IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lv_ord) = 0.
    LOOP AT lt_fields INTO DATA(ls_f).
      lv_ord = lv_ord + 1.
      APPEND VALUE #(
        bapi_name    = iv_bapi_name
        section      = iv_section
        param_name   = iv_param
        field_name   = ls_f-fieldname
        document_idx = 1
        param_order  = iv_param_ord
        field_order  = lv_ord
        field_type   = map_type( ls_f ) ) TO ct_rows.
    ENDLOOP.
  ENDMETHOD.

  METHOD map_type.
    DATA(lv_dt)  = to_lower( CONV string( is_dfies-datatype ) ).
    DATA(lv_len) = CONV i( is_dfies-leng ).
    DATA(lv_dec) = CONV i( is_dfies-decimals ).

    CASE is_dfies-datatype.
      WHEN 'STRING' OR 'RAWSTRING' OR 'SSTRING'
        OR 'DATS'   OR 'TIMS'      OR 'FLTP'
        OR 'INT1'   OR 'INT2'      OR 'INT4' OR 'INT8'
        OR 'CLNT'   OR 'LANG'      OR 'UTCLONG'.
        rv_type = lv_dt.

      WHEN 'DEC' OR 'QUAN' OR 'CURR'.
        rv_type = COND #( WHEN lv_dec > 0
                          THEN |{ lv_dt }{ lv_len }.{ lv_dec }|
                          ELSE |{ lv_dt }{ lv_len }| ).

      WHEN OTHERS.
        rv_type = COND #( WHEN lv_len > 0
                          THEN |{ lv_dt }{ lv_len }|
                          ELSE lv_dt ).
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
