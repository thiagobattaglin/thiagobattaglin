@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dynamic Load Item (Child)'
@Metadata.allowExtensions: true

define view entity ZR_LOAD_ITM
  as select from zload_itm
  association to parent ZR_LOAD_REQ as _Request on $projection.RequestUuid = _Request.RequestUuid
{
  key request_uuid   as RequestUuid,
  key item_uuid      as ItemUuid,

      item_no        as ItemNo,
      ext_id         as ExtId,
      object_type    as ObjectType,
      fields_json    as FieldsJson,

      entity_id      as EntityId,
      item_status    as ItemStatus,
      message        as Message,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at as LastChangedAt,

      _Request
}
