# 4-Week POC Delivery Plan — BAPI Migration Refactor
## Scope: 6 Migration Objects (excluding Inventory EWM)

**Project:** ConcentoRDG
**Basis:** Migration-BAPI-Report.md (2026-07-30)
**Duration:** 4 weeks
**Objective:** Deliver an executable Proof of Concept for each of the 6 objects, with measured performance evidence for the cutover committee to decide on full-scale refactor.

---

## 1. Overview

Each of the 6 objects is treated as an **independent workstream** with its own scope, deliverable, sample volume and acceptance criteria. Workstreams run in parallel across the 4 weeks.

### 1.1 Objects in scope

| # | Object | Current (h) | Target BAPI | Complexity | Priority |
|---:|---|---:|---|---|---|
| 1 | Material Equipment Conversion | 40 | `BAPI_EQUI_CREATE` / `BAPI_EQUI_CHANGE` | Low | P1 |
| 2 | Vendor Open Items | 10 | `BAPI_ACC_DOCUMENT_POST` | Low | P1 |
| 3 | Open Purchase Orders | 12 | `BAPI_PO_CREATE1` | Medium | P2 |
| 4 | Open PO Conversion | 30 | `BAPI_PO_CREATE1` + Z post-update | Medium | P2 |
| 5 | Maintenance Work Order | 10 | `BAPI_ALM_ORDER_MAINTAIN` | Medium | P3 |
| 6 | Open Production Order | 60 | `BAPI_PRODORD_CREATE` + `BAPI_PRODORDCONF_CREATE_TT` | High | P3 |

### 1.2 POC volumes (sample size per object)

| Object | Sample size | Rationale |
|---|---:|---|
| Material Equipment | 100,000 | Extrapolable to 59M with confidence |
| Vendor Open Items | 20,000 | Represents 4% of total volume |
| Open Purchase Orders | 10,000 | Full document + items + services |
| Open PO Conversion | 20,000 | Includes Z table update paths |
| Maintenance Work Order | 5,000 | Baseline vs current Cockpit run |
| Open Production Order | 5,000 | Focus on Child Order path |

### 1.3 High-level timeline

```
             W1              W2              W3              W4
             |---------------|---------------|---------------|---------------|
Material Eq. [DEV=======][TEST][MEASURE][DOC]
Vendor OI    [DEV=======][TEST][MEASURE][DOC]
Purch Orders               [DEV=======][TEST][MEASURE][DOC]
PO Convers.                [DEV=======][TEST][MEASURE][DOC]
Maint Order                          [DEV======][TEST][MEASURE][DOC]
Prod Order                           [DEV==============][TEST][MEASURE][DOC]
Consolidation                                                  [====REPORT====]
```

---

## 2. Common Setup (Week 1, days 1–2 — shared across all workstreams)

Applied once, reused by every object:

| # | Task | Owner | Effort |
|---|---|---|---|
| 1 | Reuse the reference package/parallelism/commit pattern from `zbapi_open_po_parallel.abap` | Tech Lead | 0.5 day |
| 2 | Create `ZCL_MIG_CONTEXT` class (migration mode flag for BAdI bypass) | ABAP Dev | 0.5 day |
| 3 | Align with Basis on RZ12 server group (`parallel_generators`) | Tech Lead + Basis | 0.5 day |
| 4 | Setup Application Log object `ZMIG_LOAD` for per-package logging | ABAP Dev | 0.5 day |
| 5 | Prepare QA staging tables for all 6 sample datasets | Data team | 1 day |
| 6 | Define measurement protocol (start/end timestamps, records/sec, errors) | Tech Lead | 0.5 day |

Deliverables at end of common setup:
- `ZCL_MIG_CONTEXT` class active
- `ZMIG_LOAD` application log object
- Common Z program template for BAPI + package + parallel calls
- RZ12 group provisioned
- Staging tables loaded with sample data

---

## 3. Workstream 1 — Material Equipment Conversion

**Priority:** P1 (largest volume, highest ROI)
**Sample:** 100,000 records
**Current:** 40h on ~59M records via LSMW/IDoc
**Target BAPIs:** `BAPI_EQUI_CREATE`, `BAPI_EQUI_CHANGE`, optionally `BAPI_EQMI_CREATE` (install at FL)

### Week 1
| Day | Task | Deliverable |
|---|---|---|
| 1–2 | Field mapping analysis (source ↔ EQUI + EQUZ) | Mapping spreadsheet |
| 3 | Create `ZCL_MIG_EQUIP_LOADER` from template | Class stub compiles |
| 4–5 | Implement BAPI call + package handler + parallel dispatcher | Program runs single package |

### Week 2
| Day | Task | Deliverable |
|---|---|---|
| 1–2 | Wire up staging read + result sink | End-to-end pipeline works |
| 3 | Test package sizes 100 / 500 / 1000 in QA | Best size identified |
| 4 | Run 10,000-record test — measure records/sec | Baseline measurement |
| 5 | Run 100,000-record test — measure elapsed time + errors | Final measurement |

### Week 3
| Day | Task | Deliverable |
|---|---|---|
| 1 | Data validation vs source (EQUI + EQUZ counts, master data equality) | Validation report |
| 2 | Extrapolation to full 59M volume | Estimated cutover time |
| 3 | Documentation of Z program + operating instructions | Runbook |

### Week 4
| Day | Task | Deliverable |
|---|---|---|
| 1 | Prepare demo for the committee | Demo package |
| 2–3 | Contribute results to consolidated POC report | Section in final report |

### Success criteria
- ≥ 60% reduction in extrapolated time vs the current 40h
- 100% functional consistency (EQUI + EQUZ record counts match source)
- No production-blocking BAPI messages beyond the acceptable list

---

## 4. Workstream 2 — Vendor Open Items

**Priority:** P1 (high gain, low complexity)
**Sample:** 20,000 records
**Current:** 10h via LSMW/IDoc
**Target BAPI:** `BAPI_ACC_DOCUMENT_POST` (or `BAPI_ACC_AP_DOCUMENT_POST`)

### Week 1
| Day | Task | Deliverable |
|---|---|---|
| 1–2 | Field mapping — BKPF/BSEG/WITH_ITEM ↔ BAPI structures | Mapping spreadsheet |
| 3 | Create `ZCL_MIG_VENDOR_OI_LOADER` from template | Class stub |
| 4–5 | Implement BAPI call including `EXTENSION1/2` for withholding | Program runs single package |

### Week 2
| Day | Task | Deliverable |
|---|---|---|
| 1 | Wire up staging + sink | End-to-end pipeline |
| 2 | Configure package size (recommended start: 200) | Package size set |
| 3–4 | QA test with 5,000 then 20,000 records | Measurements captured |
| 5 | Reconcile BSEG + WITH_ITEM counts against source | Validation report |

### Week 3
| Day | Task | Deliverable |
|---|---|---|
| 1 | Withholding tax validation (WITH_ITEM correctness) | Validation checklist |
| 2 | Extrapolation to full ~465k records | Estimated cutover time |
| 3 | Runbook documentation | Operating doc |

### Week 4
| Day | Task | Deliverable |
|---|---|---|
| 1 | Committee demo prep | Demo package |
| 2–3 | Contribute to consolidated report | Section in final report |

### Success criteria
- ≥ 50% reduction vs 10h
- WITH_ITEM records fully match source
- No open items with wrong assignment / clearing status

---

## 5. Workstream 3 — Open Purchase Orders

**Priority:** P2 (medium complexity, code reused with Workstream 4)
**Sample:** 10,000 documents
**Current:** 12h via LSMW/IDoc
**Target BAPI:** `BAPI_PO_CREATE1`

### Week 2
| Day | Task | Deliverable |
|---|---|---|
| 1 | Field mapping — EKKO/EKPO/EKKN/EKET/EKPA/STXH/STXL/ESLH/ESLL | Mapping spreadsheet |
| 2 | Create `ZCL_MIG_PO_LOADER` from template | Class stub |
| 3 | Implement header + item + account assignment + schedule + partners | Basic PO creates |
| 4 | Implement services (ESLH/ESLL) via `POSERVICES` + `POSRVACCESSVALUES` | Services work |
| 5 | Implement item texts (STXH/STXL) via `POITEM_TEXT` / `POTEXTHEADER` | Texts persisted |

### Week 3
| Day | Task | Deliverable |
|---|---|---|
| 1 | QA test with 1,000 documents — verify all tables | Baseline OK |
| 2 | QA test with 10,000 documents — parallel run | Measurements captured |
| 3 | Reconciliation vs source (all 9 tables) | Validation report |
| 4 | Extrapolation to full ~838k volume | Estimated cutover time |
| 5 | Runbook + operating doc | Documentation |

### Week 4
| Day | Task | Deliverable |
|---|---|---|
| 1 | Committee demo prep | Demo package |
| 2–3 | Contribute to consolidated report | Section in final report |

### Success criteria
- ≥ 40% reduction vs 12h
- All 9 target tables populated correctly
- Services and long texts validated on random sample

---

## 6. Workstream 4 — Open PO Conversion (with Z tables)

**Priority:** P2 (reuses Workstream 3 code + Z post-processing)
**Sample:** 20,000 documents
**Current:** 30h via LSMW/IDoc
**Target BAPI:** `BAPI_PO_CREATE1` + Z routine for ZLPO_WBS_BRKDWN, ZSC_PO_TEXT_KEY, PRCD_ELEMENTS_PO

### Week 2
| Day | Task | Deliverable |
|---|---|---|
| 1 | Reuse `ZCL_MIG_PO_LOADER` from Workstream 3 as base | Class fork ready |
| 2 | Add Z post-update method for ZLPO_WBS_BRKDWN | Z update works |
| 3 | Add Z post-update method for ZSC_PO_TEXT_KEY | Z update works |
| 4 | Investigate PRCD_ELEMENTS_PO: manual vs determined? | Decision documented |
| 5 | Implement condition handling per decision (POCOND/POCONDX or SAP recalc) | Conditions handled |

### Week 3
| Day | Task | Deliverable |
|---|---|---|
| 1 | QA test with 2,000 documents (small batch) | Baseline OK |
| 2 | QA test with 20,000 documents (parallel run) | Measurements captured |
| 3 | Reconciliation vs source (10 tables including Z) | Validation report |
| 4 | Extrapolation to full ~4M volume | Estimated cutover time |
| 5 | Runbook + operating doc | Documentation |

### Week 4
| Day | Task | Deliverable |
|---|---|---|
| 1 | Committee demo prep | Demo package |
| 2–3 | Contribute to consolidated report | Section in final report |

### Success criteria
- ≥ 40% reduction vs 30h
- Z tables fully populated within same LUW as PO creation
- Pricing procedure decision validated with Functional lead

---

## 7. Workstream 5 — Maintenance Work Order

**Priority:** P3 (already in Cockpit — POC compares BAPI approach vs current Cockpit)
**Sample:** 5,000 orders
**Current:** 10h via Migration Cockpit
**Target BAPI:** `BAPI_ALM_ORDER_MAINTAIN`

Note: this POC is comparative. It is possible that Migration Cockpit remains the better option — the deliverable is the evidence to decide.

### Week 2 (last 2 days)
| Day | Task | Deliverable |
|---|---|---|
| 4 | Field mapping — AUFK/AFVC/RESB/OBJK/TEXT_SAP_AFVC ↔ BAPI structures | Mapping |
| 5 | Create `ZCL_MIG_PM_ORDER_LOADER` from template | Class stub |

### Week 3
| Day | Task | Deliverable |
|---|---|---|
| 1 | Implement header + operations + components + object list | Basic order creates |
| 2 | Implement long text via `LONGTEXTS` parameter | Texts persist |
| 3 | QA test with 500 orders | Baseline OK |
| 4 | QA test with 5,000 orders (parallel run) | Measurements captured |
| 5 | Comparison vs current Cockpit run of same 5,000 | Comparative report |

### Week 4
| Day | Task | Deliverable |
|---|---|---|
| 1 | Decision recommendation (BAPI vs Cockpit) | Decision doc |
| 2–3 | Contribute to consolidated report | Section in final report |

### Success criteria
- Head-to-head measurement of BAPI vs Cockpit on same 5,000-order dataset
- Clear recommendation with justification
- If gain < 20%, recommend keeping Cockpit (as originally in report §3.4)

---

## 8. Workstream 6 — Open Production Order

**Priority:** P3 (highest risk / partial BAPI coverage)
**Sample:** 5,000 orders (focus on Child Order path — the current 40h bottleneck)
**Current:** 60h via LSMW multipart (Parent 5h + Child 40h + Confirm 5h + Long Text 5h + Custom LSMW untested)
**Target BAPIs:**
- `BAPI_PRODORD_CREATE` (Parent + Child header + operations + components)
- `BAPI_PRODORD_CHANGE` (fields not covered on creation)
- `BAPI_PRODORDCONF_CREATE_TT` / `_HDR` (AFRU confirmations)
- `SAVE_TEXT` (TEXT_SAP_AUFK)
- `BAPI_SERNR_ADD_TO_DOCUMENT` (SER05 serial numbers)
- Custom Z update for PEG_TASS (pegging)

### Week 2 (last 2 days)
| Day | Task | Deliverable |
|---|---|---|
| 4–5 | Field coverage analysis — verify what `BAPI_PRODORD_CREATE` covers vs current LSMW fields | Coverage matrix + gap list |

### Week 3
| Day | Task | Deliverable |
|---|---|---|
| 1 | Create `ZCL_MIG_PROD_ORDER_LOADER` from template | Class stub |
| 2 | Implement Parent Order creation | Parent orders create |
| 3 | Implement Child Order creation (the 40h bottleneck) | Child orders create |
| 4 | Implement AFRU confirmations via confirmation BAPI | Confirmations posted |
| 5 | Implement long text (SAVE_TEXT) + serial numbers (SER05) | Texts + serials attached |

### Week 4
| Day | Task | Deliverable |
|---|---|---|
| 1 | Implement PEG_TASS Z update (in same LUW as order) | PEG_TASS populated |
| 2 | QA test with 500 orders (all components) | Baseline OK |
| 3 | QA test with 5,000 orders (parallel run) | Measurements captured |
| 4 | Coverage assessment — decide GO / NO-GO for full refactor | Decision doc |
| 5 | Contribute to consolidated report | Section in final report |

### Success criteria
- Coverage gap assessment complete before development starts
- Measured time for Child Order path (currently 40h)
- Clear GO / NO-GO recommendation for full refactor
- If gap too large, fallback: keep LSMW for Child Order, use BAPI for the other 3 parts

### Risk mitigation
- Given the partial BAPI coverage risk flagged in the report, this workstream carries the highest chance of a NO-GO outcome. Plan explicitly accepts that outcome as a valid deliverable.

---

## 9. Week-by-Week Consolidation

### Week 1 — Foundations + Quick Wins Start
- Common setup complete (Days 1–2)
- Material Equipment and Vendor Open Items in dev
- Staging data loaded for all 6 objects

### Week 2 — Purchase Orders + PO Conversion Start
- Material Equipment and Vendor Open Items in test/measure
- Open Purchase Orders and Open PO Conversion in dev
- Maintenance Work Order and Production Order start field analysis

### Week 3 — Complex Objects
- Purchase Orders and PO Conversion in test/measure
- Maintenance Work Order and Production Order in dev
- Material Equipment and Vendor Open Items produce documentation

### Week 4 — Consolidation
- Maintenance Work Order and Production Order in test/measure
- All 6 workstreams contribute results to a single consolidated report
- Committee demo prepared
- Final GO / NO-GO decision recommended per object

---

## 10. Team and Roles

| Role | Headcount | Responsibility |
|---|---:|---|
| Tech Lead (SAP) | 1 | Coordination, common setup, code review, RZ12 alignment |
| ABAP Developer — MM/SD | 1 | Purchase Orders + PO Conversion |
| ABAP Developer — FI | 1 | Vendor Open Items |
| ABAP Developer — PM/PP | 1 | Maintenance Work Order + Production Order |
| ABAP Developer — LO | 1 | Material Equipment |
| Basis | 0.5 | RZ12 group, work processes, Application Log config |
| Functional (multi-track) | 0.5 each track | Validate mappings, condition procedure, coverage decisions |

Minimum viable team: 1 Tech Lead + 3 developers + 0.5 Basis + Functional support on demand.

---

## 11. Deliverables per Object

Standard deliverables at the end of Week 4 for every workstream:

1. Working Z program (class + class-run entry point) in QA
2. Field mapping spreadsheet
3. Measurement report (records/sec, elapsed time, error rate)
4. Extrapolation to full production volume
5. Reconciliation report vs source
6. Runbook (how to execute during cutover)
7. GO / NO-GO recommendation with justification

## 12. Consolidated POC Report (end of Week 4)

Single document consolidating all 6 workstreams, containing:

- Actual measured gain per object (vs the original report's estimates)
- Updated projected total window (based on measured, not estimated)
- GO / NO-GO recommendation per object
- Risk log per object
- Next-phase plan for approved objects (full-scale refactor)

---

## 13. Success Criteria for the POC as a Whole

| Criterion | Threshold |
|---|---|
| Objects with measured GO recommendation | ≥ 4 of 6 |
| Extrapolated total window reduction | ≥ 25% vs current 186h (excluding EWM) |
| Zero data-integrity issues in reconciliation | Mandatory for GO |
| Runbook completeness | 100% for GO objects |
| Committee sign-off | Required at end of Week 4 |

---

## 14. Risks

| # | Risk | Impact | Mitigation |
|---|---|---|---|
| 1 | `BAPI_PRODORD_CREATE` coverage gap wider than expected | Prod Order workstream returns NO-GO | Explicit early gap analysis (W2 D4-5); fallback plan documented |
| 2 | RZ12 server group not provisioned in time | All parallel tests delayed | Basis alignment on Day 1 |
| 3 | Custom BAdI logic distorts measurements | Numbers not representative | Use `ZCL_MIG_CONTEXT` bypass flag during POC runs |
| 4 | QA data volume insufficient for extrapolation | Weak evidence for committee | Load real production-copy volumes for the 6 samples |
| 5 | Functional validation slow (mapping approval) | Development blocked | Pre-book functional hours per workstream in Week 1 |
| 6 | Lock contention under parallelism in QA | Measurements skewed | Run in dedicated QA window, no online users |

---

## 15. Out of Scope

- **Inventory EWM (`/SCWM/ISU`)** — separate trace-based analysis already delivered (`Inventory-EWM-Trace-Analysis.md`)
- Full-scale refactor beyond POC (planned as next phase for GO objects)
- Production deployment
- Data cleansing / reconciliation of source data (assumed done)
- Level 1 Clean Core refactor (documented as future roadmap in main report)

---

*Document generated on 2026-08-03 — ConcentoRDG Project — 4-Week POC Plan*
