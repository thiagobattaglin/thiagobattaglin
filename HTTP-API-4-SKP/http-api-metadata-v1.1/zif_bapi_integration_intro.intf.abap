INTERFACE zif_bapi_integration_intro
  PUBLIC.

* Clean Core contract for discovering BAPI metadata.
* The default implementation (zcl_bapi_integration_intro) uses legacy APIs
* (FUNCTION_IMPORT_INTERFACE + DDIF_FIELDINFO_GET). Em ABAP Cloud puro,
* replace it with an implementation based on a whitelist + cl_abap_typedescr.

  TYPES:
    BEGIN OF ty_field,
      name    TYPE string,
      type    TYPE string,
      length  TYPE i,
      size    TYPE i,
      decimal TYPE i,
    END OF ty_field,
    tt_field TYPE STANDARD TABLE OF ty_field WITH DEFAULT KEY.

  TYPES:
    BEGIN OF ty_struct_meta,
      param_name TYPE string,
      json_name  TYPE string,   " 'structure' | 'table'
      fields     TYPE tt_field,
    END OF ty_struct_meta,
    tt_struct_meta TYPE STANDARD TABLE OF ty_struct_meta WITH DEFAULT KEY.

  TYPES:
    BEGIN OF ty_bapi_meta,
      bapi_name TYPE string,
      headers   TYPE tt_struct_meta,
      items     TYPE tt_struct_meta,
    END OF ty_bapi_meta.

  METHODS describe
    IMPORTING iv_bapi_name   TYPE csequence
    RETURNING VALUE(rs_meta) TYPE ty_bapi_meta
    RAISING   cx_static_check.

ENDINTERFACE.
