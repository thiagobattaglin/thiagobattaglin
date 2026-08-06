"! <p class="shorttext synchronized">Orchestrates the load: N items per worker</p>
"!
"! Splits input into chunks and submits 1 bgPF worker per chunk.
"! Chunk rule:
"!   iv_worker_rows > 0 → chunk size = iv_worker_rows
"!   iv_worker_rows <= 0 → default 4 workers (or fewer if input < 4).
"! object_type travels with every item; the worker resolves the adapter.
CLASS zcl_load_orchestrator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    CONSTANTS c_default_workers TYPE i VALUE 4.

    METHODS constructor
      IMPORTING io_source      TYPE REF TO zif_load_source
                io_sink        TYPE REF TO zif_load_sink
                iv_worker_rows TYPE i DEFAULT 0.

    METHODS run
      RETURNING VALUE(rv_workers) TYPE i.

    METHODS run_sync
      RETURNING VALUE(rt_result) TYPE zcl_load_dto=>tt_result.

  PRIVATE SECTION.

    DATA mo_source      TYPE REF TO zif_load_source.
    DATA mo_sink        TYPE REF TO zif_load_sink.
    DATA mv_worker_rows TYPE i.

    TYPES tt_packages TYPE STANDARD TABLE OF zcl_load_dto=>tt_input WITH EMPTY KEY.

    METHODS build_packages
      IMPORTING it_input           TYPE zcl_load_dto=>tt_input
      RETURNING VALUE(rt_packages) TYPE tt_packages.

    METHODS resolve_chunk_size
      IMPORTING iv_total            TYPE i
      RETURNING VALUE(rv_chunk_size) TYPE i.

    METHODS submit_package
      IMPORTING it_package TYPE zcl_load_dto=>tt_input.

ENDCLASS.


CLASS zcl_load_orchestrator IMPLEMENTATION.

  METHOD constructor.
    mo_source      = io_source.
    mo_sink        = io_sink.
    mv_worker_rows = iv_worker_rows.
  ENDMETHOD.

  METHOD run.

    DATA(lt_input)    = mo_source->read_all( ).
    DATA(lt_packages) = build_packages( lt_input ).

    LOOP AT lt_packages INTO DATA(lt_pkg).
      submit_package( lt_pkg ).
      rv_workers = rv_workers + 1.
    ENDLOOP.

  ENDMETHOD.

  METHOD run_sync.

    DATA(lt_input)    = mo_source->read_all( ).
    DATA(lt_packages) = build_packages( lt_input ).

    LOOP AT lt_packages INTO DATA(lt_pkg).
      DATA(lo_worker) = NEW zcl_load_worker( it_input = lt_pkg io_sink = mo_sink ).
      APPEND LINES OF lo_worker->execute_sync( ) TO rt_result.
    ENDLOOP.

  ENDMETHOD.

  METHOD resolve_chunk_size.

    IF iv_total <= 0.
      RETURN.
    ENDIF.

    IF mv_worker_rows > 0.
      rv_chunk_size = mv_worker_rows.
      RETURN.
    ENDIF.

    DATA(lv_workers) = nmin( val1 = c_default_workers val2 = iv_total ).
    rv_chunk_size = COND i(
      WHEN iv_total MOD lv_workers = 0
      THEN iv_total / lv_workers
      ELSE ( iv_total DIV lv_workers ) + 1 ).

  ENDMETHOD.

  METHOD build_packages.

    DATA(lv_chunk_size) = resolve_chunk_size( lines( it_input ) ).

    IF lv_chunk_size = 0.
      RETURN.
    ENDIF.

    DATA lt_current TYPE zcl_load_dto=>tt_input.

    LOOP AT it_input INTO DATA(ls_row).
      APPEND ls_row TO lt_current.
      IF lines( lt_current ) >= lv_chunk_size.
        APPEND lt_current TO rt_packages.
        CLEAR lt_current.
      ENDIF.
    ENDLOOP.

    IF lt_current IS NOT INITIAL.
      APPEND lt_current TO rt_packages.
    ENDIF.

  ENDMETHOD.

  METHOD submit_package.

    DATA(lo_worker) = NEW zcl_load_worker( it_input = it_package io_sink = mo_sink ).

    TRY.
        cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'LOAD_DYN_WORKER'
          )->set_operation( lo_worker
          )->save_for_execution( ).

      CATCH cx_bgmc.
        lo_worker->if_bgmc_op_single_tx_uncontrolled~execute( ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
