"! Unit tests for <em>zcl_bapi_rap_dispatcher</em>.
"! Avoids real RFC dispatch by injecting a test subclass overriding dispatch_chunks.
CLASS ltcl_dispatcher_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CLASS-DATA: mt_captured TYPE string_table.

    METHODS defaults_when_zero_or_missing FOR TESTING.
    METHODS calculate_workers_boundaries  FOR TESTING.
    METHODS parse_single_document         FOR TESTING.
    METHODS parse_bulk_documents          FOR TESTING.
    METHODS dispatch_returns_outcome      FOR TESTING RAISING cx_static_check.
    METHODS empty_bapi_raises             FOR TESTING.

ENDCLASS.


"! Test subclass that intercepts async dispatch.
CLASS ltc_dispatcher_stub DEFINITION INHERITING FROM zcl_bapi_rap_dispatcher.
  PUBLIC SECTION.
    CLASS-DATA gt_last_chunks TYPE string_table.
  PROTECTED SECTION.
    METHODS dispatch_chunks REDEFINITION.
ENDCLASS.

CLASS ltc_dispatcher_stub IMPLEMENTATION.
  METHOD dispatch_chunks.
    gt_last_chunks = it_chunks.
  ENDMETHOD.
ENDCLASS.


CLASS ltcl_dispatcher_test IMPLEMENTATION.

  METHOD defaults_when_zero_or_missing.
    DATA(lo) = NEW zcl_bapi_rap_dispatcher( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 5000
      act = lo->normalize_positive( iv_value = 0    iv_default = 5000 ) ).
    cl_abap_unit_assert=>assert_equals(
      exp = 4
      act = lo->normalize_positive( iv_value = -3   iv_default = 4    ) ).
    cl_abap_unit_assert=>assert_equals(
      exp = 12
      act = lo->normalize_positive( iv_value = 12   iv_default = 4    ) ).
  ENDMETHOD.

  METHOD calculate_workers_boundaries.
    DATA(lo) = NEW zcl_bapi_rap_dispatcher( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 3
      act = lo->calculate_workers( iv_docs_total  = 12000
                                   iv_worker_rows = 5000
                                   iv_worker_max  = 4 ) ).
    cl_abap_unit_assert=>assert_equals(
      exp = 4
      act = lo->calculate_workers( iv_docs_total  = 100000
                                   iv_worker_rows = 5000
                                   iv_worker_max  = 4 ) ).
    cl_abap_unit_assert=>assert_equals(
      exp = 1
      act = lo->calculate_workers( iv_docs_total  = 10
                                   iv_worker_rows = 5000
                                   iv_worker_max  = 4 ) ).
    cl_abap_unit_assert=>assert_equals(
      exp = 0
      act = lo->calculate_workers( iv_docs_total  = 0
                                   iv_worker_rows = 5000
                                   iv_worker_max  = 4 ) ).
  ENDMETHOD.

  METHOD parse_single_document.
    DATA(lv_json) =
      `{"bapi_name":"BAPI_PO_CREATE1","worker_threads":10,"worker_rows":5000,` &&
      `"heders_values":[{"value":"poheader","fields":[{"name":"vendor","value":"100000"}]}],` &&
      `"items_values":[]}`.

    DATA(lo)  = NEW zcl_bapi_rap_dispatcher( ).
    DATA(ls_req) = lo->parse_request( lv_json ).

    cl_abap_unit_assert=>assert_equals( exp = `BAPI_PO_CREATE1` act = ls_req-bapi_name ).
    cl_abap_unit_assert=>assert_equals( exp = 10                act = ls_req-worker_threads ).
    cl_abap_unit_assert=>assert_equals( exp = 5000              act = ls_req-worker_rows ).

    DATA(lt_docs) = lo->documents_from_request( ls_req ).
    cl_abap_unit_assert=>assert_equals( exp = 1 act = lines( lt_docs ) ).
  ENDMETHOD.

  METHOD parse_bulk_documents.
    DATA(lv_json) =
      `{"bapi_name":"BAPI_PO_CREATE1","worker_threads":4,"worker_rows":1,` &&
      `"documents":[` &&
        `{"heders_values":[],"items_values":[]},` &&
        `{"heders_values":[],"items_values":[]},` &&
        `{"heders_values":[],"items_values":[]}` &&
      `]}`.

    DATA(lo)  = NEW zcl_bapi_rap_dispatcher( ).
    DATA(ls_req)  = lo->parse_request( lv_json ).
    DATA(lt_docs) = lo->documents_from_request( ls_req ).

    cl_abap_unit_assert=>assert_equals( exp = 3 act = lines( lt_docs ) ).
  ENDMETHOD.

  METHOD dispatch_returns_outcome.
    ltc_dispatcher_stub=>gt_last_chunks = VALUE #( ).

    DATA(lv_json) =
      `{"bapi_name":"BAPI_TEST","worker_threads":2,"worker_rows":1,` &&
      `"documents":[` &&
        `{"heders_values":[],"items_values":[]},` &&
        `{"heders_values":[],"items_values":[]}` &&
      `]}`.

    DATA(lo) = NEW ltc_dispatcher_stub( ).
    DATA(ls) = lo->dispatch( lv_json ).

    cl_abap_unit_assert=>assert_equals( exp = `BAPI_TEST` act = ls-bapi_name ).
    cl_abap_unit_assert=>assert_equals( exp = 2           act = ls-accepted  ).
    cl_abap_unit_assert=>assert_equals( exp = 2           act = ls-workers   ).
    cl_abap_unit_assert=>assert_equals( exp = `async`     act = ls-mode      ).

    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = lines( ltc_dispatcher_stub=>gt_last_chunks ) ).
  ENDMETHOD.

  METHOD empty_bapi_raises.
    DATA(lv_json) = `{"bapi_name":"","heders_values":[],"items_values":[]}`.
    DATA(lo) = NEW ltc_dispatcher_stub( ).

    TRY.
        lo->dispatch( lv_json ).
        cl_abap_unit_assert=>fail( 'Should raise cx_parameter_invalid_range' ).
      CATCH cx_parameter_invalid_range ##NO_HANDLER.
      CATCH cx_root INTO DATA(lx).
        cl_abap_unit_assert=>fail( lx->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
