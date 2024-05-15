CLASS ltc_fap_isi_parse_util
DEFINITION FINAL FOR TESTING
DURATION SHORT
RISK LEVEL HARMLESS.
  PRIVATE SECTION.
*
    CLASS-DATA:
      mv_tdc_name   TYPE etobj_name VALUE 'TD_FAP_ISI_UT_PARSE_EXCEL',
      mv_param_name TYPE etp_name   VALUE 'XSTRING',
      f_cut         TYPE REF TO cl_fap_isi_parse_util.
*
    CLASS-METHODS:
      class_setup.

*
    METHODS:
      parse_correct_invoice     FOR TESTING,
      parse_wrong_header_layout FOR TESTING,
      parse_wrong_data_format   FOR TESTING,
      parse_wrong_data_value    FOR TESTING,
      get_xstring               IMPORTING iv_variant_name TYPE etvar_id
                                EXPORTING ev_xstring      TYPE xstring.

ENDCLASS.


CLASS ltc_fap_isi_parse_util IMPLEMENTATION.

  METHOD class_setup.
    CREATE OBJECT f_cut.
  ENDMETHOD.

  METHOD get_xstring.

    DATA: lv_message TYPE string.

    TRY.
        CALL METHOD cl_db_dependencies_tdc_api=>get_tdc_variant_param_value
          EXPORTING
            iv_tdc_name          = mv_tdc_name
            iv_variant_name      = iv_variant_name
            iv_param_name        = mv_param_name
          IMPORTING
            ev_tdc_var_par_value = ev_xstring.

      CATCH cx_tdc_failure.
        CONCATENATE 'TDC' mv_tdc_name 'Variant' iv_variant_name 'Parameter' mv_param_name 'is empty.' INTO lv_message SEPARATED BY space.
        MESSAGE lv_message TYPE 'I'.
    ENDTRY.

  ENDMETHOD.

  METHOD parse_correct_invoice.

    DATA: lv_xstring TYPE xstring,
          lt_entry   TYPE cl_fap_isi_parse_util=>ty_t_invoice_entry,
          ls_entry   TYPE cl_fap_isi_parse_util=>ty_s_invoice_entry.

    get_xstring(
      EXPORTING
        iv_variant_name     = '1_INVOICE_2_ITEMS'
      IMPORTING
        ev_xstring          = lv_xstring
    ).
    CHECK lv_xstring IS NOT INITIAL.

    TRY.

        f_cut->parse_xlsx(
          EXPORTING
            ix_file             = lv_xstring
          IMPORTING
            et_entry            = lt_entry
        ).

      CATCH cx_openxml_not_found.
        " Dummy
      CATCH cx_openxml_format.
        " Dummy
    ENDTRY.

    cl_abap_unit_assert=>assert_equals(
                      exp = 1
                      act = lines( lt_entry )
                     quit = if_aunit_constants=>class ).

    READ TABLE lt_entry INTO ls_entry INDEX 1.
    cl_abap_unit_assert=>assert_equals(
                      exp = 2
                      act = lines( ls_entry-items )
                     quit = if_aunit_constants=>class ).

  ENDMETHOD.

  METHOD parse_wrong_header_layout.

    DATA: lv_xstring TYPE xstring,
          lt_message TYPE bapirettab,
          lv_message TYPE string.

    get_xstring(
      EXPORTING
        iv_variant_name     = 'LAYOUT_ERROR'
      IMPORTING
        ev_xstring          = lv_xstring
    ).
    CHECK lv_xstring IS NOT INITIAL.

    TRY.

        f_cut->parse_xlsx(
           EXPORTING
             ix_file             = lv_xstring
           IMPORTING
             et_message          = lt_message
         ).

      CATCH cx_openxml_not_found.
        " Dummy
      CATCH cx_openxml_format.
        " Dummy
    ENDTRY.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '001' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e001(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '002' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e002(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '003' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e003(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '004' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e004(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '005' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e005(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '006' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e006(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '019' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e019(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

  ENDMETHOD.

  METHOD parse_wrong_data_format.

    DATA: lv_xstring TYPE xstring,
          lt_message TYPE bapirettab,
          lv_message TYPE string.


    get_xstring(
      EXPORTING
        iv_variant_name     = 'DATA_FORMAT_ERROR'
      IMPORTING
        ev_xstring          = lv_xstring
      ).
    CHECK lv_xstring IS NOT INITIAL.

    TRY.
        f_cut->parse_xlsx(
           EXPORTING
             ix_file             = lv_xstring
           IMPORTING
             et_message          = lt_message
         ).

      CATCH cx_openxml_not_found.
        " Dummy
      CATCH cx_openxml_format.
        " Dummy
    ENDTRY.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '007' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e007(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '008' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e008(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '009' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e009(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '011' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e011(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '012' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e012(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '013' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e013(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '014' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e014(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.



  ENDMETHOD.

  METHOD parse_wrong_data_value.

    DATA: lv_xstring TYPE xstring,
          lt_message TYPE bapirettab,
          lv_message TYPE string.

    get_xstring(
      EXPORTING
        iv_variant_name     = 'DATA_VALUE_ERROR'
      IMPORTING
        ev_xstring          = lv_xstring
      ).
    CHECK lv_xstring IS NOT INITIAL.

    TRY.

        f_cut->parse_xlsx(
           EXPORTING
             ix_file             = lv_xstring
           IMPORTING
             et_message          = lt_message
         ).

      CATCH cx_openxml_not_found.
        " Dummy
      CATCH cx_openxml_format.
        " Dummy
    ENDTRY.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '015' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e015(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '016' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e016(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '020' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e020(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.


    READ TABLE lt_message WITH KEY id     = 'FAP_ISI'
                                   number = '021' TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE e021(fap_isi) INTO lv_message.
      CONCATENATE 'Message Not Raised:' lv_message INTO lv_message.
      cl_abap_unit_assert=>fail(  msg = lv_message ).
    ENDIF.

  ENDMETHOD.


ENDCLASS.
