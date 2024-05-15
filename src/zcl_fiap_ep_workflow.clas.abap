CLASS zcl_fiap_ep_workflow DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES bi_object .
    INTERFACES bi_persistent .
    INTERFACES if_workflow .

    DATA mv_object_id TYPE zde_wp_wf_id .

    EVENTS created
      EXPORTING
        VALUE(is_data) TYPE zde_wp_wf_id .
    EVENTS restart_workflow
      EXPORTING
        VALUE(is_data) TYPE zde_wp_wf_id .
    EVENTS cancel_workflow
      EXPORTING
        VALUE(is_data) TYPE zde_wp_wf_id .

    METHODS constructor
      IMPORTING
        !iv_object_id TYPE zde_wp_wf_id .
    METHODS post
      IMPORTING
        VALUE(is_data)  TYPE zde_wp_wf_id
        VALUE(is_actor) TYPE ernam .
    METHODS update_ep_data
      IMPORTING
        VALUE(is_data)     TYPE zde_wp_wf_id
        VALUE(is_new_stat) TYPE zasd
        VALUE(is_actor)    TYPE ernam .
    METHODS get_approver
      IMPORTING
        VALUE(is_data) TYPE zde_wp_wf_id .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FIAP_EP_WORKFLOW IMPLEMENTATION.


  METHOD bi_object~default_attribute_value.
  ENDMETHOD.


  METHOD bi_object~execute_default_method.
  ENDMETHOD.


  METHOD bi_object~release.
  ENDMETHOD.


  METHOD bi_persistent~find_by_lpor.
*   importing LPOR TYPE SIBFLPOR
*   returning RESULT TYPE REF TO BI_PERSISTENT
    DATA: lv_wp_wf_id TYPE zde_wp_wf_id.
    lv_wp_wf_id  = lpor-instid.
    result = NEW zcl_fiap_ep_workflow( lv_wp_wf_id ).
  ENDMETHOD.


  METHOD bi_persistent~lpor.
*   returning RESULT TYPE SIBFLPOR
    result-catid  = cl_swf_evt_event=>mc_objcateg_cl. " = 'CL'
    result-typeid = 'ZCL_FIAP_EP_WORKFLOW'.
    result-instid = mv_object_id.
  ENDMETHOD.


  METHOD bi_persistent~refresh.
  ENDMETHOD.


  METHOD constructor.
    "   importing: IV_OBJECT_ID TYPE REQNO
    CALL METHOD super->constructor.
    mv_object_id = iv_object_id.

  ENDMETHOD.


  METHOD get_approver.
  ENDMETHOD.


  METHOD post.

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
          obj_sys     TYPE bapiache02-obj_sys.
    DATA : lv_obj_type TYPE   bapiache09-obj_type,
           lv_obj_key  TYPE bapiache09-obj_key,
           lv_obj_sys  TYPE bapiache09-obj_sys,
           lt_criteria TYPE STANDARD TABLE OF bapiackec9,
           ls_criteria TYPE bapiackec9,
           lv_saknr    TYPE saknr.

    IF is_data IS NOT INITIAL.
      SELECT * FROM zfiap_ep_wf AS a
      INTO TABLE @DATA(lt_zfiap_ep_wf)
      WHERE a~ep_wf_id = @is_data.
      IF lt_zfiap_ep_wf IS NOT INITIAL.
        SELECT * FROM zfiap_ep_data AS b    "#EC CI_NO_TRANSFORM
        INTO TABLE @DATA(lt_zfiap_ep_data)
        FOR ALL ENTRIES IN @lt_zfiap_ep_wf
        WHERE edi_trans_no = @lt_zfiap_ep_wf-edi_trans_no
          AND approval_status = 'A'.
        .
        IF sy-subrc IS INITIAL.
*          READ TABLE lt_zfiap_ep_data INTO DATA(ls_zfiap_ep_data) INDEX 1.
          IF sy-subrc  IS INITIAL.

            LOOP AT lt_zfiap_ep_data ASSIGNING FIELD-SYMBOL(<ls_ep_data>)." WHERE document_type ='XX' .
              CLEAR: doc_header, doc_item_gl, doc_pay, doc_recv, criteria, lv_obj_type, lv_obj_key, lv_obj_sys.
              doc_header-comp_code = '7005'. "As per issue SAP-1914 <ls_ep_data>-business_unit_company_code." company_code. "'1000'.
              doc_header-fis_period = sy-datum+4(2).
              doc_header-fisc_year = sy-datum+0(4).
              doc_header-doc_type = 'ZE'.
              doc_header-header_txt = <ls_ep_data>-edi_trans_no.
              doc_header-ref_doc_no = <ls_ep_data>-invoice_number.
              doc_header-pstng_date = sy-datum.
              doc_header-doc_date = <ls_ep_data>-sales_date. "sy-datum.
              doc_header-username = sy-uname.
*              doc_header-ref_doc_no = <ls_ep_data>-invoice_number.


              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = <ls_ep_data>-gl_account
                IMPORTING
                  output = lv_saknr.

              doc_item_gl = VALUE #( ( itemno_acc = '1'
                                          gl_account =  lv_saknr "'0000200110'
                                          item_text = <ls_ep_data>-exp_remark
                                          comp_code = '7005' "As per issue SAP-1914 <ls_ep_data>-business_unit_company_code "company_code "'1000'
                                          fis_period = sy-datum+4(2)
                                          profit_ctr = '7005Z' "'0000000507'"  "<ls_ep_data>-business_unit
                                          costcenter = '7005Z' " '0000000507'"  "<ls_ep_data>-business_unit
                                          ) ).
              CLEAR lt_criteria.
              ls_criteria-itemno_acc = 0000000001.
              ls_criteria-fieldname = 'PRCTR' .
              ls_criteria-character = '7005Z' .
              APPEND ls_criteria TO lt_criteria.
              CLEAR ls_criteria.
              ls_criteria-itemno_acc = 0000000001.
              ls_criteria-fieldname = 'COPA_KOSTL' .
              ls_criteria-character = '7005Z' .
              APPEND ls_criteria TO lt_criteria.
              CLEAR ls_criteria.


              doc_pay = VALUE #( ( itemno_acc = '2'
                                   vendor_no = <ls_ep_data>-payee_number" tenant_number "'W25013850'
                                   ) ).

              doc_recv = VALUE #( ( itemno_acc = '1'
                                      currency = <ls_ep_data>-waers "'USD'
                                      amt_doccur = <ls_ep_data>-amount "100
                                      )
                                      ( itemno_acc = '2'
                                      currency = <ls_ep_data>-waers "'USD'
                                      amt_doccur =  ( <ls_ep_data>-amount  * ( -1 ) ) ) ). "( 100  * ( -1 ) ) ) ).

*              SELECT SINGLE xbilk FROM ska1 INTO @DATA(lv_xbilk)
*                WHERE saknr = @<ls_ep_data>-gl_account AND ktopl  = 'PSUS'.
*
*              IF lv_xbilk = space.
*                criteria = VALUE #( ( itemno_acc = '1'
*                                      fieldname = 'PRCTR'
*                                      character = <ls_ep_data>-business_unit ) ).
*              ENDIF.

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
                  criteria       = lt_criteria
                  return         = return.

              IF line_exists( return[ type = 'E' ] ).
                DATA(lv_err) = abap_true.
                CLEAR <ls_ep_data>-comment_ .
                LOOP AT return INTO DATA(ls_return).
                  CONCATENATE ls_return-message <ls_ep_data>-comment_
                  INTO <ls_ep_data>-comment_ SEPARATED BY space .
                ENDLOOP.
              ELSE.
********************************* updating table ********************************************************************
                <ls_ep_data>-approval_status = 'G'.
                <ls_ep_data>-posting_date = sy-datum.
                <ls_ep_data>-document_type = 'ZE'.
                <ls_ep_data>-document_number = lv_obj_key+0(10).
                <ls_ep_data>-changed_by = is_actor.
                <ls_ep_data>-changed_date = sy-datum.
                <ls_ep_data>-changed_time = sy-uzeit.
                CLEAR <ls_ep_data>-comment_ .
                CONCATENATE 'Posted document ' <ls_ep_data>-document_number
                'in company code ' <ls_ep_data>-business_unit_company_code
                INTO <ls_ep_data>-comment_ SEPARATED BY space.
********************************************************************************************************************
              ENDIF.
            ENDLOOP.
            MODIFY zfiap_ep_data FROM TABLE lt_zfiap_ep_data.
            IF sy-subrc IS INITIAL.
              IF lv_err IS INITIAL.
                READ TABLE lt_zfiap_ep_wf INTO DATA(ls_zfiap_ep_wf) INDEX 1.
                IF sy-subrc  IS INITIAL.
                  ls_zfiap_ep_wf-changed_by = is_actor.
                  ls_zfiap_ep_wf-changed_date = sy-datum.
                  ls_zfiap_ep_wf-changed_time = sy-uzeit.
                  MODIFY lt_zfiap_ep_wf FROM ls_zfiap_ep_wf TRANSPORTING changed_by changed_date changed_time  WHERE edi_trans_no <> ''.
                  IF sy-subrc IS INITIAL.
                    MODIFY zfiap_ep_wf FROM TABLE lt_zfiap_ep_wf.
*                    IF sy-subrc IS INITIAL.
*                      COMMIT WORK AND WAIT.
*                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
              COMMIT WORK AND WAIT.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD update_ep_data.

    IF is_data IS NOT INITIAL.
      SELECT * FROM zfiap_ep_wf AS a
      INTO TABLE @DATA(lt_zfiap_ep_wf)
      WHERE a~ep_wf_id = @is_data.
      IF lt_zfiap_ep_wf IS NOT INITIAL.
        SELECT * FROM zfiap_ep_data AS b    "#EC CI_NO_TRANSFORM
        INTO TABLE @DATA(lt_zfiap_ep_data)
        FOR ALL ENTRIES IN @lt_zfiap_ep_wf
        WHERE edi_trans_no = @lt_zfiap_ep_wf-edi_trans_no.
        IF sy-subrc IS INITIAL.
          READ TABLE lt_zfiap_ep_data INTO DATA(ls_zfiap_ep_data) INDEX 1.
          IF sy-subrc  IS INITIAL.
            ls_zfiap_ep_data-approval_status = is_new_stat.
            IF ls_zfiap_ep_data-request_type = '04' AND
            ls_zfiap_ep_data-approval_status = 'A'.
              ls_zfiap_ep_data-approval_status = 'X'.
            ENDIF.
            CASE ls_zfiap_ep_data-approval_status.
              WHEN 'A'.
                ls_zfiap_ep_data-comment_ = 'Workflow is Approved'.
              WHEN 'H'.
                ls_zfiap_ep_data-comment_ = 'Workflow is Sent Back For Revision'.
              WHEN 'R'.
                ls_zfiap_ep_data-comment_ = 'Workflow is Rejected'.
              WHEN 'X'.
                ls_zfiap_ep_data-comment_ = 'Workflow is Approved for Rejection'.
            ENDCASE.
*            IF is_new_stat = 'A'.
*              ls_zfiap_ep_data-comment_ = 'Workflow is Approved'.
*            ENDIF.
            ls_zfiap_ep_data-changed_by = is_actor.
            ls_zfiap_ep_data-changed_date = sy-datum.
            ls_zfiap_ep_data-changed_time = sy-uzeit.
            MODIFY lt_zfiap_ep_data FROM ls_zfiap_ep_data TRANSPORTING approval_status comment_ changed_by changed_date changed_time WHERE edi_trans_no <> ''.
            IF sy-subrc IS INITIAL.
              READ TABLE lt_zfiap_ep_wf INTO DATA(ls_zfiap_ep_wf) INDEX 1.
              IF sy-subrc  IS INITIAL.
                ls_zfiap_ep_wf-changed_by = is_actor.
                ls_zfiap_ep_wf-changed_date = sy-datum.
                ls_zfiap_ep_wf-changed_time = sy-uzeit.
                MODIFY lt_zfiap_ep_wf FROM ls_zfiap_ep_wf TRANSPORTING changed_by changed_date changed_time  WHERE edi_trans_no <> ''.
                IF sy-subrc IS INITIAL.
                  MODIFY zfiap_ep_data FROM TABLE lt_zfiap_ep_data.
                  IF sy-subrc IS INITIAL.
                    MODIFY zfiap_ep_wf FROM TABLE lt_zfiap_ep_wf.
                    IF sy-subrc IS INITIAL.
                      COMMIT WORK AND WAIT.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
