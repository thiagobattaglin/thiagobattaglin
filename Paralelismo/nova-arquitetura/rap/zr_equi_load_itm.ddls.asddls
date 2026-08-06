@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Equipment Load Item (Child)'
@Metadata.allowExtensions: true

define view entity ZR_EQUI_LOAD_ITM
  as select from zequi_load_itm
  association to parent ZR_EQUI_LOAD_REQ as _Request on $projection.RequestUuid = _Request.RequestUuid
{
  key request_uuid   as RequestUuid,
  key item_uuid      as ItemUuid,

      item_no        as ItemNo,
      ext_id         as ExtId,
      equi_category  as EquiCategory,
      descript       as Descript,
      eqtype         as Eqtype,
      maintplant     as Maintplant,
      planplant      as Planplant,
      location       as Location,
      cost_center    as CostCenter,
      company_code   as CompanyCode,
      start_up_date  as StartUpDate,
      manufacturer   as Manufacturer,
      model_number   as ModelNumber,

      equipment      as Equipment,
      item_status    as ItemStatus,
      message        as Message,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at as LastChangedAt,

      _Request
}
