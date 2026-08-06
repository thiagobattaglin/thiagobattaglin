*&---------------------------------------------------------------------*
*& Report ZFI_EXTRACT_AP_AR_HIST
*& Extraction of AP/AR Open + Cleared Items from Source System
*& For Historic Transaction Loading into S/4HANA
*&---------------------------------------------------------------------*
*& Reads from:
*&   AP Open:    BSIK (or BSIK_VIEW in S/4HANA)
*&   AP Cleared: BSAK
*&   AR Open:    BSID (or BSID_VIEW in S/4HANA)
*&   AR Cleared: BSAD
*& Outputs CSV files compatible with the loading classes
*&---------------------------------------------------------------------*
REPORT zfi_extract_ap_ar_hist.

*----------------------------------------------------------------------*
* Class Definition
*----------------------------------------------------------------------*
CLASS lcl_ap_ar_extractor DEFINITION FINAL.

  PUBLIC SECTION.

    " Reuse types from the loading module
    TYPES: BEGIN OF ty_ap_item,
             bukrs     TYPE bukrs,
             belnr     TYPE belnr_d,
             gjahr     TYPE gjahr,
             buzei     TYPE buzei,
             lifnr     TYPE lifnr,
             blart     TYPE blart,
             bldat     TYPE bldat,
             budat     TYPE budat,
             monat     TYPE monat,
             waers     TYPE waers,
             dmbtr     TYPE dmbtr,
             wrbtr     TYPE wrbtr,
             mwskz     TYPE mwskz,
             kostl     TYPE kostl,
             prctr     TYPE prctr,
             segment   TYPE fb_segment,
             zuonr     TYPE dzuonr,
             sgtxt     TYPE sgtxt,
             zfbdt     TYPE dzfbdt,
             zterm     TYPE dzterm,
             zlspr     TYPE dzlspr,
             hkont     TYPE hkont,
             bschl     TYPE bschl,
             shkzg     TYPE shkzg,
             umskz     TYPE umskz,
             xblnr     TYPE xblnr,
             saknr     TYPE saknr,
             gsber     TYPE gsber,
             fkber     TYPE fkber,
             augbl     TYPE augbl,           " Clearing document (only for cleared)
             augdt     TYPE augdt,           " Clearing date
             status    TYPE c LENGTH 1,      " O=Open, C=Cleared
           END OF ty_ap_item,
           ty_ap_items TYPE STANDARD TABLE OF ty_ap_item WITH EMPTY KEY.

    TYPES: BEGIN OF ty_ar_item,
             bukrs     TYPE bukrs,
             belnr     TYPE belnr_d,
             gjahr     TYPE gjahr,
             buzei     TYPE buzei,
             kunnr     TYPE kunnr,
             blart     TYPE blart,
             bldat     TYPE bldat,
             budat     TYPE budat,
             monat     TYPE monat,
             waers     TYPE waers,
             dmbtr     TYPE dmbtr,
             wrbtr     TYPE wrbtr,
             mwskz     TYPE mwskz,
             kostl     TYPE kostl,
             prctr     TYPE prctr,
             segment   TYPE fb_segment,
             zuonr     TYPE dzuonr,
             sgtxt     TYPE sgtxt,
             zfbdt     TYPE dzfbdt,
             zterm     TYPE dzterm,
             hkont     TYPE hkont,
             bschl     TYPE bschl,
             shkzg     TYPE shkzg,
             umskz     TYPE umskz,
             xblnr     TYPE xblnr,
             saknr     TYPE saknr,
             gsber     TYPE gsber,
             fkber     TYPE fkber,
             manst     TYPE manst,           " Dunning Level
             madat     TYPE madat,           " Last Dunned Date
             maber     TYPE maber,           " Dunning Area
             augbl     TYPE augbl,
             augdt     TYPE augdt,
             status    TYPE c LENGTH 1,
           END OF ty_ar_item,
           ty_ar_items TYPE STANDARD TABLE OF ty_ar_item WITH EMPTY KEY.

    " BP Mapping structure
    TYPES: BEGIN OF ty_bp_map,
             legacy_id TYPE c LENGTH 10,
             bp_number TYPE bu_partner,
             bp_type   TYPE c LENGTH 2,
           END OF ty_bp_map,
           ty_bp_maps TYPE STANDARD TABLE OF ty_bp_map WITH EMPTY KEY.

    METHODS constructor
      IMPORTING
        ir_bukrs    TYPE ANY TABLE
        ir_gjahr    TYPE ANY TABLE
        ir_lifnr    TYPE ANY TABLE
        ir_kunnr    TYPE ANY TABLE
        iv_ap       TYPE abap_bool DEFAULT abap_true
        iv_ar       TYPE abap_bool DEFAULT abap_true
        iv_open     TYPE abap_bool DEFAULT abap_true
        iv_cleared  TYPE abap_bool DEFAULT abap_true
        iv_file_ap  TYPE string
        iv_file_ar  TYPE string
        iv_file_bp  TYPE string
        iv_srvpath  TYPE string.

    METHODS execute.

    " Getters for extracted data
    METHODS get_ap_open    RETURNING VALUE(rt_data) TYPE ty_ap_items.
    METHODS get_ap_cleared RETURNING VALUE(rt_data) TYPE ty_ap_items.
    METHODS get_ar_open    RETURNING VALUE(rt_data) TYPE ty_ar_items.
    METHODS get_ar_cleared RETURNING VALUE(rt_data) TYPE ty_ar_items.
    METHODS get_bp_mapping RETURNING VALUE(rt_data) TYPE ty_bp_maps.

  PRIVATE SECTION.
    DATA: mt_bukrs    TYPE RANGE OF bukrs,
          mt_gjahr    TYPE RANGE OF gjahr,
          mt_lifnr    TYPE RANGE OF lifnr,
          mt_kunnr    TYPE RANGE OF kunnr,
          mv_ap       TYPE abap_bool,
          mv_ar       TYPE abap_bool,
          mv_open     TYPE abap_bool,
          mv_cleared  TYPE abap_bool,
          mv_file_ap  TYPE string,
          mv_file_ar  TYPE string,
          mv_file_bp  TYPE string,
          mv_srvpath  TYPE string.

    DATA: mt_ap_open    TYPE ty_ap_items,
          mt_ap_cleared TYPE ty_ap_items,
          mt_ar_open    TYPE ty_ar_items,
          mt_ar_cleared TYPE ty_ar_items,
          mt_bp_mapping TYPE ty_bp_maps.

    METHODS extract_ap_open.
    METHODS extract_ap_cleared.
    METHODS extract_ar_open.
    METHODS extract_ar_cleared.
    METHODS build_bp_mapping.
    METHODS export_csv_ap IMPORTING it_data TYPE ty_ap_items iv_filename TYPE string.
    METHODS export_csv_ar IMPORTING it_data TYPE ty_ar_items iv_filename TYPE string.
    METHODS export_csv_bp.
    METHODS display_summary.
    METHODS is_background RETURNING VALUE(rv_bg) TYPE abap_bool.

ENDCLASS.

*----------------------------------------------------------------------*
* Class Implementation
*----------------------------------------------------------------------*
CLASS lcl_ap_ar_extractor IMPLEMENTATION.

  METHOD constructor.
    mt_bukrs    = ir_bukrs.
    mt_gjahr    = ir_gjahr.
    mt_lifnr    = ir_lifnr.
    mt_kunnr    = ir_kunnr.
    mv_ap       = iv_ap.
    mv_ar       = iv_ar.
    mv_open     = iv_open.
    mv_cleared  = iv_cleared.
    mv_file_ap  = iv_file_ap.
    mv_file_ar  = iv_file_ar.
    mv_file_bp  = iv_file_bp.
    mv_srvpath  = iv_srvpath.
  ENDMETHOD.

  METHOD is_background.
    rv_bg = COND #( WHEN sy-batch = abap_true THEN abap_true ELSE abap_false ).
  ENDMETHOD.

  METHOD execute.

    " --- AP Extraction ---
    IF mv_ap = abap_true.
      IF mv_open = abap_true.
        extract_ap_open( ).
      ENDIF.
      IF mv_cleared = abap_true.
        extract_ap_cleared( ).
      ENDIF.
    ENDIF.

    " --- AR Extraction ---
    IF mv_ar = abap_true.
      IF mv_open = abap_true.
        extract_ar_open( ).
      ENDIF.
      IF mv_cleared = abap_true.
        extract_ar_cleared( ).
      ENDIF.
    ENDIF.

    " --- BP Mapping ---
    build_bp_mapping( ).

    " --- Export ---
    IF mt_ap_open IS NOT INITIAL OR mt_ap_cleared IS NOT INITIAL.
      DATA(lt_ap_all) = mt_ap_open.
      APPEND LINES OF mt_ap_cleared TO lt_ap_all.
      export_csv_ap( it_data = lt_ap_all iv_filename = mv_file_ap ).
    ENDIF.

    IF mt_ar_open IS NOT INITIAL OR mt_ar_cleared IS NOT INITIAL.
      DATA(lt_ar_all) = mt_ar_open.
      APPEND LINES OF mt_ar_cleared TO lt_ar_all.
      export_csv_ar( it_data = lt_ar_all iv_filename = mv_file_ar ).
    ENDIF.

    IF mt_bp_mapping IS NOT INITIAL.
      export_csv_bp( ).
    ENDIF.

    display_summary( ).

  ENDMETHOD.

  METHOD extract_ap_open.

    " BSIK = AP Open Items (in S/4HANA this is a compatibility view)
    SELECT b~bukrs, b~belnr, b~gjahr, b~buzei,
           b~lifnr, b~blart, b~bldat, b~budat, b~monat,
           b~waers, b~dmbtr, b~wrbtr, b~mwskz,
           b~kostl, b~prctr, b~gsber,
           b~zuonr, b~sgtxt, b~zfbdt, b~zterm, b~zlspr,
           b~hkont, b~bschl, b~shkzg, b~umskz, b~xblnr,
           b~saknr
      FROM bsik AS b
      INTO CORRESPONDING FIELDS OF TABLE @mt_ap_open
      WHERE b~bukrs IN @mt_bukrs
        AND b~gjahr IN @mt_gjahr
        AND b~lifnr IN @mt_lifnr.

    " Mark as open items
    LOOP AT mt_ap_open ASSIGNING FIELD-SYMBOL(<item>).
      <item>-status = 'O'.
    ENDLOOP.

    DATA(lv_count) = lines( mt_ap_open ).
    IF is_background( ).
      WRITE: / |AP Open Items extracted: { lv_count }|.
    ELSE.
      MESSAGE |AP Open Items extracted: { lv_count }| TYPE 'S'.
    ENDIF.

  ENDMETHOD.

  METHOD extract_ap_cleared.

    " BSAK = AP Cleared Items
    SELECT b~bukrs, b~belnr, b~gjahr, b~buzei,
           b~lifnr, b~blart, b~bldat, b~budat, b~monat,
           b~waers, b~dmbtr, b~wrbtr, b~mwskz,
           b~kostl, b~prctr, b~gsber,
           b~zuonr, b~sgtxt, b~zfbdt, b~zterm,
           b~hkont, b~bschl, b~shkzg, b~umskz, b~xblnr,
           b~saknr, b~augbl, b~augdt
      FROM bsak AS b
      INTO CORRESPONDING FIELDS OF TABLE @mt_ap_cleared
      WHERE b~bukrs IN @mt_bukrs
        AND b~gjahr IN @mt_gjahr
        AND b~lifnr IN @mt_lifnr.

    LOOP AT mt_ap_cleared ASSIGNING FIELD-SYMBOL(<item>).
      <item>-status = 'C'.
    ENDLOOP.

    DATA(lv_count) = lines( mt_ap_cleared ).
    IF is_background( ).
      WRITE: / |AP Cleared Items extracted: { lv_count }|.
    ELSE.
      MESSAGE |AP Cleared Items extracted: { lv_count }| TYPE 'S'.
    ENDIF.

  ENDMETHOD.

  METHOD extract_ar_open.

    " BSID = AR Open Items
    SELECT b~bukrs, b~belnr, b~gjahr, b~buzei,
           b~kunnr, b~blart, b~bldat, b~budat, b~monat,
           b~waers, b~dmbtr, b~wrbtr, b~mwskz,
           b~kostl, b~prctr, b~gsber,
           b~zuonr, b~sgtxt, b~zfbdt, b~zterm,
           b~hkont, b~bschl, b~shkzg, b~umskz, b~xblnr,
           b~saknr, b~manst, b~madat, b~maber
      FROM bsid AS b
      INTO CORRESPONDING FIELDS OF TABLE @mt_ar_open
      WHERE b~bukrs IN @mt_bukrs
        AND b~gjahr IN @mt_gjahr
        AND b~kunnr IN @mt_kunnr.

    LOOP AT mt_ar_open ASSIGNING FIELD-SYMBOL(<item>).
      <item>-status = 'O'.
    ENDLOOP.

    DATA(lv_count) = lines( mt_ar_open ).
    IF is_background( ).
      WRITE: / |AR Open Items extracted: { lv_count }|.
    ELSE.
      MESSAGE |AR Open Items extracted: { lv_count }| TYPE 'S'.
    ENDIF.

  ENDMETHOD.

  METHOD extract_ar_cleared.

    " BSAD = AR Cleared Items
    SELECT b~bukrs, b~belnr, b~gjahr, b~buzei,
           b~kunnr, b~blart, b~bldat, b~budat, b~monat,
           b~waers, b~dmbtr, b~wrbtr, b~mwskz,
           b~kostl, b~prctr, b~gsber,
           b~zuonr, b~sgtxt, b~zfbdt, b~zterm,
           b~hkont, b~bschl, b~shkzg, b~umskz, b~xblnr,
           b~saknr, b~manst, b~madat, b~maber,
           b~augbl, b~augdt
      FROM bsad AS b
      INTO CORRESPONDING FIELDS OF TABLE @mt_ar_cleared
      WHERE b~bukrs IN @mt_bukrs
        AND b~gjahr IN @mt_gjahr
        AND b~kunnr IN @mt_kunnr.

    LOOP AT mt_ar_cleared ASSIGNING FIELD-SYMBOL(<item>).
      <item>-status = 'C'.
    ENDLOOP.

    DATA(lv_count) = lines( mt_ar_cleared ).
    IF is_background( ).
      WRITE: / |AR Cleared Items extracted: { lv_count }|.
    ELSE.
      MESSAGE |AR Cleared Items extracted: { lv_count }| TYPE 'S'.
    ENDIF.

  ENDMETHOD.

  METHOD build_bp_mapping.

    " Build BP mapping from BUT000 (Business Partner master)
    " Vendor → BP (via CVI: table CVI_VEND_LINK or BUT000 + BU_ID_NUMBER)
    IF mv_ap = abap_true.
      SELECT vendor AS legacy_id,
             partner AS bp_number
        FROM cvi_vend_link
        INTO TABLE @DATA(lt_vend_bp)
        WHERE vendor IN @mt_lifnr.

      LOOP AT lt_vend_bp ASSIGNING FIELD-SYMBOL(<vbp>).
        APPEND VALUE ty_bp_map(
          legacy_id = <vbp>-legacy_id
          bp_number = <vbp>-bp_number
          bp_type   = 'VN'
        ) TO mt_bp_mapping.
      ENDLOOP.
    ENDIF.

    " Customer → BP (via CVI: table CVI_CUST_LINK)
    IF mv_ar = abap_true.
      SELECT customer AS legacy_id,
             partner AS bp_number
        FROM cvi_cust_link
        INTO TABLE @DATA(lt_cust_bp)
        WHERE customer IN @mt_kunnr.

      LOOP AT lt_cust_bp ASSIGNING FIELD-SYMBOL(<cbp>).
        APPEND VALUE ty_bp_map(
          legacy_id = <cbp>-legacy_id
          bp_number = <cbp>-bp_number
          bp_type   = 'CU'
        ) TO mt_bp_mapping.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD export_csv_ap.

    DATA lt_csv TYPE string_table.
    DATA(lv_sep) = ';'.

    " Header
    APPEND |BUKRS{ lv_sep }BELNR{ lv_sep }GJAHR{ lv_sep }BUZEI{ lv_sep }|
        && |LIFNR{ lv_sep }BLART{ lv_sep }BLDAT{ lv_sep }BUDAT{ lv_sep }MONAT{ lv_sep }|
        && |WAERS{ lv_sep }DMBTR{ lv_sep }WRBTR{ lv_sep }MWSKZ{ lv_sep }|
        && |KOSTL{ lv_sep }PRCTR{ lv_sep }SEGMENT{ lv_sep }|
        && |ZUONR{ lv_sep }SGTXT{ lv_sep }ZFBDT{ lv_sep }ZTERM{ lv_sep }ZLSPR{ lv_sep }|
        && |HKONT{ lv_sep }BSCHL{ lv_sep }SHKZG{ lv_sep }UMSKZ{ lv_sep }XBLNR{ lv_sep }|
        && |SAKNR{ lv_sep }GSBER{ lv_sep }FKBER{ lv_sep }|
        && |AUGBL{ lv_sep }AUGDT{ lv_sep }STATUS|
      TO lt_csv.

    LOOP AT it_data ASSIGNING FIELD-SYMBOL(<d>).
      APPEND |{ <d>-bukrs }{ lv_sep }{ <d>-belnr }{ lv_sep }{ <d>-gjahr }{ lv_sep }{ <d>-buzei }{ lv_sep }|
          && |{ <d>-lifnr }{ lv_sep }{ <d>-blart }{ lv_sep }{ <d>-bldat }{ lv_sep }{ <d>-budat }{ lv_sep }{ <d>-monat }{ lv_sep }|
          && |{ <d>-waers }{ lv_sep }{ <d>-dmbtr DECIMALS = 2 }{ lv_sep }{ <d>-wrbtr DECIMALS = 2 }{ lv_sep }{ <d>-mwskz }{ lv_sep }|
          && |{ <d>-kostl }{ lv_sep }{ <d>-prctr }{ lv_sep }{ <d>-segment }{ lv_sep }|
          && |{ <d>-zuonr }{ lv_sep }{ <d>-sgtxt }{ lv_sep }{ <d>-zfbdt }{ lv_sep }{ <d>-zterm }{ lv_sep }{ <d>-zlspr }{ lv_sep }|
          && |{ <d>-hkont }{ lv_sep }{ <d>-bschl }{ lv_sep }{ <d>-shkzg }{ lv_sep }{ <d>-umskz }{ lv_sep }{ <d>-xblnr }{ lv_sep }|
          && |{ <d>-saknr }{ lv_sep }{ <d>-gsber }{ lv_sep }{ <d>-fkber }{ lv_sep }|
          && |{ <d>-augbl }{ lv_sep }{ <d>-augdt }{ lv_sep }{ <d>-status }|
        TO lt_csv.
    ENDLOOP.

    TRY.
        IF is_background( ).
          DATA(lv_path) = |{ mv_srvpath }/{ iv_filename }|.
          OPEN DATASET lv_path FOR OUTPUT IN TEXT MODE ENCODING UTF-8.
          LOOP AT lt_csv ASSIGNING FIELD-SYMBOL(<line>).
            TRANSFER <line> TO lv_path.
          ENDLOOP.
          CLOSE DATASET lv_path.
          WRITE: / |AP file exported: { lv_path }|.
        ELSE.
          cl_gui_frontend_services=>gui_download(
            EXPORTING filename = iv_filename filetype = 'ASC'
            CHANGING  data_tab = lt_csv ).
        ENDIF.
      CATCH cx_root INTO DATA(lx).
        IF is_background( ).
          WRITE: / |Export error: { lx->get_text( ) }|.
        ELSE.
          MESSAGE |Export error: { lx->get_text( ) }| TYPE 'E'.
        ENDIF.
    ENDTRY.

  ENDMETHOD.

  METHOD export_csv_ar.

    DATA lt_csv TYPE string_table.
    DATA(lv_sep) = ';'.

    APPEND |BUKRS{ lv_sep }BELNR{ lv_sep }GJAHR{ lv_sep }BUZEI{ lv_sep }|
        && |KUNNR{ lv_sep }BLART{ lv_sep }BLDAT{ lv_sep }BUDAT{ lv_sep }MONAT{ lv_sep }|
        && |WAERS{ lv_sep }DMBTR{ lv_sep }WRBTR{ lv_sep }MWSKZ{ lv_sep }|
        && |KOSTL{ lv_sep }PRCTR{ lv_sep }SEGMENT{ lv_sep }|
        && |ZUONR{ lv_sep }SGTXT{ lv_sep }ZFBDT{ lv_sep }ZTERM{ lv_sep }|
        && |HKONT{ lv_sep }BSCHL{ lv_sep }SHKZG{ lv_sep }UMSKZ{ lv_sep }XBLNR{ lv_sep }|
        && |SAKNR{ lv_sep }GSBER{ lv_sep }FKBER{ lv_sep }|
        && |MANST{ lv_sep }MADAT{ lv_sep }MABER{ lv_sep }|
        && |AUGBL{ lv_sep }AUGDT{ lv_sep }STATUS|
      TO lt_csv.

    LOOP AT it_data ASSIGNING FIELD-SYMBOL(<d>).
      APPEND |{ <d>-bukrs }{ lv_sep }{ <d>-belnr }{ lv_sep }{ <d>-gjahr }{ lv_sep }{ <d>-buzei }{ lv_sep }|
          && |{ <d>-kunnr }{ lv_sep }{ <d>-blart }{ lv_sep }{ <d>-bldat }{ lv_sep }{ <d>-budat }{ lv_sep }{ <d>-monat }{ lv_sep }|
          && |{ <d>-waers }{ lv_sep }{ <d>-dmbtr DECIMALS = 2 }{ lv_sep }{ <d>-wrbtr DECIMALS = 2 }{ lv_sep }{ <d>-mwskz }{ lv_sep }|
          && |{ <d>-kostl }{ lv_sep }{ <d>-prctr }{ lv_sep }{ <d>-segment }{ lv_sep }|
          && |{ <d>-zuonr }{ lv_sep }{ <d>-sgtxt }{ lv_sep }{ <d>-zfbdt }{ lv_sep }{ <d>-zterm }{ lv_sep }|
          && |{ <d>-hkont }{ lv_sep }{ <d>-bschl }{ lv_sep }{ <d>-shkzg }{ lv_sep }{ <d>-umskz }{ lv_sep }{ <d>-xblnr }{ lv_sep }|
          && |{ <d>-saknr }{ lv_sep }{ <d>-gsber }{ lv_sep }{ <d>-fkber }{ lv_sep }|
          && |{ <d>-manst }{ lv_sep }{ <d>-madat }{ lv_sep }{ <d>-maber }{ lv_sep }|
          && |{ <d>-augbl }{ lv_sep }{ <d>-augdt }{ lv_sep }{ <d>-status }|
        TO lt_csv.
    ENDLOOP.

    TRY.
        IF is_background( ).
          DATA(lv_path) = |{ mv_srvpath }/{ iv_filename }|.
          OPEN DATASET lv_path FOR OUTPUT IN TEXT MODE ENCODING UTF-8.
          LOOP AT lt_csv ASSIGNING FIELD-SYMBOL(<line>).
            TRANSFER <line> TO lv_path.
          ENDLOOP.
          CLOSE DATASET lv_path.
          WRITE: / |AR file exported: { lv_path }|.
        ELSE.
          cl_gui_frontend_services=>gui_download(
            EXPORTING filename = iv_filename filetype = 'ASC'
            CHANGING  data_tab = lt_csv ).
        ENDIF.
      CATCH cx_root INTO DATA(lx).
        IF is_background( ).
          WRITE: / |Export error: { lx->get_text( ) }|.
        ELSE.
          MESSAGE |Export error: { lx->get_text( ) }| TYPE 'E'.
        ENDIF.
    ENDTRY.

  ENDMETHOD.

  METHOD export_csv_bp.

    DATA lt_csv TYPE string_table.
    DATA(lv_sep) = ';'.

    APPEND |LEGACY_ID{ lv_sep }BP_NUMBER{ lv_sep }BP_TYPE| TO lt_csv.

    LOOP AT mt_bp_mapping ASSIGNING FIELD-SYMBOL(<bp>).
      APPEND |{ <bp>-legacy_id }{ lv_sep }{ <bp>-bp_number }{ lv_sep }{ <bp>-bp_type }|
        TO lt_csv.
    ENDLOOP.

    TRY.
        IF is_background( ).
          DATA(lv_path) = |{ mv_srvpath }/{ mv_file_bp }|.
          OPEN DATASET lv_path FOR OUTPUT IN TEXT MODE ENCODING UTF-8.
          LOOP AT lt_csv ASSIGNING FIELD-SYMBOL(<line>).
            TRANSFER <line> TO lv_path.
          ENDLOOP.
          CLOSE DATASET lv_path.
          WRITE: / |BP Mapping exported: { lv_path }|.
        ELSE.
          cl_gui_frontend_services=>gui_download(
            EXPORTING filename = mv_file_bp filetype = 'ASC'
            CHANGING  data_tab = lt_csv ).
        ENDIF.
      CATCH cx_root INTO DATA(lx).
        IF is_background( ).
          WRITE: / |Export error: { lx->get_text( ) }|.
        ELSE.
          MESSAGE |Export error: { lx->get_text( ) }| TYPE 'E'.
        ENDIF.
    ENDTRY.

  ENDMETHOD.

  METHOD display_summary.
    WRITE: / '============================================================'.
    WRITE: / 'AP/AR Historical Data Extraction — Summary'.
    WRITE: / '============================================================'.
    WRITE: / |AP Open Items     : { lines( mt_ap_open ) }|.
    WRITE: / |AP Cleared Items  : { lines( mt_ap_cleared ) }|.
    WRITE: / |AR Open Items     : { lines( mt_ar_open ) }|.
    WRITE: / |AR Cleared Items  : { lines( mt_ar_cleared ) }|.
    WRITE: / |BP Mappings       : { lines( mt_bp_mapping ) }|.
    WRITE: / '============================================================'.
    WRITE: / |Execution date    : { sy-datum DATE = USER }|.
    WRITE: / |Execution time    : { sy-uzeit TIME = USER }|.
    WRITE: / |User              : { sy-uname }|.
    WRITE: / '============================================================'.
  ENDMETHOD.

  METHOD get_ap_open.    rt_data = mt_ap_open. ENDMETHOD.
  METHOD get_ap_cleared. rt_data = mt_ap_cleared. ENDMETHOD.
  METHOD get_ar_open.    rt_data = mt_ar_open. ENDMETHOD.
  METHOD get_ar_cleared. rt_data = mt_ar_cleared. ENDMETHOD.
  METHOD get_bp_mapping. rt_data = mt_bp_mapping. ENDMETHOD.

ENDCLASS.

*----------------------------------------------------------------------*
* Selection Screen
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS: s_bukrs FOR bsik-bukrs OBLIGATORY,
                  s_gjahr FOR bsik-gjahr OBLIGATORY,
                  s_lifnr FOR bsik-lifnr,
                  s_kunnr FOR bsid-kunnr.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-b02.
  PARAMETERS: p_ap   AS CHECKBOX DEFAULT 'X',
              p_ar   AS CHECKBOX DEFAULT 'X',
              p_open AS CHECKBOX DEFAULT 'X',
              p_clrd AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-b03.
  PARAMETERS: p_flap  TYPE string DEFAULT 'AP_HIST_ITEMS.csv' LOWER CASE,
              p_flar  TYPE string DEFAULT 'AR_HIST_ITEMS.csv' LOWER CASE,
              p_flbp  TYPE string DEFAULT 'BP_MAPPING.csv' LOWER CASE,
              p_srv   TYPE string DEFAULT '/tmp/fi_hist/' LOWER CASE.
SELECTION-SCREEN END OF BLOCK b3.

*----------------------------------------------------------------------*
* Main
*----------------------------------------------------------------------*
START-OF-SELECTION.

  DATA(lo_extractor) = NEW lcl_ap_ar_extractor(
    ir_bukrs   = s_bukrs[]
    ir_gjahr   = s_gjahr[]
    ir_lifnr   = s_lifnr[]
    ir_kunnr   = s_kunnr[]
    iv_ap      = p_ap
    iv_ar      = p_ar
    iv_open    = p_open
    iv_cleared = p_clrd
    iv_file_ap = p_flap
    iv_file_ar = p_flar
    iv_file_bp = p_flbp
    iv_srvpath = p_srv ).

  lo_extractor->execute( ).
