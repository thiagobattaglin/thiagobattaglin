"! <p class="shorttext synchronized">Provider de dados de entrada da carga</p>
"! Abstrai a origem dos dados (staging table, CDS, upload etc.).
INTERFACE zif_po_load_source
  PUBLIC.

  METHODS read_all
    RETURNING VALUE(rt_input) TYPE zcl_po_load_dto=>tt_input.

ENDINTERFACE.
