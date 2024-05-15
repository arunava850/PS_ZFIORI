CLASS zcl_z_import_supplier__dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_z_import_supplier__dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~create_stream
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF gc_file_type,
        excel TYPE string VALUE 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        csv   TYPE string VALUE 'application/vnd.ms-excel',
      END OF gc_file_type .
    DATA mv_service_document_name TYPE string .
ENDCLASS.



CLASS ZCL_Z_IMPORT_SUPPLIER__DPC_EXT IMPLEMENTATION.


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



    DATA: lo_xlsx_parser           TYPE REF TO zcl_fap_isi_parse_util,
          lo_message_container     TYPE REF TO /iwbep/if_message_container,
          lt_message               TYPE bapirettab,
          lt_execl_parsing_message TYPE bapirettab,
          lt_create_draft_message  TYPE bapirettab,
          lv_failed_entry_no       TYPE i.

    DATA: lv_select     TYPE char1 VALUE abap_false,
          lv_count      TYPE i,
          lv_rec_cnt    TYPE i,
          lv_supinv_cnt TYPE i.

    TYPES: "zxy
      BEGIN OF ty_s_invoice_entry,
        index  TYPE string,
        header TYPE mmiv_si_s_ext_header_c,
        items  TYPE mmiv_si_t_ext_gl_acc_item_c,
      END OF ty_s_invoice_entry .
    TYPES: "zxy
      ty_t_invoice_entry TYPE STANDARD TABLE OF ty_s_invoice_entry .



    FIELD-SYMBOLS: <ls_file_content_for_upload> TYPE cl_fap_import_sup_inv_mpc=>ts_filecontentforupload.


    TYPES:
      BEGIN OF lty_s_attachment_content.
        INCLUDE TYPE: odata_cv_attach.
    TYPES  attachment_content TYPE xstring.
    TYPES  attachment_url     TYPE saeuri.
    TYPES  attachment_status  TYPE attachmentstatus.
    TYPES  phio_class         TYPE sdok_class.
    TYPES  loio_class         TYPE sdok_class.
    TYPES END OF lty_s_attachment_content .

    DATA:lo_bo               TYPE REF TO cl_odata_cv_gos_bo,
         ls_obj_map          TYPE odata_cv_obj_map,
         lt_message1         TYPE bapiret2_t,
         ls_original_content TYPE lty_s_attachment_content,
         ls_odata_cv_attach  TYPE odata_cv_attach,
         lv_err_subrc        TYPE sy-subrc,
         lv_no_commit        TYPE boole_d  VALUE ' ',
         lt_entry1           TYPE ty_t_invoice_entry,
         ls_entry1           TYPE ty_s_invoice_entry.


    IF    iv_entity_name           = 'FileContentForUpload'.
      "  AND mv_service_document_name = 'FAP_IMPORT_SUPPLIER_INVOICES'.

      CREATE OBJECT lo_xlsx_parser.
      CASE is_media_resource-mime_type.

        WHEN gc_file_type-excel.

          TRY.
              CALL METHOD lo_xlsx_parser->parse_xlsx
                EXPORTING
                  ix_file    = is_media_resource-value
                IMPORTING
                  et_entry   = DATA(lt_entry)
                  et_message = lt_execl_parsing_message.

            CATCH cx_openxml_not_found cx_openxml_format INTO DATA(lo_execl_parsing_exception).
              APPEND VALUE bapiret2(
                type   = 'E'
                id     = 'FAC_FINS_POSTING_MAP'
                number = '102'
              ) TO lt_execl_parsing_message.
          ENDTRY.
          APPEND LINES OF lt_execl_parsing_message TO lt_message.


        WHEN gc_file_type-csv.

          " TBD for CSV file

        WHEN OTHERS.
      ENDCASE.

      IF lt_message IS INITIAL.

        LOOP AT lt_entry INTO DATA(ls_entry_temp).
          CLEAR ls_entry1.
          MOVE-CORRESPONDING ls_entry_temp TO ls_entry1.
          APPEND ls_entry1 TO lt_entry1.
          CLEAR: ls_entry1,ls_entry_temp.
        ENDLOOP..
        "Only when the file is correctly parsed , do the draft creation...
        CALL METHOD cl_fap_isi_mmiv_ext_agent=>create_draft_invoices
          EXPORTING
            it_mmiv_entry_in   = lt_entry1
          IMPORTING
            et_message         = lt_message
            ev_failed_entry_no = lv_failed_entry_no.
      ENDIF.

      IF lt_message IS NOT INITIAL.
        "   merge_messages(
        "     CHANGING
        "        ct_messages =  lt_message
        "       ).
        lo_message_container = mo_context->get_message_container( ).
        lo_message_container->add_messages_from_bapi(
          EXPORTING
            it_bapi_messages = lt_message ).

        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = mo_context->get_message_container( ).
        RETURN.
      ENDIF.

      IF lt_entry IS NOT INITIAL.
        lv_select = abap_false.
        lv_rec_cnt = lines( lt_entry ).
        WHILE lv_select IS INITIAL.
          CLEAR: lv_supinv_cnt.
          wait up to 2 seconds.
          SELECT *  FROM c_importsupplierinvoice
          INTO TABLE @DATA(lt_supinv)
          FOR ALL ENTRIES IN @lt_entry
          WHERE supplierinvoiceidbyinvcgparty = @lt_entry-header-supplierinvoiceidbyinvcgparty
            AND invoicingparty = @lt_entry-header-invoicingparty
            AND supplierinvoiceuploadstatus = ''
            AND createdbyuser = @sy-uname.

          lv_count = lv_count + 1.
          lv_supinv_cnt = lines( lt_supinv ).
          IF lv_supinv_cnt = lv_rec_cnt.
            lv_select = abap_true.
          ENDIF.
          IF lv_count > 5.
            lv_select = abap_true.
          ENDIF.
          IF lv_select = abap_false.
            CLEAR lt_supinv.
          ENDIF.

        ENDWHILE.

      ENDIF.



      ls_obj_map-gos_objtype = 'BUS2081'.

      CALL METHOD cl_odata_cv_gos_bo=>get_instance
        EXPORTING
          is_mapping = ls_obj_map
        RECEIVING
          ro_bo      = lo_bo.

      LOOP AT lt_entry INTO DATA(ls_entry).

        READ TABLE lt_supinv INTO DATA(ls_supinv) WITH KEY
        companycode = ls_entry-header-companycode
        documentdate   = ls_entry-header-documentdate
        postingdate   = ls_entry-header-postingdate
        supplierinvoiceidbyinvcgparty = ls_entry-header-supplierinvoiceidbyinvcgparty
        invoicingparty = ls_entry-header-invoicingparty
        invoicegrossamount   = ls_entry-header-invoicegrossamount
        documentheadertext   = ls_entry-header-accountingdocumentheadertext .
        IF sy-subrc IS INITIAL.
          ls_original_content-objecttype = 'BUS2081'.
          ls_original_content-objectkey = ls_supinv-rootdraftkey.
          ls_original_content-filename = 'UploadURL'.
          ls_original_content-mimetype = 'text/url'.
          ls_original_content-objecttype_long = 'BUS2081'.
          ls_original_content-attachment_url = ls_entry-header-jrnlentrycntryspecificref1.

          CALL METHOD lo_bo->create_url_as_attachment
            IMPORTING
              et_messages         = lt_message1
            CHANGING
              cs_original_content = ls_original_content.

          IF lt_message1 IS INITIAL.
            MOVE-CORRESPONDING ls_original_content TO ls_odata_cv_attach.         "##ENH_OK
            ls_odata_cv_attach-mimetype = ls_original_content-mimetype.
            ls_odata_cv_attach-createdby_fullname = ls_original_content-createdby_fullname.
            ls_odata_cv_attach-url =  ls_original_content-attachment_url.
            ls_odata_cv_attach-length =  strlen( ls_odata_cv_attach-url ).
            ls_odata_cv_attach-new_attachment_ind = abap_true.

            cl_odata_attach_db_access=>insert(
              EXPORTING
                is_attach    = ls_odata_cv_attach
              IMPORTING
                ev_err_subrc = lv_err_subrc ).

            IF lv_err_subrc EQ 0.
              IF lv_no_commit EQ abap_false.
                cl_odata_attach_db_access=>commit( ) .
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
        CLEAR: ls_supinv, ls_odata_cv_attach.
      ENDLOOP.



      CREATE DATA er_entity TYPE cl_fap_import_sup_inv_mpc=>ts_filecontentforupload.
      ASSIGN er_entity->* TO <ls_file_content_for_upload>.

      <ls_file_content_for_upload>-no_of_doc_upld       = lines( lt_entry ) - lv_failed_entry_no.
      <ls_file_content_for_upload>-no_of_doc_to_be_upld = lv_failed_entry_no.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
