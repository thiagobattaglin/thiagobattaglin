# EPIC-006: AR Historic Loading Implementation

> **Priority**: P0  
> **Owner**: ABAP Developer + Data Analyst  
> **Prerequisites**: EPIC-004 (GL) with approved reconciliation; Business Partners (Customer) migrated  
> **Related documents**: [RDG-1594.md](../RDG-1594.md), [RI-871.md](../RI-871.md)

---

## Context

Implementation of historic AR data loading into S/4HANA. Can be executed in parallel with AP (EPIC-005) after GL is ready. Includes dunning data and special GL indicator handling.

---

## Tasks

### TASK-043: Data Mapping AR — Source to Target

| Field | Value |
|-------|-------|
| **Type** | Design |
| **Priority** | P0 |
| **Owner** | Data Analyst + FI Consultant |
| **Acceptance criteria** | Complete AR mapping including dunning data and special GL |

**Actions**:
- [ ] Map source → target fields (per blueprint section 4.3.3)
- [ ] Map Customer → Business Partner
- [ ] Define Dunning Data treatment (MANST, MADAT, MABER)
- [ ] Define Special GL indicator treatment (customer down payments)
- [ ] Define intercompany receivables treatment
- [ ] Validate with Finance SME

---

### TASK-044: Extraction AR — Source System

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | Data Analyst |
| **Acceptance criteria** | AR open + cleared items extracted; dunning data included |

**Actions**:
- [ ] Extract BSID (AR open items) with dunning fields (MANST, MADAT, MABER)
- [ ] Extract BSAD (AR cleared items)
- [ ] Include credit management data (if relevant)
- [ ] Generate output: AR_OPEN.csv, AR_CLEARED.csv
- [ ] Validate volumes

---

### TASK-045: Staging Transformation AR

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | Data Analyst + ABAP Developer |
| **Acceptance criteria** | AR payload ready; BP mapping resolved; dunning preserved |

**Actions**:
- [ ] Implement Customer → BP mapping
- [ ] Implement currency conversion
- [ ] Implement Profit Center / Segment derivation
- [ ] Implement dunning data preservation
- [ ] Implement validations (section 4.3.4)
- [ ] Disable credit limit check for historical loading
- [ ] Separate open vs cleared
- [ ] Load staging table

---

### TASK-046: AR Open Items Loading

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | ABAP Developer |
| **Acceptance criteria** | AR open items posted; visible in FBL5N; dunning data preserved; recon account OK |

**Actions**:
- [ ] Open fiscal period (account type D)
- [ ] Dry-run (BAPI_ACC_DOCUMENT_CHECK)
- [ ] Post via BAPI_ACC_DOCUMENT_POST (structure ACCOUNTRECEIVABLE)
- [ ] Commit every 1000 docs
- [ ] Validate BSID populated
- [ ] Validate FBL5N: customer balances correct
- [ ] Validate dunning level (MANST) preserved
- [ ] Validate reconciliation account updated
- [ ] Post-chunk reconciliation

---

### TASK-047: AR Cleared Items Loading (Summarized)

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P1 |
| **Owner** | ABAP Developer |
| **Acceptance criteria** | Cleared history loaded as journal entries |

**Actions**:
- [ ] Aggregate cleared items by period/customer group
- [ ] Create summarized GL journal entries
- [ ] Preserve reference in XBLNR/SGTXT
- [ ] Post via BAPI
- [ ] Validate correct GL balance

---

### TASK-048: AR Cross-Module Reconciliation

| Field | Value |
|-------|-------|
| **Type** | Validation |
| **Priority** | P0 |
| **Owner** | Data Analyst + FI Consultant |
| **Acceptance criteria** | AR subledger = GL reconciliation account; report approved |

**Actions**:
- [ ] Execute rule R3 (AR subledger ↔ GL recon account)
- [ ] Compare: Σ customer balances (FBL5N) = reconciliation account balance (FAGLB03)
- [ ] Investigate discrepancies
- [ ] Produce report
- [ ] Sign-off

---

### TASK-049: Update RDG-1594 with technical detail

| Field | Value |
|-------|-------|
| **Type** | Documentation |
| **Priority** | P1 |
| **Owner** | Solution Architect |
| **Acceptance criteria** | RDG-1594 complete |

**Actions**:
- [ ] Add Technical Approach
- [ ] Add Field Mapping (including dunning fields)
- [ ] Add Constraints and Limitations
- [ ] Add Business Partner mapping requirement
- [ ] Add Dunning data handling (BAPI limitations if found)
