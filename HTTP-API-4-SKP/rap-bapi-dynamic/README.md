# RAP Dynamic BAPI Runner (OData V4)

Serviço **RAP (managed)** publicado como **OData V4** que expõe uma
`static action Submit` capaz de receber um JSON descrevendo qualquer BAPI
do SAP e executá-la de forma **assíncrona**, dividida em múltiplos
workers, com mapeamento **100% dinâmico** dos campos (sem hardcodes).

Equivalente RAP da versão HTTP em [`http-api-dynamic/`](../http-api-dynamic/README.md).

---

## Endpoint

Service Binding **OData V4 Web API** `ZUI_BAPI_RUN_O4`:

```
POST /sap/opu/odata4/sap/zui_bapi_run_o4/srvd_a2x/sap/zui_bapi_run_o4/0001/BapiRun/com.sap.gateway.srvd_a2x.zui_bapi_run_o4.v0001.Submit
Content-Type: application/json
```

Payload da OData action:

```json
{
  "Payload": "<JSON de negócio serializado como string>"
}
```

Onde `Payload` contém exatamente o mesmo formato definido em
[`input.json`](./input.json). O JSON interno deve ser **escapado** para
respeitar o encoding de string OData.

Exemplo (`.http`):

```http
POST /sap/opu/odata4/sap/zui_bapi_run_o4/srvd_a2x/sap/zui_bapi_run_o4/0001/BapiRun/com.sap.gateway.srvd_a2x.zui_bapi_run_o4.v0001.Submit HTTP/1.1
X-CSRF-Token: <token>
Content-Type: application/json

{ "Payload": "{\"bapi_name\":\"BAPI_PO_CREATE1\",\"worker_threads\":10,\"worker_rows\":5000,\"heders_values\":[...],\"items_values\":[...]}" }
```

## Payload de negócio (dentro de `Payload`)

```jsonc
{
  "mode": "async",              // "async" (default) | "sync"
  "bapi_name": "BAPI_PO_CREATE1", // qualquer FM/BAPI existente
  "worker_threads": 10,         // <= 0 / vazio / ausente => 4
  "worker_rows": 5000,          // <= 0 / vazio / ausente => 5000
  "heders_values": [ ... ],     // parâmetros IMPORTING / CHANGING da BAPI
  "items_values":  [ ... ]      // parâmetros TABLES da BAPI
}
```

Cada entrada em `heders_values` / `items_values`:

```jsonc
{ "value": "<nome do parâmetro da BAPI>", "fields": [ { "name": "...", "value": "..." } ] }
```

`name` casa com o componente da estrutura ABAP (case-insensitive).
Cada ocorrência de um mesmo `TABLES` parameter em `items_values`
adiciona **uma linha** à tabela interna.

Carga em massa (bulk):

```jsonc
{
  "bapi_name": "...",
  "worker_threads": 10,
  "worker_rows": 5000,
  "documents": [
    { "heders_values": [...], "items_values": [...] },
    { "heders_values": [...], "items_values": [...] }
  ]
}
```

## Resposta

`202 Accepted` (async) — corpo OData padrão para action result:

```json
{
  "@odata.context": ".../$metadata#Collection(...)",
  "value": [
    {
      "RunUuid":  "5F1A9C33F3E01EDBB4F4A2B9F1234567",
      "BapiName": "BAPI_PO_CREATE1",
      "Accepted": 12000,
      "Workers":  3,
      "ExecMode": "async"
    }
  ]
}
```

- `RunUuid` é o identificador do registro de auditoria persistido na
  tabela `zbapi_run` e navegável via `GET BapiRun('...')`.

## Auditoria / Monitoramento

Cada `Submit` cria uma linha em `zbapi_run` (via `MODIFY ENTITY ... CREATE`
+ `COMMIT ENTITIES`) contendo `BapiName`, `WorkerThreads`, `WorkerRows`,
`Accepted`, `Workers`, `ExecMode`, `Status`, `CreatedBy`, `CreatedAt`.

Consulta:

```
GET /sap/opu/odata4/sap/zui_bapi_run_o4/srvd_a2x/sap/zui_bapi_run_o4/0001/BapiRun?$orderby=CreatedAt desc&$top=20
```

## Estratégia de execução

| Parâmetro | Default | Regra |
|---|---|---|
| `worker_threads` | `4` | máximo de workers paralelos |
| `worker_rows`    | `5000` | máximo de documentos por worker |

Cálculo:

```
needed_workers    = ceil(total_docs / worker_rows)
effective_workers = min(needed_workers, worker_threads)
chunk_size        = ceil(total_docs / effective_workers)
```

Cada worker roda em `CALL FUNCTION 'Z_BAPI_RAP_WORKER' STARTING NEW TASK
DESTINATION IN GROUP DEFAULT` (fire-and-forget). O `Submit` retorna
imediatamente com `Accepted` e `Workers`.

## Estratégia de commit

Commit **por documento** dentro do worker:

- `BAPI_TRANSACTION_COMMIT` (WAIT = 'X') após cada BAPI bem-sucedida.
- `BAPI_TRANSACTION_ROLLBACK` se o `RETURN` contiver `E` / `A` / `X`.
- Isola falhas: um documento inválido não invalida os demais do chunk.
- Alta performance vem do **paralelismo entre workers**, não do batch commit.

O registro de auditoria em `zbapi_run` é persistido com `COMMIT ENTITIES`
imediatamente após o despacho, para não depender do save-sequence do BO.

## Componentes

| Arquivo | Papel |
|---|---|
| [`zbapi_run.tabl.xml`](./zbapi_run.tabl.xml) | Tabela de persistência (auditoria) |
| [`zd_bapi_submit_in.ddls.asddls`](./zd_bapi_submit_in.ddls.asddls) | Abstract entity: parâmetro `Payload` da action |
| [`zd_bapi_submit_out.ddls.asddls`](./zd_bapi_submit_out.ddls.asddls) | Abstract entity: resultado da action |
| [`zr_bapi_run.ddls.asddls`](./zr_bapi_run.ddls.asddls) | Root view sobre `zbapi_run` |
| [`zc_bapi_run.ddls.asddls`](./zc_bapi_run.ddls.asddls) | Projection view (`transactional_query`) |
| [`zc_bapi_run.mde.asmde`](./zc_bapi_run.mde.asmde) | Metadata extension (UI) |
| [`zr_bapi_run.bdef.asbdef`](./zr_bapi_run.bdef.asbdef) | Behavior definition (root, `static action Submit`) |
| [`zc_bapi_run.bdef.asbdef`](./zc_bapi_run.bdef.asbdef) | Behavior projection |
| [`zbp_r_bapi_run.clas.abap`](./zbp_r_bapi_run.clas.abap) | Behavior class (abstract, hosting local classes) |
| [`zbp_r_bapi_run.clas.locals_imp.abap`](./zbp_r_bapi_run.clas.locals_imp.abap) | `lhc_bapi_run` — handler da action |
| [`zui_bapi_run_o4.srvd.asrvd`](./zui_bapi_run_o4.srvd.asrvd) | Service definition |
| [`zui_bapi_run_o4.srvb.srvb`](./zui_bapi_run_o4.srvb.srvb) | Service binding (OData V4 Web API) |
| [`zcl_bapi_rap_dispatcher.clas.abap`](./zcl_bapi_rap_dispatcher.clas.abap) | Parse JSON / defaults / split / dispatch async |
| [`zcl_bapi_rap_dispatcher.clas.testclasses.abap`](./zcl_bapi_rap_dispatcher.clas.testclasses.abap) | Testes unitários |
| [`zcl_bapi_rap_caller.clas.abap`](./zcl_bapi_rap_caller.clas.abap) | Introspecção + mapeamento dinâmico + BAPI call + commit/rollback |
| [`z_bapi_rap_worker.fugr.abap`](./z_bapi_rap_worker.fugr.abap) | Function Module RFC-enabled (entry point dos workers) |
| [`architecture.mmd`](./architecture.mmd) | Diagrama Mermaid |
| [`IMPLEMENTATION-GUIDE.md`](./IMPLEMENTATION-GUIDE.md) | Passo a passo de publicação |

## Premissas atendidas

| # | Premissa | Como é atendida |
|---|---|---|
| 1 | `bapi_name` aceita qualquer BAPI | Introspecção via `FUNCTION_IMPORT_INTERFACE` + RTTI `describe_by_name` — sem lista fixa |
| 2 | `heders_values` e `items_values` cobrem todas as estruturas IMPORTING/CHANGING e TABLES | `zcl_bapi_rap_caller` popula `PARAMETER-TABLE` para IMPORTING/CHANGING e agrupa linhas por `TABLES` |
| 4 | `worker_threads` default = 4 | `normalize_positive` no dispatcher |
| 5 | `worker_rows` default = 5000, itens não contam | Split feito pelo número de documentos; TABLES rows são atributos do documento |
| 6 | Async + resposta `{ bapi_name, accepted, workers, mode }` | Static action retorna `ZD_BAPI_SUBMIT_OUT` (`ExecMode` no OData; `MODE` renomeado para `EXEC_MODE` na DB por ser palavra reservada) |
| 7 | Estratégia de commit | Commit **por documento** dentro do worker; melhor performance vem do paralelismo, não do batch |
| 8 | Mapping dinâmico sem hardcode | `FUNCTION_IMPORT_INTERFACE` + `describe_by_name` + `CREATE DATA ... TYPE HANDLE` + `ASSIGN COMPONENT` |
| 9 | Isolamento de código anterior | Nomes com prefixo `_rap_` / `zbapi_run` — não referenciam `zcl_bapi_dyn_*` |

---

## English Version

# RAP Dynamic BAPI Runner (OData V4)

Managed RAP service published as OData V4 exposing a static action `Submit`.
It receives a JSON payload describing any SAP BAPI and executes it asynchronously,
split across multiple workers, with fully dynamic field mapping (no hardcoded
structures or field names).

## Endpoint

Service Binding OData V4 Web API `ZUI_BAPI_RUN_O4`:

```
POST /sap/opu/odata4/sap/zui_bapi_run_o4/srvd_a2x/sap/zui_bapi_run_o4/0001/BapiRun/com.sap.gateway.srvd_a2x.zui_bapi_run_o4.v0001.Submit
Content-Type: application/json
```

OData action payload:

```json
{
  "Payload": "<business JSON serialized as string>"
}
```

`Payload` must contain the same structure shown in `input.json`, escaped as a
JSON string for OData transport.

Business JSON (inside `Payload`):

```jsonc
{
  "mode": "async",                // "async" (default) | "sync"
  "bapi_name": "BAPI_PO_CREATE1", // any existing SAP BAPI/FM
  "worker_threads": 10,            // <= 0 / empty / missing => 4
  "worker_rows": 5000,             // <= 0 / empty / missing => 5000
  "heders_values": [ ... ],        // IMPORTING / CHANGING structures
  "items_values":  [ ... ]         // TABLES parameters
}
```

Bulk payload is supported through `documents`.

## Response

`202 Accepted` (async):

```json
{
  "@odata.context": ".../$metadata#Collection(...)",
  "value": [
    {
      "RunUuid": "5F1A9C33F3E01EDBB4F4A2B9F1234567",
      "BapiName": "BAPI_PO_CREATE1",
      "Accepted": 12000,
      "Workers": 3,
      "ExecMode": "async"
    }
  ]
}
```

## Execution strategy

- `worker_threads` default: `4`
- `worker_rows` default: `5000`

Formula:

```
needed_workers    = ceil(total_docs / worker_rows)
effective_workers = min(needed_workers, worker_threads)
chunk_size        = ceil(total_docs / effective_workers)
```

Workers are dispatched with:

```
CALL FUNCTION 'Z_BAPI_RAP_WORKER' STARTING NEW TASK DESTINATION IN GROUP DEFAULT
```

## Commit strategy

Per-document commit inside each worker:

- `BAPI_TRANSACTION_COMMIT` with `WAIT = 'X'` on success
- `BAPI_TRANSACTION_ROLLBACK` when `RETURN` contains `E`, `A`, or `X`

This isolates failures and scales through parallel workers.

## Main components

- `zbapi_run.tabl.xml`: persistence/audit table
- `zd_bapi_submit_in.ddls.asddls`: action input abstract entity
- `zd_bapi_submit_out.ddls.asddls`: action output abstract entity
- `zr_bapi_run.ddls.asddls`: root view
- `zc_bapi_run.ddls.asddls`: projection view
- `zr_bapi_run.bdef.asbdef`: root behavior with static action `Submit`
- `zbp_r_bapi_run.clas.locals_imp.abap`: action handler implementation
- `zcl_bapi_rap_dispatcher.clas.abap`: JSON parse/defaults/split/dispatch
- `zcl_bapi_rap_caller.clas.abap`: dynamic introspection, bind, BAPI call
- `z_bapi_rap_worker.fugr.abap`: RFC-enabled worker function module

## Requirement mapping

1. `bapi_name` accepts any existing BAPI/FM: dynamic introspection via `FUNCTION_IMPORT_INTERFACE` + RTTI.
2. Dynamic handling of IMPORTING/CHANGING/TABLES from `heders_values` and `items_values`.
3. `worker_threads` defaults to 4 when missing/invalid.
4. `worker_rows` defaults to 5000 when missing/invalid.
5. Async response returns `bapi_name`, `accepted`, `workers`, and `mode` (`ExecMode` in OData output).
6. Commit strategy optimized for throughput and failure isolation.
7. No hardcoded field mapping.
8. Isolated implementation (`_rap_` naming, independent artifacts).
