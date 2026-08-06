"! <p class="shorttext synchronized">Sink: writes results to Application Log</p>
CLASS zcl_load_sink_applog DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_load_sink.

    CONSTANTS c_object     TYPE c LENGTH 20 VALUE 'ZLOAD_DYN'.
    CONSTANTS c_sub_object TYPE c LENGTH 20 VALUE 'HTTP_API'.

  PRIVATE SECTION.
    DATA mt_result TYPE zcl_load_dto=>tt_result.

    METHODS write_bal
      IMPORTING it_result TYPE zcl_load_dto=>tt_result.

ENDCLASS.


CLASS zcl_load_sink_applog IMPLEMENTATION.

  METHOD zif_load_sink~append_results.
    APPEND LINES OF it_result TO mt_result.
    write_bal( it_result ).
  ENDMETHOD.

  METHOD zif_load_sink~get_results.
    rt_result = mt_result.
  ENDMETHOD.

  METHOD write_bal.
    TRY.
        DATA(lo_header) = cl_bali_header_setter=>create(
                            object    = c_object
                            subobject = c_sub_object ).
        DATA(lo_log) = cl_bali_log=>create_with_header( lo_header ).

        LOOP AT it_result INTO DATA(ls_r).
          DATA(lv_type) = COND symsgty( WHEN ls_r-status = 'S' THEN 'S' ELSE 'E' ).
          DATA(lo_msg)  = cl_bali_free_text_setter=>create(
                            severity = lv_type
                            text     = |{ ls_r-ext_id } { ls_r-entity_id } { ls_r-message }| ).
          lo_log->add_item( lo_msg ).
        ENDLOOP.

        cl_bali_log_db=>get_instance( )->save_log(
          log                        = lo_log
          do_callbacks_before_save   = abap_true
          assign_to_current_appl_job = abap_true ).

      CATCH cx_bali_runtime.
        " Do not propagate; a lost log must not break the main LUW.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
