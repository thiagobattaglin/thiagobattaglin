# BAPI Integration HTTP API v1.1 Implementation

Suggested SAP package: `ZPKG_BAPI_INTEGRATION`.

## Purpose

This package exposes an HTTP service that provides BAPI DDIC metadata and dynamically executes a BAPI for multiple documents. POST requests are split into chunks and processed through `cl_abap_parallel`.

## Request flow

### GET metadata

1. `zcl_http_bapi_integration` receives a GET request.
2. `build_introspector` creates the legacy introspector adapter.
3. `zcl_bapi_integration_builder` requests the BAPI metadata through `zif_bapi_integration_intro`.
4. The builder serializes the result with `xco_cp_json` and returns HTTP `200 OK`.

Required query parameter: `bapi_name`.

### POST execution

1. The HTTP handler reads the JSON request body.
2. `zcl_bapi_integration_dispatch` parses the request with `xco_cp_json`.
3. `resolve_workers` calculates the worker count.
4. `split_documents` partitions documents and serializes each chunk with `EXPORT ... TO DATA BUFFER`.
5. `cl_abap_parallel=>run_inline` invokes `zcl_bapi_integration_parallel` for each chunk.
6. The provider creates `zcl_bapi_integration_exec` and delegates each document to `zif_bapi_integration_executor`.
7. The dispatcher returns JSON with the BAPI name, accepted document count, worker count, and mode.

`sync` returns HTTP `200 OK`. The default `async` mode returns HTTP `202 Accepted`, but `run_inline` still blocks the HTTP request until all workers complete. True fire-and-forget processing requires an additional background processing mechanism and is outside this package.

## Worker calculation

The dispatcher applies these defaults:

- `worker_rows <= 0`: 5,000 documents per worker.
- `worker_threads <= 0`: no explicit worker limit.
- `worker_threads > 0`: maximum number of workers.

For a positive document count:

```text
rows_per_worker = worker_rows if worker_rows > 0 else 5000
needed_workers  = ceil(total_documents / rows_per_worker)
workers         = min(needed_workers, worker_threads) if worker_threads > 0 else needed_workers
```

## Component responsibilities

| Component | Responsibility |
| --- | --- |
| `zcl_http_bapi_integration` | HTTP entry point and composition root |
| `zcl_bapi_integration_builder` | Builds metadata JSON through the introspector interface |
| `zcl_bapi_integration_dispatch` | Parses requests, applies defaults, splits documents, and starts parallel processing |
| `zcl_bapi_integration_parallel` | Implements `if_abap_parallel~do` and composes the execution adapter inside each worker |
| `zcl_bapi_integration_caller` | Iterates through documents and calls the executor interface |
| `zif_bapi_integration_intro` | Metadata discovery contract |
| `zif_bapi_integration_executor` | Single-document execution contract |
| `zcl_bapi_integration_intro` | Legacy DDIC introspection adapter |
| `zcl_bapi_integration_exec` | Legacy dynamic BAPI execution and transaction handling adapter |

## Clean Core boundary

The dispatcher, builder, caller, parallel provider, HTTP handler, and interfaces are the Clean Core portion of the design. Legacy APIs are isolated behind the two interfaces:

- `FUNCTION_IMPORT_INTERFACE` and `DDIF_FIELDINFO_GET` are used by the introspector adapter.
- Dynamic `CALL FUNCTION ... PARAMETER-TABLE` and BAPI commit/rollback are used by the executor adapter.

For pure ABAP Cloud, replace the two adapters at the composition points with implementations based on released BAPI whitelists and RAP/EML. The core processing flow does not need to change.

## Deployment prerequisites

1. Activate the two interfaces.
2. Activate the legacy adapters.
3. Activate the caller, builder, parallel provider, and dispatcher.
4. Activate `zcl_http_bapi_integration`.
5. Create an HTTP service pointing to `ZCL_HTTP_BAPI_INTEGRATION`.
6. Allow the service through the applicable HTTP allowlist configuration.
7. Configure the RFC server group used by `cl_abap_parallel`.

The file `z_bapi_integration_worker.fugr.abap` is retained only as a deprecated stub. It must not be used for the v1.1 execution path.

## Example payloads

- [`input.json`](./input.json) is a POST request example.
- [`metadata-ex.json`](./metadata-ex.json) is a GET response example.

The architecture diagram is available in [`architecture.mmd`](./architecture.mmd).
