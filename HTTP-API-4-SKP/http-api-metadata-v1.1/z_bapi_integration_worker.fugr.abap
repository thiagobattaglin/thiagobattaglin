* ============================================================================
* DEPRECATED — do not use.
* ============================================================================
* This Function Group was removed during the Clean Core refactoring.
*
* Parallel processing is now handled by cl_abap_parallel (released in ABAP Cloud),
* com o provider Clean Core:
*
*     zcl_bapi_integration_parallel  (implements if_abap_parallel)
*
* which is triggered by the dispatcher:
*
*     zcl_bapi_integration_dispatch~dispatch_chunks
*
* Reason for removal:
*   CALL FUNCTION 'FUNC' STARTING NEW TASK ... DESTINATION IN GROUP DEFAULT
*   (classic aRFC) is NOT released in ABAP Cloud. It was replaced by
*   cl_abap_parallel=>run_inline, which is released and performs the same job.
*
* If you are deploying this service on an old on-premise system
* and cl_abap_parallel is unavailable for any reason, restore the
* original file from git history — but this reintroduces a
* non-Clean-Core point in the design.
* ============================================================================

