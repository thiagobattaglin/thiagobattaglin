*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhc_bapi_hyb_run DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR BapiRun RESULT result.

    CONSTANTS c_status_dispatched TYPE c LENGTH 10 VALUE 'DISPATCHED'.
    CONSTANTS c_status_failed     TYPE c LENGTH 10 VALUE 'FAILED'.

    METHODS submit FOR MODIFY
      IMPORTING keys FOR ACTION BapiRun~Submit RESULT result.

    METHODS get_metadata FOR READ
      IMPORTING keys FOR FUNCTION BapiRun~GetMetadata RESULT result.

    METHODS persist_run
      IMPORTING is_outcome     TYPE zcl_bapi_hyb_dispatcher=>ty_outcome
                iv_wt          TYPE i
                iv_wr          TYPE i
                iv_status      TYPE c
                iv_error_text  TYPE string
      RETURNING VALUE(rv_uuid) TYPE sysuuid_x16.

ENDCLASS.


CLASS lhc_bapi_hyb_run IMPLEMENTATION.

  METHOD get_global_authorizations.
    result-%create        = if_abap_behv=>auth-allowed.
    result-%update        = if_abap_behv=>auth-allowed.
    result-%delete        = if_abap_behv=>auth-allowed.
    result-%action-Submit = if_abap_behv=>auth-allowed.
  ENDMETHOD.

  METHOD get_metadata.
    APPEND VALUE #(
      %tky   = VALUE #( )
      %param = VALUE #(
        ServiceName    = 'ZUI_BAPI_HYB_RUN_O4'
        ServiceVersion = '0001'
        OdataVersion   = 'V4'
        Endpoint       = '/sap/opu/odata4/sap/zui_bapi_hyb_run_o4/srvd_a2x/sap/zui_bapi_hyb_run_o4/0001/'
        DispatchEngine = 'bgPF'
        DefaultWorkers = zcl_bapi_hyb_dispatcher=>c_default_workers
        DefaultRows    = zcl_bapi_hyb_dispatcher=>c_default_rows
        SupportedKinds = |{ zcl_bapi_hyb_dispatcher=>c_kind_chunk }\|{ zcl_bapi_hyb_dispatcher=>c_kind_bulk }|
        SupportedModes = |{ zcl_bapi_hyb_dispatcher=>c_mode_async }\|{ zcl_bapi_hyb_dispatcher=>c_mode_sync }|
        PayloadFormat  = '{ bapi_name:string, mode:async|sync, kind:chunk|bulk, ' &&
                         'worker_threads:int, worker_rows:int, ' &&
                         'documents:[ { ' &&
                         'heders_values:[ { value:HEADER_TABLE, ' &&
                         'fields:[ { name:FIELD, value:VALUE } ] } ], ' &&
                         'items_values:[ { value:ITEM_TABLE, ' &&
                         'fields:[ { name:FIELD, value:VALUE } ] } ] } ] }'
        Description    = 'Hybrid BAPI Runner - streaming header parse, lexical split, bgPF dispatch, kernel CTF worker deserialize.' )
    ) TO result.
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
          DATA(lo_dispatcher) = NEW zcl_bapi_hyb_dispatcher( ).
          DATA(ls_hdr)        = lo_dispatcher->parse_header( lv_payload ).

          IF ls_hdr-bapi_name IS INITIAL.
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
                            iv_wt         = ls_hdr-worker_threads
                            iv_wr         = ls_hdr-worker_rows
                            iv_status     = c_status_dispatched
                            iv_error_text = `` ).

          APPEND VALUE #(
            %cid   = <key>-%cid
            %param = VALUE #( RunUuid  = lv_uuid
                              BapiName = ls_outcome-bapi_name
                              Accepted = ls_outcome-accepted
                              Workers  = ls_outcome-workers
                              ExecMode = ls_outcome-mode
                              Kind     = ls_outcome-kind ) ) TO result.

        CATCH cx_root INTO DATA(lx_err).
          DATA(lv_text) = lx_err->get_text( ).
          persist_run(
            is_outcome    = VALUE #( bapi_name = ls_hdr-bapi_name
                                     mode      = ls_hdr-mode )
            iv_wt         = ls_hdr-worker_threads
            iv_wr         = ls_hdr-worker_rows
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

    MODIFY ENTITIES OF zr_bapi_hyb_run IN LOCAL MODE
      ENTITY BapiRun
        CREATE FIELDS ( RunUuid BapiName ExecMode Kind
                        WorkerThreads WorkerRows
                        Accepted Workers Status ErrorText )
        WITH VALUE #( ( %cid          = |CID_{ rv_uuid }|
                        RunUuid       = rv_uuid
                        BapiName      = is_outcome-bapi_name
                        ExecMode      = is_outcome-mode
                        Kind          = is_outcome-kind
                        WorkerThreads = iv_wt
                        WorkerRows    = iv_wr
                        Accepted      = is_outcome-accepted
                        Workers       = is_outcome-workers
                        Status        = iv_status
                        ErrorText     = iv_error_text ) ).
  ENDMETHOD.

ENDCLASS.
