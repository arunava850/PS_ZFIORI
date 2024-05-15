FUNCTION zfiap_ep_data_app.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      ACTOR_TAB STRUCTURE  SWHACTOR
*"      AC_CONTAINER STRUCTURE  SWCONT
*"  EXCEPTIONS
*"      NOBODY_FOUND
*"----------------------------------------------------------------------
  REFRESH actor_tab[].
*Get parameters from container
  " DATA : l_object  TYPE swc_object,
  "       l_objkey  TYPE swotobjid-objkey,
  "      l_objtype TYPE swotobjid-objtype.

  DATA ls_actor      TYPE swhactor.
  DATA ls_object_key TYPE uct9_s_bo_key.
  DATA lo_service    TYPE REF TO cl_uc_mdoc_bo_services.
  DATA ld_step       TYPE uc_seqnr.


  LOOP AT ac_container INTO DATA(ls_ac_container).
    IF ls_ac_container-element = 'OBJECT_ID'.
      DATA(lv_key) = ls_ac_container-value.
    ENDIF.
  ENDLOOP.

  SELECT  *
  FROM zfiap_ep_appr
  INTO TABLE @DATA(lt_approver)
  WHERE zactive = @abap_true.

*  swc_get_element ac_container 'UCDOC' l_object.
  "swc_get_object_key l_object l_objkey.
  "ls_object_key = l_objkey.

  LOOP AT lt_approver INTO DATA(ls_agent).
    ls_actor-otype = 'US'.
    ls_actor-objid = ls_agent-zuser.
    APPEND ls_actor TO actor_tab.
  ENDLOOP.

  IF lines( actor_tab ) <= 0.
    RAISE nobody_found.
  ENDIF.

ENDFUNCTION.
