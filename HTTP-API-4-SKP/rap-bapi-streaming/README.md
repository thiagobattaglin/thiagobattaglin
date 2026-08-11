# rap-bapi-streaming — chunk streaming + split lexical

Variante do RAP Dynamic BAPI Runner que **nunca deserializa o payload
inteiro no dispatcher**. Elimina o gargalo do `/ui2/cl_json` central
identificado na versão base ([../rap-bapi-dynamic/README.md](../rap-bapi-dynamic/README.md)).

## Duas estratégias (mesmo serviço)

Selecionadas pelo campo escalar `kind` no payload:

### 1. `kind: "chunk"` — cliente já paginou

O cliente envia **N POSTs pequenos** (ex.: 100 docs por request). O
dispatcher lê apenas o header escalar e encaminha o próprio payload
como **1 chunk único** para **1 worker**. Escala linearmente com o
número de POSTs paralelos do cliente.

```
Cliente ── POST 1 (100 docs) ─► worker A
Cliente ── POST 2 (100 docs) ─► worker B
Cliente ── POST N (100 docs) ─► worker N
```

Zero `deserialize` no dispatcher — só no worker, contra o próprio chunk.

### 2. `kind: "bulk"` — payload gigante único

Quando não dá pra chunkar no cliente, o dispatcher faz **split lexical**
do array `"documents":[...]` **sem deserializar**: uma única varredura
sobre a string mantendo depth de chaves e estado de string, cortando
em fronteiras de topo. Cada chunk é uma substring JSON válida
`[{doc},{doc},...]` já pronta para o worker.

- Custo do dispatcher: O(strlen(payload)) — 1 passada, sem RTTI.
- Custo do worker: `/ui2/cl_json` sobre um chunk pequeno (~worker_rows docs).

## Diferenças chave vs. `rap-bapi-dynamic`

| Ponto | Base | Streaming |
|---|---|---|
| Parse do payload inteiro no dispatcher | `/ui2/cl_json` | **Nenhum** |
| Re-serialize por chunk | Sim | **Não** |
| Chaves de tabelas grandes | `WITH DEFAULT KEY` | `WITH EMPTY KEY` |
| Novo campo | — | `kind` (chunk / bulk) |

## Endpoint

```
POST /sap/opu/odata4/sap/zui_bapi_stream_run_o4/srvd_a2x/sap/zui_bapi_stream_run_o4/0001/BapiRun/com.sap.gateway.srvd_a2x.zui_bapi_stream_run_o4.v0001.Submit
Content-Type: application/json

{ "Payload": "{\"bapi_name\":\"BAPI_PO_CREATE1\",\"kind\":\"chunk\",\"heders_values\":[...],\"items_values\":[...]}" }
```

## Componentes

| Arquivo | Papel |
|---|---|
| [zcl_bapi_stream_dispatcher.clas.abap](./zcl_bapi_stream_dispatcher.clas.abap) | Header scan + split lexical + async dispatch |
| [zcl_bapi_stream_caller.clas.abap](./zcl_bapi_stream_caller.clas.abap) | Deserialize por chunk + introspecção + BAPI call |
| [z_bapi_stream_worker.fugr.abap](./z_bapi_stream_worker.fugr.abap) | FM RFC-enabled — entry dos workers |
| [zbapi_stream_run.tabl.xml](./zbapi_stream_run.tabl.xml) | Tabela de auditoria |
| [zr_bapi_stream_run.ddls.asddls](./zr_bapi_stream_run.ddls.asddls) | Root view |
| [zc_bapi_stream_run.ddls.asddls](./zc_bapi_stream_run.ddls.asddls) | Projection view |
| [zr_bapi_stream_run.bdef.asbdef](./zr_bapi_stream_run.bdef.asbdef) | Behavior definition (root) |
| [zc_bapi_stream_run.bdef.asbdef](./zc_bapi_stream_run.bdef.asbdef) | Behavior projection |
| [zbp_r_bapi_stream_run.clas.abap](./zbp_r_bapi_stream_run.clas.abap) | Behavior pool |
| [zbp_r_bapi_stream_run.clas.locals_imp.abap](./zbp_r_bapi_stream_run.clas.locals_imp.abap) | Handler da action Submit |
| [zd_bapi_stream_in.ddls.asddls](./zd_bapi_stream_in.ddls.asddls) / [zd_bapi_stream_out.ddls.asddls](./zd_bapi_stream_out.ddls.asddls) | Abstract entities da action |
| [zui_bapi_stream_run_o4.srvd.asrvd](./zui_bapi_stream_run_o4.srvd.asrvd) / [.srvb.srvb](./zui_bapi_stream_run_o4.srvb.srvb) | Service definition + binding |
| [zcl_bapi_stream_dispatcher.clas.testclasses.abap](./zcl_bapi_stream_dispatcher.clas.testclasses.abap) | Unit tests (split lexical + parse header) |
