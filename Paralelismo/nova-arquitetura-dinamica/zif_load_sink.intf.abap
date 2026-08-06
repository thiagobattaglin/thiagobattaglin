"! <p class="shorttext synchronized">Generic result sink (any object type)</p>
INTERFACE zif_load_sink
  PUBLIC.

  METHODS append_results
    IMPORTING it_result TYPE zcl_load_dto=>tt_result.

  METHODS get_results
    RETURNING VALUE(rt_result) TYPE zcl_load_dto=>tt_result.

ENDINTERFACE.
