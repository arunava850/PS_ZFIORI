CLASS lhc_details DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR details RESULT result.
    METHODS track_upd FOR MODIFY
      IMPORTING keys FOR ACTION details~track_upd RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR details RESULT result.

ENDCLASS.

CLASS lhc_details IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD track_upd.


    READ ENTITIES OF zfiap_ep_d_tr_pro IN LOCAL MODE
      ENTITY details
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_ep_data)
      FAILED failed.


    LOOP AT lt_ep_data ASSIGNING FIELD-SYMBOL(<ls_ep_data>).
      <ls_ep_data>-tracker_sent_date = sy-datum.
      <ls_ep_data>-approval_status = 'T'.
    ENDLOOP.
    " write back the modified total_price of travels
    MODIFY ENTITIES OF zfiap_ep_d_tr_pro IN LOCAL MODE
      ENTITY details
        UPDATE FIELDS ( approval_status tracker_sent_date )
        WITH CORRESPONDING #( lt_ep_data ).

  ENDMETHOD.

  METHOD get_instance_features.

      READ ENTITIES OF zfiap_ep_d_tr_pro IN LOCAL MODE
       ENTITY details
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(entities).

    result = VALUE #( FOR entity IN entities
                    ( %tky                   = entity-%tky
                      %is_draft              = if_abap_behv=>fc-o-disabled
                      %update                = COND #( WHEN entity-edi_trans_no IS INITIAL
                                                      THEN if_abap_behv=>fc-o-disabled
                                                      ELSE if_abap_behv=>fc-o-enabled )

                                                         ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zfiap_ep_d_tr_pro DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zfiap_ep_d_tr_pro IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_ep_change      TYPE STANDARD TABLE OF zfiap_ep_pers,
          lr_edi_trans_no   TYPE RANGE OF zfiap_ep_data-edi_trans_no,
          lt_ep_controlflag TYPE STANDARD TABLE OF zfiap_x_ep_pers,
          ls_ep_controlflag LIKE LINE OF lt_ep_controlflag.
    IF update IS NOT INITIAL.
      lt_ep_change = CORRESPONDING #( update-details ).

      "Fill range value for all the updated Inspections
      lr_edi_trans_no = VALUE #( FOR ls_edi_trans_no IN update-details
                                     (  sign = 'I' option = 'EQ' low = ls_edi_trans_no-edi_trans_no )
                                   ).
      IF lr_edi_trans_no IS NOT INITIAL.
        "Get Old DB Values
        SELECT *
            FROM zfiap_ep_data
            INTO TABLE @DATA(lt_zfiap_ep_data)
            WHERE edi_trans_no IN @lr_edi_trans_no.
        IF sy-subrc IS INITIAL.
          LOOP AT lt_zfiap_ep_data ASSIGNING FIELD-SYMBOL(<lfs_data>).
            <lfs_data>-tracker_sent_date = sy-datum.
            <lfs_data>-approval_status = 'T'.
            <lfs_data>-changed_by = sy-uname.
            <lfs_data>-changed_date = sy-datum.
            <lfs_data>-changed_time = sy-uzeit.
          ENDLOOP.
          MODIFY zfiap_ep_data FROM TABLE lt_zfiap_ep_data.

          APPEND VALUE #(
                          %msg                = new_message(  id       = 'ZEP_DT'
                                                              number   = '000' " Document cannot be extended into the past
                                                              severity = if_abap_behv_message=>severity-success
                                                              v1 = 'Tracker Sent Data Updated')
*                            %element-ValidTo = if_abap_behv=>mk-on
                          ) TO reported-details.
        ENDIF.
      ENDIF.

    ENDIF.


  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
