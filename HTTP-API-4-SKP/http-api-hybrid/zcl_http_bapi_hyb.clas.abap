CLASS zcl_http_bapi_hyb DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

* HTTP entry point (if_http_service_extension) for the Hybrid BAPI
* Runner. Combines the fire-and-forget HTTP dispatch style of
* zcl_http_bapi_dyn with the hybrid strategies:
*   - kernel CTF-based JSON (no /ui2/cl_json anywhere)
*   - streaming header parse (only the top-level scalars are deserialized)
*   - lexical split of documents[]  (O(strlen), no full parse)
*   - per-document commit/rollback inside the worker
*
* Same POST semantics as zcl_http_bapi_dyn:
*   200 OK       when mode=sync
*   202 Accepted when mode=async (default)
*
* Clean Core note: FUNCTION_IMPORT_INTERFACE + dynamic CALL FUNCTION
* are NOT released in ABAP Cloud public. Deploy on on-premise, embedded
* Steampunk, or private cloud.

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.
ENDCLASS.


CLASS zcl_http_bapi_hyb IMPLEMENTATION.

  METHOD if_http_service_extension~handle_request.
    DATA lv_body TYPE string.

    TRY.
        IF to_upper( request->get_method( ) ) <> 'POST'.
          response->set_status( i_code = 405 i_reason = 'Method Not Allowed' ).
          response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
          response->set_text( `{"error":"Only POST is supported"}` ).
          RETURN.
        ENDIF.

        lv_body = request->get_text( ).
        IF lv_body IS INITIAL.
          response->set_status( i_code = 400 i_reason = 'Bad Request' ).
          response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
          response->set_text( `{"error":"Empty request body"}` ).
          RETURN.
        ENDIF.

        DATA(lo_dispatcher) = NEW zcl_http_bapi_hyb_dispatcher( ).
        DATA(ls_outcome)    = lo_dispatcher->dispatch( iv_json = lv_body ).

        response->set_status(
          i_code   = COND #( WHEN ls_outcome-mode = zcl_http_bapi_hyb_dispatcher=>c_mode_sync THEN 200 ELSE 202 )
          i_reason = COND #( WHEN ls_outcome-mode = zcl_http_bapi_hyb_dispatcher=>c_mode_sync THEN 'OK' ELSE 'Accepted' ) ).
        response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
        response->set_text( ls_outcome-response_json ).

      CATCH cx_root INTO DATA(lx_err).
        DATA(lv_err) = escape( val    = lx_err->get_text( )
                               format = cl_abap_format=>e_json_string ).
        response->set_status( i_code = 400 i_reason = 'Bad Request' ).
        response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
        response->set_text( |\{"error":"{ lv_err }"\}| ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
