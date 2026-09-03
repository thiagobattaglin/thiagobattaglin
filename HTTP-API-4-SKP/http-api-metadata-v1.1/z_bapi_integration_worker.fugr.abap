* ============================================================================
* Function Group Z_BAPI_INTEGRATION_WORKER
* ============================================================================
* Hosts the RFC-enabled Function Module used by mode="async" in the
* BAPI Integration Framework on S/4HANA On-Premise 2022 (SAP_BASIS 757).
*
* Why this exists on 2022 on-prem:
*   The bgMC / BGPF framework (cl_bgmc_process_factory, if_bgmc_op_*) is
*   only released on-premise as of S/4HANA 2023, and cl_bgrfc_unit_factory
*   is not visible from this package's language version either. So async
*   is scheduled with classic tRFC (CALL FUNCTION ... IN BACKGROUND TASK
*   DESTINATION 'NONE') from zcl_bapi_integration_dispatch, and this FM
*   is the target callee. Fire-and-forget after 202 Accepted is preserved.
*
* How to create it in ADT / SE80:
*   1. Create Function Group  Z_BAPI_INTEGRATION_WORKER  in package
*      ZPKG_BAPI_INTEGRATION.
*   2. Create Function Module Z_BAPI_INTG_WORKER_EXEC as
*      "Remote-Enabled Module".
*   3. Paste the IMPORT parameters and the source below.
*   4. Activate. No SBGRFCCONF setup is needed for DESTINATION 'NONE';
*      monitoring is done via SM58.
*
* IMPORT parameters (all pass-by-value):
*     IV_BAPI_NAME       TYPE STRING
*     IV_DOCUMENTS_JSON  TYPE STRING
*     IV_CORRELATION_ID  TYPE STRING
*     IV_WORKER_INDEX    TYPE I
*
* EXPORT / CHANGING / TABLES: none.
* EXCEPTIONS: none (a tRFC unit must not raise; on error SM58 keeps it
*             in CPICERR/SYSFAIL for manual reprocess).
*
* ----------------------------------------------------------------------------
* FUNCTION-POOL Z_BAPI_INTEGRATION_WORKER (TOP include).
* ----------------------------------------------------------------------------

FUNCTION-POOL z_bapi_integration_worker.

* ----------------------------------------------------------------------------
* FUNCTION MODULE Z_BAPI_INTG_WORKER_EXEC
* ----------------------------------------------------------------------------

FUNCTION z_bapi_intg_worker_exec.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_BAPI_NAME) TYPE  STRING
*"     VALUE(IV_DOCUMENTS_JSON) TYPE  STRING
*"     VALUE(IV_CORRELATION_ID) TYPE  STRING OPTIONAL
*"     VALUE(IV_WORKER_INDEX) TYPE  I OPTIONAL
*"----------------------------------------------------------------------

  DATA lt_docs TYPE zif_bapi_integration_executor=>tt_documents.

  TRY.
      xco_cp_json=>data->from_string( iv_documents_json )->write_to( REF #( lt_docs ) ).

      NEW zcl_bapi_integration_parallel(
            iv_bapi_name      = iv_bapi_name
            it_documents      = lt_docs
            iv_correlation_id = iv_correlation_id
            iv_worker_index   = iv_worker_index
          )->run_workload( ).

    CATCH cx_root ##NO_HANDLER.
      " A tRFC unit must never propagate an exception: SM58 would leave
      " it stuck in CPICERR/SYSFAIL. Document-level errors are already
      " persisted by zcl_bapi_integration_logger inside run_workload( ).
  ENDTRY.

ENDFUNCTION.

