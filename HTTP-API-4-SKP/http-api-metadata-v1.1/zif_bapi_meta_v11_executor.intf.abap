INTERFACE zif_bapi_meta_v11_executor
  PUBLIC.

* Contrato Clean Core para execu\u00e7\u00e3o de 1 documento contra uma BAPI.
* A implementa\u00e7\u00e3o padr\u00e3o (zcl_bapi_meta_v11_lgcy_exec) usa CALL FUNCTION
* din\u00e2mico + PARAMETER-TABLE + BAPI_TRANSACTION_COMMIT/ROLLBACK, todos
* NAO released em ABAP Cloud puro. Em Cloud, trocar por implementa\u00e7\u00e3o
* baseada em whitelist de BAPIs released ou RAP/EML.
*
* O n\u00facleo (zcl_bapi_meta_v11_caller e o provider paralelo) depende
* apenas dessa interface \u2014 \u00e9 o \u00fanico ponto onde a implementa\u00e7\u00e3o legacy
* fica acoplada, definido no composition root (zcl_http_bapi_meta_v11).

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
