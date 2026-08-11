"! Unit tests for zcl_bapi_hyb_dispatcher and zcl_bapi_hyb_lex_splitter.
"! Async dispatch is intercepted by a test subclass to keep bgPF out of
"! the test harness.
CLASS ltcl_hyb_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS defaults              FOR TESTING.
    METHODS calc_workers          FOR TESTING.
    METHODS parse_header_only     FOR TESTING RAISING cx_static_check.
    METHODS parse_header_ignores_arrays FOR TESTING RAISING cx_static_check.
    METHODS lex_split_basic       FOR TESTING.
    METHODS lex_split_nested      FOR TESTING.
    METHODS dispatch_chunk_mode   FOR TESTING RAISING cx_static_check.
    METHODS dispatch_bulk_splits  FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_hyb_stub DEFINITION INHERITING FROM zcl_bapi_hyb_dispatcher.
  PUBLIC SECTION.
    CLASS-DATA gt_last_chunks TYPE string_table.
  PROTECTED SECTION.
    METHODS dispatch_chunks REDEFINITION.
ENDCLASS.

CLASS ltc_hyb_stub IMPLEMENTATION.
  METHOD dispatch_chunks.
    gt_last_chunks = it_chunks.
  ENDMETHOD.
ENDCLASS.


CLASS ltcl_hyb_test IMPLEMENTATION.

  METHOD defaults.
    DATA(lo) = NEW zcl_bapi_hyb_dispatcher( ).
    cl_abap_unit_assert=>assert_equals(
      exp = 100
      act = lo->normalize_positive( iv_value = 0 iv_default = 100 ) ).
  ENDMETHOD.

  METHOD calc_workers.
    DATA(lo) = NEW zcl_bapi_hyb_dispatcher( ).
    cl_abap_unit_assert=>assert_equals(
      exp = 3
      act = lo->calculate_workers( iv_docs_total = 250 iv_worker_rows = 100 iv_worker_max = 4 ) ).
  ENDMETHOD.

  METHOD parse_header_only.
    DATA(lv_json) =
      `{"bapi_name":"BAPI_PO_CREATE1","mode":"async","kind":"bulk",` &&
      `"worker_threads":8,"worker_rows":100,"documents":[{"a":1},{"b":2}]}`.
    DATA(lo) = NEW zcl_bapi_hyb_dispatcher( ).
    DATA(ls) = lo->parse_header( lv_json ).
    cl_abap_unit_assert=>assert_equals( exp = `BAPI_PO_CREATE1` act = ls-bapi_name ).
    cl_abap_unit_assert=>assert_equals( exp = `async`           act = ls-mode ).
    cl_abap_unit_assert=>assert_equals( exp = `bulk`            act = ls-kind ).
    cl_abap_unit_assert=>assert_equals( exp = 8   act = ls-worker_threads ).
    cl_abap_unit_assert=>assert_equals( exp = 100 act = ls-worker_rows ).
  ENDMETHOD.

  METHOD parse_header_ignores_arrays.
* Arrays/objects preceding the trailing scalars must not confuse the trim.
    DATA(lv_json) =
      `{"heders_values":[{"value":"X","fields":[]}],` &&
      `"documents":[{"a":1}],` &&
      `"bapi_name":"BAPI_TEST","worker_threads":2}`.
    DATA(lo) = NEW zcl_bapi_hyb_dispatcher( ).
    DATA(ls) = lo->parse_header( lv_json ).
    cl_abap_unit_assert=>assert_equals( exp = `BAPI_TEST` act = ls-bapi_name ).
    cl_abap_unit_assert=>assert_equals( exp = 2           act = ls-worker_threads ).
  ENDMETHOD.

  METHOD lex_split_basic.
    DATA(lv_json) =
      `{"bapi_name":"X","documents":[` &&
      `{"heders_values":[],"items_values":[]},` &&
      `{"heders_values":[],"items_values":[]},` &&
      `{"heders_values":[],"items_values":[]}` &&
      `]}`.
    DATA(lo) = NEW zcl_bapi_hyb_lex_splitter( ).
    DATA lt_chunks TYPE string_table.
    DATA lv_count  TYPE i.
    lo->split( EXPORTING iv_json = lv_json iv_worker_rows = 2
               IMPORTING ev_doc_count = lv_count et_chunks = lt_chunks ).
    cl_abap_unit_assert=>assert_equals( exp = 3 act = lv_count ).
    cl_abap_unit_assert=>assert_equals( exp = 2 act = lines( lt_chunks ) ).
  ENDMETHOD.

  METHOD lex_split_nested.
    DATA(lv_json) =
      `{"documents":[` &&
      `{"a":{"b":"has \"},{\" tricky"},"items_values":[]},` &&
      `{"a":{"b":"ok"},"items_values":[]}` &&
      `]}`.
    DATA(lo) = NEW zcl_bapi_hyb_lex_splitter( ).
    DATA lt_chunks TYPE string_table.
    DATA lv_count  TYPE i.
    lo->split( EXPORTING iv_json = lv_json iv_worker_rows = 5
               IMPORTING ev_doc_count = lv_count et_chunks = lt_chunks ).
    cl_abap_unit_assert=>assert_equals( exp = 2 act = lv_count ).
  ENDMETHOD.

  METHOD dispatch_chunk_mode.
    ltc_hyb_stub=>gt_last_chunks = VALUE #( ).
    DATA(lv_json) = `{"bapi_name":"BAPI_TEST","kind":"chunk",` &&
                    `"heders_values":[],"items_values":[]}`.
    DATA(lo) = NEW ltc_hyb_stub( ).
    DATA(ls) = lo->dispatch( lv_json ).
    cl_abap_unit_assert=>assert_equals( exp = `BAPI_TEST` act = ls-bapi_name ).
    cl_abap_unit_assert=>assert_equals( exp = 1 act = ls-workers ).
    cl_abap_unit_assert=>assert_equals( exp = 1 act = lines( ltc_hyb_stub=>gt_last_chunks ) ).
  ENDMETHOD.

  METHOD dispatch_bulk_splits.
    ltc_hyb_stub=>gt_last_chunks = VALUE #( ).
    DATA(lv_json) =
      `{"bapi_name":"BAPI_TEST","kind":"bulk","worker_threads":4,"worker_rows":1,` &&
      `"documents":[` &&
      `{"heders_values":[],"items_values":[]},` &&
      `{"heders_values":[],"items_values":[]}` &&
      `]}`.
    DATA(lo) = NEW ltc_hyb_stub( ).
    DATA(ls) = lo->dispatch( lv_json ).
    cl_abap_unit_assert=>assert_equals( exp = 2 act = ls-accepted ).
    cl_abap_unit_assert=>assert_equals( exp = 2 act = ls-workers  ).
    cl_abap_unit_assert=>assert_equals( exp = 2 act = lines( ltc_hyb_stub=>gt_last_chunks ) ).
  ENDMETHOD.

ENDCLASS.
