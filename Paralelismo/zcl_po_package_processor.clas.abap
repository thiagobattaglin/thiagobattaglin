"! <p class="shorttext synchronized">Processa 1 pacote de PO — unidade de trabalho bgPF</p>
"!
"! Esta classe é a *unit of work* enviada ao bgPF. Cada instância processa
"! UM pacote de registros em UMA LUW própria e faz UM único COMMIT ENTITIES
"! ao final via RAP — este é o ganho de performance principal.
"!
"! Implementa if_bgmc_op_single_tx_uncontrolled: o bgPF cuida da LUW,
"! do retry e do isolamento de erros por pacote.
CLASS zcl_po_package_processor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_bgmc_op_single_tx_uncontrolled.
    INTERFACES if_bgmc_process_parameter.

    METHODS constructor
      IMPORTING it_input TYPE zcl_po_load_dto=>tt_input
                io_sink  TYPE REF TO zif_po_load_sink.

  PRIVATE SECTION.

    DATA mt_input TYPE zcl_po_load_dto=>tt_input.
    DATA mo_sink  TYPE REF TO zif_po_load_sink.

    METHODS create_purchase_orders
      RETURNING VALUE(rt_result) TYPE zcl_po_load_dto=>tt_result.

ENDCLASS.


CLASS zcl_po_package_processor IMPLEMENTATION.

  METHOD constructor.
    mt_input = it_input.
    mo_sink  = io_sink.
  ENDMETHOD.

  METHOD if_bgmc_op_single_tx_uncontrolled~execute.
    " Chamada única pelo bgPF. Aqui NÃO se faz COMMIT WORK.
    " O RAP (COMMIT ENTITIES) coordena a persistência.
    DATA(lt_result) = create_purchase_orders( ).
    mo_sink->append_results( lt_result ).
  ENDMETHOD.

  METHOD if_bgmc_process_parameter~get_transaction_mode.
    " Uma LUW controlada por pacote.
    result = if_bgmc_process_parameter=>transaction_mode-single_transaction.
  ENDMETHOD.

  METHOD create_purchase_orders.

    " Monta a coleção de entidades a criar no RAP BO released de
    " Purchase Order. O nome exato do BO/entidade depende do release:
    "   - S/4HANA Cloud: I_PurchaseOrderTP (released, C1)
    " Ajuste conforme a versão disponível no seu sistema.

    DATA lt_po_create TYPE TABLE FOR CREATE i_purchaseordertp.
    DATA lt_item_create TYPE TABLE FOR CREATE i_purchaseordertp\_purchaseorderitem.

    LOOP AT mt_input INTO DATA(ls_in).

      DATA(lv_cid) = |CID_{ ls_in-ext_id }|.

      APPEND VALUE #(
        %cid            = lv_cid
        Supplier        = ls_in-vendor
        PurchasingOrganization = ls_in-purch_org
        PurchasingGroup = ls_in-pur_group
        CompanyCode     = ls_in-comp_code
        PurchaseOrderType = ls_in-doc_type
      ) TO lt_po_create.

      APPEND VALUE #(
        %cid_ref = lv_cid
        %target  = VALUE #(
          ( %cid            = |{ lv_cid }_I10|
            PurchaseOrderItem = '00010'
            Material          = ls_in-material
            Plant             = ls_in-plant
            OrderQuantity     = ls_in-quantity
            NetPriceAmount    = ls_in-net_price
            ScheduleLineDeliveryDate = ls_in-deliv_date )
        )
      ) TO lt_item_create.

    ENDLOOP.

    " EML: MODIFY + COMMIT ENTITIES respondem por criação e commit atômico
    " do pacote inteiro. Sem BAPI_TRANSACTION_COMMIT.
    MODIFY ENTITIES OF i_purchaseordertp
      ENTITY PurchaseOrder
        CREATE FIELDS ( Supplier PurchasingOrganization PurchasingGroup
                        CompanyCode PurchaseOrderType )
          WITH lt_po_create
        CREATE BY \_PurchaseOrderItem
          FIELDS ( PurchaseOrderItem Material Plant OrderQuantity
                   NetPriceAmount ScheduleLineDeliveryDate )
          WITH lt_item_create
      MAPPED   DATA(ls_mapped)
      FAILED   DATA(ls_failed)
      REPORTED DATA(ls_reported).

    COMMIT ENTITIES RESPONSE OF i_purchaseordertp
      FAILED   DATA(ls_commit_failed)
      REPORTED DATA(ls_commit_reported).

    " Monta o resultado a partir de MAPPED (sucesso) e FAILED (erro)
    LOOP AT mt_input INTO ls_in.

      DATA(lv_cid) = |CID_{ ls_in-ext_id }|.

      READ TABLE ls_mapped-purchaseorder
        WITH KEY %cid = lv_cid ASSIGNING FIELD-SYMBOL(<ls_ok>).

      IF sy-subrc = 0 AND <ls_ok>-PurchaseOrder IS NOT INITIAL.
        APPEND VALUE #( ext_id         = ls_in-ext_id
                        purchase_order = <ls_ok>-PurchaseOrder
                        status         = 'S'
                        message        = 'OK' )
               TO rt_result.
      ELSE.
        " Coleta a primeira mensagem de erro relacionada
        DATA(lv_msg) = COND string(
          LET lo_msg = VALUE #( ls_reported-purchaseorder[ %cid = lv_cid ]-%msg
                                OPTIONAL )
          IN  WHEN lo_msg IS BOUND
              THEN lo_msg->if_message~get_text( )
              ELSE `Falha desconhecida ao criar PO` ).

        APPEND VALUE #( ext_id  = ls_in-ext_id
                        status  = 'E'
                        message = lv_msg )
               TO rt_result.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
