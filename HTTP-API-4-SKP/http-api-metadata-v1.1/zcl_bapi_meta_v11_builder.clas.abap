CLASS zcl_bapi_meta_v11_builder DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

* Núcleo Clean Core.
* Depende apenas da interface zif_bapi_meta_v11_introspector.
* Toda a introspecção DDIC (APIs não-released) fica isolada no adapter
* injetado pelo composition root (zcl_http_bapi_meta_v11).
*
* Serialização do JSON de resposta usa xco_cp_json (released em ABAP Cloud).

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING io_introspector TYPE REF TO zif_bapi_meta_v11_introspector.

    METHODS build_json
      IMPORTING iv_bapi_name   TYPE csequence
      RETURNING VALUE(rv_json) TYPE string
      RAISING   cx_static_check.

  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_field_out,
        name    TYPE string,
        type    TYPE string,
        length  TYPE i,
        size    TYPE i,
        decimal TYPE i,
      END OF ty_field_out.

    TYPES:
      BEGIN OF ty_header_out,
        structure TYPE string,
        fields    TYPE STANDARD TABLE OF ty_field_out WITH DEFAULT KEY,
      END OF ty_header_out.

    TYPES:
      BEGIN OF ty_item_out,
        table  TYPE string,
        fields TYPE STANDARD TABLE OF ty_field_out WITH DEFAULT KEY,
      END OF ty_item_out.

    TYPES:
      BEGIN OF ty_document_out,
        headers_values TYPE STANDARD TABLE OF ty_header_out WITH DEFAULT KEY,
        items_values   TYPE STANDARD TABLE OF ty_item_out   WITH DEFAULT KEY,
      END OF ty_document_out.

    TYPES:
      BEGIN OF ty_response,
        bapi_name TYPE string,
        documents TYPE STANDARD TABLE OF ty_document_out WITH DEFAULT KEY,
      END OF ty_response.

    DATA mo_introspector TYPE REF TO zif_bapi_meta_v11_introspector.

ENDCLASS.


CLASS zcl_bapi_meta_v11_builder IMPLEMENTATION.

  METHOD constructor.
    mo_introspector = io_introspector.
  ENDMETHOD.

  METHOD build_json.
    DATA ls_response TYPE ty_response.
    DATA ls_document TYPE ty_document_out.

    DATA(ls_meta) = mo_introspector->describe( iv_bapi_name ).

    ls_response-bapi_name = ls_meta-bapi_name.

    LOOP AT ls_meta-headers INTO DATA(ls_h).
      DATA ls_hdr_out TYPE ty_header_out.
      CLEAR ls_hdr_out.
      ls_hdr_out-structure = ls_h-param_name.
      LOOP AT ls_h-fields INTO DATA(ls_hf).
        APPEND VALUE #( name    = ls_hf-name
                        type    = ls_hf-type
                        length  = ls_hf-length
                        size    = ls_hf-size
                        decimal = ls_hf-decimal ) TO ls_hdr_out-fields.
      ENDLOOP.
      APPEND ls_hdr_out TO ls_document-headers_values.
    ENDLOOP.

    LOOP AT ls_meta-items INTO DATA(ls_i).
      DATA ls_itm_out TYPE ty_item_out.
      CLEAR ls_itm_out.
      ls_itm_out-table = ls_i-param_name.
      LOOP AT ls_i-fields INTO DATA(ls_if).
        APPEND VALUE #( name    = ls_if-name
                        type    = ls_if-type
                        length  = ls_if-length
                        size    = ls_if-size
                        decimal = ls_if-decimal ) TO ls_itm_out-fields.
      ENDLOOP.
      APPEND ls_itm_out TO ls_document-items_values.
    ENDLOOP.

    APPEND ls_document TO ls_response-documents.

    rv_json = xco_cp_json=>data->from_abap( ls_response )->to_string( ).
  ENDMETHOD.

ENDCLASS.

