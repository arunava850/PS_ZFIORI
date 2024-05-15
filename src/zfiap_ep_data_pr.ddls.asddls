@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection on EP Data'
define root view entity ZFIAP_EP_DATA_PR as projection on ZFIAP_EP_DATA_ATT
//association to parent target_data_source_name as _association_name
//    on $projection.element_name = _association_name.target_element_name
{
    key edi_trans_no,
    attachment,
    edi_trans_date,
    request_type,
    approval_status,
    tenant_number,
    tenant_name,
    payee_number,
    payee_name,
    sales_date,
    gl_account,
    Amount,
    Waers,
    exp_remark,
    invoice_number,
    business_unit_company_code,
    business_unit,
    business_unit_state,
    business_unit_country,
    tenant_state,
    posting_date,
    company_code,
    document_type,
    document_number,
    Comment_,
    District,
    senior_district,
    Region,
    senior_region,
    Division,
    Zzone,
    escheat_rule,
    remit_type,
    holding_period,
    hp_uom,
    pi_delay_period,
    hp_expire_date,
    tracker_sent_date,
    created_by,
    create_date,
    create_time,
    changed_by,
    changed_date,
    changed_time
    /* Associations */
//    _ep_att: redirected to ZFIAP_EP_AT_VP
//    _association_name // Make association public
}
