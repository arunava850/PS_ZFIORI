FUNCTION z_fiap_ep_data_trigger_wf.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IT_WF_KEY) TYPE  ZEP_DATA_WF_KEY_TT
*"----------------------------------------------------------------------
  DATA:ls_key         TYPE pernr,

       lv_objtype     TYPE sibftypeid,
       lv_event       TYPE sibfevent,
       lv_objkey      TYPE sibfinstid,
       ls_event_data  TYPE zde_wp_wf_id,
       lt_zfiap_ep_wf TYPE STANDARD TABLE OF zfiap_ep_wf,
       lv_ep_wf_id    TYPE  zde_wp_wf_id.

  IF it_wf_key IS NOT INITIAL.


    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZEPWF_ID'
*       QUANTITY                = '1'
*       SUBOBJECT               = ' '
*       TOYEAR                  = '0000'
*       IGNORE_BUFFER           = ' '
      IMPORTING
        number                  = lv_ep_wf_id
*       QUANTITY                =
*       RETURNCODE              =
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    lt_zfiap_ep_wf = CORRESPONDING #( it_wf_key ).

    LOOP AT lt_zfiap_ep_wf ASSIGNING FIELD-SYMBOL(<lfs_zfiap_ep_wf>).

      <lfs_zfiap_ep_wf>-ep_wf_id = lv_ep_wf_id.
      <lfs_zfiap_ep_wf>-created_by = sy-uname.
      <lfs_zfiap_ep_wf>-create_date = sy-datum.
      <lfs_zfiap_ep_wf>-create_time = sy-uzeit.

    ENDLOOP.

    IF <lfs_zfiap_ep_wf> IS ASSIGNED.
      UNASSIGN <lfs_zfiap_ep_wf>.
    ENDIF.

    SELECT * FROM zfiap_ep_wf
    INTO TABLE @DATA(lt_existing_wf)
    FOR ALL ENTRIES IN @it_wf_key
    WHERE edi_trans_no = @it_wf_key-edi_trans_no.
    IF sy-subrc IS INITIAL.
      LOOP AT lt_existing_wf ASSIGNING FIELD-SYMBOL(<ls_existing_wf>).

        <ls_existing_wf>-zinactive = abap_true.
        <ls_existing_wf>-created_by = sy-uname.
        <ls_existing_wf>-create_date = sy-datum.
        <ls_existing_wf>-create_time = sy-uzeit.

      ENDLOOP.
      APPEND LINES OF lt_existing_wf TO lt_zfiap_ep_wf.
    ENDIF.

    IF <ls_existing_wf> IS ASSIGNED.
      UNASSIGN <ls_existing_wf>.
    ENDIF.

    IF lt_zfiap_ep_wf IS NOT INITIAL.

      MODIFY  zfiap_ep_wf FROM TABLE lt_zfiap_ep_wf.

      COMMIT WORK AND WAIT.

    ENDIF.

    lv_objtype = 'ZCL_FIAP_EP_WORKFLOW'.
    lv_event = 'CREATED'.

*SET up the lpor instance id
    lv_objkey =  lv_ep_wf_id.


*Instantiate an empty event container

    DATA(lr_event_parameters) = cl_swf_evt_event=>get_event_container(
      im_objcateg = cl_swf_evt_event=>mc_objcateg_cl
      im_objtype  = lv_objtype
      im_event    = lv_event ).

    ls_event_data = lv_ep_wf_id.

    TRY.
        lr_event_parameters->set(
          EXPORTING
            name  = 'IS_DATA'                " Name of Parameter Whose Value Is to Be Set
            value = ls_event_data               " Value
        ).
      CATCH cx_swf_cnt_cont_access_denied. " Changed Access Not Allowed
      CATCH cx_swf_cnt_elem_access_denied. " Value/Unit Must Not Be Changed
      CATCH cx_swf_cnt_elem_not_found.     " Element Not in the Container
      CATCH cx_swf_cnt_elem_type_conflict. " Type Conflict Between Value and Current Parameter
      CATCH cx_swf_cnt_unit_type_conflict. " Type Conflict Between Unit and Current Parameter
      CATCH cx_swf_cnt_elem_def_invalid.   " Element Definition Is Invalid (Internal Error)
      CATCH cx_swf_cnt_container.          " Exception in the Container Service
    ENDTRY.

*    DATA: lr_wf TYPE REF TO zcl_fiap_ep_workflow.
*
*    CREATE OBJECT lr_wf
*      EXPORTING
*        iv_object_id = lv_ep_wf_id.

*RAISE the event
    TRY.
        CALL METHOD cl_swf_evt_event=>raise
          EXPORTING
            im_objcateg        = cl_swf_evt_event=>mc_objcateg_cl
            im_objtype         = lv_objtype
            im_event           = lv_event
            im_objkey          = lv_objkey
            im_event_container = lr_event_parameters.
      CATCH cx_swf_evt_invalid_objtype .
      CATCH cx_swf_evt_invalid_event .
    ENDTRY.

    COMMIT WORK." AND WAIT.

  ENDIF.

ENDFUNCTION.
