@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for State'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZFI_VH_ANLKA as select from ankt {
key spras as Spras,
key anlkl as Anlkl,
txk20 as Txk20,
txk50 as Txk50,
txt50 as Txt50,
txa50 as Txa50,
xltxid as Xltxid
 
}
where spras = 'E'

