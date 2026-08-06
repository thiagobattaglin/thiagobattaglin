@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dynamic Load Request (Projection)'
@Metadata.allowExtensions: true

define root view entity ZC_LOAD_REQ
  provider contract transactional_query
  as projection on ZR_LOAD_REQ
{
  key RequestUuid,

      Mode,
      WorkerRows,
      Status,
      TotalItems,
      Workers,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Items : redirected to composition child ZC_LOAD_ITM
}
