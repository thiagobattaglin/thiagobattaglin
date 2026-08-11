CLASS zcl_bapi_ctf_dispatcher DEFINITION
  PUBLIC
  CREATE PUBLIC.

* CTF dispatcher: replaces /ui2/cl_json=>deserialize by a JSON-to-ABAP
* pipeline based on cl_sxml_string_reader + CALL TRANSFORMATION id, which
* is typically 3-10x faster and consumes far less memory for large arrays.
*
* Split is still document-based (as in the base project), but chunks are
* re-serialized via CALL TRANSFORMATION id (writer side of sXML) instead
* of /ui2/cl_json=>serialize.

  PUBLIC SECTION.

    CONSTANTS c_default_workers TYPE i      VALUE 4.
    CONSTANTS c_default_rows    TYPE i      VALUE 5000.
    CONSTANTS c_mode_async      TYPE string VALUE 'async'.
    CONSTANTS c_mode_sync       TYPE string VALUE 'sync'.

    TYPES:
      BEGIN OF ty_field,
        name  TYPE string,
        value TYPE string,
      END OF ty_field,
      tt_fields TYPE STANDARD TABLE OF ty_field WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_struct,
        value  TYPE string,
        fields TYPE tt_fields,
      END OF ty_struct,
      tt_structs TYPE STANDARD TABLE OF ty_struct WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_document,
        heders_values TYPE tt_structs,
        items_values  TYPE tt_structs,
      END OF ty_document,
      tt_documents TYPE STANDARD TABLE OF ty_document WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_request,
        mode           TYPE string,
        bapi_name      TYPE string,
        worker_threads TYPE i,
        worker_rows    TYPE i,
        heders_values  TYPE tt_structs,
        items_values   TYPE tt_structs,
        documents      TYPE tt_documents,
      END OF ty_request.

    TYPES:
      BEGIN OF ty_outcome,
        bapi_name TYPE string,
        accepted  TYPE i,
        workers   TYPE i,
        mode      TYPE string,
      END OF ty_outcome.

    METHODS dispatch
      IMPORTING iv_json           TYPE string
      RETURNING VALUE(rs_outcome) TYPE ty_outcome
      RAISING   cx_static_check.

    "! Deserialize via CALL TRANSFORMATION id + sXML reader.
    METHODS parse_request
      IMPORTING iv_json           TYPE string
      RETURNING VALUE(rs_request) TYPE ty_request
      RAISING   cx_static_check.

    METHODS calculate_workers
      IMPORTING iv_docs_total    TYPE i
                iv_worker_rows   TYPE i
                iv_worker_max    TYPE i
      RETURNING VALUE(rv_result) TYPE i.

    METHODS split_documents
      IMPORTING it_documents     TYPE tt_documents
                iv_workers       TYPE i
      RETURNING VALUE(rt_chunks) TYPE string_table.

    METHODS normalize_positive
      IMPORTING iv_value         TYPE i
                iv_default       TYPE i
      RETURNING VALUE(rv_result) TYPE i.

    METHODS documents_from_request
      IMPORTING is_request     TYPE ty_request
      RETURNING VALUE(rt_docs) TYPE tt_documents.

  PROTECTED SECTION.

    METHODS dispatch_chunks
      IMPORTING iv_bapi_name TYPE string
                iv_mode      TYPE string
                it_chunks    TYPE string_table.

  PRIVATE SECTION.

    "! Deserialize a JSON string of any ABAP-compatible shape using sXML
    "! + CALL TRANSFORMATION id. The reader consumes tokens once (single
    "! pass, no RTTI-per-node overhead like /ui2/cl_json).
    METHODS json_to_data
      IMPORTING iv_json TYPE string
      CHANGING  cs_data TYPE any
      RAISING   cx_transformation_error.

    METHODS data_to_json
      IMPORTING is_data        TYPE any
      RETURNING VALUE(rv_json) TYPE string
      RAISING   cx_transformation_error.

ENDCLASS.


CLASS zcl_bapi_ctf_dispatcher IMPLEMENTATION.

  METHOD dispatch.
    DATA(ls_request) = parse_request( iv_json ).

    IF ls_request-bapi_name IS INITIAL.
      RAISE EXCEPTION TYPE cx_parameter_invalid_range
        EXPORTING parameter = `bapi_name`
                  value     = `(empty)`.
    ENDIF.

    DATA(lt_docs)  = documents_from_request( ls_request ).
    DATA(lv_total) = lines( lt_docs ).

    DATA(lv_rows) = normalize_positive( iv_value   = ls_request-worker_rows
                                        iv_default = c_default_rows ).
    DATA(lv_max)  = normalize_positive( iv_value   = ls_request-worker_threads
                                        iv_default = c_default_workers ).

    DATA(lv_workers) = calculate_workers( iv_docs_total  = lv_total
                                          iv_worker_rows = lv_rows
                                          iv_worker_max  = lv_max ).

    DATA(lt_chunks) = split_documents( it_documents = lt_docs
                                       iv_workers   = lv_workers ).

    DATA(lv_mode) = COND string( WHEN ls_request-mode = c_mode_sync THEN c_mode_sync
                                 ELSE c_mode_async ).

    dispatch_chunks( iv_bapi_name = ls_request-bapi_name
                     iv_mode      = lv_mode
                     it_chunks    = lt_chunks ).

    rs_outcome = VALUE #( bapi_name = ls_request-bapi_name
                          accepted  = lv_total
                          workers   = lv_workers
                          mode      = lv_mode ).
  ENDMETHOD.

  METHOD parse_request.
    TRY.
        json_to_data( EXPORTING iv_json = iv_json
                      CHANGING  cs_data = rs_request ).
      CATCH cx_transformation_error INTO DATA(lx_err).
        RAISE EXCEPTION TYPE cx_parameter_invalid_range
          EXPORTING previous  = lx_err
                    parameter = `payload`
                    value     = CONV #( lx_err->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD json_to_data.
* sXML reader in JSON mode is written in the kernel; feeds CALL
* TRANSFORMATION id which maps <asx:values> directly to ABAP structures.
    DATA(lo_reader) = cl_sxml_string_reader=>create(
                        cl_abap_codepage=>convert_to( iv_json ) ).

    CALL TRANSFORMATION id
      SOURCE XML lo_reader
      RESULT data = cs_data.
  ENDMETHOD.

  METHOD data_to_json.
    DATA lo_writer TYPE REF TO cl_sxml_string_writer.
    lo_writer = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

    CALL TRANSFORMATION id
      SOURCE data = is_data
      RESULT XML lo_writer.

    rv_json = cl_abap_codepage=>convert_from( lo_writer->get_output( ) ).
  ENDMETHOD.

  METHOD normalize_positive.
    rv_result = COND i( WHEN iv_value > 0 THEN iv_value ELSE iv_default ).
  ENDMETHOD.

  METHOD calculate_workers.
    IF iv_docs_total <= 0 OR iv_worker_rows <= 0 OR iv_worker_max <= 0.
      rv_result = 0.
      RETURN.
    ENDIF.
    DATA(lv_needed) = ( iv_docs_total + iv_worker_rows - 1 ) DIV iv_worker_rows.
    rv_result = COND i( WHEN lv_needed < iv_worker_max THEN lv_needed
                        ELSE iv_worker_max ).
  ENDMETHOD.

  METHOD split_documents.
    DATA lt_chunk TYPE tt_documents.

    DATA(lv_total) = lines( it_documents ).
    IF iv_workers <= 0 OR lv_total = 0.
      RETURN.
    ENDIF.

    DATA(lv_size)      = ( lv_total + iv_workers - 1 ) DIV iv_workers.
    DATA(lv_processed) = 0.

    DO iv_workers TIMES.
      CLEAR lt_chunk.
      DATA(lv_end) = COND i( WHEN lv_processed + lv_size > lv_total THEN lv_total
                             ELSE lv_processed + lv_size ).

      LOOP AT it_documents INTO DATA(ls_doc) FROM lv_processed + 1 TO lv_end.
        APPEND ls_doc TO lt_chunk.
      ENDLOOP.

      IF lt_chunk IS NOT INITIAL.
        TRY.
            APPEND data_to_json( lt_chunk ) TO rt_chunks.
          CATCH cx_transformation_error ##NO_HANDLER.
        ENDTRY.
      ENDIF.

      lv_processed = lv_end.
      IF lv_processed >= lv_total.
        EXIT.
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD documents_from_request.
    IF is_request-documents IS NOT INITIAL.
      rt_docs = is_request-documents.
      RETURN.
    ENDIF.

    IF is_request-heders_values IS INITIAL AND is_request-items_values IS INITIAL.
      RETURN.
    ENDIF.

    APPEND VALUE ty_document( heders_values = is_request-heders_values
                              items_values  = is_request-items_values )
           TO rt_docs.
  ENDMETHOD.

  METHOD dispatch_chunks.
    DATA lv_task TYPE c LENGTH 32.
    DATA lv_seq  TYPE i VALUE 0.

    LOOP AT it_chunks ASSIGNING FIELD-SYMBOL(<lv_chunk>).
      lv_seq  = lv_seq + 1.
      lv_task = |WK_{ sy-uzeit }_{ lv_seq }|.

      TRY.
          CALL FUNCTION 'Z_BAPI_CTF_WORKER'
            STARTING NEW TASK lv_task
            DESTINATION IN GROUP DEFAULT
            EXPORTING
              iv_bapi_name = iv_bapi_name
              iv_mode      = iv_mode
              iv_chunk     = <lv_chunk>.
        CATCH cx_root.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
