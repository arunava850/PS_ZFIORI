class ZCL_ZFIAP_EP_DATA_DPC_EXT definition
  public
  inheriting from ZCL_ZFIAP_EP_DATA_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_STREAM
    redefinition .
protected section.

  methods EP_DATASET_CREATE_ENTITY
    redefinition .
  methods EP_DATASET_DELETE_ENTITY
    redefinition .
  methods EP_DATASET_GET_ENTITY
    redefinition .
  methods EP_DATASET_GET_ENTITYSET
    redefinition .
  methods EP_DATASET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZFIAP_EP_DATA_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_STREAM
*  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
*    IS_MEDIA_RESOURCE       =
**    it_key_tab              =
**    it_navigation_path      =
*    IV_SLUG                 =
**    io_tech_request_context =
**  IMPORTING
**    er_entity               =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA: lw_file TYPE zfiap_ep_attach.
    FIELD-SYMBOLS:<fs_key> TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab ASSIGNING <fs_key> WITH KEY name = 'EdiTransNo'.
    IF sy-subrc = 0.
      lw_file-edi_trans_no = <fs_key>-value.
    ENDIF.

    lw_file-filename = lw_file-attachment = iv_slug.
    lw_file-value    = is_media_resource-value.
    lw_file-mimetype = is_media_resource-mime_type.
    lw_file-created_by  = sy-uname.
    lw_file-created_at  = sy-uzeit.
    lw_file-created_on  = sy-datum.

    INSERT INTO zfiap_ep_attach VALUES lw_file.
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
**  EXPORTING
**    iv_action_name          =
**    it_parameter            =
**    io_tech_request_context =
**  IMPORTING
**    er_data                 =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA: ls_parameter TYPE /iwbep/s_mgw_name_value_pair,
          ls_entity    TYPE zcl_zfiap_ep_data_mpc=>ts_ep_data,
          lt_entity    TYPE zcl_zfiap_ep_data_mpc=>tt_ep_data,
          ls_ep_Data   TYPE zfiap_eP_data,
          pi_delay     TYPE int1.

*     Read Function import parameter value
    IF it_parameter IS NOT INITIAL.
      IF iv_action_name = 'Validate'.
*        READ TABLE it_parameter INTO ls_parameter WITH KEY name = 'EscheatRule'.
*
*        IF sy-subrc = 0.
*
*          DATA(escheat_rule) = ls_parameter-value.
*
*        ENDIF.
*        READ TABLE it_parameter INTO ls_parameter WITH KEY name = 'SalesDate'.
*
*        IF sy-subrc = 0.
*
*          DATA(sales_Date) = ls_parameter-value.
*
*        ENDIF.
*        READ TABLE it_parameter INTO ls_parameter WITH KEY name = 'BusinessUnitState'.
*
*        IF sy-subrc = 0.
*
*          DATA(Bu_State) = ls_parameter-value.
*
*        ENDIF.
*
*        READ TABLE it_parameter INTO ls_parameter WITH KEY name = 'TenantState'.
*
*        IF sy-subrc = 0.
*
*          DATA(tenant_State) = ls_parameter-value.
*
*        ENDIF.
*        READ TABLE it_parameter INTO ls_parameter WITH KEY name = 'EdiTransDate'.
*
*        IF sy-subrc = 0.
*
*          DATA(edi_trans_date) = ls_parameter-value.
*
*        ENDIF.
        READ TABLE it_parameter INTO ls_parameter WITH KEY name = 'EdiTransNo'.

        IF sy-subrc = 0.

          DATA(edi_trans_no) = ls_parameter-value.

        ENDIF.
        SELECT SINGLE * FROM zfiap_ep_data
          INTO @ls_ep_data
          WHERE edi_trans_no = @edi_trans_no.

*        IF escheat_rule IS NOT INITIAL AND escheat_rule = 'I'.
        SELECT SINGLE pi_delay FROM zfiap_ep_rules
          INTO @DATA(lv_pi_delay)
          WHERE state = @ls_ep_data-business_unit_state.

        pi_Delay = lv_pi_delay.

        IF ( ( sy-datum - ls_ep_Data-sales_date ) =  pi_delay  ) .

          ls_entity-request_type =  '01'.
          ls_entity-approval_status = 'S'.
            ls_entity-edi_trans_no = ls_ep_data-edi_trans_no.
            ls_entity-attachment = ls_ep_data-attachment.
            ls_entity-edi_trans_date = ls_ep_data-edi_trans_date .
            ls_entity-tenant_number = ls_ep_data-tenant_number.
            ls_entity-tenant_name = ls_ep_data-tenant_name.
            ls_entity-payee_number = ls_ep_data-payee_number.
            ls_entity-payee_name = ls_ep_data-payee_name.
            ls_entity-sales_date = ls_ep_data-sales_date.
            ls_entity-gl_account = ls_ep_data-gl_account.
            ls_entity-amount = ls_ep_data-amount.
            ls_entity-waers = ls_ep_data-waers.
            ls_entity-region = ls_ep_data-region.
            ls_entity-senior_region = ls_ep_data-senior_region.
            ls_entity-zzone = ls_ep_data-zzone.
            ls_entity-hp_uom = ls_ep_data-hp_uom .
            ls_entity-exp_remark = ls_ep_data-exp_remark.
            ls_entity-invoice_number = ls_ep_data-invoice_number .
            ls_entity-business_unit_company_code = ls_ep_data-business_unit_company_code.
            ls_entity-business_unit = ls_ep_data-business_unit.
            ls_entity-business_unit_state = ls_ep_data-business_unit_state .
            ls_entity-business_unit_country = ls_ep_data-business_unit_country.
            ls_entity-tenant_state = ls_ep_data-tenant_state.
            ls_entity-posting_date = ls_ep_data-posting_date.
            ls_entity-company_code = ls_ep_data-company_code.
            ls_entity-document_type = ls_ep_data-document_type.
            ls_entity-document_number = ls_ep_data-document_number.
            ls_entity-comment_ = ls_ep_data-comment_.
            ls_entity-district = ls_ep_data-district.
            ls_entity-senior_district = ls_ep_data-senior_district.
            ls_entity-division = ls_ep_data-division .
            ls_entity-escheat_rule = ls_ep_data-escheat_rule.
            ls_entity-remit_type = ls_ep_data-remit_type .
            ls_entity-holding_period = ls_ep_data-holding_period .
            ls_entity-pi_delay_period = ls_ep_data-pi_delay_period .
            ls_entity-hp_expire_date = ls_ep_data-hp_expire_date .
            ls_entity-tracker_sent_date = ls_ep_data-tracker_sent_date .
            ls_entity-created_by = ls_ep_data-created_by.
            ls_entity-create_date = ls_ep_data-create_date.
            ls_entity-create_time = ls_ep_data-create_time.
            ls_entity-changed_by = sy-uname.
            ls_entity-changed_date = sy-datum.
            ls_entity-changed_time = sy-uzeit.

            append ls_entity to lt_entity.

          copy_data_to_ref( EXPORTING is_data = lt_entity CHANGING cr_data = er_data ).

        ENDIF.
*        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
**  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
**    it_key_tab              =
**    it_navigation_path      =
**    io_tech_request_context =
**  IMPORTING
**    er_stream               =
**    es_response_context     =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA : ls_stream   TYPE ty_s_media_resource,
           ls_upld     TYPE zfiap_ep_attach,
           lv_filename TYPE char30.

    FIELD-SYMBOLS:<fs_key> TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab ASSIGNING <fs_key> INDEX 2.
    lv_filename = <fs_key>-value.
    READ TABLE it_key_tab ASSIGNING <fs_key> WITH KEY name = 'EdiTransNo'.
    DATA(lv_trans) = <fs_key>-value.
    SELECT SINGLE * FROM zfiap_ep_attach
      INTO @ls_upld WHERE
      edi_trans_no = @lv_trans AND
      filename = @lv_filename.

    IF ls_upld IS NOT INITIAL.
      ls_stream-value = ls_upld-value.
      ls_stream-mime_type = ls_upld-mimetype.

      copy_data_to_ref( EXPORTING is_data = ls_stream
      CHANGING  cr_data = er_stream ).
    ENDIF.


  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~update_stream.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_STREAM
*  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
*    IS_MEDIA_RESOURCE       =
**    it_key_tab              =
**    it_navigation_path      =
**    io_tech_request_context =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
    DATA: lw_file TYPE zfiap_ep_attach.
    FIELD-SYMBOLS:<fs_key> TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab ASSIGNING <fs_key> WITH KEY name = 'EdiTransNo'.
    IF sy-subrc = 0.
      lw_file-edi_trans_no = <fs_key>-value.
    ENDIF.
    READ TABLE it_key_tab ASSIGNING <fs_key> WITH KEY name = 'Attachment'.
    IF sy-subrc = 0.
      lw_file-filename = <fs_key>-value.
    ENDIF.
    lw_file-value    = is_media_resource-value.
    lw_file-mimetype = is_media_resource-mime_type.
    lw_file-changed_by  = sy-uname.
    lw_file-changed_at  = sy-uzeit.
    lw_file-changed_on  = sy-datum.

    MODIFY zfiap_ep_attach FROM lw_file.
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.


  METHOD ep_dataset_create_entity.
    DATA: lo_exception TYPE REF TO /iwbep/cx_mgw_tech_exception.
    DATA: ls_request_input_data TYPE ZCL_ZFIAP_EP_data_mpc=>ts_ep_data,
          ls_ep_data            TYPE zfiap_ep_data.
    DATA: doc_header  TYPE bapiache09,
          criteria    TYPE TABLE OF bapiackec9 , "OCCURS 0 WITH HEADER LINE,
          doc_item_gl TYPE TABLE OF bapiacgl09  , "OCCURS 0 WITH HEADER LINE,
          doc_pay     TYPE TABLE OF bapiacap09 , "OCCURS 0 WITH HEADER LINE,
          doc_recv    TYPE  TABLE OF bapiaccr09, " OCCURS 0 WITH HEADER LINE,
          return      TYPE TABLE OF bapiret2, " OCCURS 0 WITH HEADER LINE,
          gt_output   TYPE TABLE OF bapiret2, " OCCURS 0 WITH HEADER LINE,
          lw_return   TYPE  bapiret2, " OCCURS 0 WITH HEADER LINE,
          extension1  TYPE TABLE OF bapiacextc, " occurs 0 with header line,
          obj_type    TYPE bapiache08-obj_type,
          obj_key     TYPE bapiache02-obj_key,
          obj_sys     TYPE bapiache02-obj_sys,
          docnum      TYPE bkpf-belnr.
    DATA : lv_obj_type TYPE   bapiache09-obj_type,
           lv_obj_key  TYPE bapiache09-obj_key,
           lv_obj_sys  TYPE bapiache09-obj_sys.

* Read Request Data
    io_data_provider->read_entry_data( IMPORTING
                                    es_data = ls_request_input_data ).

    ls_ep_data-region = ls_request_input_data-region.
    ls_ep_data-senior_region = ls_request_input_data-senior_region.
    ls_ep_data-zzone = ls_request_input_data-zzone.
    ls_ep_data-hp_uom = ls_request_input_data-hp_uom .
    ls_ep_data-edi_trans_no = ls_request_input_data-edi_trans_no.
    ls_ep_data-attachment = ls_request_input_data-attachment.
    ls_ep_data-edi_trans_date = ls_request_input_data-edi_trans_date .
    ls_ep_data-request_type = ls_request_input_data-request_type.
    ls_ep_data-approval_status = ls_request_input_data-approval_status.
    ls_ep_data-tenant_number = ls_request_input_data-tenant_number.
    ls_ep_data-tenant_name = ls_request_input_data-tenant_name.
    ls_ep_data-payee_number = ls_request_input_data-payee_number.
    ls_ep_data-payee_name = ls_request_input_data-payee_name.
    ls_ep_data-sales_date = ls_request_input_data-sales_date.
    ls_ep_data-gl_account = ls_request_input_data-gl_account.
    ls_ep_data-amount = ls_request_input_data-amount.
    ls_ep_data-waers = ls_request_input_data-waers.
    ls_ep_data-exp_remark = ls_request_input_data-exp_remark.
    ls_ep_data-invoice_number = ls_request_input_data-invoice_number .
    ls_ep_data-business_unit_company_code = ls_request_input_data-business_unit_company_code.
    ls_ep_data-business_unit = ls_request_input_data-business_unit.
    ls_ep_data-business_unit_state = ls_request_input_data-business_unit_state .
    ls_ep_data-business_unit_country = ls_request_input_data-business_unit_country.
    ls_ep_data-tenant_state = ls_request_input_data-tenant_state.
    ls_ep_data-posting_date = ls_request_input_data-posting_date.
    ls_ep_data-company_code = ls_request_input_data-company_code.
    ls_ep_data-document_type = ls_request_input_data-document_type.
    ls_ep_data-document_number = ls_request_input_data-document_number.
    ls_ep_data-comment_ = ls_request_input_data-comment_.
    ls_ep_data-district = ls_request_input_data-district.
    ls_ep_data-senior_district = ls_request_input_data-senior_district.
    ls_ep_data-division = ls_request_input_data-division .
    ls_ep_data-escheat_rule = ls_request_input_data-escheat_rule.
    ls_ep_data-remit_type = ls_request_input_data-remit_type .
    ls_ep_data-holding_period = ls_request_input_data-holding_period .
    ls_ep_data-pi_delay_period = ls_request_input_data-pi_delay_period .
    ls_ep_data-hp_expire_date = ls_request_input_data-hp_expire_date .
    ls_ep_data-tracker_sent_date = ls_request_input_data-tracker_sent_date .
    ls_ep_data-created_by = ls_request_input_data-created_by.
    ls_ep_data-create_date = ls_request_input_data-create_date.
    ls_ep_data-create_time = ls_request_input_data-create_time.
    ls_ep_data-changed_by = ls_request_input_data-changed_by.
    ls_ep_data-changed_date = ls_request_input_data-changed_date.
    ls_ep_data-changed_time = ls_request_input_data-changed_time.

    doc_header-comp_code = ls_ep_data-company_code.
    doc_header-fis_period = sy-datum+4(2).
    doc_header-fisc_year = sy-datum+0(4).
    doc_header-doc_type = 'ZE'.
    doc_header-header_txt = ls_ep_data-edi_trans_no.
    doc_header-ref_doc_no = ls_ep_data-invoice_number.
    doc_header-pstng_date = sy-datum.
    doc_header-doc_date = ls_ep_data-sales_date.

    doc_item_gl = VALUE #( ( itemno_acc = '1'
                                    gl_account = ls_ep_data-gl_account
                                    item_text = ls_ep_data-exp_remark
                                    comp_code = ls_ep_data-company_code
                                    fis_period = sy-datum+4(2)
                                    profit_ctr = ls_ep_data-business_unit
                                    costcenter = ls_ep_data-business_unit ) ).

    doc_pay = VALUE #( ( itemno_acc = '2'
                         vendor_no = ls_ep_data-tenant_number ) ).

    doc_recv = VALUE #( ( itemno_acc = '1'
                            currency = ls_ep_data-waers
                            amt_doccur = ls_ep_data-amount )
                            ( itemno_acc = '2'
                            currency = ls_ep_data-waers
                            amt_doccur = ( ls_ep_data-amount  * ( -1 ) ) ) ).

    SELECT SINGLE xbilk FROM ska1 INTO @DATA(lv_xbilk)
      WHERE saknr = @ls_ep_data-gl_account AND ktopl  = 'PSUS'.

    IF lv_xbilk = space.
      criteria = VALUE #( ( itemno_acc = '1'
                            fieldname = 'PRCTR'
                            character = ls_ep_Data-business_unit ) ).
    ENDIF.

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
      EXPORTING
        documentheader = doc_header
      IMPORTING
        obj_type       = lv_obj_type
        obj_key        = lv_obj_key
        obj_sys        = lv_obj_sys
      TABLES
        accountgl      = doc_item_gl
        accountpayable = doc_pay
        currencyamount = doc_recv
        return         = return.

    IF return IS NOT INITIAL.
      " Create exception object
      CREATE OBJECT lo_exception.
      " Add messages to container & instantiate container
      lo_exception->get_msg_container( )->add_messages_from_bapi( it_bapi_messages = return ).
      " Raise exception
      RAISE EXCEPTION lo_exception.

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait   = 'X'
        IMPORTING
          return = lw_return.
      APPEND lw_return TO return.
      READ TABLE return INTO lw_return WITH KEY type = 'E'.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
          IMPORTING
            return = lw_return.
        APPEND lw_return TO return.
        " Add messages to container & instantiate container
        lo_exception->get_msg_container( )->add_messages_from_bapi( it_bapi_messages = return ).
        " Raise exception
        RAISE EXCEPTION lo_exception.
      ELSE.
********************************* updating table ********************************************************************
        UPDATE zfiap_ep_data SET
    approval_status = 'G'
    posting_date = sy-datum
    company_code = ls_ep_data-company_code
    document_type = 'ZE'
    document_number = lv_obj_key+0(10)
    WHERE edi_trans_no = ls_ep_data-edi_trans_no.
********************************************************************************************************************
        IF sy-subrc = 0.
          lw_return-type = 'S'.
          lw_return-number = 605.
          CONCATENATE 'Posted Document' lv_obj_key+0(10) 'in company code'
          ls_ep_data-company_code INTO lw_return-message SEPARATED BY ' '.
          APPEND lw_return TO return.

          lo_exception->get_msg_container( )->add_messages_from_bapi( it_bapi_messages = return ).
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD ep_dataset_delete_entity.
**TRY.
*CALL METHOD SUPER->EP_DATASET_DELETE_ENTITY
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

          lv_trans   TYPE zwtn.

* Read key values

    READ  TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'EdiTransNo'.

    lv_trans = ls_key_tab-value.

    IF lv_trans IS NOT INITIAL.

      DELETE FROM zfiap_ep_data WHERE edi_trans_no = lv_trans.
      IF sy-subrc = 0.
        COMMIT WORK.
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD ep_dataset_get_entity.
**TRY.
*CALL METHOD SUPER->EP_DATASET_GET_ENTITY
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


    DATA: ls_key_tab TYPE /iwbep/s_mgw_name_value_pair,
          lv_trans   TYPE zwtn,
          ls_ep_data TYPE  zfiap_ep_data.

*Get the key property values

    READ TABLE it_key_tab WITH KEY name = 'EdiTransNo' INTO ls_key_tab.

    lv_trans = ls_key_tab-value.

    SELECT SINGLE * FROM zfiap_Ep_data INTO ls_ep_data WHERE edi_trans_no = lv_trans.

    IF sy-subrc = 0.

      er_entity-edi_trans_no = ls_ep_data-edi_trans_no.
      er_entity-attachment = ls_ep_data-attachment.
      er_entity-edi_trans_date = ls_ep_data-edi_trans_date .
      er_entity-request_type = ls_ep_data-request_type.
      er_entity-approval_status = ls_ep_data-approval_status.
      er_entity-tenant_number = ls_ep_data-tenant_number.
      er_entity-tenant_name = ls_ep_data-tenant_name.
      er_entity-payee_number = ls_ep_data-payee_number.
      er_entity-payee_name = ls_ep_data-payee_name.
      er_entity-sales_date = ls_ep_data-sales_date.
      er_entity-gl_account = ls_ep_data-gl_account.
      er_entity-amount = ls_ep_data-amount.
      er_entity-waers = ls_ep_data-waers.
      er_entity-exp_remark = ls_ep_data-exp_remark.
      er_entity-invoice_number = ls_ep_data-invoice_number .
      er_entity-business_unit_company_code = ls_ep_data-business_unit_company_code.
      er_entity-business_unit = ls_ep_data-business_unit.
      er_entity-business_unit_state = ls_ep_data-business_unit_state .
      er_entity-business_unit_country = ls_ep_data-business_unit_country.
      er_entity-tenant_state = ls_ep_data-tenant_state.
      er_entity-posting_date = ls_ep_data-posting_date.
      er_entity-company_code = ls_ep_data-company_code.
      er_entity-document_type = ls_ep_data-document_type.
      er_entity-document_number = ls_ep_data-document_number.
      er_entity-comment_ = ls_ep_data-comment_.
      er_entity-district = ls_ep_data-district.
      er_entity-senior_district = ls_ep_data-senior_district.
      er_entity-division = ls_ep_data-division .
      er_entity-escheat_rule = ls_ep_data-escheat_rule.
      er_entity-remit_type = ls_ep_data-remit_type .
      er_entity-holding_period = ls_ep_data-holding_period .
      er_entity-pi_delay_period = ls_ep_data-pi_delay_period .
      er_entity-hp_expire_date = ls_ep_data-hp_expire_date .
      er_entity-tracker_sent_date = ls_ep_data-tracker_sent_date .
      er_entity-created_by = ls_ep_data-created_by.
      er_entity-create_date = ls_ep_data-create_date.
      er_entity-create_time = ls_ep_data-create_time.
      er_entity-changed_by = ls_ep_data-changed_by.
      er_entity-changed_date = ls_ep_data-changed_date.
      er_entity-changed_time = ls_ep_data-changed_time.
      er_entity-region = ls_ep_data-region.
      er_entity-senior_region = ls_ep_data-senior_region.
      er_entity-zzone = ls_ep_data-zzone.
      er_entity-hp_uom = ls_ep_data-hp_uom.
    ENDIF.

  ENDMETHOD.


  METHOD ep_dataset_get_entityset.
**TRY.
*CALL METHOD SUPER->EP_DATASET_GET_ENTITYSET
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

*    DATA: lt_ep_data TYPE TABLE OF zfiap_ep_data,
*
*          ls_ep_data LIKE LINE OF lt_ep_data,
*
*          ls_entity  LIKE LINE OF et_entityset.
*
**Get data from ZUSERINFO table
*
*    SELECT * FROM zfiap_ep_data INTO TABLE lt_ep_data.
*
**Fill ET_ENTITYSET
*
*    LOOP AT lt_ep_data INTO  ls_ep_data.
*
*      ls_entity-region = ls_ep_data-region.
*      ls_entity-senior_region = ls_ep_data-senior_region.
*      ls_entity-zzone = ls_ep_data-zzone.
*      ls_entity-hp_uom = ls_ep_data-hp_uom .
*      ls_entity-edi_trans_no = ls_ep_data-edi_trans_no.
*      ls_entity-attachment = ls_ep_data-attachment.
*      ls_entity-edi_trans_date = ls_ep_data-edi_trans_date .
*      ls_entity-request_type = ls_ep_data-request_type.
*      ls_entity-approval_status = ls_ep_data-approval_status.
*      ls_entity-tenant_number = ls_ep_data-tenant_number.
*      ls_entity-tenant_name = ls_ep_data-tenant_name.
*      ls_entity-payee_number = ls_ep_data-payee_number.
*      ls_entity-payee_name = ls_ep_data-payee_name.
*      ls_entity-sales_date = ls_ep_data-sales_date.
*      ls_entity-gl_account = ls_ep_data-gl_account.
*      ls_entity-amount = ls_ep_data-amount.
*      ls_entity-waers = ls_ep_data-waers.
*      ls_entity-exp_remark = ls_ep_data-exp_remark.
*      ls_entity-invoice_number = ls_ep_data-invoice_number .
*      ls_entity-business_unit_company_code = ls_ep_data-business_unit_company_code.
*      ls_entity-business_unit = ls_ep_data-business_unit.
*      ls_entity-business_unit_state = ls_ep_data-business_unit_state .
*      ls_entity-business_unit_country = ls_ep_data-business_unit_country.
*      ls_entity-tenant_state = ls_ep_data-tenant_state.
*      ls_entity-posting_date = ls_ep_data-posting_date.
*      ls_entity-company_code = ls_ep_data-company_code.
*      ls_entity-document_type = ls_ep_data-document_type.
*      ls_entity-document_number = ls_ep_data-document_number.
*      ls_entity-comment_ = ls_ep_data-comment_.
*      ls_entity-district = ls_ep_data-district.
*      ls_entity-senior_district = ls_ep_data-senior_district.
*      ls_entity-division = ls_ep_data-division .
*      ls_entity-escheat_rule = ls_ep_data-escheat_rule.
*      ls_entity-remit_type = ls_ep_data-remit_type .
*      ls_entity-holding_period = ls_ep_data-holding_period .
*      ls_entity-pi_delay_period = ls_ep_data-pi_delay_period .
*      ls_entity-hp_expire_date = ls_ep_data-hp_expire_date .
*      ls_entity-tracker_sent_date = ls_ep_data-tracker_sent_date .
*      ls_entity-created_by = ls_ep_data-created_by.
*      ls_entity-create_date = ls_ep_data-create_date.
*      ls_entity-create_time = ls_ep_data-create_time.
*      ls_entity-changed_by = ls_ep_data-changed_by.
*      ls_entity-changed_date = ls_ep_data-changed_date.
*      ls_entity-changed_time = ls_ep_data-changed_time.
*
*      APPEND ls_entity TO et_entityset.
*      CLEAR  : ls_entity, ls_ep_data.
*
*    ENDLOOP.
  ENDMETHOD.


  METHOD ep_dataset_update_entity.
**TRY.
*CALL METHOD SUPER->EP_DATASET_UPDATE_ENTITY
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

    DATA: ls_request_input_data TYPE ZCL_ZFIAP_EP_data_mpc=>ts_ep_data,
          ls_key_tab            TYPE /iwbep/s_mgw_name_value_pair,
          lv_trans              TYPE zwtn.


    READ TABLE it_key_tab WITH KEY name = 'EdiTransNo' INTO ls_key_tab.

    lv_trans = ls_key_tab-value.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_request_input_data ).

*    CASE ls_request_input_data-request_type .
*      WHEN '01' OR '02'.
*        ls_request_input_data-approval_status = 'S'.
*      WHEN '03'.
*        ls_request_input_data-approval_status = 'S'.
*        IF ls_request_input_data-attachment IS NOT INITIAL.
*          ls_request_input_data-approval_status = 'S'.
*        ENDIF.
*    ENDCASE.


    UPDATE zfiap_ep_data SET edi_trans_no = ls_request_input_data-edi_trans_no
       attachment = ls_request_input_data-attachment
       region = ls_request_input_data-region
       senior_region = ls_request_input_data-senior_region
       zzone = ls_request_input_data-zzone
       hp_uom = ls_request_input_data-hp_uom
       edi_trans_date = ls_request_input_data-edi_trans_date
       request_type = ls_request_input_data-request_type
       approval_status = ls_request_input_data-approval_status
       tenant_number = ls_request_input_data-tenant_number
       tenant_name = ls_request_input_data-tenant_name
       payee_number = ls_request_input_data-payee_number
       payee_name = ls_request_input_data-payee_name
       sales_date = ls_request_input_data-sales_date
       gl_account = ls_request_input_data-gl_account
       amount = ls_request_input_data-amount
       waers = ls_request_input_data-waers
       exp_remark = ls_request_input_data-exp_remark
       invoice_number = ls_request_input_data-invoice_number
       business_unit_company_code = ls_request_input_data-business_unit_company_code
       business_unit = ls_request_input_data-business_unit
       business_unit_state = ls_request_input_data-business_unit_state
       business_unit_country = ls_request_input_data-business_unit_country
       tenant_state = ls_request_input_data-tenant_state
       posting_date = ls_request_input_data-posting_date
       company_code = ls_request_input_data-company_code
       document_type = ls_request_input_data-document_type
       document_number = ls_request_input_data-document_number
       comment_ = ls_request_input_data-comment_
       district = ls_request_input_data-district
       senior_district = ls_request_input_data-senior_district
       division = ls_request_input_data-division
       escheat_rule = ls_request_input_data-escheat_rule
       remit_type = ls_request_input_data-remit_type
       holding_period = ls_request_input_data-holding_period
       pi_delay_period = ls_request_input_data-pi_delay_period
       hp_expire_date = ls_request_input_data-hp_expire_date
       tracker_sent_date = ls_request_input_data-tracker_sent_date
       created_by = ls_request_input_data-created_by
       create_date = ls_request_input_data-create_date
       create_time = ls_request_input_data-create_time
       changed_by = ls_request_input_data-changed_by
       changed_date = ls_request_input_data-changed_date
       changed_time = ls_request_input_data-changed_time
      WHERE edi_trans_no  = lv_trans.

    IF sy-subrc = 0.

      er_entity = ls_request_input_data. "Fill exporting parameter ER_ENTITY
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
