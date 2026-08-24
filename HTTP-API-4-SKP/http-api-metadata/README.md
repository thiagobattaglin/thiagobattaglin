# HTTP API — BAPI Metadata

Serviço HTTP RESTful em ABAP que devolve a **estrutura DDIC de qualquer
BAPI clássica** em um JSON aninhado, exatamente no formato de
[`metadata-ex.json`](./metadata-ex.json).

É a alternativa **sem RAP** do `GetMetadata` que existe em
[`../rap-bapi-hybrid/`](../rap-bapi-hybrid/README.md): 2 classes,
zero CDS, zero behavior definition, resposta HTTP direta sem envelope
OData e sem string escapada.

## Endpoint

```
GET /sap/bc/http/sap/zbapi_meta?bapi_name=BAPI_PO_CREATE1
```

O path exato depende do node HTTP Service (ADT wizard *New Repository
Object → HTTP Service*) criado apontando para `zcl_http_bapi_meta`.

## Resposta

Mesmo shape de [`metadata-ex.json`](./metadata-ex.json):

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

- `headers_values` = parâmetros `IMPORT` da BAPI tipados contra uma
  estrutura DDIC (`POHEADER`, `POHEADERX`, `POADDRVENDOR` …).
- `items_values` = parâmetros `TABLES` da BAPI (line type = estrutura
  DDIC — `POITEM`, `POACCOUNT`, `POCOND`, `RETURN` …).
- `fields[].type` é derivado de `DDIF_FIELDINFO_GET` (`char`, `numc`,
  `dec`, `quan`, `dats`, `tims`, `lang`, `cuky`, `fltp`, `accp`,
  `int4`, `unit` …); `length`, `size` e `decimal` carregam as dimensões
  do campo.

## Códigos HTTP

| Código | Cenário |
|---|---|
| `200 OK` | BAPI encontrada, JSON gerado |
| `400 Bad Request` | `bapi_name` ausente / BAPI não existe |
| `405 Method Not Allowed` | verbo diferente de `GET` |

## Componentes

| Arquivo | Papel |
|---|---|
| [zcl_http_bapi_meta.clas.abap](./zcl_http_bapi_meta.clas.abap) | Handler HTTP (`if_http_service_extension`) — lê `bapi_name`, chama o builder, devolve o JSON |
| [zcl_http_bapi_meta_builder.clas.abap](./zcl_http_bapi_meta_builder.clas.abap) | Introspecção (`FUNCTION_IMPORT_INTERFACE` + `DDIF_FIELDINFO_GET`) e montagem do JSON aninhado |
| [metadata-ex.json](./metadata-ex.json) | Exemplo do formato de resposta |

## Ativação / Publicação no SICF

1. Ativar `zcl_http_bapi_meta_builder`.
2. Ativar `zcl_http_bapi_meta`.
3. Abrir transação `SICF`.
4. Navegar até o nó `/sap/bc/http/sap`.
5. Criar um novo serviço com o nome `zbapi_meta`.
6. No campo de handler, apontar para a classe `ZCL_HTTP_BAPI_META`.
7. Salvar o nó.
8. Ativar o serviço no SICF.
9. Verificar se o path final fica assim:

   ```
   /sap/bc/http/sap/zbapi_meta
   ```

10. Ajustar autenticação conforme o ambiente de teste.
11. Testar no navegador, Postman, Insomnia ou curl:

   ```
   GET https://<host>:<port>/sap/bc/http/sap/zbapi_meta?bapi_name=BAPI_PO_CREATE1
   ```

### Alternativa via ADT

Se preferir criar pelo ADT:

1. `New` → `Other ABAP Repository Object` → `HTTP Service`
2. definir o nome do serviço, por exemplo `ZBAPI_META`
3. apontar para a classe `ZCL_HTTP_BAPI_META`
4. salvar e ativar

### Observação importante

O SICF funciona como registro do endpoint HTTP no ICF. Sem o nó ativo e
publicado, a classe existe, mas o serviço não estará acessível pela URL.

## Diferença vs. `rap-bapi-hybrid/GetMetadata`

| Aspecto | RAP `GetMetadata` | Este HTTP Service |
|---|---|---|
| Objetos ABAP | ~15 (CDS, behavior, service binding, pool …) | **2 classes** |
| CDS abstract entities | 2 | **0** |
| Envelope OData | `{"value":[{"BapiName":"…","Metadata":"…escaped…"}]}` | JSON puro no shape final |
| Cliente precisa `JSON.parse` extra da string interna | sim | **não** |
| Verbo | GET (function OData V4) | GET nativo HTTP |
| Autenticação / CORS | via service binding | via HTTP Service node |
| Depende de `array of` no CDS | sim (se quiser aninhamento OData) | **não** |
| Cabe em ABAP Cloud público | não (usa APIs não released) | não (mesma restrição) |
| Cabe em on-premise / embedded Steampunk / private cloud | sim | sim |

## Clean Core

`FUNCTION_IMPORT_INTERFACE` e `DDIF_FIELDINFO_GET` **não são released**
para ABAP Cloud público. Este serviço tem a mesma restrição do
`rap-bapi-hybrid`: destinado a on-premise, embedded Steampunk ou
private cloud. Para ABAP Cloud público a alternativa é whitelist de
BAPIs released + mapping declarativo (perde o "qualquer BAPI").
