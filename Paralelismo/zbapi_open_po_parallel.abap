*&---------------------------------------------------------------------*
*& Report ZBAPI_OPEN_PO_PARALLEL
*&---------------------------------------------------------------------*
*& Exemplo de carga massiva de Open Purchase Orders (Ordens de Compra)
*& usando BAPI_PO_CREATE1 com:
*&   - Processamento em pacotes (packages / chunks)
*&   - Commit por pacote (não a cada registro)
*&   - Paralelismo via aRFC (CALL FUNCTION ... STARTING NEW TASK)
*&   - Controle de tarefas ativas (WAIT UNTIL) para não estourar o pool
*&
*& OBS: adapte o nome da BAPI para a sua realidade:
*&   - Purchase Order (MM):   BAPI_PO_CREATE1
*&   - Sales Order   (SD):    BAPI_SALESORDER_CREATEFROMDAT2
*&   - Production Order (PP): BAPI_PRODORD_CREATE
*&   - Maintenance Order (PM):BAPI_ALM_ORDER_MAINTAIN
*&---------------------------------------------------------------------*
REPORT zbapi_open_po_parallel.

*----------------------------------------------------------------------*
* Tipos
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_input,
         ext_id   TYPE char20,   " ID externo do arquivo / staging
         vendor   TYPE lifnr,
         purch_org TYPE ekorg,
         pur_group TYPE bkgrp,
         comp_code TYPE bukrs,
         doc_type  TYPE esart,
         material  TYPE matnr,
         plant     TYPE werks_d,
         quantity  TYPE menge_d,
         net_price TYPE bprei,
         deliv_date TYPE eindt,
       END OF ty_input,

       tt_input TYPE STANDARD TABLE OF ty_input WITH DEFAULT KEY,

       BEGIN OF ty_result,
         ext_id   TYPE char20,
         ebeln    TYPE ebeln,
         status   TYPE char1,          " S = success / E = error
         message  TYPE string,
       END OF ty_result,

       tt_result TYPE STANDARD TABLE OF ty_result WITH DEFAULT KEY.

*----------------------------------------------------------------------*
* Variáveis globais
*----------------------------------------------------------------------*
DATA: gt_input        TYPE tt_input,
      gt_result       TYPE tt_result,
      gv_tasks_active TYPE i,
      gv_tasks_done   TYPE i,
      gv_server_group TYPE rzlli_apcl.

*----------------------------------------------------------------------*
* Parâmetros de execução
*----------------------------------------------------------------------*
PARAMETERS:
  p_file    TYPE string LOWER CASE DEFAULT 'C:\temp\open_po.csv',
  p_pkgsz   TYPE i DEFAULT 100,   " tamanho do pacote (registros por task)
  p_paral   TYPE i DEFAULT 5,     " nº máximo de tasks paralelas
  p_srvgrp  TYPE rzlli_apcl DEFAULT 'parallel_generators',
  p_test    AS CHECKBOX DEFAULT 'X'.  " modo teste (não commita)

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  gv_server_group = p_srvgrp.

  PERFORM load_input      USING p_file CHANGING gt_input.
  PERFORM dispatch_parallel.
  PERFORM wait_all_tasks.
  PERFORM show_results.

*&---------------------------------------------------------------------*
*&      Form  LOAD_INPUT
*&---------------------------------------------------------------------*
* Carrega os dados de origem. Aqui simplifiquei — em produção você
* leria de uma tabela de staging, arquivo AL11, etc.
*----------------------------------------------------------------------*
FORM load_input USING iv_file TYPE string
                CHANGING ct_input TYPE tt_input.

  " Exemplo mínimo — substitua pela sua leitura real
  DATA(lt_dummy) = VALUE tt_input(
    ( ext_id = 'EXT0001' vendor = '0000100000' purch_org = '1000'
      pur_group = '001' comp_code = '1000' doc_type = 'NB'
      material = 'MAT-001' plant = '1000'
      quantity = 10 net_price = '15.50' deliv_date = sy-datum + 7 )
    ( ext_id = 'EXT0002' vendor = '0000100000' purch_org = '1000'
      pur_group = '001' comp_code = '1000' doc_type = 'NB'
      material = 'MAT-002' plant = '1000'
      quantity = 5  net_price = '99.00' deliv_date = sy-datum + 7 )
  ).

  ct_input = lt_dummy.

  WRITE: / 'Registros carregados:', lines( ct_input ).

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPATCH_PARALLEL
*&---------------------------------------------------------------------*
* Quebra os dados em pacotes de P_PKGSZ e dispara cada pacote em uma
* task assíncrona (aRFC). Controla o número máximo de tasks simultâneas
* via P_PARAL.
*----------------------------------------------------------------------*
FORM dispatch_parallel.

  DATA: lt_package   TYPE tt_input,
        lv_taskname  TYPE char32,
        lv_pkg_index TYPE i VALUE 0,
        lv_offset    TYPE i VALUE 0,
        lv_total     TYPE i,
        lv_rc        TYPE sy-subrc.

  lv_total = lines( gt_input ).

  WHILE lv_offset < lv_total.

    " Monta um pacote de P_PKGSZ registros
    CLEAR lt_package.
    LOOP AT gt_input INTO DATA(ls_row) FROM lv_offset + 1.
      APPEND ls_row TO lt_package.
      IF lines( lt_package ) >= p_pkgsz.
        EXIT.
      ENDIF.
    ENDLOOP.

    lv_offset = lv_offset + lines( lt_package ).
    lv_pkg_index = lv_pkg_index + 1.

    " Controla o número máximo de tasks em paralelo.
    " Enquanto o pool estiver cheio, espera qualquer task terminar.
    WHILE gv_tasks_active >= p_paral.
      WAIT UNTIL gv_tasks_active < p_paral UP TO 60 SECONDS.
    ENDWHILE.

    " Nome único para a task
    lv_taskname = |PO_PKG_{ lv_pkg_index WIDTH = 6 ALIGN = RIGHT PAD = '0' }|.

    " Dispara pacote em paralelo, roteando pelo server group RZ12
    CALL FUNCTION 'Z_CREATE_PO_PACKAGE'
      STARTING NEW TASK lv_taskname
      DESTINATION IN GROUP gv_server_group
      CALLING receive_task_result ON END OF TASK
      EXPORTING
        iv_test_run = p_test
        it_input    = lt_package
      EXCEPTIONS
        communication_failure = 1
        system_failure        = 2
        resource_failure      = 3
        OTHERS                = 4.

    lv_rc = sy-subrc.

    CASE lv_rc.
      WHEN 0.
        gv_tasks_active = gv_tasks_active + 1.
        WRITE: / 'Task disparada:', lv_taskname,
                 '| ativas:', gv_tasks_active.
      WHEN 3.
        " Sem recurso livre — espera e tenta novamente o mesmo pacote
        WAIT UNTIL gv_tasks_active < p_paral UP TO 30 SECONDS.
        lv_offset = lv_offset - lines( lt_package ).
        lv_pkg_index = lv_pkg_index - 1.
      WHEN OTHERS.
        " Falha grave ao disparar — processa síncrono como fallback
        PERFORM process_package_sync USING lt_package.
    ENDCASE.

  ENDWHILE.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  RECEIVE_TASK_RESULT
*&---------------------------------------------------------------------*
* Callback chamado automaticamente pelo aRFC ao término de cada task.
* Aqui coletamos o resultado e decrementamos o contador de tasks.
*----------------------------------------------------------------------*
FORM receive_task_result USING p_taskname TYPE clike.

  DATA: lt_result TYPE tt_result.

  RECEIVE RESULTS FROM FUNCTION 'Z_CREATE_PO_PACKAGE'
    IMPORTING
      et_result             = lt_result
    EXCEPTIONS
      communication_failure = 1
      system_failure        = 2
      OTHERS                = 3.

  IF sy-subrc = 0.
    APPEND LINES OF lt_result TO gt_result.
  ELSE.
    APPEND VALUE #( ext_id  = p_taskname
                    status  = 'E'
                    message = |Falha aRFC subrc={ sy-subrc }| )
           TO gt_result.
  ENDIF.

  gv_tasks_active = gv_tasks_active - 1.
  gv_tasks_done   = gv_tasks_done + 1.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  WAIT_ALL_TASKS
*&---------------------------------------------------------------------*
* Espera todas as tasks pendentes terminarem antes de encerrar.
*----------------------------------------------------------------------*
FORM wait_all_tasks.
  WAIT UNTIL gv_tasks_active = 0 UP TO 3600 SECONDS.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PROCESS_PACKAGE_SYNC
*&---------------------------------------------------------------------*
* Fallback síncrono caso não seja possível abrir a task paralela.
*----------------------------------------------------------------------*
FORM process_package_sync USING it_input TYPE tt_input.

  DATA: lt_result TYPE tt_result.

  CALL FUNCTION 'Z_CREATE_PO_PACKAGE'
    EXPORTING
      iv_test_run = p_test
      it_input    = it_input
    IMPORTING
      et_result   = lt_result.

  APPEND LINES OF lt_result TO gt_result.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SHOW_RESULTS
*&---------------------------------------------------------------------*
FORM show_results.

  DATA: lv_ok  TYPE i,
        lv_err TYPE i.

  LOOP AT gt_result INTO DATA(ls_r).
    IF ls_r-status = 'S'.
      lv_ok = lv_ok + 1.
    ELSE.
      lv_err = lv_err + 1.
    ENDIF.
    WRITE: / ls_r-ext_id, ls_r-ebeln, ls_r-status, ls_r-message.
  ENDLOOP.

  WRITE: / '----------------------------------------'.
  WRITE: / 'Sucesso :', lv_ok.
  WRITE: / 'Erros   :', lv_err.
  WRITE: / 'Pacotes :', gv_tasks_done.

ENDFORM.


*======================================================================*
* FUNCTION MODULE (RFC) — deve ser criado na SE37 como REMOTE-ENABLED
*======================================================================*
* FUNCTION Z_CREATE_PO_PACKAGE.
* *"----------------------------------------------------------------------
* *"*"Interface local:
* *"  IMPORTING
* *"     VALUE(IV_TEST_RUN) TYPE  FLAG DEFAULT 'X'
* *"     VALUE(IT_INPUT)    TYPE  ZTT_PO_INPUT
* *"  EXPORTING
* *"     VALUE(ET_RESULT)   TYPE  ZTT_PO_RESULT
* *"----------------------------------------------------------------------
*
*   DATA: ls_header      TYPE bapimepoheader,
*         ls_headerx     TYPE bapimepoheaderx,
*         lt_item        TYPE STANDARD TABLE OF bapimepoitem,
*         lt_itemx       TYPE STANDARD TABLE OF bapimepoitemx,
*         lt_sched       TYPE STANDARD TABLE OF bapimeposchedule,
*         lt_schedx      TYPE STANDARD TABLE OF bapimeposchedulx,
*         lt_return      TYPE STANDARD TABLE OF bapiret2,
*         lv_ebeln       TYPE ebeln,
*         lv_success_cnt TYPE i.
*
*   " Processa registro a registro, mas com UM ÚNICO COMMIT NO FINAL
*   " do pacote — este é o ganho principal de performance.
*   LOOP AT it_input INTO DATA(ls_in).
*
*     CLEAR: ls_header, ls_headerx,
*            lt_item, lt_itemx, lt_sched, lt_schedx,
*            lt_return, lv_ebeln.
*
*     " Header
*     ls_header-vendor   = ls_in-vendor.
*     ls_header-purch_org = ls_in-purch_org.
*     ls_header-pur_group = ls_in-pur_group.
*     ls_header-comp_code = ls_in-comp_code.
*     ls_header-doc_type  = ls_in-doc_type.
*
*     ls_headerx-vendor   = 'X'.
*     ls_headerx-purch_org = 'X'.
*     ls_headerx-pur_group = 'X'.
*     ls_headerx-comp_code = 'X'.
*     ls_headerx-doc_type  = 'X'.
*
*     " Item
*     APPEND VALUE #( po_item = '00010'
*                     material = ls_in-material
*                     plant    = ls_in-plant
*                     quantity = ls_in-quantity
*                     net_price = ls_in-net_price ) TO lt_item.
*
*     APPEND VALUE #( po_item = '00010'
*                     material = 'X' plant = 'X'
*                     quantity = 'X' net_price = 'X' ) TO lt_itemx.
*
*     " Schedule
*     APPEND VALUE #( po_item = '00010'
*                     sched_line = '0001'
*                     delivery_date = ls_in-deliv_date
*                     quantity      = ls_in-quantity ) TO lt_sched.
*
*     APPEND VALUE #( po_item = '00010'
*                     sched_line = '0001'
*                     delivery_date = 'X'
*                     quantity      = 'X' ) TO lt_schedx.
*
*     CALL FUNCTION 'BAPI_PO_CREATE1'
*       EXPORTING
*         poheader         = ls_header
*         poheaderx        = ls_headerx
*         testrun          = iv_test_run
*       IMPORTING
*         exppurchaseorder = lv_ebeln
*       TABLES
*         return           = lt_return
*         poitem           = lt_item
*         poitemx          = lt_itemx
*         poschedule       = lt_sched
*         poschedulex      = lt_schedx.
*
*     " Avalia retorno
*     READ TABLE lt_return TRANSPORTING NO FIELDS
*       WITH KEY type = 'E'.
*     IF sy-subrc = 0 OR lv_ebeln IS INITIAL.
*       APPEND VALUE #( ext_id  = ls_in-ext_id
*                       status  = 'E'
*                       message = lt_return[ type = 'E' ]-message )
*              TO et_result.
*       " Nada de rollback global aqui — só o registro atual falha.
*       " O BAPI_PO_CREATE1 já não persistiu nada porque não houve commit.
*     ELSE.
*       APPEND VALUE #( ext_id  = ls_in-ext_id
*                       ebeln   = lv_ebeln
*                       status  = 'S'
*                       message = 'OK' )
*              TO et_result.
*       lv_success_cnt = lv_success_cnt + 1.
*     ENDIF.
*
*   ENDLOOP.
*
*   " COMMIT ÚNICO POR PACOTE — este é o ponto que evita
*   " commits caros a cada BAPI e acelera muito a carga.
*   IF iv_test_run IS INITIAL AND lv_success_cnt > 0.
*     CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*       EXPORTING
*         wait = 'X'.
*   ELSE.
*     CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*   ENDIF.
*
* ENDFUNCTION.
*======================================================================*
