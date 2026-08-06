# Relatório de Análise — Migração de Dados SAP S/4HANA
## Estratégia de Otimização: LSMW × BAPI × Migration Cockpit

**Data:** 2026-07-30
**Cliente / Projeto:** ConcentoRDG
**Escopo:** Análise dos 7 objetos de carga de dados atualmente em LSMW / Migration Cockpit / T-code
**Objetivo:** Reduzir a janela total de carga (hoje ~186h) via troca seletiva por BAPIs com paralelismo e commit em pacotes

---

## 1. Sumário Executivo

| Indicador | Valor atual | Valor projetado | Redução |
|---|---:|---:|---:|
| Janela total de carga | **186 h** | **94 h – 131 h** | **30% – 50%** |
| Objetos em LSMW/IDoc | 6 | 1 (opcional) | – |
| Objetos em BAPI paralela | 0 | 5 | – |
| Objetos em Migration Cockpit | 1 | 1 – 2 | – |
| T-code manual | 1 | 1 | – |

**Recomendação principal:** priorizar refactor via BAPI + paralelismo em **3 objetos** que concentram ~65% da economia possível:

1. Material Equipment Conversion (40h → 10–20h)
2. Open Production Order (60h → 36–48h)
3. Open PO Conversion (30h → 12–18h)

---

## 2. Inventário Completo dos Objetos

| # | Track | WRICEF | Objeto | Método atual | Tempo (h) | Volume total aprox. |
|---:|---|---|---|---|---:|---:|
| 1 | SC  | ZCON1091 | Inventory (EWM) | T-code /SCWM/ISU | 24 | 28.687 |
| 2 | S2P | ZCON275  | Open Purchase Orders | LSMW/IDoc | 12 | ~838.000 |
| 3 | S2P | ZCON033  | Vendor Open Items | LSMW/IDoc | 10 | ~465.000 |
| 4 | R&M | ZCON186  | Maintenance Work Order | Migration Cockpit | 10 | ~2.850.000 |
| 5 | PTS | PTS-20028-C | Open Production Order | LSMW multipart | 60 | ~6.300.000 |
| 6 | PTS | PTS-20041-C | Material Equipment Conversion (MFC ECC) | LSMW/IDoc | 40 | ~59.200.000 |
| 7 | PTP | PTP-00035-C | Open PO Conversion | LSMW/IDoc | 30 | ~4.000.000 |
|   |     |         | **TOTAL** |  | **186** | **~72,7 milhões** |

---

## 3. Mapeamento Técnico Detalhado

### 3.1 Inventory (EWM) — 24h
- **Tabelas-alvo:** `/SCWM/ACQUA` (e correlatas `/SCWM/QUAN`, `/SCWM/ORDIM_*`)
- **BAPI equivalente:** *Não existe BAPI clássica*
- **Alternativas cloud-ready:**
  - APIs `/SCWM/API_PHYSTOCK_CREATE`, `/SCWM/ERP_STOCK_CREATE`
  - Para MM-IM (não-EWM): `BAPI_GOODSMVT_CREATE` (movimento 561)
- **Migration Cockpit — objeto padrão:** **"Warehouse stock (EWM)"** (nome técnico `S4_EWM_STOCK` / `EWM_STOCK` conforme release)
- **Objetos EWM correlatos disponíveis no Cockpit:**
  - Physical inventory document (EWM)
  - Warehouse product (EWM)
  - Storage bin (EWM)
  - Fixed bin assignment (EWM)
  - Handling Unit (EWM)
- **Recomendação:** manter `/SCWM/ISU` ou migrar para Migration Cockpit. Ganho por trocar de método é baixo (0–20%). Maior ganho vem de:
  - Paralelismo por depósito / storage type
  - Ampliar work processes durante a janela
  - Reduzir escopo (só saldo atual, sem histórico)

### 3.2 Open Purchase Orders — 12h
- **Tabelas-alvo:** EKKO (6k), EKPO (18k), EKKN (4k), EKET (12k), EKPA (25k), STXH (27k), STXL (302k), ESLH (155k), ESLL (181k)
- **BAPI recomendada:** **`BAPI_PO_CREATE1`**
- **Cobertura por tabela:**
  | Tabela | Coberta pela BAPI? | Como |
  |---|---|---|
  | EKKO | Sim | Parâmetro `POHEADER` |
  | EKPO | Sim | Tabela `POITEM` |
  | EKKN | Sim | Tabela `POACCOUNT` |
  | EKET | Sim | Tabela `POSCHEDULE` |
  | EKPA | Sim | Tabela `POPARTNER` |
  | STXH / STXL | Sim | Tabelas `POITEM_TEXT` / `POTEXTHEADER` |
  | ESLH / ESLL | Sim | Tabelas `POSERVICES` + `POSRVACCESSVALUES` |
- **Cobertura:** **Alta**
- **Migration Cockpit — objeto:** "Purchase Order"

### 3.3 Vendor Open Items — 10h
- **Tabelas-alvo:** BKPF (216k), BSEG (234k), WITH_ITEM (13k)
- **BAPI recomendada:** **`BAPI_ACC_DOCUMENT_POST`** ou **`BAPI_ACC_AP_DOCUMENT_POST`**
- **Cobertura por tabela:**
  | Tabela | Coberta pela BAPI? | Como |
  |---|---|---|
  | BKPF | Sim | Parâmetro `DOCUMENTHEADER` |
  | BSEG | Sim | Tabelas `ACCOUNTGL`, `ACCOUNTPAYABLE`, `CURRENCYAMOUNT` |
  | WITH_ITEM | Sim | Estruturas `EXTENSION1` / `EXTENSION2` com campos de retenção |
- **Cobertura:** **Alta**
- **Migration Cockpit — objeto:** "Open items in AP / Vendor open items"

### 3.4 Maintenance Work Order — 10h (já em Cockpit)
- **Tabelas-alvo:** AUFK (50k), AFVC (171k), RESB (36k), OBJK (105k), TEXT_SAP_AFVC (2,58M)
- **BAPI equivalente:** **`BAPI_ALM_ORDER_MAINTAIN`** (moderna, substituiu `BAPI_ALM_ORDER_CREATE`/`_CHANGE`)
- **Cobertura por tabela:**
  | Tabela | Coberta pela BAPI? |
  |---|---|
  | AUFK | Sim (header) |
  | AFVC | Sim (operações) |
  | RESB | Sim (componentes) |
  | OBJK | Sim (object list) |
  | TEXT_SAP_AFVC | Sim (parâmetro `LONGTEXTS`) |
- **Migration Cockpit — objeto:** "Maintenance order" (já em uso)
- **Recomendação:** manter Migration Cockpit. Ganho ao trocar por BAPI é marginal (10–20%).

### 3.5 Open Production Order — 60h ⚠️ maior gargalo
- **Tabelas-alvo:** AFKO (443k), AFPO (443k), AFVC (1M), AFVV (1M), AFRU (350k), AFFL (60k), RESB (1,74M), OBJK (105k), PEG_TASS (51k), SER05 (38k), TEXT_SAP_AUFK (89k)
- **BAPIs recomendadas:**
  - **`BAPI_PRODORD_CREATE`** — criação do header + operações + componentes
  - **`BAPI_PRODORD_CHANGE`** — complementa campos não cobertos na criação
  - **`BAPI_PRODORDCONF_CREATE_TT`** / `BAPI_PRODORDCONF_CREATE_HDR` — confirmações (AFRU)
- **Cobertura por tabela:**
  | Tabela | Coberta pela BAPI? | Observação |
  |---|---|---|
  | AFKO, AFPO, AFVC, AFVV, AFFL, RESB | Sim | via `BAPI_PRODORD_CREATE` |
  | AFRU | Sim | via BAPI de confirmação (separada) |
  | PEG_TASS (pegging) | **Não** | Update Z ou API específica |
  | SER05 (números de série) | **Não** | `BAPI_SERNR_ADD_TO_DOCUMENT` |
  | TEXT_SAP_AUFK | Sim | via `SAVE_TEXT` em batch |
- **Cobertura:** **Parcial**
- **Recomendação:** prova de conceito antes de decidir. O *Child Order LSMW* atual leva ~40h — se `BAPI_PRODORD_CREATE` cobre os campos usados, o ganho pode ser grande; senão, manter LSMW.

### 3.6 Material Equipment Conversion (MFC ECC) — 40h ⚠️ maior volume
- **Tabelas-alvo:** EQUZ (38.457.154), EQUI (20.767.496)
- **BAPI recomendada:** **`BAPI_EQUI_CREATE`** + **`BAPI_EQUI_CHANGE`** (ou `BAPI_EQMI_CREATE` para instalar em Functional Location)
- **Cobertura por tabela:**
  | Tabela | Coberta pela BAPI? |
  |---|---|
  | EQUI | Sim (dados mestre) |
  | EQUZ | Sim (usage period / installation) |
- **Cobertura:** **Alta**
- **Migration Cockpit — objeto:** "Equipment"
- **Recomendação:** **maior candidato ao refactor**. Volume massivo (~59M) + BAPI madura + tabelas totalmente cobertas. Avaliar também redução de escopo em EQUZ (só status atual, sem histórico completo) pode economizar mais horas que qualquer otimização técnica.

### 3.7 Open PO Conversion — 30h
- **Tabelas-alvo:** EKKO_PO (28k), EKPO_PO (49k), EKKN_PO (50k), EKET_PO (80k), RESB_PO (4k), ESLL_PO (78), STXL_PO (3M), **ZLPO_WBS_BRKDWN (125k)**, **ZSC_PO_TEXT_KEY (612k)**, **PRCD_ELEMENTS_PO (19k)**
- **BAPI recomendada:** **`BAPI_PO_CREATE1`**
- **Cobertura por tabela:**
  | Tabela | Coberta pela BAPI? | Observação |
  |---|---|---|
  | EKKO_PO / EKPO_PO / EKKN_PO / EKET_PO / RESB_PO / ESLL_PO / STXL_PO | Sim | via `BAPI_PO_CREATE1` padrão |
  | ZLPO_WBS_BRKDWN | **Não** | Tabela Z — update pós-BAPI |
  | ZSC_PO_TEXT_KEY | **Não** | Tabela Z — update pós-BAPI |
  | PRCD_ELEMENTS_PO | Parcial | Se são condições manuais → `POCOND`/`POCONDX`. Se determinadas por pricing procedure → deixar o SAP recalcular |
- **Cobertura:** **Média**
- **Recomendação:** BAPI + rotina Z pós-commit para as tabelas Z. Estimativa considera esse esforço adicional.

---

## 4. Análise de ROI — Ganho Potencial

| # | Objeto | Hoje (h) | Ganho realista | Projetado (h) | Economia (h) | % Economia |
|---|---|---:|---|---:|---:|---:|
| 6 | Material Equipment | 40 | 50–75% | 10–20 | **20–30** | **60%** |
| 5 | Open Production Order | 60 | 20–40% | 36–48 | 12–24 | 30% |
| 7 | Open PO Conversion | 30 | 40–60% | 12–18 | 12–18 | 50% |
| 2 | Open Purchase Orders | 12 | 40–60% | 5–7 | 5–7 | 50% |
| 3 | Vendor Open Items | 10 | 50–70% | 3–5 | 5–7 | 60% |
| 4 | Maintenance Work Order | 10 | 10–20% | 8–9 | 1–2 | 15% |
| 1 | Inventory EWM | 24 | 0–20% | 20–24 | 0–4 | 10% |
|   | **TOTAL** | **186** | | **94–131** | **55–92** | **30–50%** |

### Distribuição do ganho por objeto (base: cenário conservador ~55h)

```
Material Equipment      ████████████████████░░░░░░  36%
Open Production Order   ████████░░░░░░░░░░░░░░░░░░  22%
Open PO Conversion      ████████░░░░░░░░░░░░░░░░░░  22%
Open Purchase Orders    ███░░░░░░░░░░░░░░░░░░░░░░░   9%
Vendor Open Items       ███░░░░░░░░░░░░░░░░░░░░░░░   9%
Maintenance Order       █░░░░░░░░░░░░░░░░░░░░░░░░░   2%
Inventory EWM           ░░░░░░░░░░░░░░░░░░░░░░░░░░   0%
```

---

## 5. Plano de Implementação Sugerido

### Fase 1 — Quick wins (foco em ROI)
| Sprint | Objeto | Entrega | Ganho esperado |
|---|---|---|---:|
| S1 | **Material Equipment** | Programa Z com `BAPI_EQUI_CREATE` + pacote 500 + paralelismo | 20–30h |
| S1 | **Vendor Open Items** | Programa Z com `BAPI_ACC_DOCUMENT_POST` + pacote 200 + paralelismo | 5–7h |
| S2 | **Open PO Conversion** | Programa Z com `BAPI_PO_CREATE1` + update Z pós-commit | 12–18h |
| S2 | **Open Purchase Orders** | Reutilizar código da S2 | 5–7h |

### Fase 2 — Avaliação técnica
| Sprint | Objeto | Entrega |
|---|---|---|
| S3 | Open Production Order | POC com `BAPI_PRODORD_CREATE` para validar cobertura de campos e ganho real |

### Fase 3 — Manter
| Objeto | Ação |
|---|---|
| Maintenance Work Order | Continuar em Migration Cockpit |
| Inventory EWM | Continuar em `/SCWM/ISU` ou migrar para Migration Cockpit "Warehouse stock (EWM)" |

---

## 6. Padrão Técnico Recomendado (BAPI + Pacote + Paralelismo)

Referência de implementação disponível em:
- Versão clássica (Level 3 Clean Core): [Paralelismo/zbapi_open_po_parallel.abap](Paralelismo/zbapi_open_po_parallel.abap)
- Versão moderna (Level 1 Clean Core, ABAP Cloud + bgPF + RAP): [Paralelismo/zcl_po_load_orchestrator.clas.abap](Paralelismo/zcl_po_load_orchestrator.clas.abap)

### Parâmetros de tuning por perfil

| Perfil | Tamanho do pacote | Paralelismo | Cenário |
|---|---:|---:|---|
| Conservador | 50 | 3 | Produção com usuários online |
| Balanceado | 100 | 5 | Testes / homologação |
| Janela dedicada | 200–500 | 10–20 | Cutover fim de semana |

### Princípios aplicados

1. **Pacote de N registros** por unidade de trabalho (não commit por registro)
2. **`BAPI_TRANSACTION_COMMIT WAIT = 'X'`** ao final do pacote (ou `COMMIT ENTITIES` no RAP)
3. **`STARTING NEW TASK DESTINATION IN GROUP`** (aRFC) ou **bgPF** (Level 1)
4. **`WAIT UNTIL`** ou pool do bgPF para limitar tasks simultâneas
5. **Callback `RECEIVE RESULTS`** para coletar retorno de cada pacote
6. **Fallback síncrono** em caso de `RESOURCE_FAILURE`

---

## 7. Riscos e Premissas

### Riscos técnicos
| Risco | Objeto | Mitigação |
|---|---|---|
| BAPI não cobrir campos custom | Open Production Order, Open PO Conversion | POC antes de decidir; complementar com update Z |
| Locks concorrentes em paralelismo alto | Todos | Ajustar `P_PARAL`; SM12 monitorado |
| Sobrecarga de work processes | Todos | RZ12 dedicado; SM50 monitorado |
| Textos SAPscript em massa (STXL, TEXT_SAP_*) | Prod Order, PO | Usar parâmetro nativo da BAPI, não `SAVE_TEXT` avulso |
| Tabelas Z fora da BAPI | Open PO Conversion | Update Z no mesmo pacote, dentro da mesma LUW |
| Configuração pricing procedure | Open PO Conversion | Confirmar se PRCD_ELEMENTS_PO é manual ou determinada |

### Premissas
- Sistema-alvo: SAP S/4HANA 2022 On-Premise (ou compatível)
- Janela de cutover permite paralelismo em modo dedicado
- Basis provisionará server group RZ12 (`parallel_generators` ou equivalente) ou perfil bgPF apropriado
- Massa de dados de origem já está tratada / conciliada (fora do escopo deste ganho)

---

## 8. Clean Core — Nível de Aderência

| Abordagem | Level Clean Core | Cloud-ready? | Recomendado para |
|---|---|---|---|
| LSMW / IDoc (atual) | Level 3 | Não | Legado, tende a ser descontinuado |
| BAPI + aRFC (proposto Fase 1) | Level 3 | Não | Ganho rápido, sistema on-premise |
| BAPI encapsulada em classe (Level 2) | Level 2 | Parcial | Ponte para migração futura |
| RAP + bgPF + released APIs (Level 1) | Level 1 | Sim | Novo desenvolvimento cloud-first |

Para o cenário atual (redução de janela de cutover em S/4HANA 2022 On-Premise), **Level 3 com BAPI + paralelismo é suficiente e pragmático**. Migração para Level 1 pode ser feita posteriormente sem impacto no cutover.

---

## 9. Próximos Passos

1. Aprovação do plano de fases
2. POC de `BAPI_EQUI_CREATE` com subset de 10.000 registros — medir tempo real
3. POC de `BAPI_PRODORD_CREATE` para validar cobertura no Open Production Order
4. Confirmar objetos disponíveis no Migration Cockpit do sistema-alvo (LTMC/LTMOM/Fiori app)
5. Alinhar com Basis: RZ12 server group, perfil bgPF, work processes disponíveis durante cutover
6. Definir estratégia de log e reconciliação por pacote (App Log — `cl_bali_*`)

---

*Documento gerado em 2026-07-30 — Projeto ConcentoRDG*
