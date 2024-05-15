@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EP Data'
@Metadata.allowExtensions: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
//@ObjectModel : { resultSet.sizeCategory: #XS }
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]
//@Metadata.ignorePropagatedAnnotations: true

define root view entity ZFIAP_EP_DATA2
  as select from    zfiap_ep_data      as ep_data
  //  composition[1..*] of zfiap_ep_data_at as ep_att
    left outer join zfiap_ep_data_at   as ep_att on ep_data.edi_trans_no = ep_att.edi_trans_no
    left outer join ZFIAP_EP_DATA_WF_V as ep_wf  on(
       ep_data.edi_trans_no = ep_wf.EdiTransNo
       and ep_wf.zinactive  = ''
     )



{

      //      @Search.defaultSearchElement: true
      //      @Consumption.valueHelpDefinition: [ {
      //       entity: {
      //       name: 'ZFIAP_EP_DATA2',
      //        element: 'edi_trans_no'
      //        }
      //        }]
  key ep_data.edi_trans_no               as edi_trans_no, //*******************
      ep_data.attachment                 as attachment,
      ep_data.edi_trans_date             as edi_trans_date,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
       entity: {
       name: 'ZFI_VH_REQ_TYPE',
        element: 'text'
        }
        }]
      //      //      @ObjectModel.foreignKey.association: '_ruletxt'
      @EndUserText.label: 'Request Type'
      // escheat_rule as Escheat_Rule,
      case  ep_data.request_type
       when '00' then 'Approval Not Yet Requested'
       when '01' then 'Immediate Pay'
       when '02' then 'Remit to Jurisdiction'
       when '03' then 'Tenant Requested'
       when '04' then 'Request for Rejection'
      // else ' '
       end                               as request_type,

      //      ep_data.request_type               as request_type,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
       entity: {
       name: 'ZFI_VH_APP_STAT',
        element: 'text'
        }
        }]
      //      //      @ObjectModel.foreignKey.association: '_ruletxt'
      @EndUserText.label: 'Request Type'
      // escheat_rule as Escheat_Rule,
      case  ep_data.approval_status
       when 'G' then 'AP Generated'
       when 'A' then 'Approved'
       when 'X' then 'Cancelled'
       when 'P' then 'Pending'
       when 'R' then 'Rejected'
       when 'H' then 'Sent Back for Revisions'
       when 'T' then 'Sent to Tracker'
       when 'S' then 'Submitted (for Approval)'
      // else ' '
       end                               as approval_status,
      //      ep_data.approval_status            as approval_status,
      @Consumption.valueHelpDefinition: [
      { entity:  { name:    'I_Supplier_VH',
               element: 'Supplier' }
      }]
      ep_data.tenant_number              as tenant_number,
      @Consumption.valueHelpDefinition: [
      { entity:  { name:    'I_Supplier_VH',
             element: 'SupplierName' }
      }]
      ep_data.tenant_name                as tenant_name,
      @Consumption.valueHelpDefinition: [
      { entity:  { name:    'I_Supplier_VH',
         element: 'Supplier' }
      }]
      ep_data.payee_number               as payee_number,
      @Consumption.valueHelpDefinition: [
      { entity:  { name:    'I_Supplier_VH',
       element: 'SupplierName' }
      }]
      ep_data.payee_name                 as payee_name,
      ep_data.sales_date                 as sales_date,
      @Consumption.valueHelpDefinition: [
      { entity:  { name:    'I_GLAccount',
      element: 'GLAccount' }
      }]
      ep_data.gl_account                 as gl_account,
      cast( ep_data.amount as abap.dec( 23, 2 ) )
                           as Amount,
      @Consumption.valueHelpDefinition: [
      { entity:  { name:    'I_Currency',
      element: 'Currency' }
      }]
      ep_data.waers                      as Waers,
      ep_data.exp_remark                 as exp_remark, //*******************
      @EndUserText.label: 'EP Invoice Number'
      @Consumption.valueHelpDefinition: [
      { entity:  { name:    'ZFI_VH_EP_INV',
      element: 'invoice_number' }
      }]
      ep_data.invoice_number             as invoice_number, //******************* Done
      @EndUserText.label: 'BU Company Code'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
       entity: {
       name: 'I_CompanyCodeStdVH',
        element: 'CompanyCode'
        }
        }]
      ep_data.business_unit_company_code as business_unit_company_code,
      @EndUserText.label: 'Business Unit'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
       entity: {
       name: 'I_ProfitCenter',
        element: 'ProfitCenter'
        }
        }]
      ep_data.business_unit              as business_unit,
      @EndUserText.label: 'BU State'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
       entity: {
      //       Change for JIRA issue SAP-1564
       name: 'ZFI_VH_US_Region',
        element: 'Region'
        }
        }]
      ep_data.business_unit_state        as business_unit_state,
      @EndUserText.label: 'BU County'
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'ZFI_VH_EP_BU_COUNTY',
        element: 'business_unit_country' }
        }]
      ep_data.business_unit_country      as business_unit_country, //*******************Done Not working
      @EndUserText.label: 'Tenant State'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
       entity: {
       name: 'I_Region',
        element: 'Region'
        }
        }]
      ep_data.tenant_state               as tenant_state,
      ep_data.posting_date               as posting_date,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
       entity: {
       name: 'ZFI_VH_EP_company_code',
        element: 'company_code'
        }
        }]
      ep_data.company_code               as company_code,

      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
       entity: {
       name: 'I_AccountingDocumentType',
        element: 'AccountingDocumentType'
        }
        }]

      ep_data.document_type              as document_type,
      ep_data.document_number            as document_number, //*******************
      ep_data.comment_                   as Comment_, //*******************
      @EndUserText.label: 'District'
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'ZFI_VH_EP_district',
        element: 'district' }
        }]
      ep_data.district                   as District, //*******************CEPC Done
      @EndUserText.label: 'Senior District'
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'ZFI_VH_EP_senior_district',
        element: 'senior_district' }
        }]
      ep_data.senior_district            as senior_district, //*******************CEPC Done
      @EndUserText.label: 'Region'
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'ZFI_VH_EP_Region',
        element: 'Region' }
        }]
      ep_data.region                     as Region, //*******************CEPC Done Not tested
      @EndUserText.label: 'Senior Region'
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'ZFI_VH_EP_senior_region',
        element: 'senior_region' }
        }]
      ep_data.senior_region              as senior_region, //*******************CEPC Done Not tested
      @EndUserText.label: 'Division'
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'ZFI_VH_EP_Division',
        element: 'Division' }
        }]
      ep_data.division                   as Division, //*******************CEPC Working
      @EndUserText.label: 'Zone'
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'ZFI_VH_EP_Zzone',
        element: 'Zzone' }
        }]
      ep_data.zzone                      as Zzone, //*******************CEPC Not tested
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
       entity: {
       name: 'ZFI_VH_ESCHEAT_RULES',
        element: 'Escheat_Rule'
        }
        }]
      //      @ObjectModel.foreignKey.association: '_ruletxt'
      @EndUserText.label: 'Escheat Rule'
      // escheat_rule as Escheat_Rule,
      case  ep_data.escheat_rule
       when 'I' then 'Send Immediate to Tenant'
       when 'Y' then 'Escheat Yes'
       when 'N' then 'Escheat No'
      // else ' '
       end                               as escheat_rule,

      //      ep_data.escheat_rule               as escheat_rule,

      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'ZFI_VH_REMIT',
         element: 'Remit_Type'
         }
      } ]

      @EndUserText.label: 'Remit Type'
      case ep_data.remit_type
      when 'S' then 'State'
      when 'C' then 'County'
      when ' ' then 'Does Not Escheat'
      when 'N' then 'Not been Researched'
      else ' '
      end                                as remit_type,

      //      ep_data.remit_type                 as remit_type,
      ep_data.holding_period             as holding_period,

      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
          entity: {
           name: 'ZFI_VH_HOLDING_PERIOD_UOM',
            element: 'HP_UOM'
            }
      } ]

      @EndUserText.label: 'Holding Period UOM'
      //hp_uom as hp_uom,
      //hp_uom as HP_UOM,
      case  ep_data.hp_uom
       when 'D' then 'Day'
       when 'M' then 'Month'
       when 'Y' then 'Year'
      // else ' '
       end                               as hp_uom,


      //      ep_data.hp_uom                     as hp_uom,
      ep_data.pi_delay_period            as pi_delay_period,
      ep_data.hp_expire_date             as hp_expire_date,
      ep_data.tracker_sent_date          as tracker_sent_date,
      @Semantics.mimeType: true
      ep_att.mimetype                    as MIMETYPE,
      @Semantics.largeObject:
      { mimeType: 'MIMETYPE',
      fileName: 'attachment',
      contentDispositionPreference: #INLINE }
      ep_att.attfile                     as ATTFILE,
      @EndUserText.label: 'WF Unique ID'
      ep_wf.EpWfId                       as EpWfId,
      @EndUserText.label: 'Created By'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
          entity: {
           name: 'ZFI_VH_EP_USER',
            element: 'bname'
            }
      } ]
      ep_data.created_by                 as created_by, //******************* Done Working
      @EndUserText.label: 'Creation Date'
      ep_data.create_date                as create_date,
      @EndUserText.label: 'Creation Time'
      ep_data.create_time                as create_time,
      @EndUserText.label: 'Last Changed By'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
          entity: {
           name: 'ZFI_VH_EP_USER',
            element: 'bname'
            }
      } ]
      ep_data.changed_by                 as changed_by, //******************* Done Working
      @EndUserText.label: 'Last Change Date'
      ep_data.changed_date               as changed_date,
      @EndUserText.label: 'Last Change Time'
      ep_data.changed_time               as changed_time 
}
