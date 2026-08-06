"! <p class="shorttext synchronized">Real implementation of the PM notification BAPI facade</p>
CLASS /hdl/cl_alm_notif_bapi DEFINITION
  PUBLIC
  CREATE PUBLIC
  FINAL.

  PUBLIC SECTION.
    INTERFACES /hdl/if_alm_notif_bapi.

  PRIVATE SECTION.
    TYPES ty_bapiret2_tab TYPE STANDARD TABLE OF bapiret2 WITH EMPTY KEY.

    METHODS collect_messages
      IMPORTING it_return        TYPE ty_bapiret2_tab
      RETURNING VALUE(rs_result) TYPE /hdl/if_alm_notif_bapi=>ty_result.
ENDCLASS.


CLASS /hdl/cl_alm_notif_bapi IMPLEMENTATION.

  METHOD /hdl/if_alm_notif_bapi~put_in_progress.
    DATA lt_return TYPE ty_bapiret2_tab.

    CALL FUNCTION 'BAPI_ALM_NOTIF_PUT_IN_PROGRESS'
      EXPORTING
        number = iv_notif_no
      TABLES
        return = lt_return.

    rs_result = collect_messages( lt_return ).
  ENDMETHOD.

  METHOD /hdl/if_alm_notif_bapi~complete.
    DATA lt_return TYPE ty_bapiret2_tab.
    DATA ls_data   TYPE bapi2080_notcompstr.

    " Use current date/time as completion timestamp.
    ls_data-complt_date = sy-datum.
    ls_data-complt_time = sy-uzeit.

    CALL FUNCTION 'BAPI_ALM_NOTIF_COMPLETE'
      EXPORTING
        number              = iv_notif_no
        notifcompletiondata = ls_data
      TABLES
        return              = lt_return.

    rs_result = collect_messages( lt_return ).
  ENDMETHOD.

  METHOD /hdl/if_alm_notif_bapi~commit.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDMETHOD.

  METHOD /hdl/if_alm_notif_bapi~rollback.
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

    rs_result-success = xsdbool( lv_has_error = abap_false ).
  ENDMETHOD.

ENDCLASS.
