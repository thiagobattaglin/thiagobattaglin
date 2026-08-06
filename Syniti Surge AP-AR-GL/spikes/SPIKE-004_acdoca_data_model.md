# SPIKE-004: S/4HANA Data Model — ACDOCA / Universal Journal

## Spike Summary

| Field | Value |
|-------|-------|
| **Type** | Spike (Technical Investigation) |
| **Priority** | P0 — Blocking |
| **Timebox** | 3 days |
| **Assignee** | FI Consultant Team |
| **Labels** | `spike`, `fi-specification`, `acdoca`, `data-model`, `blocking` |

## Dependencies

| Dependency | Link | Relationship |
|-----------|------|--------------|
| GL Historic Transaction Loading | [RDG-1592](../RDG-1592.md) | Blocks — ACDOCA is the primary target table for GL |
| AP Historic Transaction Loading | [RDG-1593](../RDG-1593.md) | Blocks — AP line items stored in ACDOCA |
| AR Historic Transaction Loading | [RDG-1594](../RDG-1594.md) | Blocks — AR line items stored in ACDOCA |
| Validation & Reconciliation Framework | [RDG-1590](../RDG-1590.md) | Blocks — reconciliation must validate ACDOCA completeness |
| Implementation Guide & Delivery Enablement | [RDG-1591](../RDG-1591.md) | Blocks — guides must document mandatory fields |

## Objective

Clarify which ACDOCA fields are mandatory, how Document Splitting affects loaded documents, which currencies must be populated, and which ledgers receive the data. These are non-negotiable S/4HANA requirements.

## Expected Output

- Mandatory ACDOCA field list for valid document storage
- Document Splitting configuration and impact on loading
- Currency types and exchange rate requirements
- Ledger strategy (leading + extension ledgers)

---

## Questions

### Q-016: Which ACDOCA fields are mandatory for a valid document?

| Field | Value |
|-------|-------|
| **Category** | Technical Requirement |
| **Module** | FI-GL (New GL) |
| **SAP Reference** | Table ACDOCA, CDS View I_JournalEntry |
| **Impact if unanswered** | Documents stored incompletely; reports return wrong data |

**Detail**: ACDOCA has 400+ fields. Which must be populated for the document to be:
- Visible in FAGLL03H?
- Included in FAGLB03 balances?
- Correct in Financial Statements (S_ALR_87012284)?
- Correct in CDS View `I_JournalEntry`?
- Correct for Document Splitting?

Key fields to clarify source:
| ACDOCA Field | Description | Source? |
|---|---|---|
| RLDNR | Ledger | Always '0L' for leading? |
| RRCTY | Record type | '0' for actual? |
| RBUKRS | Company Code | From source |
| GJAHR | Fiscal Year | From source |
| BELNR | Document Number | Assigned or preserved? |
| DOCLN | Line Item | Derived? |
| RYEAR | Fiscal Year (redundant?) | Same as GJAHR? |
| POPER | Posting Period | Derived from BUDAT? |
| RACCT | Account | Source or mapped? |
| RCNTR | Cost Center | Mandatory? |
| PRCTR | Profit Center | Mandatory for splitting? |
| SEGMENT | Segment | Derived from PC? |
| RFAREA | Functional Area | Mandatory? |
| RHCUR/HSL | House Currency Amount | How to derive? |
| RKCUR/KSL | Group Currency Amount | How to derive? |
| RWCUR/WSL | Transaction Currency | From source |
| DRCRK | Debit/Credit indicator | Derived from amount sign? |

---

### Q-017: Document Splitting — mandatory characteristics?

| Field | Value |
|-------|-------|
| **Category** | Configuration Requirement |
| **Module** | FI-GL (New GL) |
| **SAP Reference** | FAGL_SPLINFO, FAGL_SPLIT_CUST, OB65 |
| **Impact if unanswered** | ACDOCA inconsistency; zero-balance rule violated |

**Detail**:
- Is Document Splitting ACTIVE in the target system? (Check: FAGL_SPLINFO)
- If active: which characteristics split the document?
  - Profit Center (PRCTR)?
  - Segment (SEGMENT)?
  - Business Area (GSBER)?
  - Functional Area (FKBER)?
- Does the target enforce **zero-balance per splitting characteristic**?
  - If yes: loading a doc without Profit Center on expense line → system auto-generates balancing line → changes document structure from source
- What happens if source documents DON'T have the splitting characteristic populated?
  - Default value?
  - Reject the document?
  - Derive from account master (SKA1-FSTAG → CEPC)?
- Does splitting apply to ALL document types or only specific ones?
- Are there splitting rules based on **business transaction variant** (config in SPRO)?

---

### Q-018: Parallel currencies — which currency types are active?

| Field | Value |
|-------|-------|
| **Category** | Configuration Requirement |
| **Module** | FI-GL |
| **SAP Reference** | T001-WAERS/HWAE2/HWAE3, FINSC_LEDGER, TCURR |
| **Impact if unanswered** | Documents stored with wrong/missing currency amounts |

**Detail**:
- How many currencies does the target system maintain?
  - Currency type 10 (Company Code Currency) — always
  - Currency type 30 (Group Currency) — active?
  - Currency type 40 (Hard Currency) — active? (common in Latin America)
  - Currency type 50/60 (Index-based) — active?
- For each active currency type: what is the exchange rate type (KURST)?
- Are historical exchange rates available in TCURR for ALL periods in scope?
- If rates are missing: do we load them first? Or derive amounts differently?
- Does the source system provide amounts in ALL target currencies, or must we CONVERT during loading?
- What about currency rounding differences? Tolerance?

---

### Q-019: Ledger strategy — which ledgers receive the data?

| Field | Value |
|-------|-------|
| **Category** | Configuration Requirement |
| **Module** | FI-GL |
| **SAP Reference** | FINSC_LEDGER (T-code FINSC_LEDGER), ACDOCA-RLDNR |
| **Impact if unanswered** | Data loaded to wrong ledger; extension ledgers missing |

**Detail**:
- Leading ledger (0L) — always populated. What about:
  - Extension ledgers (e.g., 2L for IFRS, Z1 for local GAAP)?
  - Non-leading ledgers for parallel accounting?
- If multiple ledgers: must we post to EACH ledger separately?
- Does `BAPI_ACC_DOCUMENT_POST` support multi-ledger posting? (via EXTENSION2 structure BAPI_ACCG_LD_POST?)
- What if source system has ONE accounting standard but target has TWO (e.g., HGB + IFRS)?

---

## Answer Template

| Question | Answer | Justification | Evidence | Answered By | Date |
|----------|--------|---------------|----------|-------------|------|
| Q-016 | | | | | |
| Q-017 | | | | | |
| Q-018 | | | | | |
| Q-019 | | | | | |
