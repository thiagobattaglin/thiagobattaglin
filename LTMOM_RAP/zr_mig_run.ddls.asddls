@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'LTMOM - Execucao (Root)'
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: [ 'ProjectId', 'ObjectId' ]

define root view entity ZR_MIG_RUN
  as select from zmig_run
{
  key run_uuid                       as RunUuid,

      project_id                     as ProjectId,
      subproject_id                  as SubprojectId,
      object_id                      as ObjectId,
      phase                          as Phase,
      status                         as Status,

      total_recs                     as TotalRecs,
      success_recs                   as SuccessRecs,
      error_recs                     as ErrorRecs,
      last_msg                       as LastMsg,

      @Semantics.user.createdBy: true
      created_by                     as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at                     as CreatedAt,

      started_at                     as StartedAt,
      finished_at                    as FinishedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by                as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at          as LocalLastChangedAt
}
