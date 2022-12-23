"! <p class="shorttext synchronized" lang="en">DPC</p>
CLASS zcl_transport_tool_dpc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS:
      get_my_open_transports
        RETURNING
          VALUE(rt_result) TYPE e070_t,
      release_transport
        IMPORTING
          iv_trkorr        TYPE e070-trkorr
        EXPORTING
          es_request       TYPE trwbo_request
          et_deleted_tasks TYPE trwbo_t_e070
          et_messages      TYPE ctsgerrmsgs,
      display_transport
        IMPORTING
          iv_trkorr TYPE e070-trkorr .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_transport_tool_dpc IMPLEMENTATION.
  METHOD get_my_open_transports.
    SELECT *
        FROM e070
        INTO TABLE @rt_result
        WHERE trstatus = 'D'
          AND as4user = @sy-uname
        ORDER BY trfunction.
  ENDMETHOD.

  METHOD release_transport.
    CALL FUNCTION 'TRINT_RELEASE_REQUEST'
      EXPORTING
        iv_trkorr                   = iv_trkorr
        iv_dialog                   = ' '
        iv_without_locking          = 'X'
      IMPORTING
        es_request                  = es_request
        et_deleted_tasks            = et_deleted_tasks
        et_messages                 = et_messages
      EXCEPTIONS
        cts_initialization_failure  = 1
        enqueue_failed              = 2
        no_authorization            = 3
        invalid_request             = 4
        request_already_released    = 5
        repeat_too_early            = 6
        object_lock_error           = 7
        object_check_error          = 8
        docu_missing                = 9
        db_access_error             = 10
        action_aborted_by_user      = 11
        export_failed               = 12
        execute_objects_check       = 13
        release_in_bg_mode          = 14
        release_in_bg_mode_w_objchk = 15
        error_in_export_methods     = 16
        object_lang_error           = 17
        OTHERS                      = 18.
  ENDMETHOD.

  METHOD display_transport.
    CALL FUNCTION 'TR_DISPLAY_REQUEST'
      EXPORTING
        i_trkorr = iv_trkorr                 " Request/Task
*       i_operation   =
*       i_activetab   =                  " Active tab
*       is_request_wd =
      .
  ENDMETHOD.

ENDCLASS.
