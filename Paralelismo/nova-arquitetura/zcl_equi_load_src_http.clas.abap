"! <p class="shorttext synchronized">Source: payload from the HTTP request body</p>
"!
"! Receives the already-deserialized input via constructor.
"! The HTTP handler performs JSON deserialization and injects the payload here.
CLASS zcl_equi_load_src_http DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_equi_load_source.

    METHODS constructor
      IMPORTING it_input TYPE zcl_equi_load_dto=>tt_input.

  PRIVATE SECTION.
    DATA mt_input TYPE zcl_equi_load_dto=>tt_input.

ENDCLASS.


CLASS zcl_equi_load_src_http IMPLEMENTATION.

  METHOD constructor.
    mt_input = it_input.
  ENDMETHOD.

  METHOD zif_equi_load_source~read_all.
    rt_input = mt_input.
  ENDMETHOD.

ENDCLASS.
