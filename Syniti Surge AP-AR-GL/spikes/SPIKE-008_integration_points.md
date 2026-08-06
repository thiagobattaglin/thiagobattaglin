# SPIKE-008: Technical Integration Points

## Spike Summary

| Field | Value |
|-------|-------|
| **Type** | Spike (Technical Investigation) |
| **Priority** | High |
| **Timebox** | 3 days |
| **Assignee** | FI Consultant Team |
| **Labels** | `spike`, `fi-specification`, `integration`, `side-effects` |

## Dependencies

| Dependency | Link | Relationship |
|-----------|------|--------------|
| GL Historic Transaction Loading | [RDG-1592](../RDG-1592.md) | Blocks — GL postings may trigger ALE/WF |
| AP Historic Transaction Loading | [RDG-1593](../RDG-1593.md) | Blocks — AP postings may trigger ALE/WF/BCM |
| AR Historic Transaction Loading | [RDG-1594](../RDG-1594.md) | Blocks — AR postings may trigger ALE/WF |
| Validation & Reconciliation Framework | [RDG-1590](../RDG-1590.md) | Informs — side effects may create unexpected data |
| Implementation Guide & Delivery Enablement | [RDG-1591](../RDG-1591.md) | Blocks — deactivation steps must be in guides |

## Objective

Identify all technical integration points that may be triggered by posting historic FI documents: ALE/IDocs, workflows, bank communication, and deployment model constraints. Define deactivation/bypass strategy.

## Expected Output

- List of ALE message types / change pointers to deactivate
- Workflow event linkages (SWE2) to suspend during loading
- Bank Communication impact assessment
- Platform deployment model constraints (on-prem vs. Cloud)

---

## Questions

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

### Q-036: S/4HANA Cloud deployment model support

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

## Answer Template

| Question | Answer | Justification | Evidence | Answered By | Date |
|----------|--------|---------------|----------|-------------|------|
| Q-033 | | | | | |
| Q-034 | | | | | |
| Q-035 | | | | | |
| Q-036 | | | | | |
