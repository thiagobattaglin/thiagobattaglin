"! Unit tests for zcl_bapi_ctf_dispatcher.
"! Verifies CTF-based deserialize produces the same shape as /ui2/cl_json
"! and that the splitter and workers behave equivalently to the base.
CLASS ltcl_ctf_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS defaults                FOR TESTING.
    METHODS calc_workers            FOR TESTING.
    METHODS parse_single_document   FOR TESTING RAISING cx_static_check.
    METHODS parse_bulk_documents    FOR TESTING RAISING cx_static_check.
    METHODS dispatch_returns        FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_ctf_stub DEFINITION INHERITING FROM zcl_bapi_ctf_dispatcher.
  PUBLIC SECTION.
    CLASS-DATA gt_last_chunks TYPE string_table.
  PROTECTED SECTION.
    METHODS dispatch_chunks REDEFINITION.
ENDCLASS.

CLASS ltc_ctf_stub IMPLEMENTATION.
  METHOD dispatch_chunks.
    gt_last_chunks = it_chunks.
  ENDMETHOD.
ENDCLASS.


CLASS ltcl_ctf_test IMPLEMENTATION.

  METHOD defaults.
    DATA(lo) = NEW zcl_bapi_ctf_dispatcher( ).
    cl_abap_unit_assert=>assert_equals(
      exp = 5000 act = lo->normalize_positive( iv_value = 0 iv_default = 5000 ) ).
  ENDMETHOD.

  METHOD calc_workers.
    DATA(lo) = NEW zcl_bapi_ctf_dispatcher( ).
    cl_abap_unit_assert=>assert_equals(
      exp = 3
      act = lo->calculate_workers( iv_docs_total = 12000 iv_worker_rows = 5000 iv_worker_max = 4 ) ).
  ENDMETHOD.

  METHOD parse_single_document.
    DATA(lv_json) =
      `{"bapi_name":"BAPI_PO_CREATE1","worker_threads":10,"worker_rows":5000,` &&
      `"heders_values":[{"value":"poheader","fields":[{"name":"vendor","value":"100000"}]}],` &&
      `"items_values":[]}`.
    DATA(lo)  = NEW zcl_bapi_ctf_dispatcher( ).
    DATA(ls)  = lo->parse_request( lv_json ).
    cl_abap_unit_assert=>assert_equals( exp = `BAPI_PO_CREATE1` act = ls-bapi_name ).
    cl_abap_unit_assert=>assert_equals( exp = 10   act = ls-worker_threads ).
    cl_abap_unit_assert=>assert_equals( exp = 5000 act = ls-worker_rows ).
    DATA(lt_docs) = lo->documents_from_request( ls ).
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
    DATA(lo)  = NEW zcl_bapi_ctf_dispatcher( ).
    DATA(ls)  = lo->parse_request( lv_json ).
    DATA(lt_docs) = lo->documents_from_request( ls ).
    cl_abap_unit_assert=>assert_equals( exp = 3 act = lines( lt_docs ) ).
  ENDMETHOD.

  METHOD dispatch_returns.
    ltc_ctf_stub=>gt_last_chunks = VALUE #( ).
    DATA(lv_json) =
      `{"bapi_name":"BAPI_TEST","worker_threads":2,"worker_rows":1,` &&
      `"documents":[` &&
        `{"heders_values":[],"items_values":[]},` &&
        `{"heders_values":[],"items_values":[]}` &&
      `]}`.
    DATA(lo) = NEW ltc_ctf_stub( ).
    DATA(ls) = lo->dispatch( lv_json ).
    cl_abap_unit_assert=>assert_equals( exp = `BAPI_TEST` act = ls-bapi_name ).
    cl_abap_unit_assert=>assert_equals( exp = 2 act = ls-accepted ).
    cl_abap_unit_assert=>assert_equals( exp = 2 act = ls-workers  ).
    cl_abap_unit_assert=>assert_equals( exp = 2 act = lines( ltc_ctf_stub=>gt_last_chunks ) ).
  ENDMETHOD.

ENDCLASS.
