"! <p class="shorttext synchronized">Adapter contract: 1 item = 1 BAPI call + own COMMIT</p>
"!
"! Every concrete adapter maps the generic input (ext_id + fields) to a
"! specific BAPI, executes it, performs its own BAPI_TRANSACTION_COMMIT
"! (or ROLLBACK on failure) and returns a typed result row.
"! The worker is BAPI-agnostic — it only talks to this interface.
INTERFACE zif_load_adapter
  PUBLIC.

  METHODS create
    IMPORTING is_item          TYPE zcl_load_dto=>ty_input
    RETURNING VALUE(rs_result) TYPE zcl_load_dto=>ty_result.

ENDINTERFACE.
