"! <p class="shorttext synchronized">Real implementation of the PM order BAPI facade</p>
CLASS /hdl/cl_alm_order_bapi DEFINITION
  PUBLIC
  CREATE PUBLIC
  FINAL.

  PUBLIC SECTION.
    INTERFACES /hdl/if_alm_order_bapi.

  PRIVATE SECTION.
    TYPES ty_bapiret2_tab TYPE STANDARD TABLE OF bapiret2 WITH EMPTY KEY.

    METHODS collect_messages
      IMPORTING it_return        TYPE ty_bapiret2_tab
                it_balmsg        TYPE bal_t_msg
      RETURNING VALUE(rs_result) TYPE /hdl/if_alm_order_bapi=>ty_result.
ENDCLASS.


CLASS /hdl/cl_alm_order_bapi IMPLEMENTATION.

  METHOD /hdl/if_alm_order_bapi~set_teco.
    DATA lt_balmsg TYPE bal_t_msg.
    DATA lt_return TYPE ty_bapiret2_tab.

    CALL FUNCTION 'IBAPI_ALM_ORDER_TECO_SET'
      EXPORTING
        iv_orderid  = iv_orderid
      TABLES
        et_messages = lt_balmsg
        return      = lt_return.

    rs_result = collect_messages( it_return = lt_return
                                  it_balmsg = lt_balmsg ).
  ENDMETHOD.

  METHOD /hdl/if_alm_order_bapi~set_clsd.
    DATA lt_balmsg TYPE bal_t_msg.
    DATA lt_return TYPE ty_bapiret2_tab.

    CALL FUNCTION 'IBAPI_ALM_ORDER_CLSD_SET'
      EXPORTING
        iv_orderid  = iv_orderid
      TABLES
        et_messages = lt_balmsg
        return      = lt_return.

    rs_result = collect_messages( it_return = lt_return
                                  it_balmsg = lt_balmsg ).
  ENDMETHOD.

  METHOD /hdl/if_alm_order_bapi~set_dlfl.
    DATA lt_balmsg TYPE bal_t_msg.
    DATA lt_return TYPE ty_bapiret2_tab.

    CALL FUNCTION 'IBAPI_ALM_ORDER_DLFL_SET'
      EXPORTING
        iv_orderid  = iv_orderid
      TABLES
        et_messages = lt_balmsg
        return      = lt_return.

    rs_result = collect_messages( it_return = lt_return
                                  it_balmsg = lt_balmsg ).
  ENDMETHOD.

  METHOD /hdl/if_alm_order_bapi~maintain_settlement_rule.
    DATA lt_return  TYPE ty_bapiret2_tab.
    DATA lt_methods TYPE STANDARD TABLE OF bapi_alm_order_method WITH EMPTY KEY.
    DATA lt_srule   TYPE STANDARD TABLE OF bapi_alm_order_srule WITH EMPTY KEY.

    " Header refresh / save methods around the settlement rule update
    APPEND VALUE bapi_alm_order_method(
      refnumber = '000000'
      objecttype = 'HEADER'
      method     = 'SRULE'
      objectkey  = iv_orderid ) TO lt_methods.

    APPEND VALUE bapi_alm_order_method(
      refnumber = ''
      objecttype = ''
      method     = 'SAVE'
      objectkey  = iv_orderid ) TO lt_methods.

    APPEND VALUE bapi_alm_order_srule(
      refnumber          = '000000'
      sequencenumber     = '001'
      settlement_type    = 'PER'
      source_assignment  = ''
      percentage         = '100.00'
      account_assignment_cat = 'KS'
      cost_ctr           = iv_kostl ) TO lt_srule.

    CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
      TABLES
        it_methods = lt_methods
        it_srule   = lt_srule
        return     = lt_return.

    rs_result = collect_messages( it_return = lt_return
                                  it_balmsg = VALUE bal_t_msg( ) ).
  ENDMETHOD.

  METHOD /hdl/if_alm_order_bapi~commit.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDMETHOD.

  METHOD /hdl/if_alm_order_bapi~rollback.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ENDMETHOD.

  METHOD collect_messages.
    DATA lv_has_error TYPE abap_bool VALUE abap_false.

    LOOP AT it_return INTO DATA(ls_ret).
      IF ls_ret-type = 'E' OR ls_ret-type = 'A' OR ls_ret-type = 'X'.
        lv_has_error = abap_true.
      ENDIF.
      APPEND |[{ ls_ret-type } { ls_ret-id }/{ ls_ret-number }] { ls_ret-message }|
             TO rs_result-messages.
    ENDLOOP.

    LOOP AT it_balmsg INTO DATA(ls_balmsg).
      IF ls_balmsg-msgty = 'E' OR ls_balmsg-msgty = 'A' OR ls_balmsg-msgty = 'X'.
        lv_has_error = abap_true.
      ENDIF.
      APPEND |[{ ls_balmsg-msgty } { ls_balmsg-msgid }/{ ls_balmsg-msgno }] | &&
             |{ ls_balmsg-msgv1 } { ls_balmsg-msgv2 } | &&
             |{ ls_balmsg-msgv3 } { ls_balmsg-msgv4 }|
             TO rs_result-messages.
    ENDLOOP.

    rs_result-success = xsdbool( lv_has_error = abap_false ).
  ENDMETHOD.

ENDCLASS.
