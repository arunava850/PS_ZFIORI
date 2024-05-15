@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EP Data'
@Metadata.allowExtensions: true
define root view entity ZFIAP_EP_DATA3
  as select from    zfiap_ep_pers    as ep_data
//  composition[1..*] of zfiap_ep_data_at as ep_att 
//    left outer join zfiap_ep_data_at as ep_att on ep_data.edi_trans_no = ep_att.edi_trans_no


{

  key ep_data.edi_trans_no               as edi_trans_no,
      ep_data.attachment                 as attachment,
      ep_data.edi_trans_date             as edi_trans_date,
      ep_data.request_type               as request_type,
      ep_data.approval_status            as approval_status,
      ep_data.tenant_number              as tenant_number,
      ep_data.tenant_name                as tenant_name,
      ep_data.payee_number               as payee_number,
      ep_data.payee_name                 as payee_name,
      ep_data.sales_date                 as sales_date,
      ep_data.gl_account                 as gl_account,
      ep_data.amount                     as Amount,
      ep_data.waers                      as Waers,
      ep_data.exp_remark                 as exp_remark,
      ep_data.invoice_number             as invoice_number,
      ep_data.business_unit_company_code as business_unit_company_code,
      ep_data.business_unit              as business_unit,
      ep_data.business_unit_state        as business_unit_state,
      ep_data.business_unit_country      as business_unit_country,
      ep_data.tenant_state               as tenant_state,
      ep_data.posting_date               as posting_date,
      ep_data.company_code               as company_code,
      ep_data.document_type              as document_type,
      ep_data.document_number            as document_number,
      ep_data.comment_                   as Comment_,
      ep_data.district                   as District,
      ep_data.senior_district            as senior_district,
      ep_data.region                     as Region,
      ep_data.senior_region              as senior_region,
      ep_data.division                   as Division,
      ep_data.zzone                      as Zzone,
      ep_data.escheat_rule               as escheat_rule,
      ep_data.remit_type                 as remit_type,
      ep_data.holding_period             as holding_period,
      ep_data.hp_uom                     as hp_uom,
      ep_data.pi_delay_period            as pi_delay_period,
      ep_data.hp_expire_date             as hp_expire_date,
      ep_data.tracker_sent_date          as tracker_sent_date,
      @Semantics.mimeType: true
      ep_data.mimetype                   as MIMETYPE,
      @Semantics.largeObject:
      { mimeType: 'MIMETYPE',
      fileName: 'attachment',
      contentDispositionPreference: #INLINE }
      ep_data.attfile                    as ATTFILE,
      ep_data.created_by                 as created_by,
      ep_data.create_date                as create_date,
      ep_data.create_time                as create_time,
      ep_data.changed_by                 as changed_by,
      ep_data.changed_date               as changed_date,
      ep_data.changed_time               as changed_time
}
