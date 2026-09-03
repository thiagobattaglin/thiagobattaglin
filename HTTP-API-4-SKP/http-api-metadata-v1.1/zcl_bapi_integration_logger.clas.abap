CLASS zcl_bapi_integration_logger DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

* Clean Core wrapper around the released Application Log API (cl_bali_*).
* Every log written by this framework can be inspected via SLG1
* filtering by Object = ZBAPI_INTG (and External ID = correlation id
* returned by the dispatcher).
*
* PREREQUISITE (one-off SLG0 setup):
*   Object    : ZBAPI_INTG   (text: BAPI Integration Framework)
*   Subobjects: DISPATCH     (dispatcher run summary)
*               WORKER       (per-worker document results)
*
* Only released APIs are used:
*   cl_bali_log, cl_bali_header_setter, cl_bali_free_text_setter,
*   cl_bali_log_db, if_bali_constants.
*
* All Bali calls are wrapped in TRY/CATCH cx_root so a logging problem
* (e.g. SLG0 objects missing) never breaks the integration flow.

  PUBLIC SECTION.

    CONSTANTS c_object        TYPE string VALUE 'ZBAPI_INTG'.
    CONSTANTS c_sub_dispatch  TYPE string VALUE 'DISPATCH'.
    CONSTANTS c_sub_worker    TYPE string VALUE 'WORKER'.

    CLASS-METHODS open
      IMPORTING iv_subobject     TYPE csequence
                iv_external_id   TYPE csequence
      RETURNING VALUE(ro_result) TYPE REF TO zcl_bapi_integration_logger.

    METHODS add_info
      IMPORTING iv_text TYPE csequence.

    METHODS add_success
      IMPORTING iv_text TYPE csequence.

    METHODS add_error
      IMPORTING iv_text TYPE csequence.

    METHODS add_bapi_messages
      IMPORTING it_messages TYPE zif_bapi_integration_executor=>tt_messages.

    METHODS save.

  PRIVATE SECTION.

    DATA mo_log TYPE REF TO if_bali_log.

    METHODS add_free_text
      IMPORTING iv_severity TYPE symsgty
                iv_text     TYPE csequence.

ENDCLASS.


CLASS zcl_bapi_integration_logger IMPLEMENTATION.

  METHOD open.
    ro_result = NEW zcl_bapi_integration_logger( ).

    TRY.
        DATA(lo_header) = cl_bali_header_setter=>create(
                            object      = CONV #( c_object )
                            subobject   = CONV #( iv_subobject )
                            external_id = CONV #( iv_external_id ) ).

        ro_result->mo_log = cl_bali_log=>create_with_header( header = lo_header ).
      CATCH cx_root ##NO_HANDLER.
        " If SLG0 objects are missing the log stays unbound and all
        " subsequent operations become no-ops.
        CLEAR ro_result->mo_log.
    ENDTRY.
  ENDMETHOD.

  METHOD add_info.
    add_free_text( iv_severity = 'I' iv_text = iv_text ).
  ENDMETHOD.

  METHOD add_success.
    add_free_text( iv_severity = 'S' iv_text = iv_text ).
  ENDMETHOD.

  METHOD add_error.
    add_free_text( iv_severity = 'E' iv_text = iv_text ).
  ENDMETHOD.

  METHOD add_free_text.
    IF mo_log IS NOT BOUND.
      RETURN.
    ENDIF.

    TRY.
        DATA(lo_item) = cl_bali_free_text_setter=>create(
                          severity = iv_severity
                          text     = CONV #( iv_text ) ).
        mo_log->add_item( item = lo_item ).
      CATCH cx_root ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD add_bapi_messages.
    LOOP AT it_messages INTO DATA(ls_msg).
      DATA(lv_line) = |{ ls_msg-type }: { ls_msg-id }/{ ls_msg-number } { ls_msg-message }|.
      add_free_text( iv_severity = COND #( WHEN ls_msg-type IS INITIAL THEN 'I' ELSE ls_msg-type )
                     iv_text     = lv_line ).
    ENDLOOP.
  ENDMETHOD.

  METHOD save.
    IF mo_log IS NOT BOUND.
      RETURN.
    ENDIF.

    TRY.
        cl_bali_log_db=>get_instance( )->save_log( log = mo_log ).
        COMMIT WORK.
      CATCH cx_root ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
