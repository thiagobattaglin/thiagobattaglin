FUNCTION-POOL z_bapi_dyn_worker.
* Function group for RFC-enabled worker used by zcl_bapi_dyn_dispatcher
* via CALL FUNCTION ... STARTING NEW TASK ... DESTINATION IN GROUP DEFAULT.


FUNCTION z_bapi_dyn_worker.
*"---------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_BAPI_NAME) TYPE  STRING
*"     VALUE(IV_MODE) TYPE  STRING DEFAULT 'async'
*"     VALUE(IV_CHUNK) TYPE  STRING
*"---------------------------------------------------------------------
* NOTE: this Function Module MUST be marked as *Remote-Enabled Module*
*       (Attributes tab in SE37) so that STARTING NEW TASK works.

  DATA lt_docs TYPE zcl_bapi_dyn_dispatcher=>tt_documents.

  TRY.
      /ui2/cl_json=>deserialize(
        EXPORTING json        = iv_chunk
                  pretty_name = /ui2/cl_json=>pretty_mode-none
        CHANGING  data        = lt_docs ).

      DATA(lo_caller) = NEW zcl_bapi_dyn_caller( iv_bapi_name ).
      lo_caller->process_chunk( lt_docs ).

    CATCH cx_root INTO DATA(lx_err).
* Async execution: never let the task dump.
* Application logging should be plugged here (e.g. BAL_LOG_CREATE + BAL_LOG_MSG_ADD).
      IF iv_mode IS SUPPLIED.
* Reserved for future sync branch: re-raise or log with correlation id.
      ENDIF.
  ENDTRY.

ENDFUNCTION.
