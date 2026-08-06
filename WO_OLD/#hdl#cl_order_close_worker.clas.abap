"! <p class="shorttext synchronized">Parallel worker that closes one PM order</p>
"! Must be a GLOBAL class because CL_ABAP_PARALLEL serializes the
"! instance and instantiates it in a separate RFC session.
CLASS /hdl/cl_order_close_worker DEFINITION
  PUBLIC
  CREATE PUBLIC
  FINAL.

  PUBLIC SECTION.
    INTERFACES if_abap_parallel.

    DATA aufnr      TYPE aufk-aufnr.
    DATA auart      TYPE aufk-auart.
    DATA cur_status TYPE string.
    DATA set_dlfl   TYPE abap_bool.
    DATA success    TYPE abap_bool.
    DATA message    TYPE string.
ENDCLASS.


CLASS /hdl/cl_order_close_worker IMPLEMENTATION.

  METHOD if_abap_parallel~do.
    " Delegates to the testable single-order closing logic
    " in /hdl/cl_order_closer, which uses the real BAPI facade.
    DATA(lo_closer) = NEW /hdl/cl_order_closer( ).
    DATA(ls_input)  = VALUE /hdl/cl_order_closer=>ty_order(
                        aufnr      = aufnr
                        auart      = auart
                        cur_status = cur_status ).
    DATA(ls_result) = lo_closer->close_single_order(
                        is_order     = ls_input
                        iv_set_dlfl  = set_dlfl ).

    success = xsdbool( ls_result-result = 'SUCCESS' ).
    message = ls_result-message.
  ENDMETHOD.

ENDCLASS.
