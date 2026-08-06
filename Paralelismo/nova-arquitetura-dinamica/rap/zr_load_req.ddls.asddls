@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dynamic Load Request (Root)'
@Metadata.allowExtensions: true

define root view entity ZR_LOAD_REQ
  as select from zload_req
  composition [0..*] of ZR_LOAD_ITM as _Items
{
  key request_uuid                  as RequestUuid,

      mode                          as Mode,
      worker_rows                   as WorkerRows,
      status                        as Status,
      total_items                   as TotalItems,
      workers                       as Workers,

      @Semantics.user.createdBy: true
      created_by                    as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at                    as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by               as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at               as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at         as LocalLastChangedAt,

      _Items
}
