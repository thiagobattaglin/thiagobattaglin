"! <p class="shorttext synchronized">Unit tests for ZCL_LOAD_DTO helpers</p>
CLASS ltcl_dto DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS get_field_by_lowercase   FOR TESTING.
    METHODS get_field_case_fallback  FOR TESTING.
    METHODS get_field_missing_blank  FOR TESTING.

ENDCLASS.


CLASS ltcl_dto IMPLEMENTATION.

  METHOD get_field_by_lowercase.

    DATA(lt) = VALUE zcl_load_dto=>tt_field(
      ( name = 'descript' value = 'ABC' ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = `ABC`
      act = zcl_load_dto=>get_field( it_fields = lt iv_name = 'descript' )
      msg = 'Lowercase match must return the value' ).

  ENDMETHOD.

  METHOD get_field_case_fallback.

    DATA(lt) = VALUE zcl_load_dto=>tt_field(
      ( name = 'MAINTPLANT' value = '1010' ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = `1010`
      act = zcl_load_dto=>get_field( it_fields = lt iv_name = 'MAINTPLANT' )
      msg = 'Exact case fallback must succeed' ).

  ENDMETHOD.

  METHOD get_field_missing_blank.

    DATA(lt) = VALUE zcl_load_dto=>tt_field(
      ( name = 'descript' value = 'ABC' ) ).

    cl_abap_unit_assert=>assert_initial(
      act = zcl_load_dto=>get_field( it_fields = lt iv_name = 'nonexistent' )
      msg = 'Missing name must return empty' ).

  ENDMETHOD.

ENDCLASS.
