class ZCL_FAP_ISI_PARSE_UTIL definition
  public
  final
  create public .

public section.

  types: "zxy
    BEGIN OF ty_s_invoiceid_row_col_value,
        invoiceid  TYPE char100,
        row        TYPE i,
        col        TYPE char100,
        value      TYPE string,
  END OF ty_s_invoiceid_row_col_value .
  types:
    ty_t_invoiceid_row_col_value TYPE STANDARD TABLE OF ty_s_invoiceid_row_col_value .
  types: "zxy
    BEGIN OF ty_s_invoice_entry,
        index  TYPE string,
        header TYPE zmmiv_si_s_ext_header_c,
        items  TYPE mmiv_si_t_ext_gl_acc_item_c,
      END OF ty_s_invoice_entry .
  types: "zxy
    ty_t_invoice_entry TYPE STANDARD TABLE OF ty_s_invoice_entry .

  constants:
    BEGIN OF gc_file_type,
        excel TYPE string VALUE 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        csv   TYPE string VALUE 'application/vnd.ms-excel',
      END OF gc_file_type .

  methods PARSE_XLSX
    importing
      !IX_FILE type XSTRING
    exporting
      !ET_ENTRY type TY_T_INVOICE_ENTRY
      !ET_MESSAGE type BAPIRETTAB
    raising
      CX_OPENXML_NOT_FOUND
      CX_OPENXML_FORMAT .
protected section.
private section.

  types:
    BEGIN OF ts_col.
     TYPES col TYPE string.
  TYPES END OF ts_col . "zxy     "zxy
  types:
    tt_col TYPE STANDARD TABLE OF ts_col .
  types:
    BEGIN OF ooxml_worksheet.
  TYPES name        TYPE string.
  TYPES id          TYPE string.
  TYPES location    TYPE string.
  TYPES END OF ooxml_worksheet . "zxy
  types:
    ooxml_worksheets TYPE STANDARD TABLE OF ooxml_worksheet .
  types: "zxy
    BEGIN OF ty_s_field_mapping,
        col        TYPE string,
        field_name TYPE string,
        value      TYPE string,
  END OF ty_s_field_mapping .
  types:
    ty_t_field_mapping TYPE STANDARD TABLE OF ty_s_field_mapping .
  types:
    BEGIN OF field_name_mapping.
  TYPES cell_name TYPE string.
  TYPES cell_posi TYPE string.
  TYPES stru_name TYPE string.
  TYPES value TYPE string.
  TYPES END OF field_name_mapping . "zxy
  types:
    field_name_mappings TYPE HASHED TABLE OF field_name_mapping WITH UNIQUE KEY cell_name cell_posi .
  types:
    BEGIN OF t_struc_numfmtid.
  TYPES id          TYPE i.
  TYPES formatcode  TYPE string.
  TYPES END OF t_struc_numfmtid . "zxy
  types:
    t_numfmtids TYPE STANDARD TABLE OF t_struc_numfmtid .
  types: "zxy
    BEGIN OF ty_supported_sep,
      separator TYPE c LENGTH 1,
    END OF ty_supported_sep .
  types: "zxy
    BEGIN OF replacement_log,
      id    TYPE string,
      value TYPE string,
    END OF replacement_log .
  types:
    ty_replacement_log_tt TYPE TABLE OF replacement_log WITH KEY id .
  types: "zxy
    BEGIN OF ty_currency,
      fn_amount   TYPE string,
      fn_currency TYPE string,
    END OF ty_currency .
  types:
    ty_dd04l TYPE STANDARD TABLE OF dd04l .
  types:
    BEGIN OF TY_S_SEQUENCE_NO.
  TYPES sequence_no          TYPE string.
  TYPES line_number  TYPE string.
  TYPES END OF TY_S_SEQUENCE_NO . "zxy
  types:
    TY_T_SEQUENCE_NO TYPE STANDARD TABLE OF TY_S_SEQUENCE_NO .
  types:
    TY_T_FIELDINFO TYPE STANDARD TABLE OF DFIES WITH KEY FIELDNAME .

  constants GC_ISI_MESSAGE_CLASS type STRING value 'FAP_ISI' ##NO_TEXT.
  constants GC_FAC_MSG_CLASSNAME type STRING value 'FAC_FINS_POSTING_MAP' ##NO_TEXT.
*  constants CS_EMPTY_SYMBOL type STRING value '##empty##' ##NO_TEXT.
*  data:
*    mt_supported_separators  TYPE TABLE OF ty_supported_sep WITH KEY separator .
*  data MV_SEPARATOR type STRING .
*  constants:
*    "Separators
*    gc_sep_semicolon TYPE c LENGTH 1 value ';' ##NO_TEXT.
*  constants:
*    gc_sep_comma     TYPE c LENGTH 1 value ',' ##NO_TEXT.
*  constants:
*    gc_sep_pipe      TYPE c LENGTH 1 value '|' ##NO_TEXT.
*  constants:
*    gc_sep_dot       TYPE c LENGTH 1 value '.' ##NO_TEXT.
*  constants:
*    gc_sep_tab       TYPE c LENGTH 1 value CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB ##NO_TEXT.
*  constants GC_CSV_REPLACEMENT_PATTERN type STRING value '"([^"]+)"' ##NO_TEXT.
*  data MT_CSV_PROCESSING_ERRORS type BAPIRETTAB .
*  data:
*    gt_currency   TYPE STANDARD TABLE OF ty_currency WITH KEY fn_amount .
*  data GT_DATETYPE type STRING_TABLE .
*  constants CS_HEADER_SYMBOL type STRING value 'Header' ##NO_TEXT.
*  constants CS_LINEITEM_SYMBOL type STRING value 'Lineitems' ##NO_TEXT.
*  constants GC_ID_PNUM type C value 'P' ##NO_TEXT.
*  data MT_DD04L type TY_DD04L .
*  data MT_CURRENCY type /IWBEP/T_MGW_NAME_VALUE_PAIR .
*  data MT_EXCEL type FAC_T_INDEX_VALUE_PAIR .
*  constants GC_MAX_SEQUENCE_NO type I value 999 ##NO_TEXT.
*  data GT_FIELDINFO type DD_X031L_TABLE .
  constants GC_HEADER_STRUCTURE_NAME type STRING value 'MMIV_SI_S_EXT_HEADER_C' ##NO_TEXT. "zxy
  constants GC_ITEM_STRUCTURE_NAME type STRING value 'MMIV_SI_S_EXT_GL_ACC_ITEM_C' ##NO_TEXT.
  data GT_HEADER_COLUMN type TT_COL .
  data GT_LINEITEM_COLUMN type TT_COL .
  data MO_UTIL type ref to CL_FIN_EXCEL_PARSE_UTIL .
  data GT_FIELDINFO type DD_X031L_TABLE .
  constants GC_DATA_BEGIN_INDEX type I value 7 ##NO_TEXT.
  constants GC_ID_CHAR type C value 'C' ##NO_TEXT.

  methods IS_COL1_BEFORE_COL2
    importing
      !IV_COL1 type CHAR100
      !IV_COL2 type CHAR100
    returning
      value(EB_BEFORE) type ABAP_BOOL .
  methods CHECK_EXCEL_HEADER_LAYOUT
    importing
      !IT_TABLE type CL_FIN_EXCEL_PARSE_UTIL=>TY_T_INDEX_VALUE_PAIR
    exporting
      !ET_HEADER_COL type TT_COL
      !ET_LINEITEM_COL type TT_COL
      !ET_TECH_FIELD type TY_T_INVOICEID_ROW_COL_VALUE
      !ET_MESSAGE type BAPIRETTAB .
  methods CHECK_EXCEL_LAYOUT
    importing
      !IT_TABLE type CL_FIN_EXCEL_PARSE_UTIL=>TY_T_INDEX_VALUE_PAIR
    exporting
      !ET_HEADER type TY_T_INVOICEID_ROW_COL_VALUE
      !ET_LINEITEM type TY_T_INVOICEID_ROW_COL_VALUE
      !ET_TECH_FIELD type TY_T_INVOICEID_ROW_COL_VALUE
      !ET_MESSAGE type BAPIRETTAB .
  methods CHECK_FIELD_VALUE
    importing
      !IV_FIELD_NAME type STRING
      !IV_CURRENCY_KEY type WAERS optional
      !IV_ROW type I
      !IV_COL type CHAR100
    exporting
      !ET_MESSAGE type BAPIRETTAB
    changing
      !CV_EXCEL_VALUE type STRING
      !CV_STRUC_VALUE type ANY .
  methods CHECK_HEADER_DATA
    importing
      !IT_INVOICE_KEY type TY_T_INVOICEID_ROW_COL_VALUE
      !IT_HEADER type TY_T_INVOICEID_ROW_COL_VALUE
    exporting
      !ET_MESSAGE type BAPIRETTAB .
  methods CHECK_INVOICE_ID
    importing
      !IT_INVOICE_KEY type TY_T_INVOICEID_ROW_COL_VALUE
    exporting
      !ET_MESSAGE type BAPIRETTAB .
  methods DIVIDE_HEADER_LINEITEM_DATA
    importing
      !IT_TABLE type CL_FIN_EXCEL_PARSE_UTIL=>TY_T_INDEX_VALUE_PAIR
      !IT_HEADER_COL type TT_COL
      !IT_LINEITEM_COL type TT_COL
    exporting
      !ET_HEADER type TY_T_INVOICEID_ROW_COL_VALUE
      !ET_LINEITEM type TY_T_INVOICEID_ROW_COL_VALUE
      !ET_INVOICE_KEY type TY_T_INVOICEID_ROW_COL_VALUE
      !ET_MESSAGE type BAPIRETTAB .
  methods MAP_EXCEL_DATA
    importing
      !IT_HEADER type TY_T_INVOICEID_ROW_COL_VALUE
      !IT_LINEITEM type TY_T_INVOICEID_ROW_COL_VALUE
      !IT_TECH_FIELD type TY_T_INVOICEID_ROW_COL_VALUE
    exporting
      !ET_ENTRY type TY_T_INVOICE_ENTRY
      !ET_MESSAGE type BAPIRETTAB .
  methods SET_GT_FIELDINFO .
  methods CONVERT_TO_UPPERCASE
    importing
      !IV_ROLLNAME type ROLLNAME
    changing
      !CV_VALUE type ANY .
ENDCLASS.



CLASS ZCL_FAP_ISI_PARSE_UTIL IMPLEMENTATION.


  METHOD CHECK_EXCEL_HEADER_LAYOUT.

    CONSTANTS: lc_header        TYPE i VALUE 1,
               lc_lineitem      TYPE i VALUE 2.

    DATA: ls_header             TYPE mmiv_si_s_ext_header_c,
          ls_lineitem           TYPE mmiv_si_s_ext_gl_acc_item_c,
          ls_tech_field         TYPE ty_s_invoiceid_row_col_value,
          ls_col                TYPE ts_col,
          ls_message            TYPE LINE OF bapirettab,
          lv_header_start_col   TYPE char100,
          lv_lineitem_start_col TYPE char100,
          lv_phase              TYPE i.  "1 Header "2 Lineitem

    FIELD-SYMBOLS: <fs_line>      TYPE fac_s_index_value_pair,
                   <ft_line>      TYPE fac_t_index_value_pair,
                   <fs_cell>      TYPE fac_s_index_value_pair,
                   <fs_value>     TYPE string,
                   <fv_tech_name> TYPE any.

    " Check the Section Name Line ( Row 4 in excel)
    " Shoule be only two section Header and G/L Account Items
    READ TABLE it_table ASSIGNING <fs_line> WITH TABLE KEY index = '4'.
    IF <fs_line> IS NOT ASSIGNED.
      " Line 4 is empty
       IF 1 = 2. MESSAGE e025(fap_isi). ENDIF.
            APPEND VALUE bapiret2(
              type       = 'E'
              id         = gc_isi_message_class
              number     = '025'
              message_v1 = '4' )
            TO et_message.
       RETURN.
    ENDIF.
    ASSIGN <fs_line>-value->* TO <ft_line>.
    LOOP AT <ft_line> ASSIGNING <fs_cell>.
      ASSIGN <fs_cell>-value->* TO <fs_value>.
      CASE <fs_value>.

        WHEN cl_fap_isi_template_util=>gc_header.

          IF lv_header_start_col IS INITIAL.
            lv_header_start_col    = <fs_cell>-index.
          ELSE.
            " Duplicate Header Section.
            IF 1 = 2. MESSAGE e019(fap_isi). ENDIF.
            APPEND VALUE bapiret2(
              type       = 'E'
              id         = gc_isi_message_class
              number     = '019')
            TO et_message.
          ENDIF.

        WHEN cl_fap_isi_template_util=>gc_item.

          IF lv_lineitem_start_col IS INITIAL.
            lv_lineitem_start_col    = <fs_cell>-index.
          ELSE.
            " Duplicate G/L Account Items Section.
            IF 1 = 2. MESSAGE e019(fap_isi). ENDIF.
            APPEND VALUE bapiret2(
              type       = 'E'
              id         = gc_isi_message_class
              number     = '019')
            TO et_message.
          ENDIF.

          IF lv_header_start_col IS INITIAL
            OR is_col1_before_col2(
                  iv_col1 = lv_lineitem_start_col
                  iv_col2 = lv_header_start_col ) = abap_true.
            " Error: Lineitem before Header
            IF 1 = 2. MESSAGE e001(fap_isi). ENDIF.
            APPEND VALUE bapiret2(
              type       = 'E'
              id         = gc_isi_message_class
              number     = '001')
            TO et_message.
          ENDIF.

        WHEN OTHERS.
          " Error: No other section except Header and GL Account Items allowed
          IF 1 = 2. MESSAGE e002(fap_isi). ENDIF.
          APPEND VALUE bapiret2(
            type       = 'E'
            id         = gc_isi_message_class
            number     = '002'
            message_v1 = <fs_value> )
          TO et_message.
      ENDCASE.
    ENDLOOP.
    IF lv_header_start_col IS INITIAL OR lv_lineitem_start_col IS INITIAL.
      "Error : Header Lineitem not found!
      IF 1 = 2. MESSAGE e003(fap_isi). ENDIF.
      APPEND VALUE bapiret2(
        type       = 'E'
        id         = gc_isi_message_class
        number     = '003' )
      TO et_message.
    ENDIF.

    " Check the technical name line ( Row 5)
    " The technical name should belong to one section and exists in the Header or G/L Account Item structure.
    READ TABLE it_table ASSIGNING <fs_line> WITH TABLE KEY index = '5'.
    IF <fs_line> IS NOT ASSIGNED.
      " Line 5 is empty
       IF 1 = 2. MESSAGE e025(fap_isi). ENDIF.
            APPEND VALUE bapiret2(
              type       = 'E'
              id         = gc_isi_message_class
              number     = '025'
              message_v1 = '5')
            TO et_message.
       RETURN.
    ENDIF.

    ASSIGN <fs_line>-value->* TO <ft_line>.

    LOOP AT <ft_line> ASSIGNING <fs_cell>.
      ASSIGN <fs_cell>-value->* TO <fs_value>.

      IF <fs_cell>-index = lv_header_start_col
        "Postion: Cell Column same as the Header Col
         OR (     is_col1_before_col2( iv_col1 = lv_header_start_col iv_col2 = <fs_cell>-index ) = abap_true
              AND is_col1_before_col2( iv_col1 = <fs_cell>-index     iv_col2 = lv_lineitem_start_col ) = abap_true
              AND lv_header_start_col IS NOT INITIAL ) .
        "Position: Cell Column between Header Col and Lineitem Col
          lv_phase = lc_header.
      ENDIF.

      IF <fs_cell>-index = lv_lineitem_start_col
        "Postion: Cell Column same as the Lineitem Col
         OR is_col1_before_col2( iv_col1 = lv_lineitem_start_col iv_col2 = <fs_cell>-index ) = abap_true .
        "Position: Cell Column after Lineitem Col
          lv_phase = lc_lineitem.
      ENDIF.

      ls_col-col = <fs_cell>-index.
      CASE lv_phase.
        WHEN lc_header. "Header
          ASSIGN COMPONENT <fs_value> OF STRUCTURE ls_header TO <fv_tech_name>.
          IF sy-subrc <> 0.
            " Error: Field not exist in the header structure
            IF 1 = 2. MESSAGE e004(fap_isi). ENDIF.
            APPEND VALUE bapiret2(
             type       = 'E'
             id         = gc_isi_message_class
             number     = '004'
             message_v1 = '5'
             message_v2 = <fs_cell>-index
             message_v3 = cl_fap_isi_template_util=>gc_header )
            TO et_message.
          ELSE.
            APPEND ls_col TO et_header_col.
          ENDIF.

        WHEN lc_lineitem. "Lineitem
          ASSIGN COMPONENT <fs_value> OF STRUCTURE ls_lineitem TO <fv_tech_name>.
          IF sy-subrc <> 0.
            " Error: Field not exist in the lineitem structure
            IF 1 = 2. MESSAGE e004(fap_isi). ENDIF.
            APPEND VALUE bapiret2(
              type       = 'E'
              id         = gc_isi_message_class
              number     = '004'
              message_v1 = '5'
              message_v2 = <fs_cell>-index
              message_v3 = cl_fap_isi_template_util=>gc_item )
            TO et_message.
          ELSE.
            APPEND ls_col TO et_lineitem_col.
          ENDIF.

        WHEN OTHERS.
          "Error : Fields not belong to any section
          IF 1 = 2. MESSAGE e005(fap_isi). ENDIF.
          APPEND VALUE bapiret2(
            type       = 'E'
            id         = gc_isi_message_class
            number     = '005'
            message_v1 = '5'
            message_v2 = <fs_cell>-index  )
          TO et_message.
      ENDCASE.

      ls_tech_field-col   = <fs_cell>-index.
      ls_tech_field-value = <fs_value>.
      APPEND ls_tech_field TO et_tech_field.

      CLEAR: lv_phase.

    ENDLOOP.

    " Check the field name line ( Row 6 )
    " The field name should have a corresponding technical name in row 5
    READ TABLE it_table ASSIGNING <fs_line> WITH TABLE KEY index = '6'.
    IF <fs_line> IS NOT ASSIGNED.
      " Line 6 is empty
       IF 1 = 2. MESSAGE e025(fap_isi). ENDIF.
            APPEND VALUE bapiret2(
              type       = 'E'
              id         = gc_isi_message_class
              number     = '025'
              message_v1 = '6' )
            TO et_message.
       RETURN.
    ENDIF.
    ASSIGN <fs_line>-value->* TO <ft_line>.
    LOOP AT <ft_line> ASSIGNING <fs_cell> WHERE index <> 'A'.
      ASSIGN <fs_cell>-value->* TO <fs_value>.
      IF <fs_value> IS NOT INITIAL.
        READ TABLE et_tech_field WITH KEY col = <fs_cell>-index TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          " Error : Field Description without technical name
          IF 1 = 2. MESSAGE e006(fap_isi). ENDIF.
          APPEND VALUE bapiret2(
            type       = 'E'
            id         = gc_isi_message_class
            number     = '006'
            message_v1 = '6'
            message_v2 = <fs_cell>-index  )
          TO et_message.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD CHECK_EXCEL_LAYOUT.

    DATA: lt_table_data   TYPE cl_fin_excel_parse_util=>ty_t_index_value_pair,
          lt_header       TYPE ty_t_invoiceid_row_col_value,
          lt_lineitem     TYPE ty_t_invoiceid_row_col_value,
          lt_invoice_key  TYPE ty_t_invoiceid_row_col_value,
          lt_header_col   TYPE tt_col,
          lt_lineitem_col TYPE tt_col.



    IF it_table IS INITIAL.
      " Check file not empty
      IF 1 = 2. MESSAGE e000(fap_isi). ENDIF.
      APPEND VALUE bapiret2(
        type       = 'E'
        id         = gc_isi_message_class
        number     = '000')
      TO et_message.
      RETURN.

    ELSE.
      lt_table_data = it_table.
      DELETE lt_table_data WHERE index < gc_data_begin_index.
      IF lines( lt_table_data ) > 10000.
        " Check file within 2000 rows data
        IF 1 = 2. MESSAGE e022(fap_isi). ENDIF.
        APPEND VALUE bapiret2(
          type       = 'E'
          id         = gc_isi_message_class
          number     = '022')
        TO et_message.
        RETURN.
      ENDIF.
    ENDIF.


    me->check_excel_header_layout(
      EXPORTING
        it_table        = it_table
      IMPORTING
        et_tech_field   = et_tech_field
        et_header_col   = lt_header_col
        et_lineitem_col = lt_lineitem_col
        et_message      = et_message
    ).
    CHECK et_message IS INITIAL.

    me->divide_header_lineitem_data(
      EXPORTING
        it_table        = it_table
        it_header_col   = lt_header_col
        it_lineitem_col = lt_lineitem_col
      IMPORTING
        et_header       = lt_header
        et_lineitem     = lt_lineitem
        et_invoice_key  = lt_invoice_key
        et_message      = et_message
    ).


    me->check_invoice_id(
      EXPORTING
        it_invoice_key = lt_invoice_key
      IMPORTING
        et_message     = et_message
    ).

    me->check_header_data(
      EXPORTING
        it_invoice_key = lt_invoice_key
        it_header      = lt_header
      IMPORTING
        et_message     = et_message
    ).

    SORT lt_header BY invoiceid col value row ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_header COMPARING invoiceid col value.

    et_header[]     = lt_header[].
    et_lineitem[]   = lt_lineitem[].

  ENDMETHOD.


  METHOD CHECK_FIELD_VALUE.

    DATA: lr_type_desc          TYPE REF TO cl_abap_typedescr,
          lt_ddic_obj           TYPE dd_x031l_table,
          ls_fieldinfo          LIKE LINE OF gt_fieldinfo,
          lv_type_check_retcode TYPE i,
          lv_conversion_ret_code TYPE i,
          lv_exid               TYPE x031l-exid,
          lv_datatype           TYPE dynptype.


    IF iv_currency_key IS NOT INITIAL.
      " Ref to the code in the change_currency_idoc_to_sap...of GL ...
      READ TABLE gt_fieldinfo WITH KEY fieldname = iv_field_name INTO ls_fieldinfo.
      IF ls_fieldinfo IS NOT INITIAL.
        lv_datatype = ls_fieldinfo-dtyp.
      ELSE.
        lr_type_desc = cl_abap_typedescr=>describe_by_name( iv_field_name ).
        lt_ddic_obj = lr_type_desc->get_ddic_object( ).
        IF lt_ddic_obj IS NOT INITIAL.
          lv_datatype = lt_ddic_obj[ 1 ]-dtyp.
        ENDIF.
      ENDIF.

      "First do the conversion for currency amount
      "considering the KRW... Currency with decimal digits not equal to 2
      TRY.
          mo_util->change_currency_idoc_to_sap(
         EXPORTING
           iv_field_name                  =  iv_field_name
           iv_currency_name               =  iv_currency_key   " Currency Key
           iv_dtyp                        =  lv_datatype   " Data Type in ABAP Dictionary
         CHANGING
           cv_data                        =  cv_excel_value
       ).
        CATCH cx_root INTO DATA(lo_exception).
          CLEAR cv_excel_value.
      ENDTRY.

      IF cv_excel_value IS INITIAL.
        IF 1 = 2. MESSAGE e021(FAP_ISI). ENDIF.
        APPEND VALUE bapiret2(
           type       = 'E'
           id         = gc_isi_message_class
           number     = '021'
           message_v1 = iv_row
           message_v2 = iv_col )
        TO et_message.
        RETURN.
      ENDIF.
    ENDIF.

    mo_util->format_decimal_in_excel_style(
      EXPORTING
        iv_data            = cv_excel_value
        is_field           = cv_struc_value
      RECEIVING
        rv_formatted_value = cv_excel_value
    ).

    READ TABLE gt_fieldinfo WITH KEY fieldname = iv_field_name INTO ls_fieldinfo.
    IF ls_fieldinfo IS NOT INITIAL.
      lv_exid = ls_fieldinfo-exid.
    ELSE.
      DESCRIBE FIELD cv_struc_value TYPE lv_exid.
    ENDIF.

    mo_util->validate_field_type(
      EXPORTING
        is_field       =  cv_struc_value
        iv_field_value =  cv_excel_value
        iv_field_name  =  iv_field_name
        iv_exid        =  lv_exid    " ABAP data type (C,D,N,...)
      RECEIVING
        ev_ret_code    = lv_type_check_retcode
    ).

    IF lv_type_check_retcode = 3. " Date format error
      IF 1 = 2. MESSAGE e020(FAP_ISI). ENDIF.
      APPEND VALUE bapiret2(
        type       = 'E'
        id         = gc_isi_message_class
        number     = '020'
        message_v1 = iv_row
        message_v2 = iv_col
      ) TO et_message.
    ELSEIF lv_type_check_retcode <> 0.
      IF 1 = 2. MESSAGE e021(FAP_ISI). ENDIF.
      APPEND VALUE bapiret2(
        type       = 'E'
        id         = gc_isi_message_class
        number     = '021'
        message_v1 = iv_row
        message_v2 = iv_col
       ) TO et_message.
      RETURN.
    ENDIF.

    mo_util->format_value_by_type(
      EXPORTING
        iv_value           = cv_excel_value
        iv_typename        = iv_field_name
      CHANGING
        cv_formatted_value = cv_struc_value
    ).


    mo_util->additional_conversion(
      IMPORTING
        ev_ret_code = lv_conversion_ret_code
      CHANGING
        cv_value    = cv_struc_value
    ).
    IF lv_conversion_ret_code IS NOT INITIAL.
      IF 1 = 2. MESSAGE e021(FAP_ISI). ENDIF.
      APPEND VALUE bapiret2(
        type       = 'E'
        id         = gc_isi_message_class
        number     = '021'
        message_v1 = iv_row
        message_v2 = iv_col
       ) TO et_message.
    ENDIF.

    IF lv_exid = gc_id_char.
      "For CHAR, Uppercase covernsion check
       me->convert_to_uppercase(
        EXPORTING
          iv_rollname = ls_fieldinfo-rollname
        CHANGING
          cv_value = cv_struc_value
          ).
    ENDIF.

  ENDMETHOD.


  METHOD CHECK_HEADER_DATA.

    TYPES: BEGIN OF ty_s_invoiceid_itemno,
             invoiceid TYPE char100,
             itemno    TYPE i,
           END OF ty_s_invoiceid_itemno.
    TYPES ty_t_invoiceid_itemno TYPE STANDARD TABLE OF ty_s_invoiceid_itemno.

    TYPES: BEGIN OF ty_s_invoiceid_col_row_value,
             invoiceid TYPE char100,
             col       TYPE char100,
             value     TYPE string,
             row       TYPE char100,
           END OF ty_s_invoiceid_col_row_value.
    TYPES ty_t_invoiceid_col_row_value TYPE STANDARD TABLE OF ty_s_invoiceid_col_row_value.

    DATA: lt_invoice_key      TYPE ty_t_invoiceid_row_col_value,
          lt_header           TYPE ty_t_invoiceid_row_col_value,
          lt_header_col_first TYPE ty_t_invoiceid_col_row_value,
          lt_invoice_count    TYPE ty_t_invoiceid_itemno,
          ls_invoice_count    TYPE ty_s_invoiceid_itemno,
          lv_count            TYPE i,
          lv_value_prev       TYPE string.

    FIELD-SYMBOLS: <fs_invoice_key>      TYPE ty_s_invoiceid_row_col_value,
                   <fs_header>           TYPE ty_s_invoiceid_row_col_value,
                   <fs_header_col_first> TYPE ty_s_invoiceid_col_row_value.

    lt_invoice_key[] = it_invoice_key[].
    lt_header[]      = it_header[].
    "Check Header Data is not initial
    LOOP AT lt_invoice_key ASSIGNING <fs_invoice_key>.
      READ TABLE lt_header WITH KEY invoiceid = <fs_invoice_key>-invoiceid
                                    row       = <fs_invoice_key>-row TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        " ERROR : Header should not be initial
          IF 1 = 2. MESSAGE e013(FAP_ISI). ENDIF.
          APPEND VALUE bapiret2(
            type       = 'E'
            id         = gc_isi_message_class
            number     = '013'
            message_v1 = <fs_invoice_key>-row )
         TO et_message.
      ENDIF.
    ENDLOOP.

    " Get each invoice has ? items
    lv_count = 0.
    LOOP AT lt_invoice_key ASSIGNING <fs_invoice_key>.
      ls_invoice_count-itemno = ls_invoice_count-itemno + 1.
      AT END OF invoiceid.
        ls_invoice_count-invoiceid = <fs_invoice_key>-invoiceid.
        APPEND ls_invoice_count TO lt_invoice_count.
        CLEAR: ls_invoice_count.
      ENDAT.
    ENDLOOP.

    "Check Header Data Consistency
    MOVE-CORRESPONDING lt_header TO lt_header_col_first.
    SORT lt_header_col_first BY invoiceid col ASCENDING.
    LOOP AT lt_header_col_first ASSIGNING <fs_header_col_first>.

    lv_count = lv_count + 1.
    AT NEW col.
      lv_value_prev = <fs_header_col_first>-value.
    ENDAT.

    IF <fs_header_col_first>-value <> lv_value_prev.
      " Error: Header Data Not Same for invoiceid &1
        IF 1 = 2. MESSAGE e014(FAP_ISI). ENDIF.
        APPEND VALUE bapiret2(
          type       = 'E'
          id         = gc_isi_message_class
          number     = '014'
          message_v1 = <fs_header_col_first>-invoiceid
           )
       TO et_message.
    ENDIF.

    AT END OF col.
      READ TABLE lt_invoice_count INTO ls_invoice_count WITH KEY invoiceid = <fs_header_col_first>-invoiceid.
      IF lv_count <> ls_invoice_count-itemno.
        " Error: Header Data Not Same for invoiceid &1
        IF 1 = 2. MESSAGE e014(FAP_ISI). ENDIF.
        APPEND VALUE bapiret2(
          type       = 'E'
          id         = gc_isi_message_class
          number     = '014'
          message_v1 = <fs_header_col_first>-invoiceid
          )
       TO et_message.
      ENDIF.
      CLEAR: lv_count, lv_value_prev, ls_invoice_count.
    ENDAT.

  ENDLOOP.

ENDMETHOD.


  METHOD CHECK_INVOICE_ID.
    "Get invoice key
    DATA: lt_invoice_key          TYPE ty_t_invoiceid_row_col_value,
          ls_invoice_key_prev     TYPE ty_s_invoiceid_row_col_value,
          lf_invoiceid_not_number TYPE abap_bool,
          lv_invoiceid            TYPE n LENGTH 100,
          lv_invoiceid_prev       TYPE n LENGTH 100,
          lv_row_no               TYPE i,
          lv_row_no_prev          TYPE i.

    FIELD-SYMBOLS: <fs_invoice_key> TYPE ty_s_invoiceid_row_col_value.

    lt_invoice_key[] = it_invoice_key[].

    "Check invoice number sequence
    SORT lt_invoice_key BY row invoiceid ASCENDING.
    LOOP AT lt_invoice_key ASSIGNING <fs_invoice_key>.

      CLEAR: lf_invoiceid_not_number.

      IF <fs_invoice_key>-invoiceid IS INITIAL.
        " Error: Invoice Id is empty
        IF 1 = 2. MESSAGE e007(fap_isi). ENDIF.
        APPEND VALUE bapiret2(
          type       = 'E'
          id         = gc_isi_message_class
          number     = '007'
          message_v1 = <fs_invoice_key>-row )
        TO et_message.
      ELSE.
        IF <fs_invoice_key>-invoiceid CN '0123456789 '.
          " Error: Invoice Id should be digit
          IF 1 = 2. MESSAGE e008(fap_isi). ENDIF.
          APPEND VALUE bapiret2(
              type       = 'E'
              id         = gc_isi_message_class
              number     = '008'
              message_v1 = <fs_invoice_key>-row )
          TO et_message.
          lf_invoiceid_not_number = abap_true.
        ENDIF.
      ENDIF.

      AT FIRST.
        ls_invoice_key_prev = <fs_invoice_key>.
        CONTINUE.
      ENDAT.

      lv_row_no          = <fs_invoice_key>-row.
      lv_row_no_prev     = ls_invoice_key_prev-row.

      IF lv_row_no <> lv_row_no_prev + 1.
        "Error : With Empty Row.
        IF 1 = 2. MESSAGE e011(fap_isi). ENDIF.
        APPEND VALUE bapiret2(
          type       = 'E'
          id         = gc_isi_message_class
          number     = '011' )
       TO et_message.
      ENDIF.

      IF lf_invoiceid_not_number IS INITIAL.
        " Only compare the invoice id sequence if invoice id is number...
        lv_invoiceid       = <fs_invoice_key>-invoiceid.
        lv_invoiceid_prev  = ls_invoice_key_prev-invoiceid.

        IF lv_invoiceid_prev > lv_invoiceid.
          " Error : Sequence Error
          IF 1 = 2. MESSAGE e012(fap_isi). ENDIF.
          APPEND VALUE bapiret2(
            type       = 'E'
            id         = gc_isi_message_class
            number     = '012' )
         TO et_message.
        ENDIF.

        ls_invoice_key_prev = <fs_invoice_key>.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD CONVERT_TO_UPPERCASE.

    DATA: ls_dd04l_wa TYPE dd04l.

    CALL FUNCTION 'DD_DTEL_GET'
      EXPORTING
        roll_name     = iv_rollname
      IMPORTING
        dd04l_wa_a    = ls_dd04l_wa
      EXCEPTIONS
        illegal_value = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      "Do Nothing
    ELSE.
      IF ls_dd04l_wa-lowercase = abap_false.
        TRANSLATE cv_value TO UPPER CASE.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD DIVIDE_HEADER_LINEITEM_DATA.

    DATA: ls_header          TYPE ty_s_invoiceid_row_col_value,
          ls_lineitem        TYPE ty_s_invoiceid_row_col_value,
          ls_invoice_key     TYPE ty_s_invoiceid_row_col_value,

          lf_not_in_header   TYPE abap_bool VALUE abap_false,
          lf_not_in_lineitem TYPE abap_bool VALUE abap_false,

          ls_invoice_id      TYPE fac_s_index_value_pair,
          lv_invoice_id      TYPE string.


    FIELD-SYMBOLS: <fs_line>  TYPE fac_s_index_value_pair,
                   <ft_line>  TYPE fac_t_index_value_pair,
                   <fs_cell>  TYPE fac_s_index_value_pair,
                   <fs_value> TYPE string.

    LOOP AT it_table ASSIGNING <fs_line> WHERE index >= gc_data_begin_index.

      UNASSIGN <ft_line>.
      ASSIGN <fs_line>-value->* TO <ft_line>.
      IF <ft_line> IS INITIAL.  " ***Possible?***
        CONTINUE.
      ENDIF.

      CLEAR: ls_invoice_id.
      READ TABLE <ft_line> INTO ls_invoice_id WITH TABLE KEY index = 'A'.

      IF ls_invoice_id IS INITIAL.
        CLEAR: lv_invoice_id.
      ELSE.
        UNASSIGN <fs_value>.
        ASSIGN ls_invoice_id-value->* TO <fs_value>.
        lv_invoice_id = <fs_value>.
      ENDIF.

      " Header
      ls_header-invoiceid        = lv_invoice_id.
      ls_header-row              = <fs_line>-index.
      " Lineitem
      ls_lineitem-invoiceid      = lv_invoice_id.
      ls_lineitem-row            = <fs_line>-index.
      " Invoice Key
      ls_invoice_key-invoiceid   = lv_invoice_id.
      ls_invoice_key-row         = <fs_line>-index.
      APPEND ls_invoice_key TO et_invoice_key.


      LOOP AT <ft_line> ASSIGNING <fs_cell>.

        READ TABLE it_header_col WITH TABLE KEY col = <fs_cell>-index TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          ASSIGN <fs_cell>-value->* TO <fs_value>.
          ls_header-col   = <fs_cell>-index.
          ls_header-value = <fs_value>.
          APPEND ls_header TO et_header.
        ELSE.
          lf_not_in_header  = abap_true.
        ENDIF.

        READ TABLE it_lineitem_col WITH TABLE KEY col = <fs_cell>-index TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          ASSIGN <fs_cell>-value->* TO <fs_value>.
          ls_lineitem-col   = <fs_cell>-index.
          ls_lineitem-value = <fs_value>.
          APPEND ls_lineitem TO et_lineitem.
        ELSE.
          lf_not_in_lineitem = abap_true.
        ENDIF.

        IF lf_not_in_header   = abap_true AND
           lf_not_in_lineitem = abap_true AND
           <fs_cell>-index    <> 'A'.   " Exclude the invoice id column.
          " Error : Value not in any field...
          IF 1 = 2. MESSAGE e009(fap_isi). ENDIF.
          APPEND VALUE bapiret2(
            type       = 'E'
            id         = gc_isi_message_class
            number     = '009'
            message_v1 = <fs_line>-index
            message_v2 = <fs_cell>-index )
          TO et_message.
        ENDIF.

        CLEAR: lf_not_in_header, lf_not_in_lineitem.

      ENDLOOP.

      CLEAR: ls_header, ls_lineitem, ls_invoice_key.

    ENDLOOP.

  ENDMETHOD.


  METHOD IS_COL1_BEFORE_COL2.

    " Col B is before Col AA

    IF strlen( iv_col1 ) = strlen( iv_col2 ).
      IF iv_col1 < iv_col2.
        eb_before = abap_true.
      ELSE.
        eb_before = abap_false.
      ENDIF.
    ELSEIF strlen( iv_col1 ) < strlen( iv_col2 ).
      eb_before = abap_true.
    ELSE.
      eb_before = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD MAP_EXCEL_DATA.

    DATA: lt_header        TYPE ty_t_invoiceid_row_col_value,
          lt_lineitem      TYPE ty_t_invoiceid_row_col_value,
          ls_header        TYPE ty_s_invoiceid_row_col_value,
          ls_header_copy   TYPE ty_s_invoiceid_row_col_value,
          ls_lineitem      TYPE ty_s_invoiceid_row_col_value,
          ls_lineitem_temp TYPE ty_s_invoiceid_row_col_value,
          ls_entry         TYPE ty_s_invoice_entry,
          lt_entry         TYPE ty_t_invoice_entry,
          ls_currency      TYPE ty_s_invoiceid_row_col_value,
          lv_row_no        TYPE char100,
          lv_fieldname     TYPE string.

    FIELD-SYMBOLS: <fs_tech_field>  TYPE ty_s_invoiceid_row_col_value,
                   <fs_entry>       TYPE ty_s_invoice_entry,
                   <fs_currency>    TYPE ty_s_invoiceid_row_col_value,
                   <fs_lineitem>    TYPE mmiv_si_s_ext_gl_acc_item_c,

                   <fv_excel_value> TYPE string,
                   <fv_struc_value> TYPE any.

    me->set_gt_fieldinfo( ).
    lt_header[]    = it_header[].
    lt_lineitem[]  = it_lineitem[].

    " Handle Header
    SORT lt_header BY invoiceid row.
    LOOP AT lt_header INTO ls_header.

      ls_header_copy = ls_header.
      AT NEW invoiceid.
        CLEAR: ls_entry.
        ls_entry-index = ls_header-invoiceid.

        " Assign the currency key first
        READ TABLE it_tech_field ASSIGNING <fs_tech_field> WITH KEY value = 'DOCUMENTCURRENCY'.
        IF <fs_tech_field> IS ASSIGNED.
          READ TABLE it_header INTO ls_currency WITH KEY row = ls_header_copy-row
                                                         col = <fs_tech_field>-col.
          IF ls_currency IS NOT INITIAL.
            ls_entry-header-documentcurrency = ls_currency-value.
          ENDIF.

        me->check_field_value(
        EXPORTING
          iv_field_name   = <fs_tech_field>-value
          iv_row          = ls_currency-row
          iv_col          = ls_currency-col
        IMPORTING
          et_message      = et_message
        CHANGING
          cv_excel_value  = ls_currency-value
          cv_struc_value  = ls_entry-header-documentcurrency
         ).
        ENDIF.

      ENDAT.

      ASSIGN ls_header-value TO <fv_excel_value>.
      READ TABLE it_tech_field ASSIGNING <fs_tech_field> WITH KEY col = ls_header-col.
      ASSIGN COMPONENT <fs_tech_field>-value OF STRUCTURE ls_entry-header TO <fv_struc_value>.

      CASE <fs_tech_field>-value.

        WHEN 'SUPPLIERINVOICETRANSACTIONTYPE'.
          IF <fv_excel_value> <> '1' AND
             <fv_excel_value> <> '2'.
            " Trascation field not in range
            IF 1 = 2. MESSAGE e015(FAP_ISI). ENDIF.
            APPEND VALUE bapiret2(
              type       = 'E'
              id         = gc_isi_message_class
              number     = '015'
              message_v1 = ls_header-row
              message_v2 = ls_header-col )
            TO et_message.
          ENDIF.

      ENDCASE.

      me->check_field_value(
        EXPORTING
          iv_field_name   = <fs_tech_field>-value
          iv_currency_key = ls_entry-header-documentcurrency
          iv_row          = ls_header-row
          iv_col          = ls_header-col
        IMPORTING
          et_message      = et_message
        CHANGING
          cv_excel_value  = <fv_excel_value>
          cv_struc_value  = <fv_struc_value>
      ).


      AT END OF invoiceid.
        APPEND ls_entry TO lt_entry.
      ENDAT.

    ENDLOOP.

    "Handle Lineitem
    SORT lt_lineitem BY invoiceid row.
    LOOP AT lt_lineitem INTO ls_lineitem.

*      ls_lineitem_temp = ls_lineitem. "AT NEW will turn the row value into ******
      AT NEW invoiceid.
        READ TABLE lt_entry ASSIGNING <fs_entry> WITH KEY index = ls_lineitem-invoiceid.
*        lv_row_no = ls_lineitem_temp-row.
      ENDAT.

*      IF ls_lineitem-row = lv_row_no.
*         CONTINUE. "skip the first item of the invoice
*      ENDIF.

      AT NEW row.
        APPEND INITIAL LINE TO <fs_entry>-items ASSIGNING <fs_lineitem>.
      ENDAT.

      ASSIGN ls_lineitem-value TO <fv_excel_value>.
      READ TABLE it_tech_field ASSIGNING <fs_tech_field> WITH KEY col = ls_lineitem-col.
      ASSIGN COMPONENT <fs_tech_field>-value OF STRUCTURE <fs_lineitem> TO <fv_struc_value>.

      CASE <fs_tech_field>-value.

        WHEN 'DEBITCREDITCODE'.
          IF <fv_excel_value> <> 'S' AND
             <fv_excel_value> <> 'H'.
            " Debit/Credit Indicator not in range
            IF 1 = 2. MESSAGE e016(FAP_ISI). ENDIF.
            APPEND VALUE bapiret2(
              type       = 'E'
              id         = gc_isi_message_class
              number     = '016'
              message_v1 = ls_lineitem-row
              message_v2 = ls_lineitem-col )
            TO et_message.
          ENDIF.

      ENDCASE.

      me->check_field_value(
        EXPORTING
          iv_field_name   = <fs_tech_field>-value
          iv_currency_key = <fs_entry>-header-documentcurrency
          iv_row          = ls_lineitem-row
          iv_col          = ls_lineitem-col
        IMPORTING
          et_message      = et_message
        CHANGING
          cv_excel_value  = <fv_excel_value>
          cv_struc_value  = <fv_struc_value>
      ).

    ENDLOOP.

    et_entry[] = lt_entry[].

  ENDMETHOD.


  METHOD PARSE_XLSX.

    IF ix_file IS INITIAL.
      RAISE EXCEPTION TYPE cx_openxml_format
        EXPORTING
          textid = cx_openxml_format=>cx_openxml_empty.
    ENDIF.

    IF mo_util IS NOT BOUND.
      CREATE OBJECT mo_util.
    ENDIF.

    mo_util->transform_xstring_2_tab(
      EXPORTING
        ix_file                        = ix_file
      IMPORTING
        et_table                       = DATA(lt_data)
    ).

*Check by the app specific logic
    me->check_excel_layout(
       EXPORTING
         it_table                       = lt_data
       IMPORTING
         et_tech_field                  = DATA(lt_tech_field)
         et_header                      = DATA(lt_header)
         et_lineitem                    = DATA(lt_lineitem)
         et_message                     = et_message
     ).
    CHECK et_message IS INITIAL.

    me->map_excel_data(
      EXPORTING
        it_header                      =  lt_header
        it_lineitem                    =  lt_lineitem
        it_tech_field                  =  lt_tech_field
      IMPORTING
        et_entry                       =  et_entry
        et_message                     =  et_message
    ).

  ENDMETHOD.


  method SET_GT_FIELDINFO.

    DATA:
      lt_fieldinfo LIKE gt_fieldinfo,
      lr_type_desc TYPE REF TO cl_abap_typedescr.


    lr_type_desc = cl_abap_structdescr=>describe_by_name( gc_header_structure_name ).
    lt_fieldinfo = lr_type_desc->get_ddic_object( ).
    APPEND LINES OF lt_fieldinfo TO gt_fieldinfo.
    CLEAR lt_fieldinfo.
    lr_type_desc = cl_abap_structdescr=>describe_by_name( gc_item_structure_name ).
    lt_fieldinfo = lr_type_desc->get_ddic_object( ).
    APPEND LINES OF lt_fieldinfo TO gt_fieldinfo.

  endmethod.
ENDCLASS.
