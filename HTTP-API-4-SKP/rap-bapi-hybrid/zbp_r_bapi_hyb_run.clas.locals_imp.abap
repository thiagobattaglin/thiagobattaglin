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
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      DATA(lv_bapi) = CONV string( <key>-%param-BapiName ).

      TRY.
          DATA(lt_rows) = NEW zcl_bapi_hyb_meta_builder( )->build( lv_bapi ).

          DATA lt_headers TYPE STANDARD TABLE OF zcl_bapi_hyb_meta_builder=>ty_row WITH EMPTY KEY.
          DATA lt_items   TYPE STANDARD TABLE OF zcl_bapi_hyb_meta_builder=>ty_row WITH EMPTY KEY.

          LOOP AT lt_rows ASSIGNING FIELD-SYMBOL(<row>).
            CASE <row>-section.
              WHEN 'H'.
                APPEND <row> TO lt_headers.
              WHEN 'I'.
                APPEND <row> TO lt_items.
            ENDCASE.
          ENDLOOP.

          DATA lt_header_params TYPE STANDARD TABLE OF string WITH EMPTY KEY.
          DATA lt_item_params   TYPE STANDARD TABLE OF string WITH EMPTY KEY.

          LOOP AT lt_headers ASSIGNING FIELD-SYMBOL(<h>).
            IF NOT line_exists( lt_header_params[ table_line = CONV string( <h>-param_name ) ] ).
              APPEND CONV string( <h>-param_name ) TO lt_header_params.
            ENDIF.
          ENDLOOP.

          LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<i>).
            IF NOT line_exists( lt_item_params[ table_line = CONV string( <i>-param_name ) ] ).
              APPEND CONV string( <i>-param_name ) TO lt_item_params.
            ENDIF.
          ENDLOOP.

          DATA(lv_json) = |\{"bapi_name":"{ lv_bapi }","documents":[\{|.

          lv_json = lv_json && |"headers_values":[|.
          DATA(lv_first_struct) = abap_true.
          LOOP AT lt_header_params ASSIGNING FIELD-SYMBOL(<hp>).
            IF lv_first_struct = abap_false.
              lv_json = lv_json && `,`.
            ENDIF.
            lv_first_struct = abap_false.
            lv_json = lv_json && |\{"value":"{ <hp> }","fields":[|.
            DATA(lv_first_field) = abap_true.
            LOOP AT lt_headers ASSIGNING FIELD-SYMBOL(<hf>) WHERE param_name = <hp>.
              IF lv_first_field = abap_false.
                lv_json = lv_json && `,`.
              ENDIF.
              lv_first_field = abap_false.
              lv_json = lv_json && |\{"name":"{ <hf>-field_name }","type":"{ <hf>-field_type }"\}|.
            ENDLOOP.
            lv_json = lv_json && `]}`.
          ENDLOOP.
          lv_json = lv_json && `],`.

          lv_json = lv_json && |"items_values":[|.
          lv_first_struct = abap_true.
          LOOP AT lt_item_params ASSIGNING FIELD-SYMBOL(<ip>).
            IF lv_first_struct = abap_false.
              lv_json = lv_json && `,`.
            ENDIF.
            lv_first_struct = abap_false.
            lv_json = lv_json && |\{"value":"{ <ip> }","fields":[|.
            lv_first_field = abap_true.
            LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<if>) WHERE param_name = <ip>.
              IF lv_first_field = abap_false.
                lv_json = lv_json && `,`.
              ENDIF.
              lv_first_field = abap_false.
              lv_json = lv_json && |\{"name":"{ <if>-field_name }","type":"{ <if>-field_type }"\}|.
            ENDLOOP.
            lv_json = lv_json && `]}`.
          ENDLOOP.
          lv_json = lv_json && `]}]}`.

          APPEND VALUE #(
            %cid   = <key>-%cid
            %param = VALUE #(
              BapiName = lv_bapi
              Metadata = lv_json ) ) TO result.

        CATCH cx_root.
          " BAPI not found or introspection error: return empty collection.
      ENDTRY.
    ENDLOOP.
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
          DATA(lv_trimmed)    = lo_dispatcher->get_trimmed_header( lv_payload ).
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
          DATA(lv_payload_err) = COND string( WHEN strlen( lv_payload ) > 200
                                               THEN lv_payload(200)
                                               ELSE lv_payload ).
          DATA(lv_msg_full) = |Error: { lv_text }. Payload (first 200): { lv_payload_err }|.
          
          persist_run(
            is_outcome    = VALUE #( bapi_name = ls_hdr-bapi_name
                                     mode      = ls_hdr-mode )
            iv_wt         = ls_hdr-worker_threads
            iv_wr         = ls_hdr-worker_rows
            iv_status     = c_status_failed
            iv_error_text = lv_msg_full ).

          APPEND VALUE #( %cid = <key>-%cid
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = lv_msg_full ) ) TO reported-bapirun.
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
