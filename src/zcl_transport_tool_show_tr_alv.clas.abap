"! <p class="shorttext synchronized" lang="en">Show Transport ALV</p>
CLASS zcl_transport_tool_show_tr_alv DEFINITION
  PUBLIC
  CREATE PUBLIC
  INHERITING FROM zcl_transport_tool_alv_main.

  PUBLIC SECTION.
    METHODS:
      constructor,
      display.
  PROTECTED SECTION.
    DATA:
        mt_transports TYPE e070_t.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_transport_tool_show_tr_alv IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).

    me->mt_transports = zcl_transport_tool_dpc=>get_my_open_transports( ).
    me->mt_data = REF #( me->mt_transports ).

  ENDMETHOD.

  METHOD display.
    TRY.
        IF me->mo_salv_table IS NOT BOUND.
          me->init_salv( iv_container_name = 'CC_SALV_SHOW' ).
          me->mo_salv_table->display( ).
        ELSE.
          me->refresh( ).
        ENDIF.
      CATCH cx_salv_msg.
        "handle exception
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
