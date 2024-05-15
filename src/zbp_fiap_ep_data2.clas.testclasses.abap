*"* use this source file for your ABAP unit test classes
CLASS ltcl_details DEFINITION FINAL FOR TESTING
  DURATION LONG
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      cds_test_environment TYPE REF TO if_cds_test_environment,
      sql_test_environment TYPE REF TO if_osql_test_environment,
      lt_ep_data           TYPE STANDARD TABLE OF zfiap_ep_data2,
      lt_ep_base           TYPE STANDARD TABLE OF zfiap_ep_data,
      lt_ep_at             TYPE STANDARD TABLE OF zfiap_ep_data_at,
      lt_ep_lfa1           TYPE STANDARD TABLE OF lfa1. ",

    DATA: lo_cut            TYPE REF TO lhc_details,
          lt_late_reported  TYPE RESPONSE FOR REPORTED EARLY zfiap_ep_data2,
          lt_late_failed    TYPE RESPONSE FOR FAILED EARLY zfiap_ep_data2,
          lt_act_upd_keys   TYPE TABLE FOR ACTION IMPORT zfiap_ep_data2\\details~upd,
          ls_act_upd_param  TYPE zfiap_ep_data_upd,
          lt_act_upd_result TYPE TABLE FOR ACTION RESULT zfiap_ep_data2\\details~upd,
          lt_act_val_keys   TYPE TABLE FOR ACTION IMPORT zfiap_ep_data2\\details~validate,
          lt_act_val_result TYPE TABLE FOR ACTION RESULT zfiap_ep_data2\\details~validate,
          ls_act_val_param  TYPE zfiap_ep_data_con
          .

    CLASS-METHODS:
      class_setup,    " setup test double framework
      class_teardown. " stop test doubles

    METHODS:
      setup,          " reset test doubles
      teardown,
      pop_test_data
        IMPORTING
          iv_scenario TYPE char6,
      clear_test_data,
      pop_upd_scn
        IMPORTING
          iv_act_upd_param TYPE zfiap_ep_data_upd
          iv_key           TYPE i ,
      pop_val_scn
        IMPORTING
          iv_act_val_param TYPE zfiap_ep_data_con
          iv_key           TYPE i .
    METHODS:
      " CUT: create with action call and commit
*      upd_test FOR TESTING RAISING cx_static_check,
*      validate_test FOR TESTING RAISING cx_static_check,
      test_val_scn1 FOR TESTING RAISING cx_static_check,
      test_upd_scn1 FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltcl_details IMPLEMENTATION.
  METHOD class_setup.
*    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
*                            i_for_entities = VALUE #(
*                              ( i_for_entity = 'ZFIAP_EP_DATA2' ) ) ).

    " create test doubles for additional used tables.
    sql_test_environment = cl_osql_test_environment=>create(

    i_dependency_list = VALUE #( ( 'ZFIAP_EP_DATA2' )
                                ( 'ZFIAP_EP_DATA' )
                                ( 'zfiap_ep_data_at' )
                                ( 'lfa1' )
                                )
                                  ).
  ENDMETHOD.

  METHOD class_teardown.
*    cds_test_environment->destroy(  ).
    sql_test_environment->destroy(  ).
  ENDMETHOD.

  METHOD setup.
    CREATE OBJECT lo_cut FOR TESTING.
  ENDMETHOD.

  METHOD teardown.
    " clean up any involved entity
    ROLLBACK ENTITIES.
*    cds_test_environment->clear_doubles(  ).
    sql_test_environment->clear_doubles(  ).
  ENDMETHOD.

  METHOD clear_test_data.
    CLEAR:  lt_ep_data, lt_ep_base, lt_ep_at, lt_ep_lfa1,
            lt_late_reported, lt_late_failed,
            me->lt_act_upd_keys, lt_act_upd_result, ls_act_upd_param,
            me->lt_act_val_keys, lt_act_val_result, ls_act_val_param.
  ENDMETHOD.

  METHOD pop_upd_scn.
    " Populate Scenario test Key data
    me->lt_act_upd_keys = VALUE #( ( edi_trans_no = me->lt_ep_data[ iv_key ]-edi_trans_no
                                    %param = iv_act_upd_param ) ).

    " Call test method
    lo_cut->upd(   EXPORTING
                            keys = lt_act_upd_keys
                        CHANGING
                            reported = lt_late_reported
                            failed  = lt_late_failed
                            result = lt_act_upd_result ).
  ENDMETHOD.

  METHOD pop_val_scn.
    " Populate Scenario test Key data
    me->lt_act_val_keys = VALUE #( ( edi_trans_no = me->lt_ep_data[ iv_key ]-edi_trans_no
                                    %param = iv_act_val_param ) ).

    " Call test method
    lo_cut->validate(   EXPORTING
                            keys = lt_act_val_keys
                        CHANGING
                            reported = lt_late_reported
                            failed  = lt_late_failed
                            result = lt_act_val_result ).
  ENDMETHOD.

  METHOD pop_test_data.

    " Populate All Master data
    CASE iv_scenario.
      WHEN 'VAL001'.
        lt_ep_data = VALUE #( ( edi_trans_no = '1111111111'
        request_type = '' approval_status = '' payee_number = '' ) ).

        lt_ep_base = VALUE #( ( edi_trans_no = '1111111111'
        request_type = '' approval_status = '' payee_number = '' ) ).

        lt_ep_at = VALUE #( ( edi_trans_no = '1111111111' ) ).

      WHEN 'UPD001'.
        lt_ep_data = VALUE #( ( edi_trans_no = '1111111112'
                                request_type = '00' approval_status = 'P' payee_number = '1852423' ) ).

        lt_ep_base = VALUE #( ( edi_trans_no = '1111111112'
                                request_type = '00' approval_status = 'P' payee_number = '1852423' ) ).

        lt_ep_at = VALUE #( ( edi_trans_no = '1111111112' ) ).

        lt_ep_lfa1 = VALUE #( ( lifnr = '1234567890'  name1 = 'Test_Name1' name2 = 'Test_Name2') ).
    ENDCASE.


    sql_test_environment->insert_test_data( lt_ep_data ).
    sql_test_environment->insert_test_data( lt_ep_base ).
    sql_test_environment->insert_test_data( lt_ep_at ).
    sql_test_environment->insert_test_data( lt_ep_lfa1 ).
  ENDMETHOD.

  METHOD test_val_scn1.
    " Populate All Master data
    me->clear_test_data(  ).
    me->pop_test_data( iv_scenario = 'VAL001' ).

    "Test Validate - Scenario - 1
**********************************************************************
    " Populate Scenario test Parameter data
    ls_act_val_param-conf_val = ''.
    " Call Scenario Action
    me->pop_val_scn( iv_act_val_param = ls_act_val_param iv_key = 1 ).

    " Read Test Result
    READ ENTITIES OF zfiap_ep_data2
    ENTITY details
    ALL FIELDS WITH VALUE #( ( edi_trans_no = me->lt_act_val_keys[ 1 ]-edi_trans_no ) )
    RESULT DATA(lt_upd_scn_res).

    " Assert Test Result
    cl_abap_unit_assert=>assert_equals(
        EXPORTING
            act = ''
            exp = ''
            msg = 'Test: Update Positive test failed'
        ).

    me->clear_test_data(  ).
  ENDMETHOD.

  METHOD test_upd_scn1.

    " Populate All Master data
    me->clear_test_data(  ).
    me->pop_test_data( iv_scenario = 'UPD001' ).

    "Test Update - Scenario - 1
**********************************************************************
    " Populate Scenario test Parameter data
    ls_act_upd_param-request_type = '01'.
    ls_act_upd_param-approval_status = ''.
    ls_act_upd_param-payee_number = '1234567890'.
    " Call Scenario Action
    me->pop_upd_scn( iv_act_upd_param = ls_act_upd_param iv_key = 1 ).

    " Read Test Result
    READ ENTITIES OF zfiap_ep_data2
    ENTITY details
    ALL FIELDS WITH VALUE #( ( edi_trans_no = me->lt_act_upd_keys[ 1 ]-edi_trans_no ) )
    RESULT DATA(lt_upd_scn_res).

    " Assert Test Result
    cl_abap_unit_assert=>assert_equals(
        EXPORTING
            act = lt_upd_scn_res[ 1 ]-request_type
            exp = ls_act_upd_param-request_type
            msg = 'Test: Update Request Type test failed'
        ).
    cl_abap_unit_assert=>assert_equals(
        EXPORTING
            act = lt_upd_scn_res[ 1 ]-approval_status
            exp = 'S'
            msg = 'Test: Update Approval Status test failed'
        ).
    cl_abap_unit_assert=>assert_equals(
       EXPORTING
           act = lt_upd_scn_res[ 1 ]-payee_number
           exp = ls_act_upd_param-payee_number
           msg = 'Test: Update Payee Number test failed'
       ).

    me->clear_test_data(  ).
  ENDMETHOD.

ENDCLASS.
