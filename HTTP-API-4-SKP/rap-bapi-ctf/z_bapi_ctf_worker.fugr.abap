FUNCTION-POOL z_bapi_ctf_worker.
* Function group for RFC-enabled FM Z_BAPI_CTF_WORKER used by
* zcl_bapi_ctf_dispatcher via
*     CALL FUNCTION 'Z_BAPI_CTF_WORKER' STARTING NEW TASK ...
*     DESTINATION IN GROUP DEFAULT.


FUNCTION z_bapi_ctf_worker.
*"---------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_BAPI_NAME) TYPE  STRING
*"     VALUE(IV_MODE) TYPE  STRING DEFAULT 'async'
*"     VALUE(IV_CHUNK) TYPE  STRING
*"---------------------------------------------------------------------
* NOTE: this FM MUST be flagged as Remote-Enabled Module (SE37).

  TRY.
      DATA(lo_caller) = NEW zcl_bapi_ctf_caller( iv_bapi_name ).
      lo_caller->process_chunk_json( iv_chunk ).
    CATCH cx_root INTO DATA(lx_err).
      IF iv_mode IS SUPPLIED.
        " Reserved for a future sync branch: re-raise or log with correlation id.
      ENDIF.
  ENDTRY.

ENDFUNCTION.
