@EndUserText.label: 'Hybrid BAPI Runner - Metadata'
define abstract entity ZD_BAPI_HYB_META
{
  key ServiceName    : abap.char(30);
      ServiceVersion : abap.char(10);
      OdataVersion   : abap.char(10);
      Endpoint       : abap.char(255);
      DispatchEngine : abap.char(20);
      DefaultWorkers : abap.int4;
      DefaultRows    : abap.int4;
      SupportedKinds : abap.char(100);
      SupportedModes : abap.char(50);
      PayloadFormat  : abap.string;
      Description    : abap.char(255);
}
