"! <p class="shorttext synchronized">Unit tests for ZCL_EQUI_LOAD_HTTP_API</p>

"! Stub request that returns a fixed body text.
CLASS ltcl_req_stub DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_web_http_request.
    METHODS constructor IMPORTING iv_body TYPE string.
  PRIVATE SECTION.
    DATA mv_body TYPE string.
ENDCLASS.

CLASS ltcl_req_stub IMPLEMENTATION.

  METHOD constructor.
    mv_body = iv_body.
  ENDMETHOD.

  METHOD if_web_http_request~get_text.
    result = mv_body.
  ENDMETHOD.

  METHOD if_web_http_request~get_header_field.
  ENDMETHOD.
  METHOD if_web_http_request~get_header_fields.
  ENDMETHOD.
  METHOD if_web_http_request~get_form_field.
  ENDMETHOD.
  METHOD if_web_http_request~get_form_fields.
  ENDMETHOD.
  METHOD if_web_http_request~get_cookie.
  ENDMETHOD.
  METHOD if_web_http_request~get_cookies.
  ENDMETHOD.
  METHOD if_web_http_request~get_binary.
  ENDMETHOD.
  METHOD if_web_http_request~get_uri.
  ENDMETHOD.
  METHOD if_web_http_request~get_method.
  ENDMETHOD.
  METHOD if_web_http_request~get_content_type.
  ENDMETHOD.
  METHOD if_web_http_request~get_client_authentication.
  ENDMETHOD.

ENDCLASS.


"! Stub response that captures status, headers and body.
CLASS ltcl_resp_stub DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_web_http_response.
    DATA mv_status TYPE i.
    DATA mv_ctype  TYPE string.
    DATA mv_body   TYPE string.
ENDCLASS.

CLASS ltcl_resp_stub IMPLEMENTATION.

  METHOD if_web_http_response~set_status.
    mv_status = i_code.
    result = me.
  ENDMETHOD.

  METHOD if_web_http_response~set_content_type.
    mv_ctype = i_content_type.
    result = me.
  ENDMETHOD.

  METHOD if_web_http_response~set_text.
    mv_body = i_text.
    result = me.
  ENDMETHOD.

  METHOD if_web_http_response~set_binary.
    result = me.
  ENDMETHOD.
  METHOD if_web_http_response~set_header_field.
    result = me.
  ENDMETHOD.
  METHOD if_web_http_response~set_header_fields.
    result = me.
  ENDMETHOD.
  METHOD if_web_http_response~set_cookie.
    result = me.
  ENDMETHOD.
  METHOD if_web_http_response~get_status.
  ENDMETHOD.
  METHOD if_web_http_response~get_text.
  ENDMETHOD.
  METHOD if_web_http_response~get_binary.
  ENDMETHOD.
  METHOD if_web_http_response~get_header_field.
  ENDMETHOD.
  METHOD if_web_http_response~get_header_fields.
  ENDMETHOD.
  METHOD if_web_http_response~get_content_type.
  ENDMETHOD.

ENDCLASS.


CLASS ltcl_http_api DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS empty_body_returns_400        FOR TESTING.
    METHODS empty_items_returns_400       FOR TESTING.
    METHODS async_default_returns_202     FOR TESTING.
    METHODS sync_returns_200              FOR TESTING.

    METHODS call_api
      IMPORTING iv_body    TYPE string
      EXPORTING eo_response TYPE REF TO ltcl_resp_stub.

ENDCLASS.


CLASS ltcl_http_api IMPLEMENTATION.

  METHOD call_api.

    DATA(lo_req)  = NEW ltcl_req_stub( iv_body ).
    DATA(lo_resp) = NEW ltcl_resp_stub( ).

    DATA(lo_api) = NEW zcl_equi_load_http_api( ).
    lo_api->if_http_service_extension~handle_request(
      request  = lo_req
      response = lo_resp ).

    eo_response = lo_resp.

  ENDMETHOD.

  METHOD empty_body_returns_400.

    call_api(
      EXPORTING iv_body    = ``
      IMPORTING eo_response = DATA(lo_resp) ).

    cl_abap_unit_assert=>assert_equals(
      exp = 400
      act = lo_resp->mv_status
      msg = 'Empty body must produce HTTP 400' ).

  ENDMETHOD.

  METHOD empty_items_returns_400.

    call_api(
      EXPORTING iv_body    = `{ "mode": "async", "worker_rows": 0, "items": [] }`
      IMPORTING eo_response = DATA(lo_resp) ).

    cl_abap_unit_assert=>assert_equals(
      exp = 400
      act = lo_resp->mv_status
      msg = 'Missing items must produce HTTP 400' ).

  ENDMETHOD.

  METHOD async_default_returns_202.

    call_api(
      EXPORTING iv_body    = `{ "mode": "async", "worker_rows": 0, "items": [ { "ext_id": "A1", "equi_category": "M" } ] }`
      IMPORTING eo_response = DATA(lo_resp) ).

    cl_abap_unit_assert=>assert_equals(
      exp = 202
      act = lo_resp->mv_status
      msg = 'Async flow must return HTTP 202' ).

    cl_abap_unit_assert=>assert_char_cp(
      exp = |*accepted*|
      act = lo_resp->mv_body
      msg = 'Async body must contain accepted count' ).

  ENDMETHOD.

  METHOD sync_returns_200.

    call_api(
      EXPORTING iv_body    = `{ "mode": "sync", "worker_rows": 0, "items": [ { "ext_id": "A1", "equi_category": "M" } ] }`
      IMPORTING eo_response = DATA(lo_resp) ).

    cl_abap_unit_assert=>assert_equals(
      exp = 200
      act = lo_resp->mv_status
      msg = 'Sync flow must return HTTP 200' ).

    cl_abap_unit_assert=>assert_char_cp(
      exp = |*results*|
      act = lo_resp->mv_body
      msg = 'Sync body must contain results array' ).

  ENDMETHOD.

ENDCLASS.
