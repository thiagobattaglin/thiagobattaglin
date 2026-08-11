FUNCTION-POOL z_bapi_rap_worker.
* Function group for RFC-enabled FM Z_BAPI_RAP_WORKER used by
* zcl_bapi_rap_dispatcher via
*     CALL FUNCTION 'Z_BAPI_RAP_WORKER' STARTING NEW TASK ...
*     DESTINATION IN GROUP DEFAULT.


FUNCTION z_bapi_rap_worker.
*"---------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_BAPI_NAME) TYPE  STRING
*"     VALUE(IV_MODE) TYPE  STRING DEFAULT 'async'
*"     VALUE(IV_CHUNK) TYPE  STRING
*"---------------------------------------------------------------------
* NOTE: this Function Module MUST be flagged as *Remote-Enabled Module*
*       (Attributes tab in SE37) so STARTING NEW TASK works.

  DATA lt_docs TYPE zcl_bapi_rap_dispatcher=>tt_documents.

  TRY.
      /ui2/cl_json=>deserialize(
        EXPORTING json        = iv_chunk
                  pretty_name = /ui2/cl_json=>pretty_mode-none
        CHANGING  data        = lt_docs ).

      DATA(lo_caller) = NEW zcl_bapi_rap_caller( iv_bapi_name ).
      lo_caller->process_chunk( lt_docs ).

    CATCH cx_root INTO DATA(lx_err).
* Async: never allow this task to dump. Plug application logging here (BAL_*).
      IF iv_mode IS SUPPLIED.
* Reserved for a future sync branch: re-raise or log with correlation id.
      ENDIF.
  ENDTRY.

ENDFUNCTION.
