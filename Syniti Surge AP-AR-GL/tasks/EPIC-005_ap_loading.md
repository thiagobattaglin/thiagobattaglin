# EPIC-005: AP Historic Loading Implementation

> **Priority**: P0  
> **Owner**: ABAP Developer + Data Analyst  
> **Prerequisites**: EPIC-004 (GL) with approved reconciliation; Business Partners (Vendor) migrated  
> **Related documents**: [RDG-1593.md](../RDG-1593.md), [RI-871.md](../RI-871.md)

---

## Context

Implementation of historic AP data loading into S/4HANA. Depends on GL being loaded and reconciled. Includes open items (to represent current financial position) and cleared items (for history).

---

## Tasks

### TASK-036: Data Mapping AP — Source to Target

| Field | Value |
|-------|-------|
| **Type** | Design |
| **Priority** | P0 |
| **Owner** | Data Analyst + FI Consultant |
| **Acceptance criteria** | Complete AP mapping including subtypes (invoice, credit memo, down payment, WHT) |

**Actions**:
- [ ] Map source → target fields (per blueprint section 4.2.3)
- [ ] Map Vendor → Business Partner (conversion table)
- [ ] Define Withholding Tax treatment (fields WITHT, WT_WITHCD, QBSHB)
- [ ] Define Special GL indicator treatment (UMSKZ)
- [ ] Define Payment Terms treatment (ZTERM)
- [ ] Validate with Finance SME

---

### TASK-037: Extraction AP — Source System

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | Data Analyst |
| **Acceptance criteria** | AP open + cleared items extracted; separated by status |

**Actions**:
- [ ] Extract BSIK (AP open items) from source with all required fields
- [ ] Extract BSAK (AP cleared items) from source
- [ ] Include WHT data (table WITH_ITEM / BSEG WHT fields)
- [ ] Include payment data (clearing document reference, payment method)
- [ ] Generate standardized output separated: AP_OPEN.csv, AP_CLEARED.csv
- [ ] Validate volumes

---

### TASK-038: Staging Transformation AP

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | Data Analyst + ABAP Developer |
| **Acceptance criteria** | AP payload ready; validations V1-V8 pass; BP mapping resolved |

**Actions**:
- [ ] Implement Vendor → BP mapping (lookup BUT000 by vendor number)
- [ ] Implement currency conversion
- [ ] Implement Profit Center / Segment derivation
- [ ] Implement tax code mapping
- [ ] Implement pre-posting validations (section 4.2.4)
- [ ] Separate batches: open items vs cleared items
- [ ] For cleared items: implement aggregation logic per period/vendor
- [ ] Load staging table

---

### TASK-039: AP Open Items Loading

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P0 |
| **Owner** | ABAP Developer |
| **Acceptance criteria** | AP open items posted; visible in FBL1N; reconciliation account updated |

**Actions**:
- [ ] Open fiscal period (account type K) via OB52
- [ ] Execute dry-run (BAPI_ACC_DOCUMENT_CHECK)
- [ ] Post via BAPI_ACC_DOCUMENT_POST (structure ACCOUNTPAYABLE)
- [ ] Commit every 1000 docs
- [ ] Validate BSIK populated (open items visible)
- [ ] Validate FBL1N: vendor balances correct
- [ ] Validate reconciliation account (AKONT) updated in GL
- [ ] Post-chunk reconciliation

---

### TASK-040: AP Cleared Items Loading (Summarized)

| Field | Value |
|-------|-------|
| **Type** | Development |
| **Priority** | P1 (depends on ADR-003 / TASK-003) |
| **Owner** | ABAP Developer |
| **Acceptance criteria** | Cleared history loaded as journal entries; audit trail preserved in XBLNR/SGTXT |

**Actions**:
- [ ] Implement cleared items aggregation by period/vendor group
- [ ] Create summarized GL journal entries (structure ACCOUNTGL, not ACCOUNTPAYABLE)
- [ ] Preserve reference to original in XBLNR/SGTXT
- [ ] Post via BAPI_ACC_DOCUMENT_POST
- [ ] Validate NOT visible as individual vendor line item (expected behavior)
- [ ] Validate correct GL balance

---

### TASK-041: AP Cross-Module Reconciliation

| Field | Value |
|-------|-------|
| **Type** | Validation |
| **Priority** | P0 |
| **Owner** | Data Analyst + FI Consultant |
| **Acceptance criteria** | AP subledger balance = GL reconciliation account; report approved |

**Actions**:
- [ ] Execute rule R2 (AP subledger ↔ GL recon account)
- [ ] Compare: Σ vendor balances (FBL1N) = reconciliation account balance (FAGLB03)
- [ ] Investigate discrepancies
- [ ] Produce reconciliation report
- [ ] Obtain sign-off

---

### TASK-042: Update RDG-1593 with technical detail

| Field | Value |
|-------|-------|
| **Type** | Documentation |
| **Priority** | P1 |
| **Owner** | Solution Architect |
| **Acceptance criteria** | RDG-1593 complete with technical approach, field mapping, constraints |

**Actions**:
- [ ] Add Technical Approach (BAPI + structure ACCOUNTPAYABLE)
- [ ] Add complete Field Mapping
- [ ] Add Constraints (cleared items as summarized, WHT limitations, etc.)
- [ ] Add Supported Doc Types (KR, RE, KG, KZ with UMSKZ)
- [ ] Add Business Partner mapping requirement
