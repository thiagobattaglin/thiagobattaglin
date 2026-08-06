"! <p class="shorttext synchronized">Generic load input/result DTO</p>
"!
"! Object-agnostic types shared by HTTP API, RAP saver, orchestrator,
"! workers and adapters. `fields` is a name/value bag that each adapter
"! interprets according to the target BAPI.
CLASS zcl_load_dto DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_field,
        name  TYPE string,
        value TYPE string,
      END OF ty_field,

      tt_field TYPE STANDARD TABLE OF ty_field WITH DEFAULT KEY,

      "! One input record. object_type resolves the adapter; fields carries
      "! the BAPI-specific values as a name/value list.
      BEGIN OF ty_input,
        ext_id      TYPE c LENGTH 20,
        object_type TYPE c LENGTH 20,
        fields      TYPE tt_field,
      END OF ty_input,

      tt_input TYPE STANDARD TABLE OF ty_input WITH KEY ext_id,

      BEGIN OF ty_result,
        ext_id    TYPE c LENGTH 20,
        entity_id TYPE c LENGTH 30,     " created entity number/id
        status    TYPE c LENGTH 1,      " S = Success / E = Error
        message   TYPE string,
      END OF ty_result,

      tt_result TYPE STANDARD TABLE OF ty_result WITH KEY ext_id.

    CLASS-METHODS get_field
      IMPORTING it_fields TYPE tt_field
                iv_name   TYPE csequence
      RETURNING VALUE(rv_value) TYPE string.

ENDCLASS.


CLASS zcl_load_dto IMPLEMENTATION.

  METHOD get_field.
    rv_value = VALUE #( it_fields[ name = to_lower( iv_name ) ]-value OPTIONAL ).
    IF rv_value IS INITIAL.
      rv_value = VALUE #( it_fields[ name = iv_name ]-value OPTIONAL ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
