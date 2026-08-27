* ============================================================================
* DEPRECATED — não usar.
* ============================================================================
* Este Function Group foi eliminado na refatoração Clean Core.
*
* O paralelismo agora é feito por cl_abap_parallel (released em ABAP Cloud),
* com o provider Clean Core:
*
*     zcl_bapi_meta_v11_parallel_prv  (implements if_abap_parallel)
*
* que é disparado pelo dispatcher:
*
*     zcl_bapi_meta_v11_dispatch~dispatch_chunks
*
* Motivo da remoção:
*   CALL FUNCTION 'FUNC' STARTING NEW TASK ... DESTINATION IN GROUP DEFAULT
*   (aRFC clássico) NÃO é released em ABAP Cloud. Foi substituído por
*   cl_abap_parallel=>run_inline, que é released e faz o mesmo job.
*
* Se você estiver deployando esse serviço em um sistema on-premise antigo
* e por algum motivo cl_abap_parallel não estiver disponível, restaure o
* arquivo original a partir do histórico do git — mas isso reintroduz um
* ponto não-Clean-Core no design.
* ============================================================================

