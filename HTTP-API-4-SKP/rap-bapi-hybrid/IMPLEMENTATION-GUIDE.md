# Guia de Implementação — RAP Hybrid BAPI Runner

Passo a passo para publicar o serviço **RAP/OData V4 Hybrid** em um
sistema **SAP S/4HANA on-premise** (SAP_BASIS 7.57+) ou **Embedded
Steampunk / Private Cloud**. Este projeto substitui `STARTING NEW TASK`
por **bgPF** e usa exclusivamente o **parser kernel CTF** — não usa
`/ui2/cl_json` em nenhum lugar.

> Versão em inglês: [IMPLEMENTATION-GUIDE-EN.md](./IMPLEMENTATION-GUIDE-EN.md)

---

## Sumário

1. [Pré-requisitos](#1-pré-requisitos)
2. [Diferenças vs. rap-bapi-dynamic](#2-diferenças-vs-rap-bapi-dynamic)
3. [Ordem de criação dos objetos](#3-ordem-de-criação-dos-objetos)
4. [Passo 1 — Pacote e transporte](#4-passo-1--pacote-e-transporte)
5. [Passo 2 — Tabela de persistência](#5-passo-2--tabela-de-persistência)
6. [Passo 3 — Abstract entities](#6-passo-3--abstract-entities)
7. [Passo 4 — CDS Root + Projection + Metadata Extension](#7-passo-4--cds-root--projection--metadata-extension)
8. [Passo 5 — Behavior Definitions](#8-passo-5--behavior-definitions)
9. [Passo 6 — Behavior Pool + Handler local](#9-passo-6--behavior-pool--handler-local)
10. [Passo 7 — Classes auxiliares](#10-passo-7--classes-auxiliares)
11. [Passo 8 — Service Definition + Service Binding](#11-passo-8--service-definition--service-binding)
12. [Passo 9 — bgPF: sem Server Group RFC](#12-passo-9--bgpf-sem-server-group-rfc)
13. [Passo 10 — Autorizações](#13-passo-10--autorizações)
14. [Passo 11 — Testes (ATC, ADT Preview, Postman)](#14-passo-11--testes-atc-adt-preview-postman)
15. [Anexo A — Payload OData completo](#15-anexo-a--payload-odata-completo)
16. [Anexo B — Troubleshooting](#16-anexo-b--troubleshooting)

---

## 1. Pré-requisitos

| Item | Requisito |
|---|---|
| Release | SAP_BASIS **7.57+** (bgPF GA) ou Embedded Steampunk / Private Cloud |
| ADT | Eclipse com ABAP Development Tools |
| JSON parser | **zero dependência de `/ui2/cl_json`** — usa `cl_sxml_string_reader` + `CALL TRANSFORMATION id` (kernel, released) |
| bgPF | `cl_bgmc_process_factory` disponível (`SAP_ABA >= 75C`) |
| BAPI alvo | Existente e RFC-enabled (ex.: `BAPI_PO_CREATE1`) |
| Server group RFC | **Não necessário** — bgPF usa pool próprio de work processes |
| Autorizações | `S_DEVELOP`, `S_RFC`, `S_SERVICE`, `S_TCODE` (SICF, SM59) |

---

## 2. Diferenças vs. rap-bapi-dynamic

| Aspecto | rap-bapi-dynamic | **rap-bapi-hybrid** |
|---|---|---|
| Async dispatch | `STARTING NEW TASK DESTINATION IN GROUP DEFAULT` | **bgPF** (`cl_bgmc_process_factory`) |
| JSON parser | `/ui2/cl_json` | **`cl_sxml_string_reader` + CTF id** (kernel, released) |
| Split de `documents[]` | loop completo via RTTI | **lexical O(strlen)** (`zcl_bapi_hyb_lex_splitter`) |
| Timestamps | `DEC 21,7` | **`UTCLONG`** |
| Worker FM | Function Group + `STARTING NEW TASK` | **`zcl_bapi_hyb_worker_op`** (`if_bgmc_op_single_tx_uncontrolled`) |
| GET metadata | ausente | **`static function GetMetadata`** |

Não há Function Group nem Function Module no projeto hybrid.

---

## 3. Ordem de criação dos objetos

```
ZBAPI_HYB_RUN (tabela)
  └─► ZD_BAPI_HYB_IN / ZD_BAPI_HYB_OUT / ZD_BAPI_HYB_META  (abstract entities)
        └─► ZR_BAPI_HYB_RUN (CDS root)
              └─► ZC_BAPI_HYB_RUN (CDS projection)
                    └─► ZC_BAPI_HYB_RUN (metadata extension)
                          └─► ZR_BAPI_HYB_RUN.bdef + ZC_BAPI_HYB_RUN.bdef (behavior definitions)
                                └─► ZCL_BAPI_HYB_JSON_PARSER   (parser kernel CTF)
                                      └─► ZCL_BAPI_HYB_LEX_SPLITTER  (split lexical)
                                            └─► ZCL_BAPI_HYB_DISPATCHER (dispatcher + bgPF)
                                                  └─► ZCL_BAPI_HYB_CALLER   (caller BAPI)
                                                        └─► ZCL_BAPI_HYB_WORKER_OP (bgPF operation)
                                                              └─► ZBP_R_BAPI_HYB_RUN (behavior pool)
                                                                    └─► ZUI_BAPI_HYB_RUN_O4 (srvd + srvb)
```

Ativar sempre de baixo para cima.

---

## 4. Passo 1 — Pacote e transporte

1. `SE80` → **Create → Package** → `ZBAPI_HYB_RAP`
   - Software Component: namespace do cliente
   - Application component: `CA-GTF`
2. Criar Transport Request vinculando todos os objetos.

Para protótipo local: usar `$TMP`.

---

## 5. Passo 2 — Tabela de persistência

`SE11` → Database Table → `ZBAPI_HYB_RUN`
(ver [`zbapi_hyb_run.tabl.xml`](./zbapi_hyb_run.tabl.xml)).

| Campo | Tipo DDIC | Obs. |
|---|---|---|
| `CLIENT` (key) | `CLNT` | Mandante |
| `RUN_UUID` (key) | `RAW(16)` | `SYSUUID_X16` |
| `BAPI_NAME` | `CHAR(30)` | |
| `EXEC_MODE` | `CHAR(10)` | `async` / `sync` |
| `KIND` | `CHAR(10)` | `chunk` / `bulk` |
| `WORKER_THREADS` | `INT4` | |
| `WORKER_ROWS` | `INT4` | |
| `ACCEPTED` | `INT4` | Docs recebidos |
| `WORKERS` | `INT4` | Processos bgPF criados |
| `STATUS` | `CHAR(10)` | `DISPATCHED` / `FAILED` |
| `ERROR_TEXT` | `CHAR(220)` | |
| `CREATED_BY` | `CHAR(12)` | |
| `CREATED_AT` | **`UTCLONG`** | Não usar `DEC 21,7` |
| `LAST_CHANGED_BY` | `CHAR(12)` | |
| `LAST_CHANGED_AT` | **`UTCLONG`** | |
| `LOCAL_LAST_CHANGED_AT` | **`UTCLONG`** | ETag otimista |

> **Atenção:** os três campos de timestamp usam `UTCLONG` — tipo released
> para cloud. `DEC 21,7` não funciona com `@Semantics.systemDateTime.*`.

Delivery class `A`, Enhancement Category *Can Be Enhanced (Deep)*. Ativar.

---

## 6. Passo 3 — Abstract entities

ADT → New Data Definition → selecionar template *Abstract Entity*.

| Objeto | Arquivo fonte |
|---|---|
| `ZD_BAPI_HYB_IN` | [`zd_bapi_hyb_in.ddls.asddls`](./zd_bapi_hyb_in.ddls.asddls) |
| `ZD_BAPI_HYB_OUT` | [`zd_bapi_hyb_out.ddls.asddls`](./zd_bapi_hyb_out.ddls.asddls) |
| `ZD_BAPI_HYB_META` | [`zd_bapi_hyb_meta.ddls.asddls`](./zd_bapi_hyb_meta.ddls.asddls) |

Ativar as três antes de continuar.

> `ZD_BAPI_HYB_META` é o tipo de retorno da **static function `GetMetadata`**
> (GET-callable). Sem ela o behavior definition não ativa.

---

## 7. Passo 4 — CDS Root + Projection + Metadata Extension

1. ADT → New Data Definition → `ZR_BAPI_HYB_RUN`
   Colar [`zr_bapi_hyb_run.ddls.asddls`](./zr_bapi_hyb_run.ddls.asddls). Ativar.

2. ADT → New Data Definition → `ZC_BAPI_HYB_RUN`
   Colar [`zc_bapi_hyb_run.ddls.asddls`](./zc_bapi_hyb_run.ddls.asddls). Ativar.

3. ADT → New Metadata Extension → `ZC_BAPI_HYB_RUN`
   Colar [`zc_bapi_hyb_run.mde.asmde`](./zc_bapi_hyb_run.mde.asmde). Ativar.

---

## 8. Passo 5 — Behavior Definitions

1. Na `ZR_BAPI_HYB_RUN` → botão direito → **New Behavior Definition**
   Colar [`zr_bapi_hyb_run.bdef.asbdef`](./zr_bapi_hyb_run.bdef.asbdef). Ativar.

2. Na `ZC_BAPI_HYB_RUN` → botão direito → **New Behavior Definition** (Projection)
   Colar [`zc_bapi_hyb_run.bdef.asbdef`](./zc_bapi_hyb_run.bdef.asbdef). Ativar.

O bdef raiz declara:
- `static action Submit` → POST (modificação) → parâmetro `ZD_BAPI_HYB_IN`, resultado `ZD_BAPI_HYB_OUT`
- `static function GetMetadata` → GET (leitura) → resultado `ZD_BAPI_HYB_META`

A projeção usa `use action Submit` e `use function GetMetadata`.

A raiz vai reclamar que `zbp_r_bapi_hyb_run` ainda não existe — **normal**, será criada no próximo passo.

---

## 9. Passo 6 — Behavior Pool + Handler local

1. ADT → New ABAP Class → `ZBP_R_BAPI_HYB_RUN`
   Colar [`zbp_r_bapi_hyb_run.clas.abap`](./zbp_r_bapi_hyb_run.clas.abap).

2. No editor da classe → aba **Local Types**
   Colar [`zbp_r_bapi_hyb_run.clas.locals_imp.abap`](./zbp_r_bapi_hyb_run.clas.locals_imp.abap).

O handler `lhc_bapi_hyb_run` implementa:
- `submit FOR MODIFY ... FOR ACTION BapiRun~Submit` — POST
- `get_metadata FOR READ ... FOR FUNCTION BapiRun~GetMetadata` — GET

**Ainda não ativar** — depende das classes auxiliares abaixo.

---

## 10. Passo 7 — Classes auxiliares

Criar e ativar na seguinte ordem:

### 10.1 `ZCL_BAPI_HYB_JSON_PARSER`

[`zcl_bapi_hyb_json_parser.clas.abap`](./zcl_bapi_hyb_json_parser.clas.abap)

Único ponto de JSON ↔ ABAP. Usa `cl_sxml_string_reader` +
`CALL TRANSFORMATION id` (kernel, released).  
Não instancia `/ui2/cl_json` em nenhum momento.

### 10.2 `ZCL_BAPI_HYB_LEX_SPLITTER`

[`zcl_bapi_hyb_lex_splitter.clas.abap`](./zcl_bapi_hyb_lex_splitter.clas.abap)

Split lexical O(strlen) do array `documents[]`. Não faz deserialize do
payload completo. Retorna `string_table` com um chunk JSON por worker.

### 10.3 `ZCL_BAPI_HYB_DISPATCHER`

[`zcl_bapi_hyb_dispatcher.clas.abap`](./zcl_bapi_hyb_dispatcher.clas.abap)
(classes de teste: [`zcl_bapi_hyb_dispatcher.clas.testclasses.abap`](./zcl_bapi_hyb_dispatcher.clas.testclasses.abap))

Lê somente o cabeçalho do payload via trim + CTF. Delega split ao
`zcl_bapi_hyb_lex_splitter` e dispatch ao `cl_bgmc_process_factory`.

O método `dispatch_chunks` é **protegido** e pode ser substituído por
subclasse nos testes — ver `ltc_hyb_stub` no arquivo de testes.

### 10.4 `ZCL_BAPI_HYB_CALLER`

[`zcl_bapi_hyb_caller.clas.abap`](./zcl_bapi_hyb_caller.clas.abap)

Deserialize o chunk (CTF id), introspecta a BAPI via
`FUNCTION_IMPORT_INTERFACE` + RTTI, chama `CALL FUNCTION <dyn>` com
`PARAMETER-TABLE` e decide `BAPI_TRANSACTION_COMMIT` ou
`BAPI_TRANSACTION_ROLLBACK` por documento.

### 10.5 `ZCL_BAPI_HYB_WORKER_OP`

[`zcl_bapi_hyb_worker_op.clas.abap`](./zcl_bapi_hyb_worker_op.clas.abap)

Unidade de execução do worker. Expõe o método público `execute()` que
instancia `zcl_bapi_hyb_caller` e processa o chunk.

> **bgPF (caminho de upgrade):** quando o sistema tiver
> `IF_BGMC_OP_SINGLE_TX_UNCONTROLLED` disponível (SAP_BASIS 7.57+ /
> SAP BTP ABAP 2108+), basta re-declarar
> `INTERFACES if_bgmc_op_single_tx_uncontrolled`, renomear `execute`
> para `if_bgmc_op_single_tx_uncontrolled~execute` e re-habilitar o
> agendamento bgPF em `dispatch_chunks` do dispatcher. Nenhuma outra
> classe muda.

Atualmente o dispatcher chama `execute()` diretamente (síncrono) para
evitar a dependência do release.

Após ativar todas as classes, **ativar** `ZBP_R_BAPI_HYB_RUN`.

---

## 11. Passo 8 — Service Definition + Service Binding

1. Na `ZC_BAPI_HYB_RUN` → botão direito → **New Service Definition** →
   `ZUI_BAPI_HYB_RUN_O4`
   Colar [`zui_bapi_hyb_run_o4.srvd.asrvd`](./zui_bapi_hyb_run_o4.srvd.asrvd). Ativar.

2. Sobre a Service Definition → botão direito → **New Service Binding** →
   `ZUI_BAPI_HYB_RUN_O4`, **binding type** = `OData V4 – Web API`
   Ver [`zui_bapi_hyb_run_o4.srvb.srvb`](./zui_bapi_hyb_run_o4.srvb.srvb) como referência.
   Ativar.

3. No editor do Service Binding → botão **Activate/Publish**.

URL base:

```
/sap/opu/odata4/sap/zui_bapi_hyb_run_o4/srvd_a2x/sap/zui_bapi_hyb_run_o4/0001/
```

### On-premise — registrar via STC01

```
STC01 → SAP_GATEWAY_ACTIVATE_ODATA_SERV → Technical Name: ZUI_BAPI_HYB_RUN_O4
```

### Steampunk / ABAP Environment

A URL é gerada automaticamente ao ativar o binding.

---

## 12. Passo 9 — bgPF: sem Server Group RFC

O dispatch neste projeto **não usa** `STARTING NEW TASK DESTINATION IN GROUP`.
Nenhuma configuração em `RZ12` é necessária.

O bgPF gerencia internamente o pool de processos de background. Para
monitorar execuções pendentes e falhas:

- `SM37` → jobs de background gerados pelo bgPF
- `SBGRFCMON` → monitor de bgRFC (bgPF usa bgRFC internamente)
- `SLG1` / Application Log → se o worker usar `cl_bali_log`

Ajuste a quantidade de work processes *background* (`sm50`) de acordo
com a volumetria esperada.

---

## 13. Passo 10 — Autorizações

Objeto `S_SERVICE` para o OData:

| Campo | Valor |
|---|---|
| `SRV_NAME` | `ZUI_BAPI_HYB_RUN_O4` |
| `SRV_TYPE` | `HT` |
| `SRV_CHECK` | `X` |

Adicionalmente:
- `S_RFC` para as BAPIs alvo (ex.: `BAPI_PO_CREATE1`, `BAPI_TRANSACTION_COMMIT`)
- Autorizações de negócio específicas (ex.: `M_BEST_EKO` para Purchase Orders)
- `S_BGMC` (ou equivalente) se o sistema exigir autorização para criação de processos bgPF

---

## 14. Passo 11 — Testes (ATC, ADT Preview, Postman)

### 14.1 Unit tests

`Ctrl+Shift+F10` na classe `ZCL_BAPI_HYB_DISPATCHER`. Os testes em
[`zcl_bapi_hyb_dispatcher.clas.testclasses.abap`](./zcl_bapi_hyb_dispatcher.clas.testclasses.abap)
cobrem:

| Teste | O que valida |
|---|---|
| `defaults` | `normalize_positive` retorna default quando `iv_value = 0` |
| `calc_workers` | `calculate_workers(250 docs / 100 rows / 4 max)` = 3 |
| `parse_header_only` | Header extraído corretamente sem deserializar `documents[]` |
| `parse_header_ignores_arrays` | Arrays antes de scalars não corrompem o trim |
| `lex_split_basic` | 3 documentos simples geram 3 chunks |
| `lex_split_nested` | Documentos com arrays aninhados não quebram o split |
| `dispatch_chunk_mode` | `kind=chunk` → 1 chunk, 1 worker |
| `dispatch_bulk_splits` | `kind=bulk` → N chunks via `ltc_hyb_stub` |

### 14.2 Service Binding preview

Botão *Preview* no editor do Service Binding → Fiori Launchpad com
List Report da entidade `BapiRun`.

### 14.3 GET metadata

```http
GET /sap/opu/odata4/sap/zui_bapi_hyb_run_o4/srvd_a2x/sap/zui_bapi_hyb_run_o4/0001/BapiRun/com.sap.gateway.srvd_a2x.zui_bapi_hyb_run_o4.v0001.GetMetadata()
```

Resposta esperada:

```json
{
  "value": [{
    "ServiceName":    "ZUI_BAPI_HYB_RUN_O4",
    "ServiceVersion": "0001",
    "OdataVersion":   "V4",
    "Endpoint":       "/sap/opu/odata4/sap/zui_bapi_hyb_run_o4/...",
    "DispatchEngine": "bgPF",
    "DefaultWorkers": 4,
    "DefaultRows":    100,
    "SupportedKinds": "chunk|bulk",
    "SupportedModes": "async|sync",
    "PayloadFormat":  "JSON: { bapi_name, mode, kind, worker_threads, worker_rows, documents:[...] }",
    "Description":    "Hybrid BAPI Runner - streaming header parse, lexical split, bgPF dispatch, kernel CTF worker deserialize."
  }]
}
```

### 14.4 POST submit (Postman / curl)

**Fetch CSRF token:**

```http
HEAD /sap/opu/odata4/sap/zui_bapi_hyb_run_o4/srvd_a2x/sap/zui_bapi_hyb_run_o4/0001/
X-CSRF-Token: Fetch
```

**Chamar a action Submit:**

```http
POST /sap/opu/odata4/sap/zui_bapi_hyb_run_o4/srvd_a2x/sap/zui_bapi_hyb_run_o4/0001/BapiRun/com.sap.gateway.srvd_a2x.zui_bapi_hyb_run_o4.v0001.Submit
X-CSRF-Token: <token>
Content-Type: application/json

{ "Payload": "{\"bapi_name\":\"BAPI_PO_CREATE1\",\"mode\":\"async\",\"kind\":\"bulk\",\"worker_threads\":4,\"worker_rows\":100,\"documents\":[...]}" }
```

Resposta `202 Accepted`:

```json
{
  "value": [{
    "RunUuid":  "...",
    "BapiName": "BAPI_PO_CREATE1",
    "Accepted": 1,
    "Workers":  1,
    "ExecMode": "async",
    "Kind":     "bulk"
  }]
}
```

Conferir linha gravada: `SE16 → ZBAPI_HYB_RUN` ou
`GET BapiRun('<RunUuid>')`.

---

## 15. Anexo A — Payload OData completo

Ver [`input.json`](./input.json). O campo `Payload` deve ser enviado
como **string JSON escapada**, não como objeto.

Serializar com `jq`:

```bash
jq -c '.' input.json | jq -Rs '{ Payload: . }'
```

Ou, para OData envelope:

```bash
jq -c '.' input.json | jq -Rs '{ "Payload": . }'
```

---

## 16. Anexo B — Troubleshooting

| Sintoma | Causa provável | Ação |
|---|---|---|
| `Action Submit not found` | Binding não republicado após alterar bdef | Reativar/Publish o Service Binding |
| `Function GetMetadata not found` | `use function GetMetadata` ausente no bdef de projeção | Verificar `zc_bapi_hyb_run.bdef.asbdef` |
| `Payload is empty` | Client enviou objeto, não string | Serializar `Payload` como string escapada |
| `bapi_name is mandatory` | JSON interno não contém `bapi_name` | Validar payload antes de chamar |
| `cx_transformation_error` no parser | JSON malformado ou encoding errado | Validar com `jq .` antes de enviar |
| Processo bgPF não executa | `save_for_execution` sem `COMMIT WORK` | O commit é feito pelo framework RAP ao final do save; não adicionar `COMMIT WORK` manual |
| Worker falha silenciosamente | Exceção `cx_root` capturada no `execute()` | Adicionar log via `cl_bali_log` dentro do `catch` do worker |
| Timestamps com zero | Campos `CREATED_AT` / `LAST_CHANGED_AT` não mapeados | Verificar `@Semantics.systemDateTime.*` nas views e mapping no bdef |
| `UTCLONG` não aceito | Release < 7.54 | Upgrade necessário; não usar `DEC 21,7` como fallback em cloud |
| `403` no OData | `S_SERVICE` faltando | Conceder autorização `HT / ZUI_BAPI_HYB_RUN_O4` |
| BAPI executa, nada persiste | RETURN traz `E/A/X` → rollback correto | Ler `ZBAPI_HYB_RUN` + inspecionar mensagens do RETURN via log |
| `FUNCTION_IMPORT_INTERFACE` falha | BAPI não existe ou não é RFC-enabled | Verificar `SE37` / `SM59` |
