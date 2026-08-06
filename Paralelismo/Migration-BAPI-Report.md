# Data Migration Analysis Report — SAP S/4HANA
## Optimization Strategy: LSMW × BAPI × Migration Cockpit

**Date:** 2026-07-30
**Client / Project:** ConcentoRDG
**Scope:** Analysis of 7 data load objects currently running on LSMW / Migration Cockpit / T-code
**Objective:** Reduce the total cutover load window (currently ~186h) through selective refactor to BAPIs with parallelism and package-level commits

---

## 1. Executive Summary

| Indicator | Current | Projected | Reduction |
|---|---:|---:|---:|
| Total load window | **186 h** | **94 h – 131 h** | **30% – 50%** |
| Objects on LSMW/IDoc | 6 | 1 (optional) | – |
| Objects on parallel BAPI | 0 | 5 | – |
| Objects on Migration Cockpit | 1 | 1 – 2 | – |
| Manual T-code | 1 | 1 | – |

**Primary recommendation:** prioritize refactor via BAPI + parallelism on **3 objects** that account for ~65% of the achievable savings:

1. Material Equipment Conversion (40h → 10–20h)
2. Open Production Order (60h → 36–48h)
3. Open PO Conversion (30h → 12–18h)

---

## 2. Full Object Inventory

| # | Track | WRICEF | Object | Current method | Time (h) | Approx. total volume |
|---:|---|---|---|---|---:|---:|
| 1 | SC  | ZCON1091 | Inventory (EWM) | T-code /SCWM/ISU | 24 | 28,687 |
| 2 | S2P | ZCON275  | Open Purchase Orders | LSMW/IDoc | 12 | ~838,000 |
| 3 | S2P | ZCON033  | Vendor Open Items | LSMW/IDoc | 10 | ~465,000 |
| 4 | R&M | ZCON186  | Maintenance Work Order | Migration Cockpit | 10 | ~2,850,000 |
| 5 | PTS | PTS-20028-C | Open Production Order | LSMW multipart | 60 | ~6,300,000 |
| 6 | PTS | PTS-20041-C | Material Equipment Conversion (from MFC ECC) | LSMW/IDoc | 40 | ~59,200,000 |
| 7 | PTP | PTP-00035-C | Open PO Conversion | LSMW/IDoc | 30 | ~4,000,000 |
|   |     |         | **TOTAL** |  | **186** | **~72.7 million** |

---

## 3. Detailed Technical Mapping

### 3.1 Inventory (EWM) — 24h
- **Target tables:** `/SCWM/ACQUA` (and related `/SCWM/QUAN`, `/SCWM/ORDIM_*`)
- **Equivalent BAPI:** *No classic BAPI available*
- **Cloud-ready alternatives:**
  - APIs `/SCWM/API_PHYSTOCK_CREATE`, `/SCWM/ERP_STOCK_CREATE`
  - For MM-IM (non-EWM): `BAPI_GOODSMVT_CREATE` (movement 561)
- **Migration Cockpit — standard object:** **"Warehouse stock (EWM)"** (technical name `S4_EWM_STOCK` / `EWM_STOCK` depending on release)
- **Related EWM objects available in the Cockpit:**
  - Physical inventory document (EWM)
  - Warehouse product (EWM)
  - Storage bin (EWM)
  - Fixed bin assignment (EWM)
  - Handling Unit (EWM)
- **Recommendation:** keep `/SCWM/ISU` or migrate to Migration Cockpit. Gain from switching method is low (0–20%). Best leverage comes from:
  - Parallelism per warehouse / storage type
  - Increase work processes during the window
  - Reduce scope (current balance only, no movement history)

### 3.2 Open Purchase Orders — 12h
- **Target tables:** EKKO (6k), EKPO (18k), EKKN (4k), EKET (12k), EKPA (25k), STXH (27k), STXL (302k), ESLH (155k), ESLL (181k)
- **Recommended BAPI:** **`BAPI_PO_CREATE1`**
- **Table coverage:**
  | Table | Covered by BAPI? | How |
  |---|---|---|
  | EKKO | Yes | Parameter `POHEADER` |
  | EKPO | Yes | Table `POITEM` |
  | EKKN | Yes | Table `POACCOUNT` |
  | EKET | Yes | Table `POSCHEDULE` |
  | EKPA | Yes | Table `POPARTNER` |
  | STXH / STXL | Yes | Tables `POITEM_TEXT` / `POTEXTHEADER` |
  | ESLH / ESLL | Yes | Tables `POSERVICES` + `POSRVACCESSVALUES` |
- **Coverage:** **High**
- **Migration Cockpit — object:** "Purchase Order"

### 3.3 Vendor Open Items — 10h
- **Target tables:** BKPF (216k), BSEG (234k), WITH_ITEM (13k)
- **Recommended BAPI:** **`BAPI_ACC_DOCUMENT_POST`** or **`BAPI_ACC_AP_DOCUMENT_POST`**
- **Table coverage:**
  | Table | Covered by BAPI? | How |
  |---|---|---|
  | BKPF | Yes | Parameter `DOCUMENTHEADER` |
  | BSEG | Yes | Tables `ACCOUNTGL`, `ACCOUNTPAYABLE`, `CURRENCYAMOUNT` |
  | WITH_ITEM | Yes | Structures `EXTENSION1` / `EXTENSION2` with withholding fields |
- **Coverage:** **High**
- **Migration Cockpit — object:** "Open items in AP / Vendor open items"

### 3.4 Maintenance Work Order — 10h (already in Cockpit)
- **Target tables:** AUFK (50k), AFVC (171k), RESB (36k), OBJK (105k), TEXT_SAP_AFVC (2.58M)
- **Equivalent BAPI:** **`BAPI_ALM_ORDER_MAINTAIN`** (modern, replaced `BAPI_ALM_ORDER_CREATE`/`_CHANGE`)
- **Table coverage:**
  | Table | Covered by BAPI? |
  |---|---|
  | AUFK | Yes (header) |
  | AFVC | Yes (operations) |
  | RESB | Yes (components) |
  | OBJK | Yes (object list) |
  | TEXT_SAP_AFVC | Yes (parameter `LONGTEXTS`) |
- **Migration Cockpit — object:** "Maintenance order" (currently in use)
- **Recommendation:** keep Migration Cockpit. Gain from switching to BAPI is marginal (10–20%).

### 3.5 Open Production Order — 60h ⚠️ largest bottleneck
- **Target tables:** AFKO (443k), AFPO (443k), AFVC (1M), AFVV (1M), AFRU (350k), AFFL (60k), RESB (1.74M), OBJK (105k), PEG_TASS (51k), SER05 (38k), TEXT_SAP_AUFK (89k)
- **Recommended BAPIs:**
  - **`BAPI_PRODORD_CREATE`** — creates header + operations + components
  - **`BAPI_PRODORD_CHANGE`** — complements fields not covered on creation
  - **`BAPI_PRODORDCONF_CREATE_TT`** / `BAPI_PRODORDCONF_CREATE_HDR` — confirmations (AFRU)
- **Table coverage:**
  | Table | Covered by BAPI? | Notes |
  |---|---|---|
  | AFKO, AFPO, AFVC, AFVV, AFFL, RESB | Yes | via `BAPI_PRODORD_CREATE` |
  | AFRU | Yes | via confirmation BAPI (separate) |
  | PEG_TASS (pegging) | **No** | Custom Z update or specific API |
  | SER05 (serial numbers) | **No** | `BAPI_SERNR_ADD_TO_DOCUMENT` |
  | TEXT_SAP_AUFK | Yes | via `SAVE_TEXT` in batch |
- **Coverage:** **Partial**
- **Recommendation:** proof of concept before deciding. The current *Child Order LSMW* takes ~40h — if `BAPI_PRODORD_CREATE` covers the fields in use, the gain can be substantial; otherwise, keep LSMW.

### 3.6 Material Equipment Conversion (from MFC ECC) — 40h ⚠️ largest volume
- **Target tables:** EQUZ (38,457,154), EQUI (20,767,496)
- **Recommended BAPI:** **`BAPI_EQUI_CREATE`** + **`BAPI_EQUI_CHANGE`** (or `BAPI_EQMI_CREATE` to install at a Functional Location)
- **Table coverage:**
  | Table | Covered by BAPI? |
  |---|---|
  | EQUI | Yes (master data) |
  | EQUZ | Yes (usage period / installation) |
- **Coverage:** **High**
- **Migration Cockpit — object:** "Equipment"
- **Recommendation:** **top refactor candidate**. Massive volume (~59M) + mature BAPI + tables fully covered. Also consider scope reduction on EQUZ (current status only, no full history) — this may save more hours than any technical optimization.

### 3.7 Open PO Conversion — 30h
- **Target tables:** EKKO_PO (28k), EKPO_PO (49k), EKKN_PO (50k), EKET_PO (80k), RESB_PO (4k), ESLL_PO (78), STXL_PO (3M), **ZLPO_WBS_BRKDWN (125k)**, **ZSC_PO_TEXT_KEY (612k)**, **PRCD_ELEMENTS_PO (19k)**
- **Recommended BAPI:** **`BAPI_PO_CREATE1`**
- **Table coverage:**
  | Table | Covered by BAPI? | Notes |
  |---|---|---|
  | EKKO_PO / EKPO_PO / EKKN_PO / EKET_PO / RESB_PO / ESLL_PO / STXL_PO | Yes | via standard `BAPI_PO_CREATE1` |
  | ZLPO_WBS_BRKDWN | **No** | Custom Z table — post-BAPI update |
  | ZSC_PO_TEXT_KEY | **No** | Custom Z table — post-BAPI update |
  | PRCD_ELEMENTS_PO | Partial | If manual conditions → `POCOND`/`POCONDX`. If determined by pricing procedure → let SAP recalculate |
- **Coverage:** **Medium**
- **Recommendation:** BAPI + post-commit Z routine for the Z tables. Estimate already accounts for this additional effort.

---

## 4. ROI Analysis — Potential Gain

| # | Object | Current (h) | Realistic gain | Projected (h) | Savings (h) | % Savings |
|---|---|---:|---|---:|---:|---:|
| 6 | Material Equipment | 40 | 50–75% | 10–20 | **20–30** | **60%** |
| 5 | Open Production Order | 60 | 20–40% | 36–48 | 12–24 | 30% |
| 7 | Open PO Conversion | 30 | 40–60% | 12–18 | 12–18 | 50% |
| 2 | Open Purchase Orders | 12 | 40–60% | 5–7 | 5–7 | 50% |
| 3 | Vendor Open Items | 10 | 50–70% | 3–5 | 5–7 | 60% |
| 4 | Maintenance Work Order | 10 | 10–20% | 8–9 | 1–2 | 15% |
| 1 | Inventory EWM | 24 | 0–20% | 20–24 | 0–4 | 10% |
|   | **TOTAL** | **186** | | **94–131** | **55–92** | **30–50%** |

### Savings distribution by object (conservative scenario ~55h)

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

## 5. Suggested Implementation Plan

### Phase 1 — Quick wins (ROI-focused)
| Sprint | Object | Deliverable | Expected gain |
|---|---|---|---:|
| S1 | **Material Equipment** | Z program with `BAPI_EQUI_CREATE` + package 500 + parallelism | 20–30h |
| S1 | **Vendor Open Items** | Z program with `BAPI_ACC_DOCUMENT_POST` + package 200 + parallelism | 5–7h |
| S2 | **Open PO Conversion** | Z program with `BAPI_PO_CREATE1` + post-commit Z update | 12–18h |
| S2 | **Open Purchase Orders** | Reuse code from S2 | 5–7h |

### Phase 2 — Technical evaluation
| Sprint | Object | Deliverable |
|---|---|---|
| S3 | Open Production Order | POC with `BAPI_PRODORD_CREATE` to validate field coverage and real gain |

### Phase 3 — Keep as-is
| Object | Action |
|---|---|
| Maintenance Work Order | Keep Migration Cockpit |
| Inventory EWM | Keep `/SCWM/ISU` or migrate to Migration Cockpit "Warehouse stock (EWM)" |

---

## 6. Recommended Technical Pattern (BAPI + Package + Parallelism)

Reference implementation available at:
- Classic version (Clean Core Level 3): [Paralelismo/zbapi_open_po_parallel.abap](Paralelismo/zbapi_open_po_parallel.abap)
- Modern version (Clean Core Level 1, ABAP Cloud + bgPF + RAP): [Paralelismo/zcl_po_load_orchestrator.clas.abap](Paralelismo/zcl_po_load_orchestrator.clas.abap)

### Tuning parameters per profile

| Profile | Package size | Parallelism | Scenario |
|---|---:|---:|---|
| Conservative | 50 | 3 | Production with online users |
| Balanced | 100 | 5 | Test / QA |
| Dedicated window | 200–500 | 10–20 | Weekend cutover |

### Applied principles

1. **Package of N records** per unit of work (no commit per record)
2. **`BAPI_TRANSACTION_COMMIT WAIT = 'X'`** at the end of the package (or `COMMIT ENTITIES` in RAP)
3. **`STARTING NEW TASK DESTINATION IN GROUP`** (aRFC) or **bgPF** (Level 1)
4. **`WAIT UNTIL`** or bgPF pool to limit concurrent tasks
5. **`RECEIVE RESULTS` callback** to collect the return from each package
6. **Synchronous fallback** on `RESOURCE_FAILURE`

---

## 7. Risks and Assumptions

### Technical risks
| Risk | Object | Mitigation |
|---|---|---|
| BAPI does not cover custom fields | Open Production Order, Open PO Conversion | POC before decision; complement with Z update |
| Concurrent locks under high parallelism | All | Adjust `P_PARAL`; monitor SM12 |
| Work process overload | All | Dedicated RZ12; monitor SM50 |
| Mass SAPscript text (STXL, TEXT_SAP_*) | Prod Order, PO | Use native BAPI parameter instead of standalone `SAVE_TEXT` |
| Z tables outside BAPI scope | Open PO Conversion | Z update within the same package / same LUW |
| Pricing procedure configuration | Open PO Conversion | Confirm whether PRCD_ELEMENTS_PO is manual or determined |

### Assumptions
- Target system: SAP S/4HANA 2022 On-Premise (or compatible)
- Cutover window allows parallelism in dedicated mode
- Basis will provision RZ12 server group (`parallel_generators` or equivalent) or an appropriate bgPF profile
- Source data is already cleansed / reconciled (out of scope for this gain analysis)

---

## 8. Clean Core — Compliance Level

| Approach | Clean Core Level | Cloud-ready? | Recommended for |
|---|---|---|---|
| LSMW / IDoc (current) | Level 3 | No | Legacy, likely to be deprecated |
| BAPI + aRFC (Phase 1 proposal) | Level 3 | No | Quick gain, on-premise system |
| BAPI encapsulated in class (Level 2) | Level 2 | Partial | Bridge for future migration |
| RAP + bgPF + released APIs (Level 1) | Level 1 | Yes | New cloud-first development |

For the current scenario (reduce cutover window on S/4HANA 2022 On-Premise), **Level 3 with BAPI + parallelism is sufficient and pragmatic**. Migration to Level 1 can be done later without impacting the cutover.

---

## 9. Next Steps

1. Approve the phased plan
2. POC of `BAPI_EQUI_CREATE` with a 10,000-record subset — measure actual time
3. POC of `BAPI_PRODORD_CREATE` to validate coverage on Open Production Order
4. Confirm objects available in the target system's Migration Cockpit (LTMC/LTMOM/Fiori app)
5. Align with Basis: RZ12 server group, bgPF profile, work processes available during cutover
6. Define log and reconciliation strategy per package (Application Log — `cl_bali_*`)

---

*Document generated on 2026-07-30 — ConcentoRDG Project*
