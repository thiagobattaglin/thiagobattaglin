"! <p class="shorttext synchronized">Unit tests do processor (isolado de RAP/bgPF)</p>
"!
"! Este include deve ser colocado no include *Test Classes* da classe
"! ZCL_PO_PACKAGE_PROCESSOR no ADT. Ele testa a camada de orquestração
"! e o mapeamento input -> resultado usando um sink em memória.
CLASS ltcl_po_package_processor DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS empty_input_produces_no_result FOR TESTING.
    METHODS sink_receives_results          FOR TESTING.

ENDCLASS.


CLASS ltd_sink_spy DEFINITION FOR TESTING.
  PUBLIC SECTION.
    INTERFACES zif_po_load_sink.
    DATA received TYPE zcl_po_load_dto=>tt_result.
ENDCLASS.

CLASS ltd_sink_spy IMPLEMENTATION.
  METHOD zif_po_load_sink~append_results.
    APPEND LINES OF it_result TO received.
  ENDMETHOD.
ENDCLASS.


CLASS ltcl_po_package_processor IMPLEMENTATION.

  METHOD empty_input_produces_no_result.

    DATA(lo_spy) = NEW ltd_sink_spy( ).
    DATA(lo_cut) = NEW zcl_po_package_processor(
                     it_input = VALUE #( )
                     io_sink  = lo_spy ).

    lo_cut->if_bgmc_op_single_tx_uncontrolled~execute( ).

    cl_abap_unit_assert=>assert_initial(
      act = lo_spy->received
      msg = 'Sem input, sink não deve receber resultados' ).

  ENDMETHOD.

  METHOD sink_receives_results.
    " Este teste depende de test double do RAP BO (I_PurchaseOrderTP).
    " Recomenda-se usar CDS test double framework:
    "   cl_cds_test_environment / cl_abap_behavior_testdouble
    " para simular o comportamento do BO em memória e validar o mapping.
    " Estrutura deixada como TODO consciente para não acoplar o exemplo
    " a um double específico do seu sistema.
    cl_abap_unit_assert=>fail(
      msg = 'TODO: implementar com cl_abap_behavior_testdouble' ).
  ENDMETHOD.

ENDCLASS.
