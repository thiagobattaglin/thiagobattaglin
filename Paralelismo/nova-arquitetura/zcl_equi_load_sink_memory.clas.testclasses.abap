"! <p class="shorttext synchronized">Unit tests for ZCL_EQUI_LOAD_SINK_MEMORY</p>
CLASS ltcl_sink_memory DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS append_then_get           FOR TESTING.
    METHODS multiple_appends_accum    FOR TESTING.
    METHODS get_without_append_empty  FOR TESTING.

ENDCLASS.


CLASS ltcl_sink_memory IMPLEMENTATION.

  METHOD append_then_get.

    DATA(lo_sink) = CAST zif_equi_load_sink( NEW zcl_equi_load_sink_memory( ) ).

    DATA(lt_batch) = VALUE zcl_equi_load_dto=>tt_result(
      ( ext_id = 'A1' equipment = '10000001' status = 'S' message = 'OK' ) ).

    lo_sink->append_results( lt_batch ).

    cl_abap_unit_assert=>assert_equals(
      exp = lt_batch
      act = lo_sink->get_results( )
      msg = 'get_results must return the appended batch' ).

  ENDMETHOD.

  METHOD multiple_appends_accum.

    DATA(lo_sink) = CAST zif_equi_load_sink( NEW zcl_equi_load_sink_memory( ) ).

    lo_sink->append_results( VALUE #(
      ( ext_id = 'A1' status = 'S' ) ) ).
    lo_sink->append_results( VALUE #(
      ( ext_id = 'A2' status = 'S' )
      ( ext_id = 'A3' status = 'E' message = 'boom' ) ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = 3
      act = lines( lo_sink->get_results( ) )
      msg = 'Successive appends must accumulate' ).

  ENDMETHOD.

  METHOD get_without_append_empty.

    DATA(lo_sink) = CAST zif_equi_load_sink( NEW zcl_equi_load_sink_memory( ) ).

    cl_abap_unit_assert=>assert_initial(
      act = lo_sink->get_results( )
      msg = 'Fresh sink must return empty results' ).

  ENDMETHOD.

ENDCLASS.
