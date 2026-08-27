CLASS zcl_http_bapi_meta_v11 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

* HTTP entry point v1.1 (Clean Core).
*
*   GET  /sap/bc/http/sap/zbapi_meta_v11?bapi_name=BAPI_PO_CREATE1
*        -> metadata DDIC da BAPI
*
*   POST /sap/bc/http/sap/zbapi_meta_v11
*        Body: input.json
*        -> executa a BAPI dinamicamente para N documentos em paralelo
*           via cl_abap_parallel (released).
*
* Composition root: aqui é o único lugar onde os legacy adapters são
* instanciados. Todo o resto do código depende apenas das interfaces
* zif_bapi_meta_v11_introspector e zif_bapi_meta_v11_executor.
* Trocar por implementações puramente Clean Core = trocar SÓ este
* arquivo (ou parametrizar a fábrica).

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.

  PRIVATE SECTION.
    METHODS handle_get
      IMPORTING request  TYPE REF TO if_web_http_request
                response TYPE REF TO if_web_http_response
      RAISING   cx_static_check.

    METHODS handle_post
      IMPORTING request  TYPE REF TO if_web_http_request
                response TYPE REF TO if_web_http_response
      RAISING   cx_static_check.

    METHODS build_introspector
      RETURNING VALUE(ro_result) TYPE REF TO zif_bapi_meta_v11_introspector.
ENDCLASS.


CLASS zcl_http_bapi_meta_v11 IMPLEMENTATION.

  METHOD if_http_service_extension~handle_request.

    TRY.
        DATA(lv_method) = to_upper( request->get_method( ) ).

        CASE lv_method.
          WHEN 'GET'.
            handle_get( request  = request
                        response = response ).

          WHEN 'POST'.
            handle_post( request  = request
                         response = response ).

          WHEN OTHERS.
            response->set_status( i_code = 405 i_reason = 'Method Not Allowed' ).
            response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
            response->set_text( `{"error":"Only GET and POST are supported"}` ).
        ENDCASE.

      CATCH cx_root INTO DATA(lx_err).
        DATA(lv_err) = escape( val    = lx_err->get_text( )
                               format = cl_abap_format=>e_json_string ).
        response->set_status( i_code = 400 i_reason = 'Bad Request' ).
        response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
        response->set_text( |\{"error":"{ lv_err }"\}| ).
    ENDTRY.

  ENDMETHOD.

  METHOD handle_get.
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

    DATA(lo_builder) = NEW zcl_bapi_meta_v11_builder( build_introspector( ) ).
    DATA(lv_json)    = lo_builder->build_json( lv_bapi ).

    response->set_status( i_code = 200 i_reason = 'OK' ).
    response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
    response->set_text( lv_json ).
  ENDMETHOD.

  METHOD handle_post.
    DATA(lv_body) = request->get_text( ).
    IF lv_body IS INITIAL.
      response->set_status( i_code = 400 i_reason = 'Bad Request' ).
      response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
      response->set_text( `{"error":"Empty request body"}` ).
      RETURN.
    ENDIF.

    DATA(ls_outcome) = NEW zcl_bapi_meta_v11_dispatch( )->dispatch( lv_body ).

    response->set_status(
      i_code   = COND #( WHEN ls_outcome-mode = zcl_bapi_meta_v11_dispatch=>c_mode_sync THEN 200 ELSE 202 )
      i_reason = COND #( WHEN ls_outcome-mode = zcl_bapi_meta_v11_dispatch=>c_mode_sync THEN 'OK'  ELSE 'Accepted' ) ).
    response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
    response->set_text( ls_outcome-response_json ).
  ENDMETHOD.

  METHOD build_introspector.
    " Único ponto de acoplamento com o adapter legacy (não Clean Core).
    " Para ABAP Cloud puro, trocar por um adapter whitelist-based.
    ro_result = NEW zcl_bapi_meta_v11_lgcy_intro( ).
  ENDMETHOD.

ENDCLASS.

