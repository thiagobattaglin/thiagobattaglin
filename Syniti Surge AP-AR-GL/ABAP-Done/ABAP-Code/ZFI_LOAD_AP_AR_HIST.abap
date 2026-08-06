*&---------------------------------------------------------------------*
*& Report ZFI_LOAD_AP_AR_HIST
*& Orchestrator: Load Historic AP/AR Transactions into S/4HANA
*& Clean Core Compliant — S/4HANA Cloud Private Edition
*&---------------------------------------------------------------------*
*& Flow:
*&   1. Read extracted CSV files (AP/AR open items + BP mapping)
*&   2. Validate all data before posting
*&   3. Post AP open items via BAPI_ACC_DOCUMENT_POST (ACCOUNTPAYABLE)
*&   4. Post AR open items via BAPI_ACC_DOCUMENT_POST (ACCOUNTRECEIVABLE)
*&   5. Post cleared items as summarized GL journal entries
*&   6. Run reconciliation checks
*&   7. Display results ALV
*&---------------------------------------------------------------------*
REPORT zfi_load_ap_ar_hist.

*----------------------------------------------------------------------*
* Global classes used:
*   ZIF_FI_HIST_LOADER          — Interface for all loaders
*   ZCL_FI_HIST_TYPES           — Type definitions (AP/AR/Cleared/BP)
*   ZCL_FI_HIST_AP_OPEN_LOADER  — AP open items posting
*   ZCL_FI_HIST_AR_OPEN_LOADER  — AR open items posting
*   ZCL_FI_HIST_CLEARED_LOADER  — Cleared items summarized GL posting
*   ZCL_FI_HIST_RECON_VALIDATOR — Reconciliation cross-module checks
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Orchestrator Class
*----------------------------------------------------------------------*
CLASS lcl_orchestrator DEFINITION FINAL.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_run_config,
             mode         TYPE c LENGTH 1,     " T=Test, P=Productive
             ap_open      TYPE abap_bool,
             ar_open      TYPE abap_bool,
             ap_cleared   TYPE abap_bool,
             ar_cleared   TYPE abap_bool,
             reconcile    TYPE abap_bool,
             batch_size   TYPE i,
             ap_hkont     TYPE hkont,          " AP Reconciliation account
             ar_hkont     TYPE hkont,          " AR Reconciliation account
             offset_acct  TYPE hkont,          " Migration offset account
           END OF ty_run_config.

    METHODS constructor
      IMPORTING is_config TYPE ty_run_config.

    METHODS execute.

  PRIVATE SECTION.
    DATA ms_config TYPE ty_run_config.

    " Source data (populated from CSV or staging tables)
    DATA mt_ap_open    TYPE zcl_fi_hist_types=>ty_ap_open_items.
    DATA mt_ar_open    TYPE zcl_fi_hist_types=>ty_ar_open_items.
    DATA mt_ap_cleared TYPE zcl_fi_hist_types=>ty_cleared_summaries.
    DATA mt_ar_cleared TYPE zcl_fi_hist_types=>ty_cleared_summaries.
    DATA mt_bp_mapping TYPE zcl_fi_hist_types=>ty_bp_mappings.

    " Results
    DATA ms_ap_result      TYPE zif_fi_hist_loader=>ty_result.
    DATA ms_ar_result      TYPE zif_fi_hist_loader=>ty_result.
    DATA ms_cleared_result TYPE zif_fi_hist_loader=>ty_result.

    METHODS load_data_from_csv.
    METHODS load_ap_csv IMPORTING iv_file TYPE string.
    METHODS load_ar_csv IMPORTING iv_file TYPE string.
    METHODS load_bp_csv IMPORTING iv_file TYPE string.

    METHODS build_cleared_summaries.
    METHODS run_ap_open_loading.
    METHODS run_ar_open_loading.
    METHODS run_cleared_loading.
    METHODS run_reconciliation.
    METHODS display_results.
    METHODS display_log IMPORTING it_log TYPE zif_fi_hist_loader=>ty_log iv_title TYPE string.

ENDCLASS.

CLASS lcl_orchestrator IMPLEMENTATION.

  METHOD constructor.
    ms_config = is_config.
  ENDMETHOD.

  METHOD execute.

    " Step 1: Load source data
    WRITE: / '=== Step 1: Loading source data ==='.
    load_data_from_csv( ).

    " Step 2: AP Open Items
    IF ms_config-ap_open = abap_true AND mt_ap_open IS NOT INITIAL.
      WRITE: / '=== Step 2: AP Open Items Loading ==='.
      run_ap_open_loading( ).
    ENDIF.

    " Step 3: AR Open Items
    IF ms_config-ar_open = abap_true AND mt_ar_open IS NOT INITIAL.
      WRITE: / '=== Step 3: AR Open Items Loading ==='.
      run_ar_open_loading( ).
    ENDIF.

    " Step 4: Cleared Items (summarized)
    IF ( ms_config-ap_cleared = abap_true OR ms_config-ar_cleared = abap_true ).
      WRITE: / '=== Step 4: Cleared Items (Summarized GL) ==='.
      build_cleared_summaries( ).
      run_cleared_loading( ).
    ENDIF.

    " Step 5: Reconciliation
    IF ms_config-reconcile = abap_true.
      WRITE: / '=== Step 5: Reconciliation ==='.
      run_reconciliation( ).
    ENDIF.

    " Step 6: Results
    WRITE: / '=== Step 6: Results Summary ==='.
    display_results( ).

  ENDMETHOD.

  METHOD load_data_from_csv.
    " In production, this reads from staging tables populated by the extraction program.
    " For now, we read from CSV files on the application server.
    load_ap_csv( |/tmp/fi_hist/AP_HIST_ITEMS.csv| ).
    load_ar_csv( |/tmp/fi_hist/AR_HIST_ITEMS.csv| ).
    load_bp_csv( |/tmp/fi_hist/BP_MAPPING.csv| ).

    WRITE: / |  AP Open Items loaded : { lines( mt_ap_open ) }|.
    WRITE: / |  AR Open Items loaded : { lines( mt_ar_open ) }|.
    WRITE: / |  BP Mappings loaded   : { lines( mt_bp_mapping ) }|.
  ENDMETHOD.

  METHOD load_ap_csv.

    DATA lv_line TYPE string.
    DATA lv_first TYPE abap_bool VALUE abap_true.

    TRY.
        OPEN DATASET iv_file FOR INPUT IN TEXT MODE ENCODING UTF-8.
        IF sy-subrc <> 0.
          WRITE: / |WARNING: Could not open AP file: { iv_file }|.
          RETURN.
        ENDIF.

        DO.
          READ DATASET iv_file INTO lv_line.
          IF sy-subrc <> 0. EXIT. ENDIF.

          " Skip header
          IF lv_first = abap_true.
            lv_first = abap_false.
            CONTINUE.
          ENDIF.

          SPLIT lv_line AT ';' INTO TABLE DATA(lt_fields).
          CHECK lines( lt_fields ) >= 30.

          " Only load open items (status = 'O')
          IF lt_fields[ 31 ] = 'O'.
            APPEND VALUE zcl_fi_hist_types=>ty_ap_open_item(
              bukrs   = lt_fields[ 1 ]
              belnr   = lt_fields[ 2 ]
              gjahr   = lt_fields[ 3 ]
              buzei   = lt_fields[ 4 ]
              lifnr   = lt_fields[ 5 ]
              blart   = lt_fields[ 6 ]
              bldat   = lt_fields[ 7 ]
              budat   = lt_fields[ 8 ]
              monat   = lt_fields[ 9 ]
              waers   = lt_fields[ 10 ]
              dmbtr   = lt_fields[ 11 ]
              wrbtr   = lt_fields[ 12 ]
              mwskz   = lt_fields[ 13 ]
              kostl   = lt_fields[ 14 ]
              prctr   = lt_fields[ 15 ]
              segment = lt_fields[ 16 ]
              zuonr   = lt_fields[ 17 ]
              sgtxt   = lt_fields[ 18 ]
              zfbdt   = lt_fields[ 19 ]
              zterm   = lt_fields[ 20 ]
              zlspr   = lt_fields[ 21 ]
              hkont   = lt_fields[ 22 ]
              bschl   = lt_fields[ 23 ]
              shkzg   = lt_fields[ 24 ]
              umskz   = lt_fields[ 25 ]
              xblnr   = lt_fields[ 26 ]
              saknr   = lt_fields[ 27 ]
              gsber   = lt_fields[ 28 ]
              fkber   = lt_fields[ 29 ]
            ) TO mt_ap_open.
          ENDIF.
        ENDDO.

        CLOSE DATASET iv_file.
      CATCH cx_root INTO DATA(lx).
        WRITE: / |Error reading AP CSV: { lx->get_text( ) }|.
    ENDTRY.

  ENDMETHOD.

  METHOD load_ar_csv.

    DATA lv_line TYPE string.
    DATA lv_first TYPE abap_bool VALUE abap_true.

    TRY.
        OPEN DATASET iv_file FOR INPUT IN TEXT MODE ENCODING UTF-8.
        IF sy-subrc <> 0.
          WRITE: / |WARNING: Could not open AR file: { iv_file }|.
          RETURN.
        ENDIF.

        DO.
          READ DATASET iv_file INTO lv_line.
          IF sy-subrc <> 0. EXIT. ENDIF.

          IF lv_first = abap_true.
            lv_first = abap_false.
            CONTINUE.
          ENDIF.

          SPLIT lv_line AT ';' INTO TABLE DATA(lt_fields).
          CHECK lines( lt_fields ) >= 33.

          IF lt_fields[ 33 ] = 'O'.
            APPEND VALUE zcl_fi_hist_types=>ty_ar_open_item(
              bukrs   = lt_fields[ 1 ]
              belnr   = lt_fields[ 2 ]
              gjahr   = lt_fields[ 3 ]
              buzei   = lt_fields[ 4 ]
              kunnr   = lt_fields[ 5 ]
              blart   = lt_fields[ 6 ]
              bldat   = lt_fields[ 7 ]
              budat   = lt_fields[ 8 ]
              monat   = lt_fields[ 9 ]
              waers   = lt_fields[ 10 ]
              dmbtr   = lt_fields[ 11 ]
              wrbtr   = lt_fields[ 12 ]
              mwskz   = lt_fields[ 13 ]
              kostl   = lt_fields[ 14 ]
              prctr   = lt_fields[ 15 ]
              segment = lt_fields[ 16 ]
              zuonr   = lt_fields[ 17 ]
              sgtxt   = lt_fields[ 18 ]
              zfbdt   = lt_fields[ 19 ]
              zterm   = lt_fields[ 20 ]
              hkont   = lt_fields[ 21 ]
              bschl   = lt_fields[ 22 ]
              shkzg   = lt_fields[ 23 ]
              umskz   = lt_fields[ 24 ]
              xblnr   = lt_fields[ 25 ]
              saknr   = lt_fields[ 26 ]
              gsber   = lt_fields[ 27 ]
              fkber   = lt_fields[ 28 ]
              manst   = lt_fields[ 29 ]
              madat   = lt_fields[ 30 ]
              maber   = lt_fields[ 31 ]
            ) TO mt_ar_open.
          ENDIF.
        ENDDO.

        CLOSE DATASET iv_file.
      CATCH cx_root INTO DATA(lx).
        WRITE: / |Error reading AR CSV: { lx->get_text( ) }|.
    ENDTRY.

  ENDMETHOD.

  METHOD load_bp_csv.

    DATA lv_line TYPE string.
    DATA lv_first TYPE abap_bool VALUE abap_true.

    TRY.
        OPEN DATASET iv_file FOR INPUT IN TEXT MODE ENCODING UTF-8.
        IF sy-subrc <> 0.
          WRITE: / |WARNING: Could not open BP file: { iv_file }|.
          RETURN.
        ENDIF.

        DO.
          READ DATASET iv_file INTO lv_line.
          IF sy-subrc <> 0. EXIT. ENDIF.

          IF lv_first = abap_true.
            lv_first = abap_false.
            CONTINUE.
          ENDIF.

          SPLIT lv_line AT ';' INTO TABLE DATA(lt_fields).
          CHECK lines( lt_fields ) >= 3.

          INSERT VALUE zcl_fi_hist_types=>ty_bp_mapping(
            legacy_id = lt_fields[ 1 ]
            bp_number = lt_fields[ 2 ]
            bp_type   = lt_fields[ 3 ]
          ) INTO TABLE mt_bp_mapping.
        ENDDO.

        CLOSE DATASET iv_file.
      CATCH cx_root INTO DATA(lx).
        WRITE: / |Error reading BP CSV: { lx->get_text( ) }|.
    ENDTRY.

  ENDMETHOD.

  METHOD build_cleared_summaries.

    " Read cleared items from CSV files and aggregate by period/account
    " AP Cleared: aggregate by bukrs + hkont + prctr + segment + monat + gjahr + waers
    DATA lv_line TYPE string.
    DATA lv_first TYPE abap_bool.

    " --- AP Cleared aggregation ---
    IF ms_config-ap_cleared = abap_true.
      TRY.
          OPEN DATASET '/tmp/fi_hist/AP_HIST_ITEMS.csv' FOR INPUT IN TEXT MODE ENCODING UTF-8.
          IF sy-subrc = 0.
            lv_first = abap_true.
            DO.
              READ DATASET '/tmp/fi_hist/AP_HIST_ITEMS.csv' INTO lv_line.
              IF sy-subrc <> 0. EXIT. ENDIF.

              IF lv_first = abap_true. lv_first = abap_false. CONTINUE. ENDIF.

              SPLIT lv_line AT ';' INTO TABLE DATA(lt_f).
              CHECK lines( lt_f ) >= 31.
              CHECK lt_f[ 31 ] = 'C'. " Only cleared items

              " Find or create summary bucket
              READ TABLE mt_ap_cleared ASSIGNING FIELD-SYMBOL(<ap_sum>)
                WITH KEY bukrs = lt_f[ 1 ] hkont = lt_f[ 22 ]
                         prctr = lt_f[ 15 ] monat = lt_f[ 9 ] gjahr = lt_f[ 3 ]
                         waers = lt_f[ 10 ].
              IF sy-subrc = 0.
                <ap_sum>-dmbtr += CONV dmbtr( lt_f[ 11 ] ).
                <ap_sum>-wrbtr += CONV wrbtr( lt_f[ 12 ] ).
                <ap_sum>-count += 1.
              ELSE.
                APPEND VALUE zcl_fi_hist_types=>ty_cleared_summary(
                  bukrs   = lt_f[ 1 ]
                  hkont   = lt_f[ 22 ]
                  prctr   = lt_f[ 15 ]
                  segment = lt_f[ 16 ]
                  kostl   = lt_f[ 14 ]
                  fkber   = lt_f[ 29 ]
                  gsber   = lt_f[ 28 ]
                  monat   = lt_f[ 9 ]
                  gjahr   = lt_f[ 3 ]
                  waers   = lt_f[ 10 ]
                  dmbtr   = CONV dmbtr( lt_f[ 11 ] )
                  wrbtr   = CONV wrbtr( lt_f[ 12 ] )
                  count   = 1
                  partner = lt_f[ 5 ]  " first vendor as reference
                  module  = 'AP'
                ) TO mt_ap_cleared.
              ENDIF.
            ENDDO.
            CLOSE DATASET '/tmp/fi_hist/AP_HIST_ITEMS.csv'.
          ENDIF.
        CATCH cx_root.
      ENDTRY.

      WRITE: / |  AP Cleared summaries: { lines( mt_ap_cleared ) } aggregated buckets|.
    ENDIF.

    " --- AR Cleared aggregation ---
    IF ms_config-ar_cleared = abap_true.
      TRY.
          OPEN DATASET '/tmp/fi_hist/AR_HIST_ITEMS.csv' FOR INPUT IN TEXT MODE ENCODING UTF-8.
          IF sy-subrc = 0.
            lv_first = abap_true.
            DO.
              READ DATASET '/tmp/fi_hist/AR_HIST_ITEMS.csv' INTO lv_line.
              IF sy-subrc <> 0. EXIT. ENDIF.

              IF lv_first = abap_true. lv_first = abap_false. CONTINUE. ENDIF.

              SPLIT lv_line AT ';' INTO TABLE DATA(lt_fa).
              CHECK lines( lt_fa ) >= 33.
              CHECK lt_fa[ 33 ] = 'C'.

              READ TABLE mt_ar_cleared ASSIGNING FIELD-SYMBOL(<ar_sum>)
                WITH KEY bukrs = lt_fa[ 1 ] hkont = lt_fa[ 21 ]
                         prctr = lt_fa[ 15 ] monat = lt_fa[ 9 ] gjahr = lt_fa[ 3 ]
                         waers = lt_fa[ 10 ].
              IF sy-subrc = 0.
                <ar_sum>-dmbtr += CONV dmbtr( lt_fa[ 11 ] ).
                <ar_sum>-wrbtr += CONV wrbtr( lt_fa[ 12 ] ).
                <ar_sum>-count += 1.
              ELSE.
                APPEND VALUE zcl_fi_hist_types=>ty_cleared_summary(
                  bukrs   = lt_fa[ 1 ]
                  hkont   = lt_fa[ 21 ]
                  prctr   = lt_fa[ 15 ]
                  segment = lt_fa[ 16 ]
                  kostl   = lt_fa[ 14 ]
                  fkber   = lt_fa[ 28 ]
                  gsber   = lt_fa[ 27 ]
                  monat   = lt_fa[ 9 ]
                  gjahr   = lt_fa[ 3 ]
                  waers   = lt_fa[ 10 ]
                  dmbtr   = CONV dmbtr( lt_fa[ 11 ] )
                  wrbtr   = CONV wrbtr( lt_fa[ 12 ] )
                  count   = 1
                  partner = lt_fa[ 5 ]
                  module  = 'AR'
                ) TO mt_ar_cleared.
              ENDIF.
            ENDDO.
            CLOSE DATASET '/tmp/fi_hist/AR_HIST_ITEMS.csv'.
          ENDIF.
        CATCH cx_root.
      ENDTRY.

      WRITE: / |  AR Cleared summaries: { lines( mt_ar_cleared ) } aggregated buckets|.
    ENDIF.

  ENDMETHOD.

  METHOD run_ap_open_loading.

    DATA(lv_test) = COND abap_bool( WHEN ms_config-mode = 'T' THEN abap_true ELSE abap_false ).

    DATA(lo_ap) = NEW zcl_fi_hist_ap_open_loader(
      it_items      = mt_ap_open
      it_bp_mapping = mt_bp_mapping
      iv_test_run   = lv_test
      iv_batch_size = ms_config-batch_size ).

    " Validate first
    DATA(lv_valid) = lo_ap->zif_fi_hist_loader~validate( ).
    IF lv_valid = abap_false.
      WRITE: / |  AP VALIDATION FAILED — skipping posting.|.
      ms_ap_result = lo_ap->zif_fi_hist_loader~execute( ). " To collect the log
      display_log( it_log = ms_ap_result-log iv_title = 'AP Validation Errors' ).
      RETURN.
    ENDIF.

    " Execute
    ms_ap_result = lo_ap->zif_fi_hist_loader~execute( ).

    WRITE: / |  AP Open Items: { ms_ap_result-posted_docs } posted, { ms_ap_result-failed_docs } failed|.

  ENDMETHOD.

  METHOD run_ar_open_loading.

    DATA(lv_test) = COND abap_bool( WHEN ms_config-mode = 'T' THEN abap_true ELSE abap_false ).

    DATA(lo_ar) = NEW zcl_fi_hist_ar_open_loader(
      it_items      = mt_ar_open
      it_bp_mapping = mt_bp_mapping
      iv_test_run   = lv_test
      iv_batch_size = ms_config-batch_size ).

    DATA(lv_valid) = lo_ar->zif_fi_hist_loader~validate( ).
    IF lv_valid = abap_false.
      WRITE: / |  AR VALIDATION FAILED — skipping posting.|.
      ms_ar_result = lo_ar->zif_fi_hist_loader~execute( ).
      display_log( it_log = ms_ar_result-log iv_title = 'AR Validation Errors' ).
      RETURN.
    ENDIF.

    ms_ar_result = lo_ar->zif_fi_hist_loader~execute( ).

    WRITE: / |  AR Open Items: { ms_ar_result-posted_docs } posted, { ms_ar_result-failed_docs } failed|.

  ENDMETHOD.

  METHOD run_cleared_loading.

    DATA(lv_test) = COND abap_bool( WHEN ms_config-mode = 'T' THEN abap_true ELSE abap_false ).

    " Merge AP + AR cleared summaries
    DATA lt_all_cleared TYPE zcl_fi_hist_types=>ty_cleared_summaries.
    APPEND LINES OF mt_ap_cleared TO lt_all_cleared.
    APPEND LINES OF mt_ar_cleared TO lt_all_cleared.

    IF lt_all_cleared IS INITIAL.
      WRITE: / |  No cleared items to process.|.
      RETURN.
    ENDIF.

    DATA(lo_cleared) = NEW zcl_fi_hist_cleared_loader(
      it_summaries   = lt_all_cleared
      iv_test_run    = lv_test
      iv_batch_size  = ms_config-batch_size
      iv_offset_acct = ms_config-offset_acct ).

    DATA(lv_valid) = lo_cleared->zif_fi_hist_loader~validate( ).
    IF lv_valid = abap_false.
      WRITE: / |  CLEARED VALIDATION FAILED — skipping posting.|.
      RETURN.
    ENDIF.

    ms_cleared_result = lo_cleared->zif_fi_hist_loader~execute( ).

    WRITE: / |  Cleared Items: { ms_cleared_result-posted_docs } posted, { ms_cleared_result-failed_docs } failed|.

  ENDMETHOD.

  METHOD run_reconciliation.

    " Build ranges from config — simplified for now
    DATA lt_bukrs TYPE RANGE OF bukrs.
    DATA lt_gjahr TYPE RANGE OF gjahr.

    " Collect unique company codes and fiscal years from loaded data
    DATA lt_bukrs_set TYPE SORTED TABLE OF bukrs WITH UNIQUE KEY table_line.
    DATA lt_gjahr_set TYPE SORTED TABLE OF gjahr WITH UNIQUE KEY table_line.

    LOOP AT mt_ap_open ASSIGNING FIELD-SYMBOL(<ap>).
      INSERT <ap>-bukrs INTO TABLE lt_bukrs_set.
      INSERT <ap>-gjahr INTO TABLE lt_gjahr_set.
    ENDLOOP.
    LOOP AT mt_ar_open ASSIGNING FIELD-SYMBOL(<ar>).
      INSERT <ar>-bukrs INTO TABLE lt_bukrs_set.
      INSERT <ar>-gjahr INTO TABLE lt_gjahr_set.
    ENDLOOP.

    LOOP AT lt_bukrs_set ASSIGNING FIELD-SYMBOL(<b>).
      APPEND VALUE #( sign = 'I' option = 'EQ' low = <b> ) TO lt_bukrs.
    ENDLOOP.
    LOOP AT lt_gjahr_set ASSIGNING FIELD-SYMBOL(<g>).
      APPEND VALUE #( sign = 'I' option = 'EQ' low = <g> ) TO lt_gjahr.
    ENDLOOP.

    DATA(lo_recon) = NEW zcl_fi_hist_recon_validator(
      ir_bukrs = lt_bukrs
      ir_gjahr = lt_gjahr ).

    " Calculate expected GL total = sum of all posted amounts
    DATA(lv_expected) = ms_ap_result-total_amount + ms_ar_result-total_amount + ms_cleared_result-total_amount.

    DATA(lt_results) = lo_recon->execute_all(
      iv_ap_hkont    = ms_config-ap_hkont
      iv_ar_hkont    = ms_config-ar_hkont
      iv_gl_expected = lv_expected ).

    " Display reconciliation results
    WRITE: / '------------------------------------------------------------'.
    WRITE: / 'Reconciliation Results'.
    WRITE: / '------------------------------------------------------------'.
    LOOP AT lt_results ASSIGNING FIELD-SYMBOL(<r>).
      WRITE: / |  { <r>-rule }: { <r>-description }|.
      WRITE: / |    Expected: { <r>-expected DECIMALS = 2 }  Actual: { <r>-actual DECIMALS = 2 }  Diff: { <r>-difference DECIMALS = 2 }  → { <r>-status }|.
    ENDLOOP.
    WRITE: / '------------------------------------------------------------'.

  ENDMETHOD.

  METHOD display_results.

    WRITE: / '============================================================'.
    WRITE: / 'FI Historical AP/AR Loading — Final Summary'.
    WRITE: / '============================================================'.
    WRITE: / |Mode               : { COND string( WHEN ms_config-mode = 'T' THEN 'TEST RUN (no posting)' ELSE 'PRODUCTIVE' ) }|.
    WRITE: / '------------------------------------------------------------'.
    WRITE: / 'AP Open Items:'.
    WRITE: / |  Total records     : { ms_ap_result-total_records }|.
    WRITE: / |  Posted            : { ms_ap_result-posted_docs }|.
    WRITE: / |  Failed            : { ms_ap_result-failed_docs }|.
    WRITE: / |  Total Amount      : { ms_ap_result-total_amount DECIMALS = 2 }|.
    WRITE: / '------------------------------------------------------------'.
    WRITE: / 'AR Open Items:'.
    WRITE: / |  Total records     : { ms_ar_result-total_records }|.
    WRITE: / |  Posted            : { ms_ar_result-posted_docs }|.
    WRITE: / |  Failed            : { ms_ar_result-failed_docs }|.
    WRITE: / |  Total Amount      : { ms_ar_result-total_amount DECIMALS = 2 }|.
    WRITE: / '------------------------------------------------------------'.
    WRITE: / 'Cleared Items (Summarized GL):'.
    WRITE: / |  Total buckets     : { ms_cleared_result-total_records }|.
    WRITE: / |  Posted            : { ms_cleared_result-posted_docs }|.
    WRITE: / |  Failed            : { ms_cleared_result-failed_docs }|.
    WRITE: / |  Total Amount      : { ms_cleared_result-total_amount DECIMALS = 2 }|.
    WRITE: / '============================================================'.
    WRITE: / |Execution date      : { sy-datum DATE = USER }|.
    WRITE: / |Execution time      : { sy-uzeit TIME = USER }|.
    WRITE: / |User                : { sy-uname }|.
    WRITE: / '============================================================'.

    " Display error log if any
    IF ms_ap_result-failed_docs > 0.
      display_log( it_log = ms_ap_result-log iv_title = 'AP Errors' ).
    ENDIF.
    IF ms_ar_result-failed_docs > 0.
      display_log( it_log = ms_ar_result-log iv_title = 'AR Errors' ).
    ENDIF.
    IF ms_cleared_result-failed_docs > 0.
      display_log( it_log = ms_cleared_result-log iv_title = 'Cleared Items Errors' ).
    ENDIF.

  ENDMETHOD.

  METHOD display_log.
    WRITE: / |--- { iv_title } ------|.
    LOOP AT it_log ASSIGNING FIELD-SYMBOL(<log>) WHERE msgty CA 'EA'.
      WRITE: / |  [{ <log>-msgty }] { <log>-message }|.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

*----------------------------------------------------------------------*
* Selection Screen
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-b01.
  PARAMETERS: p_mode TYPE c LENGTH 1 DEFAULT 'T' OBLIGATORY.  " T=Test, P=Productive
  SELECTION-SCREEN COMMENT /1(60) TEXT-c01.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-b02.
  PARAMETERS: p_ap_o  AS CHECKBOX DEFAULT 'X',  " Load AP Open Items
              p_ar_o  AS CHECKBOX DEFAULT 'X',  " Load AR Open Items
              p_ap_c  AS CHECKBOX DEFAULT 'X',  " Load AP Cleared (summarized)
              p_ar_c  AS CHECKBOX DEFAULT 'X',  " Load AR Cleared (summarized)
              p_recon AS CHECKBOX DEFAULT 'X'.   " Run Reconciliation
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-b03.
  PARAMETERS: p_batch TYPE i DEFAULT 1000,       " Commit batch size
              p_aphkt TYPE hkont OBLIGATORY,      " AP Reconciliation Account
              p_arhkt TYPE hkont OBLIGATORY,      " AR Reconciliation Account
              p_ofset TYPE hkont OBLIGATORY.      " Migration offset GL account
SELECTION-SCREEN END OF BLOCK b3.

*----------------------------------------------------------------------*
* Initialization
*----------------------------------------------------------------------*
INITIALIZATION.
*  TEXT-b01 = 'Execution Mode'.
*  TEXT-b02 = 'Scope'.
*  TEXT-b03 = 'Configuration'.
*  TEXT-c01 = 'T = Test Run (BAPI_ACC_DOCUMENT_CHECK), P = Productive'.

*----------------------------------------------------------------------*
* Main
*----------------------------------------------------------------------*
START-OF-SELECTION.

  DATA(lo_orchestrator) = NEW lcl_orchestrator(
    VALUE lcl_orchestrator=>ty_run_config(
      mode         = p_mode
      ap_open      = p_ap_o
      ar_open      = p_ar_o
      ap_cleared   = p_ap_c
      ar_cleared   = p_ar_c
      reconcile    = p_recon
      batch_size   = p_batch
      ap_hkont     = p_aphkt
      ar_hkont     = p_arhkt
      offset_acct  = p_ofset ) ).

  lo_orchestrator->execute( ).
