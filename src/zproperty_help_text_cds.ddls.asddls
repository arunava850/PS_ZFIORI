//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for preperty text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZProperty_help_text_cds
  as select from zproperty_help
{
  key keyfield    as Keyfield,
  key code        as Code,
      description as Description

}
where in_active_flag = ''
