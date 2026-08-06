# Equipment Load — RAP (OData V4 Web API) for Syniti Surge Replicate

Real RAP business object exposing the equipment load workflow as an
**OData V4 Web API**, consumable by external apps (Syniti Surge Replicate).
Reuses the parallel processing layer of the parent HTTP project
(`zcl_equi_load_orchestrator`, `zcl_equi_worker`, sinks, DTO, interfaces).

## Design

- Managed RAP BO with **additional save**.
- Client (Replicate) does a **deep create** of `LoadRequest` + `LoadItem`s.
- Managed runtime persists `ZEQUI_LOAD_REQ` + `ZEQUI_LOAD_ITM`.
- The additional-save handler (`lsc_saver`) reads the persisted items, wraps
  them into `zif_equi_load_source` and calls
  `zcl_equi_load_orchestrator->run( )` which submits chunked workers to bgPF.
- Client polls the request via OData GET to see `Status`, `Workers`,
  `TotalItems`, and per-item `ItemStatus` / `Equipment` / `Message`.

## Objects

| Object | Type | Role |
|---|---|---|
| [zequi_load_req.tabl.xml](zequi_load_req.tabl.xml) | DDIC table | Request header persistence |
| [zequi_load_itm.tabl.xml](zequi_load_itm.tabl.xml) | DDIC table | Request items persistence + BAPI result |
| [zr_equi_load_req.ddls.asddls](zr_equi_load_req.ddls.asddls) | CDS root | Interface layer (root) |
| [zr_equi_load_itm.ddls.asddls](zr_equi_load_itm.ddls.asddls) | CDS child | Interface layer (items) |
| [zc_equi_load_req.ddls.asddls](zc_equi_load_req.ddls.asddls) | CDS projection | Consumption (root) |
| [zc_equi_load_itm.ddls.asddls](zc_equi_load_itm.ddls.asddls) | CDS projection | Consumption (items) |
| [zr_equi_load_req.bdef.asbdef](zr_equi_load_req.bdef.asbdef) | BDEF interface | Managed BO + additional save |
| [zc_equi_load_req.bdef.asbdef](zc_equi_load_req.bdef.asbdef) | BDEF projection | Exposed operations |
| [zbp_r_equi_load_req.clas.abap](zbp_r_equi_load_req.clas.abap) | Behavior pool | Skeleton (implementation in locals) |
| [zbp_r_equi_load_req.clas.locals_imp.abap](zbp_r_equi_load_req.clas.locals_imp.abap) | Local classes | `lhc_load_req` (defaults) + `lsc_saver` (dispatch to bgPF) |
| [zui_equi_load_o4.srvd.asrvd](zui_equi_load_o4.srvd.asrvd) | Service definition | Exposes LoadRequest + LoadItem |
| [zui_equi_load_o4.srvb.srvb](zui_equi_load_o4.srvb.srvb) | Service binding | **ODATA_V4_API** (Web API) |

## OData V4 payload example

`POST /sap/opu/odata4/sap/zui_equi_load_o4/srvd_a2x/sap/zui_equi_load_o4/0001/LoadRequest`

```json
{
  "Mode": "A",
  "WorkerRows": 5000,
  "_Items": [
    {
      "ItemNo": 1,
      "ExtId": "EXT-0001",
      "EquiCategory": "M",
      "Descript": "100 HP Motor",
      "Eqtype": "MECH",
      "Maintplant": "1010",
      "Planplant": "1010",
      "Location": "AREA-01",
      "CostCenter": "10101010",
      "CompanyCode": "1010",
      "StartUpDate": "2025-01-01",
      "Manufacturer": "ACME",
      "ModelNumber": "M100"
    }
  ]
}
```

Response `201 Created` returns the persisted `RequestUuid`, current `Status`
(`R` = Running after save), `TotalItems`, `Workers`.

Poll status:

`GET /LoadRequest(<uuid>)?$expand=_Items`

## Publishing (ADT)

1. Activate `ZEQUI_LOAD_REQ`, `ZEQUI_LOAD_ITM`.
2. Activate the CDS entities (root + child, interface + projection).
3. Activate `ZR_EQUI_LOAD_REQ.bdef`, `ZC_EQUI_LOAD_REQ.bdef`.
4. Activate `ZBP_R_EQUI_LOAD_REQ` (behavior pool + locals).
5. Activate `ZUI_EQUI_LOAD_O4` service definition and binding.
6. Open the Service Binding editor → **Publish** → copy the base URL.
7. Configure a **Communication Arrangement** with an inbound communication
   user; assign the scope to the service binding.
8. Give Replicate the URL + credentials.

## Coexistence with the HTTP handler

Both endpoints coexist and reuse the same orchestrator + workers:

| Consumer style | Endpoint | Handler |
|---|---|---|
| Raw HTTP + JSON | `POST /equi-load` | [zcl_equi_load_http_api.clas.abap](../zcl_equi_load_http_api.clas.abap) |
| OData V4 (Replicate) | `POST /LoadRequest` | This RAP BO |

Same parallel processing layer:
[zcl_equi_load_orchestrator.clas.abap](../zcl_equi_load_orchestrator.clas.abap) →
[zcl_equi_worker.clas.abap](../zcl_equi_worker.clas.abap).
