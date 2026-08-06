"! @testing BDEF:ZR_MIG_RUN
CLASS ltcl_mig_run DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA cds_test_environment TYPE REF TO if_cds_test_environment.
    CLASS-DATA sql_test_environment TYPE REF TO if_osql_test_environment.

    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.
    METHODS setup.
    METHODS teardown.

    METHODS refresh_syncs_from_ltmom  FOR TESTING RAISING cx_static_check.
    METHODS refresh_not_found_warns   FOR TESTING RAISING cx_static_check.
    METHODS mark_completed_ok         FOR TESTING RAISING cx_static_check.
    METHODS validate_missing_project  FOR TESTING RAISING cx_static_check.
    METHODS validate_invalid_phase    FOR TESTING RAISING cx_static_check.

    METHODS insert_run
      IMPORTING status        TYPE c
      RETURNING VALUE(result) TYPE zmig_run.

    METHODS insert_snapshot
      IMPORTING project_id    TYPE csequence
                object_id     TYPE csequence
                phase         TYPE csequence
                status        TYPE c
                total         TYPE i DEFAULT 100
                success       TYPE i DEFAULT 100
                error         TYPE i DEFAULT 0.

ENDCLASS.


CLASS ltcl_mig_run IMPLEMENTATION.

  METHOD class_setup.
    cds_test_environment =
      cl_cds_test_environment=>create(
        i_for_entities = VALUE #( ( 'ZR_MIG_RUN' ) ( 'ZR_LTMOM_PROJECT' ) ) ).
    sql_test_environment =
      cl_osql_test_environment=>create(
        i_dependency_list = VALUE #( ( 'ZMIG_RUN' ) ) ).
  ENDMETHOD.

  METHOD class_teardown.
    cds_test_environment->destroy( ).
    sql_test_environment->destroy( ).
  ENDMETHOD.

  METHOD setup.
    cds_test_environment->clear_doubles( ).
    sql_test_environment->clear_doubles( ).
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.


  METHOD insert_run.
    result = VALUE #(
      run_uuid    = cl_system_uuid=>create_uuid_x16_static( )
      project_id  = 'ZSKP_FI_HIST'
      subproject_id = 'ZSIN_MIG_M54'
      object_id   = 'Z_OPEN_ITEM_AP_M54'
      phase       = 'IMPORT'
      status      = status
      created_by  = sy-uname
      created_at  = utclong_current( ) ).
    sql_test_environment->insert_test_data( VALUE zmig_run( ( result ) ) ).
  ENDMETHOD.


  METHOD insert_snapshot.
    DATA snap TYPE zr_ltmom_project.
    snap-ProjectId    = project_id.
    snap-SubprojectId = 'ZSIN_MIG_M54'.
    snap-ObjectId     = object_id.
    snap-Phase        = phase.
    snap-Status       = status.
    snap-TotalRecs    = total.
    snap-SuccessRecs  = success.
    snap-ErrorRecs    = error.
    snap-LastMsg      = 'From LTMOM snapshot'.
    snap-StartedAt    = utclong_current( ).
    snap-FinishedAt   = utclong_current( ).

    cds_test_environment->insert_test_data(
      i_data = VALUE zr_ltmom_project=>tt_zr_ltmom_project( ( snap ) ) ).
  ENDMETHOD.


  METHOD refresh_syncs_from_ltmom.

    DATA(seed) = insert_run( status = 'R' ).

    insert_snapshot(
      project_id = seed-project_id
      object_id  = seed-object_id
      phase      = seed-phase
      status     = 'S'
      total      = 250
      success    = 249
      error      = 1 ).

    MODIFY ENTITIES OF zr_mig_run
      ENTITY MigRun
        EXECUTE Refresh FROM VALUE #( ( %key-RunUuid = seed-run_uuid ) )
      FAILED   DATA(failed)
      REPORTED DATA(reported)
      RESULT   DATA(result).

    cl_abap_unit_assert=>assert_initial( failed-migrun ).
    cl_abap_unit_assert=>assert_equals( act = result[ 1 ]-%param-Status      exp = 'S' ).
    cl_abap_unit_assert=>assert_equals( act = result[ 1 ]-%param-TotalRecs   exp = 250 ).
    cl_abap_unit_assert=>assert_equals( act = result[ 1 ]-%param-SuccessRecs exp = 249 ).
    cl_abap_unit_assert=>assert_equals( act = result[ 1 ]-%param-ErrorRecs   exp = 1 ).
  ENDMETHOD.


  METHOD refresh_not_found_warns.

    DATA(seed) = insert_run( status = 'R' ).
    " sem inserir snapshot -> warning esperado

    MODIFY ENTITIES OF zr_mig_run
      ENTITY MigRun
        EXECUTE Refresh FROM VALUE #( ( %key-RunUuid = seed-run_uuid ) )
      FAILED   DATA(failed)
      REPORTED DATA(reported)
      RESULT   DATA(result).

    cl_abap_unit_assert=>assert_initial( failed-migrun ).
    cl_abap_unit_assert=>assert_not_initial( reported-migrun ).
  ENDMETHOD.


  METHOD mark_completed_ok.

    DATA(seed) = insert_run( status = 'N' ).

    MODIFY ENTITIES OF zr_mig_run
      ENTITY MigRun
        EXECUTE MarkCompleted FROM VALUE #( ( %key-RunUuid = seed-run_uuid ) )
      FAILED   DATA(failed)
      REPORTED DATA(reported)
      RESULT   DATA(result).

    cl_abap_unit_assert=>assert_initial( failed-migrun ).
    cl_abap_unit_assert=>assert_equals( act = result[ 1 ]-%param-Status exp = 'S' ).
    cl_abap_unit_assert=>assert_not_initial( result[ 1 ]-%param-FinishedAt ).
  ENDMETHOD.


  METHOD validate_missing_project.

    MODIFY ENTITIES OF zr_mig_run
      ENTITY MigRun
        CREATE FIELDS ( ObjectId Phase )
        WITH VALUE #( ( %cid = 'C1' ObjectId = 'Z_OI' Phase = 'IMPORT' ) )
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    COMMIT ENTITIES RESPONSE OF zr_mig_run
      FAILED   DATA(commit_failed)
      REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_not_initial( commit_failed-migrun ).
  ENDMETHOD.


  METHOD validate_invalid_phase.

    MODIFY ENTITIES OF zr_mig_run
      ENTITY MigRun
        CREATE FIELDS ( ProjectId ObjectId Phase )
        WITH VALUE #( ( %cid = 'C1'
                        ProjectId = 'ZSKP_FI_HIST'
                        ObjectId  = 'Z_OI'
                        Phase     = 'FOOBAR' ) )
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    COMMIT ENTITIES RESPONSE OF zr_mig_run
      FAILED   DATA(commit_failed)
      REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_not_initial( commit_failed-migrun ).
  ENDMETHOD.

ENDCLASS.
