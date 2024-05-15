@AbapCatalog.viewEnhancementCategory: [#NONE]
@EndUserText.label: 'CDS view for Tangible Personal Property'
@Metadata.ignorePropagatedAnnotations: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]



define view entity ZFI_TAN_PER_GL

  //as select from  anka             as _anka
  //inner join            t095             as _t095  on _anka.ktogr = _t095.ktogr
  //inner join acdoca           as _acdoca on _acdoca.racct = _t095.ktansw
  //    left outer join       tabwt            as _TABWT on _TABWT.bwasl = _acdoca.anbwa
  //    left outer join       finsc_bttype_t   as _BT    on _BT.bttype = _acdoca.bttype
  //    left outer join       finsc_custbttypt as _CUS   on _CUS.cbttype = _acdoca.cbttype

  as select distinct from acdoca as _acdoca
    inner join            t095   as _t095 on _acdoca.racct = _t095.ktansw
{
  key _acdoca.rldnr,
  key _acdoca.rbukrs,
  key _acdoca.belnr,
      //      @Search.defaultSearchElement: true
      //      @Consumption.valueHelpDefinition: [ {
      //       entity: {
      //       name: 'ZFI_VH_ANLKA',
      //        element: 'Anlkl'
      //        }
      //        }]
  key _acdoca.gjahr,
  key _acdoca.docln,
      _acdoca.anln1,
      _acdoca.racct 


}
where
  _t095.ktopl = 'PSUS'
  and _acdoca.anln1 is not initial
// and
//  _TABWT.spras = 'E'
//  and _BT.langu    = 'E'
//  and _CUS.langu   = 'E'
