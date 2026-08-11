# Installation & Publishing Guide
# Dynamic Load — HTTP API + RAP OData V4 (Adapter Pattern)

Prerequisites: SAP BTP ABAP Environment or S/4HANA Cloud ABAP Environment,
ADT (Eclipse) with the ABAP plugin installed and connected to the system.

Both APIs share the same parallel processing core and adapters. Install
Part 1 first, then Part 2 (HTTP API) and/or Part 3 (RAP) as needed.

---

## PART 1 — Shared adapter & parallelism layer

### Step 1 — Create package

New → ABAP Package
- Name: `ZLOAD_DYN`
- Description: `Dynamic Load - Multi-BAPI Parallel Processing`
- Package type: Development
- Transport: assign or use `$TMP` for local testing

---

### Step 2 — Interfaces

Create in any order, then activate:

| Interface | Source file |
|---|---|
| `ZIF_LOAD_SOURCE` | `zif_load_source.intf.abap` |
| `ZIF_LOAD_SINK` | `zif_load_sink.intf.abap` |
| `ZIF_LOAD_ADAPTER` | `zif_load_adapter.intf.abap` |

For each: New → Interface → paste content → Activate (Ctrl+F3).

---

### Step 3 — DTO class

New → ABAP Class → `ZCL_LOAD_DTO`
- Paste `zcl_load_dto.clas.abap` into the main include
- Paste `zcl_load_dto.clas.testclasses.abap` into the Test Classes include
- Activate

---

### Step 4 — Source and Sink implementations

| Class | Source file |
|---|---|
| `ZCL_LOAD_SRC_HTTP` | `zcl_load_src_http.clas.abap` |
| `ZCL_LOAD_SINK_MEMORY` | `zcl_load_sink_memory.clas.abap` |
| `ZCL_LOAD_SINK_APPLOG` | `zcl_load_sink_applog.clas.abap` |

For each: New → ABAP Class → paste → Activate.

---

### Step 5 — Application Log object

Create the log object referenced by `ZCL_LOAD_SINK_APPLOG`:
- Object: `ZLOAD_DYN`
- Sub-object: `HTTP_API`

Configure in `SLG0` (on-prem) or the cloud equivalent.

---

### Step 6 — Adapters (one per BAPI)

Create every adapter you want to support:

| Class | Object type | BAPI wrapped |
|---|---|---|
| `ZCL_ADAPTER_EQUI_CREATE` | `EQUIPMENT` | `BAPI_EQUI_CREATE` |
| `ZCL_ADAPTER_FLOC_CREATE` | `FUNC_LOCATION` | `BAPI_FUNCLOC_CREATE` |

For each: New → ABAP Class → paste content → Activate.

> Adding a new BAPI later? Only two files change: a new
> `ZCL_ADAPTER_<X>_CREATE` class and one entry in the factory (Step 7).

---

### Step 7 — Adapter factory (allowlist)

New → ABAP Class → `ZCL_LOAD_ADAPTER_FACTORY`
- Paste content from `zcl_load_adapter_factory.clas.abap`
- Activate

The `CASE lv_key ... WHEN` block is the **allowlist**. Only object types
listed here are dispatched. This is the single change point when adding
a new BAPI.

---

### Step 8 — Worker class

New → ABAP Class → `ZCL_LOAD_WORKER`
- Paste `zcl_load_worker.clas.abap` into the main include
- Paste `zcl_load_worker.clas.testclasses.abap` into the Test Classes include
- Activate

---

### Step 9 — Orchestrator class

New → ABAP Class → `ZCL_LOAD_ORCHESTRATOR`
- Paste content from `zcl_load_orchestrator.clas.abap`
- Activate

---

### Step 10 — Run unit tests

In ADT: right-click `ZCL_LOAD_WORKER` → Run As → ABAP Unit Test (Ctrl+Shift+F10).
Repeat for `ZCL_LOAD_DTO`.

All `ltcl_factory`, `ltcl_worker`, `ltcl_chunking`, `ltcl_dto` tests must be green.

Note: the worker tests intentionally use `object_type = 'ROCKET_SHIP'`
(unknown) to exercise the error path without calling any real BAPI —
tests are fully deterministic and safe to run repeatedly.

---

### Step 11 — Smoke test via Class-Run

New → ABAP Class → `ZCL_LOAD_RUN`
- Paste content from `zcl_load_run.clas.abap`
- Activate → Run (F9)

Expected console output: two lines showing the result for
`EQ-001` (Equipment) and `FL-001` (Functional Location).

---

## PART 2 — HTTP API endpoint

Raw REST/JSON entry point. Skip if only the RAP endpoint is needed.

### Step 12 — HTTP handler class

New → ABAP Class → `ZCL_LOAD_HTTP_API`
- Paste content from `zcl_load_http_api.clas.abap`
- Activate

---

### Step 13 — HTTP Service

New → Other ABAP Repository Object → HTTP Service
- Name: `ZLOAD_DYN_HTTP`
- Handler class: `ZCL_LOAD_HTTP_API`
- Activate → note the generated URL, e.g.:
  ```
  https://<host>/sap/bc/http/sap/zload_dyn_http/
  ```

---

### Step 14 — Communication Arrangement (S/4HANA Cloud)

Fiori Launchpad → Communication Arrangements:
1. New → Communication Arrangement.
2. Custom inbound scenario including the HTTP service `ZLOAD_DYN_HTTP`.
3. Create inbound Communication User (user + password).
4. Save; note the endpoint URL and credentials for the caller.

---

### Step 15 — Test the HTTP endpoint

```bash
curl -X POST https://<host>/sap/bc/http/sap/zload_dyn_http/ \
  -u <user>:<password> \
  -H "Content-Type: application/json" \
  -d '{
    "mode": "async",
    "worker_rows": 100,
    "items": [
      {
        "ext_id": "EQ-TEST-001",
        "object_type": "EQUIPMENT",
        "fields": [
          { "name": "equi_category", "value": "M" },
          { "name": "descript",      "value": "Test Motor" },
          { "name": "eqtype",        "value": "MECH" },
          { "name": "maintplant",    "value": "1010" },
          { "name": "planplant",     "value": "1010" },
          { "name": "company_code",  "value": "1010" }
        ]
      }
    ]
  }'
```

Expected response:
```json
{ "accepted": 1, "workers": 1, "mode": "async" }
```

Check `SLG1` → Object `ZLOAD_DYN` for the per-item result.

---

## PART 3 — RAP OData V4 endpoint (rap/)

For consumption by Syniti Surge Replicate.

### Step 16 — DDIC tables

**16.1** New → Database Table → `ZLOAD_REQ`
- Use `rap/zload_req.tabl.xml` as reference
- Activate

**16.2** New → Database Table → `ZLOAD_ITM`
- Use `rap/zload_itm.tabl.xml` as reference
- Note: `FIELDS_JSON` is a STRING (unbounded LOB) that stores the
  serialized `fields` array
- Activate

---

### Step 17 — CDS interface layer (activate parent before child)

**17.1** New → Data Definition → `ZR_LOAD_REQ`
- Type: Define Root View Entity
- Paste `rap/zr_load_req.ddls.asddls`
- Activate

**17.2** New → Data Definition → `ZR_LOAD_ITM`
- Paste `rap/zr_load_itm.ddls.asddls`
- Activate

---

### Step 18 — CDS projection layer

**18.1** New → Data Definition → `ZC_LOAD_REQ`
- Provider contract: `transactional_query`
- Paste `rap/zc_load_req.ddls.asddls`
- Activate

**18.2** New → Data Definition → `ZC_LOAD_ITM`
- Paste `rap/zc_load_itm.ddls.asddls`
- Activate

---

### Step 19 — Behavior Definitions

**19.1** New → Behavior Definition → `ZR_LOAD_REQ`
- Based on CDS `ZR_LOAD_REQ`
- Paste `rap/zr_load_req.bdef.asbdef`
- Activate

**19.2** New → Behavior Definition → `ZC_LOAD_REQ`
- Based on CDS `ZC_LOAD_REQ`
- Paste `rap/zc_load_req.bdef.asbdef`
- Activate

---

### Step 20 — Behavior Pool (implementation class)

New → ABAP Class → `ZBP_R_LOAD_REQ`
- Paste `rap/zbp_r_load_req.clas.abap` into the main include
- Paste `rap/zbp_r_load_req.clas.locals_imp.abap` into the
  **Local Types** include
- Paste `rap/zbp_r_load_req.clas.testclasses.abap` into the
  **Test Classes** include
- Activate

> The `lsc_saver` local class depends on `ZCL_LOAD_ORCHESTRATOR`,
> `ZCL_LOAD_SRC_HTTP`, `ZCL_LOAD_SINK_APPLOG`, `ZCL_LOAD_DTO` and
> `xco_cp_json`. All must already be active in the same package or a
> reachable dependency.

---

### Step 21 — Service Definition

New → Service Definition → `ZUI_LOAD_O4`
- Paste `rap/zui_load_o4.srvd.asrvd`
- Activate

---

### Step 22 — Service Binding

New → Service Binding → `ZUI_LOAD_O4`
- Service definition: `ZUI_LOAD_O4`
- Binding type: **OData V4 - Web API** (`ODATA_V4_API`)
- Activate → **Publish**
- Copy the base URL from the binding editor, e.g.:
  ```
  https://<host>/sap/opu/odata4/sap/zui_load_o4/srvd_a2x/sap/zui_load_o4/0001/
  ```

---

### Step 23 — Communication Arrangement for Replicate

1. Communication Systems → New:
   - System ID: `SYNITI_SURGE`
   - Host: Syniti Surge tenant hostname
2. In ADT → New → Communication Scenario → include the service binding
   `ZUI_LOAD_O4` with `ReadWrite` access → Activate.
3. Fiori Launchpad → Communication Arrangements → New:
   - Scenario: the one from step 2
   - System: `SYNITI_SURGE`
   - Inbound Communication User: `SYNITI_REPLICATE` + password
4. Note the endpoint URL at the bottom of the arrangement; hand it and
   the credentials to the Replicate SAP Target Connector.

---

### Step 24 — Configure Syniti Surge Replicate

In the Replicate SAP Target Connector configuration:
- Protocol: OData V4
- Base URL: from step 22
- Auth: Basic (user from step 23) or OAuth if configured
- Entity set: `LoadRequest`
- Deep insert enabled (`_Items` navigation)
- Map source fields to OData properties:

  | Replicate source | OData property | Notes |
  |---|---|---|
  | (static) | `Mode` = `"A"` | Async |
  | (static) | `WorkerRows` = `5000` | Or your batch size |
  | ext_id | `_Items/ExtId` | External key per record |
  | (static per stream) | `_Items/ObjectType` | e.g. `"EQUIPMENT"` |
  | all payload fields | `_Items/FieldsJson` | JSON string with name/value pairs |

Example `FieldsJson` value (as literal string in the payload):
```json
[{"name":"equi_category","value":"M"},{"name":"descript","value":"100 HP Motor"},{"name":"maintplant","value":"1010"}]
```

---

### Step 25 — End-to-end test

**25.1** POST a request:
```
POST .../LoadRequest
Authorization: Basic <base64(user:pass)>
Content-Type: application/json

{
  "Mode": "A",
  "WorkerRows": 0,
  "_Items": [{
    "ItemNo": 1,
    "ExtId": "EQ-TEST-001",
    "ObjectType": "EQUIPMENT",
    "FieldsJson": "[{\"name\":\"equi_category\",\"value\":\"M\"},{\"name\":\"descript\",\"value\":\"Test Motor\"},{\"name\":\"maintplant\",\"value\":\"1010\"},{\"name\":\"planplant\",\"value\":\"1010\"},{\"name\":\"company_code\",\"value\":\"1010\"}]"
  }]
}
```

**25.2** Note the `RequestUuid` in the 201 response, then poll:
```
GET .../LoadRequest(<uuid>)?$expand=_Items
```

Check `Status` (`N` → `R` → `C`), `_Items/ItemStatus` (`S`),
`_Items/EntityId` (equipment number).

**25.3** Confirm the created equipment: transaction `IE03` → enter the
equipment number.

**25.4** Check Application Log: `SLG1` → Object `ZLOAD_DYN`.

---

## Adding a new object type after installation

1. Create `ZCL_ADAPTER_<X>_CREATE` implementing `ZIF_LOAD_ADAPTER`.
2. Add a `c_object_type` constant with the new key (e.g. `NOTIFICATION`).
3. In `ZCL_LOAD_ADAPTER_FACTORY`:
   - Add a `WHEN zcl_adapter_<x>_create=>c_object_type` branch in `get( )`.
   - Add the key to the `supports( )` allowlist.
4. Add a unit test for the new adapter.
5. Activate; **no** other class needs changes. No RAP re-activation.

---

## Troubleshooting

| Symptom | Check |
|---|---|
| HTTP 400 `Missing object_type` | Every item must carry `object_type`; add it to the mapping |
| Adapter for `X` not called | `ZCL_LOAD_ADAPTER_FACTORY=>supports( 'X' )` — must return `X` |
| RAP saver deserialization silent errors | `FIELDS_JSON` in the DB row must be a valid JSON array of `{name, value}` objects |
| `IE03` shows no equipment | Check `SLG1` → Object `ZLOAD_DYN` for the BAPI return message |
| bgPF submitted but nothing happens | Verify `rdisp/wp_no_btc > 0` and bgRFC destination configured |
| OData 403 | Communication Arrangement missing `ReadWrite` scope for `ZUI_LOAD_O4` |
| CDS activation error "parent not found" | Activate `ZR_LOAD_REQ` before `ZR_LOAD_ITM` |
| Test class fails on `cl_cds_test_environment` | Runs only after the CDS entities are active in the system |
