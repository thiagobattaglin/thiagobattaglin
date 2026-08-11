CLASS zcl_bapi_hyb_dispatcher DEFINITION
  PUBLIC
  CREATE PUBLIC.

* Hybrid dispatcher. Combines:
*  - streaming: header parsed by trimming to a scalar-only JSON substring
*    and deserializing via CALL TRANSFORMATION id + sXML;
*  - lexical split: documents[] is cut textually (zcl_bapi_hyb_lex_splitter);
*  - synchronous dispatch: chunks processed sequentially by zcl_bapi_hyb_worker_op.
*    Upgrade path: when IF_BGMC_OP_SINGLE_TX_UNCONTROLLED is available, re-enable
*    bgPF scheduling in dispatch_chunks without changing any other class.

  PUBLIC SECTION.

    CONSTANTS c_default_workers TYPE i      VALUE 4.
    CONSTANTS c_default_rows    TYPE i      VALUE 100.
    CONSTANTS c_mode_async      TYPE string VALUE 'async'.
    CONSTANTS c_mode_sync       TYPE string VALUE 'sync'.
    CONSTANTS c_kind_chunk      TYPE string VALUE 'chunk'.
    CONSTANTS c_kind_bulk       TYPE string VALUE 'bulk'.

    TYPES:
      BEGIN OF ty_header,
        mode           TYPE string,
        bapi_name      TYPE string,
        worker_threads TYPE i,
        worker_rows    TYPE i,
        kind           TYPE string,
      END OF ty_header.

    TYPES:
      BEGIN OF ty_outcome,
        bapi_name TYPE string,
        accepted  TYPE i,
        workers   TYPE i,
        mode      TYPE string,
        kind      TYPE string,
      END OF ty_outcome.

    METHODS dispatch
      IMPORTING iv_json           TYPE string
      RETURNING VALUE(rs_outcome) TYPE ty_outcome
      RAISING   cx_static_check.

    "! Extracts the header ({mode/bapi_name/worker_threads/worker_rows/kind})
    "! by trimming iv_json to a header-shaped substring and running CTF id.
    "! This deserializes O(header) bytes, not the whole payload.
    METHODS parse_header
      IMPORTING iv_json          TYPE string
      RETURNING VALUE(rs_header) TYPE ty_header
      RAISING   cx_static_check.

    METHODS calculate_workers
      IMPORTING iv_docs_total    TYPE i
                iv_worker_rows   TYPE i
                iv_worker_max    TYPE i
      RETURNING VALUE(rv_result) TYPE i.

    METHODS normalize_positive
      IMPORTING iv_value         TYPE i
                iv_default       TYPE i
      RETURNING VALUE(rv_result) TYPE i.

  PROTECTED SECTION.

    "! Injectable hook: production impl uses bgPF; tests override it.
    METHODS dispatch_chunks
      IMPORTING iv_bapi_name TYPE string
                iv_mode      TYPE string
                it_chunks    TYPE string_table
      RAISING   cx_static_check.

  PRIVATE SECTION.

    "! Returns a JSON substring containing only the top-level scalar
    "! keys of the payload (no arrays/objects). Result is a small
    "! well-formed JSON object that CTF id can deserialize cheaply.
    METHODS trim_to_header_only
      IMPORTING iv_json          TYPE string
      RETURNING VALUE(rv_header) TYPE string.

ENDCLASS.


CLASS zcl_bapi_hyb_dispatcher IMPLEMENTATION.

  METHOD dispatch.

    DATA(ls_hdr) = parse_header( iv_json ).

    IF ls_hdr-bapi_name IS INITIAL.
      RAISE EXCEPTION TYPE cx_parameter_invalid_range
        EXPORTING parameter = `bapi_name`
                  value     = `(empty)`.
    ENDIF.

    DATA(lv_rows) = normalize_positive( iv_value   = ls_hdr-worker_rows
                                        iv_default = c_default_rows ).
    DATA(lv_max)  = normalize_positive( iv_value   = ls_hdr-worker_threads
                                        iv_default = c_default_workers ).

    DATA(lv_mode) = COND string( WHEN ls_hdr-mode = c_mode_sync THEN c_mode_sync
                                 ELSE c_mode_async ).

    DATA lt_chunks   TYPE string_table.
    DATA lv_total    TYPE i.
    DATA lv_workers  TYPE i.
    DATA lv_kind     TYPE string.

    lv_kind = COND string( WHEN ls_hdr-kind = c_kind_bulk THEN c_kind_bulk
                           ELSE c_kind_chunk ).

    IF lv_kind = c_kind_chunk.
      APPEND iv_json TO lt_chunks.
      lv_total   = 1.
      lv_workers = 1.
    ELSE.
      DATA(lo_splitter) = NEW zcl_bapi_hyb_lex_splitter( ).
      lo_splitter->split(
        EXPORTING iv_json        = iv_json
                  iv_worker_rows = lv_rows
        IMPORTING ev_doc_count   = lv_total
                  et_chunks      = lt_chunks ).

      lv_workers = calculate_workers( iv_docs_total  = lv_total
                                      iv_worker_rows = lv_rows
                                      iv_worker_max  = lv_max ).
    ENDIF.

    dispatch_chunks( iv_bapi_name = ls_hdr-bapi_name
                     iv_mode      = lv_mode
                     it_chunks    = lt_chunks ).

    rs_outcome = VALUE #(
      bapi_name = ls_hdr-bapi_name
      accepted  = lv_total
      workers   = lv_workers
      mode      = lv_mode
      kind      = lv_kind ).

  ENDMETHOD.

  METHOD parse_header.
    DATA(lv_header_json) = trim_to_header_only( iv_json ).
    IF lv_header_json IS INITIAL.
      RETURN.
    ENDIF.

    TRY.
        zcl_bapi_hyb_json_parser=>deserialize(
          EXPORTING iv_json = lv_header_json
          CHANGING  cs_data = rs_header ).
      CATCH cx_transformation_error INTO DATA(lx_err).
        RAISE EXCEPTION TYPE cx_parameter_invalid_range
          EXPORTING previous  = lx_err
                    parameter = `payload_header`
                    value     = CONV #( lx_err->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD trim_to_header_only.
* Walks the top-level object once and keeps only scalar members
* (string / number / boolean). Skips array/object members entirely by
* tracking depth + string state. Output is a well-formed JSON object
* whose only members are the payload header scalars.

    DATA lv_len     TYPE i.
    DATA lv_open    TYPE i.
    DATA lv_off     TYPE i.
    DATA lt_kept    TYPE string_table.
    DATA lv_state   TYPE i.
    DATA lv_in_str  TYPE abap_bool.
    DATA lv_escape  TYPE abap_bool.
    DATA lv_current TYPE string.
    DATA lv_key     TYPE string.
    DATA lv_value   TYPE string.
    DATA lv_ch      TYPE c LENGTH 1.
    DATA lv_depth   TYPE i.
    DATA lv_sc      TYPE c LENGTH 1.
    DATA lv_val_trim TYPE string.

    lv_len = strlen( iv_json ).
    IF lv_len = 0.
      RETURN.
    ENDIF.

    lv_open = find( val = iv_json sub = `{` ).
    IF lv_open < 0.
      RETURN.
    ENDIF.
    lv_off = lv_open + 1.

    WHILE lv_off < lv_len.
      lv_ch = iv_json+lv_off(1).

      IF lv_ch = '{' OR lv_ch = '['.
* Nested container; skip until matching close at same depth.
        lv_depth = 1.
        lv_off = lv_off + 1.
        WHILE lv_off < lv_len AND lv_depth > 0.
          lv_sc = iv_json+lv_off(1).
          IF lv_in_str = abap_true.
            IF lv_escape = abap_true.
              lv_escape = abap_false.
            ELSEIF lv_sc = '\'.
              lv_escape = abap_true.
            ELSEIF lv_sc = '"'.
              lv_in_str = abap_false.
            ENDIF.
          ELSE.
            IF lv_sc = '"'.
              lv_in_str = abap_true.
            ELSEIF lv_sc = '{' OR lv_sc = '['.
              lv_depth = lv_depth + 1.
            ELSEIF lv_sc = '}' OR lv_sc = ']'.
              lv_depth = lv_depth - 1.
            ENDIF.
          ENDIF.
          lv_off = lv_off + 1.
        ENDWHILE.
        CLEAR: lv_current, lv_key, lv_value, lv_state.
        CONTINUE.
      ENDIF.

      IF lv_ch = '}' AND lv_state <> 1.
        EXIT.
      ENDIF.

      IF lv_state = 0 AND lv_ch = '"'.
        lv_state   = 1.
        CLEAR lv_key.
        lv_off = lv_off + 1.
        CONTINUE.
      ENDIF.
      IF lv_state = 1.
        IF lv_ch = '"'.
          lv_state = 2.
        ELSE.
          lv_key = lv_key && lv_ch.
        ENDIF.
        lv_off = lv_off + 1.
        CONTINUE.
      ENDIF.
      IF lv_state = 2 AND lv_ch = ':'.
        lv_state = 3.
        CLEAR lv_value.
        lv_off = lv_off + 1.
        CONTINUE.
      ENDIF.
      IF lv_state = 3.
        IF lv_ch = ',' OR lv_ch = '}'.
          lv_val_trim = condense( val = lv_value del = ` ` ).
          IF lv_val_trim IS NOT INITIAL AND lv_key IS NOT INITIAL.
            APPEND |"{ lv_key }":{ lv_val_trim }| TO lt_kept.
          ENDIF.
          CLEAR: lv_key, lv_value.
          lv_state = 0.
          IF lv_ch = '}'.
            EXIT.
          ENDIF.
        ELSE.
          lv_value = lv_value && lv_ch.
        ENDIF.
      ENDIF.

      lv_off = lv_off + 1.
    ENDWHILE.

    rv_header = |\{{ concat_lines_of( table = lt_kept sep = `,` ) }\}|.
  ENDMETHOD.

  METHOD normalize_positive.
    rv_result = COND i( WHEN iv_value > 0 THEN iv_value ELSE iv_default ).
  ENDMETHOD.

  METHOD calculate_workers.
    IF iv_docs_total <= 0 OR iv_worker_rows <= 0 OR iv_worker_max <= 0.
      rv_result = 0.
      RETURN.
    ENDIF.
    DATA lv_needed TYPE i.
    lv_needed = ( iv_docs_total + iv_worker_rows - 1 ) DIV iv_worker_rows.
    rv_result = COND i( WHEN lv_needed < iv_worker_max THEN lv_needed
                        ELSE iv_worker_max ).
  ENDMETHOD.

  METHOD dispatch_chunks.
* Synchronous dispatch: IF_BGMC_OP_SINGLE_TX_UNCONTROLLED not available
* in this release. Each chunk runs in the same LUW sequentially.
* TODO: re-enable bgPF scheduling when the target release supports it.

    LOOP AT it_chunks ASSIGNING FIELD-SYMBOL(<lv_chunk>).
      TRY.
          DATA(lo_worker) = NEW zcl_bapi_hyb_worker_op(
            iv_bapi_name = iv_bapi_name
            iv_mode      = iv_mode
            iv_chunk     = <lv_chunk> ).
          lo_worker->execute( ).
        CATCH cx_root ##NO_HANDLER.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
