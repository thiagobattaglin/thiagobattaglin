"! <p class="shorttext synchronized">Sink: accumulates results in memory</p>
CLASS zcl_load_sink_memory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_load_sink.

  PRIVATE SECTION.
    DATA mt_result TYPE zcl_load_dto=>tt_result.

ENDCLASS.


CLASS zcl_load_sink_memory IMPLEMENTATION.

  METHOD zif_load_sink~append_results.
    APPEND LINES OF it_result TO mt_result.
  ENDMETHOD.

  METHOD zif_load_sink~get_results.
    rt_result = mt_result.
  ENDMETHOD.

ENDCLASS.
