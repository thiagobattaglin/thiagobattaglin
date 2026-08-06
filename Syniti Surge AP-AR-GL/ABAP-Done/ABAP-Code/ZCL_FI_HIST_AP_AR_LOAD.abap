*&---------------------------------------------------------------------*
*& Class ZCL_FI_HIST_AP_AR_LOAD
*& Historical AP/AR Transaction Loading for S/4HANA Cloud Private Ed.
*& Clean Core Compliant — uses BAPI_ACC_DOCUMENT_POST
*&---------------------------------------------------------------------*
*& Architecture:
*&   - Open Items AP  → BAPI structure ACCOUNTPAYABLE   → visible FBL1N
*&   - Open Items AR  → BAPI structure ACCOUNTRECEIVABLE→ visible FBL5N
*&   - Cleared Items  → Summarized as GL journal entries → balance only
*&   - Reconciliation → Cross-module validation
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Interface: Common contract for all loaders
*----------------------------------------------------------------------*
INTERFACE lif_fi_hist_loader.

  TYPES: BEGIN OF ty_log_entry,
           timestamp TYPE timestamp,
           msgty     TYPE msgty,
           msgid     TYPE symsgid,
           msgno     TYPE symsgno,
           message   TYPE string,
           doc_nr    TYPE belnr_d,
           bukrs     TYPE bukrs,
           gjahr     TYPE gjahr,
         END OF ty_log_entry,
         ty_log TYPE STANDARD TABLE OF ty_log_entry WITH EMPTY KEY.

  TYPES: BEGIN OF ty_result,
           total_records   TYPE i,
           posted_docs     TYPE i,
           failed_docs     TYPE i,
           total_amount    TYPE wrbtr,
           log             TYPE ty_log,
         END OF ty_result.

  METHODS execute
    RETURNING VALUE(rs_result) TYPE ty_result.

  METHODS validate
    RETURNING VALUE(rv_valid) TYPE abap_bool.

ENDINTERFACE.

*----------------------------------------------------------------------*
* Class: AP/AR Source Data Structures
*----------------------------------------------------------------------*
CLASS lcl_fi_hist_types DEFINITION FINAL.
  PUBLIC SECTION.

    " --- AP Open Item (source structure — mirrors BSIK) ---
    TYPES: BEGIN OF ty_ap_open_item,
             bukrs     TYPE bukrs,          " Company Code
             belnr     TYPE belnr_d,        " Document Number (source)
             gjahr     TYPE gjahr,          " Fiscal Year
             buzei     TYPE buzei,          " Line Item Number
             lifnr     TYPE lifnr,          " Vendor Number
             blart     TYPE blart,          " Document Type
             bldat     TYPE bldat,          " Document Date
             budat     TYPE budat,          " Posting Date
             monat     TYPE monat,          " Fiscal Period
             waers     TYPE waers,          " Currency
             dmbtr     TYPE dmbtr,          " Amount in Local Currency
             wrbtr     TYPE wrbtr,          " Amount in Document Currency
             mwskz     TYPE mwskz,          " Tax Code
             kostl     TYPE kostl,          " Cost Center
             prctr     TYPE prctr,          " Profit Center
             segment   TYPE fb_segment,     " Segment
             zuonr     TYPE dzuonr,         " Assignment Number
             sgtxt     TYPE sgtxt,          " Item Text
             zfbdt     TYPE dzfbdt,         " Baseline Date for Payment
             zterm     TYPE dzterm,         " Payment Terms
             zlspr     TYPE dzlspr,         " Payment Block Key
             hkont     TYPE hkont,          " GL Reconciliation Account
             bschl     TYPE bschl,          " Posting Key
             shkzg     TYPE shkzg,          " Debit/Credit Indicator
             umskz     TYPE umskz,          " Special GL Indicator
             xblnr     TYPE xblnr,          " Reference Document
             saknr     TYPE saknr,          " GL Account
             gsber     TYPE gsber,          " Business Area
             fkber     TYPE fkber,          " Functional Area
           END OF ty_ap_open_item,
           ty_ap_open_items TYPE STANDARD TABLE OF ty_ap_open_item WITH EMPTY KEY.

    " --- AR Open Item (source structure — mirrors BSID) ---
    TYPES: BEGIN OF ty_ar_open_item,
             bukrs     TYPE bukrs,          " Company Code
             belnr     TYPE belnr_d,        " Document Number (source)
             gjahr     TYPE gjahr,          " Fiscal Year
             buzei     TYPE buzei,          " Line Item Number
             kunnr     TYPE kunnr,          " Customer Number
             blart     TYPE blart,          " Document Type
             bldat     TYPE bldat,          " Document Date
             budat     TYPE budat,          " Posting Date
             monat     TYPE monat,          " Fiscal Period
             waers     TYPE waers,          " Currency
             dmbtr     TYPE dmbtr,          " Amount in Local Currency
             wrbtr     TYPE wrbtr,          " Amount in Document Currency
             mwskz     TYPE mwskz,          " Tax Code
             kostl     TYPE kostl,          " Cost Center
             prctr     TYPE prctr,          " Profit Center
             segment   TYPE fb_segment,     " Segment
             zuonr     TYPE dzuonr,         " Assignment Number
             sgtxt     TYPE sgtxt,          " Item Text
             zfbdt     TYPE dzfbdt,         " Baseline Date for Payment
             zterm     TYPE dzterm,         " Payment Terms
             hkont     TYPE hkont,          " GL Reconciliation Account
             bschl     TYPE bschl,          " Posting Key
             shkzg     TYPE shkzg,          " Debit/Credit Indicator
             umskz     TYPE umskz,          " Special GL Indicator
             xblnr     TYPE xblnr,          " Reference Document
             saknr     TYPE saknr,          " GL Account
             gsber     TYPE gsber,          " Business Area
             fkber     TYPE fkber,          " Functional Area
             manst     TYPE manst,          " Dunning Level
             madat     TYPE madat,          " Last Dunned Date
             maber     TYPE maber,          " Dunning Area
           END OF ty_ar_open_item,
           ty_ar_open_items TYPE STANDARD TABLE OF ty_ar_open_item WITH EMPTY KEY.

    " --- Cleared Item (AP or AR — summarized) ---
    TYPES: BEGIN OF ty_cleared_summary,
             bukrs     TYPE bukrs,          " Company Code
             hkont     TYPE hkont,          " Reconciliation Account
             prctr     TYPE prctr,          " Profit Center
             segment   TYPE fb_segment,     " Segment
             kostl     TYPE kostl,          " Cost Center
             fkber     TYPE fkber,          " Functional Area
             gsber     TYPE gsber,          " Business Area
             monat     TYPE monat,          " Fiscal Period
             gjahr     TYPE gjahr,          " Fiscal Year
             waers     TYPE waers,          " Currency
             dmbtr     TYPE dmbtr,          " Total in Local Currency
             wrbtr     TYPE wrbtr,          " Total in Document Currency
             count     TYPE i,              " Number of documents summarized
             partner   TYPE string,         " Vendor/Customer (for reference text)
             module    TYPE c LENGTH 2,     " 'AP' or 'AR'
           END OF ty_cleared_summary,
           ty_cleared_summaries TYPE STANDARD TABLE OF ty_cleared_summary WITH EMPTY KEY.

    " --- BP Mapping: Vendor/Customer → Business Partner ---
    TYPES: BEGIN OF ty_bp_mapping,
             legacy_id TYPE c LENGTH 10,    " Vendor or Customer number
             bp_number TYPE bu_partner,     " Business Partner number
             bp_type   TYPE c LENGTH 2,     " 'VN' = vendor, 'CU' = customer
           END OF ty_bp_mapping,
           ty_bp_mappings TYPE HASHED TABLE OF ty_bp_mapping
                          WITH UNIQUE KEY legacy_id bp_type.

ENDCLASS.

CLASS lcl_fi_hist_types IMPLEMENTATION.
ENDCLASS.

*----------------------------------------------------------------------*
* Class: AP Open Items Loader
*----------------------------------------------------------------------*
CLASS lcl_ap_open_loader DEFINITION FINAL.

  PUBLIC SECTION.
    INTERFACES lif_fi_hist_loader.

    METHODS constructor
      IMPORTING
        it_items      TYPE lcl_fi_hist_types=>ty_ap_open_items
        it_bp_mapping TYPE lcl_fi_hist_types=>ty_bp_mappings
        iv_test_run   TYPE abap_bool DEFAULT abap_true
        iv_batch_size TYPE i DEFAULT 1000.

  PRIVATE SECTION.
    DATA mt_items      TYPE lcl_fi_hist_types=>ty_ap_open_items.
    DATA mt_bp_mapping TYPE lcl_fi_hist_types=>ty_bp_mappings.
    DATA mv_test_run   TYPE abap_bool.
    DATA mv_batch_size TYPE i.
    DATA ms_result     TYPE lif_fi_hist_loader=>ty_result.

    METHODS post_single_item
      IMPORTING is_item        TYPE lcl_fi_hist_types=>ty_ap_open_item
      RETURNING VALUE(rv_belnr) TYPE belnr_d.

    METHODS add_log
      IMPORTING iv_msgty TYPE msgty iv_message TYPE string
                iv_belnr TYPE belnr_d OPTIONAL iv_bukrs TYPE bukrs OPTIONAL
                iv_gjahr TYPE gjahr OPTIONAL.

    METHODS resolve_bp
      IMPORTING iv_lifnr     TYPE lifnr
      RETURNING VALUE(rv_bp) TYPE bu_partner.

ENDCLASS.

CLASS lcl_ap_open_loader IMPLEMENTATION.

  METHOD constructor.
    mt_items      = it_items.
    mt_bp_mapping = it_bp_mapping.
    mv_test_run   = iv_test_run.
    mv_batch_size = iv_batch_size.
  ENDMETHOD.

  METHOD lif_fi_hist_loader~validate.
    rv_valid = abap_true.

    " V1: All items must have company code
    LOOP AT mt_items ASSIGNING FIELD-SYMBOL(<item>) WHERE bukrs IS INITIAL.
      add_log( iv_msgty = 'E' iv_message = |Item { sy-tabix }: Company Code is mandatory| ).
      rv_valid = abap_false.
    ENDLOOP.

    " V2: All items must have vendor number
    LOOP AT mt_items ASSIGNING <item> WHERE lifnr IS INITIAL.
      add_log( iv_msgty = 'E' iv_message = |Item { sy-tabix }: Vendor number is mandatory| ).
      rv_valid = abap_false.
    ENDLOOP.

    " V3: All items must have posting date
    LOOP AT mt_items ASSIGNING <item> WHERE budat IS INITIAL.
      add_log( iv_msgty = 'E' iv_message = |Item { sy-tabix }: Posting date is mandatory| ).
      rv_valid = abap_false.
    ENDLOOP.

    " V4: Amount must not be zero
    LOOP AT mt_items ASSIGNING <item> WHERE wrbtr = 0 AND dmbtr = 0.
      add_log( iv_msgty = 'E' iv_message = |Item { sy-tabix }: Amount is zero| ).
      rv_valid = abap_false.
    ENDLOOP.

    " V5: BP mapping must exist for all vendors
    LOOP AT mt_items ASSIGNING <item>.
      DATA(lv_bp) = resolve_bp( <item>-lifnr ).
      IF lv_bp IS INITIAL.
        add_log( iv_msgty = 'E'
                 iv_message = |Item { sy-tabix }: No BP mapping for vendor { <item>-lifnr }| ).
        rv_valid = abap_false.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD lif_fi_hist_loader~execute.

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

      " Commit work in batches
      IF mv_test_run = abap_false AND lv_counter MOD mv_batch_size = 0.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING wait = abap_true.
      ENDIF.

    ENDLOOP.

    " Final commit
    IF mv_test_run = abap_false AND lv_counter MOD mv_batch_size <> 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING wait = abap_true.
    ENDIF.

    rs_result = ms_result.
  ENDMETHOD.

  METHOD post_single_item.

    DATA: ls_header    TYPE bapiache09,
          lt_accountgl TYPE STANDARD TABLE OF bapiacgl09,
          lt_accountap TYPE STANDARD TABLE OF bapiacap09,
          lt_curramt   TYPE STANDARD TABLE OF bapiaccr09,
          lt_extension TYPE STANDARD TABLE OF bapiparex,
          lt_return    TYPE STANDARD TABLE OF bapiret2.

    DATA lv_itemno_gl TYPE posnr_acc VALUE '0000000001'.
    DATA lv_itemno_ap TYPE posnr_acc VALUE '0000000002'.

    " --- Document Header ---
    ls_header-bus_act    = 'RFBU'.          " Business Transaction
    ls_header-username   = sy-uname.
    ls_header-comp_code  = is_item-bukrs.
    ls_header-doc_date   = is_item-bldat.
    ls_header-pstng_date = is_item-budat.
    ls_header-doc_type   = is_item-blart.
    ls_header-ref_doc_no = is_item-xblnr.   " Preserve source reference
    ls_header-header_txt = |HIST_AP { is_item-belnr }/{ is_item-gjahr }|.
    ls_header-fisc_year  = is_item-gjahr.

    " --- GL Line (Reconciliation Account - Counter entry) ---
    DATA ls_gl TYPE bapiacgl09.
    ls_gl-itemno_acc = lv_itemno_gl.
    ls_gl-gl_account = is_item-hkont.       " Reconciliation account
    ls_gl-comp_code  = is_item-bukrs.
    ls_gl-pstng_date = is_item-budat.
    ls_gl-doc_type   = is_item-blart.
    ls_gl-profit_ctr = is_item-prctr.
    ls_gl-costcenter = is_item-kostl.
    ls_gl-fund_ctr   = is_item-fkber.
    ls_gl-segment    = is_item-segment.
    ls_gl-bus_area   = is_item-gsber.
    ls_gl-item_text  = is_item-sgtxt.
    ls_gl-alloc_nmbr = is_item-zuonr.
    APPEND ls_gl TO lt_accountgl.

    " --- AP Line (Vendor subledger) ---
    DATA ls_ap TYPE bapiacap09.
    ls_ap-itemno_acc = lv_itemno_ap.
    ls_ap-vendor_no  = resolve_bp( is_item-lifnr ). " BP Number
    ls_ap-comp_code  = is_item-bukrs.
    ls_ap-pstng_date = is_item-budat.
    ls_ap-doc_type   = is_item-blart.
    ls_ap-pmnttrms   = is_item-zterm.       " Payment Terms
    ls_ap-bline_date = is_item-zfbdt.       " Baseline date
    ls_ap-pmnt_block = is_item-zlspr.       " Payment block
    ls_ap-item_text  = is_item-sgtxt.
    ls_ap-alloc_nmbr = is_item-zuonr.
    ls_ap-profit_ctr = is_item-prctr.
    ls_ap-costcenter = is_item-kostl.
    ls_ap-fund_ctr   = is_item-fkber.
    ls_ap-segment    = is_item-segment.
    ls_ap-bus_area   = is_item-gsber.
    IF is_item-umskz IS NOT INITIAL.
      ls_ap-sp_gl_ind = is_item-umskz.     " Special GL indicator (down payments)
    ENDIF.
    APPEND ls_ap TO lt_accountap.

    " --- Currency Amounts ---
    " GL line amount (opposite sign — debit side of recon account)
    DATA ls_curr TYPE bapiaccr09.
    ls_curr-itemno_acc = lv_itemno_gl.
    ls_curr-currency   = is_item-waers.
    ls_curr-curr_type  = '00'.              " Document currency
    " For credit-side vendor invoice, GL side is debit
    IF is_item-shkzg = 'H'. " Credit = vendor invoice
      ls_curr-amt_doccur = is_item-wrbtr.
    ELSE. " Debit = vendor credit memo
      ls_curr-amt_doccur = is_item-wrbtr * -1.
    ENDIF.
    APPEND ls_curr TO lt_curramt.

    " AP line amount
    CLEAR ls_curr.
    ls_curr-itemno_acc = lv_itemno_ap.
    ls_curr-currency   = is_item-waers.
    ls_curr-curr_type  = '00'.
    IF is_item-shkzg = 'H'. " Credit = vendor invoice on vendor side
      ls_curr-amt_doccur = is_item-wrbtr * -1.
    ELSE.
      ls_curr-amt_doccur = is_item-wrbtr.
    ENDIF.
    APPEND ls_curr TO lt_curramt.

    " --- Call BAPI ---
    IF mv_test_run = abap_true.
      CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
        EXPORTING documentheader = ls_header
        TABLES   accountgl      = lt_accountgl
                 accountpayable = lt_accountap
                 currencyamount = lt_curramt
                 extension2     = lt_extension
                 return         = lt_return.
    ELSE.
      CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
        EXPORTING documentheader = ls_header
        TABLES   accountgl      = lt_accountgl
                 accountpayable = lt_accountap
                 currencyamount = lt_curramt
                 extension2     = lt_extension
                 return         = lt_return.
    ENDIF.

    " --- Process Return ---
    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ret>) WHERE type CA 'EA'.
      add_log( iv_msgty = <ret>-type
               iv_message = |AP { is_item-lifnr }/{ is_item-belnr }: { <ret>-message }|
               iv_bukrs = is_item-bukrs iv_gjahr = is_item-gjahr ).
      RETURN.
    ENDLOOP.

    " Success — get document number from return
    READ TABLE lt_return WITH KEY type = 'S' id = 'RW' number = '605'
      ASSIGNING FIELD-SYMBOL(<success>).
    IF sy-subrc = 0.
      rv_belnr = <success>-message_v2.
    ENDIF.

  ENDMETHOD.

  METHOD resolve_bp.
    READ TABLE mt_bp_mapping WITH KEY legacy_id = CONV #( iv_lifnr )
                                      bp_type   = 'VN'
      ASSIGNING FIELD-SYMBOL(<map>).
    rv_bp = COND #( WHEN sy-subrc = 0 THEN <map>-bp_number ).
  ENDMETHOD.

  METHOD add_log.
    GET TIME STAMP FIELD DATA(lv_ts).
    APPEND VALUE lif_fi_hist_loader=>ty_log_entry(
      timestamp = lv_ts
      msgty     = iv_msgty
      message   = iv_message
      doc_nr    = iv_belnr
      bukrs     = iv_bukrs
      gjahr     = iv_gjahr
    ) TO ms_result-log.
  ENDMETHOD.

ENDCLASS.

*----------------------------------------------------------------------*
* Class: AR Open Items Loader
*----------------------------------------------------------------------*
CLASS lcl_ar_open_loader DEFINITION FINAL.

  PUBLIC SECTION.
    INTERFACES lif_fi_hist_loader.

    METHODS constructor
      IMPORTING
        it_items      TYPE lcl_fi_hist_types=>ty_ar_open_items
        it_bp_mapping TYPE lcl_fi_hist_types=>ty_bp_mappings
        iv_test_run   TYPE abap_bool DEFAULT abap_true
        iv_batch_size TYPE i DEFAULT 1000.

  PRIVATE SECTION.
    DATA mt_items      TYPE lcl_fi_hist_types=>ty_ar_open_items.
    DATA mt_bp_mapping TYPE lcl_fi_hist_types=>ty_bp_mappings.
    DATA mv_test_run   TYPE abap_bool.
    DATA mv_batch_size TYPE i.
    DATA ms_result     TYPE lif_fi_hist_loader=>ty_result.

    METHODS post_single_item
      IMPORTING is_item        TYPE lcl_fi_hist_types=>ty_ar_open_item
      RETURNING VALUE(rv_belnr) TYPE belnr_d.

    METHODS add_log
      IMPORTING iv_msgty TYPE msgty iv_message TYPE string
                iv_belnr TYPE belnr_d OPTIONAL iv_bukrs TYPE bukrs OPTIONAL
                iv_gjahr TYPE gjahr OPTIONAL.

    METHODS resolve_bp
      IMPORTING iv_kunnr     TYPE kunnr
      RETURNING VALUE(rv_bp) TYPE bu_partner.

ENDCLASS.

CLASS lcl_ar_open_loader IMPLEMENTATION.

  METHOD constructor.
    mt_items      = it_items.
    mt_bp_mapping = it_bp_mapping.
    mv_test_run   = iv_test_run.
    mv_batch_size = iv_batch_size.
  ENDMETHOD.

  METHOD lif_fi_hist_loader~validate.
    rv_valid = abap_true.

    LOOP AT mt_items ASSIGNING FIELD-SYMBOL(<item>) WHERE bukrs IS INITIAL.
      add_log( iv_msgty = 'E' iv_message = |Item { sy-tabix }: Company Code is mandatory| ).
      rv_valid = abap_false.
    ENDLOOP.

    LOOP AT mt_items ASSIGNING <item> WHERE kunnr IS INITIAL.
      add_log( iv_msgty = 'E' iv_message = |Item { sy-tabix }: Customer number is mandatory| ).
      rv_valid = abap_false.
    ENDLOOP.

    LOOP AT mt_items ASSIGNING <item> WHERE budat IS INITIAL.
      add_log( iv_msgty = 'E' iv_message = |Item { sy-tabix }: Posting date is mandatory| ).
      rv_valid = abap_false.
    ENDLOOP.

    LOOP AT mt_items ASSIGNING <item> WHERE wrbtr = 0 AND dmbtr = 0.
      add_log( iv_msgty = 'E' iv_message = |Item { sy-tabix }: Amount is zero| ).
      rv_valid = abap_false.
    ENDLOOP.

    LOOP AT mt_items ASSIGNING <item>.
      DATA(lv_bp) = resolve_bp( <item>-kunnr ).
      IF lv_bp IS INITIAL.
        add_log( iv_msgty = 'E'
                 iv_message = |Item { sy-tabix }: No BP mapping for customer { <item>-kunnr }| ).
        rv_valid = abap_false.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD lif_fi_hist_loader~execute.

    DATA lv_counter TYPE i.
    ms_result-total_records = lines( mt_items ).

    LOOP AT mt_items ASSIGNING FIELD-SYMBOL(<item>).
      lv_counter += 1.

      DATA(lv_belnr) = post_single_item( <item> ).

      IF lv_belnr IS NOT INITIAL.
        ms_result-posted_docs += 1.
        ms_result-total_amount += <item>-wrbtr.
        add_log( iv_msgty = 'S'
                 iv_message = |Posted: { lv_belnr } for customer { <item>-kunnr }|
                 iv_belnr = lv_belnr iv_bukrs = <item>-bukrs iv_gjahr = <item>-gjahr ).
      ELSE.
        ms_result-failed_docs += 1.
      ENDIF.

      IF mv_test_run = abap_false AND lv_counter MOD mv_batch_size = 0.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING wait = abap_true.
      ENDIF.
    ENDLOOP.

    IF mv_test_run = abap_false AND lv_counter MOD mv_batch_size <> 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING wait = abap_true.
    ENDIF.

    rs_result = ms_result.
  ENDMETHOD.

  METHOD post_single_item.

    DATA: ls_header    TYPE bapiache09,
          lt_accountgl TYPE STANDARD TABLE OF bapiacgl09,
          lt_accountar TYPE STANDARD TABLE OF bapiacar09,
          lt_curramt   TYPE STANDARD TABLE OF bapiaccr09,
          lt_extension TYPE STANDARD TABLE OF bapiparex,
          lt_return    TYPE STANDARD TABLE OF bapiret2.

    DATA lv_itemno_gl TYPE posnr_acc VALUE '0000000001'.
    DATA lv_itemno_ar TYPE posnr_acc VALUE '0000000002'.

    " --- Document Header ---
    ls_header-bus_act    = 'RFBU'.
    ls_header-username   = sy-uname.
    ls_header-comp_code  = is_item-bukrs.
    ls_header-doc_date   = is_item-bldat.
    ls_header-pstng_date = is_item-budat.
    ls_header-doc_type   = is_item-blart.
    ls_header-ref_doc_no = is_item-xblnr.
    ls_header-header_txt = |HIST_AR { is_item-belnr }/{ is_item-gjahr }|.
    ls_header-fisc_year  = is_item-gjahr.

    " --- GL Line (Reconciliation Account) ---
    DATA ls_gl TYPE bapiacgl09.
    ls_gl-itemno_acc = lv_itemno_gl.
    ls_gl-gl_account = is_item-hkont.
    ls_gl-comp_code  = is_item-bukrs.
    ls_gl-pstng_date = is_item-budat.
    ls_gl-doc_type   = is_item-blart.
    ls_gl-profit_ctr = is_item-prctr.
    ls_gl-costcenter = is_item-kostl.
    ls_gl-fund_ctr   = is_item-fkber.
    ls_gl-segment    = is_item-segment.
    ls_gl-bus_area   = is_item-gsber.
    ls_gl-item_text  = is_item-sgtxt.
    ls_gl-alloc_nmbr = is_item-zuonr.
    APPEND ls_gl TO lt_accountgl.

    " --- AR Line (Customer subledger) ---
    DATA ls_ar TYPE bapiacar09.
    ls_ar-itemno_acc = lv_itemno_ar.
    ls_ar-customer   = resolve_bp( is_item-kunnr ).
    ls_ar-comp_code  = is_item-bukrs.
    ls_ar-pstng_date = is_item-budat.
    ls_ar-doc_type   = is_item-blart.
    ls_ar-pmnttrms   = is_item-zterm.
    ls_ar-bline_date = is_item-zfbdt.
    ls_ar-item_text  = is_item-sgtxt.
    ls_ar-alloc_nmbr = is_item-zuonr.
    ls_ar-profit_ctr = is_item-prctr.
    ls_ar-costcenter = is_item-kostl.
    ls_ar-fund_ctr   = is_item-fkber.
    ls_ar-segment    = is_item-segment.
    ls_ar-bus_area   = is_item-gsber.
    IF is_item-umskz IS NOT INITIAL.
      ls_ar-sp_gl_ind = is_item-umskz.
    ENDIF.
    APPEND ls_ar TO lt_accountar.

    " --- Currency Amounts ---
    DATA ls_curr TYPE bapiaccr09.
    ls_curr-itemno_acc = lv_itemno_gl.
    ls_curr-currency   = is_item-waers.
    ls_curr-curr_type  = '00'.
    " AR: Debit side = customer invoice on GL recon account
    IF is_item-shkzg = 'S'. " Debit = customer invoice
      ls_curr-amt_doccur = is_item-wrbtr * -1.
    ELSE.
      ls_curr-amt_doccur = is_item-wrbtr.
    ENDIF.
    APPEND ls_curr TO lt_curramt.

    CLEAR ls_curr.
    ls_curr-itemno_acc = lv_itemno_ar.
    ls_curr-currency   = is_item-waers.
    ls_curr-curr_type  = '00'.
    IF is_item-shkzg = 'S'. " Debit = customer invoice on customer side
      ls_curr-amt_doccur = is_item-wrbtr.
    ELSE.
      ls_curr-amt_doccur = is_item-wrbtr * -1.
    ENDIF.
    APPEND ls_curr TO lt_curramt.

    " --- Call BAPI ---
    IF mv_test_run = abap_true.
      CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
        EXPORTING documentheader    = ls_header
        TABLES   accountgl          = lt_accountgl
                 accountreceivable  = lt_accountar
                 currencyamount     = lt_curramt
                 extension2         = lt_extension
                 return             = lt_return.
    ELSE.
      CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
        EXPORTING documentheader    = ls_header
        TABLES   accountgl          = lt_accountgl
                 accountreceivable  = lt_accountar
                 currencyamount     = lt_curramt
                 extension2         = lt_extension
                 return             = lt_return.
    ENDIF.

    " --- Process Return ---
    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ret>) WHERE type CA 'EA'.
      add_log( iv_msgty = <ret>-type
               iv_message = |AR { is_item-kunnr }/{ is_item-belnr }: { <ret>-message }|
               iv_bukrs = is_item-bukrs iv_gjahr = is_item-gjahr ).
      RETURN.
    ENDLOOP.

    READ TABLE lt_return WITH KEY type = 'S' id = 'RW' number = '605'
      ASSIGNING FIELD-SYMBOL(<success>).
    IF sy-subrc = 0.
      rv_belnr = <success>-message_v2.
    ENDIF.

  ENDMETHOD.

  METHOD resolve_bp.
    READ TABLE mt_bp_mapping WITH KEY legacy_id = CONV #( iv_kunnr )
                                      bp_type   = 'CU'
      ASSIGNING FIELD-SYMBOL(<map>).
    rv_bp = COND #( WHEN sy-subrc = 0 THEN <map>-bp_number ).
  ENDMETHOD.

  METHOD add_log.
    GET TIME STAMP FIELD DATA(lv_ts).
    APPEND VALUE lif_fi_hist_loader=>ty_log_entry(
      timestamp = lv_ts
      msgty     = iv_msgty
      message   = iv_message
      doc_nr    = iv_belnr
      bukrs     = iv_bukrs
      gjahr     = iv_gjahr
    ) TO ms_result-log.
  ENDMETHOD.

ENDCLASS.

*----------------------------------------------------------------------*
* Class: Cleared Items Summarized Loader (GL Journal Entries)
*----------------------------------------------------------------------*
CLASS lcl_cleared_summary_loader DEFINITION FINAL.

  PUBLIC SECTION.
    INTERFACES lif_fi_hist_loader.

    METHODS constructor
      IMPORTING
        it_summaries  TYPE lcl_fi_hist_types=>ty_cleared_summaries
        iv_test_run   TYPE abap_bool DEFAULT abap_true
        iv_batch_size TYPE i DEFAULT 1000
        iv_offset_acct TYPE hkont.   " Offset GL account for migration

  PRIVATE SECTION.
    DATA mt_summaries   TYPE lcl_fi_hist_types=>ty_cleared_summaries.
    DATA mv_test_run    TYPE abap_bool.
    DATA mv_batch_size  TYPE i.
    DATA mv_offset_acct TYPE hkont.
    DATA ms_result      TYPE lif_fi_hist_loader=>ty_result.

    METHODS post_summary_entry
      IMPORTING is_summary     TYPE lcl_fi_hist_types=>ty_cleared_summary
      RETURNING VALUE(rv_belnr) TYPE belnr_d.

    METHODS add_log
      IMPORTING iv_msgty TYPE msgty iv_message TYPE string
                iv_belnr TYPE belnr_d OPTIONAL iv_bukrs TYPE bukrs OPTIONAL
                iv_gjahr TYPE gjahr OPTIONAL.

ENDCLASS.

CLASS lcl_cleared_summary_loader IMPLEMENTATION.

  METHOD constructor.
    mt_summaries   = it_summaries.
    mv_test_run    = iv_test_run.
    mv_batch_size  = iv_batch_size.
    mv_offset_acct = iv_offset_acct.
  ENDMETHOD.

  METHOD lif_fi_hist_loader~validate.
    rv_valid = abap_true.

    LOOP AT mt_summaries ASSIGNING FIELD-SYMBOL(<sum>) WHERE bukrs IS INITIAL.
      add_log( iv_msgty = 'E' iv_message = |Summary { sy-tabix }: Company code is mandatory| ).
      rv_valid = abap_false.
    ENDLOOP.

    LOOP AT mt_summaries ASSIGNING <sum> WHERE hkont IS INITIAL.
      add_log( iv_msgty = 'E' iv_message = |Summary { sy-tabix }: Reconciliation account is mandatory| ).
      rv_valid = abap_false.
    ENDLOOP.

    IF mv_offset_acct IS INITIAL.
      add_log( iv_msgty = 'E' iv_message = |Offset account for migration postings is mandatory| ).
      rv_valid = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD lif_fi_hist_loader~execute.

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
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING wait = abap_true.
      ENDIF.
    ENDLOOP.

    IF mv_test_run = abap_false AND lv_counter MOD mv_batch_size <> 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING wait = abap_true.
    ENDIF.

    rs_result = ms_result.
  ENDMETHOD.

  METHOD post_summary_entry.

    DATA: ls_header    TYPE bapiache09,
          lt_accountgl TYPE STANDARD TABLE OF bapiacgl09,
          lt_curramt   TYPE STANDARD TABLE OF bapiaccr09,
          lt_extension TYPE STANDARD TABLE OF bapiparex,
          lt_return    TYPE STANDARD TABLE OF bapiret2.

    " Determine document type based on module
    DATA(lv_blart) = COND blart( WHEN is_summary-module = 'AP' THEN 'SA'
                                 WHEN is_summary-module = 'AR' THEN 'SA'
                                 ELSE 'SA' ).

    " Posting date = first day of period
    DATA(lv_budat) = CONV budat( |{ is_summary-gjahr }{ is_summary-monat }01| ).

    " --- Header ---
    ls_header-bus_act    = 'RFBU'.
    ls_header-username   = sy-uname.
    ls_header-comp_code  = is_summary-bukrs.
    ls_header-doc_date   = lv_budat.
    ls_header-pstng_date = lv_budat.
    ls_header-doc_type   = lv_blart.
    ls_header-ref_doc_no = |HIST_CLR_{ is_summary-module }|.
    ls_header-header_txt = |{ is_summary-module } Cleared Per.{ is_summary-monat }/{ is_summary-gjahr } ({ is_summary-count } docs)|.
    ls_header-fisc_year  = is_summary-gjahr.

    " --- GL Line 1: Reconciliation account ---
    DATA ls_gl TYPE bapiacgl09.
    ls_gl-itemno_acc = '0000000001'.
    ls_gl-gl_account = is_summary-hkont.
    ls_gl-comp_code  = is_summary-bukrs.
    ls_gl-pstng_date = lv_budat.
    ls_gl-doc_type   = lv_blart.
    ls_gl-profit_ctr = is_summary-prctr.
    ls_gl-costcenter = is_summary-kostl.
    ls_gl-fund_ctr   = is_summary-fkber.
    ls_gl-segment    = is_summary-segment.
    ls_gl-bus_area   = is_summary-gsber.
    ls_gl-item_text  = |Hist.{ is_summary-module } cleared { is_summary-partner }|.
    APPEND ls_gl TO lt_accountgl.

    " --- GL Line 2: Offset account (migration clearing account) ---
    CLEAR ls_gl.
    ls_gl-itemno_acc = '0000000002'.
    ls_gl-gl_account = mv_offset_acct.
    ls_gl-comp_code  = is_summary-bukrs.
    ls_gl-pstng_date = lv_budat.
    ls_gl-doc_type   = lv_blart.
    ls_gl-profit_ctr = is_summary-prctr.
    ls_gl-segment    = is_summary-segment.
    ls_gl-item_text  = |Offset hist.{ is_summary-module } { is_summary-partner }|.
    APPEND ls_gl TO lt_accountgl.

    " --- Currency Amounts ---
    DATA ls_curr TYPE bapiaccr09.
    " Line 1: Recon account
    ls_curr-itemno_acc = '0000000001'.
    ls_curr-currency   = is_summary-waers.
    ls_curr-curr_type  = '00'.
    ls_curr-amt_doccur = is_summary-wrbtr.
    APPEND ls_curr TO lt_curramt.

    " Line 2: Offset (opposite sign)
    CLEAR ls_curr.
    ls_curr-itemno_acc = '0000000002'.
    ls_curr-currency   = is_summary-waers.
    ls_curr-curr_type  = '00'.
    ls_curr-amt_doccur = is_summary-wrbtr * -1.
    APPEND ls_curr TO lt_curramt.

    " --- Call BAPI ---
    IF mv_test_run = abap_true.
      CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
        EXPORTING documentheader = ls_header
        TABLES   accountgl      = lt_accountgl
                 currencyamount = lt_curramt
                 extension2     = lt_extension
                 return         = lt_return.
    ELSE.
      CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
        EXPORTING documentheader = ls_header
        TABLES   accountgl      = lt_accountgl
                 currencyamount = lt_curramt
                 extension2     = lt_extension
                 return         = lt_return.
    ENDIF.

    " --- Process Return ---
    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ret>) WHERE type CA 'EA'.
      add_log( iv_msgty = <ret>-type
               iv_message = |Cleared { is_summary-module } Per.{ is_summary-monat }: { <ret>-message }|
               iv_bukrs = is_summary-bukrs iv_gjahr = is_summary-gjahr ).
      RETURN.
    ENDLOOP.

    READ TABLE lt_return WITH KEY type = 'S' id = 'RW' number = '605'
      ASSIGNING FIELD-SYMBOL(<success>).
    IF sy-subrc = 0.
      rv_belnr = <success>-message_v2.
    ENDIF.

  ENDMETHOD.

  METHOD add_log.
    GET TIME STAMP FIELD DATA(lv_ts).
    APPEND VALUE lif_fi_hist_loader=>ty_log_entry(
      timestamp = lv_ts
      msgty     = iv_msgty
      message   = iv_message
      doc_nr    = iv_belnr
      bukrs     = iv_bukrs
      gjahr     = iv_gjahr
    ) TO ms_result-log.
  ENDMETHOD.

ENDCLASS.

*----------------------------------------------------------------------*
* Class: Reconciliation Validator
*----------------------------------------------------------------------*
CLASS lcl_reconciliation_validator DEFINITION FINAL.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_recon_result,
             rule        TYPE string,
             description TYPE string,
             expected    TYPE wrbtr,
             actual      TYPE wrbtr,
             difference  TYPE wrbtr,
             status      TYPE c LENGTH 4,  " PASS / FAIL
             bukrs       TYPE bukrs,
           END OF ty_recon_result,
           ty_recon_results TYPE STANDARD TABLE OF ty_recon_result WITH EMPTY KEY.

    METHODS constructor
      IMPORTING
        ir_bukrs TYPE ANY TABLE
        ir_gjahr TYPE ANY TABLE.

    "! R1: GL total balance = Source total balance
    METHODS validate_gl_balance
      IMPORTING iv_expected TYPE wrbtr
      RETURNING VALUE(rs_result) TYPE ty_recon_result.

    "! R2: AP subledger balance = GL reconciliation account (Vendors)
    METHODS validate_ap_vs_gl
      IMPORTING iv_hkont TYPE hkont  " Reconciliation account
      RETURNING VALUE(rs_result) TYPE ty_recon_result.

    "! R3: AR subledger balance = GL reconciliation account (Customers)
    METHODS validate_ar_vs_gl
      IMPORTING iv_hkont TYPE hkont
      RETURNING VALUE(rs_result) TYPE ty_recon_result.

    "! Execute all reconciliation rules
    METHODS execute_all
      IMPORTING iv_ap_hkont    TYPE hkont
                iv_ar_hkont    TYPE hkont
                iv_gl_expected TYPE wrbtr
      RETURNING VALUE(rt_results) TYPE ty_recon_results.

  PRIVATE SECTION.
    DATA mt_bukrs TYPE RANGE OF bukrs.
    DATA mt_gjahr TYPE RANGE OF gjahr.

ENDCLASS.

CLASS lcl_reconciliation_validator IMPLEMENTATION.

  METHOD constructor.
    mt_bukrs = ir_bukrs.
    mt_gjahr = ir_gjahr.
  ENDMETHOD.

  METHOD validate_gl_balance.
    " Read actual GL balance from ACDOCA
    SELECT SUM( hsl ) AS total
      FROM acdoca
      INTO @DATA(lv_actual)
      WHERE rbukrs IN @mt_bukrs
        AND gjahr  IN @mt_gjahr
        AND rldnr  = '0L'.

    rs_result-rule        = 'R1'.
    rs_result-description = 'GL Total Balance = Source Total Balance'.
    rs_result-expected    = iv_expected.
    rs_result-actual      = lv_actual.
    rs_result-difference  = iv_expected - lv_actual.
    rs_result-status      = COND #( WHEN rs_result-difference = 0 THEN 'PASS' ELSE 'FAIL' ).
  ENDMETHOD.

  METHOD validate_ap_vs_gl.
    " AP subledger balance (from vendor line items)
    SELECT SUM( dmbtr ) AS total
      FROM bsik
      INTO @DATA(lv_ap_balance)
      WHERE bukrs IN @mt_bukrs.

    " GL reconciliation account balance
    SELECT SUM( hsl ) AS total
      FROM acdoca
      INTO @DATA(lv_gl_balance)
      WHERE rbukrs IN @mt_bukrs
        AND gjahr  IN @mt_gjahr
        AND rldnr  = '0L'
        AND racct  = @iv_hkont.

    rs_result-rule        = 'R2'.
    rs_result-description = 'AP Subledger = GL Reconciliation Account'.
    rs_result-expected    = lv_ap_balance.
    rs_result-actual      = lv_gl_balance.
    rs_result-difference  = lv_ap_balance - lv_gl_balance.
    rs_result-status      = COND #( WHEN rs_result-difference = 0 THEN 'PASS' ELSE 'FAIL' ).
  ENDMETHOD.

  METHOD validate_ar_vs_gl.
    " AR subledger balance
    SELECT SUM( dmbtr ) AS total
      FROM bsid
      INTO @DATA(lv_ar_balance)
      WHERE bukrs IN @mt_bukrs.

    " GL reconciliation account balance
    SELECT SUM( hsl ) AS total
      FROM acdoca
      INTO @DATA(lv_gl_balance)
      WHERE rbukrs IN @mt_bukrs
        AND gjahr  IN @mt_gjahr
        AND rldnr  = '0L'
        AND racct  = @iv_hkont.

    rs_result-rule        = 'R3'.
    rs_result-description = 'AR Subledger = GL Reconciliation Account'.
    rs_result-expected    = lv_ar_balance.
    rs_result-actual      = lv_gl_balance.
    rs_result-difference  = lv_ar_balance - lv_gl_balance.
    rs_result-status      = COND #( WHEN rs_result-difference = 0 THEN 'PASS' ELSE 'FAIL' ).
  ENDMETHOD.

  METHOD execute_all.
    APPEND validate_gl_balance( iv_gl_expected ) TO rt_results.
    APPEND validate_ap_vs_gl( iv_ap_hkont ) TO rt_results.
    APPEND validate_ar_vs_gl( iv_ar_hkont ) TO rt_results.
  ENDMETHOD.

ENDCLASS.
