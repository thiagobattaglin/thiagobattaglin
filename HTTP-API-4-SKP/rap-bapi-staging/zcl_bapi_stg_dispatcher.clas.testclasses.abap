"! Unit tests for zcl_bapi_stg_dispatcher.
"! Persistence and dispatch are stubbed to keep the tests hermetic.
CLASS ltcl_stg_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS defaults           FOR TESTING.
    METHODS calc_workers       FOR TESTING.
    METHODS split_ranges_basic FOR TESTING.
    METHODS split_ranges_uneven FOR TESTING.
ENDCLASS.


CLASS ltcl_stg_test IMPLEMENTATION.

  METHOD defaults.
    DATA(lo) = NEW zcl_bapi_stg_dispatcher( ).
    cl_abap_unit_assert=>assert_equals(
      exp = 5000 act = lo->normalize_positive( iv_value = 0 iv_default = 5000 ) ).
  ENDMETHOD.

  METHOD calc_workers.
    DATA(lo) = NEW zcl_bapi_stg_dispatcher( ).
    cl_abap_unit_assert=>assert_equals(
      exp = 3
      act = lo->calculate_workers( iv_docs_total = 12000 iv_worker_rows = 5000 iv_worker_max = 4 ) ).
  ENDMETHOD.

  METHOD split_ranges_basic.
    DATA(lo) = NEW zcl_bapi_stg_dispatcher( ).
    DATA(lt) = lo->split_ranges( iv_docs_total = 10 iv_workers = 2 ).
    cl_abap_unit_assert=>assert_equals( exp = 2 act = lines( lt ) ).
    cl_abap_unit_assert=>assert_equals( exp = 1  act = lt[ 1 ]-doc_from ).
    cl_abap_unit_assert=>assert_equals( exp = 5  act = lt[ 1 ]-doc_to   ).
    cl_abap_unit_assert=>assert_equals( exp = 6  act = lt[ 2 ]-doc_from ).
    cl_abap_unit_assert=>assert_equals( exp = 10 act = lt[ 2 ]-doc_to   ).
  ENDMETHOD.

  METHOD split_ranges_uneven.
    DATA(lo) = NEW zcl_bapi_stg_dispatcher( ).
    DATA(lt) = lo->split_ranges( iv_docs_total = 7 iv_workers = 3 ).
    cl_abap_unit_assert=>assert_equals( exp = 3 act = lines( lt ) ).
    cl_abap_unit_assert=>assert_equals( exp = 7 act = lt[ 3 ]-doc_to ).
  ENDMETHOD.

ENDCLASS.
