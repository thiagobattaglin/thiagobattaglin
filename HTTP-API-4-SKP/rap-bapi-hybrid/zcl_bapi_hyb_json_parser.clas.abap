CLASS zcl_bapi_hyb_json_parser DEFINITION
  PUBLIC
  CREATE PUBLIC.

* Thin wrapper around the kernel-side sXML + CALL TRANSFORMATION id
* pipeline. Replaces every /ui2/cl_json call in the codebase with a
* single, testable, released-API entry point.

  PUBLIC SECTION.

    "! Deserialize any JSON string into any ABAP-compatible target.
    "! Uses cl_sxml_string_reader + CALL TRANSFORMATION id (kernel).
    CLASS-METHODS deserialize
      IMPORTING iv_json TYPE string
      CHANGING  cs_data TYPE any
      RAISING   cx_transformation_error.

    "! Serialize any ABAP data to compact JSON via sXML writer + CTF id.
    CLASS-METHODS serialize
      IMPORTING is_data        TYPE any
      RETURNING VALUE(rv_json) TYPE string
      RAISING   cx_transformation_error.

ENDCLASS.


CLASS zcl_bapi_hyb_json_parser IMPLEMENTATION.

  METHOD deserialize.
    DATA(lo_reader) = cl_sxml_string_reader=>create(
                        cl_abap_codepage=>convert_to( iv_json ) ).

    CALL TRANSFORMATION id
      SOURCE XML lo_reader
      RESULT data = cs_data.
  ENDMETHOD.

  METHOD serialize.
    DATA(lo_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

    CALL TRANSFORMATION id
      SOURCE data = is_data
      RESULT XML lo_writer.

    rv_json = cl_abap_codepage=>convert_from( lo_writer->get_output( ) ).
  ENDMETHOD.

ENDCLASS.
