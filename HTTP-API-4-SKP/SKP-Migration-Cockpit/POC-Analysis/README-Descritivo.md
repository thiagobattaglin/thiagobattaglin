# POC "Syniti Migrate — SAP LTMC Load Program"

**URL:** https://think-misty-19230415.figma.site (protegida por senha `Syniti`)
**Ambiente exibido:** DEV – DEV · usuário TB · Host `dmr-sap-a02.dmroffice.com:8000` · Client 800
**Serviço OData alvo:** `/sap/opu/odata/LTB/MIG_MC_ODATA_SRV`
**Classe DPC (SAP):** [`/LTB/CL_MIG_MC_ODATA_DPC_EXT`](../%23LTB%23CL_MIG_MC_ODATA_DPC_EXTclass.abap)

## 1. Objetivo da POC

Demonstrar, de forma visual e navegável, o fluxo ponta-a-ponta em que o
Syniti Migrate opera como camada de _staging + ETL + orquestração_ contra o
**SAP S/4HANA Migration Cockpit (LTMC)** para carregar **Purchase Orders (PO)
em aberto** (Business Object `MM - Purchase order (only open PO)`,
Migration Approach `STAGING`, Scenario `DEFAULT`).

A POC **não cria** de fato o Migration Project no SAP — ela **desenha** o
fluxo de chamadas que precisariam existir contra o serviço OData
`MIG_MC_ODATA_SRV`. Cada botão (`POST MigrationProjectSet`,
`POST SetParallelJobs`, `POST StartMigration`) mostra apenas o payload
que seria enviado.

## 2. Estrutura de navegação

Cabeçalho (breadcrumb estático, não navegável):
`Home ▸ Business Objects ▸ Purchase Orders ▸ LTMC Load Program`.

A tela principal expõe **3 etapas** encadeadas:

| # | Etapa | Ação principal |
|---|---|---|
| 1 | **Load Program Setup** | Listar projetos LTMC existentes e criar um novo projeto |
| 2 | **ETL Export Task** | Mapear tabelas SKP (`PO_EKKO_T`, `PO_EKPO_T`, …) ↔ estruturas de staging LTMC (`S_EKKO`, `S_EKPO`, …) e executar o export |
| 3 | **Run & Monitor** | Configurar paralelismo, disparar `StartMigration` (Simulation/Production), monitorar progresso e ler o _readback_ dos PO criados |

### 2.1 Etapa 1 — Load Program Setup

Componentes:

- **Existing LTMC Projects in SAP** — tabela com 4 registros de exemplo:
  - `ZTEST_PO_SKP` · SAP North America · DEV · In Process
  - `ZSKP_HISTORICAL_DATA_LOAD` · SAP North America · QA · Not Started
  - `ZSKP_WORK_ORDERS` · SAP Europe · DEV · In Process
  - `FI_HISTORICAL_DATA_LOAD` · SAP North America · PRD · Not Started
- **Create New LTMC Project** — formulário:
  - `SKP System` (SAP NA / EU / APAC)
  - `Environment` (DEV / QA / PRD) — a POC destaca que _"Table UUIDs differ per environment"_
  - `Project Name` (default `ZSKP_PO_LOAD_2026`)
  - `Migration Object` (`MM - Purchase order (only open PO)`)
  - `Migration Approach` (`Migrate Data Using Staging Tables`)
  - `OData endpoint` calculado (ex.: `https://dmr-sap-a02.dmroffice.com:8000/sap/opu/odata/ltb/mig_mc_odata_srv`, Client 800)
  - Botão **`POST MigrationProjectSet → NA DEV`**
- **LTMC Staging Table Structure — MM Purchase Orders** — árvore com 9 tabelas de staging (extraída do metadata):

  | Nível | Tabela | Descrição | UUID (DEV) | Pai |
  |---|---|---|---|---|
  | 0 | `S_EKKO` | Header Data | `/1LT/DSS41002602` | — |
  | 1 | `S_ADRC` | Header Address | `/1LT/DSS41002603` | `S_EKKO` |
  | 1 | `S_EKKO_TEXT` | Header Texts | `/1LT/DSS41002604` | `S_EKKO` |
  | 1 | `S_EKPO` | Item Data | `/1LT/DSS41002605` | `S_EKKO` |
  | 2 | `S_ADRC_2` | Item Address | `/1LT/DSS41002606` | `S_EKPO` |
  | 2 | `S_EKKN` | Account Assignment | `/1LT/DSS41002607` | `S_EKPO` |
  | 2 | `S_EKET` | Schedule Line | `/1LT/DSS41002608` | `S_EKPO` |
  | 3 | `S_COMP` | Components for Subcontracting | `/1LT/DSS41002609` | `S_EKET` |
  | 2 | `S_EKPO_TEXT` | Item Texts | `/1LT/DSS41002610` | `S_EKPO` |

  A UI reforça três _tabs_ (DEV / QA / PRD) explicando que os UUIDs mudam por ambiente porque em cada sistema SAP o transporte gera IDs próprios; os nomes lógicos são idênticos.

### 2.2 Etapa 2 — ETL Export Task

- **Table Mappings** (5 ativos / 6 totais):

  | Source | Target | Descrição | Rows | Status |
  |---|---|---|---|---|
  | `PO_EKKO_T` | `S_EKKO` | Header Data | 5 847 | Success |
  | `PO_EKPO_T` | `S_EKPO` | Item Data | 18 234 | Success |
  | `PO_EKKN_T` | `S_EKKN` | Account Assignment | 3 120 | Success |
  | `PO_EKET_T` | `S_EKET` | Schedule Line | 21 891 | **Error** |
  | `PO_EKKO_ADDR_T` | `S_ADRC` | Header Address | 5 847 | Idle |
  | `PO_TEXT_T` | `S_EKKO_TEXT` | Header Texts | — | Idle |

  Total agregado: **54 939** linhas em staging (rótulo da UI).

- **Field Mapping** — mostra o mapeamento coluna-a-coluna entre a origem SKP (SQL nativo, `nvarchar(n)`, `date`, …) e o destino LTMC (tipo ABAP: `CHAR`, `DATS`, `CUKY`, …). Exemplo `S_EKKO`: `EBELN`, `BUKRS`, `BSART`, `LIFNR`, `EKORG`, `EKGRP`, `BEDAT` (com transform `FORMAT_DATE`), `ZTERM`, `WAERS`.
- **Combobox de regra:** `Map By Name` (default), `Map Explicit`, `No Mapping`.
- Botão **`Run Export`** por mapeamento.
- Painel lateral: `Last Run`, `Records Exported`, `Field Mapping Rule`, `Task Active`.

### 2.3 Etapa 3 — Run & Monitor

Cinco blocos:

1. **LTMC Load Job Execution**
   - Origem: **SKP ETL Environment** (`DEV / LOAD`)
   - Destino: **SAP Target Environment** (dropdown NA/EU/APAC × DEV/QA/PRD)
   - Endpoint e Client resolvidos dinamicamente.
   - Projeto: `ZSKP_PO_LOAD_2026`, Object: `MM - Purchase Orders`, 9 staging tables, 5 847 registros staged.
   - `Execution Mode`: **Simulation** ou **Production**.
   - `Background Job Name`: `ZSKP_PO_LTMC_JOB`.
   - Checkbox `Enable readback of created PO numbers`.
2. **Parallel Background Jobs** — slider 1–50 threads, campo `SAP Basis Max Workers` (20), botão **`Apply — POST SetParallelJobs (4)`**.
3. **Execution Sequence** — a POC lista 7 chamadas OData/ETL:

   | # | Verbo | Endpoint / Ação |
   |---|---|---|
   | 1 | `GET` | `MigrationProjectSet('…')/to_MigrationObject` |
   | 2 | `ETL` | Load Staging Tables → DEV (`/1LT/DSSxxxxxxx`) |
   | 3 | `POST` | `SetParallelJobs?MigrationProjectUUID=…&MigrationObjectUUID=…&NumBackgroundJob=4` |
   | 4 | `POST` | `StartMigration?ProjectUUID=…&ObjectUUID=…&AllRecords=true` |
   | 5 | `GET` | `MigrationProjectSet('…')/to_TaskProcessing` |
   | 6 | `GET` | `ActivityMonitorSet?$filter=MigrationProjectUUID eq '…'` |
   | 7 | `GET` | `ApplicationLogSet?$filter=MigrationProjectUUID eq '…'` |

4. **Job Progress** — 4 barras: `Staging Read`, `Validation`, `Migration`, `Readback`.
5. **Activity Log / Load Results — PO Readback**
   - Log de eventos com níveis `INFO / OK / WARN / ERR`.
   - Tabela de resultado (readback) com `Legacy PO#`, `New SAP PO#`, `Comp. Code`, `Vendor`, `Status`, `Message`.
   - Exemplo do dataset: 5 pedidos, 4 criados (`4500018742…4500018745`), 1 falha (`4500001003` → _Vendor V-ABC003 not found_).

## 3. Mapeamento POC ↔ Serviço OData real

A classe DPC EXT ([#LTB#CL_MIG_MC_ODATA_DPC_EXTclass.abap](../%23LTB%23CL_MIG_MC_ODATA_DPC_EXTclass.abap)) confirma as operações que o botão da POC dispararia:

| Ação da POC | Método OData / ação (constante) | Método ABAP |
|---|---|---|
| `POST MigrationProjectSet` | `CREATE_ENTITY` de `MigrationProjectSet` | `/iwbep/if_mgw_appl_srv_runtime~create_entity` → agrupa em `changeset_begin` como transação `CREPROJ` |
| Consulta de projetos | `GET_ENTITYSET` de `MigrationProjectSet` | `MIGRATIONPROJECT_GET_ENTITYSET` |
| Consulta de MO / staging | `GET_ENTITYSET` de `MigrationObjectSet`, `TableStructureSet` | `MIGRATIONOBJECTS_GET_ENTITYSET` / `TABLESTRUCTORSET_GET_ENTITYSET` |
| `POST SetParallelJobs` | Action Import `SetParallelJobs` | `SET_PARALLEL_JOBS` / `HANDLE_SET_JOBS` |
| `POST StartMigration` | Action Import `StartMigration` (`CO_ACTION_MO_MIGRATION`) | `MO_MIGRATION_TRANSACTION` |
| Simulation | Action Import `Simulation` (`CO_ACTION_MO_SIMULATION`) | `MO_SIMULATION_TRANSACTION` |
| Monitoramento | `to_TaskProcessing`, `ActivityMonitorSet`, `ApplicationLogSet` | `TASKPROCESSINGSE_GET_ENTITYSET`, `ACTIVITYMONITORS_GET_ENTITYSET`, `APPLICATIONLOGSE_GET_ENTITYSET` |
| Readback PO criado | Não exposto por endpoint dedicado — precisa de leitura da tabela `EKKO` no SAP ou uso de action `IsInstanceInMO` + consulta `MigrationInstanceSet` | `MIGRATIONINSTANC_GET_ENTITYSET` |

Todos os métodos passam por `check_execute_auth_for_request` e
`check_system_upgrade` no início do fluxo — a POC não representa esses
gates.

## 4. Diagramas

- Sequência: [sequence-diagram.mmd](sequence-diagram.mmd)
- Fluxograma: [flowchart.mmd](flowchart.mmd)

## 5. Falhas potenciais

Consulte [Falhas-Potenciais.md](Falhas-Potenciais.md).
