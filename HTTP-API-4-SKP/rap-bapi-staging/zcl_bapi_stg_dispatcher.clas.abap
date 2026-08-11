CLASS zcl_bapi_stg_dispatcher DEFINITION
  PUBLIC
  CREATE PUBLIC.

* Staging dispatcher: parses the incoming block, then persists documents
* and items directly into staging tables (zbapi_stg_doc / zbapi_stg_item)
* via bulk INSERT ... FROM TABLE. Workers read their slice from the DB by
* RunUuid + doc_seq range - NO JSON serialize/deserialize between hops.

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
        run_uuid  TYPE sysuuid_x16,
        bapi_name TYPE string,
        accepted  TYPE i,
        workers   TYPE i,
        mode      TYPE string,
      END OF ty_outcome.

    TYPES:
      BEGIN OF ty_worker_range,
        doc_from TYPE i,
        doc_to   TYPE i,
      END OF ty_worker_range,
      tt_worker_ranges TYPE STANDARD TABLE OF ty_worker_range WITH EMPTY KEY.

    METHODS dispatch
      IMPORTING iv_run_uuid       TYPE sysuuid_x16
                iv_json           TYPE string
      RETURNING VALUE(rs_outcome) TYPE ty_outcome
      RAISING   cx_static_check.

    METHODS parse_request
      IMPORTING iv_json           TYPE string
      RETURNING VALUE(rs_request) TYPE ty_request
      RAISING   cx_static_check.

    METHODS calculate_workers
      IMPORTING iv_docs_total    TYPE i
                iv_worker_rows   TYPE i
                iv_worker_max    TYPE i
      RETURNING VALUE(rv_result) TYPE i.

    METHODS split_ranges
      IMPORTING iv_docs_total    TYPE i
                iv_workers       TYPE i
      RETURNING VALUE(rt_ranges) TYPE tt_worker_ranges.

    METHODS normalize_positive
      IMPORTING iv_value         TYPE i
                iv_default       TYPE i
      RETURNING VALUE(rv_result) TYPE i.

    METHODS documents_from_request
      IMPORTING is_request     TYPE ty_request
      RETURNING VALUE(rt_docs) TYPE tt_documents.

    "! Bulk write of documents + items into staging tables in one DB roundtrip
    "! per table. No JSON is materialized between dispatcher and worker.
    METHODS stage_documents
      IMPORTING iv_run_uuid  TYPE sysuuid_x16
                it_documents TYPE tt_documents.

  PROTECTED SECTION.

    METHODS dispatch_workers
      IMPORTING iv_bapi_name TYPE string
                iv_mode      TYPE string
                iv_run_uuid  TYPE sysuuid_x16
                it_ranges    TYPE tt_worker_ranges.

ENDCLASS.


CLASS zcl_bapi_stg_dispatcher IMPLEMENTATION.

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

    stage_documents( iv_run_uuid  = iv_run_uuid
                     it_documents = lt_docs ).

    DATA(lt_ranges) = split_ranges( iv_docs_total = lv_total
                                    iv_workers    = lv_workers ).

    DATA(lv_mode) = COND string( WHEN ls_request-mode = c_mode_sync THEN c_mode_sync
                                 ELSE c_mode_async ).

    dispatch_workers( iv_bapi_name = ls_request-bapi_name
                      iv_mode      = lv_mode
                      iv_run_uuid  = iv_run_uuid
                      it_ranges    = lt_ranges ).

    rs_outcome = VALUE #( run_uuid  = iv_run_uuid
                          bapi_name = ls_request-bapi_name
                          accepted  = lv_total
                          workers   = lv_workers
                          mode      = lv_mode ).
  ENDMETHOD.

  METHOD parse_request.
    /ui2/cl_json=>deserialize(
      EXPORTING json        = iv_json
                pretty_name = /ui2/cl_json=>pretty_mode-none
      CHANGING  data        = rs_request ).
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

  METHOD split_ranges.
    IF iv_workers <= 0 OR iv_docs_total <= 0.
      RETURN.
    ENDIF.
    DATA(lv_size) = ( iv_docs_total + iv_workers - 1 ) DIV iv_workers.
    DATA(lv_from) = 1.

    DO iv_workers TIMES.
      DATA(lv_to) = COND i( WHEN lv_from + lv_size - 1 > iv_docs_total THEN iv_docs_total
                            ELSE lv_from + lv_size - 1 ).
      APPEND VALUE ty_worker_range( doc_from = lv_from doc_to = lv_to ) TO rt_ranges.
      lv_from = lv_to + 1.
      IF lv_from > iv_docs_total.
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
                              items_values  = is_request-items_values ) TO rt_docs.
  ENDMETHOD.

  METHOD stage_documents.

* Layout in staging:
*   zbapi_stg_doc  (run_uuid, doc_seq)                             -> 1 row per document
*   zbapi_stg_item (run_uuid, doc_seq, section, param_seq, field_seq,
*                   param_name, field_name, field_value)
*     section = 'H' for heders_values, 'I' for items_values
*
* Item rows are packed flat; the worker recomposes header structs and
* table rows by (doc_seq, section, param_seq, field_seq).

    DATA lt_stg_doc  TYPE STANDARD TABLE OF zbapi_stg_doc  WITH EMPTY KEY.
    DATA lt_stg_item TYPE STANDARD TABLE OF zbapi_stg_item WITH EMPTY KEY.

    DATA lv_doc_seq  TYPE i VALUE 0.

    LOOP AT it_documents INTO DATA(ls_doc).
      lv_doc_seq = lv_doc_seq + 1.

      APPEND VALUE zbapi_stg_doc(
        run_uuid = iv_run_uuid
        doc_seq  = lv_doc_seq ) TO lt_stg_doc.

      DATA lv_param_seq TYPE i VALUE 0.
      LOOP AT ls_doc-heders_values INTO DATA(ls_h).
        lv_param_seq = lv_param_seq + 1.
        DATA lv_field_seq TYPE i VALUE 0.
        LOOP AT ls_h-fields INTO DATA(ls_hf).
          lv_field_seq = lv_field_seq + 1.
          APPEND VALUE zbapi_stg_item(
            run_uuid    = iv_run_uuid
            doc_seq     = lv_doc_seq
            section     = 'H'
            param_seq   = lv_param_seq
            field_seq   = lv_field_seq
            param_name  = ls_h-value
            field_name  = ls_hf-name
            field_value = ls_hf-value ) TO lt_stg_item.
        ENDLOOP.
      ENDLOOP.

      lv_param_seq = 0.
      LOOP AT ls_doc-items_values INTO DATA(ls_i).
        lv_param_seq = lv_param_seq + 1.
        lv_field_seq = 0.
        LOOP AT ls_i-fields INTO DATA(ls_if).
          lv_field_seq = lv_field_seq + 1.
          APPEND VALUE zbapi_stg_item(
            run_uuid    = iv_run_uuid
            doc_seq     = lv_doc_seq
            section     = 'I'
            param_seq   = lv_param_seq
            field_seq   = lv_field_seq
            param_name  = ls_i-value
            field_name  = ls_if-name
            field_value = ls_if-value ) TO lt_stg_item.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

    IF lt_stg_doc IS NOT INITIAL.
      INSERT zbapi_stg_doc FROM TABLE @lt_stg_doc.
    ENDIF.
    IF lt_stg_item IS NOT INITIAL.
      INSERT zbapi_stg_item FROM TABLE @lt_stg_item.
    ENDIF.

    COMMIT WORK.
  ENDMETHOD.

  METHOD dispatch_workers.
    DATA lv_task TYPE c LENGTH 32.
    DATA lv_seq  TYPE i VALUE 0.

    LOOP AT it_ranges INTO DATA(ls_range).
      lv_seq  = lv_seq + 1.
      lv_task = |WK_{ sy-uzeit }_{ lv_seq }|.

      TRY.
          CALL FUNCTION 'Z_BAPI_STG_WORKER'
            STARTING NEW TASK lv_task
            DESTINATION IN GROUP DEFAULT
            EXPORTING
              iv_bapi_name = iv_bapi_name
              iv_mode      = iv_mode
              iv_run_uuid  = iv_run_uuid
              iv_doc_from  = ls_range-doc_from
              iv_doc_to    = ls_range-doc_to.
        CATCH cx_root.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
