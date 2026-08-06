*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lhc_load_req DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS set_initial_values FOR DETERMINE ON MODIFY
      IMPORTING keys FOR LoadReq~set_initial_values.

ENDCLASS.


CLASS lhc_load_req IMPLEMENTATION.

  METHOD set_initial_values.

    READ ENTITIES OF zr_equi_load_req IN LOCAL MODE
      ENTITY LoadReq
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(reqs).

    LOOP AT reqs ASSIGNING FIELD-SYMBOL(<req>).

      IF <req>-Mode IS INITIAL.
        <req>-Mode = 'A'.
      ENDIF.

      IF <req>-Status IS INITIAL.
        <req>-Status = 'N'.
      ENDIF.

    ENDLOOP.

    MODIFY ENTITIES OF zr_equi_load_req IN LOCAL MODE
      ENTITY LoadReq
        UPDATE FIELDS ( Mode Status )
        WITH VALUE #( FOR r IN reqs
                      ( %tky   = r-%tky
                        Mode   = r-Mode
                        Status = r-Status ) )
      REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

ENDCLASS.


"! Additional Save Handler: fires AFTER the managed runtime persists the
"! request + items. Reuses the orchestrator from the parent HTTP project
"! to dispatch bgPF workers.
CLASS lsc_saver DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

  PRIVATE SECTION.

    METHODS dispatch_workers
      IMPORTING iv_request_uuid TYPE sysuuid_x16.

    METHODS map_items_to_dto
      IMPORTING iv_request_uuid TYPE sysuuid_x16
      RETURNING VALUE(rt_input) TYPE zcl_equi_load_dto=>tt_input.

ENDCLASS.


CLASS lsc_saver IMPLEMENTATION.

  METHOD save_modified.

    " New requests entering the DB → submit workers to bgPF.
    LOOP AT create-loadreq INTO DATA(ls_new).

      dispatch_workers( ls_new-RequestUuid ).

    ENDLOOP.

  ENDMETHOD.

  METHOD dispatch_workers.

    " Read the persisted request + items to build the DTO input.
    SELECT SINGLE mode, worker_rows
      FROM zequi_load_req
      WHERE request_uuid = @iv_request_uuid
      INTO @DATA(ls_req).

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lt_input) = map_items_to_dto( iv_request_uuid ).

    IF lt_input IS INITIAL.
      UPDATE zequi_load_req
        SET status      = 'C',
            total_items = 0,
            workers     = 0
        WHERE request_uuid = @iv_request_uuid.
      RETURN.
    ENDIF.

    DATA(lo_source) = CAST zif_equi_load_source(
                        NEW zcl_equi_load_src_http( lt_input ) ).

    DATA(lo_sink)   = CAST zif_equi_load_sink(
                        NEW zcl_equi_load_sink_applog( ) ).

    DATA(lo_orch)   = NEW zcl_equi_load_orchestrator(
                        io_source      = lo_source
                        io_sink        = lo_sink
                        iv_worker_rows = ls_req-worker_rows ).

    " Async: submit each chunk as a bgPF worker; return worker count.
    DATA(lv_workers) = lo_orch->run( ).

    UPDATE zequi_load_req
      SET status      = 'R',
          total_items = @lines( lt_input ),
          workers     = @lv_workers
      WHERE request_uuid = @iv_request_uuid.

  ENDMETHOD.

  METHOD map_items_to_dto.

    SELECT ext_id, equi_category, descript, eqtype,
           maintplant, planplant, location, cost_center,
           company_code, start_up_date, manufacturer, model_number
      FROM zequi_load_itm
      WHERE request_uuid = @iv_request_uuid
      INTO CORRESPONDING FIELDS OF TABLE @rt_input.

  ENDMETHOD.

ENDCLASS.
