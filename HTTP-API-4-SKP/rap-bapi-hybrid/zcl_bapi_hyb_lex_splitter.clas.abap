CLASS zcl_bapi_hyb_lex_splitter DEFINITION
  PUBLIC
  CREATE PUBLIC.

* Isolated, unit-tested lexical splitter for a JSON payload of shape
*   { ..., "documents": [ {doc1}, {doc2}, ... ], ... }
*
* Splits documents[] textually in a single pass over the source string.
* Tracks brace depth and string escape state to avoid parsing anything
* below the top-level document boundaries. Emits valid JSON array
* substrings like [{doc},{doc}] ready to feed into a worker.
*
* Complexity: O(strlen(iv_json)), zero RTTI, zero heap allocations
* proportional to document count. Isolated here to contain the
* "hand-rolled parser" surface area to one testable class.

  PUBLIC SECTION.

    METHODS split
      IMPORTING iv_json          TYPE string
                iv_worker_rows   TYPE i
      EXPORTING ev_doc_count     TYPE i
                et_chunks        TYPE string_table.

ENDCLASS.


CLASS zcl_bapi_hyb_lex_splitter IMPLEMENTATION.

  METHOD split.

    CLEAR: ev_doc_count, et_chunks.

    DATA(lv_len) = strlen( iv_json ).
    IF lv_len = 0 OR iv_worker_rows <= 0.
      RETURN.
    ENDIF.

    DATA(lv_off) = find( val = iv_json sub = `"documents"` ).
    IF lv_off < 0.
      RETURN.
    ENDIF.

    lv_off = find( val = iv_json sub = `[` off = lv_off ).
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

ENDCLASS.
