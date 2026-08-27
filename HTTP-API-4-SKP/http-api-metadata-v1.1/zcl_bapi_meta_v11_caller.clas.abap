CLASS zcl_bapi_meta_v11_caller DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

* Orquestrador Clean Core.
* Recebe um zif_bapi_meta_v11_executor via injeção (composition root
* está em zcl_http_bapi_meta_v11) e itera pelos documentos do chunk.
* Não contém nenhuma chamada a API não-released.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING io_executor TYPE REF TO zif_bapi_meta_v11_executor.

    METHODS process_chunk
      IMPORTING it_documents      TYPE zif_bapi_meta_v11_executor=>tt_documents
      RETURNING VALUE(rt_results) TYPE zif_bapi_meta_v11_executor=>tt_doc_results
      RAISING   cx_static_check.

  PRIVATE SECTION.
    DATA mo_executor TYPE REF TO zif_bapi_meta_v11_executor.
ENDCLASS.


CLASS zcl_bapi_meta_v11_caller IMPLEMENTATION.

  METHOD constructor.
    mo_executor = io_executor.
  ENDMETHOD.

  METHOD process_chunk.
    LOOP AT it_documents INTO DATA(ls_doc).
      APPEND mo_executor->execute( ls_doc ) TO rt_results.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

