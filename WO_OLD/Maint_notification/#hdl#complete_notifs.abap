REPORT /hdl/complete_notifs.

************************************************************************
* Complete (NOCO) Maintenance Notifications in mass mode.
*
* Useful after a Migration Cockpit load of PM notifications carrying
* historical data: puts each one in process and immediately completes
* it (status NOCO / I0076). No CO/FI impact.
*
* Thin shell. All business logic lives in the global classes:
*   - /HDL/CL_NOTIF_COMPLETER         (orchestration + pure logic)
*   - /HDL/CL_NOTIF_COMPLETE_WORKER   (parallel worker)
*   - /HDL/CL_ALM_NOTIF_BAPI          (real BAPI facade)
*   - /HDL/IF_ALM_NOTIF_BAPI          (facade interface, for DI/tests)
*   - /HDL/CX_NOTIF_COMPLETE          (custom exception)
*
* Unit tests: local test classes of /HDL/CL_NOTIF_COMPLETER.
************************************************************************

TABLES qmel.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS s_qmnum FOR qmel-qmnum.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS p_test AS CHECKBOX DEFAULT abap_true.
SELECTION-SCREEN END OF BLOCK b2.

START-OF-SELECTION.
  DATA(lt_ranges) = VALUE /hdl/cl_notif_completer=>ty_qmnum_ranges(
    FOR <ls> IN s_qmnum[]
      ( sign   = <ls>-sign
        option = <ls>-option
        low    = <ls>-low
        high   = <ls>-high ) ).

  NEW /hdl/cl_notif_completer( )->run(
    it_qmnum_range = lt_ranges
    iv_test_mode   = p_test ).
