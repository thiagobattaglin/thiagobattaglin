# SPIKE-012: Risk & Edge Cases

## Spike Summary

| Field | Value |
|-------|-------|
| **Type** | Spike (Technical Investigation) |
| **Priority** | High |
| **Timebox** | 3 days |
| **Assignee** | FI Consultant Team |
| **Labels** | `spike`, `fi-specification`, `risk`, `edge-cases` |

## Dependencies

| Dependency | Link | Relationship |
|-----------|------|--------------|
| GL Historic Transaction Loading | [RDG-1592](../RDG-1592.md) | Blocks — risks directly impact GL loading constraints |
| AP Historic Transaction Loading | [RDG-1593](../RDG-1593.md) | Blocks — risks directly impact AP loading constraints |
| AR Historic Transaction Loading | [RDG-1594](../RDG-1594.md) | Blocks — risks directly impact AR loading constraints |
| Validation & Reconciliation Framework | [RDG-1590](../RDG-1590.md) | Informs — risks create reconciliation exceptions |
| Implementation Guide & Delivery Enablement | [RDG-1591](../RDG-1591.md) | Blocks — limitations section of guides |

## Objective

Identify and define handling for documents that cannot be loaded as-is: no S/4 equivalent, reversals, tolerance/credit limits exceeded during loading, and archiving impact on freshly loaded historic data.

## Expected Output

- Fallback strategy for unloadable documents (reject/adapt/transform)
- Reversal document handling decision (load both, load neither, load net)
- Tolerance/credit limit bypass strategy during loading
- Archiving protection rules for loaded historic data

---

## Questions

### Q-045: What if a document in source has no equivalent posting logic in S/4?

| Field | Value |
|-------|-------|
| **Category** | Risk |
| **Module** | FI (all) |
| **Impact if unanswered** | Unknown number of documents cannot be loaded |

**Detail**: Examples of potentially unloadable docs:
- Documents posted via obsolete transactions (FB70/FB75 replaced by new experience)
- Documents with deprecated account types
- Documents using posting keys eliminated in S/4 (e.g., modified posting keys)
- Documents referencing objects that don't exist in S/4 (e.g., classic GL account in SAP R/3)
- ECC New GL vs. Classic GL differences (T8G39)
- What is the fallback strategy? Reject? Adapt? Transform?

---

### Q-046: Reversal documents — how to handle?

| Field | Value |
|-------|-------|
| **Category** | Technical Complexity |
| **Module** | FI (all) |
| **SAP Reference** | BKPF-STBLG (Reversal Doc), FB08, BAPI_ACC_DOCUMENT_REV_POST |
| **Impact if unanswered** | Double postings or missing reversals |

**Detail**:
- If source has Document A + its Reversal B:
  - Option 1: Load BOTH A and B → net zero, preserves audit trail
  - Option 2: Load NEITHER (they cancel out) → reduces volume
  - Option 3: Load only the net effect
- What about partial reversals?
- What about documents reversed in a different fiscal year?
- Reversal reason code (BKPF-STGRD) — must be provided?

---

### Q-047: Tolerance limits and credit limits during loading

| Field | Value |
|-------|-------|
| **Category** | Side Effects |
| **Module** | FI-AP/AR |
| **SAP Reference** | OBA4 (tolerances), OBJ1 (AR credit), FD32 (credit limit) |
| **Impact if unanswered** | Postings rejected due to tolerance/credit checks |

**Detail**:
- Posting tolerance limits (OBA4): do they apply during BAPI posting? Can they reject historic docs?
- Payment difference tolerances: relevant for loading?
- Credit limit (FD32): does posting an AR invoice increase credit exposure?
  - If yes: loading 5 years of AR invoices instantly exceeds all credit limits
  - How to bypass?
- Payment terms validation: if ZTERM from source doesn't exist in target → rejection?

---

### Q-048: Archiving impact

| Field | Value |
|-------|-------|
| **Category** | Operational |
| **Module** | BC-ARC |
| **SAP Reference** | AOBJ (archiving objects), FI_DOCUMNT, residence time |
| **Impact if unanswered** | Loaded data immediately eligible for archiving |

**Detail**:
- If we load documents from 2015-2020 into target in 2026:
  - The residence time for archiving might already be exceeded
  - Risk: next archiving run archives the just-loaded data
- How to set residence time for loaded documents?
- Should loaded docs have a different archiving attribute?
- Or: configure archiving object FI_DOCUMNT to exclude migration range?

---

## Answer Template

| Question | Answer | Justification | Evidence | Answered By | Date |
|----------|--------|---------------|----------|-------------|------|
| Q-045 | | | | | |
| Q-046 | | | | | |
| Q-047 | | | | | |
| Q-048 | | | | | |
