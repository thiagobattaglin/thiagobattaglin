"! Clean Core Wrapper Interface — Accounting Document Posting Service
"! Abstracts BAPI_ACC_DOCUMENT_POST/CHECK for testability and Clean Core compliance.
"! Released as C1 API for consumption by ABAP Cloud (Tier 1) code.
INTERFACE zif_fi_acc_doc_service
  PUBLIC.

  TYPES: BEGIN OF ty_doc_result,
           success  TYPE abap_bool,
           doc_nr   TYPE belnr_d,
           fisc_yr  TYPE gjahr,
           comp_cd  TYPE bukrs,
           messages TYPE bapiret2_t,
         END OF ty_doc_result.

  "! Post an accounting document (productive)
  METHODS post_document
    IMPORTING
      is_header            TYPE bapiache09
      it_accountgl         TYPE bapiacgl09_t OPTIONAL
      it_accountpayable    TYPE bapiacap09_t OPTIONAL
      it_accountreceivable TYPE bapiacar09_t OPTIONAL
      it_currencyamount    TYPE bapiaccr09_t OPTIONAL
      it_extension         TYPE bapiparex_t OPTIONAL
    RETURNING
      VALUE(rs_result)     TYPE ty_doc_result.

  "! Check/simulate an accounting document (no commit)
  METHODS check_document
    IMPORTING
      is_header            TYPE bapiache09
      it_accountgl         TYPE bapiacgl09_t OPTIONAL
      it_accountpayable    TYPE bapiacap09_t OPTIONAL
      it_accountreceivable TYPE bapiacar09_t OPTIONAL
      it_currencyamount    TYPE bapiaccr09_t OPTIONAL
      it_extension         TYPE bapiparex_t OPTIONAL
    RETURNING
      VALUE(rs_result)     TYPE ty_doc_result.

  "! Commit posted documents (batch commit)
  METHODS commit_work.

ENDINTERFACE.
