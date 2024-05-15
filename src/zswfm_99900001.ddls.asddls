@ClientDependent: false
@AccessControl.authorizationCheck: #PRIVILEGED_ONLY
@EndUserText.label: 'Generated: Flex Workflow CDS for scenario WS99900001'
define table function ZSWFM_99900001
with parameters wf_id:sww_wiid
returns {
  key WorkflowId : sww_wiid;
  _WF_INITIATOR : SWP_INITIA;
  _WF_PRIORITY : SWW_PRIO;
  _WF_VERSION : SWD_VERSIO;
  LAST_ACTOR : ERNAM;
  IS_DATA : ZDE_WP_WF_ID;
  IS_NEW_STAT : ZASD;
  IS_ACTOR : ERNAM;
  __KEY1 : ZDE_WP_WF_ID;
  __KEY2 : ZWTN;

}
implemented by method ZCL_SWF_99900001=>read_meta;
