@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Hybrid BAPI Runner - Execution (Projection)'
@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZC_BAPI_HYB_RUN
  provider contract transactional_query
  as projection on ZR_BAPI_HYB_RUN as BapiRun
{
  key RunUuid,

      @Search.defaultSearchElement: true
      BapiName,

      ExecMode,
      Kind,
      WorkerThreads,
      WorkerRows,
      Accepted,
      Workers,
      Status,
      ErrorText,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
