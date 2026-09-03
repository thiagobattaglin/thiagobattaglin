* ============================================================================
* DEPRECATED — do not use.
* ============================================================================
* Original role: bgMC operation for mode="async" in the BAPI Integration
* Framework (delegated to zcl_bapi_integration_parallel->run_workload( )).
*
* bgMC / BGPF (cl_bgmc_process_factory, if_bgmc_op_*) is only released
* on-premise as of S/4HANA 2023. On S/4HANA On-Premise 2022 (SAP_BASIS 757)
* the classes and interfaces referenced by this class do not exist and the
* pool would fail to activate.
*
* The async path was migrated to classic tRFC:
*
*     Function group   Z_BAPI_INTEGRATION_WORKER
*     Function module  Z_BAPI_INTG_WORKER_EXEC   (RFC-enabled)
*     Scheduler        CALL FUNCTION ... IN BACKGROUND TASK DESTINATION 'NONE'
*                      in zcl_bapi_integration_dispatch~dispatch_async_chunks
*
* Action required: delete this class in ADT ("Delete" on
* ZCL_BAPI_INTEGRATION_BGMC_OP) and include it in the same transport as the
* dispatcher change and the Z_BAPI_INTEGRATION_WORKER function group.
*
* If this package is later ported to S/4HANA 2023+ or ABAP Cloud, restore the
* bgMC implementation from git history and revert the tRFC branch in the
* dispatcher.
* ============================================================================

