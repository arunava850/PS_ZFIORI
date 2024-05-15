@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EP Rules Entity'
//@ObjectModel.createEnabled: true
//@ObjectModel.updateEnabled: true
//@ObjectModel.deleteEnabled: true
@Metadata.allowExtensions: true
//@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
//@ObjectModel : { resultSet.sizeCategory: #XS } 
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZFIAP_EP_RULES_ENTITY 
as select from zfiap_ep_rules
//association[0..1] to ZFIAP_EP_RULETXT_ENTITY as _ruletxt on $projection.State = zfiap_ep_rules.state
{
      @Consumption.valueHelpDefinition: [ {
       entity: {
       name: 'ZFI_VH_STATE',
      element: 'State'
     }
    } ]

      @EndUserText.label: 'State'
      key state          as State,
      
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
 case  escheat_rule  
  when 'I' then 'Send Immediate to Tenant'
  when 'Y' then 'Escheat Yes'
  when 'N' then 'Escheat No' 
 
 // else ' '
  end as Escheat_Rule,
        @Search.defaultSearchElement: true
       @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'ZFI_VH_REMIT',
          element: 'Remit_Type'
          }
     } ]

      @EndUserText.label: 'Remit Type'
    // remit_type as remit_type,
      //remit_type as Remit_Type,
   case remit_type
  when 'S' then 'State'
  when 'C' then 'County'
 when ' ' then 'Does Not Escheat'
  when 'N' then 'Not been Researched' 
  else ' ' 
  end as  Remit_Type,
//
//                 @Consumption.valueHelpDefinition: [ {
//                 entity: {
//                name: 'ZFI_VH_HOLDING_PERIOD',
//                 element: 'Holding_Period'
//                 }
//                 } ]

     @EndUserText.label: 'Holding Period'
      holding_period as Holding_Period,
      
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
 case  hp_uom   
  when 'D' then 'Day'
  when 'M' then 'Month'
  when 'Y' then 'Year'
 // else ' ' 
  end as hp_uom,


      @EndUserText.label: 'Pay Immediate Delay Period Days'
      pi_delay       as PI_Delay,


      @EndUserText.label: 'Property Type Code'
      prop_type_code as Prop_Type_Code,

      @EndUserText.label: 'Created By'
      created_by     as Created_By,

      @EndUserText.label: 'Created On'
      created_on     as Created_On,

      @EndUserText.label: 'Created At'
      created_at     as Created_At,

      @EndUserText.label: 'Changed By'
      changed_by     as Changed_By,

      @EndUserText.label: 'Changed On'
      changed_on     as Changed_On,
      
     @EndUserText.label: 'Changed At'
      changed_at    as changed_at 
     

 
}
