"! <p class="shorttext synchronized">Interface for FI Clearing Service</p>
"! Abstraction layer for clearing open items via CL_FINS_JE_CLEARING_REQ_HDLR.
"! Enables dependency injection and unit testing.
INTERFACE zif_fi_clearing_service
  PUBLIC.

  TYPES:
    BEGIN OF ty_clearing_header,
      bukrs TYPE bukrs,
      blart TYPE blart,
      bldat TYPE bldat,
      budat TYPE budat,
      monat TYPE monat,
      waers TYPE waers,
      bktxt TYPE bktxt,
      xblnr TYPE xblnr,
      kursf TYPE kursf,
      wwert TYPE wwert,
    END OF ty_clearing_header.

  TYPES:
    BEGIN OF ty_apar_item,
      bukrs TYPE bukrs,
      belnr TYPE belnr_d,
      buzei TYPE buzei,
      gjahr TYPE gjahr,
      koart TYPE koart,
      konko TYPE lifnr,
    END OF ty_apar_item,

    ty_apar_items TYPE STANDARD TABLE OF ty_apar_item WITH EMPTY KEY.

  TYPES:
    BEGIN OF ty_gl_item,
      bukrs TYPE bukrs,
      belnr TYPE belnr_d,
      buzei TYPE buzei,
      gjahr TYPE gjahr,
      hkont TYPE hkont,
    END OF ty_gl_item,

    ty_gl_items TYPE STANDARD TABLE OF ty_gl_item WITH EMPTY KEY.

  TYPES:
    ty_messages TYPE STANDARD TABLE OF bapiret2 WITH EMPTY KEY.

  TYPES:
    BEGIN OF ty_clearing_result,
      success     TYPE abap_bool,
      belnr       TYPE belnr_d,
      bukrs       TYPE bukrs,
      gjahr       TYPE gjahr,
      messages    TYPE ty_messages,
    END OF ty_clearing_result.

  METHODS clear_open_items
    IMPORTING
      is_header    TYPE ty_clearing_header
      it_apar_items TYPE ty_apar_items OPTIONAL
      it_gl_items  TYPE ty_gl_items OPTIONAL
      iv_test_run  TYPE abap_bool DEFAULT abap_false
    RETURNING
      VALUE(rs_result) TYPE ty_clearing_result.

  METHODS commit
    RETURNING
      VALUE(rs_msg) TYPE bapiret2.

  METHODS rollback
    RETURNING
      VALUE(rs_msg) TYPE bapiret2.

ENDINTERFACE.
