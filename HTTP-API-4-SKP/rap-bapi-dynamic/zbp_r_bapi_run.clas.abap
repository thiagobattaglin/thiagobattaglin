"! <p class="shorttext synchronized">Behavior Pool - ZR_BAPI_RUN (Dyn BAPI Runner)</p>
"!
"! Static action <em>Submit</em> handler. Delegates JSON parsing,
"! worker calculation, and async dispatch to <em>zcl_bapi_rap_dispatcher</em>.
"! Implementation is in <em>zbp_r_bapi_run.clas.locals_imp.abap</em>.
CLASS zbp_r_bapi_run DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF zr_bapi_run.
ENDCLASS.


CLASS zbp_r_bapi_run IMPLEMENTATION.
ENDCLASS.
