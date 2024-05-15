@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for REquest Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZFI_VH_APP_STAT
  as select from zfiap_ep_sh_txt
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Approval Status'
  key value as APPROVAL_STATUS,
      @EndUserText.label: 'Approval Status Description'
      text
      
}
where
      field = 'APP_STAT'
  and spras = 'E'
