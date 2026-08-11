"! <p class="shorttext synchronized">Behavior Pool - ZR_BAPI_HYB_RUN</p>
"!
"! Static action <em>Submit</em> handler. Streaming header parse,
"! lexical split of documents[], kernel CTF-based deserialize in the
"! worker, and bgPF-based async dispatch.
CLASS zbp_r_bapi_hyb_run DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF zr_bapi_hyb_run.
ENDCLASS.


CLASS zbp_r_bapi_hyb_run IMPLEMENTATION.
ENDCLASS.
