# SPIKE-006: Specific Scenarios & Edge Cases

## Spike Summary

| Field | Value |
|-------|-------|
| **Type** | Spike (Technical Investigation) |
| **Priority** | High |
| **Timebox** | 5 days |
| **Assignee** | FI Consultant Team |
| **Labels** | `spike`, `fi-specification`, `edge-cases`, `complexity` |

## Dependencies

| Dependency | Link | Relationship |
|-----------|------|--------------|
| GL Historic Transaction Loading | [RDG-1592](../RDG-1592.md) | Blocks — intercompany, FC reval, cross-company affect GL |
| AP Historic Transaction Loading | [RDG-1593](../RDG-1593.md) | Blocks — GR/IR, special GL, payments affect AP |
| AR Historic Transaction Loading | [RDG-1594](../RDG-1594.md) | Blocks — special GL, payments affect AR |
| Validation & Reconciliation Framework | [RDG-1590](../RDG-1590.md) | Blocks — edge cases create reconciliation exceptions |
| Implementation Guide & Delivery Enablement | [RDG-1591](../RDG-1591.md) | Blocks — constraints/limitations must document these |

## Objective

Define handling for complex scenarios that require special treatment: intercompany, foreign currency revaluation, GR/IR, profit center derivation, cross-company, special GL transactions, and automatic payment program documents.

## Expected Output

- Intercompany handling strategy (both sides vs. one side)
- FC revaluation inclusion/exclusion decision
- GR/IR account strategy (FI load vs. separate MM migration)
- Profit Center / Segment derivation rules for legacy data
- Cross-company posting strategy
- Special GL indicators in scope
- F110 payment document handling approach

---

## Questions

### Q-024: Intercompany transactions

| Field | Value |
|-------|-------|
| **Category** | Technical Complexity |
| **Module** | FI (all) |
| **SAP Reference** | BSEG-VBUND, BSEG-BVTYP, T042I |
| **Impact if unanswered** | Intercompany eliminates will be wrong in consolidation |

**Detail**:
- Intercompany postings generate TWO documents (one per company code). Load both?
- If we load only one side: consolidation elimination will fail.
- Trading Partner field (VBUND) — must be populated?
- What about cross-company code transactions that are in the SAME document (multi-company-code documents via BKPF-BSTAT = 'V')?

---

### Q-025: Foreign currency revaluation documents

| Field | Value |
|-------|-------|
| **Category** | Technical Complexity |
| **Module** | FI-GL, FI-AP/AR |
| **SAP Reference** | FAGL_FC_VAL (T-code), doc type reversal |
| **Impact if unanswered** | Loading FC reval docs creates double revaluation |

**Detail**:
- Foreign currency revaluation documents (from F.05/FAGL_FC_VAL) — in scope?
- These are typically reversed at period start. If we load them: do we also load the reversal?
- Risk: if loaded into open period, next revaluation run will create ANOTHER reval → double effect.
- Recommendation needed: EXCLUDE these or INCLUDE with specific handling?

---

### Q-026: GR/IR clearing account handling

| Field | Value |
|-------|-------|
| **Category** | Technical Complexity |
| **Module** | FI-MM integration |
| **SAP Reference** | Account type WRX, F.19 (GR/IR maintenance), MR11 |
| **Impact if unanswered** | GR/IR balance wrong; MR11 analysis incorrect |

**Detail**:
- GR/IR (Goods Receipt/Invoice Receipt) account documents — in scope?
- These documents are typically created by MM (MIGO/MIRO), not directly by FI.
- If loaded: how to maintain the MM-FI link (BSEG-EBELN, EBELP)?
- Impact on F.19 (GR/IR analysis)?
- Or: GR/IR balance is handled by separate migration strategy?

---

### Q-027: Profit Center / Segment derivation for old documents

| Field | Value |
|-------|-------|
| **Category** | Technical Complexity |
| **Module** | FI-GL, EC-PCA |
| **SAP Reference** | CEPC (Profit Center master), 0FI_GL_14 (Segment derivation BRF+) |
| **Impact if unanswered** | Document Splitting fails; segment reporting incomplete |

**Detail**:
- Many legacy systems don't have Profit Center on every line item.
- S/4HANA requires Profit Center for Document Splitting (if active).
- Options:
  - Derive from account master (SKB1-PRCTR)?
  - Derive from cost center → profit center assignment?
  - Use a "migration default" profit center?
  - Leave blank and accept splitting won't apply?
- Segment is derived from Profit Center (table CEPC-SEGMENT). If PC is wrong, segment is wrong.
- What about **Functional Area** (FKBER)? Mandatory? Derivation rules?

---

### Q-028: Documents with multiple company codes (cross-company)

| Field | Value |
|-------|-------|
| **Category** | Technical Complexity |
| **Module** | FI (all) |
| **SAP Reference** | BKPF-BSTAT = 'V', BAPI_ACC_DOCUMENT_POST multi-company |
| **Impact if unanswered** | Cross-company postings generate 2+ docs; loading only one is incomplete |

**Detail**:
- In SAP, cross-company-code posting creates one LOGICAL document but multiple PHYSICAL documents (one per BUKRS).
- `BAPI_ACC_DOCUMENT_POST` can handle multi-company-code in one call.
- Question: do we load the entire cross-company transaction or each company-code doc independently?
- If independently: the intercompany clearing entries won't balance.
- If together: we need to identify cross-company groups in source data.

---

### Q-029: Noted items and special GL transactions

| Field | Value |
|-------|-------|
| **Category** | Technical Complexity |
| **Module** | FI-AP/AR |
| **SAP Reference** | BSEG-UMSKZ, T074, BSEG-SHKZG in special GL context |
| **Impact if unanswered** | Special GL items post to wrong accounts or reject |

**Detail**: Special GL transactions use alternative reconciliation accounts (T074):
- Down payments received/given (UMSKZ = 'A')
- Bills of exchange (UMSKZ = 'W')
- Guarantees (UMSKZ = 'G')
- Securities (various)
- Other customer/vendor-specific special GL

Questions:
- Which Special GL indicators are in scope?
- Must the alternative reconciliation account config (T074) match source?
- Noted items (BSEG-XNEGP or BSTAT = 'S') — are they real postings? How to handle?

---

### Q-030: Automatic payment program documents (F110)

| Field | Value |
|-------|-------|
| **Category** | Scope Decision |
| **Module** | FI-AP/AR |
| **SAP Reference** | REGUH, REGUP, PAYR, doc type ZP/KZ |
| **Impact if unanswered** | Loading payment docs without clearing is meaningless |

**Detail**:
- Payment run documents (from F110) contain:
  - Payment document (KZ/DZ)
  - Check/bank transfer details (PAYR, REGUH)
  - Clearing information linking invoice ↔ payment
- If we load the payment doc: we need to also clear the invoice.
- If we DON'T load payment docs: open items remain "open" in target even though they were paid in source.
- Proposed options:
  - A) Load invoice as cleared (status = cleared, AUGBL reference)
  - B) Load invoice + payment + perform clearing
  - C) Only load open items at cutover date; treat everything else as GL summary
- Which approach?

---

## Answer Template

| Question | Answer | Justification | Evidence | Answered By | Date |
|----------|--------|---------------|----------|-------------|------|
| Q-024 | | | | | |
| Q-025 | | | | | |
| Q-026 | | | | | |
| Q-027 | | | | | |
| Q-028 | | | | | |
| Q-029 | | | | | |
| Q-030 | | | | | |
