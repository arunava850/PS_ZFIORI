*&---------------------------------------------------------------------*
*& Report ZFIAP_EP_VALIDATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfiap_ep_validate.

DATA: lv_bukrs TYPE zfiap_ep_data-business_unit_company_code,
      lv_trans TYPE zfiap_ep_data-edi_trans_no,
      lv_date  TYPE zfiap_ep_data-edi_trans_date.
DATA lv_validation_date LIKE sy-datum.
DATA lt_wf_key TYPE zep_data_wf_key_tt.

SELECT-OPTIONS : s_bukrs FOR lv_bukrs,
                 s_trans FOR lv_trans,
                 s_date FOR  lv_date obligatory.


SELECT * FROM
zfiap_ep_data
INTO TABLE @DATA(lt_ep_data)
WHERE edi_trans_no IN @s_trans
AND edi_trans_date IN @s_date
AND business_unit_company_code IN @s_bukrs
AND approval_status <> 'G'.
IF sy-subrc IS INITIAL.
*            DELETE lt_ep_data_upd WHERE approval_status = 'G'.
  DELETE lt_ep_data WHERE approval_status = 'A'.
  DELETE lt_ep_data WHERE approval_status = 'X    '.
  IF lt_ep_data IS NOT INITIAL.
    DATA(lt_ep_data_upd) = lt_ep_data.
    REFRESH lt_ep_data_upd.
    SELECT *
    FROM zfiap_ep_rules
    INTO TABLE @DATA(lt_zfiap_ep_rules)
    FOR ALL ENTRIES IN @lt_ep_data
    WHERE
*              escheat_rule = 'I' AND
    state = @lt_ep_data-business_unit_state.

    IF sy-subrc IS INITIAL.
*                LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_key>).
      LOOP AT lt_ep_data ASSIGNING FIELD-SYMBOL(<ls_ep_data>).

*Escheat Rule, Remit Type, Holding Period, HP UOM, Pay Immediate Delay Period Days, Holding Period Expire Date
        READ TABLE lt_zfiap_ep_rules INTO DATA(ls_zfiap_ep_rules) WITH KEY state = <ls_ep_data>-business_unit_state.
        IF sy-subrc IS INITIAL.
          <ls_ep_data>-escheat_rule = ls_zfiap_ep_rules-escheat_rule.
          <ls_ep_data>-remit_type = ls_zfiap_ep_rules-remit_type.
          <ls_ep_data>-holding_period = ls_zfiap_ep_rules-holding_period.
          <ls_ep_data>-hp_uom = ls_zfiap_ep_rules-hp_uom.
          <ls_ep_data>-pi_delay_period = ls_zfiap_ep_rules-pi_delay.
          <ls_ep_data>-changed_by = sy-uname.
          <ls_ep_data>-changed_date = sy-datum.
          <ls_ep_data>-changed_time = sy-uzeit.
          CASE ls_zfiap_ep_rules-hp_uom.
            WHEN 'D'.
              <ls_ep_data>-hp_expire_date = <ls_ep_data>-sales_date + <ls_ep_data>-holding_period.
            WHEN 'M'.
              <ls_ep_data>-hp_expire_date = <ls_ep_data>-sales_date + ( <ls_ep_data>-holding_period * 30 ).
            WHEN 'Y'.
              <ls_ep_data>-hp_expire_date = <ls_ep_data>-sales_date + ( <ls_ep_data>-holding_period * 365 ).
          ENDCASE.
          DATA(lv_validate_suc) = abap_true.
          IF <ls_ep_data>-escheat_rule = 'I'.
            lv_validation_date = <ls_ep_data>-sales_date + ls_zfiap_ep_rules-pi_delay.
            IF sy-datum >= lv_validation_date OR ls_zfiap_ep_rules-pi_delay IS INITIAL.
              <ls_ep_data>-request_type = '01'.
              <ls_ep_data>-approval_status = 'S'.
              <ls_ep_data>-comment_ = 'Workflow is submitted for Approval'.
            ELSE.
            ENDIF.
            CLEAR lv_validation_date.

          ENDIF.
          APPEND <ls_ep_data> TO lt_ep_data_upd.
        ENDIF.
      ENDLOOP.

    ELSE.
      MESSAGE i398(00) WITH 'No Data to Validate'.
    ENDIF.
  ENDIF.
ELSE.
  MESSAGE i398(00) WITH 'No Data to Validate'.
ENDIF.

IF lv_validate_suc = abap_true AND lt_ep_data_upd IS NOT INITIAL.

  MODIFY  zfiap_ep_data FROM  TABLE lt_ep_data_upd.
  IF sy-subrc IS INITIAL.

    COMMIT WORK AND WAIT.
    MESSAGE i398(00) WITH 'Data Validated sucessfully'.

  ENDIF.

  DATA(lt_wf_process) = lt_ep_data_upd.
  DELETE lt_wf_process WHERE approval_status <> 'S'.
  IF lt_wf_process IS NOT INITIAL.
    lt_wf_key = CORRESPONDING #( lt_wf_process ).


    CALL FUNCTION 'Z_FIAP_EP_DATA_TRIGGER_WF'
      DESTINATION 'NONE'
      EXPORTING
        it_wf_key = lt_wf_key.

    MESSAGE i398(00) WITH 'Workflow trigger initiated sucessfully'.
  ENDIF.
ENDIF.
