@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Confirmation'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZFI_VH_CONFIRM
  as select from zfiap_ep_sh_txt
{
      //  key Country,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Confirmation Key'
  key value as CONF,
      // key Language,
      @EndUserText.label: 'Confirmation Description'
      text
      /* Associations */
      // _Country,
      //  _Language,
      // _Region
}
where
      field = 'CONF'
  and spras = 'E'
