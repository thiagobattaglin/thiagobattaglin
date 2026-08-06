# SPIKE-001: Scope & Document Types

## Spike Summary

| Field | Value |
|-------|-------|
| **Type** | Spike (Technical Investigation) |
| **Priority** | P0 — Blocking |
| **Timebox** | 3 days |
| **Assignee** | FI Consultant Team |
| **Labels** | `spike`, `fi-specification`, `scope`, `blocking` |

## Dependencies

| Dependency | Link | Relationship |
|-----------|------|--------------|
| GL Historic Transaction Loading | [RDG-1592](../RDG-1592.md) | Blocks — cannot define GL extraction without scope |
| AP Historic Transaction Loading | [RDG-1593](../RDG-1593.md) | Blocks — cannot define AP extraction without scope |
| AR Historic Transaction Loading | [RDG-1594](../RDG-1594.md) | Blocks — cannot define AR extraction without scope |
| Validation & Reconciliation Framework | [RDG-1590](../RDG-1590.md) | Blocks — reconciliation rules depend on scope definition |
| Implementation Guide & Delivery Enablement | [RDG-1591](../RDG-1591.md) | Blocks — guides cannot be written without defined scope |

## Objective

Define the exact scope of FI document types, transactions, and related objects that must be loaded for GL, AP, and AR. Without this, extraction logic, validation rules, and posting approach cannot be designed.

## Expected Output

- Definitive list of BLART (document types) per module (GL/AP/AR)
- List of explicitly excluded document types with justification
- Reporting scope boundary (T-codes where data must be visible after loading)
- Clarification on related objects (parked, held, recurring, accrual, etc.)
- Sub-ledger integration decision (ML, AA, CO, PS)

---

## Questions

### Q-001: Which FI document types (BLART) are in scope for GL?

| Field | Value |
|-------|-------|
| **Category** | Scope Definition |
| **Module** | FI-GL |
| **SAP Reference** | Table T003 (Document Types), BKPF-BLART |
| **Impact if unanswered** | Cannot define extraction filters or validation rules |

**Detail**: In SAP FI, there are 50+ standard document types. Which ones does the product need to support?
- SA (G/L Account Document)?
- SB (G/L Account Posting — with clearing)?
- AB (Accounting Document)?
- Accrual/deferral types (e.g., SA with reversal indicator)?
- Statistical postings?
- Recurring entries (T-code FBS1/F.56)?
- Sample documents?
- Noted items?

**Sub-questions**:
- Should we filter by document type or load ALL types found in BKPF?
- Are there document types that should be explicitly EXCLUDED (e.g., clearing docs, payment docs)?

---

### Q-002: Which FI document types (BLART) are in scope for AP?

| Field | Value |
|-------|-------|
| **Category** | Scope Definition |
| **Module** | FI-AP |
| **SAP Reference** | T003, BKPF-BLART, account type 'K' |
| **Impact if unanswered** | Cannot define AP extraction or posting logic |

**Detail**:
- KR (Vendor Invoice)?
- KG (Vendor Credit Memo)?
- KZ (Vendor Payment)? — If yes: how to handle without bank clearing?
- KA (Vendor Document — general)?
- RE (Invoice — Gross)?
- Down payments (doc types with Special GL indicator UMSKZ = 'A')?
- Vendor bills of exchange?
- Payment notices?

**Sub-questions**:
- Do we load the PAYMENT documents themselves (KZ) or only invoices/credits?
- If we load payments: how do we recreate the clearing relationship between invoice and payment?

---

### Q-003: Which FI document types (BLART) are in scope for AR?

| Field | Value |
|-------|-------|
| **Category** | Scope Definition |
| **Module** | FI-AR |
| **SAP Reference** | T003, BKPF-BLART, account type 'D' |
| **Impact if unanswered** | Cannot define AR extraction or posting logic |

**Detail**:
- DR (Customer Invoice)?
- DG (Customer Credit Memo)?
- DZ (Customer Payment)?
- DA (Customer Document — general)?
- Customer down payments (UMSKZ = 'A')?
- Debit memo (DM)?
- Dunning interest documents?

---

### Q-004: What is the exact T-Code / reporting scope boundary?

| Field | Value |
|-------|-------|
| **Category** | Scope Definition |
| **Module** | FI (all) |
| **SAP Reference** | Various T-Codes |
| **Impact if unanswered** | Cannot validate that loaded data is visible in expected reports |

**Detail**: After loading, in which T-codes/reports must the data be visible?

**GL scope**:
- FAGLL03H (G/L Account Line Items — New)?
- FAGLB03 (G/L Account Balances)?
- S_ALR_87012284 (Financial Statements)?
- FINSC_LEDGER / ACDOCA queries?

**AP scope**:
- FBL1N (Vendor Line Items)?
- FK10N (Vendor Balances)?
- ME2M (Purchase Orders — related docs)?
- MIRO/MIR5 (Invoice verification history)?

**AR scope**:
- FBL5N (Customer Line Items)?
- FD10N (Customer Balances)?
- F.27 (Customer balance confirmation)?
- Aging reports (FI-AR standard)?

**Cross-module**:
- FB03 (Display Document)?
- BSEG query via SE16N?
- CDS Views: `I_JournalEntry`, `I_GLAccountLineItem`?

---

### Q-005: Is the scope ONLY transactional data, or does it include related objects?

| Field | Value |
|-------|-------|
| **Category** | Scope Definition |
| **Module** | FI (all) |
| **Impact if unanswered** | Scope creep or missing critical dependencies |

**Detail**: RI-871 mentions "transactional data (AP/AR/GL)". Clarify:
- **Parked documents** (VBKPF) — in scope?
- **Held documents** — in scope?
- **Recurring entry documents** (T-code FBD1) — in scope?
- **Accrual/Deferral documents** (FBS1) — in scope?
- **Down payment requests** (F-47/F-37) — in scope? (they are noted items, not real postings)
- **Credit memos with residual items** — in scope?
- **Payment advice notes** — in scope?
- **Correspondence** (dunning letters, payment notices) — in scope?
- **Check management data** (tables PAYR, PCEC) — in scope?
- **Cash management position data** — in scope?

---

### Q-006: What about sub-ledger integration (ML, AA, CO)?

| Field | Value |
|-------|-------|
| **Category** | Scope Definition |
| **Module** | FI-GL / CO / ML / AA |
| **SAP Reference** | ACDOCA fields: KSTAR, PRCTR, SEGMENT, ANLN1, MATNR, BWKEY |
| **Impact if unanswered** | Documents loaded without CO/ML/AA data are incomplete in ACDOCA |

**Detail**:
- **Material Ledger (ML)**: In S/4HANA, ML postings go to ACDOCA (fields MATNR, BWKEY, MLCATEG). How do we handle historic ML documents? Do they go through our loading or through ML-specific migration?
- **Asset Accounting (AA)**: Asset postings create FI documents. Are AA-originated documents in scope? If yes, how to handle ANLN1/ANLN2 references without actual asset master?
- **Controlling (CO)**: FI documents carry CO fields (KOSTL, AUFNR, PRCTR, CO_BUSPROC). Must we populate them? What if source doesn't have them?
- **PS (Project System)**: FI docs with WBS/Network assignments — in scope?

---

## Answer Template

| Question | Answer | Justification | Evidence | Answered By | Date |
|----------|--------|---------------|----------|-------------|------|
| Q-001 | | | | | |
| Q-002 | | | | | |
| Q-003 | | | | | |
| Q-004 | | | | | |
| Q-005 | | | | | |
| Q-006 | | | | | |
