"! Unit tests for zcl_bapi_dyn_dispatcher.
"! Include belongs to the class as testclass include.

"! Test subclass that captures dispatch instead of firing RFC tasks.
CLASS lcl_spy_dispatcher DEFINITION
  INHERITING FROM zcl_bapi_dyn_dispatcher
  FOR TESTING.

  PUBLIC SECTION.
    DATA mv_bapi     TYPE string.
    DATA mv_mode     TYPE string.
    DATA mt_captured TYPE string_table.

  PROTECTED SECTION.
    METHODS dispatch_chunks REDEFINITION.
ENDCLASS.


CLASS lcl_spy_dispatcher IMPLEMENTATION.
  METHOD dispatch_chunks.
    mv_bapi     = iv_bapi_name.
    mv_mode     = iv_mode.
    mt_captured = it_chunks.
  ENDMETHOD.
ENDCLASS.


CLASS ltc_dispatcher DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS setup.
    METHODS defaults_when_missing         FOR TESTING.
    METHODS keeps_provided_worker_values  FOR TESTING.
    METHODS calc_workers_single_doc       FOR TESTING.
    METHODS calc_workers_capped_by_max    FOR TESTING.
    METHODS calc_workers_uses_needed      FOR TESTING.
    METHODS split_even                    FOR TESTING.
    METHODS split_uneven                  FOR TESTING.
    METHODS split_zero_workers            FOR TESTING.
    METHODS documents_from_single_payload FOR TESTING.
    METHODS documents_from_bulk_array     FOR TESTING.
    METHODS build_response_shape          FOR TESTING.
    METHODS dispatch_end_to_end           FOR TESTING.
    METHODS dispatch_missing_bapi_raises  FOR TESTING.

    DATA mo_cut TYPE REF TO lcl_spy_dispatcher.

    METHODS sample_single_doc_json
      RETURNING VALUE(rv_json) TYPE string.
ENDCLASS.


CLASS ltc_dispatcher IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW lcl_spy_dispatcher( ).
  ENDMETHOD.

  METHOD defaults_when_missing.
    cl_abap_unit_assert=>assert_equals(
      exp = zcl_bapi_dyn_dispatcher=>c_default_workers
      act = mo_cut->normalize_positive( iv_value = 0
                                        iv_default = zcl_bapi_dyn_dispatcher=>c_default_workers ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = zcl_bapi_dyn_dispatcher=>c_default_rows
      act = mo_cut->normalize_positive( iv_value = -5
                                        iv_default = zcl_bapi_dyn_dispatcher=>c_default_rows ) ).
  ENDMETHOD.

  METHOD keeps_provided_worker_values.
    cl_abap_unit_assert=>assert_equals(
      exp = 10
      act = mo_cut->normalize_positive( iv_value = 10 iv_default = 4 ) ).
  ENDMETHOD.

  METHOD calc_workers_single_doc.
    cl_abap_unit_assert=>assert_equals(
      exp = 1
      act = mo_cut->calculate_workers( iv_docs_total = 1
                                       iv_worker_rows = 5000
                                       iv_worker_max  = 10 ) ).
  ENDMETHOD.

  METHOD calc_workers_capped_by_max.
    " 100000 / 5000 = 20 needed, capped at 4.
    cl_abap_unit_assert=>assert_equals(
      exp = 4
      act = mo_cut->calculate_workers( iv_docs_total  = 100000
                                       iv_worker_rows = 5000
                                       iv_worker_max  = 4 ) ).
  ENDMETHOD.

  METHOD calc_workers_uses_needed.
    " 12000 / 5000 = ceil(2.4) = 3, below max=10.
    cl_abap_unit_assert=>assert_equals(
      exp = 3
      act = mo_cut->calculate_workers( iv_docs_total  = 12000
                                       iv_worker_rows = 5000
                                       iv_worker_max  = 10 ) ).
  ENDMETHOD.

  METHOD split_even.
    DATA lt_docs TYPE zcl_bapi_dyn_dispatcher=>tt_documents.
    DO 4 TIMES.
      APPEND VALUE #( ) TO lt_docs.
    ENDDO.

    DATA(lt_chunks) = mo_cut->split_documents( it_documents = lt_docs iv_workers = 2 ).
    cl_abap_unit_assert=>assert_equals( exp = 2 act = lines( lt_chunks ) ).
  ENDMETHOD.

  METHOD split_uneven.
    DATA lt_docs TYPE zcl_bapi_dyn_dispatcher=>tt_documents.
    DO 5 TIMES.
      APPEND VALUE #( ) TO lt_docs.
    ENDDO.

    DATA(lt_chunks) = mo_cut->split_documents( it_documents = lt_docs iv_workers = 2 ).
    " 5 docs across 2 workers -> chunks of size 3 and 2.
    cl_abap_unit_assert=>assert_equals( exp = 2 act = lines( lt_chunks ) ).
  ENDMETHOD.

  METHOD split_zero_workers.
    DATA lt_docs TYPE zcl_bapi_dyn_dispatcher=>tt_documents.
    APPEND VALUE #( ) TO lt_docs.
    DATA(lt_chunks) = mo_cut->split_documents( it_documents = lt_docs iv_workers = 0 ).
    cl_abap_unit_assert=>assert_initial( lt_chunks ).
  ENDMETHOD.

  METHOD documents_from_single_payload.
    DATA ls_req TYPE zcl_bapi_dyn_dispatcher=>ty_request.
    APPEND VALUE #( value = `poheader` ) TO ls_req-heders_values.

    DATA(lt) = mo_cut->documents_from_request( ls_req ).
    cl_abap_unit_assert=>assert_equals( exp = 1 act = lines( lt ) ).
  ENDMETHOD.

  METHOD documents_from_bulk_array.
    DATA ls_req TYPE zcl_bapi_dyn_dispatcher=>ty_request.
    DO 3 TIMES.
      APPEND VALUE #( ) TO ls_req-documents.
    ENDDO.

    DATA(lt) = mo_cut->documents_from_request( ls_req ).
    cl_abap_unit_assert=>assert_equals( exp = 3 act = lines( lt ) ).
  ENDMETHOD.

  METHOD build_response_shape.
    DATA(lv) = mo_cut->build_response( iv_bapi_name = `BAPI_PO_CREATE1`
                                       iv_accepted  = 12000
                                       iv_workers   = 3
                                       iv_mode      = `async` ).

    cl_abap_unit_assert=>assert_char_cp( exp = `*"bapi_name":"BAPI_PO_CREATE1"*` act = lv ).
    cl_abap_unit_assert=>assert_char_cp( exp = `*"accepted":12000*`              act = lv ).
    cl_abap_unit_assert=>assert_char_cp( exp = `*"workers":3*`                   act = lv ).
    cl_abap_unit_assert=>assert_char_cp( exp = `*"mode":"async"*`                act = lv ).
  ENDMETHOD.

  METHOD dispatch_end_to_end.
    DATA(ls_outcome) = mo_cut->dispatch( sample_single_doc_json( ) ).

    cl_abap_unit_assert=>assert_equals( exp = `BAPI_PO_CREATE1` act = ls_outcome-bapi_name ).
    cl_abap_unit_assert=>assert_equals( exp = 1                 act = ls_outcome-accepted ).
    cl_abap_unit_assert=>assert_equals( exp = 1                 act = ls_outcome-workers ).
    cl_abap_unit_assert=>assert_equals( exp = `async`           act = ls_outcome-mode ).

    " The spy captured the dispatched chunks.
    cl_abap_unit_assert=>assert_equals( exp = `BAPI_PO_CREATE1` act = mo_cut->mv_bapi ).
    cl_abap_unit_assert=>assert_equals( exp = 1                 act = lines( mo_cut->mt_captured ) ).
  ENDMETHOD.

  METHOD dispatch_missing_bapi_raises.
    TRY.
        mo_cut->dispatch( `{"mode":"async"}` ).
        cl_abap_unit_assert=>fail( msg = `Expected cx_parameter_invalid_range` ).
      CATCH cx_parameter_invalid_range ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD sample_single_doc_json.
    rv_json =
      `{"mode":"async","bapi_name":"BAPI_PO_CREATE1","worker_threads":10,"worker_rows":5000,` &&
      `"heders_values":[{"value":"poheader","fields":[{"name":"po_number","value":"4500000001"}]}],` &&
      `"items_values":[{"value":"bapimepoitem","fields":[{"name":"po_item","value":"00010"}]}]}`.
  ENDMETHOD.

ENDCLASS.
