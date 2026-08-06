"! Cleared Items Summarized Loader
"! Posts AP/AR cleared items as summarized GL journal entries
"! Uses ZIF_FI_ACC_DOC_SERVICE (injected) with ACCOUNTGL only
"! Items are NOT visible in FBL1N/FBL5N — only affect GL balance
CLASS zcl_fi_hist_cleared_loader DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_fi_hist_loader.

    METHODS constructor
      IMPORTING
        it_summaries   TYPE zcl_fi_hist_types=>ty_cleared_summaries
        io_doc_service TYPE REF TO zif_fi_acc_doc_service OPTIONAL
        iv_test_run    TYPE abap_bool DEFAULT abap_true
        iv_batch_size  TYPE i DEFAULT 1000
        iv_offset_acct TYPE hkont.   " Offset GL account for migration

  PRIVATE SECTION.
    DATA mt_summaries   TYPE zcl_fi_hist_types=>ty_cleared_summaries.
    DATA mo_doc_service TYPE REF TO zif_fi_acc_doc_service.
    DATA mv_test_run    TYPE abap_bool.
    DATA mv_batch_size  TYPE i.
    DATA mv_offset_acct TYPE hkont.
    DATA ms_result      TYPE zif_fi_hist_loader=>ty_result.

    METHODS post_summary_entry
      IMPORTING is_summary      TYPE zcl_fi_hist_types=>ty_cleared_summary
      RETURNING VALUE(rv_belnr) TYPE belnr_d.

    METHODS add_log
      IMPORTING iv_msgty   TYPE msgty
                iv_message TYPE string
                iv_belnr   TYPE belnr_d OPTIONAL
                iv_bukrs   TYPE bukrs OPTIONAL
                iv_gjahr   TYPE gjahr OPTIONAL.

ENDCLASS.

CLASS zcl_fi_hist_cleared_loader IMPLEMENTATION.

  METHOD constructor.
    mt_summaries   = it_summaries.
    mv_test_run    = iv_test_run.
    mv_batch_size  = iv_batch_size.
    mv_offset_acct = iv_offset_acct.
    mo_doc_service = COND #( WHEN io_doc_service IS BOUND
                             THEN io_doc_service
                             ELSE NEW zcl_fi_acc_doc_service( ) ).
  ENDMETHOD.

  METHOD zif_fi_hist_loader~validate.
    rv_valid = abap_true.

    LOOP AT mt_summaries ASSIGNING FIELD-SYMBOL(<sum>).
      DATA(lv_idx) = sy-tabix.

      IF <sum>-bukrs IS INITIAL.
        add_log( iv_msgty = 'E' iv_message = |Summary { lv_idx }: Company code is mandatory| ).
        rv_valid = abap_false.
      ENDIF.

      IF <sum>-hkont IS INITIAL.
        add_log( iv_msgty = 'E' iv_message = |Summary { lv_idx }: Reconciliation account is mandatory| ).
        rv_valid = abap_false.
      ENDIF.
    ENDLOOP.

    IF mv_offset_acct IS INITIAL.
      add_log( iv_msgty = 'E' iv_message = |Offset account for migration postings is mandatory| ).
      rv_valid = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD zif_fi_hist_loader~execute.
    DATA lv_counter TYPE i.

    ms_result-total_records = lines( mt_summaries ).

    LOOP AT mt_summaries ASSIGNING FIELD-SYMBOL(<sum>).
      lv_counter += 1.

      DATA(lv_belnr) = post_summary_entry( <sum> ).

      IF lv_belnr IS NOT INITIAL.
        ms_result-posted_docs += 1.
        ms_result-total_amount += <sum>-wrbtr.
        add_log( iv_msgty = 'S'
                 iv_message = |Posted cleared summary: { lv_belnr } { <sum>-module } Per.{ <sum>-monat }/{ <sum>-gjahr }|
                 iv_belnr = lv_belnr iv_bukrs = <sum>-bukrs iv_gjahr = <sum>-gjahr ).
      ELSE.
        ms_result-failed_docs += 1.
      ENDIF.

      IF mv_test_run = abap_false AND lv_counter MOD mv_batch_size = 0.
        mo_doc_service->commit_work( ).
      ENDIF.
    ENDLOOP.

    IF mv_test_run = abap_false AND lv_counter MOD mv_batch_size <> 0.
      mo_doc_service->commit_work( ).
    ENDIF.

    rs_result = ms_result.
  ENDMETHOD.

  METHOD post_summary_entry.
    DATA lt_accountgl TYPE STANDARD TABLE OF bapiacgl09.
    DATA lt_curramt   TYPE STANDARD TABLE OF bapiaccr09.

    " Posting date = first day of period
    DATA(lv_budat) = CONV budat( |{ is_summary-gjahr }{ is_summary-monat }01| ).

    " --- Header ---
    DATA(ls_header) = VALUE bapiache09(
      bus_act    = 'RFBU'
      username   = sy-uname
      comp_code  = is_summary-bukrs
      doc_date   = lv_budat
      pstng_date = lv_budat
      doc_type   = 'SA'
      ref_doc_no = |HIST_CLR_{ is_summary-module }|
      header_txt = |{ is_summary-module } Cleared Per.{ is_summary-monat }/{ is_summary-gjahr } ({ is_summary-count } docs)|
      fisc_year  = is_summary-gjahr ).

    " --- GL Line 1: Reconciliation account ---
    APPEND VALUE bapiacgl09(
      itemno_acc = '0000000001'
      gl_account = is_summary-hkont
      comp_code  = is_summary-bukrs
      pstng_date = lv_budat
      doc_type   = 'SA'
      profit_ctr = is_summary-prctr
      costcenter = is_summary-kostl
      fund_ctr   = is_summary-fkber
      segment    = is_summary-segment
      bus_area   = is_summary-gsber
      item_text  = |Hist.{ is_summary-module } cleared { is_summary-partner }|
    ) TO lt_accountgl.

    " --- GL Line 2: Offset account (migration clearing) ---
    APPEND VALUE bapiacgl09(
      itemno_acc = '0000000002'
      gl_account = mv_offset_acct
      comp_code  = is_summary-bukrs
      pstng_date = lv_budat
      doc_type   = 'SA'
      profit_ctr = is_summary-prctr
      segment    = is_summary-segment
      item_text  = |Offset hist.{ is_summary-module } { is_summary-partner }|
    ) TO lt_accountgl.

    " --- Currency Amounts ---
    APPEND VALUE bapiaccr09(
      itemno_acc = '0000000001'
      currency   = is_summary-waers
      curr_type  = '00'
      amt_doccur = is_summary-wrbtr
    ) TO lt_curramt.

    APPEND VALUE bapiaccr09(
      itemno_acc = '0000000002'
      currency   = is_summary-waers
      curr_type  = '00'
      amt_doccur = is_summary-wrbtr * -1
    ) TO lt_curramt.

    " --- Post via Clean Core service wrapper ---
    DATA(ls_doc_result) = COND #(
      WHEN mv_test_run = abap_true
      THEN mo_doc_service->check_document(
             is_header         = ls_header
             it_accountgl      = lt_accountgl
             it_currencyamount = lt_curramt )
      ELSE mo_doc_service->post_document(
             is_header         = ls_header
             it_accountgl      = lt_accountgl
             it_currencyamount = lt_curramt ) ).

    " --- Process Result ---
    IF ls_doc_result-success = abap_false.
      LOOP AT ls_doc_result-messages ASSIGNING FIELD-SYMBOL(<ret>) WHERE type CA 'EA'.
        add_log( iv_msgty = <ret>-type
                 iv_message = |Cleared { is_summary-module } Per.{ is_summary-monat }: { <ret>-message }|
                 iv_bukrs = is_summary-bukrs iv_gjahr = is_summary-gjahr ).
        EXIT.
      ENDLOOP.
    ELSE.
      rv_belnr = ls_doc_result-doc_nr.
    ENDIF.
  ENDMETHOD.

  METHOD add_log.
    GET TIME STAMP FIELD DATA(lv_ts).
    APPEND VALUE zif_fi_hist_loader=>ty_log_entry(
      timestamp = lv_ts
      msgty     = iv_msgty
      message   = iv_message
      doc_nr    = iv_belnr
      bukrs     = iv_bukrs
      gjahr     = iv_gjahr
    ) TO ms_result-log.
  ENDMETHOD.

ENDCLASS.
