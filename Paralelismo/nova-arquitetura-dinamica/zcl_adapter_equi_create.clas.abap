"! <p class="shorttext synchronized">Adapter: BAPI_EQUI_CREATE (Equipment)</p>
CLASS zcl_adapter_equi_create DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_load_adapter.

    CONSTANTS c_object_type TYPE c LENGTH 20 VALUE 'EQUIPMENT'.

ENDCLASS.


CLASS zcl_adapter_equi_create IMPLEMENTATION.

  METHOD zif_load_adapter~create.

    DATA ls_data      TYPE bapi_itob.
    DATA ls_data_x    TYPE bapi_itobx.
    DATA lv_equipment TYPE equnr.
    DATA lt_return    TYPE STANDARD TABLE OF bapiret2.

    DATA(lv_category) = CONV c( zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'equi_category' ) ).

    ls_data-descript      = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'descript' ).
    ls_data-eqtype        = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'eqtype' ).
    ls_data-maintplant    = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'maintplant' ).
    ls_data-planplant     = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'planplant' ).
    ls_data-location      = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'location' ).
    ls_data-cost_ctr      = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'cost_center' ).
    ls_data-comp_code     = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'company_code' ).
    ls_data-manufacturer  = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'manufacturer' ).
    ls_data-model_number  = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'model_number' ).

    DATA(lv_date) = zcl_load_dto=>get_field( it_fields = is_item-fields iv_name = 'start_up_date' ).
    IF lv_date IS NOT INITIAL.
      ls_data-start_up_date = CONV d( replace( val = lv_date sub = `-` occ = 0 with = `` ) ).
    ENDIF.

    ls_data_x-descript      = abap_true.
    ls_data_x-eqtype        = abap_true.
    ls_data_x-maintplant    = abap_true.
    ls_data_x-planplant     = abap_true.
    ls_data_x-location      = abap_true.
    ls_data_x-cost_ctr      = abap_true.
    ls_data_x-comp_code     = abap_true.
    ls_data_x-start_up_date = abap_true.
    ls_data_x-manufacturer  = abap_true.
    ls_data_x-model_number  = abap_true.

    CALL FUNCTION 'BAPI_EQUI_CREATE'
      EXPORTING
        category  = lv_category
        data      = ls_data
        data_x    = ls_data_x
      IMPORTING
        equipment = lv_equipment
      TABLES
        return    = lt_return.

    DATA(lv_has_error) = xsdbool(
      line_exists( lt_return[ type = 'E' ] ) OR
      line_exists( lt_return[ type = 'A' ] ) ).

    IF lv_has_error = abap_true OR lv_equipment IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      DATA(lv_msg) = COND string(
        LET ls_err = VALUE bapiret2( lt_return[ type = 'E' ] OPTIONAL )
        IN  WHEN ls_err-message IS NOT INITIAL
            THEN ls_err-message
            ELSE `Unknown failure creating Equipment` ).

      rs_result = VALUE #( ext_id = is_item-ext_id status = 'E' message = lv_msg ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = 'X'.

    rs_result = VALUE #( ext_id    = is_item-ext_id
                         entity_id = lv_equipment
                         status    = 'S'
                         message   = 'OK' ).

  ENDMETHOD.

ENDCLASS.
