@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Escheat Rules value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
//define view entity zfi_vh_escheat_rules as select distinct from zfiap_ep_rules {
define view entity zfi_vh_escheat_rules 
as select distinct from ZFIAP_EP_RULETXT_ENTITY
 {
key   Escheat_Rule as Escheat_Rule_Text  ,
  case  Escheat_Rule  
  when 'I' then 'Send Immediate to Tenant'
  when 'Y' then 'Escheat Yes'
  when 'N' then 'Escheat No' 
  //else ''
  end as    Escheat_Rule
  
   }
   
where _RULETXT.spras = 'E'
