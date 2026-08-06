@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Equipment Load Request (Projection)'
@Metadata.allowExtensions: true

@Search.searchable: true

define root view entity ZC_EQUI_LOAD_REQ
  provider contract transactional_query
  as projection on ZR_EQUI_LOAD_REQ
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

      _Items : redirected to composition child ZC_EQUI_LOAD_ITM
}
