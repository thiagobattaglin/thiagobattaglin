"! <p class="shorttext synchronized">Unit tests for ZCL_EQUI_LOAD_SINK_APPLOG</p>
"!
"! The BAL write goes through cl_bali_* which is a system service; when the
"! log object is absent the sink swallows cx_bali_runtime. These tests
"! exercise the in-memory accumulation contract only.
CLASS ltcl_sink_applog DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS append_accumulates       FOR TESTING.
    METHODS bal_failure_swallowed    FOR TESTING.

ENDCLASS.


CLASS ltcl_sink_applog IMPLEMENTATION.

  METHOD append_accumulates.

    DATA(lo_sink) = CAST zif_equi_load_sink( NEW zcl_equi_load_sink_applog( ) ).

    lo_sink->append_results( VALUE #(
      ( ext_id = 'A1' equipment = '10000001' status = 'S' message = 'OK' )
      ( ext_id = 'A2' status = 'E' message = 'boom' ) ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = lines( lo_sink->get_results( ) )
      msg = 'Both success and error rows must accumulate' ).

  ENDMETHOD.

  METHOD bal_failure_swallowed.

    " Even when BAL is not configured, append_results must not raise.
    DATA(lo_sink) = CAST zif_equi_load_sink( NEW zcl_equi_load_sink_applog( ) ).

    TRY.
        lo_sink->append_results( VALUE #(
          ( ext_id = 'A1' status = 'S' ) ) ).
      CATCH cx_root INTO DATA(lx).
        cl_abap_unit_assert=>fail( |Sink must swallow BAL errors, got { lx->get_text( ) }| ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
