# EPIC-003: Infrastructure & Framework Development

> **Priority**: P0  
> **Owner**: Senior ABAP Developer  
> **Prerequisites**: EPIC-001 (ADRs) and EPIC-002 (POC) completed  
> **Related documents**: [RDG-1590.md](../RDG-1590.md), [RDG-1591.md](../RDG-1591.md)

---

## Context

Development of infrastructure components to be reused by all flows (GL, AP, AR): staging layer, orchestration engine, error handler, reconciliation engine, monitoring.

---

## Tasks

### TASK-021: Design and create Staging Table

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | ABAP Developer |
| **Acceptance criteria** | Z table created with control fields; per-record status functional |

**Description**:  
Create table `ZTB_HIST_STAGING` (or name per naming convention) with:
- Identification fields: UUID, RUN_ID, PHASE, CHUNK_ID, DOC_INDEX
- Control fields: STATUS (NEW/PROCESSING/POSTED/ERROR/SKIPPED), TIMESTAMP, ATTEMPTS
- Payload fields: document reference (XBLNR, BUKRS, GJAHR, BLDAT)
- Result fields: TARGET_BELNR (number assigned by SAP), ERROR_MSG

**Actions**:
- [ ] Define table structure (data elements, domains)
- [ ] Create table via ADT (ABAP Cloud — Tier 1)
- [ ] Create CDS View over the table for queries
- [ ] Unit test: insert/update/read

---

### TASK-022: Design and create Checkpoint Table

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | ABAP Developer |
| **Acceptance criteria** | Table enables precise restart after failure |

**Description**:  
Create table `ZTB_HIST_CHECKPOINT` with:
- RUN_ID, PHASE, CHUNK_ID, LAST_DOC_IDX, STATUS, TIMESTAMP, DOCS_PROCESSED, DOCS_FAILED

**Actions**:
- [ ] Define structure
- [ ] Create table (ABAP Cloud)
- [ ] Implement checkpoint write logic (after each COMMIT WORK)
- [ ] Implement restart read logic (find last checkpoint with STATUS='COMMITTED')

---

### TASK-023: Orchestration Engine (main class)

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | Senior ABAP Developer |
| **Acceptance criteria** | Engine executes end-to-end flow with mock; controls chunks, commits, checkpoints |

**Description**:  
Class `ZCL_HIST_ORCHESTRATOR` (ABAP Cloud) responsible for:
- Receiving payload from staging
- Partitioning into chunks (configurable)
- Invoking posting layer per chunk
- Managing COMMIT WORK with configurable frequency
- Updating checkpoint table
- Invoking error handler on failure
- Invoking reconciliation engine after each chunk/phase
- Controlling advancement gate between phases

**Actions**:
- [ ] Design class (interfaces, public/private methods)
- [ ] Implement chunk loop with COMMIT
- [ ] Implement checkpoint logic
- [ ] Implement error handler invocation
- [ ] Implement reconciliation gate
- [ ] Unit tests with mock posting layer

---

### TASK-024: Error Handler & Recovery

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | ABAP Developer |
| **Acceptance criteria** | Errors categorized; retry functional; Application Log populated |

**Description**:  
Class `ZCL_HIST_ERROR_HANDLER` that:
- Categorizes errors (CONNECTIVITY, VALIDATION, POSTING_REJECT, AUTH, LOCK, NR_EXHAUSTED, TIMEOUT, DUPLICATE, SYSTEM)
- Applies retry policy (max 3 attempts with backoff)
- Logs to Application Log (SLG1) via `CL_BAL_LOG`
- Updates staging table with ERROR status + message

**Actions**:
- [ ] Create Application Log subobject: ZSURGE / HIST_LOAD (via SLG0)
- [ ] Implement error handling class
- [ ] Implement retry logic with exponential backoff
- [ ] Implement categorization by BAPI return (type E, A, W)
- [ ] Unit tests for each error category

---

### TASK-025: Posting Layer — BAPI Wrapper

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | ABAP Developer |
| **Acceptance criteria** | Wrapper posts GL/AP/AR documents via BAPI; returns success or structured error |

**Description**:  
Class `ZCL_HIST_POSTING` (ABAP Cloud) encapsulating:
- Call to `BAPI_ACC_DOCUMENT_CHECK` (simulation)
- Call to `BAPI_ACC_DOCUMENT_POST` (actual posting)
- Call to `BAPI_ACC_DOCUMENT_REV_POST` (reversal)
- Parsing of BAPI return messages
- Population of structures (DOCUMENTHEADER, ACCOUNTGL, ACCOUNTPAYABLE, ACCOUNTRECEIVABLE, CURRENCYAMOUNT, EXTENSION2)

**Actions**:
- [ ] Implement method POST_GL_DOCUMENT
- [ ] Implement method POST_AP_DOCUMENT
- [ ] Implement method POST_AR_DOCUMENT
- [ ] Implement method CHECK_DOCUMENT (dry-run)
- [ ] Implement method REVERSE_DOCUMENT
- [ ] Implement duplicate check (query BKPF by XBLNR)
- [ ] Integration test with real system

---

### TASK-026: Reconciliation Engine

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | ABAP Developer |
| **Acceptance criteria** | Engine executes rules R1-R8; produces pass/fail report with discrepancies |

**Description**:  
Class `ZCL_HIST_RECONCILIATION` implementing:
- Layer 1: Pre-posting validation (debit=credit per doc)
- Layer 2: Post-chunk (count + totals)
- Layer 3: Post-phase (trial balance, cross-module)
- Rules R1-R8 configurable with tolerances
- Output: structured report (pass/warn/fail per rule)

**Actions**:
- [ ] Implement rule R1 (balance per document)
- [ ] Implement rule R2 (AP subledger ↔ GL recon account)
- [ ] Implement rule R3 (AR subledger ↔ GL recon account)
- [ ] Implement rule R4 (document count)
- [ ] Implement rule R5 (totals by company/period - local currency)
- [ ] Implement rule R6 (totals by company/period - document currency)
- [ ] Implement rule R7 (opening balance target = closing balance legacy)
- [ ] Implement rule R8 (cross-ledger)
- [ ] Implement report generation (ALV + PDF + CSV)
- [ ] Unit tests for each rule

---

### TASK-027: Monitoring & Application Log Setup

| Field | Value |
|-------|-------|
| **Type** | Development + Configuration |
| **Priority** | P1 |
| **Owner** | ABAP Developer + Basis |
| **Acceptance criteria** | Logs visible in SLG1; metrics queryable via CDS View |

**Actions**:
- [ ] Configure Application Log object/subobject (SLG0): ZSURGE/HIST_LOAD
- [ ] Implement CDS View `ZCDS_LOAD_PROGRESS` over checkpoint + staging table
- [ ] Implement CDS View `ZCDS_LOAD_ERRORS` for error analysis
- [ ] Define log retention (90/180/365 days per level)
- [ ] Configure alerts (email) for CRIT events

---

### TASK-028: Mass Reversal Program

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P1 |
| **Owner** | ABAP Developer |
| **Acceptance criteria** | Program reverses batch of documents by selection; generates reversal report |

**Description**:  
Program/class for mass reversal of loaded documents, selecting by:
- BKTXT pattern (e.g., 'HIST_RUN_001%')
- Number range interval
- Date range (CPUDT)
- Company code + fiscal year

**Actions**:
- [ ] Implement document selection for reversal
- [ ] Implement reversal loop via `BAPI_ACC_DOCUMENT_REV_POST`
- [ ] Implement reversal logging
- [ ] Implement result report (docs reversed, failures)
- [ ] Test in development environment
