# Installation & Publishing Guide
# Equipment Load — HTTP API + RAP OData V4

Prerequisites: SAP BTP ABAP Environment or S/4HANA Cloud ABAP Environment,
ADT (Eclipse) with ABAP plugin installed and connected to the system.

---

## PART 1 — Shared parallel processing layer (nova-arquitetura/)

These objects are shared by both endpoints. Must be created first.

### Step 1 — Create package

In ADT → New → ABAP Package
- Name: `ZEQUI_LOAD`
- Description: `Equipment Load - Parallel Processing`
- Package type: Development
- Transport: assign or use `$TMP` for local testing

---

### Step 2 — Interfaces

**2.1** New → Interface → `ZIF_EQUI_LOAD_SOURCE`
- Paste content from `zif_equi_load_source.intf.abap`
- Activate (Ctrl+F3)

**2.2** New → Interface → `ZIF_EQUI_LOAD_SINK`
- Paste content from `zif_equi_load_sink.intf.abap`
- Activate

---

### Step 3 — DTO class

New → ABAP Class → `ZCL_EQUI_LOAD_DTO`
- Paste content from `zcl_equi_load_dto.clas.abap`
- Activate

---

### Step 4 — Source and Sink implementations

Create in any order, then activate all:

| Class name | Source file |
|---|---|
| `ZCL_EQUI_LOAD_SRC_HTTP` | `zcl_equi_load_src_http.clas.abap` |
| `ZCL_EQUI_LOAD_SINK_MEMORY` | `zcl_equi_load_sink_memory.clas.abap` |
| `ZCL_EQUI_LOAD_SINK_APPLOG` | `zcl_equi_load_sink_applog.clas.abap` |

For each: New → ABAP Class → paste content → Activate.

---

### Step 5 — Application Log object

Transaction `SLG0` (on-prem) or equivalent in cloud:
- Object: `ZEQUI_LOAD`
- Sub-object: `HTTP_API`

---

### Step 6 — Worker class

New → ABAP Class → `ZCL_EQUI_WORKER`
- Paste `zcl_equi_worker.clas.abap` into the main include
- Paste `zcl_equi_worker.clas.testclasses.abap` into the test include
- Activate

---

### Step 7 — Orchestrator class

New → ABAP Class → `ZCL_EQUI_LOAD_ORCHESTRATOR`
- Paste content from `zcl_equi_load_orchestrator.clas.abap`
- Activate

---

### Step 8 — Run unit tests

In ADT: right-click `ZCL_EQUI_WORKER` → Run As → ABAP Unit Test (Ctrl+Shift+F10)
All test methods in `ltcl_worker` and `ltcl_chunking` must be green.

---

### Step 9 — Smoke test via Class-Run

New → ABAP Class → `ZCL_EQUI_LOAD_RUN`
- Paste content from `zcl_equi_load_run.clas.abap`
- Run (F9) — verify output in the console

---

## PART 2 — HTTP API endpoint (nova-arquitetura/)

Used if the caller wants raw REST/JSON (no OData).
Skip this part if using only the RAP endpoint.

### Step 10 — HTTP handler class

New → ABAP Class → `ZCL_EQUI_LOAD_HTTP_API`
- Paste content from `zcl_equi_load_http_api.clas.abap`
- Activate

---

### Step 11 — Create HTTP Service Binding

**11.1** New → Other ABAP Repository Object → HTTP Service
- Name: `ZEQUI_LOAD_HTTP`
- Handler class: `ZCL_EQUI_LOAD_HTTP_API`
- Activate

**11.2** Copy the generated service URL, e.g.:
```
https://<host>/sap/bc/http/sap/zequi_load_http/
```

---

### Step 12 — Configure access (S/4HANA Cloud)

In the Fiori Launchpad → Communication Arrangements:
1. New → Communication Arrangement
2. Communication Scenario: create or reuse an inbound scenario that includes
   the HTTP service `ZEQUI_LOAD_HTTP`
3. Create inbound Communication User (user + password)
4. Finish → note the service URL and credentials

---

### Step 13 — Test the HTTP endpoint

```bash
curl -X POST https://<host>/sap/bc/http/sap/zequi_load_http/ \
  -u <user>:<password> \
  -H "Content-Type: application/json" \
  -d '{
    "mode": "async",
    "worker_rows": 1000,
    "items": [{
      "ext_id": "TEST-001",
      "equi_category": "M",
      "descript": "Test Motor",
      "eqtype": "MECH",
      "maintplant": "1010",
      "planplant": "1010",
      "company_code": "1010",
      "start_up_date": "20250101"
    }]
  }'
```

Expected response:
```json
{ "accepted": 1, "workers": 1, "mode": "async" }
```

Check Application Log in transaction `SLG1` → Object `ZEQUI_LOAD`.

---

## PART 3 — RAP OData V4 endpoint (nova-arquitetura/rap/)

For consumption by Syniti Surge Replicate via OData V4.

### Step 14 — DDIC tables

**14.1** New → Other ABAP Repository Object → Database Table → `ZEQUI_LOAD_REQ`
- Use the XML in `zequi_load_req.tabl.xml` as reference for field definitions
- Delivery class: A | Data browser: X
- Activate

**14.2** New → Database Table → `ZEQUI_LOAD_ITM`
- Use `zequi_load_itm.tabl.xml` as reference
- Activate

---

### Step 15 — CDS interface layer

Activate strictly in order (parent before child):

**15.1** New → Other ABAP Repository Object → Data Definition → `ZR_EQUI_LOAD_REQ`
- Type: Define Root View Entity
- Paste content from `zr_equi_load_req.ddls.asddls`
- Activate

**15.2** New → Data Definition → `ZR_EQUI_LOAD_ITM`
- Type: Define View Entity
- Paste content from `zr_equi_load_itm.ddls.asddls`
- Activate

---

### Step 16 — CDS projection layer

**16.1** New → Data Definition → `ZC_EQUI_LOAD_REQ`
- Type: Define Root View Entity (provider contract: transactional_query)
- Paste content from `zc_equi_load_req.ddls.asddls`
- Activate

**16.2** New → Data Definition → `ZC_EQUI_LOAD_ITM`
- Type: Define View Entity
- Paste content from `zc_equi_load_itm.ddls.asddls`
- Activate

---

### Step 17 — Behavior Definitions

**17.1** New → Other ABAP Repository Object → Behavior Definition → `ZR_EQUI_LOAD_REQ`
- Based on CDS `ZR_EQUI_LOAD_REQ`
- Paste content from `zr_equi_load_req.bdef.asbdef`
- Activate

**17.2** New → Behavior Definition → `ZC_EQUI_LOAD_REQ`
- Based on CDS `ZC_EQUI_LOAD_REQ`
- Paste content from `zc_equi_load_req.bdef.asbdef`
- Activate

---

### Step 18 — Behavior Pool (implementation class)

New → ABAP Class → `ZBP_R_EQUI_LOAD_REQ`
- Paste `zbp_r_equi_load_req.clas.abap` into the main include
- Paste `zbp_r_equi_load_req.clas.locals_imp.abap` into the
  **Local Types** include (the one named `locals_imp`)
- Activate

> The `lsc_saver` additional-save handler in `locals_imp` calls
> `ZCL_EQUI_LOAD_ORCHESTRATOR` (created in Part 1).
> Both classes must be in the same package or package dependencies configured.

---

### Step 19 — Service Definition

New → Other ABAP Repository Object → Service Definition → `ZUI_EQUI_LOAD_O4`
- Paste content from `zui_equi_load_o4.srvd.asrvd`
- Activate

---

### Step 20 — Service Binding

New → Other ABAP Repository Object → Service Binding → `ZUI_EQUI_LOAD_O4`
- Service definition: `ZUI_EQUI_LOAD_O4`
- Binding type: **OData V4 - Web API** (ODATA_V4_API)
- Activate
- Click **Publish** → wait for publication to complete
- Copy the base URL shown in the binding editor, e.g.:
  ```
  https://<host>/sap/opu/odata4/sap/zui_equi_load_o4/srvd_a2x/sap/zui_equi_load_o4/0001/
  ```

---

### Step 21 — Communication Arrangement for Replicate (S/4HANA Cloud)

1. Fiori Launchpad → **Communication Systems** → New
   - System ID: `SYNITI_SURGE`
   - Host: your Syniti Surge tenant hostname
   - Save

2. **Communication Arrangements** → New
   - Communication Scenario: create a custom scenario in ADT
     (`New → Communication Scenario`) that includes the service binding
     `ZUI_EQUI_LOAD_O4` with `ReadWrite` access
   - Link to system `SYNITI_SURGE`
   - Create inbound **Communication User** (`SYNITI_REPLICATE` + password)
   - Service URL is shown at the bottom — hand this to the Replicate SAP
     Target Connector configuration

---

### Step 22 — Configure Syniti Surge Replicate

In the Replicate SAP Target Connector configuration:
- Protocol: OData V4
- Base URL: the URL from Step 20
- Auth: Basic (user from Step 21) or OAuth if configured
- Entity set: `LoadRequest`
- Deep insert: enabled (`_Items` navigation property)
- Map source fields to the OData properties:

  | Replicate source field | OData property |
  |---|---|
  | (static) | `Mode` = `"A"` |
  | (static) | `WorkerRows` = `5000` (or your batch size) |
  | ext_id | `_Items/ExtId` |
  | category | `_Items/EquiCategory` |
  | description | `_Items/Descript` |
  | eqtype | `_Items/Eqtype` |
  | plant | `_Items/Maintplant` |
  | ... | ... |

---

### Step 23 — End-to-end test

**23.1** POST a test request with one item:
```
POST https://<host>/sap/opu/odata4/sap/zui_equi_load_o4/srvd_a2x/sap/zui_equi_load_o4/0001/LoadRequest
Authorization: Basic <base64(user:pass)>
Content-Type: application/json

{
  "Mode": "A",
  "WorkerRows": 0,
  "_Items": [{
    "ItemNo": 1,
    "ExtId": "TEST-001",
    "EquiCategory": "M",
    "Descript": "Test Motor",
    "Eqtype": "MECH",
    "Maintplant": "1010",
    "Planplant": "1010",
    "CompanyCode": "1010",
    "StartUpDate": "2025-01-01"
  }]
}
```

**23.2** Note the `RequestUuid` in the 201 response, then poll:
```
GET .../LoadRequest(<uuid>)?$expand=_Items
```

Check `Status` transitions: `N` → `R` → `C`
Check `_Items/ItemStatus` = `S` and `_Items/Equipment` has a value.

**23.3** Confirm equipment created: SAP transaction `IE03` → enter the equipment number.

**23.4** Check Application Log: transaction `SLG1` → Object `ZEQUI_LOAD`.

---

## Troubleshooting

| Symptom | Check |
|---|---|
| `BAPI_EQUI_CREATE` returns error | Transaction `IE01` manually with same data to isolate |
| `lsc_saver` not triggered | Verify BDEF has `with additional save` and pool class is activated |
| Workers submitted but no result | Check bgPF profile: `rdisp/wp_no_btc` must be > 0; check bgRFC destination |
| OData 403 | Communication Arrangement missing ReadWrite scope on `ZUI_EQUI_LOAD_O4` |
| CDS activation error "parent not found" | Activate `ZR_EQUI_LOAD_REQ` before `ZR_EQUI_LOAD_ITM` |
| HTTP API returns 500 | Check `ZCL_EQUI_LOAD_HTTP_API` is the handler class on the HTTP Service |
