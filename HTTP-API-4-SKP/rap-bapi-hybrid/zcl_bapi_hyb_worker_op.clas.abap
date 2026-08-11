CLASS zcl_bapi_hyb_worker_op DEFINITION
  PUBLIC
  CREATE PUBLIC.

* Worker execution unit. Called synchronously by the dispatcher.
* Upgrade path: when IF_BGMC_OP_SINGLE_TX_UNCONTROLLED becomes available
* in the target release, re-introduce that interface and remove the direct
* call from dispatch_chunks.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING iv_bapi_name TYPE string
                iv_mode      TYPE string
                iv_chunk     TYPE string.

    METHODS execute
      RAISING cx_root.

  PRIVATE SECTION.

    DATA mv_bapi_name TYPE string.
    DATA mv_mode      TYPE string.
    DATA mv_chunk     TYPE string.

ENDCLASS.


CLASS zcl_bapi_hyb_worker_op IMPLEMENTATION.

  METHOD constructor.
    mv_bapi_name = iv_bapi_name.
    mv_mode      = iv_mode.
    mv_chunk     = iv_chunk.
  ENDMETHOD.

  METHOD execute.
    DATA(lo_caller) = NEW zcl_bapi_hyb_caller( mv_bapi_name ).
    lo_caller->process_chunk_json( mv_chunk ).
  ENDMETHOD.

ENDCLASS.
