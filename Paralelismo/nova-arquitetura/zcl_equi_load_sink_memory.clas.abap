"! <p class="shorttext synchronized">Sink: accumulates results in memory (safe per worker)</p>
"!
"! Each bgPF worker owns its OWN instance — no concurrent access
"! to the same object; isolation is guaranteed by the bgPF
"! (each unit-of-work runs in a separate LUW).
"!
"! Use this sink in the synchronous flow (HTTP API replying to the client).
"! For the async bgPF flow prefer zcl_equi_load_sink_applog
"! (Application Log) because it is persistent and observable.
CLASS zcl_equi_load_sink_memory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_equi_load_sink.

  PRIVATE SECTION.
    DATA mt_result TYPE zcl_equi_load_dto=>tt_result.

ENDCLASS.


CLASS zcl_equi_load_sink_memory IMPLEMENTATION.

  METHOD zif_equi_load_sink~append_results.
    APPEND LINES OF it_result TO mt_result.
  ENDMETHOD.

  METHOD zif_equi_load_sink~get_results.
    rt_result = mt_result.
  ENDMETHOD.

ENDCLASS.
