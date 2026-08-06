"! Interface: Common contract for all FI Historical Loaders
"! Clean Core Compliant — S/4HANA Cloud Private Edition
INTERFACE zif_fi_hist_loader
  PUBLIC.

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
