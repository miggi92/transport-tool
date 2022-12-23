*&---------------------------------------------------------------------*
*& Report z_transport_refactor_import_q
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_transport_refactor_import_q.


DATA:
  gv_keep_date    TYPE sy-datum,
  gt_import_queue TYPE STANDARD TABLE OF tmsbuffer WITH HEADER LINE,
  gt_deleting_tr  TYPE stms_tr_requests,
  gv_system       TYPE tmssysnam.

PARAMETERS:
  p_mkeep TYPE numc3 DEFAULT 3,
  p_test  AS CHECKBOX DEFAULT 'X'.


START-OF-SELECTION.

  CALL FUNCTION 'CCM_GO_BACK_MONTHS'
    EXPORTING
      currdate   = sy-datum
      backmonths = p_mkeep
    IMPORTING
      newdate    = gv_keep_date.

  gv_system = sy-sysid.
  " read import queue
  CALL FUNCTION 'TMS_MGR_READ_TRANSPORT_QUEUE'
    EXPORTING
      iv_system          = gv_system
*     iv_domain          = space
*     iv_collect_data    =
*     iv_count_only      =
*     iv_read_shadow     =
*     iv_maxrc_only      = 'X'
*     iv_read_locks      = 'X'
*     iv_clear_locks     = 'X'
*     iv_use_data_files  =
*     iv_update_cache    = 'X'
*     iv_monitor         = 'X'              " Progress Display
*     iv_progress_min    = 1
*     iv_progress_max    = 100
*     iv_verbose         =
*     iv_expiration_date =
*     iv_allow_expired   =
*     it_systems         =
*    IMPORTING
*     ev_collect_date    =
*     ev_collect_time    =
*     ev_collect_flag    =
*     es_exception       =
    TABLES
      tt_buffer          = gt_import_queue
*     tt_counter         =
*     tt_project         =
*     tt_domain          =
*     tt_system          =
*     tt_group           =
    EXCEPTIONS
      read_config_failed = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
*   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  DELETE gt_import_queue[] WHERE impflg <> '2'.


  LOOP AT gt_import_queue[] ASSIGNING FIELD-SYMBOL(<gs_import_queue>).
    SELECT SINGLE *                           "#EC CI_ALL_FIELDS_NEEDED
        FROM tpalog
        INTO @DATA(gs_log)
        WHERE trkorr = @<gs_import_queue>-trkorr
          AND trstep = '!'
          AND tarsystem = @gv_system.                   "#EC CI_GENBUFF

    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.

    IF gv_keep_date > gs_log(8).
      APPEND <gs_import_queue> TO gt_deleting_tr.
    ENDIF.
  ENDLOOP.

  IF gt_deleting_tr IS NOT INITIAL.
    IF p_test = abap_true.
      WRITE: |Would delete { lines( gt_deleting_tr ) } Transports.|.
    ELSE.
      CALL FUNCTION 'TMS_UI_MAINTAIN_TR_QUEUE'
        EXPORTING
          iv_system             = gv_system
*         iv_domain             =
          iv_request            = 'SOME'
*         iv_tarcli             =
*         iv_open_queue         =
*         iv_close_queue        =
          iv_del_request        = abap_true
*         iv_act_request        =
*         iv_clear_queue        =
*         iv_verbose            =
*         iv_expert_mode        =
          it_requests           = gt_deleting_tr
        EXCEPTIONS
          cancelled_by_user     = 1
          maintain_queue_failed = 2
          OTHERS                = 3.
    ENDIF.

    IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
