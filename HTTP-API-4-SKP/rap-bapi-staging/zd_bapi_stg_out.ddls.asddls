@EndUserText.label: 'Staging BAPI Runner - Submit Result'
define abstract entity ZD_BAPI_STG_OUT
{
  key RunUuid   : sysuuid_x16;
      BapiName  : abap.char(30);
      Accepted  : abap.int4;
      Workers   : abap.int4;
      ExecMode  : abap.char(10);
}
