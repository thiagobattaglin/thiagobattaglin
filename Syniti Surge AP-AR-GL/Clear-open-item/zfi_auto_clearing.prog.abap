"! <p class="shorttext synchronized">Report wrapper for ZCL_FI_AUTO_CLEARING</p>
"! Selection screen report to execute automatic clearing in batch/background.
"! Schedule via SM36 for high-volume scenarios.
REPORT zfi_auto_clearing.

PARAMETERS:
  p_bukrs TYPE bukrs OBLIGATORY,
  p_liflo TYPE lifnr,
  p_lifhi TYPE lifnr,
  p_budat TYPE budat DEFAULT sy-datum,
  p_packet TYPE i DEFAULT 1000.

START-OF-SELECTION.

  DATA(lo_clearing) = NEW zcl_fi_auto_clearing(
    VALUE #(
      bukrs       = p_bukrs
      lifnr_low   = p_liflo
      lifnr_high  = p_lifhi
      budat       = p_budat
      packet_size = p_packet ) ).

  DATA(lt_results) = lo_clearing->execute( ).

  " Output results
  DATA lv_success TYPE i.
  DATA lv_error   TYPE i.

  LOOP AT lt_results INTO DATA(ls_result).
    IF ls_result-success = abap_true.
      lv_success += 1.
      WRITE: / |Vendor { ls_result-lifnr }: Cleared - Doc { ls_result-clrng_doc }/{ ls_result-fiscal_year }|.
    ELSE.
      lv_error += 1.
      WRITE: / |Vendor { ls_result-lifnr }: Error - { ls_result-message }| COLOR COL_NEGATIVE.
    ENDIF.
  ENDLOOP.

  SKIP.
  WRITE: / |Total processed: { lines( lt_results ) }|.
  WRITE: / |Success: { lv_success }| COLOR COL_POSITIVE.
  WRITE: / |Errors:  { lv_error }| COLOR COL_NEGATIVE.
