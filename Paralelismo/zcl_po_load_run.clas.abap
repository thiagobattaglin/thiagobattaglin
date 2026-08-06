"! <p class="shorttext synchronized">Ponto de entrada Class-Run da carga de PO</p>
"!
"! Substitui o antigo REPORT + PARAMETERS + WRITE.
"! Executável direto no ADT (F9) como Class Run ou registrável como
"! App Job / Job Catalog Entry para uso funcional em produção.
CLASS zcl_po_load_run DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING.  " remova FOR TESTING ao promover para uso produtivo

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_po_load_run IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " Wire-up de dependências. Em produção use factories dedicadas ou
    " injeção. Aqui está inline para clareza do exemplo.
    DATA(lo_source) = CAST zif_po_load_source(
                        NEW zcl_po_load_source_staging( ) ).

    DATA(lo_sink)   = CAST zif_po_load_sink(
                        NEW zcl_po_load_sink_applog( ) ).

    DATA(lo_orch)   = NEW zcl_po_load_orchestrator(
                        io_source       = lo_source
                        io_sink         = lo_sink
                        iv_package_size = 100 ).

    lo_orch->run( ).

    out->write( `Carga submetida ao bgPF com sucesso.` ).

  ENDMETHOD.

ENDCLASS.
