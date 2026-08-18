CLASS zcl_bapi_hyb_dispatcher DEFINITION
  PUBLIC
  CREATE PUBLIC.

* Hybrid dispatcher. Combines:
*  - streaming: header parsed by walking the sXML JSON token stream
*    and picking only top-level scalar fields (nested arrays/objects
*    are skipped implicitly by depth tracking);
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
    "! by walking the sXML JSON token stream and picking top-level scalars.
    "! Nested containers (documents[], objects) are skipped implicitly.
    METHODS parse_header
      IMPORTING iv_json          TYPE string
      RETURNING VALUE(rs_header) TYPE ty_header
      RAISING   cx_static_check.

    "! Debug: return the trimmed header JSON
    METHODS get_trimmed_header
      IMPORTING iv_json          TYPE string
      RETURNING VALUE(rv_header) TYPE string.

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

    "! Assigns a top-level scalar (string/number/bool) to the header
    "! structure by key name. Unknown keys are silently ignored.
    METHODS assign_scalar
      IMPORTING iv_key    TYPE string
                iv_value  TYPE string
      CHANGING  cs_header TYPE ty_header.

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
* Reads only top-level scalar fields via sXML JSON reader.
* Anything nested (documents[], objects) is skipped implicitly
* because we only capture value nodes while depth = 2.

    DATA lv_depth     TYPE i.
    DATA lv_key       TYPE string.
    DATA lv_is_scalar TYPE abap_bool.

    TRY.
        DATA(lo_reader) = cl_sxml_string_reader=>create(
                            cl_abap_codepage=>convert_to( iv_json ) ).

        DO.
          DATA(lo_node) = lo_reader->read_next_node( ).
          IF lo_node IS NOT BOUND.
            EXIT.
          ENDIF.

          CASE lo_node->type.
            WHEN if_sxml_node=>co_nt_element_open.
              DATA(lo_open) = CAST if_sxml_open_element( lo_node ).
              lv_depth = lv_depth + 1.
              IF lv_depth = 2.
                CLEAR lv_key.
                DATA(lv_elem) = to_lower( lo_open->qname-name ).
                lv_is_scalar = xsdbool( lv_elem = 'str' OR lv_elem = 'num' OR lv_elem = 'int' OR lv_elem = 'bool' ).
                LOOP AT lo_open->get_attributes( ) INTO DATA(lo_attr).
                  IF to_lower( lo_attr->qname-name ) = 'name'.
                    lv_key = lo_attr->get_value( ).
                    EXIT.
                  ENDIF.
                ENDLOOP.
              ENDIF.

            WHEN if_sxml_node=>co_nt_value.
              IF lv_depth = 2 AND lv_is_scalar = abap_true AND lv_key IS NOT INITIAL.
                assign_scalar(
                  EXPORTING iv_key   = lv_key
                            iv_value = CAST if_sxml_value_node( lo_node )->get_value( )
                  CHANGING  cs_header = rs_header ).
              ENDIF.

            WHEN if_sxml_node=>co_nt_element_close.
              lv_depth = lv_depth - 1.
          ENDCASE.
        ENDDO.

      CATCH cx_root INTO DATA(lx_err).
        RAISE EXCEPTION TYPE cx_parameter_invalid_range
          EXPORTING previous  = lx_err
                    parameter = `payload_header`
                    value     = CONV #( lx_err->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD assign_scalar.
    CASE to_lower( iv_key ).
      WHEN 'mode'.           cs_header-mode           = iv_value.
      WHEN 'bapi_name'.      cs_header-bapi_name      = iv_value.
      WHEN 'kind'.           cs_header-kind           = iv_value.
      WHEN 'worker_threads'. cs_header-worker_threads = iv_value.
      WHEN 'worker_rows'.    cs_header-worker_rows    = iv_value.
    ENDCASE.
  ENDMETHOD.

  METHOD get_trimmed_header.
* Debug helper: returns the reconstructed header JSON.
    TRY.
        rv_header = zcl_bapi_hyb_json_parser=>serialize( parse_header( iv_json ) ).
      CATCH cx_root ##NO_HANDLER.
    ENDTRY.
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
