"! <p class="shorttext synchronized" lang="en">Controller Class</p>
CLASS zcl_transport_tool_controller DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      transport_show_pbo.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
        mo_show_alv TYPE REF TO zcl_transport_tool_show_tr_alv.
ENDCLASS.



CLASS zcl_transport_tool_controller IMPLEMENTATION.
  METHOD transport_show_pbo.
    IF me->mo_show_alv IS NOT BOUND.
      me->mo_show_alv = NEW #( ).
    ENDIF.
    me->mo_show_alv->display( ).
  ENDMETHOD.

ENDCLASS.
