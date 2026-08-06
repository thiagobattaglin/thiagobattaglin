"! <p class="shorttext synchronized">HTTP API — Equipment Load (Clean Core Add-on)</p>
"!
"! Public HTTP endpoint consumed by the Replicate SAP Target Connector
"! (and by the Scanner) following the Clean Core Compliant Add-on architecture.
"!
"! Register as a Service Binding of type HTTP Service:
"!   Handler class = ZCL_EQUI_LOAD_HTTP_API
"!
"! Contract (JSON):
"!   POST /equi-load
"!   {
"!     "mode": "async" | "sync",
"!     "worker_rows": 5000,
"!     "items": [ { "ext_id": "...", "descript": "...", ... } ]
"!   }
"!
"! worker_rows drives the chunking:
"!   - worker_rows > 0  → each worker takes up to worker_rows items
"!   - worker_rows <= 0 or missing → items are split into 4 workers
"!     (fewer than 4 if input has fewer than 4 items).
"! Inside each worker every item still runs 1 BAPI_EQUI_CREATE +
"! its own BAPI_TRANSACTION_COMMIT (isolation per item).
"!
"! Sync response:
"!   HTTP 200 { "results": [ { "ext_id", "equipment", "status", "message" } ] }
"!
"! Async response:
"!   HTTP 202 { "accepted": <n>, "workers": <n>, "mode": "async" }
CLASS zcl_equi_load_http_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.

  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_request,
        mode        TYPE string,
        worker_rows TYPE i,
        items       TYPE zcl_equi_load_dto=>tt_input,
      END OF ty_request.

    TYPES:
      BEGIN OF ty_response_sync,
        results TYPE zcl_equi_load_dto=>tt_result,
      END OF ty_response_sync.

    TYPES:
      BEGIN OF ty_response_async,
        accepted TYPE i,
        workers  TYPE i,
        mode     TYPE string,
      END OF ty_response_async.

    METHODS parse_request
      IMPORTING io_request       TYPE REF TO if_web_http_request
      RETURNING VALUE(rs_request) TYPE ty_request
      RAISING   cx_web_message_error.

    METHODS write_response_sync
      IMPORTING io_response TYPE REF TO if_web_http_response
                it_result   TYPE zcl_equi_load_dto=>tt_result
      RAISING   cx_web_message_error.

    METHODS write_response_async
      IMPORTING io_response TYPE REF TO if_web_http_response
                iv_accepted TYPE i
                iv_workers  TYPE i
      RAISING   cx_web_message_error.

    METHODS write_error
      IMPORTING io_response TYPE REF TO if_web_http_response
                iv_status   TYPE i
                iv_message  TYPE string.

ENDCLASS.


CLASS zcl_equi_load_http_api IMPLEMENTATION.

  METHOD if_http_service_extension~handle_request.

    TRY.

        DATA(ls_req) = parse_request( request ).

        IF ls_req-items IS INITIAL.
          write_error(
            io_response = response
            iv_status   = 400
            iv_message  = `items must not be empty` ).
          RETURN.
        ENDIF.

        DATA(lo_source) = CAST zif_equi_load_source(
                            NEW zcl_equi_load_src_http( ls_req-items ) ).

        IF ls_req-mode = `sync`.

          " Sync: each worker runs within the same request; immediate response.
          DATA(lo_sink_sync) = NEW zcl_equi_load_sink_memory( ).

          DATA(lo_orch_sync) = NEW zcl_equi_load_orchestrator(
                                io_source      = lo_source
                                io_sink        = CAST zif_equi_load_sink( lo_sink_sync )
                                iv_worker_rows = ls_req-worker_rows ).

          DATA(lt_result) = lo_orch_sync->run_sync( ).

          write_response_sync(
            io_response = response
            it_result   = lt_result ).

        ELSE.

          " Async (default): chunk items and submit each chunk as 1 worker to bgPF.
          DATA(lo_sink_async) = CAST zif_equi_load_sink(
                                  NEW zcl_equi_load_sink_applog( ) ).

          DATA(lo_orch_async) = NEW zcl_equi_load_orchestrator(
                                  io_source      = lo_source
                                  io_sink        = lo_sink_async
                                  iv_worker_rows = ls_req-worker_rows ).

          DATA(lv_workers) = lo_orch_async->run( ).

          write_response_async(
            io_response = response
            iv_accepted = lines( ls_req-items )
            iv_workers  = lv_workers ).

        ENDIF.

      CATCH cx_web_message_error INTO DATA(lx_msg).
        write_error(
          io_response = response
          iv_status   = 400
          iv_message  = lx_msg->get_text( ) ).

      CATCH cx_root INTO DATA(lx_root).
        write_error(
          io_response = response
          iv_status   = 500
          iv_message  = lx_root->get_text( ) ).

    ENDTRY.

  ENDMETHOD.

  METHOD parse_request.

    DATA(lv_body) = io_request->get_text( ).

    IF lv_body IS INITIAL.
      RETURN.
    ENDIF.

    " JSON deserialization → ABAP structure (snake_case names converted
    " automatically by xco_cp_json).
    xco_cp_json=>data->from_string( lv_body
      )->apply( VALUE #(
        ( xco_cp_json=>transformation->underscore_to_pascal_case ) )
      )->write_to( REF #( rs_request ) ).

  ENDMETHOD.

  METHOD write_response_sync.

    DATA(ls_body) = VALUE ty_response_sync( results = it_result ).

    DATA(lv_json) = xco_cp_json=>data->from_abap( ls_body
      )->apply( VALUE #(
        ( xco_cp_json=>transformation->pascal_case_to_underscore ) )
      )->to_string( ).

    io_response->set_status( i_code = 200 i_reason = 'OK'
      )->set_content_type( 'application/json'
      )->set_text( lv_json ).

  ENDMETHOD.

  METHOD write_response_async.

    DATA(ls_body) = VALUE ty_response_async(
                      accepted = iv_accepted
                      workers  = iv_workers
                      mode     = 'async' ).

    DATA(lv_json) = xco_cp_json=>data->from_abap( ls_body
      )->apply( VALUE #(
        ( xco_cp_json=>transformation->pascal_case_to_underscore ) )
      )->to_string( ).

    io_response->set_status( i_code = 202 i_reason = 'Accepted'
      )->set_content_type( 'application/json'
      )->set_text( lv_json ).

  ENDMETHOD.

  METHOD write_error.

    DATA(lv_json) = |\{ "error": "{ iv_message }" \}|.

    io_response->set_status( i_code = iv_status i_reason = 'Error'
      )->set_content_type( 'application/json'
      )->set_text( lv_json ).

  ENDMETHOD.

ENDCLASS.
