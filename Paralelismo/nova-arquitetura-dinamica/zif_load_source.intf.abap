"! <p class="shorttext synchronized">Generic input source (any object type)</p>
INTERFACE zif_load_source
  PUBLIC.

  METHODS read_all
    RETURNING VALUE(rt_input) TYPE zcl_load_dto=>tt_input.

ENDINTERFACE.
