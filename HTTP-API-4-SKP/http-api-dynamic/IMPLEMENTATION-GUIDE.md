# Guia de Implementação — HTTP API Dynamic BAPI Runner

Guia passo a passo para publicar o serviço em um sistema **SAP S/4HANA on-premise** ou **ABAP Environment (Steampunk private)**.

---

## Sumário

1. [Pré-requisitos](#1-pré-requisitos)
2. [Ordem de criação dos objetos](#2-ordem-de-criação-dos-objetos)
3. [Passo 1 — Pacote e transporte](#3-passo-1--pacote-e-transporte)
4. [Passo 2 — Function Group + FM RFC (worker)](#4-passo-2--function-group--fm-rfc-worker)
5. [Passo 3 — Classes ABAP](#5-passo-3--classes-abap)
6. [Passo 4 — Exposição HTTP](#6-passo-4--exposição-http)
7. [Passo 5 — Server Group RFC (paralelismo)](#7-passo-5--server-group-rfc-paralelismo)
8. [Passo 6 — Autorizações](#8-passo-6--autorizações)
9. [Passo 7 — Testes (ATC, ADT, Postman)](#9-passo-7--testes-atc-adt-postman)
10. [Passo 8 — Observabilidade / Logs](#10-passo-8--observabilidade--logs)
11. [Passo 9 — Tuning e capacidade](#11-passo-9--tuning-e-capacidade)
12. [Anexo A — Payload de exemplo (Postman/cURL)](#12-anexo-a--payload-de-exemplo-postmancurl)
13. [Anexo B — Troubleshooting](#13-anexo-b--troubleshooting)
14. [Anexo C — Checklist final](#14-anexo-c--checklist-final)

---

## 1. Pré-requisitos

| Item | Requisito |
|---|---|
| Release | SAP_BASIS 7.55+ (on-premise) ou ABAP Environment (Steampunk) |
| ADT | Eclipse com ABAP Development Tools instalado |
| Autorizações usuário dev | `S_DEVELOP`, `S_ICF_ADM`, `S_RFC`, `S_TCODE` (SICF, SE37, SE80, RZ12) |
| JSON lib | `/UI2/CL_JSON` disponível |
| BAPI alvo | Existente e RFC-enabled; ex.: `BAPI_PO_CREATE1` |
| Server group | Um grupo RFC configurado em `RZ12` (opcional, mas recomendado) |

Verifique se `/UI2/CL_JSON` existe:
```
SE24 → /UI2/CL_JSON
```
Se ausente, aplicar SAP Note **1648418** ou usar `xco_cp_json` (Steampunk).

---

## 2. Ordem de criação dos objetos

```mermaid
flowchart LR
    A[Pacote ZBAPI_DYN] --> B[Function Group Z_BAPI_DYN_WORKER]
    B --> C[Classe zcl_bapi_dyn_caller]
    C --> D[Classe zcl_bapi_dyn_dispatcher]
    D --> E[Classe zcl_http_bapi_dyn]
    E --> F[ICF Node / HTTP Service Binding]
    F --> G[Server Group RZ12]
```

Motivo: cada objeto abaixo referencia os anteriores. Ativar de baixo para cima evita erros de sintaxe transitórios.

---

## 3. Passo 1 — Pacote e transporte

1. `SE80` → **Create → Package** → `ZBAPI_DYN`
   - Software Component: `HOME` (ou customer namespace)
   - Application component: `CA-GTF`
   - Transport Layer: conforme sua landscape
2. Criar Transport Request (workbench) para agrupar todos os objetos.

> Para desenvolvimento local rápido, use `$TMP` (não transportável).

---

## 4. Passo 2 — Function Group + FM RFC (worker)

### 4.1 Criar Function Group

`SE80` → botão direito no pacote → **Create → Function Group** → `Z_BAPI_DYN_WORKER`.

### 4.2 Criar o Function Module

`SE37` → **Create** → `Z_BAPI_DYN_WORKER` no grupo `Z_BAPI_DYN_WORKER`.

**Aba Attributes** → marcar **Remote-Enabled Module** (obrigatório para `STARTING NEW TASK`).

**Aba Import:**

| Parameter | Type | Pass Value | Optional | Default |
|---|---|---|---|---|
| `IV_BAPI_NAME` | `STRING` | ✓ | | |
| `IV_MODE` | `STRING` | ✓ | ✓ | `'async'` |
| `IV_CHUNK` | `STRING` | ✓ | | |

**Aba Source Code:** colar o conteúdo de [z_bapi_dyn_worker.fugr.abap](thiagobattaglin/http-api-dynamic/z_bapi_dyn_worker.fugr.abap) (apenas o corpo entre `FUNCTION`/`ENDFUNCTION`).

Salvar + Ativar. O FM ainda vai referenciar as classes que serão criadas no passo 5 — a ativação final será feita após.

---

## 5. Passo 3 — Classes ABAP

Criar as classes na **ordem exata** abaixo (dependências: dispatcher usa caller apenas em runtime via FM; caller usa tipos do dispatcher).

### 5.1 `zcl_bapi_dyn_dispatcher` (primeiro — expõe os TYPES)

ADT → New ABAP Class → nome `zcl_bapi_dyn_dispatcher` → pacote `ZBAPI_DYN`.
Colar o conteúdo de [zcl_bapi_dyn_dispatcher.clas.abap](thiagobattaglin/http-api-dynamic/zcl_bapi_dyn_dispatcher.clas.abap).

Criar o include de testes: no ADT, botão direito na classe → **New → Test Class Include**.
Colar o conteúdo de [zcl_bapi_dyn_dispatcher.clas.testclasses.abap](thiagobattaglin/http-api-dynamic/zcl_bapi_dyn_dispatcher.clas.testclasses.abap).

Salvar. **Não ativar ainda** (referencia `Z_BAPI_DYN_WORKER`, que já existe do passo 4).
Ativar agora: `Ctrl+F3`. Se aparecer warning sobre `DESTINATION IN GROUP`, apenas ative.

### 5.2 `zcl_bapi_dyn_caller`

ADT → New ABAP Class → `zcl_bapi_dyn_caller`.
Colar [zcl_bapi_dyn_caller.clas.abap](thiagobattaglin/http-api-dynamic/zcl_bapi_dyn_caller.clas.abap).
Ativar.

### 5.3 `zcl_http_bapi_dyn`

ADT → New ABAP Class → `zcl_http_bapi_dyn`.
Colar [zcl_http_bapi_dyn.clas.abap](thiagobattaglin/http-api-dynamic/zcl_http_bapi_dyn.clas.abap).
Ativar.

### 5.4 Ativar o FM do passo 4

Voltar em `SE37` → `Z_BAPI_DYN_WORKER` → Ativar (agora que `zcl_bapi_dyn_dispatcher` e `zcl_bapi_dyn_caller` existem).

---

## 6. Passo 4 — Exposição HTTP

Objetivo: publicar a classe `zcl_http_bapi_dyn` como endpoint HTTP acessível
por clientes externos (Postman, aplicações web, integrações).

### 6.1 Escolha da stack

| Stack / Release | Recomendação |
|---|---|
| S/4HANA 1909+ (SAP_BASIS 7.54+) on-premise | Opção A — HTTP Service (nativa) |
| S/4HANA 1809 / ECC / SAP_BASIS ≤ 7.53 | Opção B — Nó SICF clássico |
| ABAP Environment (Steampunk público / privado) | Opção A — HTTP Service (nativa) |

`zcl_http_bapi_dyn` já implementa `if_http_service_extension`, que é a
interface usada pela Opção A. Para a Opção B é necessário um wrapper com
`if_http_extension`.

---

### 6.2 Opção A — HTTP Service (S/4HANA 7.54+ e Steampunk)

> **Importante — esclarecimento sobre Service Binding:**
> Handlers HTTP puros (`if_http_service_extension`) **NÃO** usam Service Binding.
> Service Binding é obrigatório apenas para serviços **RAP/OData** (CDS entities).
> Nesta arquitetura o único artefato necessário é a **HTTP Service** (`.srvd`),
> que já contém a referência à handler class.

#### 6.2.1 Pré-condição: a handler class deve estar ativa e sem erros

Antes de criar o HTTP Service, valide que `zcl_http_bapi_dyn`:

- Está **ativa** (sem `*` no nome no Project Explorer)
- Implementa `if_http_service_extension` (não `if_http_extension`)
- Compila sem erros — abra a classe e faça `Ctrl+F2` (Check)

Se a classe não estiver perfeita, o HTTP Service falha silenciosamente na
ativação e o nó ICF nunca é criado.

#### 6.2.2 Criar o HTTP Service (artefato único)

1. Eclipse com ADT conectado.
2. `Project Explorer` → botão direito no pacote `ZBAPI_DYN` → **New → Other ABAP Repository Object**.
3. Filtrar por **`HTTP Service`** (categoria *Connectivity*) → **Next**.
4. Preencher:
   - **Name**: `ZBAPI_DYN_SRV`
   - **Description**: `Dynamic BAPI Runner`
   - **Package**: `ZBAPI_DYN`
   - **Transport**: workbench ou `$TMP`
   - **Handler Class**: `ZCL_HTTP_BAPI_DYN` ← preencher **já nessa tela**
5. **Next → Finish**.

Se o wizard não pedir a Handler Class, o editor abre com o corpo em branco.
Cole exatamente isto (case sensitive, sem aspas):

```abap
@EndUserText.label : 'Dynamic BAPI Runner'
service definition ZBAPI_DYN_SRV
  handler class zcl_http_bapi_dyn;
```

Salvar (`Ctrl+S`) e **ativar** (`Ctrl+F3`).

> Se aparecer erro *"Handler class not found"*: a classe não está ativa. Volte, ative a classe primeiro, depois reative o HTTP Service.

#### 6.2.3 Consulta da URL gerada

Com o HTTP Service ativo, a URL é gerada automaticamente. Para descobrir:

- **ADT**: com o `.srvd` aberto, clique no ícone de link/globo na barra de ferramentas do editor. Copia a URL.
- **Alternativa via tabela**: `SE16` → tabela `ICFSERVICE` → filtrar `ICF_NAME = ZBAPI_DYN_SRV`.

URL típica:

```
/sap/bc/http/sap/zbapi_dyn_srv
```

#### 6.2.4 Ativar o nó em SICF (por cliente)

O HTTP Service registra o nó em `ICFSERVICE` **cross-client**, mas cada cliente precisa **ativar** manualmente para responder requisições:

1. Logar no cliente que vai expor a API (ex.: 100).
2. Transação `SICF`.
3. `Hierarchy Type` = `SERVICE` → **Execute** (`F8`).
4. `Ctrl+F` para procurar `zbapi_dyn_srv` na árvore.
5. Botão direito no nó → **Activate Service** → confirmar.
6. Ícone do nó fica **azul** (ativo).

Se o nó **não aparece na árvore** mesmo com o HTTP Service ativo:

- `F5` para refresh da árvore
- `SMICM` → *Administration → ICM → Cache → Invalidate Globally*
- Verifique na tabela `ICFSERVICE` (passo 6.2.3) — se está lá mas não aparece em SICF, é problema de cache/autorização
- Se **não** está na tabela `ICFSERVICE`: o HTTP Service não ativou de fato. Reative no ADT com Ctrl+F3 e verifique os logs.

#### 6.2.5 Configurar Logon e SSL

`SICF` → duplo clique no nó `zbapi_dyn_srv` → aba **Logon Data**:

- **Procedure**: `Standard` (Basic Auth)
- **Client**: 100
- **User** / **Password**: deixar em branco (força autenticação por request)
- **Security Requirement**: `SSL` para produção
- **Handler List** aba: confirme que aparece `ZCL_HTTP_BAPI_DYN`

Salvar. Reativar se pediu.

#### 6.2.6 Smoke test

Do próprio SAPGUI:

- `SICF` → botão direito no nó → **Test Service**

Abre o browser na URL. Como só aceitamos POST, um `GET` do browser retorna:

```
HTTP 405 Method Not Allowed
{"error":"Only POST is supported"}
```

Isso confirma que:
- ✅ Nó ICF está ativo
- ✅ Handler class está sendo chamada
- ✅ Método `if_http_service_extension~handle_request` está executando

Se a resposta for HTML de logon do SAP, revise 6.2.5. Se for 404, revise 6.2.4.

#### 6.2.7 Se o HTTP Service simplesmente não gera nó — plano B rápido

Em alguns S/4HANA on-premise (especialmente 1809 e SPs iniciais de 1909), o objeto `HTTP Service` no ADT **não** dispara o auto-registro no ICF. Se depois de 6.2.4 o nó continuar ausente e `ICFSERVICE` não tiver a entrada, pare de brigar com esse mecanismo e **pule direto para a Opção B (6.3)**.

Opção B usa a `SICF` clássica com uma classe wrapper `if_http_extension` e **sempre funciona**, independente do release. Não há penalidade de performance — é o mesmo runtime ICF por baixo.

---

### 6.3 Opção B — Nó SICF clássico com wrapper `if_http_extension`

Use quando a Service Definition (Opção A) não estiver disponível no seu
release. A ideia é criar uma **classe wrapper** que implementa
`if_http_extension` e delega para `zcl_bapi_dyn_dispatcher`.

#### 6.3.1 Criar a wrapper class

`SE24` (ou ADT) → nova classe `ZCL_HTTP_BAPI_DYN_ICF`:

```abap
CLASS zcl_http_bapi_dyn_icf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_http_extension.
ENDCLASS.


CLASS zcl_http_bapi_dyn_icf IMPLEMENTATION.

  METHOD if_http_extension~handle_request.
    DATA lv_body TYPE string.

    TRY.
        IF to_upper( server->request->get_header_field( '~request_method' ) ) <> 'POST'.
          server->response->set_status( code = 405 reason = 'Method Not Allowed' ).
          server->response->set_content_type( 'application/json' ).
          server->response->set_cdata( `{"error":"Only POST is supported"}` ).
          RETURN.
        ENDIF.

        lv_body = server->request->get_cdata( ).
        IF lv_body IS INITIAL.
          server->response->set_status( code = 400 reason = 'Bad Request' ).
          server->response->set_content_type( 'application/json' ).
          server->response->set_cdata( `{"error":"Empty request body"}` ).
          RETURN.
        ENDIF.

        DATA(lo_dispatcher) = NEW zcl_bapi_dyn_dispatcher( ).
        DATA(ls_outcome)    = lo_dispatcher->dispatch( iv_json = lv_body ).

        server->response->set_status(
          code   = COND #( WHEN ls_outcome-mode = zcl_bapi_dyn_dispatcher=>c_mode_sync THEN 200 ELSE 202 )
          reason = COND #( WHEN ls_outcome-mode = zcl_bapi_dyn_dispatcher=>c_mode_sync THEN 'OK' ELSE 'Accepted' ) ).
        server->response->set_content_type( 'application/json' ).
        server->response->set_cdata( ls_outcome-response_json ).

      CATCH cx_root INTO DATA(lx_err).
        DATA(lv_err) = escape( val    = lx_err->get_text( )
                               format = cl_abap_format=>e_json_string ).
        server->response->set_status( code = 400 reason = 'Bad Request' ).
        server->response->set_content_type( 'application/json' ).
        server->response->set_cdata( |\{"error":"{ lv_err }"\}| ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
```

Ativar.

> Nota: no clássico `if_http_extension` os parâmetros do `set_status` são `code` / `reason` (não `i_code` / `i_reason`), e o corpo é escrito com `set_cdata` (não `set_text`).

#### 6.3.2 Criar o nó ICF

`SICF`:

1. Filtrar em `default_host/sap/bc/http`.
2. Botão direito no nó `http` → **New Sub-Element → Independent Service** (nó de serviço).
3. Preencher:
   - **Name of Service Element**: `zbapi_dyn`
   - **Description**: `Dynamic BAPI Runner`
4. **OK**. Abre a manutenção do nó.

Na tela do serviço:

- Aba **Service Data**:
  - **Session Timeout**: 0 (usar padrão)
- Aba **Logon Data**:
  - **Procedure**: `Standard` (Basic Auth) ou `Alternative Logon Procedure` conforme sua política
  - **Client**: 100
  - Deixar usuário/senha em branco para forçar autenticação por request
  - **Security Requirement**: `SSL`
- Aba **Handler List**:
  - **New Handler**: `ZCL_HTTP_BAPI_DYN_ICF`
  - Salvar

Salvar tudo. Botão direito no nó `zbapi_dyn` → **Activate Service** → confirmar em `Yes`. O ícone do nó fica azul.

URL final:

```
https://<host>:<port>/sap/bc/http/sap/zbapi_dyn
```

---

### 6.4 CORS (opcional, para consumo por navegador)

Se o cliente for uma SPA (React, Angular, Fiori standalone) hospedada em outro domínio, é preciso responder cabeçalhos CORS.

Duas alternativas:

**Web Dispatcher (recomendada):** configurar `icm/HTTP/mod_0` no `RZ11` do Web Dispatcher para injetar `Access-Control-Allow-Origin`, `-Methods`, `-Headers` no path do serviço. Não requer mudança de código.

**Na handler class:** adicionar no início do `handle_request`:

```abap
response->set_header_field( i_name = 'Access-Control-Allow-Origin'
                            i_value = 'https://meu-cliente.exemplo.com' ).
response->set_header_field( i_name = 'Access-Control-Allow-Methods'
                            i_value = 'POST, OPTIONS' ).
response->set_header_field( i_name = 'Access-Control-Allow-Headers'
                            i_value = 'Content-Type, Authorization, X-CSRF-Token' ).

IF to_upper( request->get_method( ) ) = 'OPTIONS'.
  response->set_status( i_code = 204 i_reason = 'No Content' ).
  RETURN.
ENDIF.
```

### 6.5 CSRF (opcional, para navegadores autenticados por cookie)

Se o cliente autentica via SSO com cookie (SAML/OAuth), aplique a política CSRF do SAP:

1. Cliente faz `HEAD /sap/bc/http/sap/zbapi_dyn_srv` com header `X-CSRF-Token: Fetch`.
2. Servidor retorna `X-CSRF-Token: <valor>`.
3. Cliente reenvia o valor no `POST` real.

Para habilitar, adicionar no `handle_request` antes do POST real:

```abap
IF to_upper( request->get_method( ) ) = 'HEAD'
   AND request->get_header_field( 'X-CSRF-Token' ) = 'Fetch'.
  response->set_header_field( i_name = 'X-CSRF-Token'
                              i_value = cl_system_uuid=>create_uuid_c22_static( ) ).
  response->set_status( i_code = 200 i_reason = 'OK' ).
  RETURN.
ENDIF.
```

Para APIs consumidas por Postman/backend com Basic Auth ou Bearer Token, CSRF não é obrigatório.

### 6.6 Payload máximo e timeout

Valores default do ICM podem ser insuficientes para lotes grandes. Ajustes em `RZ11`:

| Parâmetro | Default | Recomendado (loads grandes) | Efeito |
|---|---|---|---|
| `icm/HTTP/max_request_size_KB` | 102400 | 512000 (500 MB) | Tamanho máximo do body |
| `icm/keep_alive_timeout` | 60 | 300 | Timeout de conexão persistente |
| `icm/server_port_0` | via | via | Reveja se timeout `PROCTIMEOUT` cobre o parse (não a execução async) |
| `rdisp/max_wprun_time` | 600 | 600 | Não precisa aumentar — a execução é async após o parse |

O parse do JSON e o dispatch dos workers são síncronos. Se o cliente envia
100 mil documentos em uma única chamada, o parse pode consumir alguns segundos —
mas os workers rodam em background e o HTTP retorna 202 imediatamente após o dispatch.

### 6.7 Verificar o endpoint disponível

Do próprio servidor (SAPGUI):

```
SICF → botão direito no serviço → Test Service
```

De fora, via `curl`:

```bash
curl -i -u <user>:<password> \
  -H "Content-Type: application/json" \
  -X POST https://<host>:<port>/sap/bc/http/sap/zbapi_dyn_srv \
  --data '{"bapi_name":"BAPI_PO_CREATE1","heders_values":[],"items_values":[]}'
```

Resposta esperada (endpoint no ar, mas sem docs válidos):

```
HTTP/1.1 202 Accepted
Content-Type: application/json

{"bapi_name":"BAPI_PO_CREATE1","accepted":1,"workers":1,"mode":"async"}
```

### 6.8 Troubleshooting específico da exposição HTTP

| Sintoma | Diagnóstico | Ação |
|---|---|---|
| `HTTP 404 Not Found` | Nó ICF inativo ou path incorreto | `SICF` → verificar ativação e URL exata |
| `HTTP 401 Unauthorized` | Basic Auth faltando/errada | Enviar `Authorization: Basic <base64>` |
| `HTTP 403 Forbidden` | Falta `S_ICF` para o serviço | Ajustar role (ver Passo 6) |
| `HTTP 500` sem body customizado | Dump antes do `try/catch` (ex.: classe não ativa) | `ST22` + reativar a classe |
| Cliente browser bloqueia CORS | Sem headers `Access-Control-*` | Aplicar 6.4 |
| Resposta HTML de logon aparece | Autenticação não configurada corretamente | `SICF → Logon Data` |
| `HTTP 413 Request Entity Too Large` | Payload maior que `icm/HTTP/max_request_size_KB` | Aumentar (6.6) |
| Erro `Handler class not found` na Service Definition | Nome digitado errado ou classe inativa | Ativar `zcl_http_bapi_dyn` |


---

## 7. Passo 5 — Server Group RFC (paralelismo)

Para que `DESTINATION IN GROUP DEFAULT` distribua os workers em vários application servers.

1. `RZ12` → **Assignment of Server Groups** → **Create Assignment**
2. Group name: `DEFAULT` (já existe por padrão em muitos sistemas)
3. Attribuir servers, definir:
   - **Maximum requests per user**: 15 (ajuste conforme carga)
   - **Maximum number of logons**: 90%
   - **Maximum PBT WPs used**: 75%
4. Salvar

> Se `DEFAULT` já está configurado, apenas confirme que há Dialog Work Processes livres suficientes (`SM50`).

---

## 8. Passo 6 — Autorizações

### 8.1 Usuário técnico do HTTP (chamador externo)

| Objeto | Campo | Valor |
|---|---|---|
| `S_ICF` | `ICF_FIELD` | `SERVICE` |
| `S_ICF` | `ICF_VALUE` | `ZBAPI_DYN_SRV` |
| `S_RFC` | `RFC_TYPE` | `FUGR` |
| `S_RFC` | `RFC_NAME` | `Z_BAPI_DYN_WORKER` |
| `S_RFC` | `ACTVT` | `16` |

### 8.2 Autorizações da BAPI alvo

O usuário do serviço precisa das autorizações **da BAPI** que vai executar. Ex.: para `BAPI_PO_CREATE1`, adicione `M_BEST_BSA`, `M_BEST_EKG`, `M_BEST_EKO`, `M_BEST_WRK`.

### 8.3 Objeto de autorização adicional (recomendado)

Crie `Z_BAPI_DYN` via `SU21` com campo `BAPI_NAME` para restringir *quais* BAPIs cada usuário pode invocar. Adicionar checagem no `handle_request`:

```abap
AUTHORITY-CHECK OBJECT 'Z_BAPI_DYN'
  ID 'BAPI_NAME' FIELD ls_request-bapi_name.
IF sy-subrc <> 0.
  response->set_status( code = 403 reason = 'Forbidden' ).
  RETURN.
ENDIF.
```

---

## 9. Passo 7 — Testes (ATC, ADT, Postman)

### 9.1 Unit tests

ADT → abrir `zcl_bapi_dyn_dispatcher` → `Ctrl+Shift+F10`.

Esperado: **13 tests passed** (todos os cenários de defaults, cálculo, split, response, dispatch com spy).

### 9.2 ATC (Static Checks)

`SE80` / ADT → clicar no pacote `ZBAPI_DYN` → **Run ATC Check with Default Variant**.
Corrigir findings de severidade Error/Warning.

### 9.3 Teste manual via SE37

Executar `Z_BAPI_DYN_WORKER` diretamente com um chunk JSON pequeno para validar o dispatcher standalone.

### 9.4 Teste HTTP via Postman

Ver [Anexo A](#12-anexo-a--payload-de-exemplo-postmancurl).

Resposta esperada:
- HTTP `202 Accepted`
- Body: `{"bapi_name":"BAPI_PO_CREATE1","accepted":1,"workers":1,"mode":"async"}`

### 9.5 Verificar execução assíncrona

`SM50` → observar Work Processes `DIA` executando `Z_BAPI_DYN_WORKER`.
`SM58` → **Transactional RFC** para ver tarefas.

---

## 10. Passo 8 — Observabilidade / Logs

O código atual **engole exceções no worker async** (para não gerar dumps). Adicionar log é altamente recomendado.

### 10.1 Application Log (BAL)

Editar `z_bapi_dyn_worker.fugr.abap`, dentro do `CATCH cx_root INTO lx_err`:

```abap
DATA(ls_bal_log) = VALUE bal_s_log(
  object    = 'ZBAPI_DYN'
  subobject = 'WORKER'
  extnumber = |{ iv_bapi_name }_{ sy-uzeit }| ).

CALL FUNCTION 'BAL_LOG_CREATE'
  EXPORTING i_s_log = ls_bal_log
  IMPORTING e_log_handle = DATA(lv_handle).

CALL FUNCTION 'BAL_LOG_MSG_ADD'
  EXPORTING i_log_handle = lv_handle
            i_s_msg = VALUE bal_s_msg(
                        msgty = 'E'
                        msgid = 'ZBAPI_DYN'
                        msgno = '001'
                        msgv1 = lx_err->get_text( ) ).

CALL FUNCTION 'BAL_DB_SAVE'
  EXPORTING i_save_all = abap_true.
```

Criar antes:
- `SLG0` → Objects → `ZBAPI_DYN` (+ subobject `WORKER`)
- `SE91` → Message Class `ZBAPI_DYN` com mensagem `001`

Visualizar logs em `SLG1`.

### 10.2 Correlation ID no header HTTP

No `zcl_http_bapi_dyn`, gerar um GUID e incluir na resposta / logs:

```abap
DATA(lv_corr) = cl_system_uuid=>create_uuid_c32_static( ).
response->set_header_field( i_name = 'X-Correlation-Id' i_value = lv_corr ).
```

Passar `lv_corr` ao dispatcher → ao FM worker → aos logs BAL. Permite rastrear qual carga produziu quais erros.

---

## 11. Passo 9 — Tuning e capacidade

### 11.1 Regras práticas

| Cenário | `worker_threads` | `worker_rows` | Observação |
|---|---|---|---|
| Carga pequena (< 5k docs) | 1–2 | 5000 | Overhead de paralelismo não compensa |
| Carga média (5k–50k) | 4 | 5000 | Default equilibrado |
| Carga grande (50k+) | 8–10 | 3000–5000 | Chunks menores = menor risco em falhas |
| Sistema com poucos DIA WPs | ≤ (DIA livres × 0.5) | 5000 | Evita starvation |

### 11.2 Onde monitorar

- `SM50` — Work Processes ativos por app server
- `SM66` — Global work process overview (todos os servers)
- `SM58` — RFC calls transacionais
- `ST22` — Runtime errors (short dumps)
- `SLG1` — Application logs (se implementado)

### 11.3 Alarme de saturação

Se `SM66` mostra > 80% dos DIA ocupados durante a carga, reduzir `worker_threads` ou dividir a carga em janelas.

### 11.4 Commit strategy — validação

A estratégia é **commit por documento**. Se quiser trocar por batch commit (mais rápido, menos seguro), altere `zcl_bapi_dyn_caller=>process_chunk`:

```abap
METHOD process_chunk.
  LOOP AT it_documents INTO DATA(ls_doc).
    APPEND call_document_no_commit( ls_doc ) TO rt_results.
  ENDLOOP.
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = abap_true.
ENDMETHOD.
```

⚠️ Nesse modo, uma única falha exige tratamento manual (nem sempre há rollback seletivo).

---

## 12. Anexo A — Payload de exemplo (Postman/cURL)

### Postman

- Method: `POST`
- URL: `https://<host>:<port>/sap/bc/http/sap/zbapi_dyn`
- Auth: `Basic Auth` (usuário técnico)
- Headers:
  - `Content-Type: application/json`
- Body (raw JSON): copiar de [input.json](thiagobattaglin/http-api-dynamic/input.json)

### cURL

```bash
curl -u <user>:<password> \
  -H "Content-Type: application/json" \
  -X POST https://<host>:<port>/sap/bc/http/sap/zbapi_dyn \
  --data @input.json
```

### Payload bulk (12k documentos)

```jsonc
{
  "mode": "async",
  "bapi_name": "BAPI_PO_CREATE1",
  "worker_threads": 10,
  "worker_rows": 5000,
  "documents": [
    { "heders_values": [...], "items_values": [...] },
    { "heders_values": [...], "items_values": [...] }
  ]
}
```

Resposta esperada:

```json
{ "bapi_name": "BAPI_PO_CREATE1", "accepted": 12000, "workers": 3, "mode": "async" }
```

---

## 13. Anexo B — Troubleshooting

| Sintoma | Causa provável | Ação |
|---|---|---|
| HTTP 400 `bapi_name` | Payload sem `bapi_name` | Validar JSON |
| HTTP 400 mensagem `Function module not found` | BAPI não existe ou não é RFC-enabled | `SE37` → verificar Attributes |
| HTTP 405 | Método diferente de POST | Trocar para POST |
| HTTP 500 sem body | Dump ABAP fora do try/catch | `ST22` para detalhes |
| Workers não disparam | FM `Z_BAPI_DYN_WORKER` não marcado RFC-enabled | `SE37` → Attributes → RFC |
| Documento aceito mas nada persiste | BAPI retorna E/A → rollback silencioso | Ativar log BAL (seção 10) |
| Dumps `TSV_TNEW_PAGE_ALLOC_FAILED` | Chunk muito grande | Reduzir `worker_rows` |
| Timeout no HTTP | Payload muito grande + parse síncrono | Aumentar `rdisp/max_wprun_time` ou dividir chamadas |
| `RFC_ERROR_LOGON_FAILURE` no worker | Server group sem trust | Verificar `RZ12` e `SMGW` |
| Campos ignorados (não gravaram) | Nome do field ≠ componente da estrutura | Verificar campos exatos via `SE11` da estrutura BAPI |

---

## 14. Anexo C — Checklist final

- [ ] Pacote `ZBAPI_DYN` criado
- [ ] Function Group `Z_BAPI_DYN_WORKER` criado
- [ ] FM `Z_BAPI_DYN_WORKER` **marcado como Remote-Enabled**
- [ ] Classes `zcl_bapi_dyn_dispatcher`, `zcl_bapi_dyn_caller`, `zcl_http_bapi_dyn` ativas
- [ ] Include de teste da dispatcher: todos os testes verdes
- [ ] HTTP Service `ZBAPI_DYN_SRV` (ou nó SICF) ativo
- [ ] Server Group `DEFAULT` configurado em `RZ12`
- [ ] Autorizações `S_ICF`, `S_RFC` + as autorizações da BAPI concedidas
- [ ] Objeto customizado `Z_BAPI_DYN` (opcional) para restringir BAPIs
- [ ] Log BAL `ZBAPI_DYN/WORKER` criado + message class `ZBAPI_DYN`
- [ ] Teste smoke via Postman com `input.json` → `202 Accepted` recebido
- [ ] `SM50` confirma execução dos workers
- [ ] Documento(s) criados no sistema (ex.: `ME23N` para POs)
- [ ] ATC sem findings de severidade Error
