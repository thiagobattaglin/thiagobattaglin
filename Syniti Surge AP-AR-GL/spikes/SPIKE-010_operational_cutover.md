# SPIKE-010: Operational & Cutover

## Spike Summary

| Field | Value |
|-------|-------|
| **Type** | Spike (Technical Investigation) |
| **Priority** | High |
| **Timebox** | 3 days |
| **Assignee** | FI Consultant Team |
| **Labels** | `spike`, `fi-specification`, `operational`, `cutover` |

## Dependencies

| Dependency | Link | Relationship |
|-----------|------|--------------|
| GL Historic Transaction Loading | [RDG-1592](../RDG-1592.md) | Blocks — cutover steps for GL |
| AP Historic Transaction Loading | [RDG-1593](../RDG-1593.md) | Blocks — cutover steps for AP |
| AR Historic Transaction Loading | [RDG-1594](../RDG-1594.md) | Blocks — cutover steps for AR |
| Validation & Reconciliation Framework | [RDG-1590](../RDG-1590.md) | Blocks — post-processing affects reconciliation |
| Implementation Guide & Delivery Enablement | [RDG-1591](../RDG-1591.md) | Directly implements — cutover sequence documented in guides |

## Objective

Define the operational procedures for cutover: period opening/closing, parallel execution strategy, prerequisites checklist, and post-processing steps after loading.

## Expected Output

- Period opening/closing procedure with security controls
- Concurrency/parallelism strategy and lock conflict analysis
- Complete prerequisites checklist (pre-loading)
- Post-processing runbook (post-loading)

---

## Questions

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

## Answer Template

| Question | Answer | Justification | Evidence | Answered By | Date |
|----------|--------|---------------|----------|-------------|------|
| Q-039 | | | | | |
| Q-040 | | | | | |
| Q-041 | | | | | |
| Q-042 | | | | | |
