"! <p class="shorttext synchronized">Class-Run entry point for local testing</p>
"!
"! Runs the load without HTTP: useful for F9 in ADT during development.
"! Replace the mock payload with your real source (staging table, CDS…).
CLASS zcl_equi_load_run DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING.  " remove FOR TESTING when promoting to productive use

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_equi_load_run IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(lt_items) = VALUE zcl_equi_load_dto=>tt_input(
      ( ext_id       = 'EXT-0001'
        equi_category = 'M'
        descript     = '100 HP Motor'
        eqtype       = 'MECH'
        maintplant   = '1010'
        planplant    = '1010'
        location     = 'AREA-01'
        cost_center  = '10101010'
        company_code = '1010'
        start_up_date = '20250101'
        manufacturer  = 'ACME'
        model_number  = 'M100' )
      ( ext_id       = 'EXT-0002'
        equi_category = 'M'
        descript     = 'Centrifugal Pump'
        eqtype       = 'MECH'
        maintplant   = '1010'
        planplant    = '1010'
        location     = 'AREA-02'
        cost_center  = '10101010'
        company_code = '1010'
        start_up_date = '20250101'
        manufacturer  = 'ACME'
        model_number  = 'B200' ) ).

    DATA(lo_source) = CAST zif_equi_load_source(
                        NEW zcl_equi_load_src_http( lt_items ) ).

    DATA(lo_sink)   = CAST zif_equi_load_sink(
                        NEW zcl_equi_load_sink_memory( ) ).

    DATA(lo_orch)   = NEW zcl_equi_load_orchestrator(
                        io_source      = lo_source
                        io_sink        = lo_sink
                        iv_worker_rows = 0 ).   " 0 → default (4 workers)

    DATA(lt_result) = lo_orch->run_sync( ).

    LOOP AT lt_result INTO DATA(ls_r).
      out->write( |{ ls_r-ext_id } | && |{ ls_r-status } | &&
                  |{ ls_r-equipment } { ls_r-message }| ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
