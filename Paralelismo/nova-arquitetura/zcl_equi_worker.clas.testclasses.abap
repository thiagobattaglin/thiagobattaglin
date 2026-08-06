"! <p class="shorttext synchronized">Unit tests for worker + orchestrator chunking</p>
CLASS ltcl_sink_spy DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES zif_equi_load_sink.
    DATA mv_calls  TYPE i.
    DATA mt_result TYPE zcl_equi_load_dto=>tt_result.
ENDCLASS.

CLASS ltcl_sink_spy IMPLEMENTATION.
  METHOD zif_equi_load_sink~append_results.
    mv_calls = mv_calls + 1.
    APPEND LINES OF it_result TO mt_result.
  ENDMETHOD.
  METHOD zif_equi_load_sink~get_results.
    rt_result = mt_result.
  ENDMETHOD.
ENDCLASS.


CLASS ltcl_source_stub DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES zif_equi_load_source.
    METHODS constructor IMPORTING it_input TYPE zcl_equi_load_dto=>tt_input.
  PRIVATE SECTION.
    DATA mt_input TYPE zcl_equi_load_dto=>tt_input.
ENDCLASS.

CLASS ltcl_source_stub IMPLEMENTATION.
  METHOD constructor.
    mt_input = it_input.
  ENDMETHOD.
  METHOD zif_equi_load_source~read_all.
    rt_input = mt_input.
  ENDMETHOD.
ENDCLASS.


"! Orchestrator subclass exposing the internal chunking for test.
CLASS ltcl_orch_probe DEFINITION FINAL INHERITING FROM zcl_equi_load_orchestrator.
ENDCLASS.


CLASS ltcl_worker DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS transaction_mode_is_single    FOR TESTING.
    METHODS sync_calls_sink_once_per_pkg  FOR TESTING.
    METHODS sync_returns_all_items        FOR TESTING.

    METHODS build_input
      IMPORTING iv_count        TYPE i
      RETURNING VALUE(rt_input) TYPE zcl_equi_load_dto=>tt_input.

ENDCLASS.


CLASS ltcl_worker IMPLEMENTATION.

  METHOD build_input.
    DO iv_count TIMES.
      APPEND VALUE #( ext_id = |EXT-{ sy-index }|
                      equi_category = 'M'
                      descript = |Item { sy-index }| ) TO rt_input.
    ENDDO.
  ENDMETHOD.

  METHOD transaction_mode_is_single.

    DATA(lo_spy) = NEW ltcl_sink_spy( ).
    DATA(lo_worker) = NEW zcl_equi_worker(
                       it_input = build_input( 1 )
                       io_sink  = CAST zif_equi_load_sink( lo_spy ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = if_bgmc_process_parameter=>transaction_mode-single_transaction
      act = lo_worker->if_bgmc_process_parameter~get_transaction_mode( )
      msg = 'Each worker must run in a single LUW' ).

  ENDMETHOD.

  METHOD sync_calls_sink_once_per_pkg.

    DATA(lo_spy) = NEW ltcl_sink_spy( ).
    DATA(lo_worker) = NEW zcl_equi_worker(
                       it_input = build_input( 5 )
                       io_sink  = CAST zif_equi_load_sink( lo_spy ) ).

    lo_worker->execute_sync( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 1
      act = lo_spy->mv_calls
      msg = 'append_results must be called once with the whole batch' ).

  ENDMETHOD.

  METHOD sync_returns_all_items.

    DATA(lo_spy) = NEW ltcl_sink_spy( ).
    DATA(lo_worker) = NEW zcl_equi_worker(
                       it_input = build_input( 3 )
                       io_sink  = CAST zif_equi_load_sink( lo_spy ) ).

    DATA(lt_result) = lo_worker->execute_sync( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 3
      act = lines( lt_result )
      msg = 'Each input item must yield exactly one result row' ).

  ENDMETHOD.

ENDCLASS.


CLASS ltcl_chunking DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS explicit_worker_rows_used    FOR TESTING.
    METHODS default_splits_into_4        FOR TESTING.
    METHODS fewer_items_than_default     FOR TESTING.

    METHODS build_input
      IMPORTING iv_count        TYPE i
      RETURNING VALUE(rt_input) TYPE zcl_equi_load_dto=>tt_input.

ENDCLASS.


CLASS ltcl_chunking IMPLEMENTATION.

  METHOD build_input.
    DO iv_count TIMES.
      APPEND VALUE #( ext_id = |EXT-{ sy-index }|
                      equi_category = 'M' ) TO rt_input.
    ENDDO.
  ENDMETHOD.

  METHOD explicit_worker_rows_used.

    " 10 items, workerRows = 3 → chunks of 3,3,3,1 → 4 workers submitted.
    DATA(lo_src) = CAST zif_equi_load_source( NEW ltcl_source_stub( build_input( 10 ) ) ).
    DATA(lo_sink) = CAST zif_equi_load_sink( NEW ltcl_sink_spy( ) ).

    DATA(lo_orch) = NEW zcl_equi_load_orchestrator(
                     io_source      = lo_src
                     io_sink        = lo_sink
                     iv_worker_rows = 3 ).

    cl_abap_unit_assert=>assert_equals(
      exp = 4
      act = lo_orch->run( )
      msg = '10 items with workerRows=3 must yield 4 workers' ).

  ENDMETHOD.

  METHOD default_splits_into_4.

    " 20 items, no workerRows → split into 4 workers of 5 each.
    DATA(lo_src) = CAST zif_equi_load_source( NEW ltcl_source_stub( build_input( 20 ) ) ).
    DATA(lo_sink) = CAST zif_equi_load_sink( NEW ltcl_sink_spy( ) ).

    DATA(lo_orch) = NEW zcl_equi_load_orchestrator(
                     io_source = lo_src
                     io_sink   = lo_sink ).

    cl_abap_unit_assert=>assert_equals(
      exp = 4
      act = lo_orch->run( )
      msg = 'Default rule must produce 4 workers' ).

  ENDMETHOD.

  METHOD fewer_items_than_default.

    " 2 items, no workerRows → only 2 workers possible.
    DATA(lo_src) = CAST zif_equi_load_source( NEW ltcl_source_stub( build_input( 2 ) ) ).
    DATA(lo_sink) = CAST zif_equi_load_sink( NEW ltcl_sink_spy( ) ).

    DATA(lo_orch) = NEW zcl_equi_load_orchestrator(
                     io_source = lo_src
                     io_sink   = lo_sink ).

    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = lo_orch->run( )
      msg = 'With fewer items than default workers, use as many workers as items' ).

  ENDMETHOD.

ENDCLASS.
