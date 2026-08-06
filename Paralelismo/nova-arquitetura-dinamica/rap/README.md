# Dynamic Load — RAP OData V4 (Syniti Surge Replicate)

RAP Business Object exposing the dynamic multi-BAPI load as an OData V4
Web API. Reuses the adapter pattern from the parent folder.

## Design

- Client (Replicate) posts a `LoadRequest` with a nested list of `_Items`.
- Each item carries `ObjectType` and `FieldsJson` (JSON serialization of
  the field name/value list).
- Managed RAP BO with **additional save** persists the request + items in
  `ZLOAD_REQ` / `ZLOAD_ITM`.
- The `lsc_saver` reads the persisted items, deserializes `FieldsJson` into
  `zcl_load_dto=>ty_input` (with the `object_type`) and calls the
  orchestrator, which dispatches bgPF workers.
- Each worker calls `zcl_load_adapter_factory=>get( object_type )` per
  item and delegates to the adapter.
- Client polls `LoadRequest(uuid)?$expand=_Items` for progress.

## Objects

| Object | Role |
|---|---|
| [zload_req.tabl.xml](zload_req.tabl.xml) | Request header table |
| [zload_itm.tabl.xml](zload_itm.tabl.xml) | Items table (with `OBJECT_TYPE` + `FIELDS_JSON`) |
| [zr_load_req.ddls.asddls](zr_load_req.ddls.asddls) / [zr_load_itm.ddls.asddls](zr_load_itm.ddls.asddls) | CDS interface (root + child) |
| [zc_load_req.ddls.asddls](zc_load_req.ddls.asddls) / [zc_load_itm.ddls.asddls](zc_load_itm.ddls.asddls) | CDS projection |
| [zr_load_req.bdef.asbdef](zr_load_req.bdef.asbdef) | Behavior interface (managed with additional save) |
| [zc_load_req.bdef.asbdef](zc_load_req.bdef.asbdef) | Behavior projection |
| [zbp_r_load_req.clas.abap](zbp_r_load_req.clas.abap) + [zbp_r_load_req.clas.locals_imp.abap](zbp_r_load_req.clas.locals_imp.abap) | Behavior pool + local handlers (`lhc_load_req`, `lsc_saver`) |
| [zui_load_o4.srvd.asrvd](zui_load_o4.srvd.asrvd) / [zui_load_o4.srvb.srvb](zui_load_o4.srvb.srvb) | Service definition + binding (ODATA_V4_API) |
| [zbp_r_load_req.clas.testclasses.abap](zbp_r_load_req.clas.testclasses.abap) | Behavior unit tests |

## OData V4 payload example

`POST .../LoadRequest`

```json
{
  "Mode": "A",
  "WorkerRows": 5000,
  "_Items": [
    {
      "ItemNo": 1,
      "ExtId": "EQ-001",
      "ObjectType": "EQUIPMENT",
      "FieldsJson": "[{\"name\":\"equi_category\",\"value\":\"M\"},{\"name\":\"descript\",\"value\":\"100 HP Motor\"},{\"name\":\"maintplant\",\"value\":\"1010\"}]"
    },
    {
      "ItemNo": 2,
      "ExtId": "FL-001",
      "ObjectType": "FUNC_LOCATION",
      "FieldsJson": "[{\"name\":\"funct_loc\",\"value\":\"FL-AREA-01\"},{\"name\":\"descript\",\"value\":\"Area 01\"}]"
    }
  ]
}
```

Polling: `GET .../LoadRequest(<uuid>)?$expand=_Items`

## Ordem de ativação

1. Tabelas `ZLOAD_REQ`, `ZLOAD_ITM`
2. CDS interface (root, depois child)
3. CDS projection (root, depois child)
4. BDEF interface, BDEF projection
5. Behavior Pool `ZBP_R_LOAD_REQ` (main + locals)
6. Service Definition + Service Binding → Publish
7. Communication Arrangement (usuário inbound + scope)

> Todos os adapters e o orchestrator do parent folder devem estar ativos
> **antes** do behavior pool, pois o `lsc_saver` depende deles.
