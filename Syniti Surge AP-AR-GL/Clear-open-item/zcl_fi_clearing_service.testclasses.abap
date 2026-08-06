"! <p class="shorttext synchronized">Mock for IF_FINS_JE_CLEARING_REQ_HDLR</p>
CLASS ltd_mock_clearing_handler DEFINITION
  FOR TESTING.

  PUBLIC SECTION.
    INTERFACES if_fins_je_clearing_req_hdlr.

    DATA ms_last_docheader TYPE cl_fdc_clearing_document_inf=>ty_clearing_header.
    DATA mt_last_aparitem  TYPE cl_fdc_clearing_document_inf=>tty_apar_item_to_be_clrd.
    DATA mt_last_accountgl TYPE cl_fdc_clearing_document_inf=>tty_gl_item_to_be_clrd.
    DATA mv_last_test_run  TYPE abap_bool.

    DATA ms_posted_document TYPE fdc_s_accdoc_hdr_key_odata.
    DATA mt_return_msg      TYPE bapirettab.
    DATA mv_save_rejected   TYPE abap_bool.

    DATA mv_commit_called   TYPE abap_bool.
    DATA mv_rollback_called TYPE abap_bool.

ENDCLASS.


CLASS ltd_mock_clearing_handler IMPLEMENTATION.

  METHOD if_fins_je_clearing_req_hdlr~post.
    ms_last_docheader = is_docheader.
    mt_last_aparitem  = it_aparitem.
    mt_last_accountgl = it_accountgl.
    mv_last_test_run  = iv_test_run.

    es_posted_document = ms_posted_document.
    et_msg             = mt_return_msg.
    rv_save_rejected   = mv_save_rejected.
  ENDMETHOD.

  METHOD if_fins_je_clearing_req_hdlr~commit.
    mv_commit_called = abap_true.
    CLEAR es_msg.
  ENDMETHOD.

  METHOD if_fins_je_clearing_req_hdlr~rollback.
    mv_rollback_called = abap_true.
    CLEAR es_msg.
  ENDMETHOD.

ENDCLASS.


"! <p class="shorttext synchronized">Unit Tests for ZCL_FI_CLEARING_SERVICE</p>
"! Tests the wrapper class using a mock of IF_FINS_JE_CLEARING_REQ_HDLR.
CLASS ltcl_clearing_service DEFINITION
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut   TYPE REF TO zcl_fi_clearing_service.
    DATA mo_mock  TYPE REF TO ltd_mock_clearing_handler.

    METHODS setup.
    METHODS clear_ap_items_success FOR TESTING.
    METHODS clear_ap_items_rejected FOR TESTING.
    METHODS clear_gl_items_success FOR TESTING.
    METHODS clear_test_run FOR TESTING.
    METHODS commit_delegates_to_handler FOR TESTING.
    METHODS rollback_delegates_to_handler FOR TESTING.
    METHODS map_header_correctly FOR TESTING.
    METHODS map_apar_items_default_bukrs FOR TESTING.
    METHODS map_gl_items_default_bukrs FOR TESTING.

ENDCLASS.


CLASS ltcl_clearing_service IMPLEMENTATION.

  METHOD setup.
    mo_mock = NEW ltd_mock_clearing_handler( ).
    mo_cut  = NEW zcl_fi_clearing_service( io_clearing_handler = mo_mock ).
  ENDMETHOD.


  METHOD clear_ap_items_success.
    " Arrange
    mo_mock->ms_posted_document = VALUE #( belnr = '0100000001'
                                           bukrs = '1000'
                                           gjahr = '2023' ).
    mo_mock->mv_save_rejected = abap_false.
    mo_mock->mt_return_msg = VALUE #(
      ( type = 'S' id = 'FINS_FI_POSTING_IF' number = '044' ) ).

    DATA(ls_header) = VALUE zif_fi_clearing_service=>ty_clearing_header(
      bukrs = '1000'
      blart = 'AB'
      bldat = '20231107'
      budat = '20231107'
      waers = 'USD' ).

    DATA(lt_items) = VALUE zif_fi_clearing_service=>ty_apar_items(
      ( bukrs = '1000' belnr = '1500000003' buzei = '001'
        gjahr = '2023' koart = 'K' konko = '100188' )
      ( bukrs = '1000' belnr = '1500000004' buzei = '001'
        gjahr = '2023' koart = 'K' konko = '100188' )
      ( bukrs = '1000' belnr = '1900000003' buzei = '001'
        gjahr = '2023' koart = 'K' konko = '100188' ) ).

    " Act
    DATA(ls_result) = mo_cut->zif_fi_clearing_service~clear_open_items(
      is_header     = ls_header
      it_apar_items = lt_items ).

    " Assert
    cl_abap_unit_assert=>assert_equals( exp = abap_true
                                        act = ls_result-success
                                        msg = 'Clearing should succeed' ).
    cl_abap_unit_assert=>assert_equals( exp = '0100000001'
                                        act = ls_result-belnr
                                        msg = 'Document number mismatch' ).
    cl_abap_unit_assert=>assert_equals( exp = '1000'
                                        act = ls_result-bukrs ).
    cl_abap_unit_assert=>assert_equals( exp = '2023'
                                        act = ls_result-gjahr ).
  ENDMETHOD.


  METHOD clear_ap_items_rejected.
    " Arrange
    mo_mock->mv_save_rejected = abap_true.
    mo_mock->mt_return_msg = VALUE #(
      ( type = 'E' id = 'FINS_FI_POSTING_IF' number = '008'
        message = 'Items cannot be cleared' ) ).

    DATA(ls_header) = VALUE zif_fi_clearing_service=>ty_clearing_header(
      bukrs = '1000'
      blart = 'AB'
      bldat = '20231107'
      budat = '20231107'
      waers = 'USD' ).

    DATA(lt_items) = VALUE zif_fi_clearing_service=>ty_apar_items(
      ( bukrs = '1000' belnr = '1500000003' buzei = '001'
        gjahr = '2023' koart = 'K' konko = '100188' ) ).

    " Act
    DATA(ls_result) = mo_cut->zif_fi_clearing_service~clear_open_items(
      is_header     = ls_header
      it_apar_items = lt_items ).

    " Assert
    cl_abap_unit_assert=>assert_equals( exp = abap_false
                                        act = ls_result-success
                                        msg = 'Clearing should fail' ).
    cl_abap_unit_assert=>assert_not_initial( act = ls_result-messages
                                             msg = 'Error messages expected' ).
  ENDMETHOD.


  METHOD clear_gl_items_success.
    " Arrange
    mo_mock->ms_posted_document = VALUE #( belnr = '0200000001'
                                           bukrs = '1000'
                                           gjahr = '2023' ).
    mo_mock->mv_save_rejected = abap_false.

    DATA(ls_header) = VALUE zif_fi_clearing_service=>ty_clearing_header(
      bukrs = '1000'
      blart = 'AB'
      bldat = '20231107'
      budat = '20231107'
      waers = 'USD' ).

    DATA(lt_gl_items) = VALUE zif_fi_clearing_service=>ty_gl_items(
      ( bukrs = '1000' belnr = '1500000010' buzei = '001'
        gjahr = '2023' hkont = '0021000000' )
      ( bukrs = '1000' belnr = '1500000011' buzei = '001'
        gjahr = '2023' hkont = '0021000000' ) ).

    " Act
    DATA(ls_result) = mo_cut->zif_fi_clearing_service~clear_open_items(
      is_header   = ls_header
      it_gl_items = lt_gl_items ).

    " Assert
    cl_abap_unit_assert=>assert_equals( exp = abap_true
                                        act = ls_result-success ).
    cl_abap_unit_assert=>assert_equals( exp = '0200000001'
                                        act = ls_result-belnr ).
  ENDMETHOD.


  METHOD clear_test_run.
    " Arrange
    mo_mock->mv_save_rejected = abap_false.
    " No posted document in test mode
    CLEAR mo_mock->ms_posted_document.

    DATA(ls_header) = VALUE zif_fi_clearing_service=>ty_clearing_header(
      bukrs = '1000'
      blart = 'AB'
      bldat = '20231107'
      budat = '20231107'
      waers = 'USD' ).

    DATA(lt_items) = VALUE zif_fi_clearing_service=>ty_apar_items(
      ( bukrs = '1000' belnr = '1500000003' buzei = '001'
        gjahr = '2023' koart = 'K' konko = '100188' ) ).

    " Act
    DATA(ls_result) = mo_cut->zif_fi_clearing_service~clear_open_items(
      is_header     = ls_header
      it_apar_items = lt_items
      iv_test_run   = abap_true ).

    " Assert — test run passes through
    cl_abap_unit_assert=>assert_equals( exp = abap_true
                                        act = mo_mock->mv_last_test_run
                                        msg = 'Test run flag not passed' ).
  ENDMETHOD.


  METHOD commit_delegates_to_handler.
    " Act
    mo_cut->zif_fi_clearing_service~commit( ).

    " Assert
    cl_abap_unit_assert=>assert_equals( exp = abap_true
                                        act = mo_mock->mv_commit_called
                                        msg = 'Commit not delegated' ).
  ENDMETHOD.


  METHOD rollback_delegates_to_handler.
    " Act
    mo_cut->zif_fi_clearing_service~rollback( ).

    " Assert
    cl_abap_unit_assert=>assert_equals( exp = abap_true
                                        act = mo_mock->mv_rollback_called
                                        msg = 'Rollback not delegated' ).
  ENDMETHOD.


  METHOD map_header_correctly.
    " Arrange
    mo_mock->mv_save_rejected = abap_false.
    mo_mock->ms_posted_document = VALUE #( belnr = '0100000001'
                                           bukrs = '1000'
                                           gjahr = '2023' ).

    DATA(ls_header) = VALUE zif_fi_clearing_service=>ty_clearing_header(
      bukrs = '1000'
      blart = 'AB'
      bldat = '20231107'
      budat = '20231107'
      monat = '11'
      waers = 'USD'
      bktxt = 'Test clearing'
      xblnr = 'REF001' ).

    " Act
    mo_cut->zif_fi_clearing_service~clear_open_items(
      is_header     = ls_header
      it_apar_items = VALUE #(
        ( bukrs = '1000' belnr = '1500000003' buzei = '001'
          gjahr = '2023' koart = 'K' konko = '100188' ) ) ).

    " Assert - check the mapped header received by mock
    cl_abap_unit_assert=>assert_equals( exp = '1000'
                                        act = mo_mock->ms_last_docheader-bukrs ).
    cl_abap_unit_assert=>assert_equals( exp = 'AB'
                                        act = mo_mock->ms_last_docheader-blart ).
    cl_abap_unit_assert=>assert_equals( exp = '20231107'
                                        act = mo_mock->ms_last_docheader-bldat ).
    cl_abap_unit_assert=>assert_equals( exp = '20231107'
                                        act = mo_mock->ms_last_docheader-budat ).
    cl_abap_unit_assert=>assert_equals( exp = 'USD'
                                        act = mo_mock->ms_last_docheader-waers ).
    cl_abap_unit_assert=>assert_equals( exp = 'Test clearing'
                                        act = mo_mock->ms_last_docheader-bktxt ).
    cl_abap_unit_assert=>assert_equals( exp = 'REF001'
                                        act = mo_mock->ms_last_docheader-xblnr ).
  ENDMETHOD.


  METHOD map_apar_items_default_bukrs.
    " Arrange - item without bukrs should inherit from header
    mo_mock->mv_save_rejected = abap_false.
    mo_mock->ms_posted_document = VALUE #( belnr = '0100000001'
                                           bukrs = '1000'
                                           gjahr = '2023' ).

    DATA(ls_header) = VALUE zif_fi_clearing_service=>ty_clearing_header(
      bukrs = '2000'
      blart = 'AB'
      bldat = '20231107'
      budat = '20231107'
      waers = 'USD' ).

    DATA(lt_items) = VALUE zif_fi_clearing_service=>ty_apar_items(
      ( belnr = '1500000003' buzei = '001'
        gjahr = '2023' koart = 'K' konko = '100188' ) ).

    " Act
    mo_cut->zif_fi_clearing_service~clear_open_items(
      is_header     = ls_header
      it_apar_items = lt_items ).

    " Assert - bukrs should default from header
    cl_abap_unit_assert=>assert_equals(
      exp = '2000'
      act = mo_mock->mt_last_aparitem[ 1 ]-bukrs
      msg = 'BUKRS should default from header' ).
  ENDMETHOD.


  METHOD map_gl_items_default_bukrs.
    " Arrange - GL item without bukrs should inherit from header
    mo_mock->mv_save_rejected = abap_false.
    mo_mock->ms_posted_document = VALUE #( belnr = '0100000001'
                                           bukrs = '1000'
                                           gjahr = '2023' ).

    DATA(ls_header) = VALUE zif_fi_clearing_service=>ty_clearing_header(
      bukrs = '3000'
      blart = 'AB'
      bldat = '20231107'
      budat = '20231107'
      waers = 'USD' ).

    DATA(lt_gl) = VALUE zif_fi_clearing_service=>ty_gl_items(
      ( belnr = '1500000010' buzei = '001'
        gjahr = '2023' hkont = '0021000000' ) ).

    " Act
    mo_cut->zif_fi_clearing_service~clear_open_items(
      is_header   = ls_header
      it_gl_items = lt_gl ).

    " Assert
    cl_abap_unit_assert=>assert_equals(
      exp = '3000'
      act = mo_mock->mt_last_accountgl[ 1 ]-bukrs
      msg = 'BUKRS should default from header for GL items' ).
  ENDMETHOD.

ENDCLASS.
