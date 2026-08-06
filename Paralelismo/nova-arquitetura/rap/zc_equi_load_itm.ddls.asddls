@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Equipment Load Item (Projection)'
@Metadata.allowExtensions: true

define view entity ZC_EQUI_LOAD_ITM
  as projection on ZR_EQUI_LOAD_ITM
{
  key RequestUuid,
  key ItemUuid,

      ItemNo,
      ExtId,
      EquiCategory,
      Descript,
      Eqtype,
      Maintplant,
      Planplant,
      Location,
      CostCenter,
      CompanyCode,
      StartUpDate,
      Manufacturer,
      ModelNumber,

      Equipment,
      ItemStatus,
      Message,

      LastChangedAt,

      _Request : redirected to parent ZC_EQUI_LOAD_REQ
}
