"! Unit tests for zcl_http_bapi_hyb_dispatcher and zcl_http_bapi_hyb_lex_splitter.
"! The RFC / inline dispatch is intercepted by a test subclass so that the
"! tests exercise only the pure logic (header parse, split, worker calc).

CLASS ltc_hyb_stub DEFINITION INHERITING FROM zcl_http_bapi_hyb_dispatcher
  FOR TESTING.

  PUBLIC SECTION.
    DATA mv_bapi     TYPE string.
    DATA mv_mode     TYPE string.
    DATA mt_captured TYPE string_table.

  PROTECTED SECTION.
    METHODS dispatch_chunks REDEFINITION.
ENDCLASS.


CLASS ltc_hyb_stub IMPLEMENTATION.
  METHOD dispatch_chunks.
    mv_bapi     = iv_bapi_name.
    mv_mode     = iv_mode.
    mt_captured = it_chunks.
  ENDMETHOD.
ENDCLASS.


CLASS ltcl_hyb_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS setup.

    METHODS defaults_when_missing          FOR TESTING.
    METHODS keeps_provided_worker_values   FOR TESTING.
    METHODS calc_workers_single_doc        FOR TESTING.
    METHODS calc_workers_capped_by_max     FOR TESTING.
    METHODS calc_workers_uses_needed       FOR TESTING.
    METHODS parse_header_only              FOR TESTING RAISING cx_static_check.
    METHODS parse_header_ignores_arrays    FOR TESTING RAISING cx_static_check.
    METHODS lex_split_basic                FOR TESTING.
    METHODS lex_split_nested               FOR TESTING.
    METHODS dispatch_chunk_mode            FOR TESTING RAISING cx_static_check.
    METHODS dispatch_bulk_splits           FOR TESTING RAISING cx_static_check.
    METHODS dispatch_missing_bapi_raises   FOR TESTING RAISING cx_static_check.
    METHODS build_response_shape           FOR TESTING.

    DATA mo_cut TYPE REF TO ltc_hyb_stub.
ENDCLASS.


CLASS ltcl_hyb_test IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW ltc_hyb_stub( ).
  ENDMETHOD.

  METHOD defaults_when_missing.
    cl_abap_unit_assert=>assert_equals(
      exp = zcl_http_bapi_hyb_dispatcher=>c_default_workers
      act = mo_cut->normalize_positive( iv_value   = 0
                                        iv_default = zcl_http_bapi_hyb_dispatcher=>c_default_workers ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = zcl_http_bapi_hyb_dispatcher=>c_default_rows
      act = mo_cut->normalize_positive( iv_value   = -5
                                        iv_default = zcl_http_bapi_hyb_dispatcher=>c_default_rows ) ).
  ENDMETHOD.

  METHOD keeps_provided_worker_values.
    cl_abap_unit_assert=>assert_equals(
      exp = 10
      act = mo_cut->normalize_positive( iv_value = 10 iv_default = 4 ) ).
  ENDMETHOD.

  METHOD calc_workers_single_doc.
    cl_abap_unit_assert=>assert_equals(
      exp = 1
      act = mo_cut->calculate_workers( iv_docs_total  = 1
                                       iv_worker_rows = 5000
                                       iv_worker_max  = 10 ) ).
  ENDMETHOD.

  METHOD calc_workers_capped_by_max.
    " 100000 / 5000 = 20 needed, capped at 4.
    cl_abap_unit_assert=>assert_equals(
      exp = 4
      act = mo_cut->calculate_workers( iv_docs_total  = 100000
                                       iv_worker_rows = 5000
                                       iv_worker_max  = 4 ) ).
  ENDMETHOD.

  METHOD calc_workers_uses_needed.
    " 12000 / 5000 = ceil(2.4) = 3, below max=10.
    cl_abap_unit_assert=>assert_equals(
      exp = 3
      act = mo_cut->calculate_workers( iv_docs_total  = 12000
                                       iv_worker_rows = 5000
                                       iv_worker_max  = 10 ) ).
  ENDMETHOD.

  METHOD parse_header_only.
    DATA(lv_json) =
      `{"bapi_name":"BAPI_PO_CREATE1","mode":"async","kind":"bulk",` &&
      `"worker_threads":8,"worker_rows":100,"documents":[{"a":1},{"b":2}]}`.

    DATA(ls) = mo_cut->parse_header( lv_json ).
    cl_abap_unit_assert=>assert_equals( exp = `BAPI_PO_CREATE1` act = ls-bapi_name ).
    cl_abap_unit_assert=>assert_equals( exp = `async`           act = ls-mode ).
    cl_abap_unit_assert=>assert_equals( exp = `bulk`            act = ls-kind ).
    cl_abap_unit_assert=>assert_equals( exp = 8                 act = ls-worker_threads ).
    cl_abap_unit_assert=>assert_equals( exp = 100               act = ls-worker_rows ).
  ENDMETHOD.

  METHOD parse_header_ignores_arrays.
* Arrays/objects preceding the trailing scalars must not confuse the trim.
    DATA(lv_json) =
      `{"heders_values":[{"value":"X","fields":[]}],` &&
      `"documents":[{"a":1}],` &&
      `"bapi_name":"BAPI_TEST","worker_threads":2}`.

    DATA(ls) = mo_cut->parse_header( lv_json ).
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

    DATA(lo) = NEW zcl_http_bapi_hyb_lex_splitter( ).
    DATA lt_chunks TYPE string_table.
    DATA lv_count  TYPE i.
    lo->split( EXPORTING iv_json        = lv_json
                         iv_worker_rows = 2
               IMPORTING ev_doc_count   = lv_count
                         et_chunks      = lt_chunks ).

    cl_abap_unit_assert=>assert_equals( exp = 3 act = lv_count ).
    cl_abap_unit_assert=>assert_equals( exp = 2 act = lines( lt_chunks ) ).
  ENDMETHOD.

  METHOD lex_split_nested.
    DATA(lv_json) =
      `{"documents":[` &&
      `{"a":{"b":"has \"},{\" tricky"},"items_values":[]},` &&
      `{"a":{"b":"ok"},"items_values":[]}` &&
      `]}`.

    DATA(lo) = NEW zcl_http_bapi_hyb_lex_splitter( ).
    DATA lt_chunks TYPE string_table.
    DATA lv_count  TYPE i.
    lo->split( EXPORTING iv_json        = lv_json
                         iv_worker_rows = 5
               IMPORTING ev_doc_count   = lv_count
                         et_chunks      = lt_chunks ).

    cl_abap_unit_assert=>assert_equals( exp = 2 act = lv_count ).
  ENDMETHOD.

  METHOD dispatch_chunk_mode.
    DATA(lv_json) = `{"bapi_name":"BAPI_TEST","kind":"chunk",` &&
                    `"heders_values":[],"items_values":[]}`.

    DATA(ls) = mo_cut->dispatch( lv_json ).

    cl_abap_unit_assert=>assert_equals( exp = `BAPI_TEST` act = ls-bapi_name ).
    cl_abap_unit_assert=>assert_equals( exp = 1           act = ls-workers ).
    cl_abap_unit_assert=>assert_equals( exp = `chunk`     act = ls-kind ).
    cl_abap_unit_assert=>assert_equals( exp = 1           act = lines( mo_cut->mt_captured ) ).
    cl_abap_unit_assert=>assert_equals( exp = `BAPI_TEST` act = mo_cut->mv_bapi ).
  ENDMETHOD.

  METHOD dispatch_bulk_splits.
    DATA(lv_json) =
      `{"bapi_name":"BAPI_TEST","kind":"bulk","worker_threads":4,"worker_rows":1,` &&
      `"documents":[` &&
      `{"heders_values":[],"items_values":[]},` &&
      `{"heders_values":[],"items_values":[]}` &&
      `]}`.

    DATA(ls) = mo_cut->dispatch( lv_json ).

    cl_abap_unit_assert=>assert_equals( exp = 2       act = ls-accepted ).
    cl_abap_unit_assert=>assert_equals( exp = 2       act = ls-workers ).
    cl_abap_unit_assert=>assert_equals( exp = `bulk`  act = ls-kind ).
    cl_abap_unit_assert=>assert_equals( exp = 2       act = lines( mo_cut->mt_captured ) ).
  ENDMETHOD.

  METHOD dispatch_missing_bapi_raises.
    TRY.
        mo_cut->dispatch( `{"mode":"async"}` ).
        cl_abap_unit_assert=>fail( msg = `Expected cx_parameter_invalid_range` ).
      CATCH cx_parameter_invalid_range ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD build_response_shape.
    DATA(lv) = mo_cut->build_response( iv_bapi_name = `BAPI_PO_CREATE1`
                                       iv_accepted  = 12000
                                       iv_workers   = 3
                                       iv_mode      = `async`
                                       iv_kind      = `bulk` ).

    cl_abap_unit_assert=>assert_char_cp( exp = `*"bapi_name":"BAPI_PO_CREATE1"*` act = lv ).
    cl_abap_unit_assert=>assert_char_cp( exp = `*"accepted":12000*`              act = lv ).
    cl_abap_unit_assert=>assert_char_cp( exp = `*"workers":3*`                   act = lv ).
    cl_abap_unit_assert=>assert_char_cp( exp = `*"mode":"async"*`                act = lv ).
    cl_abap_unit_assert=>assert_char_cp( exp = `*"kind":"bulk"*`                 act = lv ).
  ENDMETHOD.

ENDCLASS.
