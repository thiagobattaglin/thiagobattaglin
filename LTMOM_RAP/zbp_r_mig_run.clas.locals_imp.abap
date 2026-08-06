*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhc_mig_run DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR MigRun RESULT result.

    METHODS set_initial_status FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MigRun~setInitialStatus.

    METHODS check_project FOR VALIDATE ON SAVE
      IMPORTING keys FOR MigRun~checkProject.

    METHODS refresh FOR MODIFY
      IMPORTING keys FOR ACTION MigRun~Refresh RESULT result.

    METHODS mark_completed FOR MODIFY
      IMPORTING keys FOR ACTION MigRun~MarkCompleted RESULT result.

    "! Le uma linha da CDS de snapshot do LTMOM. Retorna abap_false
    "! se o projeto/objeto nao existir na base do Cockpit.
    METHODS read_ltmom_snapshot
      IMPORTING project_id    TYPE csequence
                subproject_id TYPE csequence
                object_id     TYPE csequence
                phase         TYPE csequence
      EXPORTING snapshot      TYPE zr_ltmom_project
                found         TYPE abap_bool.

ENDCLASS.


CLASS lhc_mig_run IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zr_mig_run IN LOCAL MODE
      ENTITY MigRun
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(runs)
      FAILED failed.

    result = VALUE #(
      FOR run IN runs (
        %tky                    = run-%tky

        %action-Refresh         = if_abap_behv=>fc-o-enabled

        %action-MarkCompleted   = COND #( WHEN run-Status = 'S' OR run-Status = 'C'
                                          THEN if_abap_behv=>fc-o-disabled
                                          ELSE if_abap_behv=>fc-o-enabled )
      ) ).

  ENDMETHOD.


  METHOD set_initial_status.

    READ ENTITIES OF zr_mig_run IN LOCAL MODE
      ENTITY MigRun
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(runs).

    MODIFY ENTITIES OF zr_mig_run IN LOCAL MODE
      ENTITY MigRun
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR run IN runs
                      ( %tky   = run-%tky
                        Status = COND #( WHEN run-Status IS INITIAL
                                         THEN 'N'
                                         ELSE run-Status ) ) )
      REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.


  METHOD check_project.

    READ ENTITIES OF zr_mig_run IN LOCAL MODE
      ENTITY MigRun
      FIELDS ( ProjectId ObjectId Phase )
      WITH CORRESPONDING #( keys )
      RESULT DATA(runs).

    LOOP AT runs INTO DATA(run).

      IF run-ProjectId IS INITIAL.
        APPEND VALUE #( %tky = run-%tky ) TO failed-migrun.
        APPEND VALUE #( %tky = run-%tky
                        %msg = new_message( id       = 'ZMIG_MSG'
                                            number   = '010'
                                            severity = if_abap_behv_message=>severity-error )
                        %element-ProjectId = if_abap_behv=>mk-on
                      ) TO reported-migrun.
      ENDIF.

      IF run-ObjectId IS INITIAL.
        APPEND VALUE #( %tky = run-%tky ) TO failed-migrun.
        APPEND VALUE #( %tky = run-%tky
                        %msg = new_message( id       = 'ZMIG_MSG'
                                            number   = '011'
                                            severity = if_abap_behv_message=>severity-error )
                        %element-ObjectId = if_abap_behv=>mk-on
                      ) TO reported-migrun.
      ENDIF.

      IF run-Phase IS INITIAL OR
         ( run-Phase <> 'STAGING' AND run-Phase <> 'CONVERT'
           AND run-Phase <> 'SIMUL' AND run-Phase <> 'IMPORT' ).
        APPEND VALUE #( %tky = run-%tky ) TO failed-migrun.
        APPEND VALUE #( %tky = run-%tky
                        %msg = new_message( id       = 'ZMIG_MSG'
                                            number   = '012'
                                            v1       = CONV #( run-Phase )
                                            severity = if_abap_behv_message=>severity-error )
                        %element-Phase = if_abap_behv=>mk-on
                      ) TO reported-migrun.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD refresh.

    READ ENTITIES OF zr_mig_run IN LOCAL MODE
      ENTITY MigRun
      FIELDS ( ProjectId SubprojectId ObjectId Phase )
      WITH CORRESPONDING #( keys )
      RESULT DATA(runs).

    LOOP AT runs INTO DATA(run).

      read_ltmom_snapshot(
        EXPORTING project_id    = run-ProjectId
                  subproject_id = run-SubprojectId
                  object_id     = run-ObjectId
                  phase         = run-Phase
        IMPORTING snapshot      = DATA(snap)
                  found         = DATA(found) ).

      IF found = abap_false.
        APPEND VALUE #( %tky = run-%tky
                        %msg = new_message( id       = 'ZMIG_MSG'
                                            number   = '022'
                                            v1       = CONV #( run-ProjectId )
                                            v2       = CONV #( run-ObjectId )
                                            severity = if_abap_behv_message=>severity-warning )
                      ) TO reported-migrun.
        CONTINUE.
      ENDIF.

      MODIFY ENTITIES OF zr_mig_run IN LOCAL MODE
        ENTITY MigRun
          UPDATE FIELDS ( Status TotalRecs SuccessRecs ErrorRecs
                          LastMsg StartedAt FinishedAt )
          WITH VALUE #( ( %tky        = run-%tky
                          Status      = snap-Status
                          TotalRecs   = snap-TotalRecs
                          SuccessRecs = snap-SuccessRecs
                          ErrorRecs   = snap-ErrorRecs
                          LastMsg     = snap-LastMsg
                          StartedAt   = snap-StartedAt
                          FinishedAt  = snap-FinishedAt ) ).

      APPEND VALUE #( %tky = run-%tky
                      %msg = new_message( id       = 'ZMIG_MSG'
                                          number   = '021'
                                          v1       = CONV #( snap-Status )
                                          severity = if_abap_behv_message=>severity-information )
                    ) TO reported-migrun.

    ENDLOOP.

    READ ENTITIES OF zr_mig_run IN LOCAL MODE
      ENTITY MigRun ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(final_runs).

    result = VALUE #( FOR r IN final_runs
                      ( %tky = r-%tky %param = r ) ).

  ENDMETHOD.


  METHOD mark_completed.

    READ ENTITIES OF zr_mig_run IN LOCAL MODE
      ENTITY MigRun
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(runs).

    MODIFY ENTITIES OF zr_mig_run IN LOCAL MODE
      ENTITY MigRun
        UPDATE FIELDS ( Status FinishedAt )
        WITH VALUE #( FOR run IN runs
                      ( %tky       = run-%tky
                        Status     = 'S'
                        FinishedAt = utclong_current( ) ) ).

    LOOP AT runs INTO DATA(run).
      APPEND VALUE #( %tky = run-%tky
                      %msg = new_message( id       = 'ZMIG_MSG'
                                          number   = '023'
                                          severity = if_abap_behv_message=>severity-success )
                    ) TO reported-migrun.
    ENDLOOP.

    READ ENTITIES OF zr_mig_run IN LOCAL MODE
      ENTITY MigRun ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(final_runs).

    result = VALUE #( FOR r IN final_runs
                      ( %tky = r-%tky %param = r ) ).

  ENDMETHOD.


  METHOD read_ltmom_snapshot.

    CLEAR: snapshot, found.

    SELECT SINGLE FROM zr_ltmom_project
      FIELDS *
      WHERE ProjectId    = @project_id
        AND SubprojectId = @subproject_id
        AND ObjectId     = @object_id
        AND Phase        = @phase
      INTO @snapshot.

    IF sy-subrc = 0.
      found = abap_true.
    ENDIF.

  ENDMETHOD.

ENDCLASS.


"===================================================================
" Saver – managed BO: sem logica adicional.
"===================================================================
CLASS lsc_zr_mig_run DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save              REDEFINITION.
    METHODS cleanup           REDEFINITION.
    METHODS cleanup_finalize  REDEFINITION.
ENDCLASS.


CLASS lsc_zr_mig_run IMPLEMENTATION.
  METHOD finalize.
  ENDMETHOD.
  METHOD check_before_save.
  ENDMETHOD.
  METHOD save.
  ENDMETHOD.
  METHOD cleanup.
  ENDMETHOD.
  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
