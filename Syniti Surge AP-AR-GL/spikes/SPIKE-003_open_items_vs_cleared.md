# SPIKE-003: Open Items vs. Cleared Items

## Spike Summary

| Field | Value |
|-------|-------|
| **Type** | Spike (Technical Investigation) |
| **Priority** | P0 — Blocking |
| **Timebox** | 3 days |
| **Assignee** | FI Consultant Team |
| **Labels** | `spike`, `fi-specification`, `clearing`, `blocking` |

## Dependencies

| Dependency | Link | Relationship |
|-----------|------|--------------|
| AP Historic Transaction Loading | [RDG-1593](../RDG-1593.md) | Blocks — AP open/cleared handling is core logic |
| AR Historic Transaction Loading | [RDG-1594](../RDG-1594.md) | Blocks — AR open/cleared handling is core logic |
| Validation & Reconciliation Framework | [RDG-1590](../RDG-1590.md) | Blocks — reconciliation must account for clearing status |
| Implementation Guide & Delivery Enablement | [RDG-1591](../RDG-1591.md) | Blocks — guides must document clearing approach |
| GL Historic Transaction Loading | [RDG-1592](../RDG-1592.md) | Informs — GL recon accounts affected by AP/AR clearing |

## Objective

Define the treatment of open vs. cleared items for AP/AR: what constitutes an open item at cutover, how to recreate clearing relationships for closed items, and how to handle special cases (down payments, withholding tax).

## Expected Output

- Definition of "open item" at cutover (date reference, partial clearing, etc.)
- Clearing recreation strategy (load+clear, LTMC, or summarize)
- Down payment handling rules (requests, payments, clearing)
- Withholding tax handling approach per country

---

## Questions

### Q-012: What defines an "open item" for AP/AR at cutover?

| Field | Value |
|-------|-------|
| **Category** | Scope Definition |
| **Module** | FI-AP, FI-AR |
| **SAP Reference** | BSIK (AP open), BSID (AR open), BSEG-AUGBL (clearing doc) |
| **Impact if unanswered** | Cannot determine extraction logic |

**Detail**:
- Open item = item without clearing document (AUGBL = blank) at what point in time?
  - At source extraction date?
  - At cutover date?
  - At go-live date?
- What about items that are "partially cleared" (residual items)?
- What about items with payment on account (UMSKZ)?
- Does "open" include items in payment block (ZLSPR)?

---

### Q-013: How to recreate clearing relationships for cleared items?

| Field | Value |
|-------|-------|
| **Category** | Technical Complexity |
| **Module** | FI-AP, FI-AR |
| **SAP Reference** | BSEG-AUGBL, BSEG-AUGDT, BSEG-AUGCP, F-44/F-32 (Clearing) |
| **Impact if unanswered** | Cleared items display incorrectly; aging reports wrong |

**Detail**: If cleared items are in scope:
- Do we need to recreate the clearing relationship (AUGBL, AUGDT)?
- If yes: the clearing document number in target will be DIFFERENT from source (since it's a new doc) — is that acceptable?
- Can `BAPI_ACC_DOCUMENT_POST` create already-cleared line items? (Answer: NO — it posts as open, then clearing must be done separately)
- Alternative: post invoice + payment as two separate docs, then clear them (F-44 equivalent) — is this acceptable complexity?
- Alternative: use LTMC Migration Object "Open Item — Supplier" which handles this?
- What about partial payments / residual items during clearing?

---

### Q-014: Treatment of down payments (Anzahlungen)

| Field | Value |
|-------|-------|
| **Category** | Technical Complexity |
| **Module** | FI-AP (F-48), FI-AR (F-37) |
| **SAP Reference** | BSEG-UMSKZ (Special GL indicator), T074 |
| **Impact if unanswered** | Down payments have special posting logic; wrong handling = balance errors |

**Detail**:
- Down payment REQUESTS (noted items, statistisch) — in scope? They don't create real FI docs.
- Down payment PAYMENTS (F-48/F-37) — in scope? They use Special GL accounts (table T074).
- Down payment CLEARING (F-54/F-39) — in scope?
- If we load a down payment: which Special GL indicator (UMSKZ) to use? Must it match source?
- Down payments post to alternative reconciliation accounts (T074T) — must that config exist in target?
- Impact on advance tax reporting (if down payment triggers VAT)?

---

### Q-015: Treatment of Withholding Tax (WHT)

| Field | Value |
|-------|-------|
| **Category** | Technical Complexity |
| **Module** | FI-AP primarily |
| **SAP Reference** | WITH_ITEM table, BSEG-QBSHB/QSFBT, T059Z |
| **Impact if unanswered** | WHT-relevant docs rejected or posted incorrectly |

**Detail**:
- Does `BAPI_ACC_DOCUMENT_POST` support WHT fields?
- If source has extended WHT (WITH_ITEM), how do we populate it via BAPI?
- Must WHT be recalculated during loading, or do we pass source amounts directly?
- What about accumulated WHT certificates (annual vendor statements)?
- WHT reporting relevance: if we load historic docs with WHT, will they appear in periodic WHT reports? Is that desired or problematic (double reporting)?
- Country-specific WHT rules (Brazil: DARF/DIRF, India: TDS/TCS, etc.) — which countries in scope?

---

## Answer Template

| Question | Answer | Justification | Evidence | Answered By | Date |
|----------|--------|---------------|----------|-------------|------|
| Q-012 | | | | | |
| Q-013 | | | | | |
| Q-014 | | | | | |
| Q-015 | | | | | |
