CLASS zcl_bapi_meta_v11_dispatch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

* Dispatcher Clean Core do POST v1.1.
*
* Regras de default:
*   - worker_rows    em branco / <= 0  =>  5000 linhas por worker (cap).
*   - worker_threads em branco / <= 0  =>  quantos workers forem necessários
*                                          para respeitar o cap de linhas.
*   - worker_threads > 0               =>  usado como limite máximo.
*
* APIs released usadas:
*   - if_web_http_request / if_web_http_response      (HTTP handler)
*   - xco_cp_json                                     (parse + serialize)
*   - EXPORT/IMPORT TO/FROM DATA BUFFER               (transporte binário)
*   - cl_abap_parallel                                (paralelismo)
*
* NENHUMA API não-released é chamada aqui. O acoplamento com o legacy
* (dynamic CALL FUNCTION, FUNCTION_IMPORT_INTERFACE, BAPI commit) acontece
* apenas em zcl_bapi_meta_v11_lgcy_exec, instanciado no provider paralelo.

  PUBLIC SECTION.

    CONSTANTS c_default_rows TYPE i      VALUE 5000.
    CONSTANTS c_mode_async   TYPE string VALUE 'async'.
    CONSTANTS c_mode_sync    TYPE string VALUE 'sync'.

    TYPES:
      BEGIN OF ty_request,
        mode           TYPE string,
        bapi_name      TYPE string,
        worker_threads TYPE i,
        worker_rows    TYPE i,
        documents      TYPE zif_bapi_meta_v11_executor=>tt_documents,
      END OF ty_request.

    TYPES:
      BEGIN OF ty_outcome,
        bapi_name     TYPE string,
        accepted      TYPE i,
        workers       TYPE i,
        mode          TYPE string,
        response_json TYPE string,
      END OF ty_outcome.

    TYPES tt_chunks TYPE STANDARD TABLE OF xstring WITH DEFAULT KEY.

    METHODS dispatch
      IMPORTING iv_json           TYPE string
      RETURNING VALUE(rs_outcome) TYPE ty_outcome
      RAISING   cx_static_check.

    "! Exposto para testes unitários.
    METHODS parse_request
      IMPORTING iv_json           TYPE string
      RETURNING VALUE(rs_request) TYPE ty_request
      RAISING   cx_static_check.

    "! Exposto para testes unitários.
    METHODS resolve_workers
      IMPORTING iv_docs_total    TYPE i
                iv_worker_rows   TYPE i
                iv_worker_max    TYPE i
      RETURNING VALUE(rv_result) TYPE i.

    "! Exposto para testes unitários.
    METHODS split_documents
      IMPORTING iv_bapi_name     TYPE string
                it_documents     TYPE zif_bapi_meta_v11_executor=>tt_documents
                iv_workers       TYPE i
      RETURNING VALUE(rt_chunks) TYPE tt_chunks.

    "! Exposto para testes unitários.
    METHODS build_response
      IMPORTING iv_bapi_name   TYPE string
                iv_accepted    TYPE i
                iv_workers     TYPE i
                iv_mode        TYPE string
      RETURNING VALUE(rv_json) TYPE string.

  PROTECTED SECTION.

    "! Hook redefinido em testes para não disparar cl_abap_parallel real.
    METHODS dispatch_chunks
      IMPORTING iv_workers TYPE i
                it_chunks  TYPE tt_chunks
      RAISING   cx_static_check.

  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_response,
        bapi_name TYPE string,
        accepted  TYPE i,
        workers   TYPE i,
        mode      TYPE string,
      END OF ty_response.

ENDCLASS.


CLASS zcl_bapi_meta_v11_dispatch IMPLEMENTATION.

  METHOD dispatch.
    DATA(ls_request) = parse_request( iv_json ).

    IF ls_request-bapi_name IS INITIAL.
      RAISE EXCEPTION TYPE cx_parameter_invalid_range
        EXPORTING parameter = `bapi_name`
                  value     = `(empty)`.
    ENDIF.

    DATA(lv_total) = lines( ls_request-documents ).

    DATA(lv_workers) = resolve_workers( iv_docs_total  = lv_total
                                        iv_worker_rows = ls_request-worker_rows
                                        iv_worker_max  = ls_request-worker_threads ).

    DATA(lt_chunks) = split_documents( iv_bapi_name = ls_request-bapi_name
                                       it_documents = ls_request-documents
                                       iv_workers   = lv_workers ).

    DATA(lv_mode) = COND string( WHEN ls_request-mode = c_mode_sync THEN c_mode_sync
                                 ELSE c_mode_async ).

    dispatch_chunks( iv_workers = lv_workers
                     it_chunks  = lt_chunks ).

    rs_outcome = VALUE #(
      bapi_name     = ls_request-bapi_name
      accepted      = lv_total
      workers       = lv_workers
      mode          = lv_mode
      response_json = build_response( iv_bapi_name = ls_request-bapi_name
                                      iv_accepted  = lv_total
                                      iv_workers   = lv_workers
                                      iv_mode      = lv_mode ) ).
  ENDMETHOD.

  METHOD parse_request.
    xco_cp_json=>data->from_string( iv_json )->write_to( REF #( rs_request ) ).
  ENDMETHOD.

  METHOD resolve_workers.
    IF iv_docs_total <= 0.
      rv_result = 0.
      RETURN.
    ENDIF.

    DATA(lv_rows)   = COND i( WHEN iv_worker_rows > 0 THEN iv_worker_rows
                              ELSE c_default_rows ).
    DATA(lv_needed) = ( iv_docs_total + lv_rows - 1 ) DIV lv_rows.

    IF iv_worker_max > 0.
      rv_result = COND i( WHEN lv_needed < iv_worker_max THEN lv_needed
                          ELSE iv_worker_max ).
    ELSE.
      rv_result = lv_needed.
    ENDIF.
  ENDMETHOD.

  METHOD split_documents.
    DATA lt_chunk TYPE zif_bapi_meta_v11_executor=>tt_documents.
    DATA lv_bin   TYPE xstring.

    DATA(lv_total) = lines( it_documents ).
    IF iv_workers <= 0 OR lv_total = 0.
      RETURN.
    ENDIF.

    DATA(lv_size)      = ( lv_total + iv_workers - 1 ) DIV iv_workers.
    DATA(lv_processed) = 0.

    DO iv_workers TIMES.
      CLEAR lt_chunk.
      DATA(lv_end) = COND i( WHEN lv_processed + lv_size > lv_total THEN lv_total
                             ELSE lv_processed + lv_size ).

      LOOP AT it_documents INTO DATA(ls_doc) FROM lv_processed + 1 TO lv_end.
        APPEND ls_doc TO lt_chunk.
      ENDLOOP.

      IF lt_chunk IS NOT INITIAL.
        " Transporte binário nativo entre dispatcher e provider paralelo.
        EXPORT bapi_name = iv_bapi_name
               documents = lt_chunk
               TO DATA BUFFER lv_bin.
        APPEND lv_bin TO rt_chunks.
      ENDIF.

      lv_processed = lv_end.
      IF lv_processed >= lv_total.
        EXIT.
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD build_response.
    DATA(ls_resp) = VALUE ty_response( bapi_name = iv_bapi_name
                                       accepted  = iv_accepted
                                       workers   = iv_workers
                                       mode      = iv_mode ).
    rv_json = xco_cp_json=>data->from_abap( ls_resp )->to_string( ).
  ENDMETHOD.

  METHOD dispatch_chunks.
    IF iv_workers <= 0 OR it_chunks IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lo_provider) = CAST if_abap_parallel( NEW zcl_bapi_meta_v11_parallel_prv( ) ).
    DATA(lo_parallel) = NEW cl_abap_parallel( ).

    DATA lt_out TYPE cl_abap_parallel=>t_out_tab.

    " cl_abap_parallel = released substituto do aRFC clássico
    " (STARTING NEW TASK ... DESTINATION IN GROUP DEFAULT).
    " run_inline bloqueia até todos os workers terminarem.
    lo_parallel->run_inline(
      EXPORTING
        p_num_processes = iv_workers
        p_in_tab        = it_chunks
      IMPORTING
        p_out_tab       = lt_out
      CHANGING
        p_provider      = lo_provider ).
  ENDMETHOD.

ENDCLASS.

