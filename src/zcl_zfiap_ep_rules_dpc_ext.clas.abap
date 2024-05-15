class ZCL_ZFIAP_EP_RULES_DPC_EXT definition
  public
  inheriting from ZCL_ZFIAP_EP_RULES_DPC
  create public .

public section.
protected section.

  methods EP_RULESSET_CREATE_ENTITY
    redefinition .
  methods EP_RULESSET_DELETE_ENTITY
    redefinition .
  methods EP_RULESSET_GET_ENTITY
    redefinition .
  methods EP_RULESSET_GET_ENTITYSET
    redefinition .
  methods EP_RULESSET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZFIAP_EP_RULES_DPC_EXT IMPLEMENTATION.


  METHOD ep_rulesset_create_entity.
**TRY.
*CALL METHOD SUPER->EP_RULESSET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA: ls_request_input_data TYPE ZCL_ZFIAP_EP_RULES_mpc=>ts_ep_rules,
          ls_ep_rules           TYPE zfiap_ep_rules.

* Read Request Data

    io_data_provider->read_entry_data( IMPORTING es_data = ls_request_input_data ).

* Fill workarea to be inserted

    ls_ep_rules-state   = ls_request_input_data-state.
    ls_ep_rules-escheat_rule = ls_request_input_data-escheat_rule.
    ls_ep_rules-remit_type = ls_request_input_data-remit_type.
    ls_ep_rules-holding_period    = ls_request_input_data-holding_period.
    ls_ep_rules-hp_uom   = ls_request_input_data-hp_uom.
    ls_ep_rules-pi_delay  = ls_request_input_data-pi_delay.
    ls_ep_rules-prop_type_code  = ls_request_input_data-prop_type_code.
    ls_ep_rules-created_at  = ls_request_input_data-created_at.
    ls_ep_rules-created_by  = ls_request_input_data-created_by.
    ls_ep_rules-created_on  = ls_request_input_data-created_on.
    ls_ep_rules-changed_on  = ls_request_input_data-changed_on.
    ls_ep_rules-changed_by  = ls_request_input_data-changed_by.
    ls_ep_rules-changed_at  = ls_request_input_data-changed_at.


* Insert Data in table Zep_rules

    INSERT zfiap_ep_rules FROM ls_ep_rules.

    IF sy-subrc = 0.

      er_entity = ls_request_input_data. "Fill Exporting parameter ER_ENTITY
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.


  METHOD ep_rulesset_delete_entity.
**TRY.
*CALL METHOD SUPER->EP_RULESSET_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA: ls_key_tab TYPE /iwbep/s_mgw_name_value_pair,

          lv_region  TYPE zfiap_ep_rules-state.

* Read key values

    READ  TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'State'.

    lv_region = ls_key_tab-value.

    IF lv_region IS NOT INITIAL.

      DELETE FROM zfiap_ep_rules WHERE state = lv_region.
      IF sy-subrc = 0.
        COMMIT WORK.
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD ep_rulesset_get_entity.
**TRY.
*CALL METHOD SUPER->EP_RULESSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA: ls_key_tab  TYPE /iwbep/s_mgw_name_value_pair,

          lv_region   TYPE regio,

          ls_ep_rules TYPE  zfiap_ep_rules.

*Get the key property values

    READ TABLE it_key_tab WITH KEY name = 'State' INTO ls_key_tab.

    lv_region = ls_key_tab-value.

*Get the single record from ZUSERINFO and fill ER_ENTITY

    SELECT SINGLE * FROM zfiap_Ep_rules INTO ls_ep_rules WHERE state = lv_region.

    IF sy-subrc = 0.

      er_entity-state = ls_ep_rules-state .
      er_entity-escheat_rule = ls_ep_rules-escheat_rule.
      er_entity-hp_uom = ls_ep_rules-hp_uom .
      er_entity-holding_period = ls_ep_rules-holding_period.
      er_entity-pi_delay = ls_ep_rules-pi_delay.
      er_entity-remit_type = ls_ep_rules-remit_type.
      er_entity-prop_type_code = ls_ep_rules-prop_type_code.
      er_entity-created_by = ls_ep_rules-created_by.
      er_entity-created_on = ls_ep_rules-created_on.
      er_entity-created_at = ls_ep_rules-created_at.
      er_entity-changed_by = ls_ep_rules-changed_by .
      er_entity-changed_on = ls_ep_rules-changed_on .
      er_entity-changed_at = ls_ep_rules-changed_at .
    ENDIF.

  ENDMETHOD.


  METHOD ep_rulesset_get_entityset.
**TRY.
*CALL METHOD SUPER->EP_RULESSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

*    DATA: lt_ep_rules TYPE TABLE OF zfiap_ep_rules,
*
*          ls_ep_rules LIKE LINE OF lt_ep_rules,
*
*          ls_entity   LIKE LINE OF et_entityset.
*
**Get data from ZUSERINFO table
*
*    SELECT * FROM zfiap_ep_rules INTO TABLE lt_ep_rules.
*
**Fill ET_ENTITYSET
*
*    LOOP AT lt_ep_rules INTO  ls_ep_rules.
*
*      ls_entity-state = ls_ep_rules-state .
*      ls_entity-escheat_rule = ls_ep_rules-escheat_rule.
*      ls_entity-hp_uom = ls_ep_rules-hp_uom .
*      ls_entity-holding_period = ls_ep_rules-holding_period.
*      ls_entity-pi_delay = ls_ep_rules-pi_delay.
*      ls_entity-remit_type = ls_ep_rules-remit_type.
*      ls_entity-prop_type_code = ls_ep_rules-prop_type_code.
*      ls_entity-created_on = ls_ep_rules-created_on.
*      ls_entity-created_at = ls_ep_rules-created_at.
*      ls_entity-changed_by = ls_ep_rules-changed_by.
*      ls_entity-changed_on = ls_ep_rules-changed_on.
*      ls_entity-changed_at = ls_ep_rules-changed_at.
*
*      APPEND ls_entity TO et_entityset.
*      CLEAR  : ls_entity, ls_ep_rules.
*
*    ENDLOOP.

  ENDMETHOD.


  METHOD ep_rulesset_update_entity.

    DATA: ls_request_input_data TYPE ZCL_ZFIAP_EP_RULES_mpc=>ts_ep_rules,
          ls_key_tab            TYPE /iwbep/s_mgw_name_value_pair,
          lv_region             TYPE zfiap_ep_rules-state,
          ls_ep_rules           TYPE zfiap_ep_rules.

* Get key values

    READ TABLE it_key_tab WITH KEY name = 'State' INTO ls_key_tab.

    lv_region = ls_key_tab-value.

    IF lv_region IS NOT INITIAL.

* Read request data

      io_data_provider->read_entry_data( IMPORTING es_data = ls_request_input_data ).

      UPDATE zfiap_ep_rules SET state = ls_request_input_data-state
                                escheat_rule  = ls_request_input_data-escheat_rule
                                remit_type = ls_request_input_data-remit_type
                                holding_period = ls_request_input_data-holding_period
                                hp_uom = ls_request_input_data-hp_uom
                                pi_delay = ls_request_input_data-pi_delay
                                prop_type_code = ls_request_input_data-prop_type_code
                                created_by = ls_request_input_data-created_by
                                created_on = ls_request_input_data-created_on
                                created_at = ls_request_input_data-created_at
                                changed_by = sy-uname
                                changed_on = sy-datum
                                changed_at = sy-uzeit
                           WHERE state  = lv_region.

      IF sy-subrc = 0.

        er_entity = ls_request_input_data. "Fill exporting parameter ER_ENTITY
        COMMIT WORK.
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
