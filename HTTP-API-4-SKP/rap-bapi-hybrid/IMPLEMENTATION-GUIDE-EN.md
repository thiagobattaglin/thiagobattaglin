# Implementation Guide — RAP Hybrid BAPI Runner

Step-by-step instructions to publish the **RAP/OData V4 Hybrid** service on
**SAP S/4HANA on-premise** (SAP_BASIS 7.57+) or **Embedded Steampunk / Private
Cloud**. This project replaces `STARTING NEW TASK` with **bgPF** and exclusively
uses the **kernel CTF parser** — `/ui2/cl_json` is not used anywhere.

> Versão em português: [IMPLEMENTATION-GUIDE.md](./IMPLEMENTATION-GUIDE.md)

---

## Table of Contents

- [Implementation Guide — RAP Hybrid BAPI Runner](#implementation-guide--rap-hybrid-bapi-runner)
  - [Table of Contents](#table-of-contents)
  - [1. Prerequisites](#1-prerequisites)
  - [2. Differences vs. rap-bapi-dynamic](#2-differences-vs-rap-bapi-dynamic)
  - [3. Object creation order](#3-object-creation-order)
  - [4. Step 1 — Package and transport](#4-step-1--package-and-transport)
  - [5. Step 2 — Persistence table](#5-step-2--persistence-table)
  - [6. Step 3 — Abstract entities](#6-step-3--abstract-entities)
  - [7. Step 4 — CDS Root + Projection + Metadata Extension](#7-step-4--cds-root--projection--metadata-extension)
  - [8. Step 5 — Behavior Definitions](#8-step-5--behavior-definitions)
  - [9. Step 6 — Behavior Pool + local handler](#9-step-6--behavior-pool--local-handler)
  - [10. Step 7 — Helper classes](#10-step-7--helper-classes)
    - [10.1 `ZCL_BAPI_HYB_JSON_PARSER`](#101-zcl_bapi_hyb_json_parser)
    - [10.2 `ZCL_BAPI_HYB_LEX_SPLITTER`](#102-zcl_bapi_hyb_lex_splitter)
    - [10.3 `ZCL_BAPI_HYB_DISPATCHER`](#103-zcl_bapi_hyb_dispatcher)
    - [10.4 `ZCL_BAPI_HYB_CALLER`](#104-zcl_bapi_hyb_caller)
    - [10.5 `ZCL_BAPI_HYB_WORKER_OP`](#105-zcl_bapi_hyb_worker_op)
  - [11. Step 8 — Service Definition + Service Binding](#11-step-8--service-definition--service-binding)
    - [On-premise — register via STC01](#on-premise--register-via-stc01)
    - [Steampunk / ABAP Environment](#steampunk--abap-environment)
  - [12. Step 9 — bgPF: no RFC server group needed](#12-step-9--bgpf-no-rfc-server-group-needed)
  - [13. Step 10 — Authorizations](#13-step-10--authorizations)
  - [14. Step 11 — Testing (ATC, ADT Preview, Postman)](#14-step-11--testing-atc-adt-preview-postman)
    - [14.1 Unit tests](#141-unit-tests)
    - [14.2 Service Binding preview](#142-service-binding-preview)
    - [14.3 GET metadata](#143-get-metadata)
    - [14.4 POST submit (Postman / curl)](#144-post-submit-postman--curl)
  - [15. Appendix A — Full OData payload](#15-appendix-a--full-odata-payload)
  - [16. Appendix B — Troubleshooting](#16-appendix-b--troubleshooting)

---

## 1. Prerequisites

| Item | Requirement |
|---|---|
| Release | SAP_BASIS **7.57+** (bgPF GA) or Embedded Steampunk / Private Cloud |
| ADT | Eclipse with ABAP Development Tools |
| JSON parser | **no dependency on `/ui2/cl_json`** — uses `cl_sxml_string_reader` + `CALL TRANSFORMATION id` (kernel, released) |
| bgPF | `cl_bgmc_process_factory` available (`SAP_ABA >= 75C`) |
| Target BAPI | Must exist and be RFC-enabled (e.g. `BAPI_PO_CREATE1`) |
| RFC server group | **Not required** — bgPF manages its own work process pool |
| Authorizations | `S_DEVELOP`, `S_RFC`, `S_SERVICE`, `S_TCODE` (SICF, SM59) |

---

## 2. Differences vs. rap-bapi-dynamic

| Aspect | rap-bapi-dynamic | **rap-bapi-hybrid** |
|---|---|---|
| Async dispatch | `STARTING NEW TASK DESTINATION IN GROUP DEFAULT` | **bgPF** (`cl_bgmc_process_factory`) |
| JSON parser | `/ui2/cl_json` | **`cl_sxml_string_reader` + CTF id** (kernel, released) |
| `documents[]` split | full loop via RTTI | **lexical O(strlen)** (`zcl_bapi_hyb_lex_splitter`) |
| Timestamps | `DEC 21,7` | **`UTCLONG`** |
| Worker FM | Function Group + `STARTING NEW TASK` | **`zcl_bapi_hyb_worker_op`** (`if_bgmc_op_single_tx_uncontrolled`) |
| GET metadata | absent | **`static function GetMetadata parameter ZD_BAPI_HYB_META_IN`** (dynamic introspection via `FUNCTION_IMPORT_INTERFACE` + `DDIF_FIELDINFO_GET`) |

There is no Function Group or Function Module in the hybrid project.

---

## 3. Object creation order

```
ZBAPI_HYB_RUN (table)
  └─► ZD_BAPI_HYB_IN / ZD_BAPI_HYB_OUT /
      ZD_BAPI_HYB_META_IN / ZD_BAPI_HYB_META            (abstract entities)
        └─► ZR_BAPI_HYB_RUN (CDS root)
              └─► ZC_BAPI_HYB_RUN (CDS projection)
                    └─► ZC_BAPI_HYB_RUN (metadata extension)
                          └─► ZR_BAPI_HYB_RUN.bdef + ZC_BAPI_HYB_RUN.bdef (behavior definitions)
                                └─► ZCL_BAPI_HYB_JSON_PARSER    (kernel CTF parser)
                                      └─► ZCL_BAPI_HYB_LEX_SPLITTER  (lexical split)
                                            └─► ZCL_BAPI_HYB_DISPATCHER (dispatcher + bgPF)
                                                  └─► ZCL_BAPI_HYB_CALLER      (BAPI caller)
                                                        └─► ZCL_BAPI_HYB_WORKER_OP    (bgPF operation)
                                                              └─► ZCL_BAPI_HYB_META_BUILDER (BAPI → JSON introspection)
                                                                    └─► ZBP_R_BAPI_HYB_RUN (behavior pool)
                                                                          └─► ZUI_BAPI_HYB_RUN_O4 (srvd + srvb)
```

Always activate bottom-up.

---

## 4. Step 1 — Package and transport

1. `SE80` → **Create → Package** → `ZBAPI_HYB_RAP`
   - Software Component: customer namespace
   - Application component: `CA-GTF`
2. Create a Transport Request to group all objects.

For a quick local prototype: use `$TMP`.

---

## 5. Step 2 — Persistence table

`SE11` → Database Table → `ZBAPI_HYB_RUN`
(see [`zbapi_hyb_run.tabl.xml`](./zbapi_hyb_run.tabl.xml)).

| Field | DDIC type | Notes |
|---|---|---|
| `CLIENT` (key) | `CLNT` | Mandatory client key |
| `RUN_UUID` (key) | `RAW(16)` | `SYSUUID_X16` |
| `BAPI_NAME` | `CHAR(30)` | |
| `EXEC_MODE` | `CHAR(10)` | `async` / `sync` |
| `KIND` | `CHAR(10)` | `chunk` / `bulk` |
| `WORKER_THREADS` | `INT4` | |
| `WORKER_ROWS` | `INT4` | |
| `ACCEPTED` | `INT4` | Documents received |
| `WORKERS` | `INT4` | bgPF processes created |
| `STATUS` | `CHAR(10)` | `DISPATCHED` / `FAILED` |
| `ERROR_TEXT` | `CHAR(220)` | |
| `CREATED_BY` | `CHAR(12)` | |
| `CREATED_AT` | **`UTCLONG`** | Do not use `DEC 21,7` |
| `LAST_CHANGED_BY` | `CHAR(12)` | |
| `LAST_CHANGED_AT` | **`UTCLONG`** | |
| `LOCAL_LAST_CHANGED_AT` | **`UTCLONG`** | Optimistic locking ETag |

> **Important:** all three timestamp fields use `UTCLONG` — the released type
> for cloud. `DEC 21,7` is incompatible with `@Semantics.systemDateTime.*`.

Delivery class `A`, Enhancement Category *Can Be Enhanced (Deep)*. Activate.

---

## 6. Step 3 — Abstract entities

ADT → New Data Definition → select template *Abstract Entity*.

| Object | Role | Source file |
|---|---|---|
| `ZD_BAPI_HYB_IN` | Parameter of the `Submit` action (JSON payload) | [`zd_bapi_hyb_in.ddls.asddls`](./zd_bapi_hyb_in.ddls.asddls) |
| `ZD_BAPI_HYB_OUT` | Result of the `Submit` action | [`zd_bapi_hyb_out.ddls.asddls`](./zd_bapi_hyb_out.ddls.asddls) |
| `ZD_BAPI_HYB_META_IN` | Parameter of the `GetMetadata` function (`BapiName`) | [`zd_bapi_hyb_meta_in.ddls.asddls`](./zd_bapi_hyb_meta_in.ddls.asddls) |
| `ZD_BAPI_HYB_META` | Row of the `[0..*]` result of `GetMetadata` — one record per DDIC field (`BapiName`, `Section`, `ParamName`, `FieldName`, `DocumentIdx`, `ParamOrder`, `FieldOrder`, `FieldType`) | [`zd_bapi_hyb_meta.ddls.asddls`](./zd_bapi_hyb_meta.ddls.asddls) |

Activate all before continuing.

> `ZD_BAPI_HYB_META_IN` is declared as `define root abstract entity` so it
> can be used as a function `parameter` in the BDEF. Without it, the BDEF
> raises `parameter type not found` and the behavior pool won't compile.
>
> `ZD_BAPI_HYB_META` is the row of the OData collection returned by
> `GetMetadata`. `Section = 'H'` maps to `heders_values` (IMPORT with
> DDIC structure); `Section = 'I'` maps to `items_values` (TABLES).
> No `string` field carrying escaped JSON is used.

---

## 7. Step 4 — CDS Root + Projection + Metadata Extension

1. ADT → New Data Definition → `ZR_BAPI_HYB_RUN`
   Paste [`zr_bapi_hyb_run.ddls.asddls`](./zr_bapi_hyb_run.ddls.asddls). Activate.

2. ADT → New Data Definition → `ZC_BAPI_HYB_RUN`
   Paste [`zc_bapi_hyb_run.ddls.asddls`](./zc_bapi_hyb_run.ddls.asddls). Activate.

3. ADT → New Metadata Extension → `ZC_BAPI_HYB_RUN`
   Paste [`zc_bapi_hyb_run.mde.asmde`](./zc_bapi_hyb_run.mde.asmde). Activate.

---

## 8. Step 5 — Behavior Definitions

1. Right-click `ZR_BAPI_HYB_RUN` → **New Behavior Definition**
   Paste [`zr_bapi_hyb_run.bdef.asbdef`](./zr_bapi_hyb_run.bdef.asbdef). Activate.

2. Right-click `ZC_BAPI_HYB_RUN` → **New Behavior Definition** (Projection)
   Paste [`zc_bapi_hyb_run.bdef.asbdef`](./zc_bapi_hyb_run.bdef.asbdef). Activate.

The root bdef declares:
- `static action Submit` → POST (modify) → parameter `ZD_BAPI_HYB_IN`, result `[1] ZD_BAPI_HYB_OUT`
- `static function GetMetadata` → GET (read, with input) → parameter `ZD_BAPI_HYB_META_IN` (`BapiName`), result `[0..*] ZD_BAPI_HYB_META`

The projection uses `use action Submit` and `use function GetMetadata`.

> **Mandatory activation order** (avoids the *`<KEY> does not have a
> component called %PARAM-BAPINAME`* error in the behavior pool):
> 1. Activate `ZD_BAPI_HYB_META_IN` first;
> 2. Activate `ZR_BAPI_HYB_RUN.bdef` — regenerates the derived type of
>    `keys` including `%param-BapiName`;
> 3. Activate `ZC_BAPI_HYB_RUN.bdef`;
> 4. Only then activate the behavior pool `ZBP_R_BAPI_HYB_RUN`.

The root will warn that `zbp_r_bapi_hyb_run` does not yet exist — **expected**,
it will be created in the next step.

---

## 9. Step 6 — Behavior Pool + local handler

1. ADT → New ABAP Class → `ZBP_R_BAPI_HYB_RUN`
   Paste [`zbp_r_bapi_hyb_run.clas.abap`](./zbp_r_bapi_hyb_run.clas.abap).

2. In the class editor → tab **Local Types**
   Paste [`zbp_r_bapi_hyb_run.clas.locals_imp.abap`](./zbp_r_bapi_hyb_run.clas.locals_imp.abap).

The local handler `lhc_bapi_hyb_run` implements:
- `submit FOR MODIFY ... FOR ACTION BapiRun~Submit` — POST
- `get_metadata FOR READ ... FOR FUNCTION BapiRun~GetMetadata` — GET (with `BapiName` in `%param`), iterates over `zcl_bapi_hyb_meta_builder->build( )` and `APPEND`s one row per field into `result`

**Do not activate yet** — depends on the helper classes below, including
`ZCL_BAPI_HYB_META_BUILDER`.

---

## 10. Step 7 — Helper classes

Create and activate in the following order:

### 10.1 `ZCL_BAPI_HYB_JSON_PARSER`

[`zcl_bapi_hyb_json_parser.clas.abap`](./zcl_bapi_hyb_json_parser.clas.abap)

Single point of JSON ↔ ABAP conversion. Uses `cl_sxml_string_reader` +
`CALL TRANSFORMATION id` (kernel, released).  
Does not instantiate `/ui2/cl_json` anywhere.

### 10.2 `ZCL_BAPI_HYB_LEX_SPLITTER`

[`zcl_bapi_hyb_lex_splitter.clas.abap`](./zcl_bapi_hyb_lex_splitter.clas.abap)

O(strlen) lexical split of the `documents[]` array. Does not deserialize
the full payload. Returns a `string_table` with one JSON chunk per worker.

### 10.3 `ZCL_BAPI_HYB_DISPATCHER`

[`zcl_bapi_hyb_dispatcher.clas.abap`](./zcl_bapi_hyb_dispatcher.clas.abap)
(test classes: [`zcl_bapi_hyb_dispatcher.clas.testclasses.abap`](./zcl_bapi_hyb_dispatcher.clas.testclasses.abap))

Reads only the header of the payload via trim + CTF. Delegates splitting
to `zcl_bapi_hyb_lex_splitter` and dispatching to `cl_bgmc_process_factory`.

The `dispatch_chunks` method is **protected** and can be overridden in a
subclass during testing — see `ltc_hyb_stub` in the test file.

### 10.4 `ZCL_BAPI_HYB_CALLER`

[`zcl_bapi_hyb_caller.clas.abap`](./zcl_bapi_hyb_caller.clas.abap)

Deserializes the chunk (CTF id), introspects the BAPI via
`FUNCTION_IMPORT_INTERFACE` + RTTI, calls `CALL FUNCTION <dyn>` with
`PARAMETER-TABLE`, and decides `BAPI_TRANSACTION_COMMIT` or
`BAPI_TRANSACTION_ROLLBACK` per document.

### 10.5 `ZCL_BAPI_HYB_WORKER_OP`

[`zcl_bapi_hyb_worker_op.clas.abap`](./zcl_bapi_hyb_worker_op.clas.abap)

Worker execution unit. Exposes the public method `execute()` which
instantiates `zcl_bapi_hyb_caller` and processes the chunk.

> **bgPF (upgrade path):** when the system has
> `IF_BGMC_OP_SINGLE_TX_UNCONTROLLED` available (SAP_BASIS 7.57+ /
> SAP BTP ABAP 2108+), simply re-declare
> `INTERFACES if_bgmc_op_single_tx_uncontrolled`, rename `execute` to
> `if_bgmc_op_single_tx_uncontrolled~execute`, and re-enable bgPF
> scheduling in the dispatcher's `dispatch_chunks`. No other class needs
> to change.

Currently the dispatcher calls `execute()` directly (synchronous) to
avoid the release dependency.

### 10.6 `ZCL_BAPI_HYB_META_BUILDER`

[`zcl_bapi_hyb_meta_builder.clas.abap`](./zcl_bapi_hyb_meta_builder.clas.abap)

Returns the BAPI metadata as a **typed ABAP table** (no JSON
serialization). Each row represents one DDIC field, ready to become a
row of the OData collection `[0..*] ZD_BAPI_HYB_META`.

Public signature:

```abap
TYPES:
  BEGIN OF ty_row,
    bapi_name    TYPE c LENGTH 30,
    section      TYPE c LENGTH 1,     " 'H' | 'I'
    param_name   TYPE c LENGTH 30,
    field_name   TYPE c LENGTH 30,
    document_idx TYPE i,
    param_order  TYPE i,
    field_order  TYPE i,
    field_type   TYPE c LENGTH 30,
  END OF ty_row,
  tt_rows TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

METHODS build
  IMPORTING iv_bapi_name   TYPE csequence
  RETURNING VALUE(rt_rows) TYPE tt_rows
  RAISING   cx_static_check.
```

Internal flow of `build( iv_bapi_name )`:

1. `FUNCTION_EXISTS` validates that the BAPI exists.
2. `FUNCTION_IMPORT_INTERFACE` returns the interface (IMPORT, TABLES, ...).
3. Each IMPORT parameter typed against a DDIC structure becomes rows
   with `section = 'H'` and `param_name = <parameter name>`.
4. Each TABLES parameter becomes rows with `section = 'I'` — the table
   line type is the DDIC structure introspected.
5. `DDIF_FIELDINFO_GET` returns the fields of each structure; `map_type`
   converts DDIC datatype/length/decimals into `char2`, `numc10`,
   `dec13.2`, `string`, etc.

No more manual JSON assembly or `e_json_string` escaping. OData
serialization is handled by the RAP framework.

> **Clean Core:** `FUNCTION_IMPORT_INTERFACE` and `DDIF_FIELDINFO_GET` are
> not released for ABAP Cloud. This helper is intended for on-premise /
> embedded Steampunk / private cloud — same constraint as
> `zcl_bapi_hyb_caller`.

> **Clean Core:** `FUNCTION_IMPORT_INTERFACE` and `DDIF_FIELDINFO_GET` are
> not released for ABAP Cloud. This helper is intended for on-premise /
> embedded Steampunk / private cloud — same constraint as
> `zcl_bapi_hyb_caller`.

After activating all classes, **activate** `ZBP_R_BAPI_HYB_RUN`.

---

## 11. Step 8 — Service Definition + Service Binding

1. Right-click `ZC_BAPI_HYB_RUN` → **New Service Definition** →
   `ZUI_BAPI_HYB_RUN_O4`
   Paste [`zui_bapi_hyb_run_o4.srvd.asrvd`](./zui_bapi_hyb_run_o4.srvd.asrvd). Activate.

2. Right-click on the Service Definition → **New Service Binding** →
   `ZUI_BAPI_HYB_RUN_O4`, **binding type** = `OData V4 – Web API`
   See [`zui_bapi_hyb_run_o4.srvb.srvb`](./zui_bapi_hyb_run_o4.srvb.srvb) as
   reference. Activate.

3. In the Service Binding editor → click **Activate/Publish**.

Base URL:

```
/sap/opu/odata4/sap/zui_bapi_hyb_run_o4/srvd_a2x/sap/zui_bapi_hyb_run_o4/0001/
```

### On-premise — register via STC01

```
STC01 → SAP_GATEWAY_ACTIVATE_ODATA_SERV → Technical Name: ZUI_BAPI_HYB_RUN_O4
```

### Steampunk / ABAP Environment

The URL is generated automatically when the binding is activated.

---

## 12. Step 9 — bgPF: no RFC server group needed

This project **does not use** `STARTING NEW TASK DESTINATION IN GROUP`.
No `RZ12` configuration is required.

bgPF manages its own background work process pool internally. To monitor
pending executions and failures:

- `SM37` → background jobs created by bgPF
- `SBGRFCMON` → bgRFC monitor (bgPF uses bgRFC internally)
- `SLG1` / Application Log → if the worker uses `cl_bali_log`

Tune the number of background work processes (`SM50`) according to the expected
volume.

---

## 13. Step 10 — Authorizations

`S_SERVICE` object for OData:

| Field | Value |
|---|---|
| `SRV_NAME` | `ZUI_BAPI_HYB_RUN_O4` |
| `SRV_TYPE` | `HT` |
| `SRV_CHECK` | `X` |

Additionally:
- `S_RFC` for target BAPIs (e.g. `BAPI_PO_CREATE1`, `BAPI_TRANSACTION_COMMIT`)
- Business-specific authorizations (e.g. `M_BEST_EKO` for Purchase Orders)
- `S_BGMC` (or equivalent) if the system requires authorization for bgPF process creation

---

## 14. Step 11 — Testing (ATC, ADT Preview, Postman)

### 14.1 Unit tests

`Ctrl+Shift+F10` on class `ZCL_BAPI_HYB_DISPATCHER`. The tests in
[`zcl_bapi_hyb_dispatcher.clas.testclasses.abap`](./zcl_bapi_hyb_dispatcher.clas.testclasses.abap)
cover:

| Test | What it validates |
|---|---|
| `defaults` | `normalize_positive` returns default when `iv_value = 0` |
| `calc_workers` | `calculate_workers(250 docs / 100 rows / 4 max)` = 3 |
| `parse_header_only` | Header extracted correctly without deserializing `documents[]` |
| `parse_header_ignores_arrays` | Arrays before scalars do not corrupt the trim |
| `lex_split_basic` | 3 simple documents produce 3 chunks |
| `lex_split_nested` | Documents with nested arrays do not break the split |
| `dispatch_chunk_mode` | `kind=chunk` → 1 chunk, 1 worker |
| `dispatch_bulk_splits` | `kind=bulk` → N chunks via `ltc_hyb_stub` |

### 14.2 Service Binding preview

Click *Preview* in the Service Binding editor → Fiori Launchpad with
List Report for entity `BapiRun`.

### 14.3 GET metadata (with BAPI parameter)

`GetMetadata` is a `static function` with `result [0..*] ZD_BAPI_HYB_META`.
The `BapiName` parameter goes **in the URL**, inside parentheses, and
the call is `GET` — no body, no `Content-Type`, no CSRF token.

```http
GET /sap/opu/odata4/sap/zui_bapi_hyb_run_o4/srvd_a2x/sap/zui_bapi_hyb_run_o4/0001/BapiRun/com.sap.gateway.srvd_a2x.zui_bapi_hyb_run_o4.v0001.GetMetadata(BapiName='BAPI_PO_CREATE1')
Accept: application/json
Authorization: Basic <credentials>
```

Expected response — structured OData collection, one row per DDIC field
(no more `Edm.String` carrying escaped JSON):

```json
{
  "value": [
    { "BapiName": "BAPI_PO_CREATE1", "Section": "H", "ParamName": "POHEADER", "FieldName": "DOC_TYPE", "FieldType": "char4",  "DocumentIdx": 1, "ParamOrder": 1, "FieldOrder": 1 },
    { "BapiName": "BAPI_PO_CREATE1", "Section": "H", "ParamName": "POHEADER", "FieldName": "VENDOR",   "FieldType": "char10", "DocumentIdx": 1, "ParamOrder": 1, "FieldOrder": 2 },
    { "BapiName": "BAPI_PO_CREATE1", "Section": "I", "ParamName": "POITEM",   "FieldName": "PO_ITEM",  "FieldType": "numc5",  "DocumentIdx": 1, "ParamOrder": 1, "FieldOrder": 1 }
  ]
}
```

`Section = 'H'` → `heders_values` (IMPORT). `Section = 'I'` → `items_values`
(TABLES). To rebuild the nested shape of [`input.json`](./input.json),
group the rows by `Section` + `ParamName` on the client.

If the BAPI does not exist, the response returns `"value": []` (the
handler swallows `cx_root` and returns an empty collection).

### 14.4 POST submit (Postman / curl)

**Fetch CSRF token:**

```http
HEAD /sap/opu/odata4/sap/zui_bapi_hyb_run_o4/srvd_a2x/sap/zui_bapi_hyb_run_o4/0001/
X-CSRF-Token: Fetch
```

**Call the Submit action:**

```http
POST /sap/opu/odata4/sap/zui_bapi_hyb_run_o4/srvd_a2x/sap/zui_bapi_hyb_run_o4/0001/BapiRun/com.sap.gateway.srvd_a2x.zui_bapi_hyb_run_o4.v0001.Submit
X-CSRF-Token: <token>
Content-Type: application/json

{ "Payload": "{\"bapi_name\":\"BAPI_PO_CREATE1\",\"mode\":\"async\",\"kind\":\"bulk\",\"worker_threads\":4,\"worker_rows\":100,\"documents\":[...]}" }
```

Expected `202 Accepted`:

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

Verify the persisted row: `SE16 → ZBAPI_HYB_RUN` or
`GET BapiRun('<RunUuid>')`.

---

## 15. Appendix A — Full OData payload

See [`input.json`](./input.json). The `Payload` field must be sent as an
**escaped JSON string**, not as an object.

Serialize with `jq`:

```bash
jq -c '.' input.json | jq -Rs '{ Payload: . }'
```

---

## 16. Appendix B — Troubleshooting

| Symptom | Likely cause | Action |
|---|---|---|
| `Action Submit not found` | Binding not republished after bdef changes | Reactivate/Publish the Service Binding |
| `Function GetMetadata not found` | `use function GetMetadata` missing from projection bdef | Check `zc_bapi_hyb_run.bdef.asbdef` |
| `<KEY> does not have a component called %PARAM-BAPINAME` | Behavior pool compiled before `ZD_BAPI_HYB_META_IN` / new BDEF | Activate in order: entity → root BDEF → projection BDEF → behavior pool. If it persists, *Project → Clean* in Eclipse |
| `parameter type ZD_BAPI_HYB_META_IN not found` | Parameter entity not active or not `root abstract entity` | Activate `ZD_BAPI_HYB_META_IN` as `define root abstract entity` |
| `Payload is empty` | Client sent an object instead of an escaped string | Serialize `Payload` as escaped JSON string |
| `bapi_name is mandatory` | Internal JSON does not contain `bapi_name` | Validate payload before calling |
| `GetMetadata` returns `"value": []` | BAPI does not exist, is not RFC-enabled, or introspection failed | Check `SE37` / `SM59` — `FUNCTION_EXISTS` / `FUNCTION_IMPORT_INTERFACE` failed |
| `GetMetadata` returns very few rows (only `Section='I'` or only `'H'`) | BAPI only has scalar parameters on the other side | Expected behavior — the introspection only includes IMPORT/TABLES typed against a DDIC structure |
| `cx_transformation_error` in parser | Malformed JSON or wrong encoding | Validate with `jq .` before sending |
| bgPF process never executes | `save_for_execution` without `COMMIT WORK` | Commit is handled by the RAP framework at the end of the save; do not add manual `COMMIT WORK` |
| Worker fails silently | `cx_root` caught in `execute()` | Add logging via `cl_bali_log` inside the worker catch block |
| Timestamps are zero | `CREATED_AT` / `LAST_CHANGED_AT` not mapped | Check `@Semantics.systemDateTime.*` on views and mapping in bdef |
| `UTCLONG` not accepted | Release < 7.54 | Upgrade required; do not fall back to `DEC 21,7` in cloud |
| `403` on OData | Missing `S_SERVICE` | Grant `HT / ZUI_BAPI_HYB_RUN_O4` authorization |
| BAPI executes but nothing persists | RETURN contains `E/A/X` → correct rollback | Read `ZBAPI_HYB_RUN` + inspect RETURN messages via log |
| `FUNCTION_IMPORT_INTERFACE` fails | BAPI does not exist or is not RFC-enabled | Check `SE37` / `SM59` |
