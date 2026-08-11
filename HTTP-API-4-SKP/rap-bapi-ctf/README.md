# rap-bapi-ctf — CALL TRANSFORMATION + cl_sxml_string_reader

Variante do RAP Dynamic BAPI Runner que substitui **`/ui2/cl_json`**
por **`cl_sxml_string_reader` + `CALL TRANSFORMATION id`** para
deserialização (JSON → ABAP) e serialização (ABAP → JSON de chunk).

Base: [../rap-bapi-dynamic/README.md](../rap-bapi-dynamic/README.md).

## Por que CTF/sXML

- **Kernel-side**: reader/writer sXML e `CALL TRANSFORMATION id` são
  implementados no kernel; consumo O(bytes) real, sem RTTI/`ASSIGN
  COMPONENT` por nó.
- **Passada única**: o reader tokeniza a string uma vez e alimenta o
  mapeamento identity para a estrutura ABAP diretamente.
- **Ganho típico**: 3–10× mais rápido que `/ui2/cl_json` para arrays
  grandes; consumo de memória muito menor.

## Padrão adotado

```abap
DATA(lo_reader) = cl_sxml_string_reader=>create(
                    cl_abap_codepage=>convert_to( iv_json ) ).

CALL TRANSFORMATION id
  SOURCE XML lo_reader
  RESULT data = <destino_ABAP>.
```

Serialização de chunks:

```abap
DATA lo_writer TYPE REF TO cl_sxml_string_writer.
lo_writer = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

CALL TRANSFORMATION id
  SOURCE data = <origem>
  RESULT XML lo_writer.

rv_json = cl_abap_codepage=>convert_from( lo_writer->get_output( ) ).
```

## Diferenças chave vs. `rap-bapi-dynamic`

| Ponto | Base | CTF |
|---|---|---|
| Deserialize (dispatcher e worker) | `/ui2/cl_json=>deserialize` | `cl_sxml_string_reader` + `CALL TRANSFORMATION id` |
| Serialize (split de chunks) | `/ui2/cl_json=>serialize` | `cl_sxml_string_writer` + `CALL TRANSFORMATION id` |
| Chaves de tabelas grandes | `WITH DEFAULT KEY` | `WITH EMPTY KEY` |

O contrato do payload (`mode`, `bapi_name`, `worker_threads`,
`worker_rows`, `heders_values`, `items_values`, `documents`) permanece
100% igual ao da versão base.

## Alternativa (mesmo espírito): transformation customizada

Para squeeze adicional, dá pra registrar uma XSLT/JSON transformation
customizada (`ZBAPI_CTF_DESERIALIZE`) que já normaliza case/nomes de
campos, mas essa versão usa `id` que é suficiente porque a shape ABAP
casa com o JSON.

## Endpoint

```
POST /sap/opu/odata4/sap/zui_bapi_ctf_run_o4/srvd_a2x/sap/zui_bapi_ctf_run_o4/0001/BapiRun/com.sap.gateway.srvd_a2x.zui_bapi_ctf_run_o4.v0001.Submit
```

## Componentes

| Arquivo | Papel |
|---|---|
| [zcl_bapi_ctf_dispatcher.clas.abap](./zcl_bapi_ctf_dispatcher.clas.abap) | Parse (CTF) + split + async dispatch |
| [zcl_bapi_ctf_caller.clas.abap](./zcl_bapi_ctf_caller.clas.abap) | Deserialize por chunk (CTF) + BAPI call |
| [z_bapi_ctf_worker.fugr.abap](./z_bapi_ctf_worker.fugr.abap) | FM RFC-enabled — entry dos workers |
| [zbapi_ctf_run.tabl.xml](./zbapi_ctf_run.tabl.xml) | Tabela de auditoria |
| [zr_bapi_ctf_run.ddls.asddls](./zr_bapi_ctf_run.ddls.asddls) | Root view |
| [zc_bapi_ctf_run.ddls.asddls](./zc_bapi_ctf_run.ddls.asddls) | Projection view |
| [zr_bapi_ctf_run.bdef.asbdef](./zr_bapi_ctf_run.bdef.asbdef) | Behavior definition |
| [zc_bapi_ctf_run.bdef.asbdef](./zc_bapi_ctf_run.bdef.asbdef) | Behavior projection |
| [zbp_r_bapi_ctf_run.clas.abap](./zbp_r_bapi_ctf_run.clas.abap) | Behavior pool |
| [zbp_r_bapi_ctf_run.clas.locals_imp.abap](./zbp_r_bapi_ctf_run.clas.locals_imp.abap) | Handler da action Submit |
| [zd_bapi_ctf_in.ddls.asddls](./zd_bapi_ctf_in.ddls.asddls) / [zd_bapi_ctf_out.ddls.asddls](./zd_bapi_ctf_out.ddls.asddls) | Abstract entities |
| [zui_bapi_ctf_run_o4.srvd.asrvd](./zui_bapi_ctf_run_o4.srvd.asrvd) / [.srvb.srvb](./zui_bapi_ctf_run_o4.srvb.srvb) | Service definition + binding |
| [zcl_bapi_ctf_dispatcher.clas.testclasses.abap](./zcl_bapi_ctf_dispatcher.clas.testclasses.abap) | Unit tests |
