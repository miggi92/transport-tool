"! <p class="shorttext synchronized" lang="en">Main ALV Class</p>
CLASS zcl_transport_tool_alv_main DEFINITION
  PUBLIC
  CREATE PUBLIC ABSTRACT .

  PUBLIC SECTION.
    METHODS:
      refresh.
  PROTECTED SECTION.
    DATA:
      mo_salv_table TYPE REF TO cl_salv_table,
      mt_data       TYPE REF TO data.

    METHODS:
      init_salv
        IMPORTING
          VALUE(iv_container_name) TYPE c
        RAISING
          cx_salv_msg.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_transport_tool_alv_main IMPLEMENTATION.
  METHOD refresh.
    mo_salv_table->refresh(
*  EXPORTING
*    s_stable     =                         " ALV Control: Refresh Stability
*    refresh_mode = if_salv_c_refresh=>soft " ALV: Data Element for Constants
    ).
  ENDMETHOD.

  METHOD init_salv.
    FIELD-SYMBOLS:
     <lt_data> TYPE ANY TABLE.

    ASSIGN me->mt_data->* TO <lt_data>.

    DATA(lo_container) = NEW cl_gui_custom_container(
      container_name          = iv_container_name
    ).

    cl_salv_table=>factory(
      EXPORTING
*          list_display   = if_salv_c_bool_sap=>false " ALV Displayed in List Mode
        r_container    = lo_container                          " Abstract Container for GUI Controls
*          container_name =
      IMPORTING
        r_salv_table   = me->mo_salv_table                          " Basis Class Simple ALV Tables
      CHANGING
        t_table        = <lt_data>
    ).

    me->mo_salv_table->get_columns( )->set_optimize( ).
  ENDMETHOD.

ENDCLASS.
