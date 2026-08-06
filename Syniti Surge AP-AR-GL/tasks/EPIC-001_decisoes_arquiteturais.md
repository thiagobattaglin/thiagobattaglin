# EPIC-001: Architecture Decisions (ADRs) — Pre-Development

> **Priority**: P0 — Blocking  
> **Owner**: Solution Architect + Product Owner  
> **Deadline**: Before any development starts  
> **Related documents**: [RI-871.md](../RI-871.md), [RDG-1592.md](../RDG-1592.md), [RDG-1593.md](../RDG-1593.md), [RDG-1594.md](../RDG-1594.md)

---

## Context

Architecture reviews identified that the feature documents (RI-871) and RDGs lack sufficient technical depth to start development. Fundamental architecture decisions must be made and documented as ADRs (Architecture Decision Records) before any implementation.

---

## Tasks

### TASK-001: ADR — Posting Mechanism (LTMC vs BAPI vs Hybrid)

| Field | Value |
|-------|-------|
| **Type** | Decision |
| **Priority** | P0 — Blocking |
| **Owner** | SAP Migration Specialist + Solution Architect |
| **Acceptance criteria** | ADR documented with decision, rejected alternatives, and consequences |

**Description**:  
Define whether loading will use: (1) Pure Migration Cockpit (LTMC); (2) Direct `BAPI_ACC_DOCUMENT_POST`; (3) Hybrid approach.

**Actions**:
- [ ] Verify available Migration Objects in the target S/4HANA release
- [ ] Test `BAPI_ACC_DOCUMENT_POST` for each transaction type (AP/AR/GL)
- [ ] Document limitations of each approach
- [ ] Produce formal ADR with decision

**Impact if delayed**: Blocks all implementation; impossible to estimate effort without knowing the mechanism.

---

### TASK-002: ADR — GL Document-Level vs Balance Carry-Forward

| Field | Value |
|-------|-------|
| **Type** | Decision |
| **Priority** | P0 — Blocking |
| **Owner** | Product Owner + Finance Consultant |
| **Acceptance criteria** | Decision documented with trade-offs accepted by client |

**Description**:  
For GL, decide between: (a) Load each individual historical document (full history, high volume); (b) Load carry-forward balances per account/period (summarized, low volume); (c) Hybrid.

**Actions**:
- [ ] Gather GL volumetrics from source (COUNT of docs per year/company)
- [ ] Present trade-offs to client (drill-down vs performance vs cost)
- [ ] Obtain Finance Controller sign-off
- [ ] Document decision in ADR

**Impact if delayed**: Defines the Migration Object (GL_ACCOUNT_BALANCE_CARRY_FORWARD vs FI_DOCUMENT_ITEM), volumetrics, and entire GL design.

---

### TASK-003: ADR — Cleared Items AP/AR (Individual vs Summarized vs Excluded)

| Field | Value |
|-------|-------|
| **Type** | Decision |
| **Priority** | P0 — Blocking |
| **Owner** | Product Owner + Finance Consultant |
| **Acceptance criteria** | Decision documented; impact on aging reports accepted |

**Description**:  
Define treatment of already cleared AP/AR documents: (a) Recreate each doc + clearing document (extreme complexity); (b) Load as summarized journal entries per period/vendor-customer; (c) Exclude from scope.

**Actions**:
- [ ] Assess technical feasibility of recreating clearing relationship via LTMC
- [ ] Present options to client with impact on reports (aging, payment history)
- [ ] Document decision

**Impact if delayed**: Blocks AP/AR design; impacts volumetrics by factor of 2-10x.

---

### TASK-004: ADR — Document Splitting Strategy

| Field | Value |
|-------|-------|
| **Type** | Decision |
| **Priority** | P0 — Blocking |
| **Owner** | FI Consultant + Solution Architect |
| **Acceptance criteria** | Target splitting characteristics documented; enrichment strategy defined |

**Actions**:
- [ ] Confirm whether Document Splitting is active in target (FAGL_SPLINFO)
- [ ] Identify splitting characteristics (Profit Center, Segment, Business Area)
- [ ] Define default values for historical documents without segmentation
- [ ] Validate zero-balance requirement per characteristic
- [ ] Document ADR

**Impact if delayed**: Loading without splitting generates irreversible inconsistency in ACDOCA.

---

### TASK-005: ADR — Currency Strategy (Parallel Currencies)

| Field | Value |
|-------|-------|
| **Type** | Decision |
| **Priority** | P1 |
| **Owner** | FI Consultant + Data Analyst |
| **Acceptance criteria** | Active currency types listed; derivation strategy defined |

**Actions**:
- [ ] Identify active currency types in target (10, 30, 40, etc.)
- [ ] Confirm availability of historical exchange rates in TCURR
- [ ] Define: does source provide all currencies or derive in staging?
- [ ] Document ADR

---

### TASK-006: ADR — Loading Sequence

| Field | Value |
|-------|-------|
| **Type** | Decision |
| **Priority** | P1 |
| **Owner** | Solution Architect |
| **Acceptance criteria** | Sequence defined with justification and dependencies |

**Actions**:
- [ ] Define order: GL → AP → AR (recommended) or alternative
- [ ] Document prerequisites per phase
- [ ] Define reconciliation gates between phases

---

### TASK-007: ADR — Number Range Strategy

| Field | Value |
|-------|-------|
| **Type** | Decision |
| **Priority** | P1 |
| **Owner** | Basis + FI Consultant |
| **Acceptance criteria** | Dedicated number range interval reserved for loading; strategy documented |

**Actions**:
- [ ] Reserve dedicated number range interval via FBN1
- [ ] Define: internal numbering (SAP assigns) with XBLNR for audit trail
- [ ] Calculate required capacity (volume × 2 for reversal headroom)
- [ ] Document ADR

---

### TASK-008: ADR — Fiscal Period Management

| Field | Value |
|-------|-------|
| **Type** | Decision |
| **Priority** | P1 |
| **Owner** | FI Consultant + Basis |
| **Acceptance criteria** | Open/close procedure defined; auth controls documented |

**Actions**:
- [ ] Define opening strategy (per account type, per period)
- [ ] Define security controls during open window (auth group BRGRU)
- [ ] Document sequence: open → load → reconcile → close

---

### TASK-009: ADR — Idempotency and Reprocessing

| Field | Value |
|-------|-------|
| **Type** | Decision |
| **Priority** | P1 |
| **Owner** | Solution Architect |
| **Acceptance criteria** | Dedup mechanism defined; idempotency key specified |

**Actions**:
- [ ] Define idempotency key: XBLNR + BUKRS + GJAHR + BLDAT
- [ ] Design staging table with status (NEW/PROCESSING/POSTED/ERROR/SKIPPED)
- [ ] Validate that re-run does not generate duplicates

---

### TASK-010: ADR — Rollback/Reversal Strategy

| Field | Value |
|-------|-------|
| **Type** | Decision |
| **Priority** | P1 |
| **Owner** | Solution Architect |
| **Acceptance criteria** | Reversal mechanism defined per granularity; mass reversal program specified |

**Actions**:
- [ ] Define mechanism: `BAPI_ACC_DOCUMENT_REV_POST`
- [ ] Define granularity: per doc, per chunk, per phase
- [ ] Define document identification for reversal (BKTXT pattern + NR range)
- [ ] Accept trade-off of NR consumed in reversal
