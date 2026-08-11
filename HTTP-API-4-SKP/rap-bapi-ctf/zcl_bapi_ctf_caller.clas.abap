CLASS zcl_bapi_ctf_caller DEFINITION
  PUBLIC
  CREATE PUBLIC.

* Same dynamic BAPI orchestrator as the base project, but using
* CALL TRANSFORMATION id + sXML reader to deserialize the worker chunk
* instead of /ui2/cl_json=>deserialize.

  PUBLIC SECTION.

    TYPES ty_fields    TYPE zcl_bapi_ctf_dispatcher=>tt_fields.
    TYPES ty_structs   TYPE zcl_bapi_ctf_dispatcher=>tt_structs.
    TYPES ty_document  TYPE zcl_bapi_ctf_dispatcher=>ty_document.
    TYPES tt_documents TYPE zcl_bapi_ctf_dispatcher=>tt_documents.

    TYPES:
      BEGIN OF ty_message,
        type    TYPE symsgty,
        id      TYPE symsgid,
        number  TYPE symsgno,
        message TYPE string,
      END OF ty_message,
      tt_messages TYPE STANDARD TABLE OF ty_message WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_doc_result,
        success  TYPE abap_bool,
        messages TYPE tt_messages,
      END OF ty_doc_result,
      tt_doc_results TYPE STANDARD TABLE OF ty_doc_result WITH EMPTY KEY.

    METHODS constructor
      IMPORTING iv_bapi_name TYPE string
      RAISING   cx_static_check.

    METHODS process_chunk_json
      IMPORTING iv_chunk          TYPE string
      RETURNING VALUE(rt_results) TYPE tt_doc_results
      RAISING   cx_static_check.

    METHODS call_document
      IMPORTING is_document      TYPE ty_document
      RETURNING VALUE(rs_result) TYPE ty_doc_result.

  PRIVATE SECTION.

    CONSTANTS c_kind_import TYPE c LENGTH 1 VALUE 'I'.
    CONSTANTS c_kind_export TYPE c LENGTH 1 VALUE 'E'.
    CONSTANTS c_kind_change TYPE c LENGTH 1 VALUE 'C'.
    CONSTANTS c_kind_table  TYPE c LENGTH 1 VALUE 'T'.

    TYPES:
      BEGIN OF ty_param_meta,
        name TYPE abap_parmname,
        kind TYPE c LENGTH 1,
        type TYPE REF TO cl_abap_datadescr,
      END OF ty_param_meta,
      tt_param_meta TYPE STANDARD TABLE OF ty_param_meta WITH KEY name.

    TYPES:
      BEGIN OF ty_rows_bucket,
        param_name TYPE abap_parmname,
        table_ref  TYPE REF TO data,
      END OF ty_rows_bucket,
      tt_rows_bucket TYPE STANDARD TABLE OF ty_rows_bucket WITH KEY param_name.

    DATA mv_bapi_name TYPE rs38l_fnam.
    DATA mt_params    TYPE tt_param_meta.

    METHODS load_interface RAISING cx_static_check.

    METHODS resolve_type_by_name
      IMPORTING iv_primary       TYPE csequence
                iv_fallback      TYPE csequence
      RETURNING VALUE(ro_result) TYPE REF TO cl_abap_datadescr.

    METHODS find_param
      IMPORTING iv_name        TYPE csequence
      RETURNING VALUE(rs_meta) TYPE ty_param_meta.

    METHODS fill_structure
      IMPORTING it_fields TYPE ty_fields
                ir_target TYPE REF TO data.

    METHODS append_row
      IMPORTING it_fields TYPE ty_fields
                ir_table  TYPE REF TO data.

    METHODS get_or_create_table_ref
      IMPORTING is_meta        TYPE ty_param_meta
      CHANGING  ct_buckets     TYPE tt_rows_bucket
      RETURNING VALUE(rr_data) TYPE REF TO data.

    METHODS commit_or_rollback
      IMPORTING iv_success TYPE abap_bool.

    METHODS extract_bapi_messages
      IMPORTING ir_return   TYPE REF TO data
      EXPORTING et_messages TYPE tt_messages
                ev_success  TYPE abap_bool.

ENDCLASS.


CLASS zcl_bapi_ctf_caller IMPLEMENTATION.

  METHOD constructor.
    mv_bapi_name = to_upper( iv_bapi_name ).

    CALL FUNCTION 'FUNCTION_EXISTS'
      EXPORTING funcname = mv_bapi_name
      EXCEPTIONS function_not_exist = 1 OTHERS = 2.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_parameter_invalid_range
        EXPORTING parameter = `bapi_name`
                  value     = CONV #( mv_bapi_name ).
    ENDIF.

    load_interface( ).
  ENDMETHOD.

  METHOD process_chunk_json.
    DATA lt_docs TYPE tt_documents.

    TRY.
        DATA(lo_reader) = cl_sxml_string_reader=>create(
                            cl_abap_codepage=>convert_to( iv_chunk ) ).
        CALL TRANSFORMATION id
          SOURCE XML lo_reader
          RESULT data = lt_docs.
      CATCH cx_transformation_error INTO DATA(lx_err).
        RAISE EXCEPTION TYPE cx_parameter_invalid_range
          EXPORTING previous  = lx_err
                    parameter = `chunk`
                    value     = CONV #( lx_err->get_text( ) ).
    ENDTRY.

    LOOP AT lt_docs INTO DATA(ls_doc).
      APPEND call_document( ls_doc ) TO rt_results.
    ENDLOOP.
  ENDMETHOD.

  METHOD load_interface.
    DATA: lt_import TYPE STANDARD TABLE OF rsimp,
          lt_export TYPE STANDARD TABLE OF rsexp,
          lt_change TYPE STANDARD TABLE OF rscha,
          lt_tables TYPE STANDARD TABLE OF rstbl,
          lt_except TYPE STANDARD TABLE OF rsexc.

    CALL FUNCTION 'FUNCTION_IMPORT_INTERFACE'
      EXPORTING funcname = mv_bapi_name
      TABLES    exception_list = lt_except
                export_parameter = lt_export
                import_parameter = lt_import
                changing_parameter = lt_change
                tables_parameter = lt_tables
      EXCEPTIONS error_message = 1 function_not_found = 2 invalid_name = 3 OTHERS = 4.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_parameter_invalid_range
        EXPORTING parameter = `bapi_name`
                  value     = CONV #( mv_bapi_name ).
    ENDIF.

    LOOP AT lt_import INTO DATA(ls_imp).
      DATA(lo_type_i) = resolve_type_by_name( iv_primary = ls_imp-typ iv_fallback = ls_imp-dbfield ).
      IF lo_type_i IS BOUND.
        APPEND VALUE ty_param_meta( name = to_upper( ls_imp-parameter )
                                    kind = c_kind_import type = lo_type_i ) TO mt_params.
      ENDIF.
    ENDLOOP.
    LOOP AT lt_change INTO DATA(ls_chg).
      DATA(lo_type_c) = resolve_type_by_name( iv_primary = ls_chg-typ iv_fallback = ls_chg-dbfield ).
      IF lo_type_c IS BOUND.
        APPEND VALUE ty_param_meta( name = to_upper( ls_chg-parameter )
                                    kind = c_kind_change type = lo_type_c ) TO mt_params.
      ENDIF.
    ENDLOOP.
    LOOP AT lt_tables INTO DATA(ls_tab).
      DATA(lo_type_t) = resolve_type_by_name( iv_primary = ls_tab-dbstruct iv_fallback = ls_tab-typ ).
      IF lo_type_t IS BOUND.
        APPEND VALUE ty_param_meta( name = to_upper( ls_tab-parameter )
                                    kind = c_kind_table type = lo_type_t ) TO mt_params.
      ENDIF.
    ENDLOOP.
    LOOP AT lt_export INTO DATA(ls_exp).
      DATA(lo_type_e) = resolve_type_by_name( iv_primary = ls_exp-typ iv_fallback = ls_exp-dbfield ).
      IF lo_type_e IS BOUND.
        APPEND VALUE ty_param_meta( name = to_upper( ls_exp-parameter )
                                    kind = c_kind_export type = lo_type_e ) TO mt_params.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD resolve_type_by_name.
    TRY.
        IF iv_primary IS NOT INITIAL.
          ro_result ?= cl_abap_typedescr=>describe_by_name( iv_primary ).
          RETURN.
        ENDIF.
      CATCH cx_root ##NO_HANDLER.
    ENDTRY.
    TRY.
        IF iv_fallback IS NOT INITIAL.
          ro_result ?= cl_abap_typedescr=>describe_by_name( iv_fallback ).
        ENDIF.
      CATCH cx_root ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD find_param.
    DATA(lv_name) = CONV abap_parmname( to_upper( iv_name ) ).
    READ TABLE mt_params INTO rs_meta WITH KEY name = lv_name.
    IF sy-subrc <> 0.
      CLEAR rs_meta.
    ENDIF.
  ENDMETHOD.

  METHOD call_document.
    DATA lt_ptab   TYPE abap_func_parmbind_tab.
    DATA lt_etab   TYPE abap_func_excpbind_tab.
    DATA lt_bucket TYPE tt_rows_bucket.
    DATA lr_data   TYPE REF TO data.

    LOOP AT is_document-heders_values INTO DATA(ls_hdr).
      DATA(ls_meta_h) = find_param( ls_hdr-value ).
      IF ls_meta_h-name IS INITIAL OR ls_meta_h-type IS NOT BOUND.
        CONTINUE.
      ENDIF.
      IF ls_meta_h-type->kind <> cl_abap_typedescr=>kind_struct
         AND ls_meta_h-type->kind <> cl_abap_typedescr=>kind_elem.
        CONTINUE.
      ENDIF.
      CREATE DATA lr_data TYPE HANDLE ls_meta_h-type.
      fill_structure( it_fields = ls_hdr-fields ir_target = lr_data ).
      DATA lv_kind_p TYPE c LENGTH 1.
      lv_kind_p = SWITCH #( ls_meta_h-kind
                              WHEN c_kind_import THEN abap_func_exporting
                              WHEN c_kind_change THEN abap_func_changing
                              ELSE abap_func_exporting ).
      INSERT VALUE #( name = ls_meta_h-name kind = lv_kind_p value = lr_data ) INTO TABLE lt_ptab.
    ENDLOOP.

    LOOP AT is_document-items_values INTO DATA(ls_itm).
      DATA(ls_meta_t) = find_param( ls_itm-value ).
      IF ls_meta_t-name IS INITIAL OR ls_meta_t-type IS NOT BOUND OR ls_meta_t-kind <> c_kind_table.
        CONTINUE.
      ENDIF.
      DATA(lr_tab) = get_or_create_table_ref( EXPORTING is_meta = ls_meta_t
                                              CHANGING  ct_buckets = lt_bucket ).
      append_row( it_fields = ls_itm-fields ir_table = lr_tab ).
    ENDLOOP.

    LOOP AT lt_bucket INTO DATA(ls_bucket).
      INSERT VALUE #( name = ls_bucket-param_name kind = abap_func_tables value = ls_bucket-table_ref ) INTO TABLE lt_ptab.
    ENDLOOP.

    DATA lr_return TYPE REF TO data.
    DATA(ls_meta_ret) = find_param( `RETURN` ).
    IF ls_meta_ret-name IS NOT INITIAL AND ls_meta_ret-type IS BOUND.
      CREATE DATA lr_return TYPE HANDLE ls_meta_ret-type.
      IF ls_meta_ret-kind = c_kind_table.
        INSERT VALUE #( name = ls_meta_ret-name kind = abap_func_tables value = lr_return ) INTO TABLE lt_ptab.
      ELSEIF ls_meta_ret-kind = c_kind_export.
        INSERT VALUE #( name = ls_meta_ret-name kind = abap_func_importing value = lr_return ) INTO TABLE lt_ptab.
      ENDIF.
    ENDIF.

    TRY.
        CALL FUNCTION mv_bapi_name PARAMETER-TABLE lt_ptab EXCEPTION-TABLE lt_etab.
      CATCH cx_root INTO DATA(lx_call).
        rs_result-success = abap_false.
        APPEND VALUE ty_message( type = 'A' message = lx_call->get_text( ) ) TO rs_result-messages.
        commit_or_rollback( abap_false ).
        RETURN.
    ENDTRY.

    extract_bapi_messages( EXPORTING ir_return = lr_return
                           IMPORTING et_messages = rs_result-messages
                                     ev_success  = rs_result-success ).
    commit_or_rollback( rs_result-success ).
  ENDMETHOD.

  METHOD get_or_create_table_ref.
    READ TABLE ct_buckets WITH KEY param_name = is_meta-name ASSIGNING FIELD-SYMBOL(<ls_b>).
    IF sy-subrc = 0.
      rr_data = <ls_b>-table_ref.
      RETURN.
    ENDIF.
    DATA lo_line TYPE REF TO cl_abap_structdescr.
    IF is_meta-type->kind = cl_abap_typedescr=>kind_struct.
      lo_line ?= is_meta-type.
    ELSE.
      RETURN.
    ENDIF.
    DATA(lo_tab) = cl_abap_tabledescr=>create( p_line_type = lo_line ).
    CREATE DATA rr_data TYPE HANDLE lo_tab.
    APPEND VALUE ty_rows_bucket( param_name = is_meta-name table_ref = rr_data ) TO ct_buckets.
  ENDMETHOD.

  METHOD fill_structure.
    ASSIGN ir_target->* TO FIELD-SYMBOL(<fs_target>).
    IF sy-subrc <> 0 OR <fs_target> IS NOT ASSIGNED.
      RETURN.
    ENDIF.
    LOOP AT it_fields INTO DATA(ls_field).
      ASSIGN COMPONENT to_upper( ls_field-name ) OF STRUCTURE <fs_target> TO FIELD-SYMBOL(<fs_comp>).
      IF sy-subrc = 0.
        TRY.
            <fs_comp> = ls_field-value.
          CATCH cx_root ##NO_HANDLER.
        ENDTRY.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD append_row.
    ASSIGN ir_table->* TO FIELD-SYMBOL(<ft_table>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    DATA lr_row TYPE REF TO data.
    DATA(lo_tab)  = CAST cl_abap_tabledescr( cl_abap_typedescr=>describe_by_data( <ft_table> ) ).
    DATA(lo_line) = lo_tab->get_table_line_type( ).
    CREATE DATA lr_row TYPE HANDLE lo_line.
    fill_structure( it_fields = it_fields ir_target = lr_row ).
    ASSIGN lr_row->* TO FIELD-SYMBOL(<fs_row>).
    INSERT <fs_row> INTO TABLE <ft_table>.
  ENDMETHOD.

  METHOD extract_bapi_messages.
    CLEAR: et_messages, ev_success.
    ev_success = abap_true.
    IF ir_return IS NOT BOUND.
      RETURN.
    ENDIF.
    ASSIGN ir_return->* TO FIELD-SYMBOL(<fs_return>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    DATA(lo_desc) = cl_abap_typedescr=>describe_by_data( <fs_return> ).
    IF lo_desc->kind = cl_abap_typedescr=>kind_table.
      LOOP AT <fs_return> ASSIGNING FIELD-SYMBOL(<fs_row>).
        DATA ls_msg TYPE ty_message.
        CLEAR ls_msg.
        ASSIGN COMPONENT 'TYPE'    OF STRUCTURE <fs_row> TO FIELD-SYMBOL(<fs_v>).
        IF sy-subrc = 0. ls_msg-type = <fs_v>. ENDIF.
        ASSIGN COMPONENT 'ID'      OF STRUCTURE <fs_row> TO <fs_v>.
        IF sy-subrc = 0. ls_msg-id = <fs_v>. ENDIF.
        ASSIGN COMPONENT 'NUMBER'  OF STRUCTURE <fs_row> TO <fs_v>.
        IF sy-subrc = 0. ls_msg-number = <fs_v>. ENDIF.
        ASSIGN COMPONENT 'MESSAGE' OF STRUCTURE <fs_row> TO <fs_v>.
        IF sy-subrc = 0. ls_msg-message = <fs_v>. ENDIF.
        APPEND ls_msg TO et_messages.
        IF ls_msg-type = 'E' OR ls_msg-type = 'A' OR ls_msg-type = 'X'.
          ev_success = abap_false.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD commit_or_rollback.
    IF iv_success = abap_true.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = 'X'.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
