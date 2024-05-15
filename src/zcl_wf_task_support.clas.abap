class ZCL_WF_TASK_SUPPORT definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_WF_TASK_SUPPORT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_WF_TASK_SUPPORT IMPLEMENTATION.


  METHOD if_wf_task_support~get_multiple_task_support.

    LOOP AT ch_tasks_supports ASSIGNING FIELD-SYMBOL(<fs_task_supports>).

      <fs_task_supports>-forward = abap_false.

    ENDLOOP.
  ENDMETHOD.


  method IF_WF_TASK_SUPPORT~GET_TASK_SUPPORT.
  endmethod.
ENDCLASS.
