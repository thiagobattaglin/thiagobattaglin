# SPIKE-002: Document Creation Strategy

## Spike Summary

| Field | Value |
|-------|-------|
| **Type** | Spike (Technical Investigation) |
| **Priority** | P0 — Blocking |
| **Timebox** | 3 days |
| **Assignee** | FI Consultant Team |
| **Labels** | `spike`, `fi-specification`, `architecture`, `blocking` |

## Dependencies

| Dependency | Link | Relationship |
|-----------|------|--------------|
| GL Historic Transaction Loading | [RDG-1592](../RDG-1592.md) | Blocks — posting logic validation depends on strategy |
| AP Historic Transaction Loading | [RDG-1593](../RDG-1593.md) | Blocks — posting logic validation depends on strategy |
| AR Historic Transaction Loading | [RDG-1594](../RDG-1594.md) | Blocks — posting logic validation depends on strategy |
| Validation & Reconciliation Framework | [RDG-1590](../RDG-1590.md) | Blocks — reconciliation approach depends on creation strategy |
| Implementation Guide & Delivery Enablement | [RDG-1591](../RDG-1591.md) | Blocks — execution guidance depends on strategy choice |

## Objective

Define the fundamental architecture decisions about HOW documents are created in the target system: exact replica vs. summarized, posting dates, number ranges, and how to avoid side effects from posting historic data.

## Expected Output

- Decision per module: exact replica vs. summarized vs. hybrid
- Posting date strategy (original vs. migration date)
- Number range strategy (preserve, internal, or dedicated interval)
- Side-effect avoidance mechanism (how to suppress triggers)
- Fiscal year variant and special period handling rules

---

## Questions

### Q-007: Exact replica vs. summarized documents?

| Field | Value |
|-------|-------|
| **Category** | Architecture Decision |
| **Module** | FI (all) |
| **SAP Reference** | BAPI_ACC_DOCUMENT_POST, LTMC |
| **Impact if unanswered** | Fundamental design choice blocks all development |

**Detail**: For each module, clarify:

**Option A — Exact replica (1:1)**:
- One SAP doc in target per one doc in source
- Same number of line items
- Same amounts per line
- Preserves full drill-down capability
- High volume, high complexity

**Option B — Summarized/Aggregated**:
- Multiple source docs → one target doc per period/account/vendor
- Reduces volume dramatically
- Loses individual document drill-down
- May be sufficient for reporting needs

**Option C — Hybrid**:
- Open items: exact replica (needed for operations)
- Cleared items: summarized (only needed for history/totals)

**Per module, which option?**
| Module | Open Items | Cleared Items | Balances Only? |
|--------|-----------|---------------|----------------|
| GL | ? | ? | ? |
| AP | ? | ? | ? |
| AR | ? | ? | ? |

---

### Q-008: How to post without affecting target system operations?

| Field | Value |
|-------|-------|
| **Category** | Architecture Decision |
| **Module** | FI (all) |
| **SAP Reference** | BAPI_ACC_DOCUMENT_POST parameter EXTENSION2, BAdI BADI_ACC_DOCUMENT |
| **Impact if unanswered** | Loading could trigger unintended side effects |

**Detail**: Loading historic documents must NOT:
- Trigger automatic payment runs (F110)
- Trigger dunning runs (F150)
- Affect credit management limits/exposure
- Trigger workflow notifications
- Trigger ALE/IDoc distribution (change pointers)
- Affect bank reconciliation (FEBEP)
- Trigger tax reporting (periodic VAT returns)
- Update CO actuals for current plan versions
- Trigger asset depreciation recalculation
- Affect cash management planning

**Questions for FI**:
- Which BAdIs/Substitutions/Validations in the target reject or modify historical postings?
- Can we use a specific **posting key combination** that marks documents as "migration" to bypass operational triggers?
- Is there a migration-specific document type that avoids these side effects?
- Can we use header text pattern (BKTXT) or reference field (XBLNR) to tag migration docs for exclusion from operational processes?

---

### Q-009: Which posting date (BUDAT) and document date (BLDAT) strategy?

| Field | Value |
|-------|-------|
| **Category** | Architecture Decision |
| **Module** | FI (all) |
| **SAP Reference** | BKPF-BUDAT, BKPF-BLDAT, BKPF-CPUDT |
| **Impact if unanswered** | Wrong dates cause period assignment errors, balance mismatches |

**Detail**:
- **BUDAT (Posting Date)**: Use original posting date from source? Or use migration execution date?
  - If original: periods must be opened retroactively
  - If migration date: all docs land in current period = wrong trial balance per period
- **BLDAT (Document Date)**: Preserve original document date from source?
- **CPUDT (Entry Date)**: This is system-generated (date of entry). Accept that it will be the migration execution date?
- **AEDAT (Changed on)**: Not settable via BAPI — accept loss?
- **Impact on period-end reports**: If BUDAT = original, then monthly trial balances per period are correct. Is this required?

---

### Q-010: How to handle fiscal year variants and special periods?

| Field | Value |
|-------|-------|
| **Category** | Configuration |
| **Module** | FI-GL |
| **SAP Reference** | T009, T009B, OB29 (Fiscal Year Variant) |
| **Impact if unanswered** | Posting to wrong period; rejection of docs in special periods |

**Detail**:
- Does the target use calendar year (K4) or non-standard fiscal year variant?
- Does the source use a DIFFERENT fiscal year variant than the target?
- If different: how to handle period mapping? (e.g., source period 13 → target period ?)
- Are there documents in **special periods** (13, 14, 15, 16)? How to handle?
- Can we post to special periods via BAPI, or do they require manual posting (F-02)?

---

### Q-011: Number range strategy — preserve original document numbers?

| Field | Value |
|-------|-------|
| **Category** | Architecture Decision |
| **Module** | FI (all) |
| **SAP Reference** | FBN1, NRIV, BKPF-BELNR, BKPF-XBLNR |
| **Impact if unanswered** | Audit trail definition; conflict with existing NR assignments |

**Detail**:
- **Option A**: Preserve original document number (BELNR) from source
  - Requires external number range assignment
  - Risk: conflicts with existing docs in target
  - Requires FBN1 configuration of external intervals
- **Option B**: Let SAP assign new number (internal numbering)
  - Original number preserved in XBLNR (Reference) for audit trail
  - No conflict risk
  - Requires cross-reference table for audit
- **Option C**: Dedicated number range interval for migration
  - Internal, but in a specific range (e.g., 5000000000-5999999999)
  - Easy to identify migration docs later

**Which option does the customer/product prefer?**

---

## Answer Template

| Question | Answer | Justification | Evidence | Answered By | Date |
|----------|--------|---------------|----------|-------------|------|
| Q-007 | | | | | |
| Q-008 | | | | | |
| Q-009 | | | | | |
| Q-010 | | | | | |
| Q-011 | | | | | |
