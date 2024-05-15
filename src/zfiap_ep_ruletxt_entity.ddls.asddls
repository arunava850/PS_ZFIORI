@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds view for RULES TEXT'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.dataCategory: #VALUE_HELP
define view entity ZFIAP_EP_RULETXT_ENTITY as select from zfiap_ep_rules
association[0..1] to zfiap_ep_ruletxt as _RULETXT on $projection.state = zfiap_ep_rules.state
//association[0..1]  to zfi_vh_escheat_rules as _vh_escheat on $projection.ESCHEAT_RULE = zfiap_ep_rules.escheat_rule
//association[0..1] to zfi_vh_remit as _vh_remit on $projection.remit_type = zfiap_ep_rules.remit_type
{
      @Search.defaultSearchElement: true
      key zfiap_ep_rules.state as state,

      
      @Search.defaultSearchElement: true
       @ObjectModel.foreignKey.association:'_ruletxt'
      zfiap_ep_rules.escheat_rule as Escheat_Rule,
      
      @Semantics.language : true
      _RULETXT.spras as spras,
      @ObjectModel.text.element : [ 'escheat_rule_text' ]
      _RULETXT[ spras = $session.system_language ].escheat_rule_text as escheat_rule_text,
      
      @Search.defaultSearchElement: true
       @ObjectModel.foreignKey.association:'_ruletxt'
    zfiap_ep_rules.remit_type as remit_type,
    
     @Search.defaultSearchElement: true
     @ObjectModel.text.element : [ 'remit_type_text' ]
      _RULETXT[ spras = $session.system_language ].remit_type_text as remit_type_text,
      
     //@Search.defaultSearchElement: true
     // @ObjectModel.foreignKey.association:'_ruletxt'
     zfiap_ep_rules.hp_uom as hp_uom,
     
     @Search.defaultSearchElement: true
      @ObjectModel.text.element : [ 'hp_uom_text' ]
      _RULETXT[ spras = $session.system_language ].hp_uom_text as hp_uom_text,
      
     zfiap_ep_rules.changed_at as changed_at,
     zfiap_ep_rules.changed_by as changed_by,
     zfiap_ep_rules.changed_on as changed_on,
     zfiap_ep_rules.created_at as created_at,
     zfiap_ep_rules.created_by as created_by,
     zfiap_ep_rules.created_on as created_on,
     zfiap_ep_rules.pi_delay as pi_delay,
     zfiap_ep_rules.prop_type_code as prop_type_code,
     zfiap_ep_rules.holding_period as holding_period ,
     _RULETXT.spras as language,
     _RULETXT
     
     }
     
