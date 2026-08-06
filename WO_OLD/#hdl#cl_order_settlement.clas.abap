"! <p class="shorttext synchronized">Mass-create default settlement rule for PM orders</p>
"! Looks up the cost center from the order's installation site (ILOA-KOSTL)
"! and, when missing, falls back to the equipment master / functional
"! location. Creates a single-receiver PER 100 % settlement rule using
"! BAPI_ALM_ORDER_MAINTAIN via the injected BAPI facade.
CLASS /hdl/cl_order_settlement DEFINITION
  PUBLIC
  CREATE PUBLIC
  FINAL.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_order,
             aufnr TYPE aufk-aufnr,
             auart TYPE aufk-auart,
             equnr TYPE iloa-equnr,
             tplnr TYPE iloa-tplnr,
             kostl TYPE kostl,
           END OF ty_order.
    TYPES ty_orders TYPE STANDARD TABLE OF ty_order WITH EMPTY KEY.

    TYPES: BEGIN OF ty_result,
             aufnr   TYPE aufk-aufnr,
             auart   TYPE aufk-auart,
             kostl   TYPE kostl,
             result  TYPE c LENGTH 10,
             message TYPE string,
           END OF ty_result.
    TYPES ty_results TYPE STANDARD TABLE OF ty_result WITH EMPTY KEY.

    TYPES ty_aufnr_range  TYPE RANGE OF aufnr.

    CONSTANTS:
      c_result_ok      TYPE c LENGTH 10 VALUE 'SUCCESS',
      c_result_ko      TYPE c LENGTH 10 VALUE 'ERROR',
      c_result_skipped TYPE c LENGTH 10 VALUE 'SKIPPED'.

    METHODS constructor
      IMPORTING io_bapi TYPE REF TO /hdl/if_alm_order_bapi OPTIONAL.

    METHODS run
      IMPORTING it_aufnr_range TYPE ty_aufnr_range
                iv_test_mode   TYPE abap_bool DEFAULT abap_true.

    "------------------------------------------------------------------
    " Public for unit testing
    "------------------------------------------------------------------
    METHODS process_single
      IMPORTING is_order         TYPE ty_order
      RETURNING VALUE(rs_result) TYPE ty_result.

    METHODS get_results
      RETURNING VALUE(rt_results) TYPE ty_results.

  PRIVATE SECTION.
    DATA mo_bapi    TYPE REF TO /hdl/if_alm_order_bapi.
    DATA mt_orders  TYPE ty_orders.
    DATA mt_results TYPE ty_results.

    METHODS read_orders
      IMPORTING it_aufnr_range TYPE ty_aufnr_range.

    METHODS filter_orders_with_srule.

    METHODS display_alv.

ENDCLASS.


CLASS /hdl/cl_order_settlement IMPLEMENTATION.

  METHOD constructor.
    mo_bapi = COND #( WHEN io_bapi IS BOUND THEN io_bapi
                      ELSE NEW /hdl/cl_alm_order_bapi( ) ).
  ENDMETHOD.

  METHOD run.
    read_orders( it_aufnr_range ).

    IF mt_orders IS INITIAL.
      WRITE: / 'No maintenance orders found for selection.'.
      RETURN.
    ENDIF.

    filter_orders_with_srule( ).

    LOOP AT mt_orders INTO DATA(ls_order).
      DATA ls_res TYPE ty_result.

      IF iv_test_mode = abap_true.
        ls_res-aufnr   = ls_order-aufnr.
        ls_res-auart   = ls_order-auart.
        ls_res-kostl   = ls_order-kostl.
        ls_res-result  = c_result_ok.
        ls_res-message = COND #(
          WHEN ls_order-kostl IS INITIAL
            THEN 'TEST: cost center missing - would be skipped.'
          ELSE |TEST: would create settlement rule with cost center { ls_order-kostl }| ).
      ELSE.
        ls_res = process_single( ls_order ).
      ENDIF.

      APPEND ls_res TO mt_results.
    ENDLOOP.

    display_alv( ).
  ENDMETHOD.

  METHOD read_orders.
    " Reads orders together with the cost center already maintained
    " on the installation site (ILOA), the equipment master or the
    " functional location.
    SELECT k~aufnr,
           k~auart,
           l~equnr,
           l~tplnr,
           COALESCE( l~kostl, e~kostl, f~kostl ) AS kostl
      FROM aufk AS k
      INNER JOIN afih AS h
        ON h~aufnr = k~aufnr
      LEFT OUTER JOIN iloa  AS l ON l~iloan = h~iloan
      LEFT OUTER JOIN equi  AS e ON e~equnr = l~equnr
      LEFT OUTER JOIN iflot AS f ON f~tplnr = l~tplnr
      WHERE k~aufnr IN @it_aufnr_range
        AND k~autyp = '30'   " PM order
      INTO TABLE @mt_orders.
  ENDMETHOD.

  METHOD filter_orders_with_srule.
    " Skip orders that already have a settlement rule (header rule in COBRB).
    DATA lt_filtered TYPE ty_orders.

    IF mt_orders IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lt_objnr) = VALUE STANDARD TABLE OF j_objnr WITH EMPTY KEY (
                       FOR ls IN mt_orders ( |OR{ ls-aufnr }| ) ).

    SELECT objnr
      FROM cobrb
      FOR ALL ENTRIES IN @lt_objnr
      WHERE objnr = @lt_objnr-table_line
      INTO TABLE @DATA(lt_existing).

    LOOP AT mt_orders INTO DATA(ls_order).
      DATA(lv_objnr) = |OR{ ls_order-aufnr }|.
      IF line_exists( lt_existing[ table_line = lv_objnr ] ).
        APPEND VALUE ty_result(
          aufnr   = ls_order-aufnr
          auart   = ls_order-auart
          kostl   = ls_order-kostl
          result  = c_result_skipped
          message = 'Order already has a settlement rule.' ) TO mt_results.
      ELSE.
        APPEND ls_order TO lt_filtered.
      ENDIF.
    ENDLOOP.

    mt_orders = lt_filtered.
  ENDMETHOD.

  METHOD process_single.
    rs_result-aufnr = is_order-aufnr.
    rs_result-auart = is_order-auart.
    rs_result-kostl = is_order-kostl.

    IF is_order-kostl IS INITIAL.
      rs_result-result  = c_result_ko.
      rs_result-message = 'Cost center not found on ILOA / Equipment / Functional Location.'.
      RETURN.
    ENDIF.

    DATA(ls_bapi) = mo_bapi->maintain_settlement_rule(
                      iv_orderid = is_order-aufnr
                      iv_kostl   = is_order-kostl ).

    IF ls_bapi-success = abap_false.
      mo_bapi->rollback( ).
      rs_result-result  = c_result_ko.
      rs_result-message = |BAPI_ALM_ORDER_MAINTAIN failed: { concat_lines_of( table = ls_bapi-messages sep = ` | ` ) }|.
      RETURN.
    ENDIF.

    mo_bapi->commit( ).
    rs_result-result  = c_result_ok.
    rs_result-message = |Settlement rule created: CTR { is_order-kostl } / 100 % / PER|.
  ENDMETHOD.

  METHOD display_alv.
    DATA lo_alv TYPE REF TO cl_salv_table.
    TRY.
        cl_salv_table=>factory(
          IMPORTING r_salv_table = lo_alv
          CHANGING  t_table      = mt_results ).
        lo_alv->get_display_settings( )->set_striped_pattern( abap_true ).
        lo_alv->get_functions( )->set_all( abap_true ).
        lo_alv->get_columns( )->set_optimize( abap_true ).
        lo_alv->display( ).
      CATCH cx_salv_msg.
        LOOP AT mt_results INTO DATA(ls).
          WRITE: / ls-aufnr, ls-auart, ls-kostl, ls-result, ls-message.
        ENDLOOP.
    ENDTRY.
  ENDMETHOD.

  METHOD get_results.
    rt_results = mt_results.
  ENDMETHOD.

ENDCLASS.
