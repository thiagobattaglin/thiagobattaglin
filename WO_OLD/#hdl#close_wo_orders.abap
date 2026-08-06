REPORT /hdl/close_wo_orders.

************************************************************************
* Close Maintenance Orders (PM) in mass mode
*
* Thin shell. All business logic lives in the global classes:
*   - /HDL/CL_ORDER_CLOSER         (orchestration + pure logic)
*   - /HDL/CL_ORDER_CLOSE_WORKER   (parallel worker)
*   - /HDL/CL_ALM_ORDER_BAPI       (real BAPI facade)
*   - /HDL/IF_ALM_ORDER_BAPI       (BAPI facade interface, for DI/tests)
*   - /HDL/CX_ORDER_CLOSE          (custom exception)
*
* Unit tests: local test classes of /HDL/CL_ORDER_CLOSER.
************************************************************************

TABLES aufk.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS s_aufnr FOR aufk-aufnr.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS p_test AS CHECKBOX DEFAULT abap_true.
  PARAMETERS p_dlt  AS CHECKBOX DEFAULT abap_false.
SELECTION-SCREEN END OF BLOCK b2.

START-OF-SELECTION.
  DATA(lt_ranges) = VALUE /hdl/cl_order_closer=>ty_aufnr_ranges(
    FOR <ls> IN s_aufnr[]
      ( sign   = <ls>-sign
        option = <ls>-option
        low    = <ls>-low
        high   = <ls>-high ) ).

  NEW /hdl/cl_order_closer( )->run(
    it_aufnr_range = lt_ranges
    iv_test_mode   = p_test
    iv_set_dlfl    = p_dlt ).
