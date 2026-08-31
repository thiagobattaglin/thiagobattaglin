# HTTP API — BAPI Integration **v1.1** (Clean Core refactoring)

Suggested SAP package: `ZPKG_BAPI_INTEGRATION`.

The service provides BAPI metadata discovery and parallel batch execution.

Serviço HTTP com dois verbos:

- **GET** → devolve o metadata DDIC da BAPI (mesmo shape do v1.0).
- **POST** → recebe o layout de [`input.json`](./input.json) e executa a BAPI
  dinamicamente para N documentos em paralelo.

## Endpoints

```
GET  /sap/bc/http/sap/zbapi_integration?bapi_name=BAPI_PO_CREATE1
POST /sap/bc/http/sap/zbapi_integration         Content-Type: application/json
```

## POST — regras de default

| Tag | Papel |
|---|---|
| `bapi_name` | BAPI que será chamada |
| `documents` | Array de documentos a criar |
| `documents[].heders_values` | Estruturas IMPORTING/CHANGING + valores |
| `documents[].items_values`  | Tabelas (TABLES) + valores |
| `worker_rows` | Máximo de documentos por worker. **Vazio / `<= 0` ⇒ 5000** |
| `worker_threads` | Cap máximo de workers paralelos. **Vazio / `<= 0` ⇒ sem cap** |
| `mode` | `"async"` (default) ou `"sync"` |

Regra (`zcl_bapi_integration_dispatch=>resolve_workers`):

```
wr      = worker_rows if > 0 else 5000
needed  = ceil(total_docs / wr)
workers = min(needed, worker_threads) if worker_threads > 0 else needed
```

## Arquitetura

Todo o núcleo depende **apenas** de APIs released em ABAP Cloud e das duas
interfaces do projeto. O acoplamento com APIs legadas fica isolado em
**dois adapters explicitamente marcados** como não-Clean-Core.

```
zcl_http_bapi_integration         <-- composition root (único ponto de wire-up)
        |
        v
zcl_bapi_integration_builder      <-- usa zif_bapi_integration_intro
zcl_bapi_integration_dispatch     <-- xco_cp_json + cl_abap_parallel
        |
        v
zcl_bapi_integration_parallel <-- if_abap_parallel~do
        |
        v
zcl_bapi_integration_caller       <-- usa zif_bapi_integration_executor

  zif_bapi_integration_intro  ←→  zcl_bapi_integration_intro  (legacy)
  zif_bapi_integration_executor      ←→  zcl_bapi_integration_exec   (legacy)
```

## APIs released usadas no núcleo

| API | Onde | Status |
|---|---|---|
| `if_http_service_extension`, `if_web_http_*` | handler | ✅ released |
| `xco_cp_json=>data->from_string / from_abap` | dispatch + builder | ✅ released |
| `EXPORT/IMPORT TO/FROM DATA BUFFER` | dispatch ↔ provider | ✅ released |
| `cl_abap_parallel=>run_inline` + `if_abap_parallel` | paralelismo | ✅ released |
| `cl_abap_typedescr` / `cl_abap_tabledescr` | executor legacy | ✅ released |
| `CREATE DATA TYPE HANDLE`, `ASSIGN COMPONENT` | executor legacy | ✅ released |
| `escape( format = cl_abap_format=>e_json_string )` | handler | ✅ released |

## APIs NÃO-released (isoladas nos adapters legacy)

| API | Onde | Como isolamos |
|---|---|---|
| `FUNCTION_IMPORT_INTERFACE` | `zcl_bapi_integration_intro`, `zcl_bapi_integration_exec` | atrás da interface `zif_bapi_integration_intro` e do executor legacy |
| `DDIF_FIELDINFO_GET` | `zcl_bapi_integration_intro` | idem |
| `CALL FUNCTION dyn_name PARAMETER-TABLE` | `zcl_bapi_integration_exec` | atrás de `zif_bapi_integration_executor` |
| `BAPI_TRANSACTION_COMMIT/_ROLLBACK` | `zcl_bapi_integration_exec` | idem |

O composition root [`zcl_http_bapi_integration`](./zcl_http_bapi_integration.clas.abap)
é o **único** arquivo que faz `NEW zcl_bapi_integration_intro( )`.
O provider paralelo [`zcl_bapi_integration_parallel`](./zcl_bapi_integration_parallel.clas.abap)
é o **único** arquivo que faz `NEW zcl_bapi_integration_exec( ... )`.

Para migrar 100% para ABAP Cloud puro basta trocar esses dois pontos por
implementações baseadas em whitelist de BAPIs released + RAP/EML.

## Paralelismo: `cl_abap_parallel` no lugar de aRFC

O v1.1 original usava `CALL FUNCTION 'Z_...' STARTING NEW TASK ... DESTINATION
IN GROUP DEFAULT` (aRFC clássico) e um Function Group ABAP para o worker.
Nada disso é released em Cloud.

Substituição:

- Function Group **removido** ([z_bapi_integration_worker.fugr.abap](./z_bapi_integration_worker.fugr.abap) fica como stub deprecated).
- `cl_abap_parallel=>run_inline` (released) faz o fan-out.
- Provider = classe implementando `if_abap_parallel~do` (recebe `p_in TYPE xstring`, retorna `p_out TYPE xstring`).
- Transporte binário via `EXPORT/IMPORT TO/FROM DATA BUFFER`, sem JSON no meio.

`run_inline` bloqueia a thread HTTP até todos os workers finalizarem.
Isso vale para **ambos** os modos (`sync` e `async` — a diferença fica
só no status code de retorno). Para fire-and-forget verdadeiro no
padrão Clean Core, envelopar essa chamada em um bgMC unit
(`cl_bgmc_process_factory`) ou bgRFC — fora do escopo deste refactor.

## JSON: `xco_cp_json` no lugar de `/ui2/cl_json`

- `zcl_bapi_integration_dispatch=>parse_request` usa `xco_cp_json=>data->from_string( )->write_to( )`.
- `zcl_bapi_integration_dispatch=>build_response` e `zcl_bapi_integration_builder=>build_json` usam `xco_cp_json=>data->from_abap( )->to_string( )`.

`/ui2/cl_json` sumiu do código.

## Commit / Rollback

Ainda por documento, dentro do executor legacy. Em versão puramente Cloud
seria substituído por `COMMIT ENTITIES` da RAP.

## Componentes

### Núcleo Clean Core
| Arquivo | Papel |
|---|---|
| [zcl_http_bapi_integration.clas.abap](./zcl_http_bapi_integration.clas.abap) | Handler HTTP + composition root |
| [zcl_bapi_integration_dispatch.clas.abap](./zcl_bapi_integration_dispatch.clas.abap) | Parse + defaults + split + `cl_abap_parallel` |
| [zcl_bapi_integration_parallel.clas.abap](./zcl_bapi_integration_parallel.clas.abap) | Provider `if_abap_parallel~do` |
| [zcl_bapi_integration_caller.clas.abap](./zcl_bapi_integration_caller.clas.abap) | Orquestrador (usa só interface) |
| [zcl_bapi_integration_builder.clas.abap](./zcl_bapi_integration_builder.clas.abap) | Metadata JSON builder (usa só interface) |

### Interfaces (Clean Core)
| Arquivo | Papel |
|---|---|
| [zif_bapi_integration_intro.intf.abap](./zif_bapi_integration_intro.intf.abap) | Contrato de descoberta de metadata |
| [zif_bapi_integration_executor.intf.abap](./zif_bapi_integration_executor.intf.abap) | Contrato de execução de 1 documento |

### Legacy Adapters (NÃO Clean Core)
| Arquivo | Papel |
|---|---|
| [zcl_bapi_integration_intro.clas.abap](./zcl_bapi_integration_intro.clas.abap) | Introspecção via `FUNCTION_IMPORT_INTERFACE` + `DDIF_FIELDINFO_GET` |
| [zcl_bapi_integration_exec.clas.abap](./zcl_bapi_integration_exec.clas.abap) | `CALL FUNCTION` dinâmico + BAPI commit/rollback |

### Auxiliares
| Arquivo | Papel |
|---|---|
| [input.json](./input.json) | Exemplo POST |
| [metadata-ex.json](./metadata-ex.json) | Exemplo GET |
| [architecture.mmd](./architecture.mmd) | Diagrama |
| [z_bapi_integration_worker.fugr.abap](./z_bapi_integration_worker.fugr.abap) | **DEPRECATED** (substituído por `cl_abap_parallel`) |

## Ativação / Publicação

1. Ativar interfaces: `zif_bapi_integration_intro`, `zif_bapi_integration_executor`.
2. Ativar adapters legacy: `zcl_bapi_integration_intro`, `zcl_bapi_integration_exec`.
3. Ativar núcleo: `zcl_bapi_integration_caller`, `zcl_bapi_integration_builder`, `zcl_bapi_integration_parallel`, `zcl_bapi_integration_dispatch`.
4. Ativar handler: `zcl_http_bapi_integration`.
5. Criar HTTP Service (SICF ou ADT → New → HTTP Service) apontando para `ZCL_HTTP_BAPI_INTEGRATION`.
6. Liberar em `UCON_HTTP_SERVICES` (Allowlist Scenario).
7. Configurar server group RFC para paralelismo (`RZ12`) — `cl_abap_parallel` usa o server group `default` por padrão.

## Path para 100 % ABAP Cloud puro

O que ainda impede: qualquer BAPI dinâmica clássica com `CALL FUNCTION dyn`.
Para ir até o fim:

1. Adicionar uma classe `zcl_bapi_integration_cloud_intro` implementando
   `zif_bapi_integration_intro` usando **whitelist de BAPIs released**
   (lista de nomes → nomes de estrutura/table DDIC) resolvida com
   `cl_abap_typedescr=>describe_by_name`.
2. Adicionar `zcl_bapi_integration_cloud_exec` implementando
   `zif_bapi_integration_executor` com **static** `CALL FUNCTION 'BAPI_XXX'`
   por BAPI whitelisted **ou** delegar para RAP/EML (`MODIFY ENTITIES ...
   FROM ...` + `COMMIT ENTITIES`).
3. Trocar no `zcl_http_bapi_integration=>build_introspector` e no
   `zcl_bapi_integration_parallel~do`.

Nenhum outro arquivo precisa mudar.

