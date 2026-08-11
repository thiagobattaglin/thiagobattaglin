# rap-bapi-staging — persistência em staging DB (sem JSON entre hops)

Variante do RAP Dynamic BAPI Runner que **elimina o serialize/deserialize
intermediário entre dispatcher e workers**. O payload de entrada é
persistido diretamente em tabelas de staging via `INSERT ... FROM TABLE`
e os workers leem sua fatia por `RunUuid + doc_seq range`.

Base: [../rap-bapi-dynamic/README.md](../rap-bapi-dynamic/README.md).

## Como funciona

1. Cliente faz **POST** com o payload de negócio.
2. Dispatcher deserializa **uma única vez** e escreve em bulk em duas
   tabelas de staging (uma passada única cada):
   - `zbapi_stg_doc` (1 linha por documento)
   - `zbapi_stg_item` (flat name/value com `section = H | I`)
3. Dispatcher calcula ranges `(doc_from, doc_to)` e dispara N workers
   passando **apenas** `RunUuid + range` — sem JSON no RFC.
4. Cada worker executa **um único** `SELECT ... BETWEEN` no
   `zbapi_stg_item` (prefixo da PK → uso natural do índice), rehydrata
   os documentos em memória e executa a BAPI.

## Diferenças chave vs. `rap-bapi-dynamic`

| Ponto | Base | Staging |
|---|---|---|
| Deserialize no dispatcher | 1× (payload todo) | 1× (payload todo) |
| Serialize (split) | 1× por chunk (`/ui2/cl_json=>serialize`) | **0** — elimina totalmente |
| Deserialize no worker | 1× por chunk | **0** — SELECT direto |
| Parâmetros do RFC | `iv_chunk TYPE string` (JSON) | `iv_run_uuid + iv_doc_from + iv_doc_to` |
| Chaves de tabelas grandes | `WITH DEFAULT KEY` | `WITH EMPTY KEY` |
| Extras | — | Persistência auditável, replays possíveis |

## Trade-offs

- **Prós**
  - Elimina o pico de memória duplicada que o serialize+deserialize
    intermediário produzia.
  - O SELECT do worker é `WHERE run_uuid = ? AND doc_seq BETWEEN ? AND ?`,
    que casa com o prefixo da PK (`RUN_UUID, DOC_SEQ`) — índice
    primário resolve.
  - Payload fica persistido: dá pra reprocessar sem o cliente re-enviar.
- **Contras**
  - O dispatcher ainda tem 1 deserialize de payload cheio (para poder
    escrever no staging). Combinar com **Projeto 1 (streaming)** ou
    **Projeto 2 (CTF)** anula esse custo restante.
  - Volume de linhas em `zbapi_stg_item` = Σ(campos por doc). Precisa
    de estratégia de expurgo (job noturno, TTL por `RunUuid`).

## Endpoint

```
POST /sap/opu/odata4/sap/zui_bapi_stg_run_o4/srvd_a2x/sap/zui_bapi_stg_run_o4/0001/BapiRun/com.sap.gateway.srvd_a2x.zui_bapi_stg_run_o4.v0001.Submit
```

## Componentes

| Arquivo | Papel |
|---|---|
| [zcl_bapi_stg_dispatcher.clas.abap](./zcl_bapi_stg_dispatcher.clas.abap) | Parse + bulk INSERT nas staging + async dispatch (range) |
| [zcl_bapi_stg_caller.clas.abap](./zcl_bapi_stg_caller.clas.abap) | SELECT + rehydrate + introspecção + BAPI call |
| [z_bapi_stg_worker.fugr.abap](./z_bapi_stg_worker.fugr.abap) | FM RFC-enabled (aceita apenas UUID + range) |
| [zbapi_stg_run.tabl.xml](./zbapi_stg_run.tabl.xml) | Tabela de auditoria (persistida pelo behavior) |
| [zbapi_stg_doc.tabl.xml](./zbapi_stg_doc.tabl.xml) | Staging: 1 linha por documento |
| [zbapi_stg_item.tabl.xml](./zbapi_stg_item.tabl.xml) | Staging: name/value flat, PK (RUN_UUID, DOC_SEQ, SECTION, PARAM_SEQ, FIELD_SEQ) |
| [zr_bapi_stg_run.ddls.asddls](./zr_bapi_stg_run.ddls.asddls) | Root view |
| [zc_bapi_stg_run.ddls.asddls](./zc_bapi_stg_run.ddls.asddls) | Projection view |
| [zr_bapi_stg_run.bdef.asbdef](./zr_bapi_stg_run.bdef.asbdef) | Behavior definition |
| [zc_bapi_stg_run.bdef.asbdef](./zc_bapi_stg_run.bdef.asbdef) | Behavior projection |
| [zbp_r_bapi_stg_run.clas.abap](./zbp_r_bapi_stg_run.clas.abap) | Behavior pool |
| [zbp_r_bapi_stg_run.clas.locals_imp.abap](./zbp_r_bapi_stg_run.clas.locals_imp.abap) | Handler da action Submit |
| [zd_bapi_stg_in.ddls.asddls](./zd_bapi_stg_in.ddls.asddls) / [zd_bapi_stg_out.ddls.asddls](./zd_bapi_stg_out.ddls.asddls) | Abstract entities |
| [zui_bapi_stg_run_o4.srvd.asrvd](./zui_bapi_stg_run_o4.srvd.asrvd) / [.srvb.srvb](./zui_bapi_stg_run_o4.srvb.srvb) | Service definition + binding |
| [architecture.mmd](./architecture.mmd) | Diagrama Mermaid |
| [zcl_bapi_stg_dispatcher.clas.testclasses.abap](./zcl_bapi_stg_dispatcher.clas.testclasses.abap) | Unit tests (splits/defaults) |
