"! Reconciliation Validator
"! Cross-module validation: AP/AR subledger vs GL reconciliation accounts
"! Executes rules R1 (GL total), R2 (AP vs GL), R3 (AR vs GL)
"! Uses released CDS views (C1 API) for Clean Core compliance
CLASS zcl_fi_hist_recon_validator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

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
      IMPORTING iv_expected      TYPE wrbtr
      RETURNING VALUE(rs_result) TYPE ty_recon_result.

    "! R2: AP subledger balance = GL reconciliation account (Vendors)
    METHODS validate_ap_vs_gl
      IMPORTING iv_hkont         TYPE hkont  " Reconciliation account
      RETURNING VALUE(rs_result) TYPE ty_recon_result.

    "! R3: AR subledger balance = GL reconciliation account (Customers)
    METHODS validate_ar_vs_gl
      IMPORTING iv_hkont         TYPE hkont
      RETURNING VALUE(rs_result) TYPE ty_recon_result.

    "! Execute all reconciliation rules
    METHODS execute_all
      IMPORTING iv_ap_hkont       TYPE hkont
                iv_ar_hkont       TYPE hkont
                iv_gl_expected    TYPE wrbtr
      RETURNING VALUE(rt_results) TYPE ty_recon_results.

  PRIVATE SECTION.
    DATA mt_bukrs TYPE RANGE OF bukrs.
    DATA mt_gjahr TYPE RANGE OF gjahr.

ENDCLASS.

CLASS zcl_fi_hist_recon_validator IMPLEMENTATION.

  METHOD constructor.
    mt_bukrs = ir_bukrs.
    mt_gjahr = ir_gjahr.
  ENDMETHOD.

  METHOD validate_gl_balance.
    " Released CDS view I_JournalEntryItem (C1, item-level — replaces ACDOCA)
    SELECT SUM( AmountInCompanyCodeCurrency ) AS total
      FROM I_JournalEntryItem
      INTO @DATA(lv_actual)
      WHERE CompanyCode IN @mt_bukrs
        AND FiscalYear  IN @mt_gjahr
        AND Ledger      = '0L'.

    rs_result = VALUE #(
      rule        = 'R1'
      description = 'GL Total Balance = Source Total Balance'
      expected    = iv_expected
      actual      = lv_actual
      difference  = iv_expected - lv_actual
      status      = COND #( WHEN iv_expected - lv_actual = 0 THEN 'PASS' ELSE 'FAIL' ) ).
  ENDMETHOD.

  METHOD validate_ap_vs_gl.
    " AP subledger balance: items posted to supplier in leading ledger
    SELECT SUM( AmountInCompanyCodeCurrency ) AS total
      FROM I_JournalEntryItem
      INTO @DATA(lv_ap_balance)
      WHERE CompanyCode IN @mt_bukrs
        AND FiscalYear  IN @mt_gjahr
        AND Ledger      = '0L'
        AND Supplier    <> @space.

    " GL reconciliation account balance
    SELECT SUM( AmountInCompanyCodeCurrency ) AS total
      FROM I_JournalEntryItem
      INTO @DATA(lv_gl_balance)
      WHERE CompanyCode IN @mt_bukrs
        AND FiscalYear  IN @mt_gjahr
        AND Ledger      = '0L'
        AND GLAccount   = @iv_hkont.

    rs_result = VALUE #(
      rule        = 'R2'
      description = 'AP Subledger = GL Reconciliation Account'
      expected    = lv_ap_balance
      actual      = lv_gl_balance
      difference  = lv_ap_balance - lv_gl_balance
      status      = COND #( WHEN lv_ap_balance - lv_gl_balance = 0 THEN 'PASS' ELSE 'FAIL' ) ).
  ENDMETHOD.

  METHOD validate_ar_vs_gl.
    " AR subledger balance: items posted to customer in leading ledger
    SELECT SUM( AmountInCompanyCodeCurrency ) AS total
      FROM I_JournalEntryItem
      INTO @DATA(lv_ar_balance)
      WHERE CompanyCode IN @mt_bukrs
        AND FiscalYear  IN @mt_gjahr
        AND Ledger      = '0L'
        AND Customer    <> @space.

    " GL reconciliation account balance
    SELECT SUM( AmountInCompanyCodeCurrency ) AS total
      FROM I_JournalEntryItem
      INTO @DATA(lv_gl_balance)
      WHERE CompanyCode IN @mt_bukrs
        AND FiscalYear  IN @mt_gjahr
        AND Ledger      = '0L'
        AND GLAccount   = @iv_hkont.

    rs_result = VALUE #(
      rule        = 'R3'
      description = 'AR Subledger = GL Reconciliation Account'
      expected    = lv_ar_balance
      actual      = lv_gl_balance
      difference  = lv_ar_balance - lv_gl_balance
      status      = COND #( WHEN lv_ar_balance - lv_gl_balance = 0 THEN 'PASS' ELSE 'FAIL' ) ).
  ENDMETHOD.

  METHOD execute_all.
    rt_results = VALUE #(
      ( validate_gl_balance( iv_gl_expected ) )
      ( validate_ap_vs_gl( iv_ap_hkont ) )
      ( validate_ar_vs_gl( iv_ar_hkont ) ) ).
  ENDMETHOD.

ENDCLASS.
