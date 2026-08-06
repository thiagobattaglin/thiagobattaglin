"! <p class="shorttext synchronized">Class-Run entry point for local testing</p>
CLASS zcl_load_run DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_load_run IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(lt_items) = VALUE zcl_load_dto=>tt_input(
      ( ext_id      = 'EQ-001'
        object_type = 'EQUIPMENT'
        fields      = VALUE #(
          ( name = 'equi_category' value = 'M' )
          ( name = 'descript'      value = '100 HP Motor' )
          ( name = 'eqtype'        value = 'MECH' )
          ( name = 'maintplant'    value = '1010' )
          ( name = 'planplant'     value = '1010' )
          ( name = 'company_code'  value = '1010' )
          ( name = 'start_up_date' value = '2025-01-01' ) ) )
      ( ext_id      = 'FL-001'
        object_type = 'FUNC_LOCATION'
        fields      = VALUE #(
          ( name = 'funct_loc'    value = 'FL-AREA-01' )
          ( name = 'descript'     value = 'Area 01' )
          ( name = 'maintplant'   value = '1010' )
          ( name = 'planplant'    value = '1010' )
          ( name = 'company_code' value = '1010' ) ) ) ).

    DATA(lo_source) = CAST zif_load_source( NEW zcl_load_src_http( lt_items ) ).
    DATA(lo_sink)   = CAST zif_load_sink( NEW zcl_load_sink_memory( ) ).
    DATA(lo_orch)   = NEW zcl_load_orchestrator(
                        io_source      = lo_source
                        io_sink        = lo_sink
                        iv_worker_rows = 0 ).

    DATA(lt_result) = lo_orch->run_sync( ).

    LOOP AT lt_result INTO DATA(ls_r).
      out->write( |{ ls_r-ext_id } { ls_r-status } { ls_r-entity_id } { ls_r-message }| ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
