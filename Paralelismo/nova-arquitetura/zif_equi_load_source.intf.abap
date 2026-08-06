"! <p class="shorttext synchronized">Input data provider (Equipment)</p>
"! Abstracts the source: HTTP body (Replicate SAP Target Connector), CDS,
"! staging table, file upload, etc.
INTERFACE zif_equi_load_source
  PUBLIC.

  METHODS read_all
    RETURNING VALUE(rt_input) TYPE zcl_equi_load_dto=>tt_input.

ENDINTERFACE.
