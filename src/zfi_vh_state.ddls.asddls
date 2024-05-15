@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for State'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zfi_vh_state as select from I_PrepaymentRegionText {
//  key Country,
  key Region as State,
  // key Language,
  RegionName
  /* Associations */
 // _Country,
//  _Language,
 // _Region
 
}
where Country = 'US'
and Language  = 'E'
