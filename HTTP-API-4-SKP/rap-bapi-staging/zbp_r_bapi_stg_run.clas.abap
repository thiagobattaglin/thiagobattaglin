"! <p class="shorttext synchronized">Behavior Pool - ZR_BAPI_STG_RUN</p>
"!
"! Static action <em>Submit</em> handler. Persists documents into staging
"! tables via bulk INSERT and dispatches workers with only RunUuid + range.
CLASS zbp_r_bapi_stg_run DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF zr_bapi_stg_run.
ENDCLASS.


CLASS zbp_r_bapi_stg_run IMPLEMENTATION.
ENDCLASS.
