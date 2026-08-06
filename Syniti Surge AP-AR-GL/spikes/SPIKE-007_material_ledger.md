# SPIKE-007: Material Ledger & Specific Valuation

## Spike Summary

| Field | Value |
|-------|-------|
| **Type** | Spike (Technical Investigation) |
| **Priority** | Medium |
| **Timebox** | 2 days |
| **Assignee** | FI Consultant Team |
| **Labels** | `spike`, `fi-specification`, `material-ledger`, `valuation` |

## Dependencies

| Dependency | Link | Relationship |
|-----------|------|--------------|
| GL Historic Transaction Loading | [RDG-1592](../RDG-1592.md) | Blocks — ML docs are FI documents in ACDOCA |
| AP Historic Transaction Loading | [RDG-1593](../RDG-1593.md) | Informs — AP invoices linked to ML price differences |
| AR Historic Transaction Loading | [RDG-1594](../RDG-1594.md) | Informs — cost of goods sold postings linked to ML |
| Validation & Reconciliation Framework | [RDG-1590](../RDG-1590.md) | Blocks — ML docs affect reconciliation totals |
| Implementation Guide & Delivery Enablement | [RDG-1591](../RDG-1591.md) | Blocks — ML exclusion/inclusion must be documented |

## Objective

Determine whether Material Ledger-generated FI documents and transfer pricing documents are in scope, and if so, how to handle them without running actual costing.

## Expected Output

- ML document scope decision (include/exclude/separate migration)
- ACDOCA-MLCATEG handling for historic docs
- Transfer pricing / non-leading ledger strategy

---

## Questions

### Q-031: Material Ledger historic data migration

| Field | Value |
|-------|-------|
| **Category** | Scope Definition |
| **Module** | CO-PC (Material Ledger) |
| **SAP Reference** | ACDOCA-MLCATEG, CKMLHD, CKMLCT, MLCD, table MLIT |
| **Impact if unanswered** | ML-related FI docs loaded incorrectly; actual costing wrong |

**Detail**:
- In S/4HANA, Material Ledger is MANDATORY (activated by default).
- ML creates FI documents for:
  - Price differences (PRDI)
  - Single/Multi-Level price determination (CKMLCP)
  - Actual cost component split
- Questions:
  - Are ML-generated FI documents in scope of this feature?
  - If yes: how to handle without running actual costing (CKMLCP)?
  - ML documents reference material + plant (MATNR, BWKEY) — must material masters exist?
  - What about the ML closing entries (revaluation of consumption)?
  - Is there a separate ML migration strategy that handles this?
  - In ACDOCA: MLCATEG field — what value for historic docs?

---

### Q-032: Transfer pricing documents (Profit Center Valuation)

| Field | Value |
|-------|-------|
| **Category** | Scope Definition |
| **Module** | EC-PCA, FI-GL |
| **SAP Reference** | ACDOCA-RLDNR (non-leading ledger), ledger L1/2L |
| **Impact if unanswered** | Transfer pricing ledger empty or incorrect |

**Detail**:
- If target uses non-leading ledger for transfer pricing or profit center valuation:
  - Must we load data to that ledger?
  - What are the valuation differences (delta entries)?
  - How to derive them from source?

---

## Answer Template

| Question | Answer | Justification | Evidence | Answered By | Date |
|----------|--------|---------------|----------|-------------|------|
| Q-031 | | | | | |
| Q-032 | | | | | |
