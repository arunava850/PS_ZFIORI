@EndUserText.label: 'Attach Entity'
@Metadata.allowExtensions: true

define abstract entity ZFIAP_EP_DATA_upd
{
  @Consumption.valueHelpDefinition: [ {
  entity          : {
  name            : 'ZFI_VH_REQ_UPD_TYPE',
  element         : 'REQUEST_TYPE'
  }
  } ]
  @EndUserText.label: 'Request Type'
  REQUEST_TYPE    : zrtd;
  @Consumption.valueHelpDefinition: [ {
   entity         : {
   name           : 'ZFI_VH_APP_UPD_STAT',
  element         : 'APPROVAL_STATUS'
  }
  } ]
  @EndUserText.label: 'Approval Status'

  APPROVAL_STATUS : zasd;
  @Consumption.valueHelpDefinition: [ {
   entity         : {
   name           : 'ZFI_VH_SUPPLIER',
  element         : 'Supplier'
  }
  } ]
  @EndUserText.label: 'Payee Number'
  payee_number    : zpayee;

  @Consumption.valueHelpDefinition: [ {
  entity          : {
  name            : 'ZFI_VH_CONFIRM',
  element         : 'CONF'
  }
  } ]
  @EndUserText.label: 'For Remit to Jur -> Confirm Payee Number'
  @UI.defaultValue: ' '
  conf_val        : char1;


  //  @UI.hidden      : true
  //  attachment      : zatch1;
  //  @UI.hidden      : true
  //  @Semantics.mimeType: true
  //  mimetype        : zmimetype;
  //  @Semantics.largeObject:
  //  { mimeType      : 'mimetype',
  //  fileName        : 'attachment',
  //  contentDispositionPreference: #INLINE }
  //  attfile         : zattfile;

}
