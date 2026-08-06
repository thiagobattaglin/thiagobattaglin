REPORT /hdl/close_wo_orders.

"----------------------------------------------------------------------
" Close Maintenance Orders (PM) in mass mode
" Refactored for Clean Core and S/4HANA best practices
" Features:
"   - Order selection with multiple criteria
"   - TECO/CLSD status setting with eligibility checks
"   - Parallel mass processing
"   - Audit logging (BAL)
"   - i18n support with translatable text elements
"----------------------------------------------------------------------

TABLES: aufk, afih, iloa, tj02t, jest.

*----------------------------------------------------------------------*
* Type definitions - Clean ABAP naming (no prefixes)
*----------------------------------------------------------------------*

TYPES: objnr TYPE c LENGTH 22,
       status_code TYPE c LENGTH 5.

TYPES: BEGIN OF order_data,
         aufnr      TYPE aufk-aufnr,
         auart      TYPE aufk-auart,
         plant      TYPE aufk-werks,
         func_loc   TYPE iloa-tplnr,
         equipment  TYPE iloa-eqfnr,
         created_on TYPE aufk-erdat,
         object_id  TYPE objnr,
         status_txt TYPE string,
       END OF order_data.
TYPES orders_table TYPE STANDARD TABLE OF order_data WITH EMPTY KEY.

TYPES: BEGIN OF status_data,
         object_id  TYPE objnr,
         status     TYPE status_code,
         description TYPE tj02t-txt30,
       END OF status_data.
TYPES statuses_table TYPE STANDARD TABLE OF status_data WITH EMPTY KEY.

TYPES: BEGIN OF closure_result,
         aufnr       TYPE aufk-aufnr,
         auart       TYPE aufk-auart,
         status_txt  TYPE string,
         exec_result TYPE c LENGTH 10,
         exec_msg    TYPE string,
       END OF closure_result.
TYPES results_table TYPE STANDARD TABLE OF closure_result WITH EMPTY KEY.

*----------------------------------------------------------------------*
* Exception Hierarchy
*----------------------------------------------------------------------*

CLASS order_error DEFINITION FINAL INHERITING FROM cx_static_check.
  PUBLIC SECTION.
    DATA message TYPE string READ-ONLY.
    METHODS constructor IMPORTING error_msg TYPE string.
ENDCLASS.

CLASS order_error IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    me->message = error_msg.
  ENDMETHOD.
ENDCLASS.

*----------------------------------------------------------------------*
* Constants - Status definitions
*----------------------------------------------------------------------*

CONSTANTS: status_teco TYPE jest-stat VALUE 'I0045',
           status_clsd TYPE jest-stat VALUE 'I0046',
           status_dlfl TYPE jest-stat VALUE 'I0076'.

*----------------------------------------------------------------------*
* Selection Screen
*----------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK selection WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_aufnr FOR aufk-aufnr.
SELECTION-SCREEN END OF BLOCK selection.

SELECTION-SCREEN BEGIN OF BLOCK options WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_test AS CHECKBOX DEFAULT abap_true.
SELECTION-SCREEN END OF BLOCK options.

*----------------------------------------------------------------------*
* Worker class for parallel execution
*----------------------------------------------------------------------*

CLASS order_closure_worker DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_abap_parallel.

    DATA order_number  TYPE aufk-aufnr.
    DATA order_type    TYPE aufk-auart.
    DATA status_desc   TYPE string.
    DATA is_success    TYPE abap_bool.
    DATA result_msg    TYPE string.
ENDCLASS.

CLASS order_closure_worker IMPLEMENTATION.
  METHOD if_abap_parallel~do.
    DATA bapi_msgs TYPE bal_t_msg.
    DATA return_tab TYPE STANDARD TABLE OF bapiret2 WITH EMPTY KEY.
    DATA has_error TYPE abap_bool.
    TRY.
      CALL FUNCTION 'IBAPI_ALM_ORDER_TECO_SET'
        EXPORTING
          iv_orderid  = order_number
        TABLES
          et_messages = bapi_msgs
          return      = return_tab
        EXCEPTIONS
          OTHERS      = 1.

      IF sy-subrc <> 0.
        RAISE EXCEPTION NEW order_error( 'TECO setting failed' ).
      ENDIF.

      has_error = xsdbool(
        line_exists( return_tab[ type = 'E' ] ) OR
        line_exists( return_tab[ type = 'A' ] ) OR
        line_exists( bapi_msgs[ msgty = 'E' ] ) OR
        line_exists( bapi_msgs[ msgty = 'A' ] ) ).

      IF has_error = abap_true.
        result_msg = COND string(
          WHEN line_exists( return_tab[ type = 'E' ] )
            THEN return_tab[ type = 'E' ]-message
          WHEN line_exists( return_tab[ type = 'A' ] )
            THEN return_tab[ type = 'A' ]-message
          ELSE 'TECO/CLSD operation failed' ).
        is_success = abap_false.
        RETURN.
      ENDIF.

      CLEAR return_tab.
      CLEAR bapi_msgs.

      CALL FUNCTION 'IBAPI_ALM_ORDER_CLSD_SET'
        EXPORTING
          iv_orderid  = order_number
        TABLES
          et_messages = bapi_msgs
          return      = return_tab
        EXCEPTIONS
          OTHERS      = 1.

      IF sy-subrc <> 0.
        RAISE EXCEPTION NEW order_error( 'CLSD setting failed' ).
      ENDIF.

      has_error = xsdbool(
        line_exists( return_tab[ type = 'E' ] ) OR
        line_exists( return_tab[ type = 'A' ] ) OR
        line_exists( bapi_msgs[ msgty = 'E' ] ) OR
        line_exists( bapi_msgs[ msgty = 'A' ] ) ).

      IF has_error = abap_true.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        result_msg = COND string(
          WHEN line_exists( return_tab[ type = 'E' ] )
            THEN return_tab[ type = 'E' ]-message
          WHEN line_exists( return_tab[ type = 'A' ] )
            THEN return_tab[ type = 'A' ]-message
          ELSE 'TECO/CLSD operation failed' ).
        is_success = abap_false.
        RETURN.
      ENDIF.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING wait = abap_true
        EXCEPTIONS OTHERS = 1.

      IF sy-subrc <> 0.
        RAISE EXCEPTION NEW order_error( 'Commit failed' ).
      ENDIF.

      is_success = abap_true.
      result_msg = |Order { order_number } closed successfully|.

    CATCH order_error INTO DATA(ex).
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      is_success = abap_false.
      result_msg = ex->message.
  ENDTRY.
  ENDMETHOD.
ENDCLASS.

*----------------------------------------------------------------------*
* Main application class
*----------------------------------------------------------------------*

CLASS application DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS run.

  PRIVATE SECTION.
    DATA orders TYPE orders_table.
    DATA results TYPE results_table.
    DATA log_handle TYPE balloghndl.

    METHODS check_authorization RAISING order_error.
    METHODS read_orders.
    METHODS read_statuses IMPORTING src_orders TYPE orders_table
      RETURNING value(result_statuses) TYPE statuses_table.
    METHODS apply_status_filter IMPORTING filter_statuses TYPE statuses_table.
    METHODS validate_eligibility IMPORTING validation_statuses TYPE statuses_table.
    METHODS execute_parallel_closure.
    METHODS execute_test_mode.
    METHODS show_results.
    METHODS get_parallel_tasks RETURNING value(task_count) TYPE i.
    METHODS init_logging.
    METHODS add_log_entry IMPORTING entry_type TYPE symsgty entry_msg TYPE string.
    METHODS finalize_logging.
ENDCLASS.

CLASS application IMPLEMENTATION.

  METHOD run.
    TRY.
      check_authorization( ).
      init_logging( ).

      read_orders( ).

      IF orders IS INITIAL.
        add_log_entry( entry_type = 'I' entry_msg = 'No orders found' ).
        finalize_logging( ).
        show_results( ).
        RETURN.
      ENDIF.

      DATA(statuses) = read_statuses( orders ).

      apply_status_filter( statuses ).
      validate_eligibility( statuses ).

      IF orders IS INITIAL.
        add_log_entry( entry_type = 'I' entry_msg = 'No eligible orders' ).
        finalize_logging( ).
        show_results( ).
        RETURN.
      ENDIF.

      IF p_test = abap_true.
        execute_test_mode( ).
      ELSE.
        execute_parallel_closure( ).
      ENDIF.

      finalize_logging( ).
      show_results( ).

    CATCH order_error INTO DATA(error).
      add_log_entry( entry_type = 'E' entry_msg = error->message ).
      finalize_logging( ).
  ENDTRY.
  ENDMETHOD.

  METHOD check_authorization.
    AUTHORITY-CHECK OBJECT 'S_TCODE'
      ID 'TCD' FIELD 'IW32'.

    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW order_error( 'Missing authorization for IW32' ).
    ENDIF.
  ENDMETHOD.

  METHOD read_orders.
    SELECT k~aufnr, k~auart, k~werks, l~tplnr, l~eqfnr, k~erdat, k~objnr
      FROM aufk AS k
      INNER JOIN afih AS h ON h~aufnr = k~aufnr
      LEFT OUTER JOIN iloa AS l ON l~iloan = h~iloan
      WHERE k~aufnr IN @s_aufnr
      INTO TABLE @orders.
  ENDMETHOD.

  METHOD read_statuses.
    DATA result_tab TYPE statuses_table.

    IF src_orders IS INITIAL.
      RETURN.
    ENDIF.

    DATA obj_list TYPE STANDARD TABLE OF objnr WITH EMPTY KEY.
    LOOP AT src_orders INTO DATA(o).
      APPEND o-object_id TO obj_list.
    ENDLOOP.

    SELECT j~objnr, j~stat, t~txt30
      FROM jest AS j
      INNER JOIN tj02t AS t ON t~istat = j~stat AND t~spras = @sy-langu
      FOR ALL ENTRIES IN @obj_list
      WHERE j~objnr = @obj_list-table_line AND j~inact = @abap_false
      INTO TABLE @result_tab.

    result_statuses = result_tab.
  ENDMETHOD.

  METHOD apply_status_filter.
    DATA filtered_orders TYPE orders_table.

    LOOP AT orders INTO DATA(order).
      DATA(status_display) = SPACE.

      LOOP AT filter_statuses INTO DATA(status) WHERE object_id = order-object_id.
        IF status_display IS INITIAL.
          status_display = status-description.
        ELSE.
          status_display = |{ status_display }, { status-description }|.
        ENDIF.
      ENDLOOP.

      order-status_txt = status_display.
      APPEND order TO filtered_orders.
    ENDLOOP.

    orders = filtered_orders.
  ENDMETHOD.

  METHOD validate_eligibility.
    DATA valid_orders TYPE orders_table.

    LOOP AT orders INTO DATA(order).
      DATA has_clsd_status TYPE abap_bool VALUE abap_false.
      DATA has_dlfl_status TYPE abap_bool VALUE abap_false.

      LOOP AT validation_statuses INTO DATA(status) WHERE object_id = order-object_id.
        IF status-status = status_clsd.
          has_clsd_status = abap_true.
        ELSEIF status-status = status_dlfl.
          has_dlfl_status = abap_true.
        ENDIF.
      ENDLOOP.

      IF has_clsd_status = abap_true.
        APPEND VALUE closure_result(
          aufnr = order-aufnr
          auart = order-auart
          status_txt = order-status_txt
          exec_result = 'ERROR'
          exec_msg = TEXT-006 ) TO results.
        add_log_entry( entry_type = 'E' entry_msg = |{ order-aufnr }: { TEXT-006 }| ).
        CONTINUE.
      ENDIF.

      IF has_dlfl_status = abap_true.
        APPEND VALUE closure_result(
          aufnr = order-aufnr
          auart = order-auart
          status_txt = order-status_txt
          exec_result = 'ERROR'
          exec_msg = TEXT-007 ) TO results.
        add_log_entry( entry_type = 'E' entry_msg = |{ order-aufnr }: { TEXT-007 }| ).
        CONTINUE.
      ENDIF.

      APPEND order TO valid_orders.
    ENDLOOP.

    orders = valid_orders.
  ENDMETHOD.

  METHOD execute_test_mode.
    LOOP AT orders INTO DATA(order).
      APPEND VALUE closure_result(
        aufnr = order-aufnr
        auart = order-auart
        status_txt = order-status_txt
        exec_result = 'SUCCESS'
        exec_msg = TEXT-008 ) TO results.
      add_log_entry( entry_type = 'I' entry_msg = |TEST { order-aufnr }: { TEXT-009 }| ).
    ENDLOOP.
  ENDMETHOD.

  METHOD execute_parallel_closure.
    DATA parallel_runner TYPE REF TO cl_abap_parallel.
    DATA worker_instances TYPE cl_abap_parallel=>t_in_inst_tab.
    DATA output_instances TYPE cl_abap_parallel=>t_out_inst_tab.

    DATA(task_cnt) = get_parallel_tasks( ).
    parallel_runner = NEW cl_abap_parallel( p_num_tasks = task_cnt ).

    LOOP AT orders INTO DATA(order).
      DATA(worker) = NEW order_closure_worker( ).
      worker->order_number = order-aufnr.
      worker->order_type = order-auart.
      worker->status_desc = order-status_txt.
      APPEND CAST if_abap_parallel( worker ) TO worker_instances.
    ENDLOOP.

    parallel_runner->run_inst(
      EXPORTING p_in_tab = worker_instances
      IMPORTING p_out_tab = output_instances ).

    LOOP AT output_instances INTO DATA(output).
      DATA(result_worker) = CAST order_closure_worker( output-inst ).

      DATA(success_indicator) = COND #(
        WHEN result_worker->is_success = abap_true THEN 'SUCCESS' ELSE 'ERROR' ).

      APPEND VALUE closure_result(
        aufnr = result_worker->order_number
        auart = result_worker->order_type
        status_txt = result_worker->status_desc
        exec_result = success_indicator
        exec_msg = result_worker->result_msg ) TO results.

      add_log_entry(
        entry_type = COND #(
          WHEN result_worker->is_success = abap_true THEN 'S' ELSE 'E' )
        entry_msg = |{ result_worker->order_number }: { result_worker->result_msg }| ).
    ENDLOOP.
  ENDMETHOD.

  METHOD show_results.
    DATA display_table TYPE REF TO cl_salv_table.

    TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = display_table
        CHANGING t_table = results ).

      display_table->get_display_settings( )->set_striped_pattern( abap_true ).
      display_table->get_functions( )->set_all( abap_true ).
      display_table->get_columns( )->set_optimize( abap_true ).
      display_table->display( ).

    CATCH cx_salv_msg.
      LOOP AT results INTO DATA(result).
        WRITE: / result-aufnr,
                 result-auart,
                 result-status_txt,
                 result-exec_result,
                 result-exec_msg.
      ENDLOOP.
    ENDTRY.
  ENDMETHOD.

  METHOD get_parallel_tasks.
    DATA batch_param TYPE char128.

    CALL FUNCTION 'TH_GET_PARAMETER'
      EXPORTING parameter_name = 'rdisp/wp_no_btc'
      IMPORTING parameter_value = batch_param
      EXCEPTIONS OTHERS = 1.

    IF sy-subrc <> 0.
      task_count = 1.
      RETURN.
    ENDIF.

    IF batch_param IS NOT INITIAL.
      task_count = floor( CONV i( batch_param ) * 60 / 100 ).
    ENDIF.

    IF task_count < 1.
      task_count = 1.
    ENDIF.
  ENDMETHOD.

  METHOD init_logging.
    DATA log_data TYPE bal_s_log.

    log_data-object = 'PM'.
    log_data-subobject = 'ORDER'.
    log_data-alprog = sy-repid.
    log_data-aluser = sy-uname.
    log_data-aldate = sy-datum.
    log_data-altime = sy-uzeit.
    log_data-extnumber = |{ sy-repid }/{ sy-datum }/{ sy-uzeit }|.

    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING i_s_log = log_data
      IMPORTING e_log_handle = log_handle
      EXCEPTIONS OTHERS = 1.

    IF sy-subrc <> 0.
      log_handle = 0.
    ENDIF.
  ENDMETHOD.

  METHOD add_log_entry.
    IF log_handle IS INITIAL.
      RETURN.
    ENDIF.

    DATA log_msg TYPE bal_s_msg.
    log_msg-msgty = entry_type.
    log_msg-msgid = '00'.
    log_msg-msgno = '398'.
    log_msg-msgv1 = entry_msg.

    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING i_log_handle = log_handle i_s_msg = log_msg
      EXCEPTIONS OTHERS = 1.
  ENDMETHOD.

  METHOD finalize_logging.
    IF log_handle IS INITIAL.
      RETURN.
    ENDIF.

    DATA log_handles TYPE bal_t_logh.
    APPEND log_handle TO log_handles.

    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING i_t_log_handle = log_handles
      EXCEPTIONS OTHERS = 1.
  ENDMETHOD.

ENDCLASS.

*----------------------------------------------------------------------*
* START-OF-SELECTION: Main entry point
*----------------------------------------------------------------------*

START-OF-SELECTION.
  TRY.
    NEW application( )->run( ).
  CATCH cx_root INTO DATA(root_error).
    WRITE: / |{ TEXT-010 }: { root_error->get_text( ) }|.
  ENDTRY.