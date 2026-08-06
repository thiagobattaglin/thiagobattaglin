"! <p class="shorttext synchronized">Parallel worker that completes one PM notification</p>
"! Must be a GLOBAL class because CL_ABAP_PARALLEL serializes the
"! instance and instantiates it in a separate RFC session.
CLASS /hdl/cl_notif_complete_worker DEFINITION
  PUBLIC
  CREATE PUBLIC
  FINAL.

  PUBLIC SECTION.
    INTERFACES if_abap_parallel.

    DATA qmnum      TYPE qmel-qmnum.
    DATA qmart      TYPE qmel-qmart.
    DATA cur_status TYPE string.
    DATA success    TYPE abap_bool.
    DATA message    TYPE string.
ENDCLASS.


CLASS /hdl/cl_notif_complete_worker IMPLEMENTATION.

  METHOD if_abap_parallel~do.
    DATA(lo_completer) = NEW /hdl/cl_notif_completer( ).
    DATA(ls_input)     = VALUE /hdl/cl_notif_completer=>ty_notif(
                           qmnum      = qmnum
                           qmart      = qmart
                           cur_status = cur_status ).
    DATA(ls_result)    = lo_completer->complete_single( ls_input ).

    success = xsdbool( ls_result-result = 'SUCCESS' ).
    message = ls_result-message.
  ENDMETHOD.

ENDCLASS.
