"! <p class="shorttext synchronized">Mass-complete PM maintenance notifications (NOCO)</p>
"! Entry point: RUN.
"! Pure helpers (apply_status_filter, complete_single) are exposed
"! for unit testing. The BAPI facade is injected via the constructor so
"! tests can replace the real implementation with a test double.
CLASS /hdl/cl_notif_completer DEFINITION
  PUBLIC
  CREATE PUBLIC
  FINAL.

  PUBLIC SECTION.

    TYPES ty_objnr     TYPE c LENGTH 22.
    TYPES ty_stat      TYPE c LENGTH 5.
    TYPES ty_objnr_tab TYPE STANDARD TABLE OF ty_objnr WITH EMPTY KEY.

    TYPES: BEGIN OF ty_notif,
             qmnum      TYPE qmel-qmnum,
             qmart      TYPE qmel-qmart,
             tplnr      TYPE qmel-tplnr,
             equnr      TYPE qmel-equnr,
             erdat      TYPE qmel-erdat,
             objnr      TYPE ty_objnr,
             cur_status TYPE string,
           END OF ty_notif.
    TYPES ty_notifs TYPE STANDARD TABLE OF ty_notif WITH EMPTY KEY.

    TYPES: BEGIN OF ty_status,
             objnr TYPE ty_objnr,
             stat  TYPE ty_stat,
             txt30 TYPE tj02t-txt30,
           END OF ty_status.
    TYPES ty_statuses TYPE STANDARD TABLE OF ty_status WITH EMPTY KEY.

    TYPES: BEGIN OF ty_result,
             qmnum      TYPE qmel-qmnum,
             qmart      TYPE qmel-qmart,
             cur_status TYPE string,
             result     TYPE c LENGTH 10,
             message    TYPE string,
           END OF ty_result.
    TYPES ty_results TYPE STANDARD TABLE OF ty_result WITH EMPTY KEY.

    TYPES: BEGIN OF ty_qmnum_range,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE qmnum,
             high   TYPE qmnum,
           END OF ty_qmnum_range.
    TYPES ty_qmnum_ranges TYPE STANDARD TABLE OF ty_qmnum_range WITH EMPTY KEY.

    CONSTANTS:
      c_stat_noco TYPE ty_stat   VALUE 'I0076',  " Notification completed
      c_stat_dlfl TYPE ty_stat   VALUE 'I0320',  " Deletion flag (notif)
      c_result_ok TYPE c LENGTH 10 VALUE 'SUCCESS',
      c_result_ko TYPE c LENGTH 10 VALUE 'ERROR'.

    METHODS constructor
      IMPORTING io_bapi TYPE REF TO /hdl/if_alm_notif_bapi OPTIONAL.

    METHODS run
      IMPORTING it_qmnum_range TYPE ty_qmnum_ranges
                iv_test_mode   TYPE abap_bool DEFAULT abap_true.

    "------------------------------------------------------------------
    " Public for unit testing
    "------------------------------------------------------------------
    METHODS apply_status_filter
      IMPORTING it_statuses TYPE ty_statuses
      CHANGING  ct_notifs   TYPE ty_notifs
                ct_results  TYPE ty_results.

    METHODS complete_single
      IMPORTING is_notif         TYPE ty_notif
      RETURNING VALUE(rs_result) TYPE ty_result.

    METHODS get_results
      RETURNING VALUE(rt_results) TYPE ty_results.

  PRIVATE SECTION.
    DATA mo_bapi    TYPE REF TO /hdl/if_alm_notif_bapi.
    DATA mt_notifs  TYPE ty_notifs.
    DATA mt_results TYPE ty_results.
    DATA mv_loghndl TYPE balloghndl.

    METHODS check_authorization RAISING /hdl/cx_notif_complete.

    METHODS read_notifs
      IMPORTING it_qmnum_range TYPE ty_qmnum_ranges.

    METHODS read_statuses
      IMPORTING it_objnr           TYPE ty_objnr_tab
      RETURNING VALUE(rt_statuses) TYPE ty_statuses.

    METHODS process_parallel.
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


CLASS /hdl/cl_notif_completer IMPLEMENTATION.

  METHOD constructor.
    mo_bapi = COND #( WHEN io_bapi IS BOUND THEN io_bapi
                      ELSE NEW /hdl/cl_alm_notif_bapi( ) ).
  ENDMETHOD.

  METHOD run.
    TRY.
        check_authorization( ).
        init_log( ).

        read_notifs( it_qmnum_range ).

        IF mt_notifs IS INITIAL.
          WRITE: / 'No maintenance notifications found for selection.'.
          add_log( iv_type = 'I' iv_text = 'No notifications found for selection.' ).
          save_log( ).
          RETURN.
        ENDIF.

        DATA(lt_objnr) = VALUE ty_objnr_tab(
          FOR ls IN mt_notifs ( ls-objnr ) ).
        DATA(lt_statuses) = read_statuses( lt_objnr ).

        apply_status_filter(
          EXPORTING it_statuses = lt_statuses
          CHANGING  ct_notifs   = mt_notifs
                    ct_results  = mt_results ).

        IF mt_notifs IS INITIAL.
          add_log( iv_type = 'I' iv_text = 'No eligible notifications for NOCO.' ).
          save_log( ).
          display_alv( ).
          RETURN.
        ENDIF.

        IF iv_test_mode = abap_true.
          process_test_mode( ).
        ELSE.
          process_parallel( ).
        ENDIF.

        save_log( ).
        display_alv( ).

      CATCH /hdl/cx_notif_complete INTO DATA(lx_error).
        WRITE: / lx_error->message.
        add_log( iv_type = 'E' iv_text = lx_error->message ).
        save_log( ).
    ENDTRY.
  ENDMETHOD.

  METHOD check_authorization.
    AUTHORITY-CHECK OBJECT 'S_TCODE'
      ID 'TCD' FIELD 'IW22'.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW /hdl/cx_notif_complete(
        iv_message = 'Missing authorization for transaction IW22.' ).
    ENDIF.
  ENDMETHOD.

  METHOD read_notifs.
    SELECT qmnum,
           qmart,
           tplnr,
           equnr,
           erdat,
           objnr
      FROM qmel
      WHERE qmnum IN @it_qmnum_range
      INTO TABLE @mt_notifs.
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
    " Removes notifications already NOCO or with deletion flag, builds
    " the concatenated status text for display, and pushes ineligible
    " notifications to the results table as ERROR.
    DATA lt_eligible TYPE ty_notifs.

    LOOP AT ct_notifs INTO DATA(ls_notif).
      DATA(lv_status_txt) = ``.
      DATA(lv_is_noco)    = abap_false.
      DATA(lv_is_dlfl)    = abap_false.

      LOOP AT it_statuses INTO DATA(ls_status)
        WHERE objnr = ls_notif-objnr.

        lv_status_txt = COND #(
          WHEN lv_status_txt IS INITIAL THEN ls_status-txt30
          ELSE |{ lv_status_txt }, { ls_status-txt30 }| ).

        IF ls_status-stat = c_stat_noco.
          lv_is_noco = abap_true.
        ELSEIF ls_status-stat = c_stat_dlfl.
          lv_is_dlfl = abap_true.
        ENDIF.
      ENDLOOP.

      ls_notif-cur_status = lv_status_txt.

      IF lv_is_noco = abap_true.
        APPEND VALUE ty_result(
          qmnum      = ls_notif-qmnum
          qmart      = ls_notif-qmart
          cur_status = ls_notif-cur_status
          result     = c_result_ko
          message    = 'Notification already completed (NOCO).' ) TO ct_results.
        add_log( iv_type = 'E' iv_text = |{ ls_notif-qmnum }: already NOCO| ).
        CONTINUE.
      ENDIF.

      IF lv_is_dlfl = abap_true.
        APPEND VALUE ty_result(
          qmnum      = ls_notif-qmnum
          qmart      = ls_notif-qmart
          cur_status = ls_notif-cur_status
          result     = c_result_ko
          message    = 'Notification has deletion flag.' ) TO ct_results.
        add_log( iv_type = 'E' iv_text = |{ ls_notif-qmnum }: deletion flag set| ).
        CONTINUE.
      ENDIF.

      APPEND ls_notif TO lt_eligible.
    ENDLOOP.

    ct_notifs = lt_eligible.
  ENDMETHOD.

  METHOD complete_single.
    rs_result-qmnum      = is_notif-qmnum.
    rs_result-qmart      = is_notif-qmart.
    rs_result-cur_status = is_notif-cur_status.

    " Put in process first, otherwise some releases reject COMPLETE
    " when the notification is still OSNO.
    DATA(ls_progress) = mo_bapi->put_in_progress( is_notif-qmnum ).
    IF ls_progress-success = abap_false.
      mo_bapi->rollback( ).
      rs_result-result  = c_result_ko.
      rs_result-message = |PUT_IN_PROGRESS failed: { concat_lines_of( table = ls_progress-messages sep = ` | ` ) }|.
      RETURN.
    ENDIF.

    DATA(ls_complete) = mo_bapi->complete( is_notif-qmnum ).
    IF ls_complete-success = abap_false.
      mo_bapi->rollback( ).
      rs_result-result  = c_result_ko.
      rs_result-message = |COMPLETE failed: { concat_lines_of( table = ls_complete-messages sep = ` | ` ) }|.
      RETURN.
    ENDIF.

    mo_bapi->commit( ).
    rs_result-result  = c_result_ok.
    rs_result-message = |Notification { is_notif-qmnum } completed successfully|.
  ENDMETHOD.

  METHOD process_test_mode.
    LOOP AT mt_notifs INTO DATA(ls_notif).
      APPEND VALUE ty_result(
        qmnum      = ls_notif-qmnum
        qmart      = ls_notif-qmart
        cur_status = ls_notif-cur_status
        result     = c_result_ok
        message    = 'TEST MODE: notification would be put in process and completed.' ) TO mt_results.
      add_log( iv_type = 'I' iv_text = |TEST { ls_notif-qmnum }: would complete| ).
    ENDLOOP.
  ENDMETHOD.

  METHOD process_parallel.
    DATA(lv_tasks)    = get_parallel_task_count( ).
    DATA(lo_parallel) = NEW cl_abap_parallel( p_num_tasks = lv_tasks ).
    DATA lt_input  TYPE cl_abap_parallel=>t_in_inst_tab.
    DATA lt_output TYPE cl_abap_parallel=>t_out_inst_tab.

    LOOP AT mt_notifs INTO DATA(ls_notif).
      DATA(lo_worker) = NEW /hdl/cl_notif_complete_worker( ).
      lo_worker->qmnum      = ls_notif-qmnum.
      lo_worker->qmart      = ls_notif-qmart.
      lo_worker->cur_status = ls_notif-cur_status.
      APPEND CAST if_abap_parallel( lo_worker ) TO lt_input.
    ENDLOOP.

    lo_parallel->run_inst(
      EXPORTING p_in_tab  = lt_input
      IMPORTING p_out_tab = lt_output ).

    LOOP AT lt_output INTO DATA(ls_output).
      DATA(lo_result) = CAST /hdl/cl_notif_complete_worker( ls_output-inst ).
      APPEND VALUE ty_result(
        qmnum      = lo_result->qmnum
        qmart      = lo_result->qmart
        cur_status = lo_result->cur_status
        result     = COND #( WHEN lo_result->success = abap_true
                               THEN c_result_ok
                             ELSE c_result_ko )
        message    = lo_result->message ) TO mt_results.

      add_log(
        iv_type = COND #( WHEN lo_result->success = abap_true THEN 'S' ELSE 'E' )
        iv_text = |{ lo_result->qmnum }: { lo_result->message }| ).
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
        LOOP AT mt_results INTO DATA(ls).
          WRITE: / ls-qmnum, ls-qmart, ls-cur_status, ls-result, ls-message.
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
    ls_log-object    = 'CMP'.    " Notification log
    ls_log-subobject = 'NOTIF'.
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
