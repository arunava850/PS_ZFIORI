@EndUserText.label: 'Confirm'
@Metadata.allowExtensions: true

define abstract entity ZFIAP_EP_DATA_CON
{
  @Consumption.valueHelpDefinition: [ {
  entity          : {
  name            : 'ZFI_VH_CONFIRM',
  element         : 'CONF'
  }
  } ]
  @EndUserText.label: 'Confirmation'
  @UI.defaultValue: 'X'
  conf_val   : char1;

}
