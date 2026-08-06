"! <p class="shorttext synchronized">Unit tests for ZCL_EQUI_LOAD_SRC_HTTP</p>
CLASS ltcl_src_http DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS read_all_returns_input      FOR TESTING.
    METHODS empty_input_returns_empty   FOR TESTING.

ENDCLASS.


CLASS ltcl_src_http IMPLEMENTATION.

  METHOD read_all_returns_input.

    DATA(lt_in) = VALUE zcl_equi_load_dto=>tt_input(
      ( ext_id = 'A1' equi_category = 'M' descript = 'X' )
      ( ext_id = 'A2' equi_category = 'M' descript = 'Y' ) ).

    DATA(lo_src) = CAST zif_equi_load_source( NEW zcl_equi_load_src_http( lt_in ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = lt_in
      act = lo_src->read_all( )
      msg = 'read_all must return the exact injected payload' ).

  ENDMETHOD.

  METHOD empty_input_returns_empty.

    DATA lt_empty TYPE zcl_equi_load_dto=>tt_input.
    DATA(lo_src) = CAST zif_equi_load_source( NEW zcl_equi_load_src_http( lt_empty ) ).

    cl_abap_unit_assert=>assert_initial(
      act = lo_src->read_all( )
      msg = 'Empty input must yield empty output' ).

  ENDMETHOD.

ENDCLASS.
