CLASS zcl_http_bapi_meta_builder DEFINITION
  PUBLIC
  CREATE PUBLIC.

* Introspects a classic BAPI (FUNCTION_IMPORT_INTERFACE + DDIF_FIELDINFO_GET)
* and returns the nested JSON in the shape of metadata-ex.json.
*
* This class is intentionally self-contained (no CDS, no RAP): the HTTP
* handler zcl_http_bapi_meta calls build_json( ) and writes the string
* straight into the response body.

  PUBLIC SECTION.

    METHODS build_json
      IMPORTING iv_bapi_name   TYPE csequence
      RETURNING VALUE(rv_json) TYPE string
      RAISING   cx_static_check.

  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_field,
        name TYPE c LENGTH 30,
        type TYPE string,
      END OF ty_field,
      tt_field TYPE STANDARD TABLE OF ty_field WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_struct,
        param_name TYPE c LENGTH 30,
        fields     TYPE tt_field,
      END OF ty_struct,
      tt_struct TYPE STANDARD TABLE OF ty_struct WITH EMPTY KEY.

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

    METHODS build_struct
      IMPORTING iv_param      TYPE csequence
                iv_type       TYPE csequence
      RETURNING VALUE(rs_out) TYPE ty_struct.

    METHODS resolve_type_name
      IMPORTING iv_primary          TYPE csequence
                iv_fallback         TYPE csequence
      RETURNING VALUE(rv_type_name) TYPE string.

    METHODS map_type
      IMPORTING is_dfies       TYPE dfies
      RETURNING VALUE(rv_type) TYPE string.

    METHODS structs_to_json
      IMPORTING it_structs     TYPE tt_struct
      RETURNING VALUE(rv_json) TYPE string.

    METHODS json_escape
      IMPORTING iv_in         TYPE csequence
      RETURNING VALUE(rv_out) TYPE string.

ENDCLASS.


CLASS zcl_http_bapi_meta_builder IMPLEMENTATION.

  METHOD build_json.
    DATA lt_imports TYPE tt_struct_ref.
    DATA lt_tables  TYPE tt_struct_ref.
    DATA lt_headers TYPE tt_struct.
    DATA lt_items   TYPE tt_struct.

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

    LOOP AT lt_imports INTO DATA(ls_imp).
      APPEND build_struct( iv_param = ls_imp-param_name
                           iv_type  = ls_imp-type_name ) TO lt_headers.
    ENDLOOP.

    LOOP AT lt_tables INTO DATA(ls_tab).
      APPEND build_struct( iv_param = ls_tab-param_name
                           iv_type  = ls_tab-type_name ) TO lt_items.
    ENDLOOP.

    rv_json = |\{"bapi_name":"{ json_escape( lv_bapi ) }",|
           && |"documents":[\{"headers_values":{ structs_to_json( lt_headers ) },|
           && |"items_values":{ structs_to_json( lt_items ) }\}]\}|.
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
      APPEND VALUE #( name = ls_f-fieldname
                      type = map_type( ls_f ) ) TO rs_out-fields.
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

  METHOD structs_to_json.
    rv_json = `[`.
    DATA(lv_first_s) = abap_true.
    LOOP AT it_structs ASSIGNING FIELD-SYMBOL(<s>).
      IF lv_first_s = abap_false.
        rv_json = rv_json && `,`.
      ENDIF.
      lv_first_s = abap_false.

      rv_json = rv_json && |\{"value":"{ json_escape( <s>-param_name ) }","fields":[|.

      DATA(lv_first_f) = abap_true.
      LOOP AT <s>-fields ASSIGNING FIELD-SYMBOL(<f>).
        IF lv_first_f = abap_false.
          rv_json = rv_json && `,`.
        ENDIF.
        lv_first_f = abap_false.
        rv_json = rv_json &&
          |\{"name":"{ json_escape( <f>-name ) }","type":"{ json_escape( <f>-type ) }"\}|.
      ENDLOOP.

      rv_json = rv_json && `]}`.
    ENDLOOP.
    rv_json = rv_json && `]`.
  ENDMETHOD.

  METHOD json_escape.
    rv_out = escape( val    = iv_in
                     format = cl_abap_format=>e_json_string ).
  ENDMETHOD.

ENDCLASS.
