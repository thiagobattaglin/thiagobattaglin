@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Staging BAPI Runner - Execution (Root)'
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: [ 'BapiName' ]

define root view entity ZR_BAPI_STG_RUN
  as select from zbapi_stg_run
{
  key run_uuid                       as RunUuid,

      bapi_name                      as BapiName,
      exec_mode                      as ExecMode,
      worker_threads                 as WorkerThreads,
      worker_rows                    as WorkerRows,
      accepted                       as Accepted,
      workers                        as Workers,
      status                         as Status,
      error_text                     as ErrorText,

      @Semantics.user.createdBy: true
      created_by                     as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at                     as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by                as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at          as LocalLastChangedAt
}
