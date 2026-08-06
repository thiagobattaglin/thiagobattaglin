"! <p class="shorttext synchronized">Facade for PM notification BAPIs</p>
"! Allows the completer logic to be unit-tested with a test double
"! instead of calling the real BAPI_ALM_NOTIF_* function modules.
INTERFACE /hdl/if_alm_notif_bapi
  PUBLIC.

  TYPES ty_message  TYPE string.
  TYPES ty_messages TYPE STANDARD TABLE OF ty_message WITH EMPTY KEY.

  TYPES: BEGIN OF ty_result,
           success  TYPE abap_bool,
           messages TYPE ty_messages,
         END OF ty_result.

  "! Sets the notification to "In Process" (status IARB / removes OSNO).
  METHODS put_in_progress
    IMPORTING iv_notif_no      TYPE qmnum
    RETURNING VALUE(rs_result) TYPE ty_result.

  "! Sets the notification to "Completed" (status NOCO / I0076).
  METHODS complete
    IMPORTING iv_notif_no      TYPE qmnum
    RETURNING VALUE(rs_result) TYPE ty_result.

  METHODS commit.

  METHODS rollback.

ENDINTERFACE.
