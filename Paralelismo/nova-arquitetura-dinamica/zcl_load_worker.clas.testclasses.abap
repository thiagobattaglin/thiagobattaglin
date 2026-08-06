"! <p class="shorttext synchronized">Unit tests for factory + worker + orchestrator chunking</p>

CLASS ltcl_sink_spy DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES zif_load_sink.
    DATA mv_calls  TYPE i.
    DATA mt_result TYPE zcl_load_dto=>tt_result.
ENDCLASS.

CLASS ltcl_sink_spy IMPLEMENTATION.
  METHOD zif_load_sink~append_results.
    mv_calls = mv_calls + 1.
    APPEND LINES OF it_result TO mt_result.
  ENDMETHOD.
  METHOD zif_load_sink~get_results.
    rt_result = mt_result.
  ENDMETHOD.
ENDCLASS.


CLASS ltcl_source_stub DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES zif_load_source.
    METHODS constructor IMPORTING it_input TYPE zcl_load_dto=>tt_input.
  PRIVATE SECTION.
    DATA mt_input TYPE zcl_load_dto=>tt_input.
ENDCLASS.

CLASS ltcl_source_stub IMPLEMENTATION.
  METHOD constructor.
    mt_input = it_input.
  ENDMETHOD.
  METHOD zif_load_source~read_all.
    rt_input = mt_input.
  ENDMETHOD.
ENDCLASS.


CLASS ltcl_factory DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS equipment_returns_adapter    FOR TESTING.
    METHODS floc_returns_adapter         FOR TESTING.
    METHODS unknown_raises               FOR TESTING.
    METHODS supports_yes_no              FOR TESTING.

ENDCLASS.


CLASS ltcl_factory IMPLEMENTATION.

  METHOD equipment_returns_adapter.

    DATA(lo_adapter) = zcl_load_adapter_factory=>get( 'EQUIPMENT' ).
    cl_abap_unit_assert=>assert_bound( act = lo_adapter msg = 'Adapter must be bound' ).

  ENDMETHOD.

  METHOD floc_returns_adapter.

    DATA(lo_adapter) = zcl_load_adapter_factory=>get( 'FUNC_LOCATION' ).
    cl_abap_unit_assert=>assert_bound( act = lo_adapter msg = 'Adapter must be bound' ).

  ENDMETHOD.

  METHOD unknown_raises.

    TRY.
        zcl_load_adapter_factory=>get( 'ROCKET_SHIP' ).
        cl_abap_unit_assert=>fail( 'Unknown object_type must raise' ).
      CATCH cx_sy_ref_is_initial.
        " expected
    ENDTRY.

  ENDMETHOD.

  METHOD supports_yes_no.

    cl_abap_unit_assert=>assert_true( zcl_load_adapter_factory=>supports( 'EQUIPMENT' ) ).
    cl_abap_unit_assert=>assert_true( zcl_load_adapter_factory=>supports( 'equipment' ) ).
    cl_abap_unit_assert=>assert_false( zcl_load_adapter_factory=>supports( 'ROCKET_SHIP' ) ).

  ENDMETHOD.

ENDCLASS.


CLASS ltcl_worker DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS unsupported_object_yields_err  FOR TESTING.
    METHODS sink_called_once_per_pkg       FOR TESTING.

ENDCLASS.


CLASS ltcl_worker IMPLEMENTATION.

  METHOD unsupported_object_yields_err.

    DATA(lo_spy) = NEW ltcl_sink_spy( ).
    DATA(lo_w)   = NEW zcl_load_worker(
                    it_input = VALUE #( ( ext_id = 'X1' object_type = 'ROCKET_SHIP' ) )
                    io_sink  = CAST zif_load_sink( lo_spy ) ).

    DATA(lt_res) = lo_w->execute_sync( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'E'
      act = lt_res[ 1 ]-status
      msg = 'Unsupported object_type must yield error result' ).

  ENDMETHOD.

  METHOD sink_called_once_per_pkg.

    DATA(lo_spy) = NEW ltcl_sink_spy( ).
    DATA(lo_w)   = NEW zcl_load_worker(
                    it_input = VALUE #(
                      ( ext_id = 'X1' object_type = 'ROCKET_SHIP' )
                      ( ext_id = 'X2' object_type = 'ROCKET_SHIP' ) )
                    io_sink  = CAST zif_load_sink( lo_spy ) ).

    lo_w->execute_sync( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 1
      act = lo_spy->mv_calls
      msg = 'append_results called once with the whole slice' ).

  ENDMETHOD.

ENDCLASS.


CLASS ltcl_chunking DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS explicit_worker_rows_used  FOR TESTING.
    METHODS default_splits_into_4      FOR TESTING.
    METHODS fewer_items_than_default   FOR TESTING.

    METHODS build_input
      IMPORTING iv_count        TYPE i
      RETURNING VALUE(rt_input) TYPE zcl_load_dto=>tt_input.

ENDCLASS.


CLASS ltcl_chunking IMPLEMENTATION.

  METHOD build_input.
    DO iv_count TIMES.
      APPEND VALUE #( ext_id = |X{ sy-index }| object_type = 'ROCKET_SHIP' ) TO rt_input.
    ENDDO.
  ENDMETHOD.

  METHOD explicit_worker_rows_used.

    DATA(lo_orch) = NEW zcl_load_orchestrator(
                     io_source      = CAST zif_load_source( NEW ltcl_source_stub( build_input( 10 ) ) )
                     io_sink        = CAST zif_load_sink( NEW ltcl_sink_spy( ) )
                     iv_worker_rows = 3 ).

    cl_abap_unit_assert=>assert_equals(
      exp = 4  " 10 items with size 3 → 4 workers (3,3,3,1)
      act = lo_orch->run( )
      msg = 'workerRows=3 with 10 items must yield 4 workers' ).

  ENDMETHOD.

  METHOD default_splits_into_4.

    DATA(lo_orch) = NEW zcl_load_orchestrator(
                     io_source = CAST zif_load_source( NEW ltcl_source_stub( build_input( 20 ) ) )
                     io_sink   = CAST zif_load_sink( NEW ltcl_sink_spy( ) ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = 4
      act = lo_orch->run( )
      msg = 'Default rule must produce 4 workers' ).

  ENDMETHOD.

  METHOD fewer_items_than_default.

    DATA(lo_orch) = NEW zcl_load_orchestrator(
                     io_source = CAST zif_load_source( NEW ltcl_source_stub( build_input( 2 ) ) )
                     io_sink   = CAST zif_load_sink( NEW ltcl_sink_spy( ) ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = lo_orch->run( )
      msg = 'Fewer items than default → workers = items' ).

  ENDMETHOD.

ENDCLASS.
