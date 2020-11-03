CLASS y_check_cx_root_usage DEFINITION
  PUBLIC
  INHERITING FROM y_check_base
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor .
  PROTECTED SECTION.
    METHODS inspect_tokens REDEFINITION.
  PRIVATE SECTION.
    METHODS has_cx_root
      IMPORTING statement     TYPE sstmnt
      RETURNING VALUE(result) TYPE abap_bool.
ENDCLASS.



CLASS Y_CHECK_CX_ROOT_USAGE IMPLEMENTATION.


  METHOD constructor.
    super->constructor( ).

    settings-pseudo_comment = '"#EC NEED_CX_ROOT' ##NO_TEXT.
    settings-disable_threshold_selection = abap_true.
    settings-threshold = 0.
    settings-documentation = |{ c_docs_path-checks }cx_root_usage.md|.

    set_check_message( 'CX_ROOT should not be used!' ).
  ENDMETHOD.


  METHOD inspect_tokens.
    CHECK get_token_abs( statement-from ) EQ 'CATCH'
      AND has_cx_root( statement ) EQ abap_true.

    DATA(check_configuration) = detect_check_configuration( statement ).

    IF check_configuration IS INITIAL.
      RETURN.
    ENDIF.

    raise_error( statement_level     = statement-level
                 statement_index     = index
                 statement_from      = statement-from
                 error_priority      = check_configuration-prio ).
  ENDMETHOD.


  METHOD has_cx_root.
    LOOP AT ref_scan_manager->get_tokens( ) ASSIGNING FIELD-SYMBOL(<tokens>)
          FROM statement-from TO statement-to WHERE str EQ 'CX_ROOT'.
      result = abap_true.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.