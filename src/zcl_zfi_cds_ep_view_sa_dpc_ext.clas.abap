class ZCL_ZFI_CDS_EP_VIEW_SA_DPC_EXT definition
  public
  inheriting from ZCL_ZFI_CDS_EP_VIEW_SA_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_BEGIN
    redefinition .
  methods /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_PROCESS
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZFI_CDS_EP_VIEW_SA_DPC_EXT IMPLEMENTATION.


  method /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_BEGIN.

  cv_defer_mode = abap_true .

  endmethod.


  METHOD /iwbep/if_mgw_core_srv_runtime~changeset_process.

    DATA : lo_func_import_context TYPE REF TO /iwbep/if_mgw_req_func_import,
           lt_parameters          TYPE /iwbep/t_mgw_name_value_pair,
           ls_ep_data             TYPE ZFI_CDS_EP_VIEW_SADL,
           ls_result              TYPE ZCL_ZFI_CDS_EP_VIEW_SA_MPC_EXT=>TS_ZFI_CDS_EP_VIEW_SADLTYPE,
           ls_changeset_response  TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response.

    "read requests where operation is execute action (EA)
    LOOP AT CT_CHANGESET_DATA ASSIGNING FIELD-SYMBOL(<lfs_changeset_request>)
            WHERE operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action.

      "find function name
      lo_func_import_context ?= <lfs_changeset_request>-request_context .
      DATA(lv_function_import_name) = lo_func_import_context->get_function_import_name( ) .

      IF lv_function_import_name = 'Create'." or lv_function_import_name = 'KeepFlight' .

        "read parameters
        lt_parameters = lo_func_import_context->get_parameters( ).
        ls_ep_data-ESCHEAT_RULE = lt_parameters[ name = 'ESCHEAT_RULE' ]-value .
        ls_ep_data-STATE = lt_parameters[ name = 'STATE' ]-value .

        "set/reset values
        CASE lv_function_import_name.
          WHEN 'Create'.

        ENDCASE .


        "select new values
        "do you know - even if you haven't yet committed the changes,
        "system will return new data
        "search 'transaction isolation levels' to read more on this

        "prepare response with operation number and respective data,
        "insert in CT_CHANGESET_RESPONSE
        ls_changeset_response-operation_no = <lfs_changeset_request>-operation_no .
        copy_data_to_ref(
           EXPORTING
             is_data = ls_result
           CHANGING
             cr_data = <lfs_changeset_request>-entity_data ).

        "INSERT ls_changeset_response INTO TABLE CT_CHANGESET_DATA.
      ENDIF .
    ENDLOOP .


  ENDMETHOD.
ENDCLASS.
