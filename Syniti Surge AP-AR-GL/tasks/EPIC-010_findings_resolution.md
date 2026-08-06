# EPIC-010: Findings Resolution (Review Findings)

> **Priority**: P0/P1 per severity  
> **Owner**: Various (see per task)  
> **Prerequisites**: None — can start immediately  
> **Related documents**: [RI-871.md](../RI-871.md), [RDG-1590.md](../RDG-1590.md), [RDG-1591.md](../RDG-1591.md), [RDG-1592.md](../RDG-1592.md), [RDG-1593.md](../RDG-1593.md), [RDG-1594.md](../RDG-1594.md)

---

## Context

Tasks derived directly from findings of the product and architecture reviews. Resolve documentation gaps that prevent development from starting.

---

## Tasks — CRITICAL Findings Resolution

### TASK-066: [F-001/ARCH] Document ACDOCA as target in RDGs

| Field | Value |
|-------|-------|
| **Finding severity** | CRITICAL |
| **Owner** | Solution Architect |
| **Impacted file** | [RDG-1592.md](../RDG-1592.md), [RDG-1593.md](../RDG-1593.md), [RDG-1594.md](../RDG-1594.md) |

**Action**: Add "Target Data Model" section in each technical RDG specifying ACDOCA as primary target with mandatory fields.

---

### TASK-067: [F-002/ARCH] Document Document Splitting in RDGs

| Field | Value |
|-------|-------|
| **Finding severity** | CRITICAL |
| **Owner** | Solution Architect + FI Consultant |
| **Impacted file** | [RDG-1592.md](../RDG-1592.md), [RDG-1593.md](../RDG-1593.md), [RDG-1594.md](../RDG-1594.md) |

**Action**: Add "Document Splitting Considerations" section stating: (a) whether target has splitting active; (b) enrichment strategy; (c) default values.

---

## Tasks — HIGH Findings Resolution

### TASK-068: [F-003/ARCH] Name Migration Objects by type

| Field | Value |
|-------|-------|
| **Finding severity** | HIGH |
| **Owner** | SAP Migration Specialist |
| **Impacted file** | [RDG-1592.md](../RDG-1592.md), [RDG-1593.md](../RDG-1593.md), [RDG-1594.md](../RDG-1594.md) |

**Action**: After TASK-012 (LTMC inventory), update each RDG with technical name of Migration Object used.

---

### TASK-069: [F-004/ARCH] Document GL document vs balance decision

| Field | Value |
|-------|-------|
| **Finding severity** | HIGH |
| **Owner** | Product Owner |
| **Impacted file** | [RDG-1592.md](../RDG-1592.md) |

**Action**: After TASK-002 (ADR), update RDG-1592 with decision taken and trade-offs.

---

### TASK-070: [F-005/ARCH] Document open vs cleared treatment

| Field | Value |
|-------|-------|
| **Finding severity** | HIGH |
| **Owner** | Product Owner |
| **Impacted file** | [RDG-1593.md](../RDG-1593.md), [RDG-1594.md](../RDG-1594.md) |

**Action**: After TASK-003 (ADR), update RDGs with scope (open only vs open+cleared) and strategy.

---

### TASK-071: [F-006/ARCH] Document Business Partner requirement

| Field | Value |
|-------|-------|
| **Finding severity** | HIGH |
| **Owner** | Solution Architect |
| **Impacted file** | [RDG-1593.md](../RDG-1593.md), [RDG-1594.md](../RDG-1594.md) |

**Action**: Add prerequisite: "Business Partner migration must be complete before AP/AR loading" with description of Vendor→BP / Customer→BP mapping.

---

### TASK-072: [F-007/ARCH] Define volumetrics and performance strategy

| Field | Value |
|-------|-------|
| **Finding severity** | HIGH |
| **Owner** | Solution Architect + FI Consultant |
| **Impacted file** | [RI-871.md](../RI-871.md) |

**Action**: Add "Volumetrics & Performance" section in feature doc with: expected volumes, partitioning strategy, parallelism.

---

### TASK-073: [F-008/ARCH] Document fiscal period management

| Field | Value |
|-------|-------|
| **Finding severity** | HIGH |
| **Owner** | Solution Architect |
| **Impacted file** | [RDG-1592.md](../RDG-1592.md), [RDG-1593.md](../RDG-1593.md), [RDG-1594.md](../RDG-1594.md) |

**Action**: Add "Period Management" section in each RDG with open/close strategy.

---

### TASK-074: [F-009/ARCH] Document rollback strategy

| Field | Value |
|-------|-------|
| **Finding severity** | HIGH |
| **Owner** | Solution Architect |
| **Impacted file** | New doc or section in [RI-871.md](../RI-871.md) |

**Action**: Document reversal strategy via BAPI_ACC_DOCUMENT_REV_POST with granularity and identification.

---

### TASK-075: [F-013/ARCH] Declare ABAP Cloud / Tier 1

| Field | Value |
|-------|-------|
| **Finding severity** | HIGH |
| **Owner** | Solution Architect |
| **Impacted file** | [RI-871.md](../RI-871.md) |

**Action**: Add explicit statement: "All custom development uses ABAP Cloud (Tier 1). Verification via ATC scan with variant ABAP_CLOUD_READINESS."

---

## Tasks — MEDIUM Findings Resolution

### TASK-076: [F-006/PROD] Reformulate DoD with verifiable criteria

| Field | Value |
|-------|-------|
| **Finding severity** | MEDIUM |
| **Owner** | Product Owner |
| **Impacted file** | [RI-871.md](../RI-871.md) |

**Action**: Reformulate each DoD criterion with objective metric (see TASK-065 for details).

---

### TASK-077: [F-007/PROD] Add demos for uncovered DoD items

| Field | Value |
|-------|-------|
| **Finding severity** | MEDIUM |
| **Owner** | Product Owner |
| **Impacted file** | [RI-871.md](../RI-871.md) |

**Action**: Add demo items for: (a) Clean Core scan result; (b) scope/limitations walkthrough; (c) implementation guide; (d) error/rejection scenario; (e) detected discrepancy scenario.

---

### TASK-078: [F-008/PROD] Add error scenarios in Demo

| Field | Value |
|-------|-------|
| **Finding severity** | MEDIUM |
| **Owner** | Product Owner |
| **Impacted file** | [RI-871.md](../RI-871.md) |

**Action**: Demo must include: (a) rejected posting + handling; (b) discrepancy detected by framework; (c) recovery procedure.

---

### TASK-079: [F-009/PROD] Add status and owner to dependencies

| Field | Value |
|-------|-------|
| **Finding severity** | MEDIUM |
| **Owner** | Product Owner |
| **Impacted file** | [RI-871.md](../RI-871.md) |

**Action**: Create dependencies table with: reference, status (Draft/In-Review/Approved), owner, expected date.

---

### TASK-080: [F-010/PROD] Business Outcomes with measurable metrics

| Field | Value |
|-------|-------|
| **Finding severity** | MEDIUM |
| **Owner** | Product Owner |
| **Impacted file** | [RI-871.md](../RI-871.md) |

**Action**: Add measurable KPI to each Business Outcome (e.g., "100% of records auditable", "reconciliation ±0.01").
