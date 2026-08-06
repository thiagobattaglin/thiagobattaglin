REPORT /hdl/set_wo_settlement.

************************************************************************
* Mass-create a default settlement rule (Cost Center / PER / 100 %)
* for PM maintenance orders that don't yet have one.
*
* Useful right after a Migration Cockpit load of PM orders, where the
* settlement rule worksheet was left empty and the orders cannot be
* closed (error: "Order cannot be completed; account assignment not
* maintained").
*
* Thin shell. Logic lives in /HDL/CL_ORDER_SETTLEMENT.
************************************************************************

TABLES aufk.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS s_aufnr FOR aufk-aufnr.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS p_test AS CHECKBOX DEFAULT abap_true.
SELECTION-SCREEN END OF BLOCK b2.

START-OF-SELECTION.
  DATA(lt_ranges) = VALUE /hdl/cl_order_settlement=>ty_aufnr_range(
    FOR <ls> IN s_aufnr[]
      ( sign   = <ls>-sign
        option = <ls>-option
        low    = <ls>-low
        high   = <ls>-high ) ).

  NEW /hdl/cl_order_settlement( )->run(
    it_aufnr_range = lt_ranges
    iv_test_mode   = p_test ).
