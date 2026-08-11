# HTTP API Dynamic BAPI Runner (ABAP)

Serviço HTTP RESTful em ABAP cloud-compliant que recebe um JSON descrevendo
qualquer BAPI existente no SAP e a executa de forma assíncrona, distribuída
em múltiplos workers, com mapeamento dinâmico dos campos (sem hardcodes).

## Endpoint

`POST /sap/bc/http/sap/zbapi_dyn` (ou equivalente exposto via SICF / HTTP Service)

Content-Type: `application/json`

## Payload

O payload segue o formato de `input.json`. O JSON representa **um documento**
por padrão. Para carga em massa envie um array em `documents`.

```jsonc
{
  "mode": "async",              // "async" (default) | "sync"
  "bapi_name": "BAPI_PO_CREATE1", // qualquer FM/BAPI SAP
  "worker_threads": 10,         // <= 0 / vazio / ausente => 4
  "worker_rows": 5000,          // <= 0 / vazio / ausente => 5000
  "heders_values": [ ... ],     // estruturas IMPORTING / CHANGING da BAPI
  "items_values":  [ ... ]      // parâmetros TABLES da BAPI
}
```

Cada entrada de `heders_values` / `items_values` tem:

```jsonc
{ "value": "<nome do parâmetro da BAPI>", "fields": [ { "name": "...", "value": "..." } ] }
```

O `name` casa com o componente da estrutura ABAP (case-insensitive).
Se o mesmo TABLES parameter aparecer várias vezes em `items_values`,
cada ocorrência adiciona uma **linha** à tabela interna.

Para carga bulk:

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

HTTP `202 Accepted` (async) ou `200 OK` (sync):

```json
{ "bapi_name": "BAPI_PO_CREATE1", "accepted": 12000, "workers": 3, "mode": "async" }
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

Cada worker é despachado via `CALL FUNCTION 'Z_BAPI_DYN_WORKER' STARTING NEW TASK ... DESTINATION IN GROUP DEFAULT`
(fire-and-forget). O HTTP retorna imediatamente com `accepted` e `workers`.

## Estratégia de commit

Commit **por documento** (dentro do worker):

- `BAPI_TRANSACTION_COMMIT` (WAIT = 'X') após cada BAPI bem-sucedida.
- `BAPI_TRANSACTION_ROLLBACK` se o `RETURN` da BAPI conter mensagens `E` / `A`.
- Isola falhas: 1 documento com erro não invalida os demais do chunk.
- Alta performance é obtida pelo paralelismo entre workers, não por batch commit.

## Componentes

| Arquivo | Papel |
|---|---|
| `zcl_http_bapi_dyn.clas.abap` | Handler HTTP (`if_http_service_extension`) |
| `zcl_bapi_dyn_dispatcher.clas.abap` | Parse JSON, defaults, cálculo de workers, split, dispatch async |
| `zcl_bapi_dyn_dispatcher.clas.testclasses.abap` | Testes unitários |
| `zcl_bapi_dyn_caller.clas.abap` | Introspecção + mapeamento dinâmico + chamada da BAPI + commit/rollback |
| `z_bapi_dyn_worker.fugr.abap` | Function Module RFC-enabled (entry point dos workers) |
| `architecture.mmd` | Diagrama Mermaid |

## Ativação / Publicação

1. Criar Function Group `Z_BAPI_DYN_WORKER` (RFC-enabled) e o FM `Z_BAPI_DYN_WORKER`.
2. Ativar as classes.
3. Criar HTTP Service (Service Binding) apontando para `zcl_http_bapi_dyn`.
4. Opcional: definir server group RFC para paralelismo (`RZ12`).
