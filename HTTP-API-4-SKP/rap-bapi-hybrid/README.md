# rap-bapi-hybrid — melhor combinação (streaming + CTF) com correções Clean Core

Variante final do RAP Dynamic BAPI Runner. Combina o **dispatcher sem
parse do payload inteiro** (Projeto 1) com o **parser kernel-side**
(Projeto 2) e substitui o **STARTING NEW TASK** por **bgPF**
(Background Processing Framework — `cl_bgmc_process_factory`).

Base: [../rap-bapi-dynamic/README.md](../rap-bapi-dynamic/README.md) ·
inspirações: [../rap-bapi-streaming/](../rap-bapi-streaming/README.md) ·
[../rap-bapi-ctf/](../rap-bapi-ctf/README.md).

**Guia de implementação:** [PT-BR](./IMPLEMENTATION-GUIDE.md) · [EN](./IMPLEMENTATION-GUIDE-EN.md)

## O que muda vs. cada peça de origem

| Ponto | Projeto 1 (streaming) | Projeto 2 (CTF) | **Hybrid** |
|---|---|---|---|
| Deserialize do payload no dispatcher | scan escalar manual | payload inteiro (CTF) | **substring de header + CTF** — só bytes do cabeçalho |
| `/ui2/cl_json` | ainda no worker | zero | **zero em qualquer lugar** |
| Split de `documents[]` | lexical | doc-por-doc via RTTI | **lexical isolado em [zcl_bapi_hyb_lex_splitter](./zcl_bapi_hyb_lex_splitter.clas.abap)** |
| Serialize de chunks | não faz | faz (kernel) | **não faz** |
| Deserialize no worker | `/ui2/cl_json` do chunk | CTF do chunk | **CTF do chunk (released)** |
| Async dispatch | `STARTING NEW TASK` | `STARTING NEW TASK` | **bgPF (`cl_bgmc_process_factory`)** |
| Chaves de tabelas grandes | `WITH EMPTY KEY` | `WITH EMPTY KEY` | `WITH EMPTY KEY` |
| Timestamps | DEC 21,7 | DEC 21,7 | **UTCLONG** |

## Fluxo

```
POST Submit ─► lhc_bapi_hyb_run
                 │
                 │ parse_header  (CTF id em substring "só cabeçalho")
                 ▼
             zcl_bapi_hyb_dispatcher
                 │
                 ├── kind = chunk  ─► 1 chunk (o próprio payload)
                 │
                 └── kind = bulk   ─► zcl_bapi_hyb_lex_splitter (O(strlen))
                                      │
                                      ▼
                                    chunks [{doc},{doc},...]

                 ▼
             cl_bgmc_process_factory
             .create( ).set_transactional_process( zcl_bapi_hyb_worker_op )
             .save_for_execution( )   (COMMIT WORK vem do save do RAP)

                 ▼
             zcl_bapi_hyb_worker_op        (executa em LUW separada)
                 │
                 ▼
             zcl_bapi_hyb_caller
                 │
                 │ zcl_bapi_hyb_json_parser=>deserialize (CTF id)
                 ▼
             CALL FUNCTION mv_bapi_name PARAMETER-TABLE ...
             BAPI_TRANSACTION_COMMIT / ROLLBACK  (por documento)
```

## Correções Clean Core aplicadas

| Ponto crítico | Solução | Status |
|---|---|---|
| `/ui2/cl_json` em qualquer lugar | Único helper [zcl_bapi_hyb_json_parser](./zcl_bapi_hyb_json_parser.clas.abap) com `cl_sxml_string_reader` + `CALL TRANSFORMATION id` | ✅ corrigido |
| `STARTING NEW TASK DESTINATION IN GROUP DEFAULT` | bgPF (`cl_bgmc_process_factory`) + `if_bgmc_op_single_tx_uncontrolled` em [zcl_bapi_hyb_worker_op](./zcl_bapi_hyb_worker_op.clas.abap) | ✅ corrigido |
| Timestamps DEC 21,7 | UTCLONG na tabela de auditoria | ✅ corrigido |
| Parser artesanal espalhado | Isolado e testado em [zcl_bapi_hyb_lex_splitter](./zcl_bapi_hyb_lex_splitter.clas.abap) | ✅ mitigado |
| `FUNCTION_IMPORT_INTERFACE` + `CALL FUNCTION <dyn>` | Mantidos — são a **razão de existir** do runner dinâmico | ⚠️ **exige on-premise / embedded Steampunk / private cloud**. Não é released no ABAP Cloud público |
| BAPIs clássicas + `BAPI_TRANSACTION_COMMIT` | Mantidos pelo mesmo motivo | ⚠️ mesma restrição acima |

Para rodar em **ABAP Cloud público** o único caminho seria trocar a
introspecção dinâmica por uma **whitelist de BAPIs released** e mapping
declarativo — o que descaracteriza o objetivo do runner "aceita
qualquer BAPI". Nesse cenário a recomendação é usar **API-based
extensibility** com o serviço concreto liberado (ex.:
`API_PURCHASEORDER_PROCESS_SRV`).

## Endpoint

```
POST /sap/opu/odata4/sap/zui_bapi_hyb_run_o4/srvd_a2x/sap/zui_bapi_hyb_run_o4/0001/BapiRun/com.sap.gateway.srvd_a2x.zui_bapi_hyb_run_o4.v0001.Submit
Content-Type: application/json

{ "Payload": "{\"bapi_name\":\"BAPI_PO_CREATE1\",\"kind\":\"bulk\",\"worker_threads\":4,\"worker_rows\":100,\"documents\":[...]}" }
```

### GET metadata

`GetMetadata` é uma **static function** RAP (GET-callable) com resultado
`[0..*]` — devolve uma **coleção OData estruturada**, uma linha por
campo DDIC da BAPI, sem JSON escapado em string.

```
GET /sap/opu/odata4/sap/zui_bapi_hyb_run_o4/srvd_a2x/sap/zui_bapi_hyb_run_o4/0001/BapiRun/com.sap.gateway.srvd_a2x.zui_bapi_hyb_run_o4.v0001.GetMetadata(BapiName='BAPI_PO_CREATE1')
```

Resposta (formato):

```json
{
  "documents": [
    {
      "headers_values": [
        {
          "value": "POHEADER",
          "fields": [
            { "name": "DOC_TYPE", "type": "char4" },
            { "name": "VENDOR", "type": "char10" },
            { "name": "PURCH_ORG", "type": "char4" }
          ]
        }
      ],
      "items_values": [
        {
          "value": "POITEM",
          "fields": [
            { "name": "PO_ITEM", "type": "numc5" },
            { "name": "MATERIAL", "type": "char18" },
            { "name": "QUANTITY", "type": "quantum13.3" }
          ]
        }
      ]
    }
  ]
}
```

`headers_values` representa os parâmetros de IMPORT/estrutura (ex.: `POHEADER`).
`items_values` representa as tabelas/linhas (ex.: `POITEM`).

Esse é o formato solicitado no contrato original, e não a coleção plana do `ZD_BAPI_HYB_META`.

O documento OData `$metadata` (EDMX) continua disponível em

```
GET /sap/opu/odata4/sap/zui_bapi_hyb_run_o4/srvd_a2x/sap/zui_bapi_hyb_run_o4/0001/$metadata
```

## Componentes

| Arquivo | Papel |
|---|---|
| [zcl_bapi_hyb_json_parser.clas.abap](./zcl_bapi_hyb_json_parser.clas.abap) | Único ponto de JSON ↔ ABAP (kernel CTF) |
| [zcl_bapi_hyb_lex_splitter.clas.abap](./zcl_bapi_hyb_lex_splitter.clas.abap) | Split lexical de `documents[]` (O(n), isolado, testado) |
| [zcl_bapi_hyb_dispatcher.clas.abap](./zcl_bapi_hyb_dispatcher.clas.abap) | Trim de header + parse via CTF + split + dispatch |
| [zcl_bapi_hyb_worker_op.clas.abap](./zcl_bapi_hyb_worker_op.clas.abap) | Unidade de execução bgPF (`if_bgmc_op_single_tx_uncontrolled`) |
| [zcl_bapi_hyb_caller.clas.abap](./zcl_bapi_hyb_caller.clas.abap) | Deserialize por chunk + introspecção + BAPI call |
| [zbapi_hyb_run.tabl.xml](./zbapi_hyb_run.tabl.xml) | Tabela de auditoria (UTCLONG) |
| [zr_bapi_hyb_run.ddls.asddls](./zr_bapi_hyb_run.ddls.asddls) | Root view |
| [zc_bapi_hyb_run.ddls.asddls](./zc_bapi_hyb_run.ddls.asddls) | Projection view |
| [zr_bapi_hyb_run.bdef.asbdef](./zr_bapi_hyb_run.bdef.asbdef) | Behavior definition |
| [zc_bapi_hyb_run.bdef.asbdef](./zc_bapi_hyb_run.bdef.asbdef) | Behavior projection |
| [zbp_r_bapi_hyb_run.clas.abap](./zbp_r_bapi_hyb_run.clas.abap) | Behavior pool |
| [zbp_r_bapi_hyb_run.clas.locals_imp.abap](./zbp_r_bapi_hyb_run.clas.locals_imp.abap) | Handler da action Submit |
| [zd_bapi_hyb_in.ddls.asddls](./zd_bapi_hyb_in.ddls.asddls) / [zd_bapi_hyb_out.ddls.asddls](./zd_bapi_hyb_out.ddls.asddls) | Abstract entities |
| [zd_bapi_hyb_meta.ddls.asddls](./zd_bapi_hyb_meta.ddls.asddls) | Abstract entity - resultado de `GetMetadata` (GET) |
| [zui_bapi_hyb_run_o4.srvd.asrvd](./zui_bapi_hyb_run_o4.srvd.asrvd) / [.srvb.srvb](./zui_bapi_hyb_run_o4.srvb.srvb) | Service definition + binding |
| [architecture.mmd](./architecture.mmd) | Diagrama Mermaid |
| [zcl_bapi_hyb_dispatcher.clas.testclasses.abap](./zcl_bapi_hyb_dispatcher.clas.testclasses.abap) | Unit tests (header trim + split + dispatch stub) |

## Nota sobre bgPF e o commit

`cl_bgmc_process_factory=>...->save_for_execution( )` **agenda** o
processo. Ele só é despachado após o `COMMIT WORK` do LUW atual. Como o
handler roda dentro do RAP save sequence, o commit final da action
(feito pelo framework RAP) já libera todos os processos agendados de
uma vez. Nada precisa de `COMMIT WORK` manual.
