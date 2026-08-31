CLASS zcl_bapi_integration_caller DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

* Clean Core orchestrator.
* Receives a zif_bapi_integration_executor through injection (the composition root
* is in zcl_http_bapi_integration) and iterates over the chunk documents.
* Contains no calls to non-released APIs.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING io_executor TYPE REF TO zif_bapi_integration_executor.

    METHODS process_chunk
      IMPORTING it_documents      TYPE zif_bapi_integration_executor=>tt_documents
      RETURNING VALUE(rt_results) TYPE zif_bapi_integration_executor=>tt_doc_results
      RAISING   cx_static_check.

  PRIVATE SECTION.
    DATA mo_executor TYPE REF TO zif_bapi_integration_executor.
ENDCLASS.


CLASS zcl_bapi_integration_caller IMPLEMENTATION.

  METHOD constructor.
    mo_executor = io_executor.
  ENDMETHOD.

  METHOD process_chunk.
    LOOP AT it_documents INTO DATA(ls_doc).
      APPEND mo_executor->execute( ls_doc ) TO rt_results.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

