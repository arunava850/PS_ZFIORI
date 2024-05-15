@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Remit Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]
define view entity zfi_vh_remit as select distinct from ZFIAP_EP_RULETXT_ENTITY { 
  key  remit_type   as Remit_Type_Text, 
  case remit_type
   when 'S' then 'State'
  when 'C' then 'County'
  when ' ' then 'Does Not Escheat'
  when 'N' then 'Not been Researched' 
  else ' ' 
  end as    Remit_Type 
  
 
} 

where language = 'E'
