"! <p class="shorttext synchronized">Worker: N items, 1 BAPI + 1 own COMMIT per item</p>
"!
"! bgPF unit-of-work. Each worker receives a slice of items sized by
"! the caller (parameter workerRows in the HTTP contract). Inside the
"! worker every item is processed as an ISOLATED transaction:
"!
"!   LOOP AT items.
"!     CALL FUNCTION 'BAPI_EQUI_CREATE'.
"!     IF error.
"!       CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.  " rolls back this item only
"!     ELSE.
"!       CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.    " commits this item only
"!     ENDIF.
"!   ENDLOOP.
"!
"! Effect: failure of one item does NOT undo previous items in the same
"! worker; workers run in parallel across the bgPF pool.
CLASS zcl_equi_worker DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_bgmc_op_single_tx_uncontrolled.
    INTERFACES if_bgmc_process_parameter.

    METHODS constructor
      IMPORTING it_input TYPE zcl_equi_load_dto=>tt_input
                io_sink  TYPE REF TO zif_equi_load_sink.

    "! Synchronous execution (no bgPF) — used by the HTTP handler in sync mode.
    METHODS execute_sync
      RETURNING VALUE(rt_result) TYPE zcl_equi_load_dto=>tt_result.

  PRIVATE SECTION.

    DATA mt_input TYPE zcl_equi_load_dto=>tt_input.
    DATA mo_sink  TYPE REF TO zif_equi_load_sink.

    METHODS process_items
      RETURNING VALUE(rt_result) TYPE zcl_equi_load_dto=>tt_result.

    METHODS create_one_equipment
      IMPORTING is_item          TYPE zcl_equi_load_dto=>ty_input
      RETURNING VALUE(rs_result) TYPE zcl_equi_load_dto=>ty_result.

ENDCLASS.


CLASS zcl_equi_worker IMPLEMENTATION.

  METHOD constructor.
    mt_input = it_input.
    mo_sink  = io_sink.
  ENDMETHOD.

  METHOD if_bgmc_op_single_tx_uncontrolled~execute.
    DATA(lt_result) = process_items( ).
    mo_sink->append_results( lt_result ).
  ENDMETHOD.

  METHOD if_bgmc_process_parameter~get_transaction_mode.
    result = if_bgmc_process_parameter=>transaction_mode-single_transaction.
  ENDMETHOD.

  METHOD execute_sync.
    rt_result = process_items( ).
    mo_sink->append_results( rt_result ).
  ENDMETHOD.

  METHOD process_items.
    LOOP AT mt_input INTO DATA(ls_item).
      APPEND create_one_equipment( ls_item ) TO rt_result.
    ENDLOOP.
  ENDMETHOD.

  METHOD create_one_equipment.

    DATA ls_data      TYPE bapi_itob.
    DATA ls_data_x    TYPE bapi_itobx.
    DATA lv_equipment TYPE equnr.
    DATA lt_return    TYPE STANDARD TABLE OF bapiret2.

    ls_data-descript      = is_item-descript.
    ls_data-eqtype        = is_item-eqtype.
    ls_data-maintplant    = is_item-maintplant.
    ls_data-planplant     = is_item-planplant.
    ls_data-location      = is_item-location.
    ls_data-cost_ctr      = is_item-cost_center.
    ls_data-comp_code     = is_item-company_code.
    ls_data-start_up_date = is_item-start_up_date.
    ls_data-manufacturer  = is_item-manufacturer.
    ls_data-model_number  = is_item-model_number.

    ls_data_x-descript      = abap_true.
    ls_data_x-eqtype        = abap_true.
    ls_data_x-maintplant    = abap_true.
    ls_data_x-planplant     = abap_true.
    ls_data_x-location      = abap_true.
    ls_data_x-cost_ctr      = abap_true.
    ls_data_x-comp_code     = abap_true.
    ls_data_x-start_up_date = abap_true.
    ls_data_x-manufacturer  = abap_true.
    ls_data_x-model_number  = abap_true.

    CALL FUNCTION 'BAPI_EQUI_CREATE'
      EXPORTING
        category  = is_item-equi_category
        data      = ls_data
        data_x    = ls_data_x
      IMPORTING
        equipment = lv_equipment
      TABLES
        return    = lt_return.

    DATA(lv_has_error) = xsdbool(
      line_exists( lt_return[ type = 'E' ] ) OR
      line_exists( lt_return[ type = 'A' ] ) ).

    IF lv_has_error = abap_true OR lv_equipment IS INITIAL.

      " Rollback this item only; other items in the worker are preserved.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      DATA(lv_msg) = COND string(
        LET ls_err = VALUE bapiret2( lt_return[ type = 'E' ] OPTIONAL )
        IN  WHEN ls_err-message IS NOT INITIAL
            THEN ls_err-message
            ELSE `Unknown failure while creating Equipment` ).

      rs_result = VALUE #( ext_id  = is_item-ext_id
                           status  = 'E'
                           message = lv_msg ).
      RETURN.
    ENDIF.

    " *** OWN COMMIT PER ITEM ***
    " 1 item = 1 BAPI = 1 isolated commit inside the worker.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

    rs_result = VALUE #( ext_id    = is_item-ext_id
                         equipment = lv_equipment
                         status    = 'S'
                         message   = 'OK' ).

  ENDMETHOD.

ENDCLASS.
