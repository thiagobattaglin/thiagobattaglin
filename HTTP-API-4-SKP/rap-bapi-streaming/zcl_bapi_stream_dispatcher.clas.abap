CLASS zcl_bapi_stream_dispatcher DEFINITION
  PUBLIC
  CREATE PUBLIC.

* Streaming dispatcher: never deserializes the whole payload.
* - "chunk" mode: client already sends small POSTs (e.g. 100 docs each).
*                 The dispatcher forwards each POST as a single chunk to
*                 exactly one worker without parsing document contents.
* - "bulk"  mode: one large payload arrives, but the split is *lexical*
*                 (scanning "documents":[ ... ] and cutting at top-level
*                 "},{" boundaries). No full deserialize; each worker gets
*                 a substring already valid as a JSON array chunk.

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

    "! Public entry point: parses ONLY the small header (no documents),
    "! then either forwards the payload as one chunk (kind=chunk) or
    "! performs a lexical split on documents[] (kind=bulk).
    METHODS dispatch
      IMPORTING iv_json           TYPE string
      RETURNING VALUE(rs_outcome) TYPE ty_outcome
      RAISING   cx_static_check.

    "! Parses only the top-level scalar header (mode / bapi_name /
    "! worker_threads / worker_rows / kind). Never touches documents/items.
    METHODS parse_header
      IMPORTING iv_json          TYPE string
      RETURNING VALUE(rs_header) TYPE ty_header
      RAISING   cx_static_check.

    "! Splits documents[] textually. Returns valid JSON array chunks like
    "! [{doc1},{doc2}]. Runs in a single pass over the source string.
    METHODS split_lexical
      IMPORTING iv_json          TYPE string
                iv_workers       TYPE i
                iv_worker_rows   TYPE i
      EXPORTING ev_doc_count     TYPE i
                et_chunks        TYPE string_table.

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

    METHODS dispatch_chunks
      IMPORTING iv_bapi_name TYPE string
                iv_mode      TYPE string
                it_chunks    TYPE string_table.

  PRIVATE SECTION.

    METHODS scan_string_value
      IMPORTING iv_json          TYPE string
                iv_key           TYPE string
      RETURNING VALUE(rv_value)  TYPE string.

    METHODS scan_int_value
      IMPORTING iv_json          TYPE string
                iv_key           TYPE string
      RETURNING VALUE(rv_value)  TYPE i.

ENDCLASS.


CLASS zcl_bapi_stream_dispatcher IMPLEMENTATION.

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
* Client already chunked: forward the payload as a single worker chunk.
* No document parsing occurs on the dispatcher side.
      APPEND iv_json TO lt_chunks.
      lv_total   = 1.
      lv_workers = 1.
    ELSE.
      split_lexical(
        EXPORTING iv_json        = iv_json
                  iv_workers     = lv_max
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
    rs_header-bapi_name      = scan_string_value( iv_json = iv_json iv_key = `bapi_name` ).
    rs_header-mode           = scan_string_value( iv_json = iv_json iv_key = `mode`      ).
    rs_header-kind           = scan_string_value( iv_json = iv_json iv_key = `kind`      ).
    rs_header-worker_threads = scan_int_value(    iv_json = iv_json iv_key = `worker_threads` ).
    rs_header-worker_rows    = scan_int_value(    iv_json = iv_json iv_key = `worker_rows`    ).
  ENDMETHOD.

  METHOD normalize_positive.
    rv_result = COND i( WHEN iv_value > 0 THEN iv_value ELSE iv_default ).
  ENDMETHOD.

  METHOD calculate_workers.
    IF iv_docs_total <= 0 OR iv_worker_rows <= 0 OR iv_worker_max <= 0.
      rv_result = 0.
      RETURN.
    ENDIF.
    DATA(lv_needed) = ( iv_docs_total + iv_worker_rows - 1 ) DIV iv_worker_rows.
    rv_result = COND i( WHEN lv_needed < iv_worker_max THEN lv_needed
                        ELSE iv_worker_max ).
  ENDMETHOD.

  METHOD split_lexical.

* Single lexical pass over the source string. We locate "documents":[
* and then walk each top-level element by tracking brace depth and
* string state. When docs_in_chunk reaches iv_worker_rows OR we finish
* the whole array, we emit a JSON array substring as one chunk.

    CLEAR: ev_doc_count, et_chunks.

    DATA(lv_len) = strlen( iv_json ).
    IF lv_len = 0 OR iv_worker_rows <= 0.
      RETURN.
    ENDIF.

    DATA(lv_off) = find( val = iv_json sub = `"documents"` ).
    IF lv_off < 0.
      RETURN.
    ENDIF.

    lv_off = find( val   = iv_json
                   sub   = `[`
                   off   = lv_off ).
    IF lv_off < 0.
      RETURN.
    ENDIF.
    lv_off = lv_off + 1.

    DATA lv_depth       TYPE i VALUE 0.
    DATA lv_in_string   TYPE abap_bool VALUE abap_false.
    DATA lv_escape      TYPE abap_bool VALUE abap_false.
    DATA lv_doc_start   TYPE i VALUE -1.
    DATA lt_docs_buffer TYPE string_table.
    DATA lv_docs_batch  TYPE i VALUE 0.
    DATA lv_char        TYPE c LENGTH 1.

    WHILE lv_off < lv_len.
      lv_char = iv_json+lv_off(1).

      IF lv_in_string = abap_true.
        IF lv_escape = abap_true.
          lv_escape = abap_false.
        ELSEIF lv_char = '\'.
          lv_escape = abap_true.
        ELSEIF lv_char = '"'.
          lv_in_string = abap_false.
        ENDIF.
      ELSE.
        CASE lv_char.
          WHEN '"'.
            lv_in_string = abap_true.
          WHEN '{'.
            IF lv_depth = 0.
              lv_doc_start = lv_off.
            ENDIF.
            lv_depth = lv_depth + 1.
          WHEN '}'.
            lv_depth = lv_depth - 1.
            IF lv_depth = 0 AND lv_doc_start >= 0.
              DATA(lv_doc_len) = lv_off - lv_doc_start + 1.
              APPEND iv_json+lv_doc_start(lv_doc_len) TO lt_docs_buffer.
              ev_doc_count  = ev_doc_count + 1.
              lv_docs_batch = lv_docs_batch + 1.
              lv_doc_start  = -1.

              IF lv_docs_batch >= iv_worker_rows.
                APPEND |[{ concat_lines_of( table = lt_docs_buffer sep = `,` ) }]| TO et_chunks.
                CLEAR lt_docs_buffer.
                lv_docs_batch = 0.
              ENDIF.
            ENDIF.
          WHEN ']'.
            IF lv_depth = 0.
              EXIT.
            ENDIF.
          WHEN OTHERS.
            " scalars, whitespace, commas
        ENDCASE.
      ENDIF.

      lv_off = lv_off + 1.
    ENDWHILE.

    IF lines( lt_docs_buffer ) > 0.
      APPEND |[{ concat_lines_of( table = lt_docs_buffer sep = `,` ) }]| TO et_chunks.
    ENDIF.

  ENDMETHOD.

  METHOD scan_string_value.
* Locates "<key>"<ws>:<ws>"<value>" without full JSON parsing.
    DATA(lv_pat) = |"{ iv_key }"|.
    DATA(lv_off) = find( val = iv_json sub = lv_pat ).
    IF lv_off < 0.
      RETURN.
    ENDIF.
    lv_off = find( val = iv_json sub = `:` off = lv_off ).
    IF lv_off < 0.
      RETURN.
    ENDIF.
    lv_off = find( val = iv_json sub = `"` off = lv_off + 1 ).
    IF lv_off < 0.
      RETURN.
    ENDIF.
    DATA(lv_start) = lv_off + 1.
    DATA(lv_end)   = find( val = iv_json sub = `"` off = lv_start ).
    IF lv_end < 0.
      RETURN.
    ENDIF.
    rv_value = iv_json+lv_start(lv_end - lv_start).
  ENDMETHOD.

  METHOD scan_int_value.
    DATA(lv_pat) = |"{ iv_key }"|.
    DATA(lv_off) = find( val = iv_json sub = lv_pat ).
    IF lv_off < 0.
      RETURN.
    ENDIF.
    lv_off = find( val = iv_json sub = `:` off = lv_off ).
    IF lv_off < 0.
      RETURN.
    ENDIF.
    lv_off = lv_off + 1.
    DATA(lv_len)  = strlen( iv_json ).
    DATA lv_num TYPE string.
    DATA lv_ch  TYPE c LENGTH 1.
    WHILE lv_off < lv_len.
      lv_ch = iv_json+lv_off(1).
      IF lv_ch CA '0123456789-'.
        lv_num = lv_num && lv_ch.
      ELSEIF lv_num IS NOT INITIAL.
        EXIT.
      ELSEIF lv_ch = ',' OR lv_ch = '}' OR lv_ch = '"'.
        EXIT.
      ENDIF.
      lv_off = lv_off + 1.
    ENDWHILE.
    IF lv_num IS NOT INITIAL.
      rv_value = lv_num.
    ENDIF.
  ENDMETHOD.

  METHOD dispatch_chunks.
    DATA lv_task TYPE c LENGTH 32.
    DATA lv_seq  TYPE i VALUE 0.

    LOOP AT it_chunks ASSIGNING FIELD-SYMBOL(<lv_chunk>).
      lv_seq  = lv_seq + 1.
      lv_task = |WK_{ sy-uzeit }_{ lv_seq }|.

      TRY.
          CALL FUNCTION 'Z_BAPI_STREAM_WORKER'
            STARTING NEW TASK lv_task
            DESTINATION IN GROUP DEFAULT
            EXPORTING
              iv_bapi_name = iv_bapi_name
              iv_mode      = iv_mode
              iv_chunk     = <lv_chunk>.
        CATCH cx_root.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
