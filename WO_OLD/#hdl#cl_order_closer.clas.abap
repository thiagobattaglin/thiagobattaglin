"! <p class="shorttext synchronized">Mass-close PM maintenance orders (TECO + CLSD)</p>
"! Entry point: RUN.
"! Pure helpers (apply_status_filter, validate_eligibility,
"! close_single_order, get_results) are exposed for unit testing.
"! The BAPI facade is injected via the constructor so tests can
"! replace the real implementation by a test double.
CLASS /hdl/cl_order_closer DEFINITION
  PUBLIC
  CREATE PUBLIC
  FINAL.

  PUBLIC SECTION.

    TYPES ty_objnr     TYPE c LENGTH 22.
    TYPES ty_stat      TYPE c LENGTH 5.
    TYPES ty_objnr_tab TYPE STANDARD TABLE OF ty_objnr WITH EMPTY KEY.

    TYPES: BEGIN OF ty_order,
             aufnr      TYPE aufk-aufnr,
             auart      TYPE aufk-auart,
             iwerk      TYPE aufk-werks,
             tplnr      TYPE iloa-tplnr,
             equnr      TYPE iloa-equnr,
             erdat      TYPE aufk-erdat,
             objnr      TYPE ty_objnr,
             cur_status TYPE string,
           END OF ty_order.
    TYPES ty_orders TYPE STANDARD TABLE OF ty_order WITH EMPTY KEY.

    TYPES: BEGIN OF ty_status,
             objnr TYPE ty_objnr,
             stat  TYPE ty_stat,
             txt30 TYPE tj02t-txt30,
           END OF ty_status.
    TYPES ty_statuses TYPE STANDARD TABLE OF ty_status WITH EMPTY KEY.

    TYPES: BEGIN OF ty_result,
             aufnr      TYPE aufk-aufnr,
             auart      TYPE aufk-auart,
             cur_status TYPE string,
             result     TYPE c LENGTH 10,
             message    TYPE string,
           END OF ty_result.
    TYPES ty_results TYPE STANDARD TABLE OF ty_result WITH EMPTY KEY.

    TYPES: BEGIN OF ty_aufnr_range,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE aufnr,
             high   TYPE aufnr,
           END OF ty_aufnr_range.
    TYPES ty_aufnr_ranges TYPE STANDARD TABLE OF ty_aufnr_range WITH EMPTY KEY.

    CONSTANTS:
      c_stat_teco TYPE ty_stat   VALUE 'I0045',
      c_stat_clsd TYPE ty_stat   VALUE 'I0046',
      c_stat_dlfl TYPE ty_stat   VALUE 'I0076',
      c_result_ok TYPE c LENGTH 10 VALUE 'SUCCESS',
      c_result_ko TYPE c LENGTH 10 VALUE 'ERROR'.

    "! @parameter io_bapi | Optional BAPI facade. Default = real BAPI calls.
    METHODS constructor
      IMPORTING io_bapi TYPE REF TO /hdl/if_alm_order_bapi OPTIONAL.

    METHODS run
      IMPORTING it_aufnr_range TYPE ty_aufnr_ranges
                iv_test_mode   TYPE abap_bool DEFAULT abap_true
                iv_set_dlfl    TYPE abap_bool DEFAULT abap_false.

    "------------------------------------------------------------------
    " Methods below are public to allow direct unit testing.
    "------------------------------------------------------------------
    METHODS apply_status_filter
      IMPORTING it_statuses TYPE ty_statuses
      CHANGING  ct_orders   TYPE ty_orders.

    METHODS validate_eligibility
      IMPORTING it_statuses TYPE ty_statuses
      CHANGING  ct_orders   TYPE ty_orders
                ct_results  TYPE ty_results.

    METHODS close_single_order
      IMPORTING is_order         TYPE ty_order
                iv_set_dlfl      TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(rs_result) TYPE ty_result.

    METHODS get_results
      RETURNING VALUE(rt_results) TYPE ty_results.

  PRIVATE SECTION.
    DATA mo_bapi    TYPE REF TO /hdl/if_alm_order_bapi.
    DATA mt_orders  TYPE ty_orders.
    DATA mt_results TYPE ty_results.
    DATA mv_loghndl TYPE balloghndl.

    METHODS check_authorization RAISING /hdl/cx_order_close.

    METHODS read_orders
      IMPORTING it_aufnr_range TYPE ty_aufnr_ranges.

    METHODS read_statuses
      IMPORTING it_objnr           TYPE ty_objnr_tab
      RETURNING VALUE(rt_statuses) TYPE ty_statuses.

    METHODS process_parallel
      IMPORTING iv_set_dlfl TYPE abap_bool.
    METHODS process_serial
      IMPORTING iv_set_dlfl TYPE abap_bool.
    METHODS process_test_mode.
    METHODS display_alv.

    METHODS get_parallel_task_count
      RETURNING VALUE(rv_tasks) TYPE i.

    METHODS init_log.
    METHODS add_log
      IMPORTING iv_type TYPE symsgty
                iv_text TYPE string.
    METHODS save_log.

ENDCLASS.


CLASS /hdl/cl_order_closer IMPLEMENTATION.

  METHOD constructor.
    mo_bapi = COND #( WHEN io_bapi IS BOUND THEN io_bapi
                      ELSE NEW /hdl/cl_alm_order_bapi( ) ).
  ENDMETHOD.

  METHOD run.
    TRY.
        check_authorization( ).
        init_log( ).

        read_orders( it_aufnr_range ).

        IF mt_orders IS INITIAL.
          WRITE: / 'No maintenance orders found for selection.'.
          add_log( iv_type = 'I' iv_text = 'No orders found for selection.' ).
          save_log( ).
          RETURN.
        ENDIF.

        DATA(lt_objnr) = VALUE ty_objnr_tab(
          FOR ls_order IN mt_orders ( ls_order-objnr ) ).
        DATA(lt_statuses) = read_statuses( lt_objnr ).

        apply_status_filter(
          EXPORTING it_statuses = lt_statuses
          CHANGING  ct_orders   = mt_orders ).

        validate_eligibility(
          EXPORTING it_statuses = lt_statuses
          CHANGING  ct_orders   = mt_orders
                    ct_results  = mt_results ).

        IF mt_orders IS INITIAL.
          add_log( iv_type = 'I' iv_text = 'No eligible orders for CLSD.' ).
          save_log( ).
          display_alv( ).
          RETURN.
        ENDIF.

        IF iv_test_mode = abap_true.
          process_test_mode( ).
        ELSE.
          process_parallel( iv_set_dlfl ).
        ENDIF.

        save_log( ).
        display_alv( ).

      CATCH /hdl/cx_order_close INTO DATA(lx_error).
        WRITE: / lx_error->message.
        add_log( iv_type = 'E' iv_text = lx_error->message ).
        save_log( ).
    ENDTRY.
  ENDMETHOD.

  METHOD check_authorization.
    AUTHORITY-CHECK OBJECT 'S_TCODE'
      ID 'TCD' FIELD 'IW32'.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW /hdl/cx_order_close(
        iv_message = 'Missing authorization for transaction IW32.' ).
    ENDIF.
  ENDMETHOD.

  METHOD read_orders.
    SELECT k~aufnr,
           k~auart,
           k~werks AS iwerk,
           l~tplnr,
           l~equnr,
           k~erdat,
           k~objnr
      FROM aufk AS k
      INNER JOIN afih AS h
        ON h~aufnr = k~aufnr
      LEFT OUTER JOIN iloa AS l
        ON l~iloan = h~iloan
      WHERE k~aufnr IN @it_aufnr_range
      INTO TABLE @mt_orders.
  ENDMETHOD.

  METHOD read_statuses.
    IF it_objnr IS INITIAL.
      RETURN.
    ENDIF.

    SELECT j~objnr,
           j~stat,
           t~txt30
      FROM jest AS j
      INNER JOIN tj02t AS t
        ON t~istat = j~stat
       AND t~spras = @sy-langu
      FOR ALL ENTRIES IN @it_objnr
      WHERE j~objnr = @it_objnr-table_line
        AND j~inact = @abap_false
      INTO TABLE @rt_statuses.
  ENDMETHOD.

  METHOD apply_status_filter.
    " Removes orders that are already CLSD and computes the
    " concatenated status text for display.
    DATA lt_filtered TYPE ty_orders.

    LOOP AT ct_orders INTO DATA(ls_order).
      DATA(lv_keep)       = abap_true.
      DATA(lv_status_txt) = ``.

      LOOP AT it_statuses INTO DATA(ls_status)
        WHERE objnr = ls_order-objnr.

        lv_status_txt = COND #(
          WHEN lv_status_txt IS INITIAL THEN ls_status-txt30
          ELSE |{ lv_status_txt }, { ls_status-txt30 }| ).

        IF ls_status-stat = c_stat_clsd.
          lv_keep = abap_false.
        ENDIF.
      ENDLOOP.

      ls_order-cur_status = lv_status_txt.

      IF lv_keep = abap_true.
        APPEND ls_order TO lt_filtered.
      ELSE.
        APPEND VALUE ty_result(
          aufnr      = ls_order-aufnr
          auart      = ls_order-auart
          cur_status = ls_order-cur_status
          result     = c_result_ko
          message    = 'Order already has status CLSD.' ) TO mt_results.
      ENDIF.
    ENDLOOP.

    ct_orders = lt_filtered.
  ENDMETHOD.

  METHOD validate_eligibility.
    DATA lt_valid TYPE ty_orders.

    LOOP AT ct_orders INTO DATA(ls_order).
      DATA(lv_is_clsd) = abap_false.
      DATA(lv_is_dlfl) = abap_false.

      LOOP AT it_statuses INTO DATA(ls_status)
        WHERE objnr = ls_order-objnr.
        IF ls_status-stat = c_stat_clsd.
          lv_is_clsd = abap_true.
        ELSEIF ls_status-stat = c_stat_dlfl.
          lv_is_dlfl = abap_true.
        ENDIF.
      ENDLOOP.

      IF lv_is_clsd = abap_true.
        APPEND VALUE ty_result(
          aufnr      = ls_order-aufnr
          auart      = ls_order-auart
          cur_status = ls_order-cur_status
          result     = c_result_ko
          message    = 'Order already has status CLSD.' ) TO ct_results.
        add_log( iv_type = 'E' iv_text = |{ ls_order-aufnr }: already CLSD| ).
        CONTINUE.
      ENDIF.

      IF lv_is_dlfl = abap_true.
        APPEND VALUE ty_result(
          aufnr      = ls_order-aufnr
          auart      = ls_order-auart
          cur_status = ls_order-cur_status
          result     = c_result_ko
          message    = 'Order has deletion flag and cannot be closed.' ) TO ct_results.
        add_log( iv_type = 'E' iv_text = |{ ls_order-aufnr }: deletion flag set| ).
        CONTINUE.
      ENDIF.

      APPEND ls_order TO lt_valid.
    ENDLOOP.

    ct_orders = lt_valid.
  ENDMETHOD.

  METHOD close_single_order.
    rs_result-aufnr      = is_order-aufnr.
    rs_result-auart      = is_order-auart.
    rs_result-cur_status = is_order-cur_status.

    DATA(ls_teco) = mo_bapi->set_teco( is_order-aufnr ).
    IF ls_teco-success = abap_false.
      mo_bapi->rollback( ).
      rs_result-result  = c_result_ko.
      rs_result-message = |TECO failed: { concat_lines_of( table = ls_teco-messages sep = ` | ` ) }|.
      RETURN.
    ENDIF.

    DATA(ls_clsd) = mo_bapi->set_clsd( is_order-aufnr ).
    IF ls_clsd-success = abap_false.
      mo_bapi->rollback( ).
      rs_result-result  = c_result_ko.
      rs_result-message = |CLSD failed: { concat_lines_of( table = ls_clsd-messages sep = ` | ` ) }|.
      RETURN.
    ENDIF.

    IF iv_set_dlfl = abap_true.
      DATA(ls_dlfl) = mo_bapi->set_dlfl( is_order-aufnr ).
      IF ls_dlfl-success = abap_false.
        mo_bapi->rollback( ).
        rs_result-result  = c_result_ko.
        rs_result-message = |DLFL failed: { concat_lines_of( table = ls_dlfl-messages sep = ` | ` ) }|.
        RETURN.
      ENDIF.
    ENDIF.

    mo_bapi->commit( ).
    rs_result-result  = c_result_ok.
    rs_result-message = COND #(
      WHEN iv_set_dlfl = abap_true
        THEN |Order { is_order-aufnr } set to TECO, CLSD and DLFL successfully|
      ELSE |Order { is_order-aufnr } set to TECO and CLSD successfully| ).
  ENDMETHOD.

  METHOD process_serial.
    LOOP AT mt_orders INTO DATA(ls_order).
      DATA(ls_res) = close_single_order(
                       is_order    = ls_order
                       iv_set_dlfl = iv_set_dlfl ).
      APPEND ls_res TO mt_results.
      add_log(
        iv_type = COND #( WHEN ls_res-result = c_result_ok THEN 'S' ELSE 'E' )
        iv_text = |{ ls_res-aufnr }: { ls_res-message }| ).
    ENDLOOP.
  ENDMETHOD.

  METHOD process_test_mode.
    LOOP AT mt_orders INTO DATA(ls_order).
      APPEND VALUE ty_result(
        aufnr      = ls_order-aufnr
        auart      = ls_order-auart
        cur_status = ls_order-cur_status
        result     = c_result_ok
        message    = 'TEST MODE: order would be processed for TECO and CLSD.' ) TO mt_results.
      add_log( iv_type = 'I' iv_text = |TEST { ls_order-aufnr }: would set TECO and close| ).
    ENDLOOP.
  ENDMETHOD.

  METHOD process_parallel.
    DATA(lv_tasks)    = get_parallel_task_count( ).
    DATA(lo_parallel) = NEW cl_abap_parallel( p_num_tasks = lv_tasks ).
    DATA lt_input  TYPE cl_abap_parallel=>t_in_inst_tab.
    DATA lt_output TYPE cl_abap_parallel=>t_out_inst_tab.

    LOOP AT mt_orders INTO DATA(ls_order).
      DATA(lo_worker) = NEW /hdl/cl_order_close_worker( ).
      lo_worker->aufnr      = ls_order-aufnr.
      lo_worker->auart      = ls_order-auart.
      lo_worker->cur_status = ls_order-cur_status.
      lo_worker->set_dlfl   = iv_set_dlfl.
      APPEND CAST if_abap_parallel( lo_worker ) TO lt_input.
    ENDLOOP.

    lo_parallel->run_inst(
      EXPORTING p_in_tab  = lt_input
      IMPORTING p_out_tab = lt_output ).

    LOOP AT lt_output INTO DATA(ls_output).
      DATA(lo_result) = CAST /hdl/cl_order_close_worker( ls_output-inst ).
      APPEND VALUE ty_result(
        aufnr      = lo_result->aufnr
        auart      = lo_result->auart
        cur_status = lo_result->cur_status
        result     = COND #( WHEN lo_result->success = abap_true
                               THEN c_result_ok
                             ELSE c_result_ko )
        message    = lo_result->message ) TO mt_results.

      add_log(
        iv_type = COND #( WHEN lo_result->success = abap_true THEN 'S' ELSE 'E' )
        iv_text = |{ lo_result->aufnr }: { lo_result->message }| ).
    ENDLOOP.
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
        LOOP AT mt_results INTO DATA(ls_result).
          WRITE: / ls_result-aufnr,
                   ls_result-auart,
                   ls_result-cur_status,
                   ls_result-result,
                   ls_result-message.
        ENDLOOP.
    ENDTRY.
  ENDMETHOD.

  METHOD get_parallel_task_count.
    DATA lv_btc_param TYPE char128.

    CALL FUNCTION 'TH_GET_PARAMETER'
      EXPORTING  parameter_name  = 'rdisp/wp_no_btc'
      IMPORTING  parameter_value = lv_btc_param
      EXCEPTIONS OTHERS          = 1.

    IF sy-subrc = 0 AND lv_btc_param IS NOT INITIAL.
      rv_tasks = floor( CONV i( lv_btc_param ) * 60 / 100 ).
    ENDIF.

    IF rv_tasks < 1.
      rv_tasks = 1.
    ENDIF.
  ENDMETHOD.

  METHOD init_log.
    DATA ls_log TYPE bal_s_log.
    ls_log-object    = 'PM'.
    ls_log-subobject = 'ORDER'.
    ls_log-alprog    = sy-repid.
    ls_log-aluser    = sy-uname.
    ls_log-aldate    = sy-datum.
    ls_log-altime    = sy-uzeit.
    ls_log-extnumber = |{ sy-repid }/{ sy-datum }/{ sy-uzeit }|.

    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING  i_s_log      = ls_log
      IMPORTING  e_log_handle = mv_loghndl
      EXCEPTIONS OTHERS       = 1.
  ENDMETHOD.

  METHOD add_log.
    CHECK mv_loghndl IS NOT INITIAL.
    DATA ls_msg TYPE bal_s_msg.
    ls_msg-msgty = iv_type.
    ls_msg-msgid = '00'.
    ls_msg-msgno = '398'.
    ls_msg-msgv1 = substring( val = iv_text
                              off = 0
                              len = COND #( WHEN strlen( iv_text ) > 50 THEN 50
                                            ELSE strlen( iv_text ) ) ).
    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING  i_log_handle = mv_loghndl
                 i_s_msg      = ls_msg
      EXCEPTIONS OTHERS       = 1.
  ENDMETHOD.

  METHOD save_log.
    CHECK mv_loghndl IS NOT INITIAL.
    DATA lt_logh TYPE bal_t_logh.
    APPEND mv_loghndl TO lt_logh.
    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING  i_t_log_handle = lt_logh
      EXCEPTIONS OTHERS         = 1.
  ENDMETHOD.

  METHOD get_results.
    rt_results = mt_results.
  ENDMETHOD.

ENDCLASS.
