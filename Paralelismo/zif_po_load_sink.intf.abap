"! <p class="shorttext synchronized">Sink para persistir resultados da carga</p>
"! Abstrai onde os resultados vão parar (log Z, Application Log via cl_bali_*, etc.).
INTERFACE zif_po_load_sink
  PUBLIC.

  METHODS append_results
    IMPORTING it_result TYPE zcl_po_load_dto=>tt_result.

ENDINTERFACE.
