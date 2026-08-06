"! <p class="shorttext synchronized">DTO: input/output record for Equipment load</p>
"!
"! Types shared by HTTP API, Orchestrator, Workers and Sinks.
"! Technology-agnostic (no HTTP or BAPI references here).
CLASS zcl_equi_load_dto DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! Input record for mass equipment load
      BEGIN OF ty_input,
        ext_id       TYPE c LENGTH 20,   " external key (Migrate Working DB)
        equi_category TYPE c LENGTH 1,   " equipment category (M, P, ...)
        descript     TYPE c LENGTH 40,   " description
        eqtype       TYPE c LENGTH 10,   " equipment type
        maintplant   TYPE c LENGTH 4,    " maintenance plant
        planplant    TYPE c LENGTH 4,    " planning plant
        location     TYPE c LENGTH 10,   " location
        cost_center  TYPE c LENGTH 10,   " cost center
        company_code TYPE c LENGTH 4,    " company code
        start_up_date TYPE d,            " start-up date
        manufacturer TYPE c LENGTH 30,   " manufacturer
        model_number TYPE c LENGTH 20,   " model number
      END OF ty_input,

      tt_input TYPE STANDARD TABLE OF ty_input WITH KEY ext_id,

      "! Processing result for a single record
      BEGIN OF ty_result,
        ext_id    TYPE c LENGTH 20,
        equipment TYPE c LENGTH 18,   " created equipment number
        status    TYPE c LENGTH 1,    " S = Success / E = Error
        message   TYPE string,
      END OF ty_result,

      tt_result TYPE STANDARD TABLE OF ty_result WITH KEY ext_id.

ENDCLASS.

CLASS zcl_equi_load_dto IMPLEMENTATION.
ENDCLASS.
