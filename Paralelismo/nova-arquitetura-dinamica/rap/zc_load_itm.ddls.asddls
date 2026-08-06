@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dynamic Load Item (Projection)'
@Metadata.allowExtensions: true

define view entity ZC_LOAD_ITM
  as projection on ZR_LOAD_ITM
{
  key RequestUuid,
  key ItemUuid,

      ItemNo,
      ExtId,
      ObjectType,
      FieldsJson,

      EntityId,
      ItemStatus,
      Message,

      LastChangedAt,

      _Request : redirected to parent ZC_LOAD_REQ
}
