CLASS zcl_http_bapi_meta DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

* HTTP entry point (if_http_service_extension) that returns the DDIC
* metadata of any classic BAPI in the exact shape of metadata-ex.json:
*
*   {
*     "bapi_name": "...",
*     "documents": [
*       {
*         "headers_values": [ { "value":"POHEADER", "fields":[...] }, ... ],
*         "items_values":   [ { "value":"POITEM",   "fields":[...] }, ... ]
*       }
*     ]
*   }
*
* GET /sap/bc/http/sap/zbapi_meta?bapi_name=BAPI_PO_CREATE1
*
* Clean Core caveat: FUNCTION_IMPORT_INTERFACE + DDIF_FIELDINFO_GET are
* not released for ABAP Cloud public. Intended for on-premise, embedded
* Steampunk or private cloud.

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.
ENDCLASS.


CLASS zcl_http_bapi_meta IMPLEMENTATION.

  METHOD if_http_service_extension~handle_request.

    TRY.
        IF to_upper( request->get_method( ) ) <> 'GET'.
          response->set_status( i_code = 405 i_reason = 'Method Not Allowed' ).
          response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
          response->set_text( `{"error":"Only GET is supported"}` ).
          RETURN.
        ENDIF.

        DATA(lv_bapi) = request->get_form_field( 'bapi_name' ).
        IF lv_bapi IS INITIAL.
          lv_bapi = request->get_form_field( 'BapiName' ).
        ENDIF.

        IF lv_bapi IS INITIAL.
          response->set_status( i_code = 400 i_reason = 'Bad Request' ).
          response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
          response->set_text( `{"error":"Query parameter bapi_name is mandatory"}` ).
          RETURN.
        ENDIF.

        DATA(lv_json) = NEW zcl_http_bapi_meta_builder( )->build_json( lv_bapi ).

        response->set_status( i_code = 200 i_reason = 'OK' ).
        response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
        response->set_text( lv_json ).

      CATCH cx_root INTO DATA(lx_err).
        DATA(lv_err) = escape( val    = lx_err->get_text( )
                               format = cl_abap_format=>e_json_string ).
        response->set_status( i_code = 400 i_reason = 'Bad Request' ).
        response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
        response->set_text( |\{"error":"{ lv_err }"\}| ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
