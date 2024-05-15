@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
//@ObjectModel : { resultSet.sizeCategory: #XS }
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]
@AbapCatalog.viewEnhancementCategory: [#NONE]
@EndUserText.label: 'EP Data Tracker Pro'
@Metadata.ignorePropagatedAnnotations: true
//@OData.publish: true
define root view entity ZFIAP_EP_D_TR_PRO
  as select from    ZFIAP_EP_DATA2  as _edpdata
    left outer join zfiap_ep_rules  as _rules on _edpdata.business_unit_state = _rules.state
    left outer join ZFIAP_EP_LFA1_F as _lfa1  on _edpdata.payee_number = _lfa1.Lifnr
{
  key _edpdata.edi_trans_no,
      _edpdata.attachment,
      _edpdata.edi_trans_date,
      _edpdata.request_type,
      _edpdata.approval_status,
      _edpdata.tenant_number,
      _edpdata.tenant_name,
      _edpdata.payee_number,
      _edpdata.payee_name,
      _edpdata.sales_date,
      _edpdata.gl_account,
      @Semantics.amount.currencyCode : 'Waers'
      @UI.hidden: true
      _edpdata.Amount,
      concat_with_space( '$', cast( _edpdata.Amount as abap.char( 30 ) ), 1 ) as AmountStr,
      //cast( _edpdata.Amount as abap.char( 30 ) ) as AmountStr,
      _edpdata.Waers,
      _edpdata.exp_remark,
      _edpdata.invoice_number,
      _edpdata.business_unit_company_code,
//      SUBSTRING( lpad( cast (_edpdata.business_unit as abap.sstring( 10 )  ), 10, '0'), 6, 5 ) as business_unit,
//      case
//      when length(_edpdata.business_unit) < 5 then
//       lpad( _edpdata.business_unit, 5, '0')
//      else
//      _edpdata.business_unit
//      end as business_unit1,
//      ltrim(_edpdata.business_unit, '0') as business_unit,
//     length(ltrim(_edpdata.business_unit, '0')) as lbu,
     
     case
     when length(ltrim(_edpdata.business_unit, '0')) = 0
     then concat('000000', ltrim(_edpdata.business_unit, '0') ) 
          when length(ltrim(_edpdata.business_unit, '0')) = 1
     then concat('0000', ltrim(_edpdata.business_unit, '0') ) 
          when length(ltrim(_edpdata.business_unit, '0')) = 2
     then concat('000', ltrim(_edpdata.business_unit, '0') ) 
          when length(ltrim(_edpdata.business_unit, '0')) = 3
     then concat('00', ltrim(_edpdata.business_unit, '0') ) 
          when length(ltrim(_edpdata.business_unit, '0')) = 4
     then concat('0', ltrim(_edpdata.business_unit, '0') ) 
     else
     ltrim(_edpdata.business_unit, '0')
     end as business_unit,
     
//      SUBSTRING( lpad( _edpdata.business_unit, 10, '0'), 6, 5 ) as business_unit,
      @EndUserText.label: 'BU State'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
       entity: {
       name: 'ZFI_VH_US_Region',
        element: 'Region'
        }
        }]
      _edpdata.business_unit_state,
      _edpdata.business_unit_country,
      _edpdata.tenant_state,
      _edpdata.posting_date,
      _edpdata.company_code,
      _edpdata.document_type,
      _edpdata.document_number,
      _edpdata.Comment_,
      _edpdata.District,
      _edpdata.senior_district,
      _edpdata.Region,
      _edpdata.senior_region,
      _edpdata.Division,
      _edpdata.Zzone,
      _edpdata.escheat_rule,
      _edpdata.remit_type,
      _edpdata.holding_period,
      _edpdata.hp_uom,
      _edpdata.pi_delay_period,
      _edpdata.hp_expire_date,
      _edpdata.tracker_sent_date,
      _edpdata.MIMETYPE,
      _edpdata.ATTFILE,
      _edpdata.EpWfId,
      _edpdata.created_by,
      _edpdata. create_date,
      _edpdata.create_time,
      _edpdata.changed_by,
      _edpdata.changed_date,
      _edpdata.changed_time,
      _rules.prop_type_code,
      case
        when _lfa1.Stcd2 = ''
        then _lfa1.lastnnew
        else  _lfa1.fullname
        end                                                                   as Name2,
      case
        when _lfa1.Stcd2 = ''
        then _lfa1.firstn
        else  ''
        end                                                                   as Name1,
      // _lfa1.Name1,
      //  _lfa1.Name2,
      _lfa1.Name3,
      _lfa1.Stras,
      _lfa1.Title,
      _lfa1.StrSuppl1,
      _lfa1.Ort01,
      _lfa1.Regio,
      _lfa1.Pstlz,
      _lfa1.Country,
      _lfa1.Stcd1,
      _lfa1.Stcd2,
      case
      when _lfa1.Stcd2 = ''
      then _lfa1.Stcd1
      else  _lfa1.Stcd2
      end                                                                     as taxno,
      case  _edpdata.edi_trans_no
      when '0000000000' then ''
      else ''
      end                                                                     as checknumber,
      case
        when _lfa1.Stcd2 = ''
            then _lfa1.middlen
            else  ''
        end                                                                   as middle_name
}

where
      _edpdata.approval_status   = 'Pending'
  and _edpdata.escheat_rule      = 'Escheat Yes'
  and _edpdata.remit_type        = 'State'
  and _edpdata.tracker_sent_date is initial
