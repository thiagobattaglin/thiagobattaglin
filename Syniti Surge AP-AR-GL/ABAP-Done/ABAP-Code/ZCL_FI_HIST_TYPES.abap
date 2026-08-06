"! Global class: AP/AR Source Data Structures and Type Definitions
"! Used by all FI Historical Loading classes
CLASS zcl_fi_hist_types DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

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
             manst     TYPE mahns,          " Dunning Level
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

CLASS zcl_fi_hist_types IMPLEMENTATION.
ENDCLASS.
