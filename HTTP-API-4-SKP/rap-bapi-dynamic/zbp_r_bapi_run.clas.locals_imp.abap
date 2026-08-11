*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhc_bapi_run DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR BapiRun RESULT result.

    CONSTANTS c_status_dispatched TYPE c LENGTH 10 VALUE 'DISPATCHED'.
    CONSTANTS c_status_failed     TYPE c LENGTH 10 VALUE 'FAILED'.

    METHODS submit FOR MODIFY
      IMPORTING keys FOR ACTION BapiRun~Submit RESULT result.

    METHODS persist_run
      IMPORTING is_outcome     TYPE zcl_bapi_rap_dispatcher=>ty_outcome
                iv_wt          TYPE i
                iv_wr          TYPE i
                iv_status      TYPE c
                iv_error_text  TYPE string
      RETURNING VALUE(rv_uuid) TYPE sysuuid_x16.

ENDCLASS.


CLASS lhc_bapi_run IMPLEMENTATION.

  METHOD get_global_authorizations.
    result-%create        = if_abap_behv=>auth-allowed.
    result-%update        = if_abap_behv=>auth-allowed.
    result-%delete        = if_abap_behv=>auth-allowed.
    result-%action-Submit = if_abap_behv=>auth-allowed.
  ENDMETHOD.

  METHOD submit.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).

      DATA(lv_payload) = <key>-%param-Payload.

      IF lv_payload IS INITIAL.
        APPEND VALUE #( %cid = <key>-%cid
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Payload is empty' ) ) TO reported-bapirun.
        APPEND VALUE #( %cid = <key>-%cid ) TO failed-bapirun.
        CONTINUE.
      ENDIF.

      TRY.
          DATA(lo_dispatcher) = NEW zcl_bapi_rap_dispatcher( ).

          DATA(ls_request) = lo_dispatcher->parse_request( lv_payload ).

          IF ls_request-bapi_name IS INITIAL.
            APPEND VALUE #( %cid = <key>-%cid
                            %msg = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = 'bapi_name is mandatory' ) ) TO reported-bapirun.
            APPEND VALUE #( %cid = <key>-%cid ) TO failed-bapirun.
            CONTINUE.
          ENDIF.

          DATA(ls_outcome) = lo_dispatcher->dispatch( lv_payload ).

          DATA(lv_uuid) = persist_run(
                            is_outcome    = ls_outcome
                            iv_wt         = ls_request-worker_threads
                            iv_wr         = ls_request-worker_rows
                            iv_status     = c_status_dispatched
                            iv_error_text = `` ).

          APPEND VALUE #(
            %cid   = <key>-%cid
            %param = VALUE #( RunUuid  = lv_uuid
                              BapiName = ls_outcome-bapi_name
                              Accepted = ls_outcome-accepted
                              Workers  = ls_outcome-workers
                              ExecMode = ls_outcome-mode ) ) TO result.

        CATCH cx_root INTO DATA(lx_err).
          DATA(lv_text) = lx_err->get_text( ).
          persist_run(
            is_outcome    = VALUE #( bapi_name = ls_request-bapi_name
                                     mode      = ls_request-mode )
            iv_wt         = ls_request-worker_threads
            iv_wr         = ls_request-worker_rows
            iv_status     = c_status_failed
            iv_error_text = lv_text ).

          APPEND VALUE #( %cid = <key>-%cid
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = lv_text ) ) TO reported-bapirun.
          APPEND VALUE #( %cid = <key>-%cid ) TO failed-bapirun.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD persist_run.

    TRY.
        rv_uuid = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_root.
        CLEAR rv_uuid.
    ENDTRY.

* Inserts an audit row in the BO buffer. Effective persistence occurs in the
* RAP natural save sequence at the end of the OData roundtrip - CreatedBy,
* CreatedAt, and LocalLastChangedAt are filled by managed framework handlers.
    MODIFY ENTITIES OF zr_bapi_run IN LOCAL MODE
      ENTITY BapiRun
        CREATE FIELDS ( RunUuid BapiName ExecMode
                        WorkerThreads WorkerRows
                        Accepted Workers Status ErrorText )
        WITH VALUE #( ( %cid          = |CID_{ rv_uuid }|
                        RunUuid       = rv_uuid
                        BapiName      = is_outcome-bapi_name
                        ExecMode      = is_outcome-mode
                        WorkerThreads = iv_wt
                        WorkerRows    = iv_wr
                        Accepted      = is_outcome-accepted
                        Workers       = is_outcome-workers
                        Status        = iv_status
                        ErrorText     = iv_error_text ) ).

  ENDMETHOD.

ENDCLASS.
