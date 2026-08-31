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
      IMPORTING iv_bapi_name TYPE string
                it_documents TYPE zif_bapi_integration_executor=>tt_documents.

  PRIVATE SECTION.
    DATA mv_bapi_name TYPE string.
    DATA mt_docs      TYPE zif_bapi_integration_executor=>tt_documents.
ENDCLASS.


CLASS zcl_bapi_integration_parallel IMPLEMENTATION.

  METHOD constructor.
    mv_bapi_name = iv_bapi_name.
    mt_docs      = it_documents.
  ENDMETHOD.

  METHOD if_abap_parallel~do.
    TRY.
        " Local composition in the worker \u2014 the only coupling point with legacy code.
        DATA(lo_exec) = CAST zif_bapi_integration_executor(
                          NEW zcl_bapi_integration_exec( mv_bapi_name ) ).

        LOOP AT mt_docs INTO DATA(ls_doc).
          lo_exec->execute( ls_doc ).
        ENDLOOP.

      CATCH cx_root ##NO_HANDLER.
        " Parallel execution must never bring down the framework worker.
        " Document errors are already handled by the executor through BAPI RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
