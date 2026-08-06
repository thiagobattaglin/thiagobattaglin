# Equipment Load — HTTP API + Parallel Processing (bgPF)

RAP-friendly ABAP Cloud implementation of the Clean Core add-on architecture
Replicate → HTTP API → Parallel Processing, using `BAPI_EQUI_CREATE`.

**Rules:**
- The caller controls **how many items each worker processes** via
  `worker_rows` in the request body.
- Inside every worker each item still runs its **own** `BAPI_EQUI_CREATE`
  and its **own** `BAPI_TRANSACTION_COMMIT` (isolation per item).
- When `worker_rows` is missing / zero, the orchestrator splits the input
  into **4 workers** (or fewer, if the input has fewer than 4 items).

## Objects created

| Object | Role in the architecture |
|---|---|
| [zcl_equi_load_http_api.clas.abap](zcl_equi_load_http_api.clas.abap) | **HTTP API** — `if_http_service_extension` handler, parses `worker_rows` and `items` |
| [zcl_equi_load_orchestrator.clas.abap](zcl_equi_load_orchestrator.clas.abap) | Splits items into chunks and submits **1 worker per chunk** to the **bgPF** |
| [zcl_equi_worker.clas.abap](zcl_equi_worker.clas.abap) | **Worker** — loops over its slice of items, 1 BAPI + own commit per item |
| [zcl_equi_load_dto.clas.abap](zcl_equi_load_dto.clas.abap) | Input / result DTOs |
| [zif_equi_load_source.intf.abap](zif_equi_load_source.intf.abap) / [zif_equi_load_sink.intf.abap](zif_equi_load_sink.intf.abap) | Source / sink contracts |
| [zcl_equi_load_src_http.clas.abap](zcl_equi_load_src_http.clas.abap) | Source: deserialized HTTP payload |
| [zcl_equi_load_sink_memory.clas.abap](zcl_equi_load_sink_memory.clas.abap) | In-memory sink (synchronous response) |
| [zcl_equi_load_sink_applog.clas.abap](zcl_equi_load_sink_applog.clas.abap) | Application Log sink (`cl_bali_*`) |
| [zcl_equi_load_run.clas.abap](zcl_equi_load_run.clas.abap) | Class-Run entry point for F9 in ADT |
| [zcl_equi_worker.clas.testclasses.abap](zcl_equi_worker.clas.testclasses.abap) | Unit tests (worker + chunking) |

## Flows

- **Async (default)** — HTTP API receives the payload; the orchestrator
  chunks the `items` according to `worker_rows` (or splits into 4 by default)
  and submits each chunk as a `ZCL_EQUI_WORKER` unit-of-work to the **bgPF**
  (`cl_bgmc_process_factory`). Immediate **HTTP 202** response with
  `accepted` + `workers`. Inside each worker every item runs `BAPI_EQUI_CREATE`
  followed by its own `BAPI_TRANSACTION_COMMIT`. Errors are written to the
  Application Log (`ZEQUI_LOAD`).

- **Sync** (`"mode":"sync"`) — each worker still owns its slice of items,
  but the workers execute sequentially within the request. The HTTP 200
  response contains the `results` list keyed by `ext_id`. Suitable for small
  batches or interactive scenarios.

## Chunking rule

| `worker_rows` | Behaviour |
|---|---|
| `> 0` (e.g. `5000`) | Each worker takes up to `worker_rows` items. 12 000 items with `worker_rows=5000` → 3 workers (5000, 5000, 2000). |
| missing / `0` / null | Split evenly into **4 workers**. 20 items → 4 workers of 5. |
| default with fewer items than 4 | One worker per item (e.g. 2 items → 2 workers). |

## HTTP Contract

```
POST /equi-load
Content-Type: application/json

{
  "mode": "async",
  "worker_rows": 5000,
  "items": [
    {
      "ext_id": "EXT-0001",
      "equi_category": "M",
      "descript": "100 HP Motor",
      "eqtype": "MECH",
      "maintplant": "1010",
      "planplant": "1010",
      "location": "AREA-01",
      "cost_center": "10101010",
      "company_code": "1010",
      "start_up_date": "2025-01-01",
      "manufacturer": "ACME",
      "model_number": "M100"
    }
  ]
}
```

Sync response:

```json
{
  "results": [
    { "ext_id": "EXT-0001", "equipment": "10000042", "status": "S", "message": "OK" }
  ]
}
```

Async response:

```json
{ "accepted": 12000, "workers": 3, "mode": "async" }
```

## Publishing as HTTP Service (ADT)

1. Create a **Service Definition** and a **Service Binding** of type *HTTP Service*.
2. Bind to handler class `ZCL_EQUI_LOAD_HTTP_API`.
3. Configure Communication Arrangement / Scope to allow the Replicate SAP
   Target Connector to consume the endpoint.

## Diagram

See [architecture.mmd](architecture.mmd).

## Clean Core Notes

- `BAPI_EQUI_CREATE` is used here as a pedagogical example. In a strictly clean
  core scenario, replace it with a released RAP Business Object and swap
  `BAPI_TRANSACTION_COMMIT` for `COMMIT ENTITIES`. The 1 worker = 1 item =
  1 commit rule remains valid.
- All auxiliary APIs are released: `cl_bgmc_*`, `cl_bali_*`,
  `xco_cp_json`, `if_http_service_extension`.
