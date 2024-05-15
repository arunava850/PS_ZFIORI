class ZCL_Z_IMPORT_SUPPLIER__MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  types:
      ACTIONRESULT type MMIV_SI_S_ACTION_RESULT .
  types:
   begin of ts_text_element,
      artifact_name  type c length 40,       " technical name
      artifact_type  type c length 4,
      parent_artifact_name type c length 40, " technical name
      parent_artifact_type type c length 4,
      text_symbol    type textpoolky,
   end of ts_text_element .
  types:
         tt_text_elements type standard table of ts_text_element with key text_symbol .
  types:
    begin of ACTIONRESULTDUPLICATECHECK,
        DRAFTROOTKEY type SYSUUID_X,
        INVOICEUPLOADUUID type SYSUUID_X,
        ACTIONOK type FLAG,
    end of ACTIONRESULTDUPLICATECHECK .
  types:
    begin of ACTIONRESULTPOST,
        ACTION_OK type FLAG,
        COUNTER type /IWBEP/SB_ODATA_TY_INT2,
        TOTALNUMBER type /IWBEP/SB_ODATA_TY_INT2,
        BELNR type C length 10,
        GJAHR type C length 4,
        BLOCKED type FLAG,
    end of ACTIONRESULTPOST .
  types:
    begin of LOGHANDLE,
        LOGHANDLEID type string,
        LOGNUMBER type string,
    end of LOGHANDLE .
  types:
    begin of SAP__FITTOPAGE,
        ERRORRECOVERYBEHAVIOR type C length 8,
        ISENABLED type FLAG,
        MINIMUMFONTSIZE type I,
    end of SAP__FITTOPAGE .
  types:
    begin of TS_GETLOGHANDLE,
        INVOICEUPLOADUUID type SYSUUID_X,
    end of TS_GETLOGHANDLE .
  types:
    begin of TS_POST,
        KEY_UUID type string,
    end of TS_POST .
  types:
    begin of TS_CHECK,
        DRAFTROOTKEY type SYSUUID_X,
        INVOICEUPLOADUUID type SYSUUID_X,
    end of TS_CHECK .
  types:
    begin of TS_DELETE,
        DRAFTROOTKEY type SYSUUID_X,
        INVOICEUPLOADUUID type SYSUUID_X,
    end of TS_DELETE .
  types:
    begin of TS_DUPLICATECHECK,
        INVOICEUPLOADUUID type SYSUUID_X,
    end of TS_DUPLICATECHECK .
  types:
    begin of TS_PARKASCOMPLETED,
        DRAFTROOTKEY type SYSUUID_X,
        INVOICEUPLOADUUID type SYSUUID_X,
    end of TS_PARKASCOMPLETED .
  types:
    begin of TS_UPDATE,
        POSTINGDATE type C length 8,
        DOCUMENTDATE type C length 8,
        INVOICINGPARTY type C length 10,
        DRAFTROOTKEY type SYSUUID_X,
        INVOICEUPLOADUUID type SYSUUID_X,
        ITEMTEXT type C length 50,
        HEADERTEXT type C length 25,
        DOCUMENTTYPE type C length 2,
        PAYMENTTERM type C length 4,
    end of TS_UPDATE .
  types:
  begin of TS_FEATURETOGGLE,
     TOGGLEID type C length 40,
     TOGGLEACTIVE type FLAG,
  end of TS_FEATURETOGGLE .
  types:
TT_FEATURETOGGLE type standard table of TS_FEATURETOGGLE .
  types:
  begin of TS_FILECONTENTFORDOWNLOAD,
     SPRAS type C length 2,
     FILENAME type string,
     MIMETYPE type string,
     ISTEMPLATE type FLAG,
  end of TS_FILECONTENTFORDOWNLOAD .
  types:
TT_FILECONTENTFORDOWNLOAD type standard table of TS_FILECONTENTFORDOWNLOAD .
  types:
  begin of TS_FILECONTENTFORUPLOAD,
     FILENAME type C length 256,
     MIMETYPE type string,
     TMPID type C length 22,
     TMPIDTYPE type C length 1,
     HOLD_DOC_ID type C length 40,
     DRAFTID type C length 32,
     IS_INITIAL_UPLOAD type FLAG,
     NO_OF_DOC_TO_BE_UPLD type /IWBEP/SB_ODATA_TY_INT2,
     FILECONTENT type X length 256,
     NO_OF_DOC_UPLD type /IWBEP/SB_ODATA_TY_INT2,
  end of TS_FILECONTENTFORUPLOAD .
  types:
TT_FILECONTENTFORUPLOAD type standard table of TS_FILECONTENTFORUPLOAD .
  types:
  begin of TS_FINSPOSTINGAPHEADER,
     SUPPLIERINVOICETRANSACTIONTYPE type C length 1,
     COMPANYCODE type C length 4,
     DOCUMENTDATE type TIMESTAMPL,
     POSTINGDATE type TIMESTAMPL,
     SUPPLIERINVOICEIDBYINVCGPARTY type C length 16,
     INVOICINGPARTY type C length 10,
     INVOICEGROSSAMOUNT type P length 8 decimals 3,
     DOCUMENTCURRENCY type C length 5,
     PAYMENTBLOCKINGREASON type C length 1,
     DUECALCULATIONBASEDATE type TIMESTAMPL,
     MANUALCASHDISCOUNT type P length 8 decimals 3,
     PAYMENTMETHOD type C length 1,
     INVOICEREFERENCE type C length 10,
     INVOICEREFERENCEFISCALYEAR type C length 4,
     PAYMENTTERMS type C length 4,
     CASHDISCOUNT1DAYS type P length 4 decimals 3,
     CASHDISCOUNT1PERCENT type P length 3 decimals 3,
     CASHDISCOUNT2DAYS type P length 4 decimals 3,
     CASHDISCOUNT2PERCENT type P length 3 decimals 3,
     NETPAYMENTDAYS type P length 4 decimals 3,
     FIXEDCASHDISCOUNT type C length 1,
     UNPLANNEDDELIVERYCOST type P length 8 decimals 3,
     UNPLANNEDDELIVERYCOSTTAXCODE type C length 2,
     UNPLNDDELIVCOSTTAXJURISDICTION type C length 15,
     REFERENCEDOCUMENTCATEGORY type C length 1,
     ACCOUNTINGDOCUMENTTYPE type C length 2,
     ASSIGNMENTREFERENCE type C length 18,
     SUPPLIERPOSTINGLINEITEMTEXT type C length 50,
     ACCOUNTINGDOCUMENTHEADERTEXT type C length 25,
     SUPPLIERINVOICEORIGIN type C length 1,
     BUSINESSNETWORKORIGIN type C length 2,
     SUPPLIERINVOICEUPLOADFILEUUID type SYSUUID_X,
     URLFIELD type ZURLFIELD,
  end of TS_FINSPOSTINGAPHEADER .
  types:
TT_FINSPOSTINGAPHEADER type standard table of TS_FINSPOSTINGAPHEADER .
  types:
  begin of TS_FINSPOSTINGAPITEM,
     SUPPLIERINVOICEITEMAMOUNT type P length 8 decimals 3,
     DEBITCREDITCODE type C length 1,
     TAXCODE type C length 2,
     TAXJURISDICTION type C length 15,
     SUPPLIERINVOICEITEMTEXT type C length 50,
     ASSIGNMENTREFERENCE type C length 18,
     BUSINESSAREA type C length 4,
     BUSINESSPROCESS type C length 12,
     CONTROLLINGAREA type C length 4,
     COSTCENTER type C length 10,
     COSTCTRACTIVITYTYPE type C length 6,
     COSTOBJECT type C length 12,
     FUNCTIONALAREA type C length 16,
     GLACCOUNT type C length 10,
     ISNOTCASHDISCOUNTLIABLE type FLAG,
     INTERNALORDER type C length 12,
     PERSONNELNUMBER type C length 8,
     PROFITCENTER type C length 10,
     SALESORDER type C length 10,
     SALESORDERITEM type C length 6,
     WBSELEMENT type C length 24,
     PROJECTNETWORK type C length 12,
     NETWORKACTIVITY type C length 4,
     WORKITEM type C length 10,
     COMMITMENTITEM type C length 24,
     FUNDSMANAGEMENTCENTER type C length 16,
     TAXBASEAMOUNTINTRANSCRCY type P length 8 decimals 3,
     FUNDS type C length 10,
     GRANT type C length 20,
     QUANTITYUNIT type C length 3,
     QUANTITY type P length 7 decimals 3,
     PARTNERBUSINESSAREA type C length 4,
  end of TS_FINSPOSTINGAPITEM .
  types:
TT_FINSPOSTINGAPITEM type standard table of TS_FINSPOSTINGAPITEM .
  types:
     TS_INVOICELIST type FAP_ISI_S_CAPISINVOICE .
  types:
TT_INVOICELIST type standard table of TS_INVOICELIST .
  types:
  begin of TS_LANGUAGE,
     SPRAS type C length 2,
     SPTXT type C length 16,
  end of TS_LANGUAGE .
  types:
TT_LANGUAGE type standard table of TS_LANGUAGE .
  types:
  begin of TS_MASSCHANGE,
     POSTINGDATE type C length 8,
     DOCUMENTDATE type C length 8,
     INVOICINGPARTY type C length 10,
     DOCUMENTTYPE type C length 2,
     PAYMENTTERM type C length 4,
     HEADERTEXT type C length 25,
     ITEMTEXT type C length 50,
  end of TS_MASSCHANGE .
  types:
TT_MASSCHANGE type standard table of TS_MASSCHANGE .
  types:
  begin of TS_SAP__COVERPAGE,
     TITLE type string,
     ID type SYSUUID_X,
     NAME type string,
     VALUE type string,
  end of TS_SAP__COVERPAGE .
  types:
TT_SAP__COVERPAGE type standard table of TS_SAP__COVERPAGE .
  types:
  begin of TS_SAP__DOCUMENTDESCRIPTION,
     ID type SYSUUID_X,
     CREATED_BY type string,
     CREATED_AT type TIMESTAMP,
     FILENAME type string,
     TITLE type string,
  end of TS_SAP__DOCUMENTDESCRIPTION .
  types:
TT_SAP__DOCUMENTDESCRIPTION type standard table of TS_SAP__DOCUMENTDESCRIPTION .
  types:
  begin of TS_SAP__FORMAT,
     ID type SYSUUID_X,
     FONTSIZE type I,
     ORIENTATION type C length 10,
     PAPERSIZE type C length 10,
     BORDERSIZE type I,
     MARGINSIZE type I,
     FONTNAME type C length 255,
     FITTOPAGE type SAP__FITTOPAGE,
  end of TS_SAP__FORMAT .
  types:
TT_SAP__FORMAT type standard table of TS_SAP__FORMAT .
  types:
  begin of TS_SAP__PDFSTANDARD,
     ID type SYSUUID_X,
     USEPDFACONFORMANCEVC type C length 1,
     USEPDFACONFORMANCE type FLAG,
     DOENABLEACCESSIBILITYVC type C length 1,
     DOENABLEACCESSIBILITY type FLAG,
  end of TS_SAP__PDFSTANDARD .
  types:
TT_SAP__PDFSTANDARD type standard table of TS_SAP__PDFSTANDARD .
  types:
  begin of TS_SAP__SIGNATURE,
     ID type SYSUUID_X,
     DO_SIGN type FLAG,
     REASON type string,
  end of TS_SAP__SIGNATURE .
  types:
TT_SAP__SIGNATURE type standard table of TS_SAP__SIGNATURE .
  types:
  begin of TS_SAP__TABLECOLUMNS,
     ID type SYSUUID_X,
     NAME type string,
     HEADER type string,
     HORIZONTAL_ALIGNMENT type C length 10,
  end of TS_SAP__TABLECOLUMNS .
  types:
TT_SAP__TABLECOLUMNS type standard table of TS_SAP__TABLECOLUMNS .
  types:
  begin of TS_SAP__VALUEHELP,
     VALUEHELP type string,
     FIELD_VALUE type string,
     DESCRIPTION type string,
  end of TS_SAP__VALUEHELP .
  types:
TT_SAP__VALUEHELP type standard table of TS_SAP__VALUEHELP .
  types:
  begin of TS_VL_SH_FAP_T003,
     XKOAK type FLAG,
     BLART type C length 2,
     LTEXT type C length 20,
  end of TS_VL_SH_FAP_T003 .
  types:
TT_VL_SH_FAP_T003 type standard table of TS_VL_SH_FAP_T003 .
  types:
  begin of TS_VL_SH_ODATA_KREDI,
     BEGRU type C length 4,
     KTOKK type C length 4,
     LAND1 type C length 3,
     MCOD3 type C length 25,
     SORTL type C length 10,
     MCOD1 type C length 25,
     LIFNR type C length 10,
     BUKRS type C length 4,
  end of TS_VL_SH_ODATA_KREDI .
  types:
TT_VL_SH_ODATA_KREDI type standard table of TS_VL_SH_ODATA_KREDI .
  types:
  begin of TS_VL_SH_ODATA_ZTERM,
     LANGUAGE type C length 2,
     PAYMENTTERMS type C length 4,
     PAYMENTTERMSNAME type C length 30,
  end of TS_VL_SH_ODATA_ZTERM .
  types:
TT_VL_SH_ODATA_ZTERM type standard table of TS_VL_SH_ODATA_ZTERM .

  constants GC_VL_SH_ODATA_ZTERM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_ODATA_ZTERM' ##NO_TEXT.
  constants GC_VL_SH_ODATA_KREDI type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_ODATA_KREDI' ##NO_TEXT.
  constants GC_VL_SH_FAP_T003 type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VL_SH_FAP_T003' ##NO_TEXT.
  constants GC_SAP__VALUEHELP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__ValueHelp' ##NO_TEXT.
  constants GC_SAP__TABLECOLUMNS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__TableColumns' ##NO_TEXT.
  constants GC_SAP__SIGNATURE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__Signature' ##NO_TEXT.
  constants GC_SAP__PDFSTANDARD type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__PDFStandard' ##NO_TEXT.
  constants GC_SAP__FORMAT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__Format' ##NO_TEXT.
  constants GC_SAP__FITTOPAGE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__FitToPage' ##NO_TEXT.
  constants GC_SAP__DOCUMENTDESCRIPTION type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__DocumentDescription' ##NO_TEXT.
  constants GC_SAP__COVERPAGE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SAP__CoverPage' ##NO_TEXT.
  constants GC_MASSCHANGE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'MassChange' ##NO_TEXT.
  constants GC_LOGHANDLE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'LogHandle' ##NO_TEXT.
  constants GC_LANGUAGE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'Language' ##NO_TEXT.
  constants GC_INVOICELIST type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'InvoiceList' ##NO_TEXT.
  constants GC_FINSPOSTINGAPITEM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'FinsPostingAPItem' ##NO_TEXT.
  constants GC_FINSPOSTINGAPHEADER type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'FinsPostingAPHeader' ##NO_TEXT.
  constants GC_FILECONTENTFORUPLOAD type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'FileContentForUpload' ##NO_TEXT.
  constants GC_FILECONTENTFORDOWNLOAD type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'FileContentForDownload' ##NO_TEXT.
  constants GC_FEATURETOGGLE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'FeatureToggle' ##NO_TEXT.
  constants GC_ACTIONRESULTPOST type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResultPost' ##NO_TEXT.
  constants GC_ACTIONRESULTDUPLICATECHECK type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResultDuplicateCheck' ##NO_TEXT.
  constants GC_ACTIONRESULT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResult' ##NO_TEXT.

  methods GET_EXTENDED_MODEL
  final
    exporting
      !EV_EXTENDED_SERVICE type /IWBEP/MED_GRP_TECHNICAL_NAME
      !EV_EXT_SERVICE_VERSION type /IWBEP/MED_GRP_VERSION
      !EV_EXTENDED_MODEL type /IWBEP/MED_MDL_TECHNICAL_NAME
      !EV_EXT_MODEL_VERSION type /IWBEP/MED_MDL_VERSION
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods LOAD_TEXT_ELEMENTS
  final
    returning
      value(RT_TEXT_ELEMENTS) type TT_TEXT_ELEMENTS
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .

  methods DEFINE
    redefinition .
  methods GET_LAST_MODIFIED
    redefinition .
protected section.
private section.

  methods CREATE_NEW_ARTIFACTS
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
ENDCLASS.



CLASS ZCL_Z_IMPORT_SUPPLIER__MPC IMPLEMENTATION.


  method CREATE_NEW_ARTIFACTS.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*


DATA:
  lo_entity_type    TYPE REF TO /iwbep/if_mgw_odata_entity_typ,                      "#EC NEEDED
  lo_complex_type   TYPE REF TO /iwbep/if_mgw_odata_cmplx_type,                      "#EC NEEDED
  lo_property       TYPE REF TO /iwbep/if_mgw_odata_property,                        "#EC NEEDED
  lo_association    TYPE REF TO /iwbep/if_mgw_odata_assoc,                           "#EC NEEDED
  lo_assoc_set      TYPE REF TO /iwbep/if_mgw_odata_assoc_set,                       "#EC NEEDED
  lo_ref_constraint TYPE REF TO /iwbep/if_mgw_odata_ref_constr,                      "#EC NEEDED
  lo_nav_property   TYPE REF TO /iwbep/if_mgw_odata_nav_prop,                        "#EC NEEDED
  lo_action         TYPE REF TO /iwbep/if_mgw_odata_action,                          "#EC NEEDED
  lo_parameter      TYPE REF TO /iwbep/if_mgw_odata_property,                        "#EC NEEDED
  lo_entity_set     TYPE REF TO /iwbep/if_mgw_odata_entity_set.                      "#EC NEEDED


lo_entity_type = model->get_entity_type( iv_entity_name = 'FinsPostingAPHeader' ).    "#EC NOTEXT
lo_property = lo_entity_type->create_property( iv_property_name = 'urlfield' iv_abap_fieldname = 'URLFIELD' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 120 ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).

lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_entity_type->bind_structure( iv_structure_name = 'ZCL_Z_IMPORT_SUPPLIER__MPC=>TS_FINSPOSTINGAPHEADER' iv_bind_conversions = '' ). "#EC NOTEXT
  endmethod.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*


data:
  lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ, "#EC NEEDED
  lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type, "#EC NEEDED
  lo_property       type ref to /iwbep/if_mgw_odata_property, "#EC NEEDED
  lo_association    type ref to /iwbep/if_mgw_odata_assoc,  "#EC NEEDED
  lo_assoc_set      type ref to /iwbep/if_mgw_odata_assoc_set, "#EC NEEDED
  lo_ref_constraint type ref to /iwbep/if_mgw_odata_ref_constr, "#EC NEEDED
  lo_nav_property   type ref to /iwbep/if_mgw_odata_nav_prop, "#EC NEEDED
  lo_action         type ref to /iwbep/if_mgw_odata_action, "#EC NEEDED
  lo_parameter      type ref to /iwbep/if_mgw_odata_property, "#EC NEEDED
  lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set, "#EC NEEDED
  lo_complex_prop   type ref to /iwbep/if_mgw_odata_cmplx_prop. "#EC NEEDED

* Extend the model
model->extend_model( iv_model_name = 'FAP_IMPORT_SUPPLIER_INVOICES' iv_model_version = '0001' ). "#EC NOTEXT

model->set_schema_namespace( 'FAP_IMPORT_SUPPLIER_INVOICES' ).


*
* Disable all the entity types that were disabled from reference model
*
* Disable entity type 'SAP__Currency'
try.
lo_entity_type = model->get_entity_type( iv_entity_name = 'SAP__Currency' ). "#EC NOTEXT
lo_entity_type->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.

IF lo_entity_type IS BOUND.
* Disable all the properties for this entity type
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'CurrencyCode' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'ISOCode' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'Text' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'DecimalPlaces' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.


endif.

* Disable entity type 'SAP__UnitOfMeasure'
try.
lo_entity_type = model->get_entity_type( iv_entity_name = 'SAP__UnitOfMeasure' ). "#EC NOTEXT
lo_entity_type->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.

IF lo_entity_type IS BOUND.
* Disable all the properties for this entity type
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'UnitCode' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'ISOCode' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'ExternalCode' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'Text' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_property = lo_entity_type->get_property( iv_property_name = 'DecimalPlaces' ). "#EC NOTEXT
lo_property->set_disabled( iv_disabled = abap_true ).
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.


endif.


*
*Disable all the entity sets that were disabled from reference model
*
try.
lo_entity_set = model->get_entity_set( iv_entity_set_name = 'SAP__Currencies' ). "#EC NOTEXT
IF lo_entity_set IS BOUND.
lo_entity_set->set_disabled( iv_disabled = abap_true ).
ENDIF.
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
try.
lo_entity_set = model->get_entity_set( iv_entity_set_name = 'SAP__UnitsOfMeasure' ). "#EC NOTEXT
IF lo_entity_set IS BOUND.
lo_entity_set->set_disabled( iv_disabled = abap_true ).
ENDIF.
CATCH /iwbep/cx_mgw_med_exception.
*  No Action was taken as the OData Element is not a part of redefined service
ENDTRY.
* New artifacts have been created in the service builder after the redefinition of service
create_new_artifacts( ).
  endmethod.


  method GET_EXTENDED_MODEL.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*



ev_extended_service  = 'FAP_IMPORT_SUPPLIER_INVOICES'.                "#EC NOTEXT
ev_ext_service_version = '0001'.               "#EC NOTEXT
ev_extended_model    = 'FAP_IMPORT_SUPPLIER_INVOICES'.                    "#EC NOTEXT
ev_ext_model_version = '0001'.                   "#EC NOTEXT
  endmethod.


  method GET_LAST_MODIFIED.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  constants: lc_gen_date_time type timestamp value '20240403015603'. "#EC NOTEXT
rv_last_modified = super->get_last_modified( ).
IF rv_last_modified LT lc_gen_date_time.
  rv_last_modified = lc_gen_date_time.
ENDIF.
  endmethod.


  method LOAD_TEXT_ELEMENTS.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*


data:
  lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,           "#EC NEEDED
  lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,           "#EC NEEDED
  lo_property       type ref to /iwbep/if_mgw_odata_property,             "#EC NEEDED
  lo_association    type ref to /iwbep/if_mgw_odata_assoc,                "#EC NEEDED
  lo_assoc_set      type ref to /iwbep/if_mgw_odata_assoc_set,            "#EC NEEDED
  lo_ref_constraint type ref to /iwbep/if_mgw_odata_ref_constr,           "#EC NEEDED
  lo_nav_property   type ref to /iwbep/if_mgw_odata_nav_prop,             "#EC NEEDED
  lo_action         type ref to /iwbep/if_mgw_odata_action,               "#EC NEEDED
  lo_parameter      type ref to /iwbep/if_mgw_odata_property,             "#EC NEEDED
  lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.           "#EC NEEDED


DATA:
     ls_text_element TYPE ts_text_element.                   "#EC NEEDED
  endmethod.
ENDCLASS.
