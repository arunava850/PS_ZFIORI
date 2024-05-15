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
@OData.publish: true


define view entity ZFI_TAN_PER_PROP

//as select from  anka             as _anka 
//inner join            t095             as _t095  on _anka.ktogr = _t095.ktogr
//inner join acdoca           as _acdoca on _acdoca.racct = _t095.ktansw
//    left outer join       tabwt            as _TABWT on _TABWT.bwasl = _acdoca.anbwa
//    left outer join       finsc_bttype_t   as _BT    on _BT.bttype = _acdoca.bttype
//    left outer join       finsc_custbttypt as _CUS   on _CUS.cbttype = _acdoca.cbttype
    
  as select distinct  from acdoca           as _acdoca
//    left outer join            t095             as _t095  on _acdoca.racct = _t095.ktansw
    left outer join            anla             as _anka  on 
//    _t095.ktogr = _anka.ktogr and 
    _acdoca.anln1 = _anka.anln1
    left outer join       tabwt            as _TABWT on _TABWT.bwasl = _acdoca.anbwa
    left outer join       finsc_bttype_t   as _BT    on _BT.bttype = _acdoca.bttype
    left outer join       finsc_custbttypt as _CUS   on _CUS.cbttype = _acdoca.cbttype
{
  key _acdoca.rldnr,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
       entity: {
       name: 'I_CompanyCode',
        element: 'CompanyCode'
        }
        }]
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
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
       entity: {
       name: 'ZFI_VH_ANLKA',
        element: 'Anlkl'
        }
        }]
      _acdoca.anlkl,
      _acdoca.anln1,
      _acdoca.bzdat,
      _acdoca.anbwa,
      _TABWT.bwatxt,

      _acdoca.blart,
      _acdoca.racct,
      _acdoca.prctr,
      _acdoca.bttype,
      _BT.txt  as BusTranCatDesc,
      _acdoca.cbttype,
      _CUS.txt as BusTranTypDesc,
      _acdoca.awref,
      _acdoca.rhcur,
      @Semantics.amount.currencyCode : 'RHCUR'
      _acdoca.hsl,
      _acdoca.drcrk,
      _acdoca.budat,
      _acdoca.bschl,
      _acdoca.zuonr,
      _acdoca.sgtxt,
      _acdoca.lifnr

}
where
 //     _t095.ktopl  = 'PSUS'
 // and 
  ( _TABWT.spras = 'E' or _acdoca.anbwa is initial )
  and ( _BT.langu    = 'E' or _acdoca.bttype is initial )
  and ( _CUS.langu   = 'E' or _acdoca.cbttype is initial )
  and _acdoca.anln1 is not initial
  and _acdoca.anlkl  is not initial
  
