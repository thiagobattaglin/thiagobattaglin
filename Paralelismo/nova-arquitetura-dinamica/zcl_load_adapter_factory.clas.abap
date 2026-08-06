"! <p class="shorttext synchronized">Factory: object_type → adapter</p>
"!
"! Central allowlist. New object types = new adapter class + one entry here.
"! No dynamic CALL FUNCTION: every dispatch is a static reference to a
"! released class, keeping Clean Core compliance.
CLASS zcl_load_adapter_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.

    CLASS-METHODS get
      IMPORTING iv_object_type    TYPE csequence
      RETURNING VALUE(ro_adapter) TYPE REF TO zif_load_adapter
      RAISING   cx_sy_ref_is_initial.

    CLASS-METHODS supports
      IMPORTING iv_object_type   TYPE csequence
      RETURNING VALUE(rv_result) TYPE abap_bool.

ENDCLASS.


CLASS zcl_load_adapter_factory IMPLEMENTATION.

  METHOD get.

    DATA(lv_key) = to_upper( iv_object_type ).

    CASE lv_key.
      WHEN zcl_adapter_equi_create=>c_object_type.
        ro_adapter = NEW zcl_adapter_equi_create( ).

      WHEN zcl_adapter_floc_create=>c_object_type.
        ro_adapter = NEW zcl_adapter_floc_create( ).

      WHEN OTHERS.
        RAISE EXCEPTION TYPE cx_sy_ref_is_initial.
    ENDCASE.

  ENDMETHOD.

  METHOD supports.

    DATA(lv_key) = to_upper( iv_object_type ).
    rv_result = xsdbool( lv_key = zcl_adapter_equi_create=>c_object_type OR
                         lv_key = zcl_adapter_floc_create=>c_object_type ).

  ENDMETHOD.

ENDCLASS.
