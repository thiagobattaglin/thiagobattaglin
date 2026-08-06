"! ABAP Unit tests for /HDL/CL_ORDER_SETTLEMENT.

CLASS ltd_bapi_double DEFINITION FOR TESTING.
  PUBLIC SECTION.
    INTERFACES /hdl/if_alm_order_bapi.

    DATA mv_srule_success  TYPE abap_bool VALUE abap_true.
    DATA mv_srule_calls    TYPE i.
    DATA mv_commit_calls   TYPE i.
    DATA mv_rollback_calls TYPE i.
    DATA mv_last_order     TYPE aufnr.
    DATA mv_last_kostl     TYPE kostl.
ENDCLASS.

CLASS ltd_bapi_double IMPLEMENTATION.

  METHOD /hdl/if_alm_order_bapi~set_teco.
    rs_result-success = abap_true.
  ENDMETHOD.

  METHOD /hdl/if_alm_order_bapi~set_clsd.
    rs_result-success = abap_true.
  ENDMETHOD.

  METHOD /hdl/if_alm_order_bapi~set_dlfl.
    rs_result-success = abap_true.
  ENDMETHOD.

  METHOD /hdl/if_alm_order_bapi~maintain_settlement_rule.
    mv_srule_calls    = mv_srule_calls + 1.
    mv_last_order     = iv_orderid.
    mv_last_kostl     = iv_kostl.
    rs_result-success = mv_srule_success.
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


CLASS ltc_order_settlement DEFINITION
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT
  FINAL.

  PRIVATE SECTION.
    DATA mo_bapi TYPE REF TO ltd_bapi_double.
    DATA mo_cut  TYPE REF TO /hdl/cl_order_settlement.

    METHODS setup.

    METHODS process_creates_srule       FOR TESTING.
    METHODS process_skips_missing_kostl FOR TESTING.
    METHODS process_handles_bapi_error  FOR TESTING.
ENDCLASS.


CLASS ltc_order_settlement IMPLEMENTATION.

  METHOD setup.
    mo_bapi = NEW ltd_bapi_double( ).
    mo_cut  = NEW /hdl/cl_order_settlement( io_bapi = mo_bapi ).
  ENDMETHOD.

  METHOD process_creates_srule.
    DATA(ls_order) = VALUE /hdl/cl_order_settlement=>ty_order(
      aufnr = '000004000100' auart = 'PM01' kostl = '0000001000' ).

    DATA(ls_result) = mo_cut->process_single( ls_order ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-result           exp = 'SUCCESS' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_srule_calls    exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_commit_calls   exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_rollback_calls exp = 0 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_last_order     exp = ls_order-aufnr ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_last_kostl     exp = ls_order-kostl ).
  ENDMETHOD.

  METHOD process_skips_missing_kostl.
    DATA(ls_order) = VALUE /hdl/cl_order_settlement=>ty_order(
      aufnr = '000004000101' auart = 'PM01' kostl = '' ).

    DATA(ls_result) = mo_cut->process_single( ls_order ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-result           exp = 'ERROR' ).
    cl_abap_unit_assert=>assert_char_cp(
      act = ls_result-message          exp = '*Cost center not found*' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_srule_calls    exp = 0 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_commit_calls   exp = 0 ).
  ENDMETHOD.

  METHOD process_handles_bapi_error.
    mo_bapi->mv_srule_success = abap_false.
    DATA(ls_order) = VALUE /hdl/cl_order_settlement=>ty_order(
      aufnr = '000004000102' auart = 'PM01' kostl = '0000001000' ).

    DATA(ls_result) = mo_cut->process_single( ls_order ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-result           exp = 'ERROR' ).
    cl_abap_unit_assert=>assert_char_cp(
      act = ls_result-message          exp = '*Forced SRULE failure*' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_srule_calls    exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_rollback_calls exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_commit_calls   exp = 0 ).
  ENDMETHOD.

ENDCLASS.
