CLASS zcl_bapi_integration_parallel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

* Clean Core worker for cl_abap_parallel=>run_inst (released in ABAP Cloud).
* Each instance holds one chunk (bapi_name + documents) captured at construction,
* so run_inst can fan out the calls without xstring serialization and without
* touching the interface's p_in parameter, which is not accessible in the
* released ABAP Cloud signature of if_abap_parallel~do.
* Legacy coupling (dynamic CALL FUNCTION, BAPI commit) stays inside
* zcl_bapi_integration_exec, resolved through zif_bapi_integration_executor.

  PUBLIC SECTION.
    INTERFACES if_abap_parallel.

    METHODS constructor
      IMPORTING iv_bapi_name      TYPE string
                it_documents      TYPE zif_bapi_integration_executor=>tt_documents
                iv_correlation_id TYPE string OPTIONAL
                iv_worker_index   TYPE i      OPTIONAL.

    "! Shared workload used both by cl_abap_parallel (sync) and by the tRFC
    "! function module Z_BAPI_INTG_WORKER_EXEC (async, S/4 on-prem 2022).
    METHODS run_workload.

  PRIVATE SECTION.
    DATA mv_bapi_name      TYPE string.
    DATA mt_docs           TYPE zif_bapi_integration_executor=>tt_documents.
    DATA mv_correlation_id TYPE string.
    DATA mv_worker_index   TYPE i.
ENDCLASS.


CLASS zcl_bapi_integration_parallel IMPLEMENTATION.

  METHOD constructor.
    mv_bapi_name      = iv_bapi_name.
    mt_docs           = it_documents.
    mv_correlation_id = iv_correlation_id.
    mv_worker_index   = iv_worker_index.
  ENDMETHOD.

  METHOD if_abap_parallel~do.
    run_workload( ).
  ENDMETHOD.

  METHOD run_workload.
    DATA(lo_log) = zcl_bapi_integration_logger=>open(
                     iv_subobject   = zcl_bapi_integration_logger=>c_sub_worker
                     iv_external_id = mv_correlation_id ).

    lo_log->add_info( |Worker { mv_worker_index } started: BAPI { mv_bapi_name }, { lines( mt_docs ) } document(s)| ).

    DATA lv_success TYPE i.
    DATA lv_failed  TYPE i.
    DATA lv_index   TYPE i.

    TRY.
        " Local composition in the worker \u2014 the only coupling point with legacy code.
        DATA(lo_exec) = CAST zif_bapi_integration_executor(
                          NEW zcl_bapi_integration_exec( mv_bapi_name ) ).

        LOOP AT mt_docs INTO DATA(ls_doc).
          lv_index += 1.
          DATA(ls_result) = lo_exec->execute( ls_doc ).

          IF ls_result-success = abap_true.
            lv_success += 1.
          ELSE.
            lv_failed += 1.
            lo_log->add_error( |Worker { mv_worker_index } doc #{ lv_index }: failed| ).
            lo_log->add_bapi_messages( ls_result-messages ).
          ENDIF.
        ENDLOOP.

      CATCH cx_root INTO DATA(lx_worker).
        " Parallel execution must never bring down the framework worker.
        " Document errors are already handled by the executor through BAPI RETURN.
        lo_log->add_error( |Worker { mv_worker_index } aborted: { lx_worker->get_text( ) }| ).
    ENDTRY.

    lo_log->add_info( |Worker { mv_worker_index } finished: { lv_success } ok / { lv_failed } failed| ).
    lo_log->save( ).
  ENDMETHOD.

ENDCLASS.
