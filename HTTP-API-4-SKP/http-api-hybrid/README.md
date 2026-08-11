# HTTP API Hybrid BAPI Runner (ABAP)

Serviço HTTP RESTful em ABAP que recebe um JSON descrevendo qualquer
BAPI existente no SAP e a executa **assíncrona ou síncronamente**, com
mapeamento dinâmico dos campos (sem hardcodes).

Combina a **fachada HTTP** do
[`http-api-dynamic`](../http-api-dynamic/README.md) com as técnicas do
[`rap-bapi-hybrid`](../rap-bapi-hybrid/README.md):

| Componente | Origem | Ganho |
|---|---|---|
| Endpoint `if_http_service_extension` | http-api-dynamic | resposta HTTP idiomática (200 / 202 / 400 / 405) |
| Parser JSON kernel (`cl_sxml_string_reader` + `CALL TRANSFORMATION id`) | rap-bapi-hybrid | zero `/ui2/cl_json` no projeto |
| **Streaming header parse** (`trim_to_header_only` + CTF) | rap-bapi-hybrid | deserializa só os bytes do cabeçalho, não o payload inteiro |
| **Lexical split** (`zcl_http_bapi_hyb_lex_splitter`) | rap-bapi-hybrid | corta `documents[]` em O(strlen), sem RTTI |
| Dispatch async via `STARTING NEW TASK ... DESTINATION IN GROUP DEFAULT` | http-api-dynamic | fire-and-forget imediato — sem depender de RAP save sequence |
| Modo `sync` inline | http-api-dynamic + hybrid | resposta 200 OK após execução do chunk |
| Per-document commit / rollback | ambos | isolamento entre documentos |
| `kind = chunk / bulk` | rap-bapi-hybrid | mesmo endpoint aceita 1 documento ou milhares |

## Endpoint

`POST /sap/bc/http/sap/zbapi_hyb` (ou o path equivalente definido no
SICF / HTTP Service que apontar para `zcl_http_bapi_hyb`).

Content-Type: `application/json`

## Payload

O payload segue [`input.json`](./input.json). O JSON representa
**um documento** por padrão. Para carga em massa envie um array em
`documents` e use `kind: "bulk"`.

```jsonc
{
  "mode": "async",                // "async" (default) | "sync"
  "kind": "bulk",                 // "chunk" (default) | "bulk"
  "bapi_name": "BAPI_PO_CREATE1", // qualquer FM/BAPI SAP
  "worker_threads": 10,           // <= 0 / vazio / ausente => 4
  "worker_rows": 5000,            // <= 0 / vazio / ausente => 5000

  "documents": [                  // usado quando kind = "bulk"
    { "heders_values": [ ... ], "items_values": [ ... ] },
    { "heders_values": [ ... ], "items_values": [ ... ] }
  ],

  "heders_values": [ ... ],       // usado quando kind = "chunk"
  "items_values":  [ ... ]        // usado quando kind = "chunk"
}
```

Cada entrada de `heders_values` / `items_values` tem:

```jsonc
{ "value": "<nome do parâmetro da BAPI>", "fields": [ { "name": "...", "value": "..." } ] }
```

`name` casa com o componente da estrutura ABAP (case-insensitive). Se o
mesmo TABLES parameter aparecer várias vezes em `items_values`, cada
ocorrência adiciona uma **linha** à tabela interna.

### `kind`

| Valor | Comportamento |
|---|---|
| `chunk` (default) | O payload inteiro é considerado **um chunk** — 1 worker executa. Ideal para 1 documento por request. |
| `bulk` | `documents[]` é **cortado lexicalmente** em O(strlen); o cálculo de workers é aplicado; N chunks são despachados. |

## Resposta

- `202 Accepted` para `mode=async`
- `200 OK` para `mode=sync`
- `400 Bad Request` para body vazio / JSON inválido / `bapi_name` ausente
- `405 Method Not Allowed` para verbos que não `POST`

```json
{
  "bapi_name": "BAPI_PO_CREATE1",
  "accepted": 12000,
  "workers": 3,
  "mode": "async",
  "kind": "bulk"
}
```

## Estratégia de execução

| Parâmetro | Default | Regra |
|---|---|---|
| `worker_threads` | `4` | máximo de workers paralelos |
| `worker_rows`    | `5000` | máximo de documentos por worker |

Cálculo (apenas para `kind=bulk`):

```
needed_workers    = ceil(total_docs / worker_rows)
effective_workers = min(needed_workers, worker_threads)
chunk_size        = ceil(total_docs / effective_workers)
```

Cada worker (`Z_HTTP_BAPI_HYB_WORKER`) é despachado via
`CALL FUNCTION 'Z_HTTP_BAPI_HYB_WORKER' STARTING NEW TASK ... DESTINATION IN GROUP DEFAULT`
quando `mode=async`. O HTTP retorna `202 Accepted` imediatamente com
`accepted` e `workers`.

Para `mode=sync` a execução ocorre **inline** dentro do handler HTTP e
a resposta só volta ao cliente após o último `BAPI_TRANSACTION_COMMIT`
do chunk.

## Estratégia de commit

Commit **por documento**, dentro do worker (`zcl_http_bapi_hyb_caller`):

- `BAPI_TRANSACTION_COMMIT WAIT = 'X'` após cada BAPI bem-sucedida;
- `BAPI_TRANSACTION_ROLLBACK` se o `RETURN` da BAPI contiver mensagens
  `E`, `A` ou `X`;
- 1 documento com erro **não invalida** os demais do chunk;
- Alta performance vem do paralelismo entre workers, não de batch commit.

## Como o parse é feito (hybrid)

1. **Header** — `zcl_http_bapi_hyb_dispatcher->trim_to_header_only`
   percorre o payload uma vez e monta uma **substring JSON contendo só
   os escalares de topo** (`bapi_name`, `mode`, `kind`,
   `worker_threads`, `worker_rows`). Essa substring é minúscula e é
   deserializada via `zcl_http_bapi_hyb_json_parser=>deserialize`
   (kernel CTF).
2. **Split de `documents[]`** — `zcl_http_bapi_hyb_lex_splitter` faz
   um único passe O(strlen), respeitando estado de string escapada, e
   emite chunks como `[{doc},{doc}]` prontos para virar payload de
   worker. Sem RTTI, sem `/ui2/cl_json`.
3. **Chunk no worker** — o worker chama
   `zcl_http_bapi_hyb_caller->process_chunk_json` que usa **CTF id**
   sobre um wrapper (`ty_wrapper`) para aceitar tanto array de
   documentos quanto objeto único ou wrapper `{ documents: [...] }`.

## Componentes

| Arquivo | Papel |
|---|---|
| [zcl_http_bapi_hyb.clas.abap](./zcl_http_bapi_hyb.clas.abap) | Handler HTTP (`if_http_service_extension`) |
| [zcl_http_bapi_hyb_dispatcher.clas.abap](./zcl_http_bapi_hyb_dispatcher.clas.abap) | Parse header + split + defaults + dispatch |
| [zcl_http_bapi_hyb_dispatcher.clas.testclasses.abap](./zcl_http_bapi_hyb_dispatcher.clas.testclasses.abap) | Unit tests com stub do `dispatch_chunks` |
| [zcl_http_bapi_hyb_json_parser.clas.abap](./zcl_http_bapi_hyb_json_parser.clas.abap) | Wrapper único do kernel sXML + `CALL TRANSFORMATION id` |
| [zcl_http_bapi_hyb_lex_splitter.clas.abap](./zcl_http_bapi_hyb_lex_splitter.clas.abap) | Split lexical de `documents[]` (O(n)) |
| [zcl_http_bapi_hyb_caller.clas.abap](./zcl_http_bapi_hyb_caller.clas.abap) | Introspecção + mapeamento dinâmico + call + commit/rollback |
| [z_http_bapi_hyb_worker.fugr.abap](./z_http_bapi_hyb_worker.fugr.abap) | Function Module RFC-enabled (entry point dos workers async) |
| [architecture.mmd](./architecture.mmd) | Diagrama Mermaid |
| [input.json](./input.json) | Payload de exemplo |

## Ativação / Publicação

1. Criar Function Group `Z_HTTP_BAPI_HYB_WORKER` e o FM
   `Z_HTTP_BAPI_HYB_WORKER` — marcar como **Remote-Enabled Module** na
   aba *Attributes* do SE37.
2. Ativar as classes na ordem: `zcl_http_bapi_hyb_json_parser` →
   `zcl_http_bapi_hyb_lex_splitter` → `zcl_http_bapi_hyb_caller` →
   `zcl_http_bapi_hyb_dispatcher` → `zcl_http_bapi_hyb`.
3. Rodar os unit tests (`ltcl_hyb_test`).
4. Criar HTTP Service (Service Binding) apontando para
   `zcl_http_bapi_hyb`.
5. Opcional: definir server group RFC para paralelismo (`RZ12`).

## Clean Core

`FUNCTION_IMPORT_INTERFACE`, `CALL FUNCTION <dyn>` e as BAPIs clássicas
**não** são released para ABAP Cloud público. Este runner é a mesma
"razão de existir" do `rap-bapi-hybrid`: on-premise, embedded Steampunk
ou private cloud. Para Cloud público a recomendação continua sendo
usar API-based extensibility com o serviço concreto liberado
(ex.: `API_PURCHASEORDER_PROCESS_SRV`).
