@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'LTMOM - Execucao (Projection)'
@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZC_MIG_RUN
  provider contract transactional_query
  as projection on ZR_MIG_RUN as MigRun
{
  key RunUuid,

      @Search.defaultSearchElement: true
      ProjectId,
      SubprojectId,

      @Search.defaultSearchElement: true
      ObjectId,

      Phase,
      Status,

      TotalRecs,
      SuccessRecs,
      ErrorRecs,
      LastMsg,

      CreatedBy,
      CreatedAt,
      StartedAt,
      FinishedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
