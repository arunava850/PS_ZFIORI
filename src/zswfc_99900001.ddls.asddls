@AbapCatalog.sqlViewName: 'ZSWF99900001'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #PRIVILEGED_ONLY
@EndUserText.label: 'Generated: Flex Workflow CDS for scenario WS99900001'
@ObjectModel: {
  usageType.serviceQuality: #X,
  usageType.sizeCategory: #S,
  usageType.dataClass: #MASTER
}
@ClientHandling.algorithm: #SESSION_VARIABLE
define view ZSWFC_99900001
with parameters wf_id:sww_wiid
as select from ZSWFM_99900001(wf_id:$parameters.wf_id) as MetaData
association [0..1] to ZFIAP_EP_DATA_WF_V as __LEADING_OBJECT on
  __LEADING_OBJECT.EPWFID = $projection.S____KEY1
  AND
  __LEADING_OBJECT.EDITRANSNO = $projection.S____KEY2
association [0..1] to ZFIAP_EP_DATA_WF_V as _REQUEST_IN_EP_DATA on
  _REQUEST_IN_EP_DATA.EPWFID = $projection.S____KEY1
  AND
  _REQUEST_IN_EP_DATA.EDITRANSNO = $projection.S____KEY2


{
  key MetaData.WorkflowId
  , MetaData._WF_INITIATOR AS S___WF_INITIATOR
  , MetaData._WF_PRIORITY AS S___WF_PRIORITY
  , MetaData._WF_VERSION AS S___WF_VERSION
  , MetaData.LAST_ACTOR AS LAST_ACTOR
  , MetaData.IS_DATA AS IS_DATA
  , MetaData.IS_NEW_STAT AS IS_NEW_STAT
  , MetaData.IS_ACTOR AS IS_ACTOR
  , __LEADING_OBJECT
  , _REQUEST_IN_EP_DATA
  , MetaData.__KEY1 as S____KEY1 // REQUEST_IN_EP_DATA.EPWFID
  , MetaData.__KEY2 as S____KEY2 // REQUEST_IN_EP_DATA.EDITRANSNO
}
where MetaData.WorkflowId = $parameters.wf_id;
