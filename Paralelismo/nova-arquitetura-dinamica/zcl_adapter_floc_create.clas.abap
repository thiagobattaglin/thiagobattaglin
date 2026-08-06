"! <p class="shorttext synchronized">Adapter: BAPI_FUNCLOC_CREATE (Functional Location)</p>
"! Second adapter as an extensibility example.
CLASS zcl_adapter_floc_create DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_load_adapter.

    CONSTANTS c_object_type TYPE c LENGTH 20 VALUE 'FUNC_LOCATION'.

ENDCLASS.


CLASS zcl_adapter_floc_create IMPLEMENTATION.

  METHOD zif_load_adapter~create.

    DATA ls_data     TYPE bapi_itob_flc.
    DATA ls_data_x   TYPE bapi_itob_flc_x.
    DATA lv_funcloc  TYPE tplnr.
    DATA lt_return   TYPE STANDARD TABLE OF bapiret2.

    ls_data-funct_loc  = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'funct_loc' ).
    ls_data-descript   = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'descript' ).
    ls_data-maintplant = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'maintplant' ).
    ls_data-planplant  = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'planplant' ).
    ls_data-cost_ctr   = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'cost_center' ).
    ls_data-comp_code  = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'company_code' ).

    ls_data_x-funct_loc  = abap_true.
    ls_data_x-descript   = abap_true.
    ls_data_x-maintplant = abap_true.
    ls_data_x-planplant  = abap_true.
    ls_data_x-cost_ctr   = abap_true.
    ls_data_x-comp_code  = abap_true.

    CALL FUNCTION 'BAPI_FUNCLOC_CREATE'
      EXPORTING
        funclocdata      = ls_data
        funclocdatax     = ls_data_x
      IMPORTING
        functionallocation = lv_funcloc
      TABLES
        return           = lt_return.

    DATA(lv_has_error) = xsdbool(
      line_exists( lt_return[ type = 'E' ] ) OR
      line_exists( lt_return[ type = 'A' ] ) ).

    IF lv_has_error = abap_true OR lv_funcloc IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      DATA(lv_msg) = COND string(
        LET ls_err = VALUE bapiret2( lt_return[ type = 'E' ] OPTIONAL )
        IN  WHEN ls_err-message IS NOT INITIAL
            THEN ls_err-message
            ELSE `Unknown failure creating Functional Location` ).

      rs_result = VALUE #( ext_id = is_item-ext_id status = 'E' message = lv_msg ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = 'X'.

    rs_result = VALUE #( ext_id    = is_item-ext_id
                         entity_id = lv_funcloc
                         status    = 'S'
                         message   = 'OK' ).

  ENDMETHOD.

ENDCLASS.
