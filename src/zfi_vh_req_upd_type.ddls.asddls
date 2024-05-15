@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Request Type'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZFI_VH_REQ_UPD_TYPE
  as select from zfiap_ep_sh_txt
{
      //  key Country,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Request Type'
  key value as REQUEST_TYPE,
      // key Language,
      @EndUserText.label: 'Request Type Description'
      text
      /* Associations */
      // _Country,
      //  _Language,
      // _Region
}
where
      field = 'REQ_TYP'
  and spras = 'E'
  and ( value = '02' or value = '03' or value = '04' )
