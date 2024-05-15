@AbapCatalog.sqlViewName: 'ZFIAPEPDAWF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for EP Data workflow'
define view  ZFIAP_EP_DATA_WF_V as select from zfiap_ep_wf as tab
{
    key ep_wf_id as EpWfId,
    key edi_trans_no as EdiTransNo,
    zinactive as zinactive,
    created_by as CreatedBy,
    create_date as CreateDate,
    create_time as CreateTime,
    changed_by as ChangedBy,
    changed_date as ChangedDate,
    changed_time as ChangedTime
}
