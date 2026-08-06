# SPIKE-005: Master Data Dependencies

## Spike Summary

| Field | Value |
|-------|-------|
| **Type** | Spike (Technical Investigation) |
| **Priority** | High |
| **Timebox** | 2 days |
| **Assignee** | FI Consultant Team |
| **Labels** | `spike`, `fi-specification`, `master-data`, `prerequisites` |

## Dependencies

| Dependency | Link | Relationship |
|-----------|------|--------------|
| AP Historic Transaction Loading | [RDG-1593](../RDG-1593.md) | Blocks — BP must exist before AP posting |
| AR Historic Transaction Loading | [RDG-1594](../RDG-1594.md) | Blocks — BP must exist before AR posting |
| GL Historic Transaction Loading | [RDG-1592](../RDG-1592.md) | Blocks — CoA must exist before GL posting |
| Validation & Reconciliation Framework | [RDG-1590](../RDG-1590.md) | Informs — reconciliation accounts depend on master data |
| Implementation Guide & Delivery Enablement | [RDG-1591](../RDG-1591.md) | Blocks — prerequisites must be documented in guides |

## Objective

Clarify all master data prerequisites that must exist in the target system before historic loading can begin: Business Partner mapping, Chart of Accounts, Tax Codes, and Bank Accounts.

## Expected Output

- BP migration dependency confirmation and mapping table location
- Chart of Accounts mapping strategy (identical vs. new CoA)
- Tax code handling rules (original vs. mapped, recalculate vs. pass-through)
- Bank account/house bank prerequisites for payment documents

---

## Questions

### Q-020: Business Partner — vendor/customer mapping requirement

| Field | Value |
|-------|-------|
| **Category** | Prerequisite |
| **Module** | FI-AP, FI-AR |
| **SAP Reference** | BUT000, CVI_CUST_LINK, CVI_VEND_LINK, BP role |
| **Impact if unanswered** | AP/AR postings rejected — BP is mandatory in S/4HANA |

**Detail**: In S/4HANA, there is NO direct vendor/customer. Everything is Business Partner.
- Is Business Partner migration COMPLETE before we start AP/AR loading?
- Where is the mapping table? (CVI_VEND_LINK: vendor→BP, CVI_CUST_LINK: customer→BP)
- What about one-time vendors/customers (CPD accounts, account type C)?
  - How to handle BSEG-LIFNR/KUNNR for one-time with address data?
- What about alternative payers/payees (BSEG-EMPFK)?
- What about intercompany vendors/customers?

---

### Q-021: Chart of Accounts — mapping required?

| Field | Value |
|-------|-------|
| **Category** | Prerequisite |
| **Module** | FI-GL |
| **SAP Reference** | SKA1, SKB1, T001-KTOPL |
| **Impact if unanswered** | GL postings rejected due to invalid accounts |

**Detail**:
- Is the target Chart of Accounts (CoA) identical to the source?
- If different (new CoA in S/4): is there a mapping table? Where?
- What about accounts that exist in source but NOT in target (decommissioned accounts)?
  - Reject document? Map to catch-all? Split mapping?
- Group Chart of Accounts (KTOPL in T001): relevant for consolidation?
- Country Chart of Accounts: used?

---

### Q-022: Tax codes — mapping and handling

| Field | Value |
|-------|-------|
| **Category** | Prerequisite |
| **Module** | FI (all) |
| **SAP Reference** | T007A, BSEG-MWSKZ, J_1BTXST3 (Brazil) |
| **Impact if unanswered** | Tax code mismatch → posting rejection or wrong tax amounts |

**Detail**:
- Must historic documents carry the ORIGINAL tax code from source?
- If target has different tax codes: mapping required?
- Must tax be RECALCULATED during loading, or load exact amounts from source?
- What about tax condition records (FTXP configuration)?
- Country-specific tax: Brazil (Nota Fiscal integration, ICMS, PIS, COFINS), India (GST), EU (OSS)?
- Historical tax rate changes: if loaded doc has old rate, does the system validate against current rate?

---

### Q-023: Bank accounts and house banks

| Field | Value |
|-------|-------|
| **Category** | Prerequisite |
| **Module** | FI-AP/AR (payment-related fields) |
| **SAP Reference** | T012, BNKA, BSEG-HBKID/HKTID |
| **Impact if unanswered** | Payment-related fields rejected or orphaned |

**Detail**:
- If we load payment documents (KZ/DZ): do we need house bank/account ID in the doc?
- Must the house banks exist in target (T012)?
- Partner bank data (vendor/customer bank details) — must exist in BP before loading?
- Payment method fields (BSEG-ZLSCH) — must payment method config exist?

---

## Answer Template

| Question | Answer | Justification | Evidence | Answered By | Date |
|----------|--------|---------------|----------|-------------|------|
| Q-020 | | | | | |
| Q-021 | | | | | |
| Q-022 | | | | | |
| Q-023 | | | | | |
