"! <p class="shorttext synchronized">Behavior Pool - ZR_BAPI_STREAM_RUN</p>
"!
"! Static action <em>Submit</em> handler. Delegates to
"! <em>zcl_bapi_stream_dispatcher</em> which does NOT deserialize the
"! whole payload: it only reads the small scalar header and either
"! forwards the chunk as-is (kind=chunk) or splits the documents[]
"! array lexically (kind=bulk).
CLASS zbp_r_bapi_stream_run DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF zr_bapi_stream_run.
ENDCLASS.


CLASS zbp_r_bapi_stream_run IMPLEMENTATION.
ENDCLASS.
