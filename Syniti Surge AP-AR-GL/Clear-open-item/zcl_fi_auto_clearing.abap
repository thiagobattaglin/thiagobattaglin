"! <p class="shorttext synchronized">Automatic Clearing for AP Open Items</p>
"! Clean Core compliant solution for automatic clearing of vendor open items.
"! Replaces manual execution of transaction F.13 (program SAPF124).
"! Designed for high-volume processing with packet-based execution.
CLASS zcl_fi_auto_clearing DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_clearing_params,
        bukrs     TYPE bukrs,
        lifnr_low TYPE lifnr,
        lifnr_high TYPE lifnr,
        budat     TYPE budat,
        packet_size TYPE i,
      END OF ty_clearing_params,

      BEGIN OF ty_clearing_result,
        lifnr       TYPE lifnr,
        bukrs       TYPE bukrs,
        clrng_doc   TYPE belnr_d,
        fiscal_year TYPE gjahr,
        success     TYPE abap_bool,
        message     TYPE bapi_msg,
      END OF ty_clearing_result,

      ty_clearing_results TYPE STANDARD TABLE OF ty_clearing_result WITH EMPTY KEY.

    METHODS constructor
      IMPORTING
        is_params TYPE ty_clearing_params.

    METHODS execute
      RETURNING
        VALUE(rt_results) TYPE ty_clearing_results.

  PRIVATE SECTION.

    DATA ms_params TYPE ty_clearing_params.

    TYPES:
      BEGIN OF ty_open_item,
        bukrs TYPE bukrs,
        lifnr TYPE lifnr,
        belnr TYPE belnr_d,
        gjahr TYPE gjahr,
        buzei TYPE buzei,
        dmbtr TYPE dmbtr,
        shkzg TYPE shkzg,
        zuonr TYPE dzuonr,
        bschl TYPE bschl,
        augdt TYPE augdt,
      END OF ty_open_item,

      ty_open_items TYPE STANDARD TABLE OF ty_open_item WITH EMPTY KEY.

    METHODS select_open_items
      RETURNING
        VALUE(rt_items) TYPE ty_open_items.

    METHODS group_items_for_clearing
      IMPORTING
        it_items         TYPE ty_open_items
      RETURNING
        VALUE(rt_groups) TYPE STANDARD TABLE OF ty_open_items WITH EMPTY KEY.

    METHODS clear_group
      IMPORTING
        it_group        TYPE ty_open_items
      RETURNING
        VALUE(rs_result) TYPE ty_clearing_result.

ENDCLASS.


CLASS zcl_fi_auto_clearing IMPLEMENTATION.

  METHOD constructor.
    ms_params = is_params.
    IF ms_params-packet_size IS INITIAL.
      ms_params-packet_size = 1000.
    ENDIF.
  ENDMETHOD.


  METHOD execute.
    DATA(lt_open_items) = select_open_items( ).

    IF lt_open_items IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lt_groups) = group_items_for_clearing( lt_open_items ).

    LOOP AT lt_groups INTO DATA(lt_group).
      DATA(ls_result) = clear_group( lt_group ).
      APPEND ls_result TO rt_results.
    ENDLOOP.
  ENDMETHOD.


  METHOD select_open_items.
    "! Select open items from vendor subledger (BSIK in ECC / ACDOCA in S/4)
    "! Only items not yet cleared (augdt = '00000000')
    SELECT bukrs, lifnr, belnr, gjahr, buzei, dmbtr, shkzg, zuonr, bschl, augdt
      FROM bsik
      WHERE bukrs = @ms_params-bukrs
        AND lifnr BETWEEN @ms_params-lifnr_low AND @ms_params-lifnr_high
        AND augdt = '00000000'
      ORDER BY lifnr, zuonr
      INTO TABLE @rt_items
      UP TO @ms_params-packet_size ROWS.
  ENDMETHOD.


  METHOD group_items_for_clearing.
    "! Group items by vendor + assignment (ZUONR) for clearing
    "! Items in a group must net to zero to be clearable
    DATA lt_group TYPE ty_open_items.
    DATA lv_prev_key TYPE string.

    LOOP AT it_items INTO DATA(ls_item).
      DATA(lv_key) = |{ ls_item-lifnr }{ ls_item-zuonr }|.

      IF lv_prev_key IS NOT INITIAL AND lv_key <> lv_prev_key.
        " Check if group nets to zero
        DATA(lv_balance) = REDUCE dmbtr(
          INIT sum = CONV dmbtr( 0 )
          FOR wa IN lt_group
          NEXT sum = COND #(
            WHEN wa-shkzg = 'S' THEN sum + wa-dmbtr
            ELSE sum - wa-dmbtr ) ).

        IF lv_balance = 0 AND lt_group IS NOT INITIAL.
          APPEND lt_group TO rt_groups.
        ENDIF.
        CLEAR lt_group.
      ENDIF.

      APPEND ls_item TO lt_group.
      lv_prev_key = lv_key.
    ENDLOOP.

    " Process last group
    IF lt_group IS NOT INITIAL.
      lv_balance = REDUCE dmbtr(
        INIT sum = CONV dmbtr( 0 )
        FOR wa IN lt_group
        NEXT sum = COND #(
          WHEN wa-shkzg = 'S' THEN sum + wa-dmbtr
          ELSE sum - wa-dmbtr ) ).

      IF lv_balance = 0.
        APPEND lt_group TO rt_groups.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD clear_group.
    "! Execute clearing via POSTING_INTERFACE_CLEARING (released API)
    DATA lt_ftclear TYPE STANDARD TABLE OF ftclear.
    DATA lt_ftpost  TYPE STANDARD TABLE OF ftpost.
    DATA lt_blntab  TYPE STANDARD TABLE OF blntab.
    DATA lt_fttax   TYPE STANDARD TABLE OF fttax.
    DATA lv_msgid   TYPE symsgid.
    DATA lv_msgno   TYPE symsgno.
    DATA lv_msgty   TYPE symsgty.
    DATA lt_return  TYPE STANDARD TABLE OF bapiret2.

    DATA(ls_first) = it_group[ 1 ].
    rs_result-lifnr = ls_first-lifnr.
    rs_result-bukrs = ls_first-bukrs.

    " Header data for clearing
    APPEND VALUE ftpost(
      session = '0001'
      count   = '001'
      fnam    = 'BKPF-BUKRS'
      fval    = ls_first-bukrs ) TO lt_ftpost.

    APPEND VALUE ftpost(
      session = '0001'
      count   = '001'
      fnam    = 'BKPF-BLDAT'
      fval    = ms_params-budat ) TO lt_ftpost.

    APPEND VALUE ftpost(
      session = '0001'
      count   = '001'
      fnam    = 'BKPF-BUDAT'
      fval    = ms_params-budat ) TO lt_ftpost.

    APPEND VALUE ftpost(
      session = '0001'
      count   = '001'
      fnam    = 'BKPF-BLART'
      fval    = 'AB' ) TO lt_ftpost.

    " Account info
    APPEND VALUE ftpost(
      session = '0001'
      count   = '001'
      fnam    = 'RF05A-AGKON'
      fval    = ls_first-lifnr ) TO lt_ftpost.

    APPEND VALUE ftpost(
      session = '0001'
      count   = '001'
      fnam    = 'RF05A-AGKOA'
      fval    = 'K' ) TO lt_ftpost.  " K = Vendor

    APPEND VALUE ftpost(
      session = '0001'
      count   = '001'
      fnam    = 'RF05A-XNOPS'
      fval    = 'X' ) TO lt_ftpost.  " Without special G/L

    " Items to clear
    DATA lv_count TYPE n LENGTH 3 VALUE '001'.
    LOOP AT it_group INTO DATA(ls_item).
      lv_count += 1.
      APPEND VALUE ftclear(
        agession = '0001'
        agession = lv_count
        agbeln   = ls_item-belnr
        agbuzei  = ls_item-buzei
        aggjahr  = ls_item-gjahr ) TO lt_ftclear.
    ENDLOOP.

    " Call the released clearing function
    CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
      EXPORTING
        i_auession    = '0001'
        i_tcode       = 'F-44'
        i_sgfunct     = 'C'   " C = Clear
      TABLES
        t_ftpost      = lt_ftpost
        t_ftclear     = lt_ftclear
        t_blntab      = lt_blntab
        t_fttax       = lt_fttax
      EXCEPTIONS
        OTHERS        = 1.

    IF sy-subrc = 0 AND lt_blntab IS NOT INITIAL.
      rs_result-clrng_doc   = lt_blntab[ 1 ]-belnr.
      rs_result-fiscal_year = lt_blntab[ 1 ]-gjahr.
      rs_result-success     = abap_true.
    ELSE.
      rs_result-success = abap_false.
      rs_result-message = |{ sy-msgid } { sy-msgno }: { sy-msgv1 } { sy-msgv2 }|.
    ENDIF.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDMETHOD.

ENDCLASS.
