FUNCTION-POOL z_bapi_stg_worker.
* Function group for RFC-enabled FM Z_BAPI_STG_WORKER used by
* zcl_bapi_stg_dispatcher via
*     CALL FUNCTION 'Z_BAPI_STG_WORKER' STARTING NEW TASK ...
*     DESTINATION IN GROUP DEFAULT.


FUNCTION z_bapi_stg_worker.
*"---------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_BAPI_NAME) TYPE  STRING
*"     VALUE(IV_MODE) TYPE  STRING DEFAULT 'async'
*"     VALUE(IV_RUN_UUID) TYPE  SYSUUID_X16
*"     VALUE(IV_DOC_FROM) TYPE  I
*"     VALUE(IV_DOC_TO) TYPE  I
*"---------------------------------------------------------------------
* NOTE: this FM MUST be flagged as Remote-Enabled Module (SE37).
* NO JSON is transferred between dispatcher and worker - only key range.

  TRY.
      DATA(lo_caller) = NEW zcl_bapi_stg_caller( iv_bapi_name ).
      lo_caller->process_range( iv_run_uuid = iv_run_uuid
                                iv_doc_from = iv_doc_from
                                iv_doc_to   = iv_doc_to ).
    CATCH cx_root INTO DATA(lx_err).
      IF iv_mode IS SUPPLIED.
        " Reserved for a future sync branch: re-raise or log with correlation id.
      ENDIF.
  ENDTRY.

ENDFUNCTION.
