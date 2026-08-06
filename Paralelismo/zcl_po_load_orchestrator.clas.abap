"! <p class="shorttext synchronized">Orquestra a carga: split em pacotes + bgPF</p>
"!
"! Substitui o antigo dispatcher aRFC (CALL FUNCTION STARTING NEW TASK).
"! Usa o Background Processing Framework released (bgPF), que:
"!   - roda em processos batch dedicados
"!   - controla retry, isolamento de LUW e observabilidade
"!   - é cloud-ready (Clean Core Level 1)
CLASS zcl_po_load_orchestrator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING io_source     TYPE REF TO zif_po_load_source
                io_sink       TYPE REF TO zif_po_load_sink
                iv_package_size TYPE i DEFAULT 100.

    METHODS run.

  PRIVATE SECTION.

    DATA mo_source       TYPE REF TO zif_po_load_source.
    DATA mo_sink         TYPE REF TO zif_po_load_sink.
    DATA mv_package_size TYPE i.

    METHODS build_packages
      IMPORTING it_input     TYPE zcl_po_load_dto=>tt_input
      RETURNING VALUE(rt_packages) TYPE STANDARD TABLE OF zcl_po_load_dto=>tt_input
                                    WITH EMPTY KEY.

    METHODS submit_package
      IMPORTING it_package TYPE zcl_po_load_dto=>tt_input.

ENDCLASS.


CLASS zcl_po_load_orchestrator IMPLEMENTATION.

  METHOD constructor.
    mo_source       = io_source.
    mo_sink         = io_sink.
    mv_package_size = iv_package_size.
  ENDMETHOD.

  METHOD run.

    DATA(lt_input) = mo_source->read_all( ).

    DATA(lt_packages) = build_packages( lt_input ).

    LOOP AT lt_packages INTO DATA(lt_pkg).
      submit_package( lt_pkg ).
    ENDLOOP.

    " O bgPF persiste as unidades e o scheduler executa em paralelo
    " conforme a configuração do sistema (perfil bgRFC / batch).
    " Nenhum WAIT UNTIL / COMMIT WORK aqui: o commit da fila de bgPF
    " é feito pelo próprio framework após a submissão.

  ENDMETHOD.

  METHOD build_packages.

    DATA lt_current TYPE zcl_po_load_dto=>tt_input.

    LOOP AT it_input INTO DATA(ls_row).
      APPEND ls_row TO lt_current.
      IF lines( lt_current ) >= mv_package_size.
        APPEND lt_current TO rt_packages.
        CLEAR lt_current.
      ENDIF.
    ENDLOOP.

    IF lt_current IS NOT INITIAL.
      APPEND lt_current TO rt_packages.
    ENDIF.

  ENDMETHOD.

  METHOD submit_package.

    " Cria a unidade de trabalho e submete ao bgPF.
    " O framework roteia para um work process livre em paralelo.
    DATA(lo_processor) = NEW zcl_po_package_processor(
                          it_input = it_package
                          io_sink  = mo_sink ).

    TRY.
        cl_bgmc_process_factory=>get_default( )->create( )->set_name( 'PO_LOAD_PACKAGE'
          )->set_operation( lo_processor
          )->save_for_execution( ).

      CATCH cx_bgmc INTO DATA(lx_bgmc).
        " Fallback: em caso de falha ao enfileirar, executa síncrono
        " no mesmo work process. Registra e prossegue.
        lo_processor->if_bgmc_op_single_tx_uncontrolled~execute( ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
