"! <p class="shorttext synchronized">Sink for persisting load results</p>
"! Abstracts the destination: Application Log via cl_bali_*,
"! custom Z-table, HTTP JSON response, etc.
INTERFACE zif_equi_load_sink
  PUBLIC.

  METHODS append_results
    IMPORTING it_result TYPE zcl_equi_load_dto=>tt_result.

  METHODS get_results
    RETURNING VALUE(rt_result) TYPE zcl_equi_load_dto=>tt_result.

ENDINTERFACE.
