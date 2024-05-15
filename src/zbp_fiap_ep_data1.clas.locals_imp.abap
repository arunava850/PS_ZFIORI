CLASS lhc_ZFIAP_EP_DATA1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR details RESULT result.

    METHODS get_instance_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR details RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE details.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE details.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE details.

    METHODS read FOR READ
      IMPORTING keys FOR READ details RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK details.

    METHODS validate FOR MODIFY
      IMPORTING keys FOR ACTION details~validate RESULT result.

    METHODS post FOR MODIFY
      IMPORTING keys FOR ACTION details~post RESULT result.

    METHODS attach FOR MODIFY
      IMPORTING keys FOR ACTION details~attach RESULT result.

ENDCLASS.

CLASS lhc_ZFIAP_EP_DATA1 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD Attach.
  ENDMETHOD.

  METHOD validate.
  ENDMETHOD.

  METHOD post.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZFIAP_EP_DATA1 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS adjust_numbers REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZFIAP_EP_DATA1 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD adjust_numbers.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
