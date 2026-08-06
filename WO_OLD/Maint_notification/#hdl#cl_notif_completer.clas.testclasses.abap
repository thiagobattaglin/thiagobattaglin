"! ABAP Unit tests for /HDL/CL_NOTIF_COMPLETER.
"! No database, no BAPI: the BAPI facade is replaced by a test double.

CLASS ltd_bapi_double DEFINITION FOR TESTING.
  PUBLIC SECTION.
    INTERFACES /hdl/if_alm_notif_bapi.

    DATA mv_progress_success TYPE abap_bool VALUE abap_true.
    DATA mv_complete_success TYPE abap_bool VALUE abap_true.

    DATA mv_progress_calls   TYPE i.
    DATA mv_complete_calls   TYPE i.
    DATA mv_commit_calls     TYPE i.
    DATA mv_rollback_calls   TYPE i.

    DATA mv_last_progress    TYPE qmnum.
    DATA mv_last_complete    TYPE qmnum.
ENDCLASS.

CLASS ltd_bapi_double IMPLEMENTATION.

  METHOD /hdl/if_alm_notif_bapi~put_in_progress.
    mv_progress_calls  = mv_progress_calls + 1.
    mv_last_progress   = iv_notif_no.
    rs_result-success  = mv_progress_success.
    IF mv_progress_success = abap_false.
      APPEND |[E ZTEST/010] Forced PUT_IN_PROGRESS failure for { iv_notif_no }|
             TO rs_result-messages.
    ENDIF.
  ENDMETHOD.

  METHOD /hdl/if_alm_notif_bapi~complete.
    mv_complete_calls  = mv_complete_calls + 1.
    mv_last_complete   = iv_notif_no.
    rs_result-success  = mv_complete_success.
    IF mv_complete_success = abap_false.
      APPEND |[E ZTEST/011] Forced COMPLETE failure for { iv_notif_no }|
             TO rs_result-messages.
    ENDIF.
  ENDMETHOD.

  METHOD /hdl/if_alm_notif_bapi~commit.
    mv_commit_calls = mv_commit_calls + 1.
  ENDMETHOD.

  METHOD /hdl/if_alm_notif_bapi~rollback.
    mv_rollback_calls = mv_rollback_calls + 1.
  ENDMETHOD.

ENDCLASS.


CLASS ltc_notif_completer DEFINITION
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT
  FINAL.

  PRIVATE SECTION.
    DATA mo_bapi TYPE REF TO ltd_bapi_double.
    DATA mo_cut  TYPE REF TO /hdl/cl_notif_completer.

    METHODS setup.

    " complete_single
    METHODS complete_success            FOR TESTING.
    METHODS complete_progress_failure   FOR TESTING.
    METHODS complete_complete_failure   FOR TESTING.

    " apply_status_filter
    METHODS filter_removes_noco         FOR TESTING.
    METHODS filter_removes_dlfl         FOR TESTING.
    METHODS filter_keeps_open           FOR TESTING.
    METHODS filter_builds_status        FOR TESTING.
ENDCLASS.


CLASS ltc_notif_completer IMPLEMENTATION.

  METHOD setup.
    mo_bapi = NEW ltd_bapi_double( ).
    mo_cut  = NEW /hdl/cl_notif_completer( io_bapi = mo_bapi ).
  ENDMETHOD.

  "============================ complete_single

  METHOD complete_success.
    DATA(ls_notif) = VALUE /hdl/cl_notif_completer=>ty_notif(
      qmnum = '000010000001' qmart = 'M1' ).

    DATA(ls_result) = mo_cut->complete_single( ls_notif ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-result            exp = 'SUCCESS' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_progress_calls  exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_complete_calls  exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_commit_calls    exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_rollback_calls  exp = 0 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_last_complete   exp = ls_notif-qmnum ).
  ENDMETHOD.

  METHOD complete_progress_failure.
    mo_bapi->mv_progress_success = abap_false.
    DATA(ls_notif) = VALUE /hdl/cl_notif_completer=>ty_notif(
      qmnum = '000010000010' qmart = 'M1' ).

    DATA(ls_result) = mo_cut->complete_single( ls_notif ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-result            exp = 'ERROR' ).
    cl_abap_unit_assert=>assert_char_cp(
      act = ls_result-message           exp = '*Forced PUT_IN_PROGRESS failure*' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_complete_calls  exp = 0 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_commit_calls    exp = 0 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_rollback_calls  exp = 1 ).
  ENDMETHOD.

  METHOD complete_complete_failure.
    mo_bapi->mv_complete_success = abap_false.
    DATA(ls_notif) = VALUE /hdl/cl_notif_completer=>ty_notif(
      qmnum = '000010000020' qmart = 'M1' ).

    DATA(ls_result) = mo_cut->complete_single( ls_notif ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-result            exp = 'ERROR' ).
    cl_abap_unit_assert=>assert_char_cp(
      act = ls_result-message           exp = '*Forced COMPLETE failure*' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_progress_calls  exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_complete_calls  exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_commit_calls    exp = 0 ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_bapi->mv_rollback_calls  exp = 1 ).
  ENDMETHOD.

  "============================ apply_status_filter

  METHOD filter_removes_noco.
    DATA lt_notifs  TYPE /hdl/cl_notif_completer=>ty_notifs.
    DATA lt_stats   TYPE /hdl/cl_notif_completer=>ty_statuses.
    DATA lt_results TYPE /hdl/cl_notif_completer=>ty_results.

    lt_notifs = VALUE #(
      ( qmnum = '000010000100' qmart = 'M1' objnr = 'QM000000000010000100' ) ).
    lt_stats = VALUE #(
      ( objnr = 'QM000000000010000100' stat = 'I0076' txt30 = 'NOCO' ) ).

    mo_cut->apply_status_filter(
      EXPORTING it_statuses = lt_stats
      CHANGING  ct_notifs   = lt_notifs
                ct_results  = lt_results ).

    cl_abap_unit_assert=>assert_initial( act = lt_notifs ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_results ) exp = 1 ).
    cl_abap_unit_assert=>assert_char_cp(
      act = lt_results[ 1 ]-message exp = '*already completed*' ).
  ENDMETHOD.

  METHOD filter_removes_dlfl.
    DATA lt_notifs  TYPE /hdl/cl_notif_completer=>ty_notifs.
    DATA lt_stats   TYPE /hdl/cl_notif_completer=>ty_statuses.
    DATA lt_results TYPE /hdl/cl_notif_completer=>ty_results.

    lt_notifs = VALUE #(
      ( qmnum = '000010000101' qmart = 'M1' objnr = 'QM000000000010000101' ) ).
    lt_stats = VALUE #(
      ( objnr = 'QM000000000010000101' stat = 'I0320' txt30 = 'DLFL' ) ).

    mo_cut->apply_status_filter(
      EXPORTING it_statuses = lt_stats
      CHANGING  ct_notifs   = lt_notifs
                ct_results  = lt_results ).

    cl_abap_unit_assert=>assert_initial( act = lt_notifs ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_results ) exp = 1 ).
    cl_abap_unit_assert=>assert_char_cp(
      act = lt_results[ 1 ]-message exp = '*deletion flag*' ).
  ENDMETHOD.

  METHOD filter_keeps_open.
    DATA lt_notifs  TYPE /hdl/cl_notif_completer=>ty_notifs.
    DATA lt_stats   TYPE /hdl/cl_notif_completer=>ty_statuses.
    DATA lt_results TYPE /hdl/cl_notif_completer=>ty_results.

    lt_notifs = VALUE #(
      ( qmnum = '000010000102' qmart = 'M1' objnr = 'QM000000000010000102' ) ).
    lt_stats = VALUE #(
      ( objnr = 'QM000000000010000102' stat = 'I0072' txt30 = 'OSNO' ) ).

    mo_cut->apply_status_filter(
      EXPORTING it_statuses = lt_stats
      CHANGING  ct_notifs   = lt_notifs
                ct_results  = lt_results ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_notifs ) exp = 1 ).
    cl_abap_unit_assert=>assert_initial( act = lt_results ).
  ENDMETHOD.

  METHOD filter_builds_status.
    DATA lt_notifs  TYPE /hdl/cl_notif_completer=>ty_notifs.
    DATA lt_stats   TYPE /hdl/cl_notif_completer=>ty_statuses.
    DATA lt_results TYPE /hdl/cl_notif_completer=>ty_results.

    lt_notifs = VALUE #(
      ( qmnum = '000010000103' qmart = 'M1' objnr = 'QM000000000010000103' ) ).
    lt_stats = VALUE #(
      ( objnr = 'QM000000000010000103' stat = 'I0072' txt30 = 'OSNO' )
      ( objnr = 'QM000000000010000103' stat = 'I0073' txt30 = 'IARB' ) ).

    mo_cut->apply_status_filter(
      EXPORTING it_statuses = lt_stats
      CHANGING  ct_notifs   = lt_notifs
                ct_results  = lt_results ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_notifs[ 1 ]-cur_status
      exp = 'OSNO, IARB' ).
  ENDMETHOD.

ENDCLASS.
