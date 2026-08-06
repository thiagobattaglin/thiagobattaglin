"! Clean Core Wrapper — BAPI_ACC_DOCUMENT_POST/CHECK
"! Tier 2 implementation: encapsulates legacy BAPI calls.
"! Released as C1 for consumption by Tier 1 (ABAP Cloud) classes.
"!
"! Usage: Inject via constructor into loader classes.
"! For unit tests: create a mock implementing ZIF_FI_ACC_DOC_SERVICE.
CLASS zcl_fi_acc_doc_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_fi_acc_doc_service.

ENDCLASS.

CLASS zcl_fi_acc_doc_service IMPLEMENTATION.

  METHOD zif_fi_acc_doc_service~post_document.
    DATA lt_accountgl         TYPE STANDARD TABLE OF bapiacgl09.
    DATA lt_accountpayable    TYPE STANDARD TABLE OF bapiacap09.
    DATA lt_accountreceivable TYPE STANDARD TABLE OF bapiacar09.
    DATA lt_currencyamount    TYPE STANDARD TABLE OF bapiaccr09.
    DATA lt_extension         TYPE STANDARD TABLE OF bapiparex.
    DATA lt_return            TYPE STANDARD TABLE OF bapiret2.

    lt_accountgl         = it_accountgl.
    lt_accountpayable    = it_accountpayable.
    lt_accountreceivable = it_accountreceivable.
    lt_currencyamount    = it_currencyamount.
    lt_extension         = it_extension.

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
      EXPORTING documentheader    = is_header
      TABLES   accountgl          = lt_accountgl
               accountpayable     = lt_accountpayable
               accountreceivable  = lt_accountreceivable
               currencyamount     = lt_currencyamount
               extension2         = lt_extension
               return             = lt_return.

    rs_result-messages = lt_return.

    " Check for errors
    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ret>) WHERE type CA 'EA'.
      rs_result-success = abap_false.
      RETURN.
    ENDLOOP.

    " Extract document number from success message
    ASSIGN lt_return[ type = 'S' id = 'RW' number = '605' ] TO FIELD-SYMBOL(<success>).
    IF sy-subrc = 0.
      rs_result-success = abap_true.
      rs_result-doc_nr  = <success>-message_v2.
      rs_result-fisc_yr = is_header-fisc_year.
      rs_result-comp_cd = is_header-comp_code.
    ENDIF.
  ENDMETHOD.

  METHOD zif_fi_acc_doc_service~check_document.
    DATA lt_accountgl         TYPE STANDARD TABLE OF bapiacgl09.
    DATA lt_accountpayable    TYPE STANDARD TABLE OF bapiacap09.
    DATA lt_accountreceivable TYPE STANDARD TABLE OF bapiacar09.
    DATA lt_currencyamount    TYPE STANDARD TABLE OF bapiaccr09.
    DATA lt_extension         TYPE STANDARD TABLE OF bapiparex.
    DATA lt_return            TYPE STANDARD TABLE OF bapiret2.

    lt_accountgl         = it_accountgl.
    lt_accountpayable    = it_accountpayable.
    lt_accountreceivable = it_accountreceivable.
    lt_currencyamount    = it_currencyamount.
    lt_extension         = it_extension.

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
      EXPORTING documentheader    = is_header
      TABLES   accountgl          = lt_accountgl
               accountpayable     = lt_accountpayable
               accountreceivable  = lt_accountreceivable
               currencyamount     = lt_currencyamount
               extension2         = lt_extension
               return             = lt_return.

    rs_result-messages = lt_return.
    rs_result-success  = abap_true.

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ret>) WHERE type CA 'EA'.
      rs_result-success = abap_false.
      RETURN.
    ENDLOOP.
  ENDMETHOD.

  METHOD zif_fi_acc_doc_service~commit_work.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING wait = abap_true.
  ENDMETHOD.

ENDCLASS.
