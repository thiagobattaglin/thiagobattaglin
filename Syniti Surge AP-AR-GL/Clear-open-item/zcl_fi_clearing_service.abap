"! <p class="shorttext synchronized">Wrapper for CL_FINS_JE_CLEARING_REQ_HDLR</p>
"! Encapsulates the standard SAP clearing handler for AP/AR/GL open items.
"! Provides a simplified interface with proper type mapping.
"! Designed for high-volume batch processing of vendor clearing documents.
CLASS zcl_fi_clearing_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_fi_clearing_service.

    METHODS constructor
      IMPORTING
        io_clearing_handler TYPE REF TO if_fins_je_clearing_req_hdlr OPTIONAL.

  PRIVATE SECTION.
    DATA mo_handler TYPE REF TO if_fins_je_clearing_req_hdlr.

    METHODS map_header
      IMPORTING
        is_header       TYPE zif_fi_clearing_service=>ty_clearing_header
      RETURNING
        VALUE(rs_header) TYPE cl_fdc_clearing_document_inf=>ty_clearing_header.

    METHODS map_apar_items
      IMPORTING
        is_header      TYPE zif_fi_clearing_service=>ty_clearing_header
        it_items       TYPE zif_fi_clearing_service=>ty_apar_items
      EXPORTING
        et_items       TYPE cl_fdc_clearing_document_inf=>tty_apar_item_to_be_clrd.

    METHODS map_gl_items
      IMPORTING
        is_header      TYPE zif_fi_clearing_service=>ty_clearing_header
        it_items       TYPE zif_fi_clearing_service=>ty_gl_items
      EXPORTING
        et_items       TYPE cl_fdc_clearing_document_inf=>tty_gl_item_to_be_clrd.

    METHODS has_errors
      IMPORTING
        it_messages    TYPE bapirettab
      RETURNING
        VALUE(rv_result) TYPE abap_bool.

ENDCLASS.


CLASS zcl_fi_clearing_service IMPLEMENTATION.

  METHOD constructor.
    IF io_clearing_handler IS BOUND.
      mo_handler = io_clearing_handler.
    ELSE.
      mo_handler = NEW cl_fins_je_clearing_req_hdlr( ).
    ENDIF.
  ENDMETHOD.


  METHOD zif_fi_clearing_service~clear_open_items.
    DATA ls_posted_doc TYPE fdc_s_accdoc_hdr_key_odata.
    DATA lt_msg        TYPE bapirettab.

    DATA(ls_doc_header) = map_header( is_header ).

    map_apar_items( EXPORTING is_header = is_header
                              it_items  = it_apar_items
                    IMPORTING et_items  = DATA(lt_apar) ).

    map_gl_items( EXPORTING is_header = is_header
                            it_items  = it_gl_items
                  IMPORTING et_items  = DATA(lt_gl) ).

    DATA(lv_rejected) = mo_handler->post(
      EXPORTING
        is_docheader       = ls_doc_header
        it_aparitem        = lt_apar
        it_accountgl       = lt_gl
        iv_test_run        = iv_test_run
      IMPORTING
        es_posted_document = ls_posted_doc
        et_msg             = lt_msg ).

    rs_result-messages = lt_msg.

    IF lv_rejected = abap_false AND ls_posted_doc IS NOT INITIAL.
      rs_result-success = abap_true.
      rs_result-belnr   = ls_posted_doc-belnr.
      rs_result-bukrs   = ls_posted_doc-bukrs.
      rs_result-gjahr   = ls_posted_doc-gjahr.
    ELSE.
      rs_result-success = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD zif_fi_clearing_service~commit.
    mo_handler->commit( IMPORTING es_msg = rs_msg ).
  ENDMETHOD.


  METHOD zif_fi_clearing_service~rollback.
    mo_handler->rollback( IMPORTING es_msg = rs_msg ).
  ENDMETHOD.


  METHOD map_header.
    rs_header-bukrs = is_header-bukrs.
    rs_header-blart = is_header-blart.
    rs_header-bldat = is_header-bldat.
    rs_header-budat = is_header-budat.
    rs_header-monat = is_header-monat.
    rs_header-waers = is_header-waers.
    rs_header-bktxt = is_header-bktxt.
    rs_header-xblnr = is_header-xblnr.
    rs_header-kursf = is_header-kursf.
    rs_header-wwert = is_header-wwert.
  ENDMETHOD.


  METHOD map_apar_items.
    CLEAR et_items.
    LOOP AT it_items INTO DATA(ls_item).
      APPEND INITIAL LINE TO et_items ASSIGNING FIELD-SYMBOL(<fs_item>).

      <fs_item>-belnr = ls_item-belnr.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING input  = <fs_item>-belnr
        IMPORTING output = <fs_item>-belnr.

      <fs_item>-buzei = ls_item-buzei.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING input  = <fs_item>-buzei
        IMPORTING output = <fs_item>-buzei.

      IF ls_item-bukrs IS INITIAL.
        <fs_item>-bukrs = is_header-bukrs.
      ELSE.
        <fs_item>-bukrs = ls_item-bukrs.
      ENDIF.

      <fs_item>-gjahr = ls_item-gjahr.
      <fs_item>-koart = ls_item-koart.

      <fs_item>-konko = ls_item-konko.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING input  = <fs_item>-konko
        IMPORTING output = <fs_item>-konko.
    ENDLOOP.
  ENDMETHOD.


  METHOD map_gl_items.
    CLEAR et_items.
    LOOP AT it_items INTO DATA(ls_item).
      APPEND INITIAL LINE TO et_items ASSIGNING FIELD-SYMBOL(<fs_item>).

      <fs_item>-belnr = ls_item-belnr.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING input  = <fs_item>-belnr
        IMPORTING output = <fs_item>-belnr.

      <fs_item>-buzei = ls_item-buzei.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING input  = <fs_item>-buzei
        IMPORTING output = <fs_item>-buzei.

      IF ls_item-bukrs IS INITIAL.
        <fs_item>-bukrs = is_header-bukrs.
      ELSE.
        <fs_item>-bukrs = ls_item-bukrs.
      ENDIF.

      <fs_item>-gjahr = ls_item-gjahr.

      <fs_item>-hkont = ls_item-hkont.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING input  = <fs_item>-hkont
        IMPORTING output = <fs_item>-hkont.
    ENDLOOP.
  ENDMETHOD.


  METHOD has_errors.
    rv_result = abap_false.
    LOOP AT it_messages TRANSPORTING NO FIELDS WHERE type CA 'EA'.
      rv_result = abap_true.
      RETURN.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
