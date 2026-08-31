INTERFACE zif_bapi_integration_executor
  PUBLIC.

* Clean Core contract for executing one document against a BAPI.
* The default implementation (zcl_bapi_integration_exec) uses CALL FUNCTION
* dynamically + PARAMETER-TABLE + BAPI_TRANSACTION_COMMIT/ROLLBACK, all
* non-released in pure ABAP Cloud. In Cloud, replace it with an implementation
* based on a whitelist of released BAPIs or RAP/EML.
*
* The core (zcl_bapi_integration_caller and the parallel provider) depends
* only on this interface \u2014 it is the only point where the legacy implementation
* fica acoplada, definido no composition root (zcl_http_bapi_integration).

  TYPES:
    BEGIN OF ty_field,
      name  TYPE string,
      value TYPE string,
    END OF ty_field,
    tt_fields TYPE STANDARD TABLE OF ty_field WITH DEFAULT KEY.

  TYPES:
    BEGIN OF ty_struct,
      value  TYPE string,
      fields TYPE tt_fields,
    END OF ty_struct,
    tt_structs TYPE STANDARD TABLE OF ty_struct WITH DEFAULT KEY.

  TYPES:
    BEGIN OF ty_document,
      heders_values TYPE tt_structs,
      items_values  TYPE tt_structs,
    END OF ty_document,
    tt_documents TYPE STANDARD TABLE OF ty_document WITH DEFAULT KEY.

  TYPES:
    BEGIN OF ty_message,
      type    TYPE symsgty,
      id      TYPE symsgid,
      number  TYPE symsgno,
      message TYPE string,
    END OF ty_message,
    tt_messages TYPE STANDARD TABLE OF ty_message WITH DEFAULT KEY.

  TYPES:
    BEGIN OF ty_doc_result,
      success  TYPE abap_bool,
      messages TYPE tt_messages,
    END OF ty_doc_result,
    tt_doc_results TYPE STANDARD TABLE OF ty_doc_result WITH DEFAULT KEY.

  METHODS execute
    IMPORTING is_document      TYPE ty_document
    RETURNING VALUE(rs_result) TYPE ty_doc_result
    RAISING   cx_static_check.

ENDINTERFACE.
