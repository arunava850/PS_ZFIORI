@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for Holding Period UOM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity zfi_vh_holding_period_uom as select  distinct from ZFIAP_EP_RULETXT_ENTITY {
    key hp_uom as  HP_UOM_Text, 
   case  hp_uom   
  when 'D' then 'Day'
  when 'M' then 'Month'
  when 'Y' then 'Year'
  else ' ' end  as  HP_UOM
}
