"! ABAP Unit tests for /HDL/CL_ORDER_CLOSER.
"! No database, no BAPI: the BAPI facade is replaced by a test double.

CLASS ltd_bapi_double DEFINITION FOR TESTING.
  PUBLIC SECTION.
    INTERFACES /hdl/if_alm_order_bapi.

    " Behavior switches
    DATA mv_teco_success TYPE abap_bool VALUE abap_true.
    DATA mv_clsd_success TYPE abap_bool VALUE abap_true.
    DATA mv_dlfl_success TYPE abap_bool VALUE abap_true.
    DATA mv_srule_success TYPE abap_bool VALUE abap_true.

    " Call counters
    DATA mv_teco_calls     TYPE i.
    DATA mv_clsd_calls     TYPE i.
    DATA mv_dlfl_calls     TYPE i.
    DATA mv_srule_calls    TYPE i.
    DATA mv_commit_calls   TYPE i.
    DATA mv_rollback_calls TYPE i.

    " Last order received
    DATA mv_last_teco_order  TYPE aufnr.
    DATA mv_last_clsd_order  TYPE aufnr.
    DATA mv_last_dlfl_order  TYPE aufnr.
    DATA mv_last_srule_order TYPE aufnr.
    DATA mv_last_srule_kostl TYPE kostl.
ENDCLASS.

CLASS ltd_bapi_double IMPLEMENTATION.

  METHOD /hdl/if_alm_order_bapi~set_teco.
    mv_teco_calls       = mv_teco_calls + 1.
    mv_last_teco_order  = iv_orderid.
    rs_result-success   = mv_teco_success.
    IF mv_teco_success = abap_false.
      APPEND |[E ZTEST/001] Forced TECO failure for { iv_orderid }|
             TO rs_result-messages.
    ENDIF.
  ENDMETHOD.

  METHOD /hdl/if_alm_order_bapi~set_clsd.
    mv_clsd_calls       = mv_clsd_calls + 1.
    mv_last_clsd_order  = iv_orderid.
    rs_result-success   = mv_clsd_success.
    IF mv_clsd_success = abap_false.
      APPEND |[E ZTEST/002] Forced CLSD failure for { iv_orderid }|
             TO rs_result-messages.
    ENDIF.
  ENDMETHOD.

  METHOD /hdl/if_alm_order_bapi~set_dlfl.
    mv_dlfl_calls       = mv_dlfl_calls + 1.
    mv_last_dlfl_order  = iv_orderid.
    rs_result-success   = mv_dlfl_success.
    IF mv_dlfl_success = abap_false.
      APPEND |[E ZTEST/003] Forced DLFL failure for { iv_orderid }|
             TO rs_result-messages.
    ENDIF.
  ENDMETHOD.

  METHOD /hdl/if_alm_order_bapi~maintain_settlement_rule.
    mv_srule_calls       = mv_srule_calls + 1.
    mv_last_srule_order  = iv_orderid.
    mv_last_srule_kostl  = iv_kostl.
    rs_result-success    = mv_srule_success.
    IF mv_srule_success = abap_false.
      APPEND |[E ZTEST/004] Forced SRULE failure for { iv_orderid }|
             TO rs_result-messages.
    ENDIF.
  ENDMETHOD.

  METHOD /hdl/if_alm_order_bapi~commit.
    mv_commit_calls = mv_commit_calls + 1.
  ENDMETHOD.

  METHOD /hdl/if_alm_order_bapi~rollback.
    mv_rollback_calls = mv_rollback_calls + 1.
  ENDMETHOD.

ENDCLASS.


CLASS ltc_order_closer DEFINITION
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT
  FINAL.

  PRIVATE SECTION.
    DATA mo_bapi TYPE REF TO ltd_bapi_double.
    DATA mo_cut  TYPE REF TO /hdl/cl_order_closer.

    METHODS setup.

    " close_single_order
    METHODS close_success           FOR TESTING.
    METHODS close_teco_failure      FOR TESTING.
    METHODS close_clsd_failure      FOR TESTING.
    METHODS close_with_dlfl_success FOR TESTING.
    METHODS close_with_dlfl_failure FOR TESTING.

    " apply_status_filter
    METHODS filter_removes_closed   FOR TESTING.
    METHODS filter_keeps_open       FOR TESTING.
    METHODS filter_builds_status    FOR TESTING.

    " validate_eligibility
    METHODS eligibility_blocks_clsd FOR TESTING.
    METHODS eligibility_blocks_dlfl FOR TESTING.
    METHODS eligibility_keeps_open  FOR TESTING.
ENDCLASS.


CLASS ltc_order_closer IMPLEMENTATION.

  METHOD setup.
    mo_bapi = NEW ltd_bapi_double( ).
    mo_cut  = NEW /hdl/cl_order_closer( io_bapi = mo_bapi ).
  ENDMETHOD.

  "============================ close_single_order

  METHOD close_success.
    DATA(ls_order) = VALUE /hdl/cl_order_closer=>ty_order(
      aufnr = '000004000001' auart = 'PM01' ).

    DATA(ls_result) = mo_cut->close_single_order( ls_order ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-result            exp = 'SUCCESS' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_teco_calls      exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_clsd_calls      exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_commit_calls    exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_rollback_calls  exp = 0 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_last_teco_order exp = ls_order-aufnr ).
  ENDMETHOD.

  METHOD close_teco_failure.
    mo_bapi->mv_teco_success = abap_false.
    DATA(ls_order) = VALUE /hdl/cl_order_closer=>ty_order(
      aufnr = '000004000010' auart = 'PM01' ).

    DATA(ls_result) = mo_cut->close_single_order( ls_order ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-result           exp = 'ERROR' ).
    cl_abap_unit_assert=>assert_char_cp(
      act = ls_result-message          exp = '*Forced TECO failure*' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_clsd_calls     exp = 0 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_rollback_calls exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_commit_calls   exp = 0 ).
  ENDMETHOD.

  METHOD close_clsd_failure.
    mo_bapi->mv_clsd_success = abap_false.
    DATA(ls_order) = VALUE /hdl/cl_order_closer=>ty_order(
      aufnr = '000004000020' auart = 'PM01' ).

    DATA(ls_result) = mo_cut->close_single_order( ls_order ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-result           exp = 'ERROR' ).
    cl_abap_unit_assert=>assert_char_cp(
      act = ls_result-message          exp = '*Forced CLSD failure*' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_teco_calls     exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_clsd_calls     exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_rollback_calls exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_commit_calls   exp = 0 ).
  ENDMETHOD.

  METHOD close_with_dlfl_success.
    DATA(ls_order) = VALUE /hdl/cl_order_closer=>ty_order(
      aufnr = '000004000030' auart = 'PM01' ).

    DATA(ls_result) = mo_cut->close_single_order(
      is_order    = ls_order
      iv_set_dlfl = abap_true ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-result            exp = 'SUCCESS' ).
    cl_abap_unit_assert=>assert_char_cp(
      act = ls_result-message           exp = '*TECO, CLSD and DLFL*' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_teco_calls      exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_clsd_calls      exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_dlfl_calls      exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_commit_calls    exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_rollback_calls  exp = 0 ).
  ENDMETHOD.

  METHOD close_with_dlfl_failure.
    mo_bapi->mv_dlfl_success = abap_false.
    DATA(ls_order) = VALUE /hdl/cl_order_closer=>ty_order(
      aufnr = '000004000031' auart = 'PM01' ).

    DATA(ls_result) = mo_cut->close_single_order(
      is_order    = ls_order
      iv_set_dlfl = abap_true ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-result           exp = 'ERROR' ).
    cl_abap_unit_assert=>assert_char_cp(
      act = ls_result-message          exp = '*Forced DLFL failure*' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_teco_calls     exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_clsd_calls     exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_dlfl_calls     exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_commit_calls   exp = 0 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_rollback_calls exp = 1 ).
  ENDMETHOD.

  "============================ apply_status_filter

  METHOD filter_removes_closed.
    DATA lt_orders TYPE /hdl/cl_order_closer=>ty_orders.
    DATA lt_stats  TYPE /hdl/cl_order_closer=>ty_statuses.

    lt_orders = VALUE #(
      ( aufnr = '000004000001' auart = 'PM01' objnr = 'OR000000000004000001' )
      ( aufnr = '000004000002' auart = 'PM01' objnr = 'OR000000000004000002' ) ).

    lt_stats = VALUE #(
      ( objnr = 'OR000000000004000001' stat = 'I0002' txt30 = 'Released' )
      ( objnr = 'OR000000000004000002' stat = 'I0046' txt30 = 'CLSD' ) ).

    mo_cut->apply_status_filter(
      EXPORTING it_statuses = lt_stats
      CHANGING  ct_orders   = lt_orders ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_orders )      exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = lt_orders[ 1 ]-aufnr    exp = '000004000001' ).
  ENDMETHOD.

  METHOD filter_keeps_open.
    DATA lt_orders TYPE /hdl/cl_order_closer=>ty_orders.
    DATA lt_stats  TYPE /hdl/cl_order_closer=>ty_statuses.

    lt_orders = VALUE #(
      ( aufnr = '000004000003' auart = 'PM01' objnr = 'OR000000000004000003' ) ).
    lt_stats = VALUE #(
      ( objnr = 'OR000000000004000003' stat = 'I0002' txt30 = 'Released' ) ).

    mo_cut->apply_status_filter(
      EXPORTING it_statuses = lt_stats
      CHANGING  ct_orders   = lt_orders ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_orders ) exp = 1 ).
  ENDMETHOD.

  METHOD filter_builds_status.
    DATA lt_orders TYPE /hdl/cl_order_closer=>ty_orders.
    DATA lt_stats  TYPE /hdl/cl_order_closer=>ty_statuses.

    lt_orders = VALUE #(
      ( aufnr = '000004000004' auart = 'PM01' objnr = 'OR000000000004000004' ) ).
    lt_stats = VALUE #(
      ( objnr = 'OR000000000004000004' stat = 'I0001' txt30 = 'Created' )
      ( objnr = 'OR000000000004000004' stat = 'I0002' txt30 = 'Released' ) ).

    mo_cut->apply_status_filter(
      EXPORTING it_statuses = lt_stats
      CHANGING  ct_orders   = lt_orders ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_orders[ 1 ]-cur_status
      exp = 'Created, Released' ).
  ENDMETHOD.

  "============================ validate_eligibility

  METHOD eligibility_blocks_clsd.
    DATA lt_orders  TYPE /hdl/cl_order_closer=>ty_orders.
    DATA lt_stats   TYPE /hdl/cl_order_closer=>ty_statuses.
    DATA lt_results TYPE /hdl/cl_order_closer=>ty_results.

    lt_orders = VALUE #(
      ( aufnr = '000004000005' auart = 'PM01' objnr = 'OR000000000004000005' ) ).
    lt_stats = VALUE #(
      ( objnr = 'OR000000000004000005' stat = 'I0046' txt30 = 'CLSD' ) ).

    mo_cut->validate_eligibility(
      EXPORTING it_statuses = lt_stats
      CHANGING  ct_orders   = lt_orders
                ct_results  = lt_results ).

    cl_abap_unit_assert=>assert_initial( act = lt_orders ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_results ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = lt_results[ 1 ]-result exp = 'ERROR' ).
    cl_abap_unit_assert=>assert_char_cp(
      act = lt_results[ 1 ]-message exp = '*CLSD*' ).
  ENDMETHOD.

  METHOD eligibility_blocks_dlfl.
    DATA lt_orders  TYPE /hdl/cl_order_closer=>ty_orders.
    DATA lt_stats   TYPE /hdl/cl_order_closer=>ty_statuses.
    DATA lt_results TYPE /hdl/cl_order_closer=>ty_results.

    lt_orders = VALUE #(
      ( aufnr = '000004000006' auart = 'PM01' objnr = 'OR000000000004000006' ) ).
    lt_stats = VALUE #(
      ( objnr = 'OR000000000004000006' stat = 'I0076' txt30 = 'DLFL' ) ).

    mo_cut->validate_eligibility(
      EXPORTING it_statuses = lt_stats
      CHANGING  ct_orders   = lt_orders
                ct_results  = lt_results ).

    cl_abap_unit_assert=>assert_initial( act = lt_orders ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_results ) exp = 1 ).
    cl_abap_unit_assert=>assert_char_cp(
      act = lt_results[ 1 ]-message exp = '*deletion flag*' ).
  ENDMETHOD.

  METHOD eligibility_keeps_open.
    DATA lt_orders  TYPE /hdl/cl_order_closer=>ty_orders.
    DATA lt_stats   TYPE /hdl/cl_order_closer=>ty_statuses.
    DATA lt_results TYPE /hdl/cl_order_closer=>ty_results.

    lt_orders = VALUE #(
      ( aufnr = '000004000007' auart = 'PM01' objnr = 'OR000000000004000007' ) ).
    lt_stats = VALUE #(
      ( objnr = 'OR000000000004000007' stat = 'I0002' txt30 = 'Released' ) ).

    mo_cut->validate_eligibility(
      EXPORTING it_statuses = lt_stats
      CHANGING  ct_orders   = lt_orders
                ct_results  = lt_results ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_orders ) exp = 1 ).
    cl_abap_unit_assert=>assert_initial( act = lt_results ).
  ENDMETHOD.

ENDCLASS.
