# EPIC-004: GL Historic Loading Implementation

> **Priority**: P0  
> **Owner**: ABAP Developer + Data Analyst  
> **Prerequisites**: EPIC-003 (Infrastructure) completed; Master data (CoA, Profit Centers) migrated  
> **Related documents**: [RDG-1592.md](../RDG-1592.md), [RI-871.md](../RI-871.md)

---

## Context

Implementation of historic GL data loading into S/4HANA. GL is the first transaction to be loaded as it does not depend on AP/AR, and serves as the basis for cross-module reconciliation afterward.

---

## Tasks

### TASK-029: Data Mapping GL — Source to Target

| Field | Value |
|-------|-------|
| **Type** | Design |
| **Priority** | P0 |
| **Owner** | Data Analyst + FI Consultant |
| **Acceptance criteria** | Complete mapping document with transformation rules per field |

**Actions**:
- [ ] Map all source → target fields (per blueprint section 4.1.3)
- [ ] Define transformation rules (account mapping, currency conversion, PC derivation)
- [ ] Identify fields with no source equivalent → define defaults
- [ ] Validate with client Finance SME
- [ ] Document mapping in structured spreadsheet

---

### TASK-030: Extraction GL — Source System

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | Data Analyst / ABAP Developer |
| **Acceptance criteria** | GL data extracted in standardized format; volume confirmed |

**Actions**:
- [ ] Develop extraction from BKPF + BSEG (GL items) from source
- [ ] Filter: only GL doc types (SA, SB, etc. per scope)
- [ ] Include audit trail fields (original CPUDT, CPUTM, USNAM)
- [ ] Generate output in standardized CSV/XML
- [ ] Validate extracted volume vs expectation (TASK-017)

---

### TASK-031: Staging Transformation GL

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | Data Analyst + ABAP Developer |
| **Acceptance criteria** | GL data transformed and ready for posting; pre-posting validations pass |

**Actions**:
- [ ] Implement account mapping (source CoA → target CoA)
- [ ] Implement currency conversion (parallel currencies via TCURR)
- [ ] Implement Profit Center derivation (default if missing)
- [ ] Implement Segment derivation (from Profit Center, via FAGL_SEGM)
- [ ] Implement validations V1-V8 (per blueprint section 4.1.4)
- [ ] Generate payload in BAPI format
- [ ] Load staging table with status NEW

---

### TASK-032: GL Balance Carry-Forward Loading

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 (if decided in ADR-002 as approach) |
| **Owner** | ABAP Developer + SAP Migration Specialist |
| **Acceptance criteria** | Opening balances loaded; FAGLB03 shows correct trial balance |

**Actions**:
- [ ] Prepare opening balances by account/company/period/PC
- [ ] Use Migration Object (if available) or BAPI_ACC_DOCUMENT_POST with carry-forward doc type
- [ ] Post balances
- [ ] Validate trial balance (FAGLB03) in target vs source
- [ ] Reconciliation: target opening balance = legacy closing balance

---

### TASK-033: GL Document-Level Loading

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 (if decided in ADR-002 as approach) |
| **Owner** | ABAP Developer |
| **Acceptance criteria** | Individual GL documents posted; visible in FAGLL03H; ACDOCA populated |

**Actions**:
- [ ] Execute loading by chunks (orchestrator)
- [ ] Dry-run first (BAPI_ACC_DOCUMENT_CHECK)
- [ ] Actual posting (BAPI_ACC_DOCUMENT_POST)
- [ ] Commit strategy: every 1000 docs
- [ ] Post-chunk reconciliation
- [ ] Validate ACDOCA: mandatory fields populated
- [ ] Validate FAGLL03H: documents visible
- [ ] Phase reconciliation: trial balance

---

### TASK-034: GL Reconciliation (Post-Phase)

| Field | Value |
|-------|-------|
| **Type** | Validation |
| **Priority** | P0 |
| **Owner** | Data Analyst + FI Consultant |
| **Acceptance criteria** | Target trial balance = source ± tolerance; reconciliation report approved |

**Actions**:
- [ ] Execute reconciliation engine (rules R4, R5, R6, R7)
- [ ] Compare FAGLB03 (target) vs trial balance (source) by account/period
- [ ] Investigate discrepancies > tolerance
- [ ] Produce reconciliation report
- [ ] Obtain Finance Controller sign-off to proceed to AP

---

### TASK-035: Update RDG-1592 with technical detail

| Field | Value |
|-------|-------|
| **Type** | Documentation |
| **Priority** | P1 |
| **Owner** | Solution Architect |
| **Acceptance criteria** | RDG-1592 contains: Migration Object used, field mapping, constraints, limitations |

**Actions**:
- [ ] Add "Technical Approach" section with Migration Object/BAPI used
- [ ] Add "Field Mapping" section with fields table
- [ ] Add "Constraints & Limitations" section with effective limitations (found in POC)
- [ ] Add "Supported Document Types" section with list
- [ ] Add "Document Splitting Handling" section
- [ ] Review and approve
