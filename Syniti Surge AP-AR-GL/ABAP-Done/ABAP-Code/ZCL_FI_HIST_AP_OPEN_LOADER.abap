"! AP Open Items Loader
"! Posts individual AP open items into S/4HANA via Clean Core wrapper
"! Uses ZIF_FI_ACC_DOC_SERVICE (injected) → items visible in FBL1N
CLASS zcl_fi_hist_ap_open_loader DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_fi_hist_loader.

    METHODS constructor
      IMPORTING
        it_items       TYPE zcl_fi_hist_types=>ty_ap_open_items
        it_bp_mapping  TYPE zcl_fi_hist_types=>ty_bp_mappings
        io_doc_service TYPE REF TO zif_fi_acc_doc_service OPTIONAL
        iv_test_run    TYPE abap_bool DEFAULT abap_true
        iv_batch_size  TYPE i DEFAULT 1000.

  PRIVATE SECTION.
    DATA mt_items       TYPE zcl_fi_hist_types=>ty_ap_open_items.
    DATA mt_bp_mapping  TYPE zcl_fi_hist_types=>ty_bp_mappings.
    DATA mo_doc_service TYPE REF TO zif_fi_acc_doc_service.
    DATA mv_test_run    TYPE abap_bool.
    DATA mv_batch_size  TYPE i.
    DATA ms_result      TYPE zif_fi_hist_loader=>ty_result.

    METHODS post_single_item
      IMPORTING is_item         TYPE zcl_fi_hist_types=>ty_ap_open_item
      RETURNING VALUE(rv_belnr) TYPE belnr_d.

    METHODS add_log
      IMPORTING iv_msgty   TYPE msgty
                iv_message TYPE string
                iv_belnr   TYPE belnr_d OPTIONAL
                iv_bukrs   TYPE bukrs OPTIONAL
                iv_gjahr   TYPE gjahr OPTIONAL.

    METHODS resolve_bp
      IMPORTING iv_lifnr     TYPE lifnr
      RETURNING VALUE(rv_bp) TYPE bu_partner.

ENDCLASS.

CLASS zcl_fi_hist_ap_open_loader IMPLEMENTATION.

  METHOD constructor.
    mt_items       = it_items.
    mt_bp_mapping  = it_bp_mapping.
    mv_test_run    = iv_test_run.
    mv_batch_size  = iv_batch_size.
    " Default: create real service if none injected (production usage)
    mo_doc_service = COND #( WHEN io_doc_service IS BOUND
                             THEN io_doc_service
                             ELSE NEW zcl_fi_acc_doc_service( ) ).
  ENDMETHOD.

  METHOD zif_fi_hist_loader~validate.
    rv_valid = abap_true.

    LOOP AT mt_items ASSIGNING FIELD-SYMBOL(<item>).
      DATA(lv_idx) = sy-tabix.

      IF <item>-bukrs IS INITIAL.
        add_log( iv_msgty = 'E' iv_message = |Item { lv_idx }: Company Code is mandatory| ).
        rv_valid = abap_false.
      ENDIF.

      IF <item>-lifnr IS INITIAL.
        add_log( iv_msgty = 'E' iv_message = |Item { lv_idx }: Vendor number is mandatory| ).
        rv_valid = abap_false.
      ENDIF.

      IF <item>-budat IS INITIAL.
        add_log( iv_msgty = 'E' iv_message = |Item { lv_idx }: Posting date is mandatory| ).
        rv_valid = abap_false.
      ENDIF.

      IF <item>-wrbtr = 0 AND <item>-dmbtr = 0.
        add_log( iv_msgty = 'E' iv_message = |Item { lv_idx }: Amount is zero| ).
        rv_valid = abap_false.
      ENDIF.

      IF NOT line_exists( mt_bp_mapping[ legacy_id = <item>-lifnr bp_type = 'VN' ] ).
        add_log( iv_msgty = 'E'
                 iv_message = |Item { lv_idx }: No BP mapping for vendor { <item>-lifnr }| ).
        rv_valid = abap_false.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD zif_fi_hist_loader~execute.
    DATA lv_counter TYPE i.

    ms_result-total_records = lines( mt_items ).

    LOOP AT mt_items ASSIGNING FIELD-SYMBOL(<item>).
      lv_counter += 1.

      DATA(lv_belnr) = post_single_item( <item> ).

      IF lv_belnr IS NOT INITIAL.
        ms_result-posted_docs += 1.
        ms_result-total_amount += <item>-wrbtr.
        add_log( iv_msgty = 'S'
                 iv_message = |Posted: { lv_belnr } for vendor { <item>-lifnr }|
                 iv_belnr = lv_belnr iv_bukrs = <item>-bukrs iv_gjahr = <item>-gjahr ).
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

  METHOD post_single_item.
    DATA lt_accountgl TYPE STANDARD TABLE OF bapiacgl09.
    DATA lt_accountap TYPE STANDARD TABLE OF bapiacap09.
    DATA lt_curramt   TYPE STANDARD TABLE OF bapiaccr09.

    " --- Document Header ---
    DATA(ls_header) = VALUE bapiache09(
      bus_act    = 'RFBU'
      username   = sy-uname
      comp_code  = is_item-bukrs
      doc_date   = is_item-bldat
      pstng_date = is_item-budat
      doc_type   = is_item-blart
      ref_doc_no = is_item-xblnr
      header_txt = |HIST_AP { is_item-belnr }/{ is_item-gjahr }|
      fisc_year  = is_item-gjahr ).

    " --- GL Line (Reconciliation Account) ---
    APPEND VALUE bapiacgl09(
      itemno_acc = '0000000001'
      gl_account = is_item-hkont
      comp_code  = is_item-bukrs
      pstng_date = is_item-budat
      doc_type   = is_item-blart
      profit_ctr = is_item-prctr
      costcenter = is_item-kostl
      funds_ctr  = is_item-fkber
      segment    = is_item-segment
      bus_area   = is_item-gsber
      item_text  = is_item-sgtxt
      alloc_nmbr = is_item-zuonr
    ) TO lt_accountgl.

    " --- AP Line (Vendor subledger) ---
    APPEND VALUE bapiacap09(
      itemno_acc = '0000000002'
      vendor_no  = resolve_bp( is_item-lifnr )
      comp_code  = is_item-bukrs
      pmnttrms   = is_item-zterm
      bline_date = is_item-zfbdt
      pmnt_block = is_item-zlspr
      item_text  = is_item-sgtxt
      alloc_nmbr = is_item-zuonr
      profit_ctr = is_item-prctr
      fund       = is_item-fkber
      bus_area   = is_item-gsber
      tax_code   = is_item-mwskz
      sp_gl_ind  = is_item-umskz
    ) TO lt_accountap.

    " --- Currency Amounts ---
    " GL line (opposite sign — debit side of recon account)
    APPEND VALUE bapiaccr09(
      itemno_acc = '0000000001'
      currency   = is_item-waers
      curr_type  = '00'
      amt_doccur = COND #( WHEN is_item-shkzg = 'H'
                           THEN is_item-wrbtr
                           ELSE is_item-wrbtr * -1 )
    ) TO lt_curramt.

    " AP line amount
    APPEND VALUE bapiaccr09(
      itemno_acc = '0000000002'
      currency   = is_item-waers
      curr_type  = '00'
      amt_doccur = COND #( WHEN is_item-shkzg = 'H'
                           THEN is_item-wrbtr * -1
                           ELSE is_item-wrbtr )
    ) TO lt_curramt.

    " --- Post via Clean Core service wrapper ---
    DATA(ls_doc_result) = COND #(
      WHEN mv_test_run = abap_true
      THEN mo_doc_service->check_document(
             is_header         = ls_header
             it_accountgl      = lt_accountgl
             it_accountpayable = lt_accountap
             it_currencyamount = lt_curramt )
      ELSE mo_doc_service->post_document(
             is_header         = ls_header
             it_accountgl      = lt_accountgl
             it_accountpayable = lt_accountap
             it_currencyamount = lt_curramt ) ).

    " --- Process Result ---
    IF ls_doc_result-success = abap_false.
      LOOP AT ls_doc_result-messages ASSIGNING FIELD-SYMBOL(<ret>) WHERE type CA 'EA'.
        add_log( iv_msgty = <ret>-type
                 iv_message = |AP { is_item-lifnr }/{ is_item-belnr }: { <ret>-message }|
                 iv_bukrs = is_item-bukrs iv_gjahr = is_item-gjahr ).
        EXIT.
      ENDLOOP.
    ELSE.
      rv_belnr = ls_doc_result-doc_nr.
    ENDIF.
  ENDMETHOD.

  METHOD resolve_bp.
    rv_bp = VALUE #( mt_bp_mapping[ legacy_id = iv_lifnr bp_type = 'VN' ]-bp_number OPTIONAL ).
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
