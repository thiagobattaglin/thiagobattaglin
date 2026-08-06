"! <p class="shorttext synchronized">Unit tests for RAP BO ZR_EQUI_LOAD_REQ</p>
"!
"! Uses cl_cds_test_environment to swap the underlying tables for doubles,
"! so determinations run without touching the physical DB.

CLASS ltcl_load_req DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CLASS-DATA cds_env TYPE REF TO if_cds_test_environment.

    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.
    METHODS teardown.

    METHODS default_mode_is_async     FOR TESTING.
    METHODS default_status_is_new     FOR TESTING.
    METHODS explicit_mode_preserved   FOR TESTING.

    METHODS create_request
      IMPORTING iv_mode          TYPE c
                iv_worker_rows   TYPE i DEFAULT 0
      RETURNING VALUE(rv_uuid)   TYPE sysuuid_x16.

ENDCLASS.


CLASS ltcl_load_req IMPLEMENTATION.

  METHOD class_setup.
    cds_env = cl_cds_test_environment=>create(
      i_for_entities = VALUE #( ( 'ZR_EQUI_LOAD_REQ' )
                                ( 'ZR_EQUI_LOAD_ITM' ) ) ).
  ENDMETHOD.

  METHOD class_teardown.
    cds_env->destroy( ).
  ENDMETHOD.

  METHOD teardown.
    cds_env->clear_doubles( ).
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD create_request.

    MODIFY ENTITIES OF zr_equi_load_req
      ENTITY LoadReq
        CREATE FIELDS ( Mode WorkerRows )
          WITH VALUE #( ( %cid = 'X1' Mode = iv_mode WorkerRows = iv_worker_rows ) )
      MAPPED DATA(mapped)
      FAILED DATA(failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_initial(
      act = failed
      msg = 'Create must not fail' ).

    rv_uuid = mapped-loadreq[ 1 ]-RequestUuid.

  ENDMETHOD.

  METHOD default_mode_is_async.

    DATA(lv_uuid) = create_request( iv_mode = space ).

    READ ENTITIES OF zr_equi_load_req
      ENTITY LoadReq
      FIELDS ( Mode )
      WITH VALUE #( ( RequestUuid = lv_uuid ) )
      RESULT DATA(reqs).

    cl_abap_unit_assert=>assert_equals(
      exp = 'A'
      act = reqs[ 1 ]-Mode
      msg = 'Missing Mode must default to A (Async)' ).

  ENDMETHOD.

  METHOD default_status_is_new.

    DATA(lv_uuid) = create_request( iv_mode = 'A' ).

    READ ENTITIES OF zr_equi_load_req
      ENTITY LoadReq
      FIELDS ( Status )
      WITH VALUE #( ( RequestUuid = lv_uuid ) )
      RESULT DATA(reqs).

    cl_abap_unit_assert=>assert_equals(
      exp = 'N'
      act = reqs[ 1 ]-Status
      msg = 'Missing Status must default to N (New)' ).

  ENDMETHOD.

  METHOD explicit_mode_preserved.

    DATA(lv_uuid) = create_request( iv_mode = 'S' ).

    READ ENTITIES OF zr_equi_load_req
      ENTITY LoadReq
      FIELDS ( Mode )
      WITH VALUE #( ( RequestUuid = lv_uuid ) )
      RESULT DATA(reqs).

    cl_abap_unit_assert=>assert_equals(
      exp = 'S'
      act = reqs[ 1 ]-Mode
      msg = 'Caller-supplied Mode must not be overwritten' ).

  ENDMETHOD.

ENDCLASS.
