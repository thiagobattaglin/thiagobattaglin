# EPIC-002: Technical Discovery & POC

> **Priority**: P0  
> **Owner**: SAP Migration Specialist + Solution Architect  
> **Deadline**: Before starting Phase 1  
> **Related documents**: [RI-871.md](../RI-871.md), [RDG-1592.md](../RDG-1592.md), [RDG-1593.md](../RDG-1593.md), [RDG-1594.md](../RDG-1594.md)

---

## Context

Before starting development, it is necessary to confirm technical feasibility in the client's actual environment, identify Migration Object limitations, and produce performance benchmarks.

---

## Tasks

### TASK-011: Confirm S/4HANA target version and release

| Field | Value |
|-------|-------|
| **Type** | Research |
| **Priority** | P0 |
| **Owner** | IT / Basis |
| **Acceptance criteria** | Release number documented; deployment model confirmed (on-prem/Private Cloud) |

**Actions**:
- [ ] Verify SAP_BASIS component version in target
- [ ] Confirm deployment model (on-premise vs Private Cloud vs Public Cloud)
- [ ] Document any applied Service Packs / Feature Packs

---

### TASK-012: Inventory of available Migration Objects in LTMC

| Field | Value |
|-------|-------|
| **Type** | Research |
| **Priority** | P0 |
| **Owner** | SAP Migration Specialist |
| **Acceptance criteria** | List of financial MOs with technical name, available fields, and limitations |

**Actions**:
- [ ] Access LTMC in target (transaction LTMC)
- [ ] List Migration Objects for FI: search for "Supplier Open Item", "Customer Open Item", "GL Balance", "FI Document"
- [ ] For each MO: document mandatory, optional, and unsupported fields
- [ ] Verify if MO supports posting in retroactive period
- [ ] Identify limitations (doc types, special GL, etc.)

---

### TASK-013: Verify C1-contract of candidate APIs

| Field | Value |
|-------|-------|
| **Type** | Research |
| **Priority** | P0 |
| **Owner** | ABAP Developer |
| **Acceptance criteria** | Released status confirmed for each API in target release |

**Actions**:
- [ ] Verify via ADT / Fiori "Custom Code Migration":
  - `BAPI_ACC_DOCUMENT_POST` → Released?
  - `BAPI_ACC_DOCUMENT_CHECK` → Released?
  - `BAPI_ACC_DOCUMENT_REV_POST` → Released?
  - CDS Views: `I_JournalEntry`, `I_GLAccountLineItem`, `I_SupplierLineItem`, `I_CustomerLineItem` → Released?
- [ ] If any API is not released: identify alternative or SAP Note exception

---

### TASK-014: Inventory of active BAdIs in target (FI Posting)

| Field | Value |
|-------|-------|
| **Type** | Research |
| **Priority** | P0 |
| **Owner** | ABAP Team |
| **Acceptance criteria** | Complete list of BAdIs impacting FI posting, with impact assessment |

**Actions**:
- [ ] List active BAdIs for:
  - `BADI_ACC_DOCUMENT` (document validation)
  - `FI_DOC_MODIFY` (document modification)
  - `AC_DOCUMENT` (accounting document)
  - Substitutions (GGB1) and Validations (GGB0) in FI
- [ ] For each BAdI: assess if it would reject historical documents
- [ ] Define strategy: temporary bypass vs data enrichment

---

### TASK-015: Confirm Document Splitting configuration in target

| Field | Value |
|-------|-------|
| **Type** | Research |
| **Priority** | P0 |
| **Owner** | FI Consultant |
| **Acceptance criteria** | Splitting rules documented; impact assessment produced |

**Actions**:
- [ ] Verify FAGL_SPLINFO: splitting active? For which company codes?
- [ ] Identify splitting characteristics: Profit Center? Segment? Business Area?
- [ ] Verify zero-balance setting per characteristic
- [ ] Assess: do source documents have splitting fields populated?
- [ ] Define default values if fields are missing

---

### TASK-016: Confirm configured Parallel Currencies

| Field | Value |
|-------|-------|
| **Type** | Research |
| **Priority** | P1 |
| **Owner** | FI Consultant |
| **Acceptance criteria** | Currency types listed; historical exchange rates available |

**Actions**:
- [ ] Verify T001 (company code): local currency 1, local currency 2
- [ ] Verify FINSC_LEDGER: currency types per ledger
- [ ] Confirm historical exchange rates in TCURR for periods in scope
- [ ] If rates are missing: plan rate loading as prerequisite

---

### TASK-017: Gather source volumetrics

| Field | Value |
|-------|-------|
| **Type** | Research |
| **Priority** | P0 |
| **Owner** | Data Analyst + Client FI |
| **Acceptance criteria** | Volume per type/company/year documented; size estimate in GB |

**Actions**:
- [ ] Execute queries on source:
  ```sql
  -- GL documents
  SELECT BUKRS, GJAHR, BLART, COUNT(*) FROM BKPF GROUP BY BUKRS, GJAHR, BLART
  -- AP open items
  SELECT BUKRS, GJAHR, COUNT(*) FROM BSIK GROUP BY BUKRS, GJAHR
  -- AP cleared items
  SELECT BUKRS, GJAHR, COUNT(*) FROM BSAK GROUP BY BUKRS, GJAHR
  -- AR open items
  SELECT BUKRS, GJAHR, COUNT(*) FROM BSID GROUP BY BUKRS, GJAHR
  -- AR cleared items
  SELECT BUKRS, GJAHR, COUNT(*) FROM BSAD GROUP BY BUKRS, GJAHR
  ```
- [ ] Calculate total line item volume (BSEG or equivalent)
- [ ] Estimate ACDOCA size (avg ~2KB per line item)
- [ ] Document results

---

### TASK-018: POC — Post 100 GL documents

| Field | Value |
|-------|-------|
| **Type** | POC / Spike |
| **Priority** | P0 |
| **Owner** | ABAP Developer + SAP Migration Specialist |
| **Acceptance criteria** | 100 GL docs posted successfully; ACDOCA populated correctly; throughput benchmark |

**Actions**:
- [ ] Prepare sample of 100 GL journal entries from source
- [ ] Transform to BAPI_ACC_DOCUMENT_POST format
- [ ] Execute BAPI_ACC_DOCUMENT_CHECK (dry-run) for all
- [ ] Post via BAPI_ACC_DOCUMENT_POST
- [ ] Validate in ACDOCA: mandatory fields populated?
- [ ] Validate in FAGLB03: balances correct?
- [ ] Validate Document Splitting: segments assigned?
- [ ] Measure execution time (baseline benchmark)
- [ ] Document findings

---

### TASK-019: POC — Post AP and AR open items

| Field | Value |
|-------|-------|
| **Type** | POC / Spike |
| **Priority** | P0 |
| **Owner** | ABAP Developer |
| **Acceptance criteria** | AP/AR open items posted; visible in FBL1N/FBL5N; reconciliation account updated |

**Actions**:
- [ ] Prepare 50 AP open items (invoices + credit memos) from source
- [ ] Prepare 50 AR open items from source
- [ ] Post via BAPI (structure ACCOUNTPAYABLE / ACCOUNTRECEIVABLE)
- [ ] Validate BSIK/BSID populated
- [ ] Validate reconciliation account in GL (FAGLB03)
- [ ] Test document with Special GL indicator (down payment)
- [ ] Test document with Withholding Tax
- [ ] Document limitations found

---

### TASK-020: Confirm ALE/Change Pointers integration

| Field | Value |
|-------|-------|
| **Type** | Research |
| **Priority** | P1 |
| **Owner** | Integration Team |
| **Acceptance criteria** | List of relevant FI change pointers; deactivation strategy if needed |

**Actions**:
- [ ] Verify BD50: active change pointers for FI message types (FIDCCP, ACC_DOCUMENT, etc.)
- [ ] Assess whether loading postings trigger unwanted IDocs
- [ ] If yes: temporary deactivation strategy with post-load reactivation
