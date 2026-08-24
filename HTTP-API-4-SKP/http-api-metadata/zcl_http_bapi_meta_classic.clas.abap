CLASS zcl_http_bapi_meta_classic DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

* Variante classica (IF_HTTP_EXTENSION) para publicar via SICF manual
* quando o release nao oferece o wizard HTTP Service do ADT.
* Comportamento identico ao zcl_http_bapi_meta (IF_HTTP_SERVICE_EXTENSION).

  PUBLIC SECTION.
    INTERFACES if_http_extension.
ENDCLASS.


CLASS zcl_http_bapi_meta_classic IMPLEMENTATION.

  METHOD if_http_extension~handle_request.

    DATA(lo_req) = server->request.
    DATA(lo_res) = server->response.

    TRY.
        IF to_upper( lo_req->get_method( ) ) <> 'GET'.
          lo_res->set_status( code = 405 reason = 'Method Not Allowed' ).
          lo_res->set_header_field( name = 'Content-Type' value = 'application/json' ).
          lo_res->set_cdata( `{"error":"Only GET is supported"}` ).
          RETURN.
        ENDIF.

        DATA(lv_bapi) = lo_req->get_form_field( 'bapi_name' ).
        IF lv_bapi IS INITIAL.
          lv_bapi = lo_req->get_form_field( 'BapiName' ).
        ENDIF.

        IF lv_bapi IS INITIAL.
          lo_res->set_status( code = 400 reason = 'Bad Request' ).
          lo_res->set_header_field( name = 'Content-Type' value = 'application/json' ).
          lo_res->set_cdata( `{"error":"Query parameter bapi_name is mandatory"}` ).
          RETURN.
        ENDIF.

        DATA(lv_json) = NEW zcl_http_bapi_meta_builder( )->build_json( lv_bapi ).

        lo_res->set_status( code = 200 reason = 'OK' ).
        lo_res->set_header_field( name = 'Content-Type' value = 'application/json' ).
        lo_res->set_cdata( lv_json ).

      CATCH cx_root INTO DATA(lx_err).
        DATA(lv_err) = escape( val    = lx_err->get_text( )
                               format = cl_abap_format=>e_json_string ).
        lo_res->set_status( code = 400 reason = 'Bad Request' ).
        lo_res->set_header_field( name = 'Content-Type' value = 'application/json' ).
        lo_res->set_cdata( |\{"error":"{ lv_err }"\}| ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
