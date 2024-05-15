CLASS lhc_zfiap_ep_rules_entity DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR rules RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE rules.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE rules.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE rules.

    METHODS read FOR READ
      IMPORTING keys FOR READ rules RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK rules.

    METHODS map_data IMPORTING im_data            TYPE zfiap_ep_rules
                     RETURNING VALUE(r_bapi_data) TYPE zfiap_ep_rules.

ENDCLASS.

CLASS lhc_zfiap_ep_rules_entity IMPLEMENTATION.

  METHOD map_data.
    r_bapi_data-state      = im_data-state.
    r_bapi_data-escheat_rule = im_data-escheat_rule.
    r_bapi_data-remit_type = im_data-remit_type.
    r_bapi_data-prop_type_code = im_data-prop_type_code.
    r_bapi_data-pi_delay   = im_data-pi_delay.
    r_bapi_data-holding_period = im_data-holding_period.
    r_bapi_data-hp_uom     = im_data-hp_uom.
    r_bapi_data-changed_at = im_data-changed_at.
    r_bapi_data-changed_by = im_data-changed_by.
    r_bapi_data-changed_on = im_data-changed_on.
    r_bapi_data-created_at = im_data-created_at .
    r_bapi_data-created_on = im_data-created_on .
    r_bapi_data-created_by = im_data-created_by.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

    DATA: ls_ep_rules TYPE zfiap_ep_rules,
          lt_ep_rules TYPE TABLE OF zfiap_ep_rules.

    LOOP AT entities INTO DATA(ls_entity).
      ls_entity-created_at = sy-uzeit.
      ls_entity-created_by = sy-uname.
      ls_entity-created_on = sy-datum.
      ls_ep_rules = map_data( im_data = CORRESPONDING #( ls_entity ) ).
      INSERT VALUE #( %cid = ls_entity-%cid
                      state = ls_ep_rules-state
                      )
                      INTO TABLE mapped-rules.

      CASE  ls_ep_rules-escheat_rule.
        WHEN 'Send Immediate to Tenant' .
          ls_ep_rules-escheat_rule = 'I'.
        WHEN 'Escheat Yes' .
          ls_ep_rules-escheat_rule = 'Y'.
        WHEN 'Escheat No'.
          ls_ep_rules-escheat_rule = 'N' .
        WHEN ' '.
          ls_ep_rules-escheat_rule = ' ' .
      ENDCASE   .
      CASE  ls_ep_rules-remit_type.
        WHEN 'State' .
          ls_ep_rules-remit_type = 'S'.
        WHEN 'County' .
          ls_ep_rules-remit_type = 'C'.
        WHEN 'Does Not Escheat'.
          ls_ep_rules-remit_type = ' ' .
        WHEN 'Not been Researched'.
          ls_ep_rules-remit_type = 'N' .
        WHEN ' '.
          ls_ep_rules-remit_type = ' ' .
      ENDCASE   .
      CASE  ls_ep_rules-hp_uom.
        WHEN 'DAY' OR 'Day' .
          ls_ep_rules-hp_uom = 'D'.
        WHEN 'YEAR' OR 'Year'.
          ls_ep_rules-hp_uom = 'Y'.
        WHEN 'MONTH' OR 'Month'.
          ls_ep_rules-hp_uom = 'M'.
        WHEN ' '.
          ls_ep_rules-hp_uom = ' ' .
      ENDCASE   .

      INSERT zfiap_ep_rules FROM ls_ep_rules.
      IF sy-subrc IS NOT INITIAL.
        APPEND VALUE #(
                %msg                = new_message(  id       = 'ZEP_DT'
                                                    number   = '011'
                                                    severity = if_abap_behv_message=>severity-error )
*                                                           v1 = 'No Valid Data to validate"' )
                                                    ) TO reported-rules.
      ENDIF.
*      MODIFY zfiap_ep_rules FROM ls_ep_rules.
      CLEAR ls_entity.
    ENDLOOP.

  ENDMETHOD.

  METHOD update.
    DATA: ls_ep_rules TYPE zfiap_ep_rules,
          lt_ep_rules TYPE TABLE OF zfiap_ep_rules.

    READ TABLE entities INTO DATA(ls_entity) INDEX 1.

    SELECT SINGLE * FROM zfiap_ep_rules
   INTO @DATA(ls_rules)
   WHERE state = @ls_entity-state.

    IF ls_entity-%control-escheat_rule = '01'.
      ls_rules-escheat_rule = ls_entity-escheat_rule.
    ENDIF.
    IF ls_entity-%control-remit_type = '01'.
      ls_rules-remit_type = ls_entity-remit_type.
    ENDIF.
    IF ls_entity-%control-prop_type_code = '01'.
      ls_rules-prop_type_code = ls_entity-prop_type_code.
    ENDIF.
    IF ls_entity-%control-pi_delay = '01'.
      ls_rules-pi_delay = ls_entity-pi_delay.
    ENDIF.
    IF ls_entity-%control-holding_period = '01'.
      ls_rules-holding_period = ls_entity-holding_period.
    ENDIF.
    IF ls_entity-%control-hp_uom = '01'.
      ls_rules-hp_uom = ls_entity-hp_uom.
    ENDIF.

    CASE  ls_rules-escheat_rule.
      WHEN 'Send Immediate to Tenant' .
        ls_rules-escheat_rule = 'I'.
      WHEN 'Escheat Yes' .
        ls_rules-escheat_rule = 'Y'.
      WHEN 'Escheat No'.
        ls_rules-escheat_rule = 'N' .
      WHEN ' '.
        ls_rules-escheat_rule = ' ' .
    ENDCASE   .
    CASE  ls_rules-remit_type.
      WHEN 'State' .
        ls_rules-remit_type = 'S'.
      WHEN 'County' .
        ls_rules-remit_type = 'C'.
      WHEN 'Does Not Escheat'.
        ls_rules-remit_type = ' ' .
      WHEN 'Not been Researched'.
        ls_rules-remit_type = 'N' .
      WHEN ' '.
        ls_rules-remit_type = ' ' .
    ENDCASE   .
    CASE  ls_rules-hp_uom.
      WHEN 'DAY' OR 'Day' .
        ls_rules-hp_uom = 'D'.
      WHEN 'YEAR' OR 'Year'.
        ls_rules-hp_uom = 'Y'.
      WHEN 'MONTH' OR 'Month'.
        ls_rules-hp_uom = 'M'.
      WHEN ' '.
        ls_rules-hp_uom = ' ' .
    ENDCASE   .

    ls_rules-changed_by = sy-uname.
    ls_rules-changed_on = sy-datum.
    ls_rules-changed_at = sy-uzeit.

    MODIFY zfiap_ep_rules FROM ls_rules.
    CLEAR: ls_rules, ls_entity.

  ENDMETHOD.

  METHOD delete.
    DATA: ls_ep_rules TYPE zfiap_ep_rules,
          lt_ep_rules TYPE TABLE OF zfiap_ep_rules.


    READ TABLE keys INTO DATA(ls_keys) INDEX 1.
    SELECT SINGLE * FROM zfiap_ep_rules INTO @DATA(ls_entity) WHERE state = @ls_keys-state.

    DELETE zfiap_ep_rules FROM ls_entity.
  ENDMETHOD.

  METHOD read.
    READ TABLE keys INTO DATA(ls_keys) INDEX 1.

    DATA: ls_ep_rules TYPE zfiap_ep_rules,
          lt_ep_rules TYPE TABLE OF zfiap_ep_rules.

    SELECT * FROM zfiap_ep_rules
     FOR ALL ENTRIES IN @keys
     WHERE state = @keys-state
     INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zfiap_ep_rules_entity DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zfiap_ep_rules_entity IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
