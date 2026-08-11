FUNCTION-POOL z_http_bapi_hyb_worker.
* Function group for the RFC-enabled worker used by
* zcl_http_bapi_hyb_dispatcher via
*   CALL FUNCTION 'Z_HTTP_BAPI_HYB_WORKER'
*     STARTING NEW TASK ... DESTINATION IN GROUP DEFAULT.


FUNCTION z_http_bapi_hyb_worker.
*"---------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_BAPI_NAME) TYPE  STRING
*"     VALUE(IV_MODE) TYPE  STRING DEFAULT 'async'
*"     VALUE(IV_CHUNK) TYPE  STRING
*"---------------------------------------------------------------------
* NOTE: this Function Module MUST be flagged as *Remote-Enabled Module*
*       (Attributes tab in SE37) so that STARTING NEW TASK works.
*
* The chunk is deserialized inside zcl_http_bapi_hyb_caller via the
* kernel CTF pipeline (zcl_http_bapi_hyb_json_parser). This function
* never touches /ui2/cl_json.

  TRY.
      DATA(lo_caller) = NEW zcl_http_bapi_hyb_caller( iv_bapi_name ).
      lo_caller->process_chunk_json( iv_chunk ).

    CATCH cx_root INTO DATA(lx_err).
* Async task must never dump. Wire application logging here
* (e.g. BAL_LOG_CREATE + BAL_LOG_MSG_ADD) with a correlation id.
      IF iv_mode IS SUPPLIED.
* Reserved for a future sync branch that would re-raise / propagate.
      ENDIF.
  ENDTRY.

ENDFUNCTION.
