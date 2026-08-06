"! <p class="shorttext synchronized">Worker: BAPI-agnostic, delegates to adapter</p>
"!
"! The worker does NOT know which BAPI is called. For each item in its
"! slice it obtains the adapter for the item's object_type from the
"! factory and delegates the BAPI + commit isolation to the adapter.
CLASS zcl_load_worker DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_bgmc_op_single_tx_uncontrolled.
    INTERFACES if_bgmc_process_parameter.

    METHODS constructor
      IMPORTING it_input TYPE zcl_load_dto=>tt_input
                io_sink  TYPE REF TO zif_load_sink.

    METHODS execute_sync
      RETURNING VALUE(rt_result) TYPE zcl_load_dto=>tt_result.

  PRIVATE SECTION.

    DATA mt_input TYPE zcl_load_dto=>tt_input.
    DATA mo_sink  TYPE REF TO zif_load_sink.

    METHODS process_items
      RETURNING VALUE(rt_result) TYPE zcl_load_dto=>tt_result.

ENDCLASS.


CLASS zcl_load_worker IMPLEMENTATION.

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

      TRY.
          DATA(lo_adapter) = zcl_load_adapter_factory=>get( ls_item-object_type ).
          APPEND lo_adapter->create( ls_item ) TO rt_result.

        CATCH cx_sy_ref_is_initial.
          APPEND VALUE #(
            ext_id  = ls_item-ext_id
            status  = 'E'
            message = |Unsupported object_type '{ ls_item-object_type }'| )
            TO rt_result.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
