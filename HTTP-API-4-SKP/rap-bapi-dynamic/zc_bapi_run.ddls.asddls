@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dyn BAPI Runner - Execucao (Projection)'
@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZC_BAPI_RUN
  provider contract transactional_query
  as projection on ZR_BAPI_RUN as BapiRun
{
  key RunUuid,

      @Search.defaultSearchElement: true
      BapiName,

      ExecMode,
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
