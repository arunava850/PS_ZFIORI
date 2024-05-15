CLASS ltcl_details DEFINITION DEFERRED FOR TESTING.
CLASS lhc_details DEFINITION INHERITING FROM cl_abap_behavior_handler FRIENDS ltcl_details.
  PRIVATE SECTION.

*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR details RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR details RESULT result.

*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE details.
*
*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE details.
*
*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE details.

*    METHODS read FOR READ
*      IMPORTING keys FOR READ details RESULT result.

*    METHODS lock FOR LOCK
*      IMPORTING keys FOR LOCK details.

    METHODS upd FOR MODIFY
      IMPORTING keys FOR ACTION details~upd RESULT result.

    METHODS post FOR MODIFY
      IMPORTING keys FOR ACTION details~post RESULT result.

    METHODS validate FOR  MODIFY
      IMPORTING keys FOR ACTION details~validate RESULT result.
    METHODS extract FOR MODIFY
      IMPORTING keys FOR ACTION details~extract." RESULT result.

*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR details RESULT result.

ENDCLASS.

CLASS lhc_details IMPLEMENTATION.

*  METHOD get_instance_features.
*  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD create.
*  ENDMETHOD.
*
*  METHOD update.
*  ENDMETHOD.
*
*  METHOD delete.
*  ENDMETHOD.

*  METHOD read.
*  ENDMETHOD.

*  METHOD lock.
*  ENDMETHOD.

  METHOD upd.

    DATA lt_wf_key TYPE zep_data_wf_key_tt.
    READ ENTITIES OF zfiap_ep_data2 IN LOCAL MODE
     ENTITY details
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_ep_data_upd)
     FAILED failed.

    DATA(lt_keys) = keys.

    READ TABLE lt_keys INTO DATA(ls_key) INDEX 1.
    IF sy-subrc IS INITIAL.
      DATA(lv_req_type) = ls_key-%param-request_type.
      DATA(lv_app_stat) = ls_key-%param-approval_status.
      DATA(lv_payee_num) = ls_key-%param-payee_number.
      DATA(lv_payee_conf) = ls_key-%param-conf_val.
      IF lv_payee_num IS NOT INITIAL.
        CASE lv_req_type.
          WHEN '01' OR '02'.

            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lv_payee_num
              IMPORTING
                output = lv_payee_num. "Fix for Issue SAP-1776

            SELECT SINGLE lifnr, name1, name2
                    FROM lfa1 INTO @DATA(ls_lfa1)
                    WHERE lifnr = @lv_payee_num.
            IF sy-subrc IS INITIAL.
              CONCATENATE ls_lfa1-name1 ls_lfa1-name2  INTO DATA(lv_payee_name) SEPARATED BY space.
            ENDIF.
          WHEN OTHERS.
            DATA(lv_err) = abap_true.
            APPEND VALUE #(
                          %msg                = new_message(  id       = 'ZEP_DT'
                                                              number   = '006'
                                                              severity = if_abap_behv_message=>severity-information )
*                                                           v1 = 'No Valid Data to validate"' )
                                                              ) TO reported-details.
        ENDCASE.
      ENDIF.
      IF lv_err IS INITIAL.

        IF lv_req_type = '02' AND  lv_payee_conf IS INITIAL.

          lv_err = abap_true.
          APPEND VALUE #(
                        %msg                = new_message(  id       = 'ZEP_DT'
                                                            number   = '012'
                                                            severity = if_abap_behv_message=>severity-information
                                                             )
*                                                           v1 = 'No Valid Data to validate"' )
                                                            ) TO reported-details.
        ENDIF.
      ENDIF.

      IF lv_err IS INITIAL.
        IF lt_ep_data_upd IS NOT INITIAL.
          SELECT * FROM
          zfiap_ep_data
          INTO TABLE @DATA(lt_ep_data)
          FOR ALL ENTRIES IN @lt_ep_data_upd
          WHERE edi_trans_no = @lt_ep_data_upd-edi_trans_no.
          IF sy-subrc IS INITIAL.
            DELETE lt_ep_data WHERE approval_status = 'G'.
            "   DELETE lt_ep_data WHERE approval_status = 'A'.
            IF lt_ep_data IS NOT INITIAL.

              CASE lv_req_type.
                WHEN '01' OR '02'.
                  lv_app_stat = 'S'.
                WHEN '03'.


                  LOOP AT lt_ep_data INTO DATA(ls_att_check).
                    IF ls_att_check-attachment IS INITIAL.
                      lv_err = abap_true.
                      APPEND VALUE #(
                                    %msg                = new_message(  id       = 'ZEP_DT'
                                                                        number   = '008'
                                                                        severity = if_abap_behv_message=>severity-information
                                                                        v1 = ls_att_check-edi_trans_no )
                                                                        ) TO reported-details.
                    ENDIF.
                  ENDLOOP.
                  IF lv_err IS INITIAL.
                    lv_app_stat = 'S'.
                  ENDIF.

              ENDCASE.
              IF lv_app_stat = 'T'.
                DATA(lv_sent_date) = sy-datum.
              ENDIF.
            ELSE.
              lv_err = abap_true.
              APPEND VALUE #(
                            %msg                = new_message(  id       = 'ZEP_DT'
                                                                number   = '007'
                                                                severity = if_abap_behv_message=>severity-information )
*                                                           v1 = 'No Valid Data to validate"' )
                                                                ) TO reported-details.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.


    ENDIF.

    IF lv_err IS INITIAL.

      IF lv_req_type IS INITIAL AND lv_app_stat IS INITIAL AND lv_payee_num IS INITIAL.
        lv_err = abap_true.
        APPEND VALUE #(
                      %msg                = new_message(  id       = 'ZEP_DT'
                                                          number   = '009'
                                                          severity = if_abap_behv_message=>severity-information )
*                                                           v1 = 'No Valid Data to validate"' )
                                                          ) TO reported-details.
      ELSE.

        LOOP AT lt_ep_data ASSIGNING FIELD-SYMBOL(<lfs_ep_data>).
          IF lv_req_type IS NOT INITIAL.
            <lfs_ep_data>-request_type = lv_req_type.
          ENDIF.
          IF lv_app_stat IS NOT INITIAL.
            <lfs_ep_data>-approval_status = lv_app_stat.
            IF lv_app_stat = 'S'.
              <lfs_ep_data>-comment_ = 'Workflow is submitted for Approval'.
            ENDIF.
          ENDIF.
          IF lv_payee_num IS NOT INITIAL.
            <lfs_ep_data>-payee_number = lv_payee_num.
          ENDIF.
          IF lv_payee_name IS NOT INITIAL.
            <lfs_ep_data>-payee_name = lv_payee_name.
          ENDIF.
          IF lv_sent_date IS NOT INITIAL.
            <lfs_ep_data>-tracker_sent_date = lv_sent_date.
          ENDIF.
          <lfs_ep_data>-changed_by = sy-uname.
          <lfs_ep_data>-changed_date = sy-datum.
          <lfs_ep_data>-changed_time = sy-uzeit.
          APPEND VALUE #(
                  %msg                = new_message(  id       = 'ZEP_DT'
                                                      number   = '010'
                                                      severity = if_abap_behv_message=>severity-success
                                                      v1 = <lfs_ep_data>-edi_trans_no )

                  ) TO reported-details.
          DATA(lv_validate_suc) = abap_true.
        ENDLOOP.
      ENDIF.

    ENDIF.

    IF lv_validate_suc = abap_true AND lv_err IS INITIAL.
      MODIFY ENTITIES OF zfiap_ep_data2 IN LOCAL MODE
        ENTITY details
          UPDATE FIELDS ( request_type approval_status payee_number payee_name tracker_sent_date comment_ changed_by changed_date changed_time )
          WITH CORRESPONDING #( lt_ep_data ).

      IF lv_app_stat = 'S'.
        DATA(lt_wf_process) = lt_ep_data.
        DELETE lt_wf_process WHERE approval_status <> 'S'.
        IF lt_wf_process IS NOT INITIAL.
          lt_wf_key = CORRESPONDING #( lt_wf_process ).

          CALL FUNCTION 'Z_FIAP_EP_DATA_TRIGGER_WF'
            DESTINATION 'NONE'
            EXPORTING
              it_wf_key = lt_wf_key.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD post.

    READ ENTITIES OF zfiap_ep_data2 IN LOCAL MODE
       ENTITY details
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(lt_ep_data)
       FAILED failed.


    LOOP AT lt_ep_data ASSIGNING FIELD-SYMBOL(<ls_ep_data>).
      <ls_ep_data>-document_type = 'XX'.
    ENDLOOP.
    " write back the modified total_price of travels
    MODIFY ENTITIES OF zfiap_ep_data2 IN LOCAL MODE
      ENTITY details
        UPDATE FIELDS ( approval_status posting_date document_type document_number )
        WITH CORRESPONDING #( lt_ep_data ).


  ENDMETHOD.

  METHOD validate.

    DATA lt_wf_key TYPE zep_data_wf_key_tt.
    DATA lv_validation_date LIKE sy-datum.
    READ ENTITIES OF zfiap_ep_data2 IN LOCAL MODE
     ENTITY details
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_ep_data_upd)
     FAILED failed.

    DATA(lt_keys) = keys.
    READ TABLE lt_keys INTO DATA(ls_key) INDEX 1.
    IF sy-subrc IS INITIAL.
      IF ls_key-%param-conf_val = abap_true.
        IF lt_ep_data_upd IS NOT INITIAL.
          SELECT * FROM
          zfiap_ep_data
          INTO TABLE @DATA(lt_ep_data)
          FOR ALL ENTRIES IN @lt_ep_data_upd
          WHERE edi_trans_no = @lt_ep_data_upd-edi_trans_no.
          IF sy-subrc IS INITIAL.
            DELETE lt_ep_data_upd WHERE approval_status = 'G'.
            " DELETE lt_ep_data_upd WHERE approval_status = 'A'.
            DELETE lt_ep_data_upd WHERE approval_status = 'X    '.
            IF lt_ep_data_upd IS NOT INITIAL.
              SELECT *                             "#EC CI_NO_TRANSFORM
              FROM zfiap_ep_rules
              INTO TABLE @DATA(lt_zfiap_ep_rules)
              FOR ALL ENTRIES IN @lt_ep_data
              WHERE
*              escheat_rule = 'I' AND
              state = @lt_ep_data-business_unit_state.

              IF sy-subrc IS INITIAL.
                LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_key>).
                  LOOP AT lt_ep_data ASSIGNING FIELD-SYMBOL(<ls_ep_data>).

*Escheat Rule, Remit Type, Holding Period, HP UOM, Pay Immediate Delay Period Days, Holding Period Expire Date
                    READ TABLE lt_zfiap_ep_rules INTO DATA(ls_zfiap_ep_rules) WITH KEY state = <ls_ep_data>-business_unit_state.
                    IF sy-subrc IS INITIAL.
                      <ls_ep_data>-escheat_rule = ls_zfiap_ep_rules-escheat_rule.
                      <ls_ep_data>-remit_type = ls_zfiap_ep_rules-remit_type.
                      <ls_ep_data>-holding_period = ls_zfiap_ep_rules-holding_period.
                      <ls_ep_data>-hp_uom = ls_zfiap_ep_rules-hp_uom.
                      <ls_ep_data>-pi_delay_period = ls_zfiap_ep_rules-pi_delay.

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
                          <ls_ep_data>-changed_by = sy-uname.
                          <ls_ep_data>-changed_date = sy-datum.
                          <ls_ep_data>-changed_time = sy-uzeit.
                          APPEND VALUE #( %tky                = <fs_key>-%tky
                                          %msg                = new_message(  id       = 'ZEP_DT'
                                                                              number   = '004' " Document cannot be extended into the past
                                                                              severity = if_abap_behv_message=>severity-success
                                                                              v1 = <fs_key>-edi_trans_no
*                                                                            v2 = 'Succesfully Validated'
                                                                              )
*                            %element-ValidTo = if_abap_behv=>mk-on
                                          ) TO reported-details.

                        ELSE.
                          APPEND VALUE #( %tky                = <fs_key>-%tky
                                          %msg                = new_message(  id       = 'ZEP_DT'
                                                                              number   = '003' " Document cannot be extended into the past
                                                                              severity = if_abap_behv_message=>severity-information
                                                                              v1 = <fs_key>-edi_trans_no
*                                                                            v2 = 'Date is not current'
                                                                              )
                                                                              ) TO reported-details.
                        ENDIF.
                        CLEAR lv_validation_date.
                      ENDIF.
                    ELSE.
                      APPEND VALUE #( %tky                = <fs_key>-%tky
                                      %msg                = new_message(  id       = 'ZEP_DT'
                                                                          number   = '002' " Document cannot be extended into the past
                                                                          severity = if_abap_behv_message=>severity-information
                                                                          v1 = <fs_key>-edi_trans_no
*                                                                        v2 = 'Escheat Rule is not "Immediate"'
                                                                          )
                                                                          ) TO reported-details.
                    ENDIF.
                  ENDLOOP.
                ENDLOOP.
              ELSE.
                APPEND VALUE #(
                               %msg                = new_message(  id       = 'ZEP_DT'
                                                                   number   = '005' " Document cannot be extended into the past
                                                                   severity = if_abap_behv_message=>severity-information )
*                                                           v1 = 'No Valid Data to validate"' )
                                                                   ) TO reported-details.
              ENDIF.
            ENDIF.
          ELSE.
            APPEND VALUE #(
               %msg                = new_message(  id       = 'ZEP_DT'
                                                   number   = '005' " Document cannot be extended into the past
                                                   severity = if_abap_behv_message=>severity-information )
*                                                           v1 = 'No Valid Data to validate"' )
                                                   ) TO reported-details.
          ENDIF.
        ELSE.
          APPEND VALUE #(
                         %msg                = new_message(  id       = 'ZEP_DT'
                                                             number   = '005' " Document cannot be extended into the past
                                                             severity = if_abap_behv_message=>severity-information )
*                                                           v1 = 'No Valid Data to validate"' )
                                                             ) TO reported-details.

        ENDIF.

        IF lv_validate_suc = abap_true.
          MODIFY ENTITIES OF zfiap_ep_data2 IN LOCAL MODE
            ENTITY details
              UPDATE FIELDS ( escheat_rule remit_type holding_period hp_uom pi_delay_period hp_expire_date
              request_type approval_status comment_ changed_by changed_date changed_time )
              WITH CORRESPONDING #( lt_ep_data ).

          DATA(lt_wf_process) = lt_ep_data.
          DELETE lt_wf_process WHERE approval_status <> 'S'.
          IF lt_wf_process IS NOT INITIAL.
            lt_wf_key = CORRESPONDING #( lt_wf_process ).


            CALL FUNCTION 'Z_FIAP_EP_DATA_TRIGGER_WF'
              DESTINATION 'NONE'
              EXPORTING
                it_wf_key = lt_wf_key.
          ENDIF.
        ENDIF.
      ELSE.
        APPEND VALUE #(
                       %msg                = new_message(  id       = 'ZEP_DT'
                                                           number   = '001' " Document cannot be extended into the past
                                                           severity = if_abap_behv_message=>severity-information )
*                                                           v1 = 'Conifrmation is Required"' )
                                                           ) TO reported-details.
      ENDIF.
    ENDIF.
  ENDMETHOD.

*  METHOD get_instance_features.
*  ENDMETHOD.

  METHOD extract.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zfiap_ep_data2 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

*    METHODS finalize REDEFINITION.

*    METHODS check_before_save REDEFINITION.

*    METHODS adjust_numbers REDEFINITION.

*    METHODS save REDEFINITION.

*    METHODS cleanup REDEFINITION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zfiap_ep_data2 IMPLEMENTATION.

*  METHOD finalize.
*  ENDMETHOD.

*  METHOD check_before_save.
*  ENDMETHOD.

*  METHOD adjust_numbers.
*  ENDMETHOD.

*  METHOD save.
*  ENDMETHOD.

*  METHOD cleanup.
*  ENDMETHOD.

  METHOD save_modified.

    "Data Declaration


    DATA: lt_ep_change      TYPE STANDARD TABLE OF zfiap_ep_pers,
          lr_edi_trans_no   TYPE RANGE OF zfiap_ep_data-edi_trans_no,
          lt_ep_att         TYPE STANDARD TABLE OF zfiap_ep_data_at,
          lt_ep_att_upd     TYPE STANDARD TABLE OF zfiap_ep_data_at,
          lt_ep_data        TYPE STANDARD TABLE OF zfiap_ep_data,
          lt_ep_data_upd    TYPE STANDARD TABLE OF zfiap_ep_data,
          lt_ep_controlflag TYPE STANDARD TABLE OF zfiap_x_ep_pers,
          ls_ep_controlflag LIKE LINE OF lt_ep_controlflag.


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

    IF update IS NOT INITIAL.
      lt_ep_change = CORRESPONDING #( update-details ).

      IF lt_ep_change IS NOT INITIAL.

        LOOP AT  update-details INTO DATA(ls_details_change).
          MOVE-CORRESPONDING ls_details_change-%control TO ls_ep_controlflag.
*          ls_ep_controlflag = ls_details_change-%control.
*          ls_ep_controlflag-changed_by = ls_details_change-%control-changed_by.
*          ls_ep_controlflag-changed_date = ls_details_change-%control-changed_date.
          APPEND ls_ep_controlflag TO lt_ep_controlflag.
        ENDLOOP.
*        ls_ep_controlflag = CORRESPONDING #( update-details[ 1 ]-%control ).


        "Fill range value for all the updated Inspections
        lr_edi_trans_no = VALUE #( FOR ls_edi_trans_no IN update-details
                                       (  sign = 'I' option = 'EQ' low = ls_edi_trans_no-edi_trans_no )
                                     ).
        IF lr_edi_trans_no IS NOT INITIAL.

          lt_ep_data_upd = CORRESPONDING #( lt_ep_change )." FROM ENTITY ).
          lt_ep_att_upd = CORRESPONDING #( lt_ep_change )." FROM ENTITY ).

          LOOP AT lt_ep_data_upd ASSIGNING FIELD-SYMBOL(<ls_ep_data>) WHERE document_type ='XX' .

            doc_header-comp_code = '1000'."<ls_ep_data>-company_code.
            doc_header-fis_period = sy-datum+4(2).
            doc_header-fisc_year = sy-datum+0(4).
            doc_header-doc_type = 'ZE'.
            doc_header-header_txt = <ls_ep_data>-edi_trans_no.
            doc_header-ref_doc_no = <ls_ep_data>-invoice_number.
            doc_header-pstng_date = sy-datum.
            doc_header-doc_date = sy-datum."<ls_ep_data>-sales_date.
            doc_header-username = sy-uname.
            doc_header-ref_doc_no = <ls_ep_data>-edi_trans_no.

            doc_item_gl = VALUE #( ( itemno_acc = '1'
                                        gl_account =  '0000200110' "<ls_ep_data>-gl_account
                                        item_text = <ls_ep_data>-exp_remark
                                        comp_code = '1000'"<ls_ep_data>-company_code
                                        fis_period = sy-datum+4(2)
                                        profit_ctr = '0000000507'"<ls_ep_data>-business_unit
                                        costcenter = '0000000507'"<ls_ep_data>-business_unit
                                        ) ).

            doc_pay = VALUE #( ( itemno_acc = '2'
                                 vendor_no = 'W25013850'"<ls_ep_data>-tenant_number
                                 ) ).

            doc_recv = VALUE #( ( itemno_acc = '1'
                                    currency = 'USD'"<ls_ep_data>-waers
                                    amt_doccur = 100"<ls_ep_data>-amount
                                    )
                                    ( itemno_acc = '2'
                                    currency = 'USD'"<ls_ep_data>-waers
                                    amt_doccur = ( 100  * ( -1 ) ) ) ). "( <ls_ep_data>-amount  * ( -1 ) ) ) ).

            SELECT SINGLE xbilk FROM ska1 INTO @DATA(lv_xbilk)
              WHERE saknr = @<ls_ep_data>-gl_account AND ktopl  = 'PSUS'.

            IF lv_xbilk = space.
              criteria = VALUE #( ( itemno_acc = '1'
                                    fieldname = 'PRCTR'
                                    character = <ls_ep_data>-business_unit ) ).
            ENDIF.

            CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
*              DESTINATION 'DS4CLNT110'
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

            IF line_exists( return[ type = 'E' ] ).
            ELSE.
********************************* updating table ********************************************************************
              <ls_ep_data>-approval_status = 'G'.
              <ls_ep_data>-posting_date = sy-datum.
              <ls_ep_data>-document_type = 'ZE'.
              <ls_ep_data>-document_number = lv_obj_key+0(10).
********************************************************************************************************************
            ENDIF.
          ENDLOOP.


          "Get Old DB Values
          SELECT *
              FROM zfiap_ep_data
              INTO TABLE @DATA(lt_zfiap_ep_data)
              WHERE edi_trans_no IN @lr_edi_trans_no.

          IF sy-subrc IS INITIAL.

            LOOP AT lt_ep_data_upd ASSIGNING FIELD-SYMBOL(<ls_ep_data1>) WHERE document_type ='XX' .
              READ TABLE lt_zfiap_ep_data ASSIGNING FIELD-SYMBOL(<ls_zfiap_ep_data>) WITH KEY edi_trans_no = <ls_ep_data1>-edi_trans_no.
              IF sy-subrc IS INITIAL.
                <ls_ep_data1>-document_type = <ls_zfiap_ep_data>-document_type.
              ENDIF..
            ENDLOOP.
            "Prepare DB Table to update
            lt_ep_data = VALUE #(
                                          FOR x = 1 WHILE x <= lines( lt_ep_data_upd )
                                          LET
                                            ls_controlflag = VALUE #( lt_ep_controlflag[ x ] OPTIONAL )
                                            ls_ep_data_upd = VALUE #( lt_ep_data_upd[ x ] OPTIONAL )
                                            ls_zfiap_ep_data = VALUE #( lt_zfiap_ep_data[ edi_trans_no = ls_ep_data_upd-edi_trans_no ] OPTIONAL )
                                          IN
                                          (


                                             "Do not update cannonical, semantical keys, administrative fields
                                              edi_trans_no = ls_zfiap_ep_data-edi_trans_no
                                              created_by = ls_zfiap_ep_data-created_by
                                              create_date = ls_zfiap_ep_data-create_date
                                              create_time = ls_zfiap_ep_data-create_time

                                             "Update other columns, if found controlflag as X - else pass DB values
                                              edi_trans_date = COND #( WHEN ls_controlflag-edi_trans_date IS NOT INITIAL THEN ls_ep_data_upd-edi_trans_date ELSE ls_zfiap_ep_data-edi_trans_date )
                                              attachment = COND #( WHEN ls_controlflag-attachment IS NOT INITIAL THEN ls_ep_data_upd-attachment ELSE ls_zfiap_ep_data-attachment )
                                              request_type = COND #( WHEN ls_controlflag-request_type IS NOT INITIAL THEN ls_ep_data_upd-request_type ELSE ls_zfiap_ep_data-request_type )
                                              approval_status = COND #( WHEN ls_controlflag-approval_status IS NOT INITIAL THEN ls_ep_data_upd-approval_status ELSE ls_zfiap_ep_data-approval_status )
                                              tenant_number = COND #( WHEN ls_controlflag-tenant_number IS NOT INITIAL THEN ls_ep_data_upd-tenant_number ELSE ls_zfiap_ep_data-tenant_number )
                                              tenant_name = COND #( WHEN ls_controlflag-tenant_name IS NOT INITIAL THEN ls_ep_data_upd-tenant_name ELSE ls_zfiap_ep_data-tenant_name )
                                              payee_number = COND #( WHEN ls_controlflag-payee_number IS NOT INITIAL THEN ls_ep_data_upd-payee_number ELSE ls_zfiap_ep_data-payee_number )
                                              payee_name = COND #( WHEN ls_controlflag-payee_name IS NOT INITIAL THEN ls_ep_data_upd-payee_name ELSE ls_zfiap_ep_data-payee_name )
                                              sales_date = COND #( WHEN ls_controlflag-sales_date IS NOT INITIAL THEN ls_ep_data_upd-sales_date ELSE ls_zfiap_ep_data-sales_date )
                                              gl_account = COND #( WHEN ls_controlflag-gl_account IS NOT INITIAL THEN ls_ep_data_upd-gl_account ELSE ls_zfiap_ep_data-gl_account )
                                              amount = COND #( WHEN ls_controlflag-amount IS NOT INITIAL THEN ls_ep_data_upd-amount ELSE ls_zfiap_ep_data-amount )
                                              waers = COND #( WHEN ls_controlflag-waers IS NOT INITIAL THEN ls_ep_data_upd-waers ELSE ls_zfiap_ep_data-waers )
                                              exp_remark = COND #( WHEN ls_controlflag-exp_remark IS NOT INITIAL THEN ls_ep_data_upd-exp_remark ELSE ls_zfiap_ep_data-exp_remark )
                                              invoice_number = COND #( WHEN ls_controlflag-invoice_number IS NOT INITIAL THEN ls_ep_data_upd-invoice_number ELSE ls_zfiap_ep_data-invoice_number )
                                              business_unit_company_code = COND #( WHEN ls_controlflag-business_unit_company_code IS NOT INITIAL THEN ls_ep_data_upd-business_unit_company_code ELSE ls_zfiap_ep_data-business_unit_company_code )
                                              business_unit = COND #( WHEN ls_controlflag-business_unit IS NOT INITIAL THEN ls_ep_data_upd-business_unit ELSE ls_zfiap_ep_data-business_unit )
                                              business_unit_state = COND #( WHEN ls_controlflag-business_unit_state IS NOT INITIAL THEN ls_ep_data_upd-business_unit_state ELSE ls_zfiap_ep_data-business_unit_state )
                                              business_unit_country = COND #( WHEN ls_controlflag-business_unit_country IS NOT INITIAL THEN ls_ep_data_upd-business_unit_country ELSE ls_zfiap_ep_data-business_unit_country )
                                              tenant_state = COND #( WHEN ls_controlflag-tenant_state IS NOT INITIAL THEN ls_ep_data_upd-tenant_state ELSE ls_zfiap_ep_data-tenant_state )
                                              posting_date = COND #( WHEN ls_controlflag-posting_date IS NOT INITIAL THEN ls_ep_data_upd-posting_date ELSE ls_zfiap_ep_data-posting_date )
                                              company_code = COND #( WHEN ls_controlflag-company_code IS NOT INITIAL THEN ls_ep_data_upd-company_code ELSE ls_zfiap_ep_data-company_code )
                                              document_type = COND #( WHEN ls_controlflag-document_type IS NOT INITIAL THEN ls_ep_data_upd-document_type ELSE ls_zfiap_ep_data-document_type )
                                              document_number = COND #( WHEN ls_controlflag-document_number IS NOT INITIAL THEN ls_ep_data_upd-document_number ELSE ls_zfiap_ep_data-document_number )
                                              comment_ = COND #( WHEN ls_controlflag-comment_ IS NOT INITIAL THEN ls_ep_data_upd-comment_ ELSE ls_zfiap_ep_data-comment_ )
                                              district = COND #( WHEN ls_controlflag-district IS NOT INITIAL THEN ls_ep_data_upd-district ELSE ls_zfiap_ep_data-district )
                                              senior_district = COND #( WHEN ls_controlflag-senior_district IS NOT INITIAL THEN ls_ep_data_upd-senior_district ELSE ls_zfiap_ep_data-senior_district )
                                              region = COND #( WHEN ls_controlflag-region IS NOT INITIAL THEN ls_ep_data_upd-region ELSE ls_zfiap_ep_data-region )
                                              senior_region = COND #( WHEN ls_controlflag-senior_region IS NOT INITIAL THEN ls_ep_data_upd-senior_region ELSE ls_zfiap_ep_data-senior_region )
                                              division = COND #( WHEN ls_controlflag-division IS NOT INITIAL THEN ls_ep_data_upd-division ELSE ls_zfiap_ep_data-division )
                                              zzone = COND #( WHEN ls_controlflag-zzone IS NOT INITIAL THEN ls_ep_data_upd-zzone ELSE ls_zfiap_ep_data-zzone )
                                              escheat_rule = COND #( WHEN ls_controlflag-escheat_rule IS NOT INITIAL THEN ls_ep_data_upd-escheat_rule ELSE ls_zfiap_ep_data-escheat_rule )
                                              remit_type = COND #( WHEN ls_controlflag-remit_type IS NOT INITIAL THEN ls_ep_data_upd-remit_type ELSE ls_zfiap_ep_data-remit_type )
                                              holding_period = COND #( WHEN ls_controlflag-holding_period IS NOT INITIAL THEN ls_ep_data_upd-holding_period ELSE ls_zfiap_ep_data-holding_period )
                                              hp_uom = COND #( WHEN ls_controlflag-hp_uom IS NOT INITIAL THEN ls_ep_data_upd-hp_uom ELSE ls_zfiap_ep_data-hp_uom )
                                              pi_delay_period = COND #( WHEN ls_controlflag-pi_delay_period IS NOT INITIAL THEN ls_ep_data_upd-pi_delay_period ELSE ls_zfiap_ep_data-pi_delay_period )
                                              hp_expire_date = COND #( WHEN ls_controlflag-hp_expire_date IS NOT INITIAL THEN ls_ep_data_upd-hp_expire_date ELSE ls_zfiap_ep_data-hp_expire_date )
                                              tracker_sent_date = COND #( WHEN ls_controlflag-tracker_sent_date IS NOT INITIAL THEN ls_ep_data_upd-tracker_sent_date ELSE ls_zfiap_ep_data-tracker_sent_date )
                                              changed_by = COND #( WHEN ls_controlflag-changed_by IS NOT INITIAL THEN ls_ep_data_upd-changed_by ELSE ls_zfiap_ep_data-changed_by )
                                              changed_date = COND #( WHEN ls_controlflag-changed_date IS NOT INITIAL THEN ls_ep_data_upd-changed_date ELSE ls_zfiap_ep_data-changed_date )
                                              changed_time = COND #( WHEN ls_controlflag-changed_time IS NOT INITIAL THEN ls_ep_data_upd-changed_time ELSE ls_zfiap_ep_data-changed_time )
                                          )


                                       ).


            SELECT *
                FROM zfiap_ep_data_at
                INTO TABLE @DATA(lt_zfiap_ep_data_at)
                WHERE edi_trans_no IN @lr_edi_trans_no.
            IF sy-subrc IS INITIAL.
              lt_ep_att = VALUE #(
                                                        FOR x = 1 WHILE x <= lines( lt_ep_att_upd )
                                                        LET
                                                          ls_controlflag = VALUE #( lt_ep_controlflag[ x ] OPTIONAL )
                                                          ls_ep_att_upd = VALUE #( lt_ep_att_upd[ x ] OPTIONAL )
                                                          ls_zfiap_ep_data_at = VALUE #( lt_zfiap_ep_data_at[ edi_trans_no = ls_ep_att_upd-edi_trans_no ] OPTIONAL )
                                                        IN
                                                        (

              "Do not update cannonical, semantical keys, administrative fields
                                                            edi_trans_no = ls_zfiap_ep_data_at-edi_trans_no
                                                            attachment = COND #( WHEN ls_controlflag-attachment IS NOT INITIAL THEN ls_ep_att_upd-attachment ELSE ls_zfiap_ep_data_at-attachment )
                                                            mimetype = COND #( WHEN ls_controlflag-attachment IS NOT INITIAL THEN ls_ep_att_upd-mimetype ELSE ls_zfiap_ep_data_at-mimetype )
                                                            attfile = COND #( WHEN ls_controlflag-attachment IS NOT INITIAL THEN ls_ep_att_upd-attfile ELSE ls_zfiap_ep_data_at-attfile )
                                                        )


                                                     ).
            ELSE.
              lt_ep_att = lt_ep_att_upd.
            ENDIF.



          ENDIF.
        ENDIF.

      ENDIF.
*      details MAPPING FROM ENTITY ).
*      ls_ep_controlflag = CORRESPONDING #( update-details[ 1 ]-%control ).

      IF lt_ep_att IS NOT INITIAL.
        MODIFY zfiap_ep_data_at FROM TABLE lt_ep_att.

*        APPEND VALUE #(
*                        %msg                = new_message(  id       = 'ZEP_DT'
*                                                            number   = '000' " Document cannot be extended into the past
*                                                            severity = if_abap_behv_message=>severity-success
*                                                            v1 = 'Attachment Updated')
**                            %element-ValidTo = if_abap_behv=>mk-on
*                        ) TO reported-details.

      ENDIF.
      IF lt_ep_data IS NOT INITIAL.
        MODIFY zfiap_ep_data FROM TABLE lt_ep_data.
        APPEND VALUE #(
                        %msg                = new_message(  id       = 'ZEP_DT'
                                                            number   = '000' " Document cannot be extended into the past
                                                            severity = if_abap_behv_message=>severity-success
                                                            v1 = 'Data Updated')
*                            %element-ValidTo = if_abap_behv=>mk-on
                        ) TO reported-details.
      ENDIF.
      APPEND VALUE #(
                         %msg                = new_message(  id       = 'ZEP_DT'
                                                             number   = '000' " Document cannot be extended into the past
                                                             severity = if_abap_behv_message=>severity-success
                                                             v1 = 'Data Processing Completed')
*                                                    %element-ValidTo = if_abap_behv=>mk-on
                         ) TO reported-details.
    ENDIF.
  ENDMETHOD.


  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
