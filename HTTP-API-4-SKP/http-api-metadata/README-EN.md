# HTTP API - BAPI Metadata

RESTful HTTP service in ABAP that returns the **DDIC structure of any classic BAPI** as nested JSON, exactly in the format of [`metadata-ex.json`](./metadata-ex.json).

It is the **RAP-free** alternative to the `GetMetadata` implementation in [`../rap-bapi-hybrid/`](../rap-bapi-hybrid/README.md): 2 classes, no CDS, no behavior definition, direct HTTP response without an OData envelope or an escaped JSON string.

## Endpoint

```
GET /sap/bc/http/sap/zbapi_meta?bapi_name=BAPI_PO_CREATE1
```

The exact path depends on the HTTP Service node created with the ADT wizard *New Repository Object -> HTTP Service*, pointing to `zcl_http_bapi_meta`.

## Response

The response follows the same shape as [`metadata-ex.json`](./metadata-ex.json):

```json
{
  "bapi_name": "BAPI_PO_CREATE1",
  "documents": [
    {
      "headers_values": [
        {
          "structure": "POHEADER",
          "fields": [
            { "name": "DOC_TYPE",  "type": "char", "length": 2, "size": 2, "decimal": 0 },
            { "name": "VENDOR",    "type": "char", "length": 10, "size": 10, "decimal": 0 }
          ]
        }
      ],
      "items_values": [
        {
          "table": "POITEM",
          "fields": [
            { "name": "PO_ITEM",  "type": "numc", "length": 5, "size": 5, "decimal": 0 },
            { "name": "MATERIAL", "type": "char", "length": 18, "size": 18, "decimal": 0 },
            { "name": "QUANTITY", "type": "quan", "length": 13, "size": 13, "decimal": 3 }
          ]
        }
      ]
    }
  ]
}
```

- `headers_values` = BAPI `IMPORT` parameters typed against a DDIC structure (`POHEADER`, `POHEADERX`, `POADDRVENDOR`, etc.).
- `items_values` = BAPI `TABLES` parameters (line type is a DDIC structure such as `POITEM`, `POACCOUNT`, `POCOND`, or `RETURN`).
- `fields[].type` is derived from `DDIF_FIELDINFO_GET` (`char`, `numc`, `dec`, `quan`, `dats`, `tims`, `lang`, `cuky`, `fltp`, `accp`, `int4`, `unit`, etc.). The field dimensions are provided by `length`, `size`, and `decimal`.

## HTTP Status Codes

| Code | Scenario |
|---|---|
| `200 OK` | BAPI found and JSON generated |
| `400 Bad Request` | `bapi_name` is missing or the BAPI does not exist |
| `405 Method Not Allowed` | HTTP method is different from `GET` |

## Components

| File | Purpose |
|---|---|
| [zcl_http_bapi_meta.clas.abap](./zcl_http_bapi_meta.clas.abap) | HTTP handler (`if_http_service_extension`) - reads `bapi_name`, calls the builder, and returns the JSON |
| [zcl_http_bapi_meta_builder.clas.abap](./zcl_http_bapi_meta_builder.clas.abap) | Introspection (`FUNCTION_IMPORT_INTERFACE` + `DDIF_FIELDINFO_GET`) and nested JSON assembly |
| [metadata-ex.json](./metadata-ex.json) | Response format example |

## Activation / Publication in SICF

1. Activate `zcl_http_bapi_meta_builder`.
2. Activate `zcl_http_bapi_meta`.
3. Open transaction `SICF`.
4. Navigate to the `/sap/bc/http/sap` node.
5. Create a new service named `zbapi_meta`.
6. Set `ZCL_HTTP_BAPI_META` as the handler class.
7. Save the node.
8. Activate the service in SICF.
9. Verify that the final path is:

   ```
   /sap/bc/http/sap/zbapi_meta
   ```

10. Configure authentication according to the test environment.
11. Release the service in transaction `UCON_HTTP_SERVICES` (UCON HTTP Allowlist Scenario). Without this release, the service returns `403 Forbidden` even when the SICF node is active:
    - open `UCON_HTTP_SERVICES`
    - locate the `zbapi_meta` service or the full path `/sap/bc/http/sap/zbapi_meta`
    - mark it as *Active* / *Released* in the HTTP Allowlist scenario
    - save and activate
12. Test it in a browser, Postman, Insomnia, or curl:

   ```
   GET https://<host>:<port>/sap/bc/http/sap/zbapi_meta?bapi_name=BAPI_PO_CREATE1
   ```

### ADT Alternative

To create the service through ADT:

1. Select `New` -> `Other ABAP Repository Object` -> `HTTP Service`.
2. Define the service name, for example `ZBAPI_META`.
3. Point it to the `ZCL_HTTP_BAPI_META` class.
4. Save and activate.

### Important Note

SICF registers the HTTP endpoint in the ICF. Without an active and published node, the class exists but the service cannot be accessed through the URL.

In S/4HANA, the UCON HTTP Allowlist (`UCON_HTTP_SERVICES`) is an additional authorization layer. If the service is not released there, the gateway returns `403 Forbidden` even when the SICF node is active.

## Difference from `rap-bapi-hybrid/GetMetadata`

| Aspect | RAP `GetMetadata` | This HTTP Service |
|---|---|---|
| ABAP objects | Approximately 15 (CDS, behavior, service binding, pool, etc.) | **2 classes** |
| CDS abstract entities | 2 | **0** |
| OData envelope | `{"value":[{"BapiName":"...","Metadata":"...escaped..."}]}` | Plain JSON in the final shape |
| Client needs an additional `JSON.parse` for the inner string | Yes | **No** |
| HTTP method | GET (OData V4 function) | Native HTTP GET |
| Authentication / CORS | Through service binding | Through the HTTP Service node |
| Depends on `array of` in CDS | Yes, if nested OData is required | **No** |
| Works in public ABAP Cloud | No, uses unreleased APIs | No, same restriction |
| Works on on-premise / embedded Steampunk / private cloud | Yes | Yes |

## Clean Core

`FUNCTION_IMPORT_INTERFACE` and `DDIF_FIELDINFO_GET` are **not released** for public ABAP Cloud. This service has the same restriction as `rap-bapi-hybrid` and is intended for on-premise, embedded Steampunk, or private cloud environments. For public ABAP Cloud, the alternative is a whitelist of released BAPIs with declarative mapping, which does not support arbitrary BAPIs.
