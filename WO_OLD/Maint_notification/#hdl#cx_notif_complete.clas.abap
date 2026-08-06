CLASS /hdl/cx_notif_complete DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  CREATE PUBLIC.

  PUBLIC SECTION.
    DATA message TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        iv_message TYPE string   OPTIONAL
        previous   LIKE previous OPTIONAL.

    METHODS get_text REDEFINITION.
ENDCLASS.


CLASS /hdl/cx_notif_complete IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    me->message = iv_message.
  ENDMETHOD.

  METHOD get_text.
    result = COND #( WHEN message IS NOT INITIAL
                       THEN message
                     ELSE super->get_text( ) ).
  ENDMETHOD.

ENDCLASS.
