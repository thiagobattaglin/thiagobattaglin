"! <p class="shorttext synchronized">DTO: linha de input para carga de PO</p>
CLASS zcl_po_load_dto DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! Registro de entrada da carga em massa
      BEGIN OF ty_input,
        ext_id     TYPE c LENGTH 20,
        vendor     TYPE c LENGTH 10,
        purch_org  TYPE c LENGTH 4,
        pur_group  TYPE c LENGTH 3,
        comp_code  TYPE c LENGTH 4,
        doc_type   TYPE c LENGTH 4,
        material   TYPE c LENGTH 40,
        plant      TYPE c LENGTH 4,
        quantity   TYPE p LENGTH 13 DECIMALS 3,
        net_price  TYPE p LENGTH 11 DECIMALS 2,
        deliv_date TYPE d,
      END OF ty_input,

      tt_input TYPE STANDARD TABLE OF ty_input WITH KEY ext_id,

      "! Resultado do processamento de um registro
      BEGIN OF ty_result,
        ext_id       TYPE c LENGTH 20,
        purchase_order TYPE c LENGTH 10,
        status       TYPE c LENGTH 1,   " S = Success / E = Error
        message      TYPE string,
      END OF ty_result,

      tt_result TYPE STANDARD TABLE OF ty_result WITH KEY ext_id.

ENDCLASS.

CLASS zcl_po_load_dto IMPLEMENTATION.
ENDCLASS.
