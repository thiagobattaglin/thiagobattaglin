"! <p class="shorttext synchronized">Facade for PM order BAPIs (TECO / CLSD / DLFL / Settlement)</p>
"! Allows the closer logic to be unit-tested with a test double instead
"! of calling the real IBAPI_ALM_ORDER_* / BAPI_ALM_ORDER_MAINTAIN
"! function modules.
INTERFACE /hdl/if_alm_order_bapi
  PUBLIC.

  TYPES ty_message  TYPE string.
  TYPES ty_messages TYPE STANDARD TABLE OF ty_message WITH EMPTY KEY.

  TYPES: BEGIN OF ty_result,
           success  TYPE abap_bool,
           messages TYPE ty_messages,
         END OF ty_result.

  METHODS set_teco
    IMPORTING iv_orderid       TYPE aufnr
    RETURNING VALUE(rs_result) TYPE ty_result.

  METHODS set_clsd
    IMPORTING iv_orderid       TYPE aufnr
    RETURNING VALUE(rs_result) TYPE ty_result.

  "! Sets the deletion flag (DLFL) on the order.
  METHODS set_dlfl
    IMPORTING iv_orderid       TYPE aufnr
    RETURNING VALUE(rs_result) TYPE ty_result.

  "! Creates a default settlement rule with a single receiver = cost center,
  "! 100 %, settlement type PER.
  METHODS maintain_settlement_rule
    IMPORTING iv_orderid       TYPE aufnr
              iv_kostl         TYPE kostl
    RETURNING VALUE(rs_result) TYPE ty_result.

  METHODS commit.

  METHODS rollback.

ENDINTERFACE.
