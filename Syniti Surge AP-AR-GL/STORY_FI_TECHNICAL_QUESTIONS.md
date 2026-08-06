# User Story: Technical Specification Questions for FI Consultants

## Story

**As a** Senior ABAP Developer on the Syniti Surge team,  
**I need** answers to all technical FI questions listed below  
**So that** I can design and build the historic AP/AR/GL transaction loading product for S/4HANA with confidence, ensuring Clean Core compliance, ACDOCA consistency, and full reconciliation capability.

**Context**: The feature [RI-871](https://entota.atlassian.net/jira/polaris/projects/RI/ideas/view/3066355?selectedIssue=RI-871) requires loading historic financial transactions into S/4HANA. There is no FI technical specification available. The development team needs FI Consultants to clarify all questions below before architecture decisions (ADRs) and development can begin.

**Priority**: P0 — Blocking all development  
**Assignee**: FI Consultant Team  
**Labels**: `architecture`, `fi-specification`, `blocking`, `historic-loading`

---

## Instructions for FI Consultants

Please answer each question below with:
1. **Answer** — clear, unambiguous response
2. **Justification** — why (business rule, SAP standard, customer requirement)
3. **Evidence** — SAP Note, transaction, config path, or documentation reference
4. **Impact if unanswered** — remains here for context of what blocks development

---

## SECTION 1: Scope & Document Types

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

## SECTION 2: Document Creation Strategy

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

## SECTION 3: Open Items vs. Cleared Items

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

## SECTION 4: S/4HANA Data Model (ACDOCA / Universal Journal)

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

## SECTION 5: Master Data Dependencies

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

## SECTION 6: Specific Scenarios & Edge Cases

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

## SECTION 7: Material Ledger & Specific Valuation

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

## SECTION 8: Technical Integration Points

### Q-033: ALE / IDoc / Change Pointer impact

| Field | Value |
|-------|-------|
| **Category** | Side Effects |
| **Module** | BC-MID (ALE) |
| **SAP Reference** | BD50, NAST, change pointers, message types FI_DOC* |
| **Impact if unanswered** | Loading triggers thousands of unwanted IDocs to downstream systems |

**Detail**:
- Does posting a FI document trigger change pointers (BD50)?
- If yes: IDocs generated for each loaded doc → floods downstream systems.
- Must we deactivate change pointers before loading?
- Which message types are relevant? (FIDCCP, ACC_DOCUMENT, DEBMAS, CREMAS?)
- What about output types (NAST) triggered by invoice posting?

---

### Q-034: Workflow and notification triggers

| Field | Value |
|-------|-------|
| **Category** | Side Effects |
| **Module** | BC-BMT-WFM (Workflow) |
| **SAP Reference** | SWE2 (Event linkage), BTE (Business Transaction Events) |
| **Impact if unanswered** | Thousands of workflow items created for migration docs |

**Detail**:
- Are there workflows triggered by FI document creation? (e.g., invoice approval workflows)
- Business Transaction Events (BTE via FIBF): any active that could interfere?
- Must we deactivate WF event linkages (SWE2) during loading?

---

### Q-035: Bank Communication Management (BCM) impact

| Field | Value |
|-------|-------|
| **Category** | Side Effects |
| **Module** | FI-BL (Bank Ledger) |
| **SAP Reference** | FEBEP (Bank Statement items), FF_5 (Cash Management) |
| **Impact if unanswered** | Loading payment docs affects bank reconciliation |

**Detail**:
- If we load payment documents: do they create entries in bank ledger (FEBEP)?
- If yes: bank reconciliation will show phantom items.
- Impact on cash management position (FF_5)?
- Must bank-relevant documents be excluded from loading?

---

### Q-036: Real-Time Integration to S/4HANA Cloud

| Field | Value |
|-------|-------|
| **Category** | Technical Constraint |
| **Module** | Platform |
| **SAP Reference** | SAP S/4HANA Cloud deployment model restrictions |
| **Impact if unanswered** | Product may not work on Cloud editions |

**Detail**:
- Is the product designed for on-premise / private cloud only?
- What about S/4HANA Public Cloud (3-system landscape)?
  - Public Cloud has NO access to SE16, no custom tables (unless RAP-based key user extensibility)
  - Public Cloud migration uses SAP Migration Cockpit ONLY
  - Custom BAPIs are not allowed
- What about RISE with SAP (private cloud managed)?
- Does this affect our Clean Core compliance claim?

---

## SECTION 9: Reconciliation & Validation

### Q-037: What constitutes a "successful reconciliation"?

| Field | Value |
|-------|-------|
| **Category** | Acceptance Criteria |
| **Module** | FI (all) |
| **SAP Reference** | FAGLB03, FBL1N/FBL5N, trial balance |
| **Impact if unanswered** | Cannot define pass/fail criteria for DoD |

**Detail**: Define precisely for each level:

**Document level**:
- Debit = Credit per document? (always, by accounting rule)
- Line item count source = target?
- Amounts per line match?

**Account level (period)**:
- GL account balance per period: source = target?
- Tolerance: zero? Or ±0.01 for rounding?

**Subledger level**:
- Σ vendor open items (BSIK) = GL reconciliation account (FAGLB03 for AKONT)?
- Σ customer open items (BSID) = GL reconciliation account?

**Cross-module**:
- GL total = AP reconciliation account + AR reconciliation account + other accounts?
- Trial balance source (full) vs trial balance target (loaded)?

**Audit sampling**:
- Random sample of N documents: verify source→target field-by-field?
- What N is acceptable? (10? 100? statistical sample?)

---

### Q-038: How to handle reconciliation differences from excluded items?

| Field | Value |
|-------|-------|
| **Category** | Reconciliation Logic |
| **Module** | FI (all) |
| **Impact if unanswered** | False-positive discrepancies in reconciliation report |

**Detail**: If certain doc types are EXCLUDED from scope (e.g., payment docs, FC reval):
- The trial balance will NOT match 100% by design.
- How to account for excluded items in reconciliation?
- Do we need a "reconciliation adjustment" calculation: `Target balance = Source balance - Excluded items`?
- Who defines and signs off on the exclusion list?

---

## SECTION 10: Operational & Cutover Questions

### Q-039: Period opening/closing procedure

| Field | Value |
|-------|-------|
| **Category** | Operational |
| **Module** | FI-GL |
| **SAP Reference** | OB52, T001B (period control), BRGRU |
| **Impact if unanswered** | Posting rejected due to closed periods |

**Detail**:
- Must ALL historical periods be opened simultaneously?
- Or can we open/load/close period by period (sequential)?
- Security concern: opening old periods in production allows any user to post retroactively.
  - Can we restrict via authorization group (BRGRU)?
  - Can we restrict to the technical migration user only?
- What about fiscal year close carryforward (T-code FAGL_FC_CARRY_FORWARD)?
  - If we load data in a year that's already carried forward: does it break?

---

### Q-040: Parallel execution / concurrency

| Field | Value |
|-------|-------|
| **Category** | Performance |
| **Module** | FI (all) |
| **SAP Reference** | SM50, SM66, RFC destinations, dialog vs background WP |
| **Impact if unanswered** | Cannot estimate load time or cutover window feasibility |

**Detail**:
- Can multiple documents be posted in parallel? (Answer: YES, if no lock conflicts)
- What lock objects are held during `BAPI_ACC_DOCUMENT_POST`?
  - ENQUEUE on BKPF (company code + fiscal year)?
  - ENQUEUE on number range?
  - Lock on vendor/customer master?
- If posting GL + AP + AR simultaneously: any lock conflicts?
- Maximum parallelism recommended? (4? 8? 16 processes?)
- Background vs dialog: which is appropriate?
- RFC server groups: relevant?

---

### Q-041: Cutover sequence — what must happen BEFORE loading?

| Field | Value |
|-------|-------|
| **Category** | Operational |
| **Module** | FI (all) |
| **Impact if unanswered** | Loading fails due to missing prerequisites |

**Detail**: Confirm the following must be completed BEFORE historic loading:
- [ ] CoA migration (all GL accounts exist in target)
- [ ] Profit Center hierarchy (CEPC)
- [ ] Cost Center hierarchy (CSKS)
- [ ] Business Partner migration (all vendors/customers)
- [ ] Bank master data (BNKA, T012)
- [ ] Tax code configuration (T007A)
- [ ] Document type configuration (T003)
- [ ] Number range setup (FBN1)
- [ ] Fiscal year variant configuration (T009)
- [ ] Exchange rates loaded (TCURR) for all periods
- [ ] Document Splitting configuration (if active)
- [ ] Period open for loading (OB52)
- [ ] Authorization role for migration user

**Anything else?**

---

### Q-042: What happens AFTER loading? (Post-processing)

| Field | Value |
|-------|-------|
| **Category** | Operational |
| **Module** | FI (all) |
| **Impact if unanswered** | Loaded data not fully integrated |

**Detail**: After historic data is loaded, which post-processing steps are needed?
- Close opened periods (OB52)?
- Run balance carryforward (FAGL_FC_CARRY_FORWARD)?
- Recalculate totals (transaction FAGL_RESET_TOTALS / F.5E)?
- Update credit management exposure (FCV1)?
- Update dunning levels for AR (if loaded without dunning data)?
- Rebuild indexes / statistics (DB-level)?
- Activate change pointers again (if deactivated)?
- Remove migration user / lock?

---

## SECTION 11: Clean Core & Compliance

### Q-043: Which APIs are C1-Released (stable contract) for this use case?

| Field | Value |
|-------|-------|
| **Category** | Clean Core |
| **Module** | FI (all) |
| **SAP Reference** | SAP API Business Hub, ADT Released Objects |
| **Impact if unanswered** | Using non-released APIs violates Clean Core |

**Detail**: Confirm released status for:
| Object | Type | Released? |
|--------|------|-----------|
| BAPI_ACC_DOCUMENT_POST | BAPI (FM) | ? |
| BAPI_ACC_DOCUMENT_CHECK | BAPI (FM) | ? |
| BAPI_ACC_DOCUMENT_REV_POST | BAPI (FM) | ? |
| I_JournalEntry | CDS View | ? |
| I_GLAccountLineItem | CDS View | ? |
| I_SupplierLineItem | CDS View | ? |
| I_CustomerLineItem | CDS View | ? |
| CL_BAL_LOG | Class | ? |
| IF_BADI_ACC_DOCUMENT | BAdI Interface | ? |

- If `BAPI_ACC_DOCUMENT_POST` is NOT released in target release: what is the alternative?
- Is there a RAP-based API for FI document posting in newer releases?
- What about `FINSC_POST_API` (new Clean Core posting API)?

---

### Q-044: ATC scan requirements for delivered code

| Field | Value |
|-------|-------|
| **Category** | Clean Core |
| **Module** | Development |
| **SAP Reference** | ATC (ABAP Test Cockpit), variant ABAP_CLOUD_READINESS |
| **Impact if unanswered** | Code rejected by customer governance |

**Detail**:
- Must all delivered Z-code pass ATC with variant `ABAP_CLOUD_READINESS`?
- What about code that uses BAPIs (which are released but call classic modules internally)?
- Custom tables (ZSURGE_*): allowed under Tier 1? Or must use RAP-managed tables?
- Application Log (SLG0/SLG1): is `CL_BAL_LOG` released in Tier 1?

---

## SECTION 12: Risk & Edge Cases

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

## SECTION 13: Country-Specific Requirements

### Q-049: Country-specific fields and legal requirements

| Field | Value |
|-------|-------|
| **Category** | Scope Definition |
| **Module** | FI (localization) |
| **SAP Reference** | Various (J_1B*, J_1A*, J_1I*, etc.) |
| **Impact if unanswered** | Missing legal fields in specific countries |

**Detail**: Which countries will use this product? Each may have specific requirements:

| Country | Specific Concern |
|---------|-----------------|
| Brazil | Nota Fiscal reference (J_1BNFLIN), CFOP, tax split (PIS/COFINS/ICMS), SPED ECF/ECD reporting |
| India | GST fields (J_1IG*), HSN code, TDS/TCS (Withholding Tax) |
| Mexico | UUID (CFDI), SAT catalog codes |
| Argentina | Perception/Withholding tax (J_1A*), CUIT |
| USA/Canada | 1099 reporting (QSSHH, BSEG-J_1KFTIND) |
| EU | VAT registration, Intrastat (BSEG-MWSKZ + country) |
| China | Golden Tax integration, Fapiao |

- Must we support ALL country-specific fields?
- Or: define supported countries for v1?
- What about multi-country customers (loading AP from 20 company codes in different countries)?

---

### Q-050: Electronic invoicing compliance

| Field | Value |
|-------|-------|
| **Category** | Legal Compliance |
| **Module** | FI (localization) |
| **Impact if unanswered** | Loaded docs may trigger e-invoice submission |

**Detail**:
- In countries with electronic invoicing (Brazil NF-e, Mexico CFDI, India e-Invoice):
  - Does posting a historical document trigger an e-invoice submission?
  - How to prevent this?
  - Must we populate the external document reference (UUID/chave de acesso)?

---

---

## Summary Statistics

| Category | Questions |
|----------|-----------|
| Scope & Document Types | Q-001 to Q-006 |
| Document Creation Strategy | Q-007 to Q-011 |
| Open Items vs. Cleared Items | Q-012 to Q-015 |
| S/4HANA Data Model (ACDOCA) | Q-016 to Q-019 |
| Master Data Dependencies | Q-020 to Q-023 |
| Specific Scenarios & Edge Cases | Q-024 to Q-030 |
| Material Ledger & Valuation | Q-031 to Q-032 |
| Technical Integration Points | Q-033 to Q-036 |
| Reconciliation & Validation | Q-037 to Q-038 |
| Operational & Cutover | Q-039 to Q-042 |
| Clean Core & Compliance | Q-043 to Q-044 |
| Risk & Edge Cases | Q-045 to Q-048 |
| Country-Specific Requirements | Q-049 to Q-050 |
| **TOTAL** | **50 Questions** |

---
