class ZCL_ZFI_CDS_EP_VIEW_SA_MPC_EXT definition
  public
  inheriting from ZCL_ZFI_CDS_EP_VIEW_SA_MPC
  create public .

public section.

  methods DEFINE
    redefinition .
protected section.
private section.

  methods ADD_ACTION
    importing
      !IV_ACTION_NAME type /IWBEP/MED_EXTERNAL_NAME .
ENDCLASS.



CLASS ZCL_ZFI_CDS_EP_VIEW_SA_MPC_EXT IMPLEMENTATION.


  method ADD_ACTION.

    data: lv_fc_fieldvalue type /iwbep/med_annotation_value,
          lo_complex_type  type ref to /iwbep/if_mgw_odata_cmplx_type,
          lo_prop          type ref to /iwbep/if_mgw_odata_property.

    data(lo_action) = model->create_action( iv_action_name ).

    "set return parameter
    lo_action->set_return_entity_type( 'ZFI_CDS_EP_VIEW_SADLType' ) .
    lo_action->set_return_entity_set( 'ZFI_CDS_EP_VIEW_SADL' ).

    lo_action->set_http_method( 'PUT' ).
    lo_action->set_return_multiplicity( /iwbep/if_mgw_med_odata_types=>gcs_cardinality-cardinality_1_1 ).
    "specify input parameters
    data(lo_parameter) = lo_action->create_input_parameter(
                                  iv_parameter_name = 'Escheat_rule'
*                                  iv_parameter_name = 'Airline'
                                  iv_abap_fieldname = 'ESCHEAT_RULE' ).
    lo_parameter->/iwbep/if_mgw_odata_property~set_type_edm_string( ).
    lo_parameter->set_maxlength( iv_max_length = 3 ).

    data(lo_parameter1) = lo_action->create_input_parameter(
                                  iv_parameter_name = 'State'
                                  iv_abap_fieldname = 'STATE' ).
    lo_parameter1->/iwbep/if_mgw_odata_property~set_type_edm_string( ).
    lo_parameter1->set_maxlength( iv_max_length = 4 ).

    "Is Action Active?
    concatenate 'IsActive' iv_action_name into data(lv_action_ac).

    data(lo_annotation) = lo_action->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
    lo_annotation->add( iv_key = 'action-for' iv_value = 'ZFI_CDS_EP_VIEW_SADLType' ).
    lo_annotation = lo_action->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
    lo_annotation->add( iv_key = 'applicable-path' iv_value = lv_action_ac ).


  endmethod.


  method DEFINE.
    super->define( ) .
    add_action( iv_action_name = 'Create' ) .
*    add_action( iv_action_name = 'KeepFlight' ) .

  endmethod.
ENDCLASS.
