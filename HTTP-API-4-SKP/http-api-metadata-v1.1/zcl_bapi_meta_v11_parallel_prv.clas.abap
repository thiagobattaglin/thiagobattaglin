CLASS zcl_bapi_meta_v11_parallel_prv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

* Provider Clean Core para cl_abap_parallel (released em ABAP Cloud).
* Substitui o antigo Function Group + STARTING NEW TASK (aRFC cl\u00e1ssico,
* n\u00e3o released). O n\u00facleo n\u00e3o fala mais com nenhum FM.
*
* p_in xstring cont\u00e9m um chunk de documentos serializado via
*    EXPORT bapi_name = ... documents = ... TO DATA BUFFER
* Isso mant\u00e9m o provider stateless e sobrevive \u00e0 fork de work processes
* que cl_abap_parallel faz internamente.

  PUBLIC SECTION.
    INTERFACES if_abap_parallel.
ENDCLASS.


CLASS zcl_bapi_meta_v11_parallel_prv IMPLEMENTATION.

  METHOD if_abap_parallel~do.
    DATA lv_bapi_name TYPE string.
    DATA lt_docs      TYPE zif_bapi_meta_v11_executor=>tt_documents.

    TRY.
        IMPORT bapi_name = lv_bapi_name
               documents = lt_docs
               FROM DATA BUFFER p_in.

        " Composition local no worker \u2014 \u00fanico ponto de acoplamento com o legacy.
        DATA(lo_exec) = CAST zif_bapi_meta_v11_executor(
                          NEW zcl_bapi_meta_v11_lgcy_exec( lv_bapi_name ) ).

        LOOP AT lt_docs INTO DATA(ls_doc).
          lo_exec->execute( ls_doc ).
        ENDLOOP.

      CATCH cx_root ##NO_HANDLER.
        " Execu\u00e7\u00e3o paralela nunca deve derrubar o worker do framework.
        " Erros por documento j\u00e1 s\u00e3o tratados pelo executor via BAPI RETURN.
    ENDTRY.

    CLEAR p_out.
  ENDMETHOD.

ENDCLASS.
