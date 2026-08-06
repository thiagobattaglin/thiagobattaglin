# Dynamic Load — HTTP API + RAP OData V4 + Adapter Pattern

Multi-BAPI variant of the Equipment Load project. Instead of hardcoding
`BAPI_EQUI_CREATE`, the API receives an `object_type` per item and the
worker dispatches to the matching adapter class. Adding a new BAPI means
adding one adapter class + one entry in the factory allowlist — no
`CALL FUNCTION` with dynamic name, no Clean Core violation.

**Same parallelism rules** as the non-dynamic project:
- Each item = 1 BAPI + 1 own `BAPI_TRANSACTION_COMMIT` (isolation).
- Chunking via `worker_rows` (or default 4 workers).
- bgPF for parallel execution.

## Objects

| Object | Role |
|---|---|
| [zcl_load_dto.clas.abap](zcl_load_dto.clas.abap) | Object-agnostic input/result types with `object_type` and `fields` name/value bag |
| [zif_load_source.intf.abap](zif_load_source.intf.abap) / [zif_load_sink.intf.abap](zif_load_sink.intf.abap) | Source/sink contracts |
| [zif_load_adapter.intf.abap](zif_load_adapter.intf.abap) | **Adapter contract** — 1 BAPI + own commit |
| [zcl_adapter_equi_create.clas.abap](zcl_adapter_equi_create.clas.abap) | Adapter → `BAPI_EQUI_CREATE` |
| [zcl_adapter_floc_create.clas.abap](zcl_adapter_floc_create.clas.abap) | Adapter → `BAPI_FUNCLOC_CREATE` (extensibility example) |
| [zcl_load_adapter_factory.clas.abap](zcl_load_adapter_factory.clas.abap) | **Allowlist** `object_type → adapter` (static dispatch) |
| [zcl_load_src_http.clas.abap](zcl_load_src_http.clas.abap) | Source: HTTP payload |
| [zcl_load_sink_memory.clas.abap](zcl_load_sink_memory.clas.abap) | Sink: in-memory (sync) |
| [zcl_load_sink_applog.clas.abap](zcl_load_sink_applog.clas.abap) | Sink: Application Log `ZLOAD_DYN` |
| [zcl_load_worker.clas.abap](zcl_load_worker.clas.abap) | Worker — BAPI-agnostic, uses adapter for each item |
| [zcl_load_orchestrator.clas.abap](zcl_load_orchestrator.clas.abap) | Chunks input, submits workers to bgPF |
| [zcl_load_http_api.clas.abap](zcl_load_http_api.clas.abap) | HTTP handler (`if_http_service_extension`) |
| [zcl_load_run.clas.abap](zcl_load_run.clas.abap) | Class-Run smoke test |
| [zcl_load_worker.clas.testclasses.abap](zcl_load_worker.clas.testclasses.abap) | Tests: factory + worker + chunking |
| [zcl_load_dto.clas.testclasses.abap](zcl_load_dto.clas.testclasses.abap) | Tests: field lookup helper |

## HTTP Contract

```
POST /load
Content-Type: application/json

{
  "mode": "async",
  "worker_rows": 5000,
  "items": [
    {
      "ext_id": "EQ-001",
      "object_type": "EQUIPMENT",
      "fields": [
        { "name": "equi_category", "value": "M" },
        { "name": "descript",      "value": "100 HP Motor" },
        { "name": "eqtype",        "value": "MECH" },
        { "name": "maintplant",    "value": "1010" }
      ]
    },
    {
      "ext_id": "FL-001",
      "object_type": "FUNC_LOCATION",
      "fields": [
        { "name": "funct_loc",    "value": "FL-AREA-01" },
        { "name": "descript",     "value": "Area 01" },
        { "name": "maintplant",   "value": "1010" }
      ]
    }
  ]
}
```

## Adding a new object type

1. Create `ZCL_ADAPTER_<X>_CREATE` implementing `ZIF_LOAD_ADAPTER`
2. Move the target BAPI call inside `create( )` (see equipment adapter for template)
3. Add `WHEN zcl_adapter_<x>_create=>c_object_type` in `ZCL_LOAD_ADAPTER_FACTORY`
4. Update `supports( )` in the same factory
5. Add a unit test for the new adapter

No changes to the worker, orchestrator, HTTP API or RAP layer.

## RAP variant

See [rap/README.md](rap/README.md) — OData V4 endpoint for Syniti Surge Replicate.
Uses the same adapters and orchestrator.

## Diagram

See [architecture.mmd](architecture.mmd).
