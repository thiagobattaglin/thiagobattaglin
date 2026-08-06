# SPIKE-011: Clean Core & Compliance

## Spike Summary

| Field | Value |
|-------|-------|
| **Type** | Spike (Technical Investigation) |
| **Priority** | P0 — Blocking |
| **Timebox** | 2 days |
| **Assignee** | FI Consultant Team |
| **Labels** | `spike`, `fi-specification`, `clean-core`, `compliance`, `blocking` |

## Dependencies

| Dependency | Link | Relationship |
|-----------|------|--------------|
| GL Historic Transaction Loading | [RDG-1592](../RDG-1592.md) | Blocks — Clean Core compliance is acceptance criteria |
| AP Historic Transaction Loading | [RDG-1593](../RDG-1593.md) | Blocks — Clean Core compliance is acceptance criteria |
| AR Historic Transaction Loading | [RDG-1594](../RDG-1594.md) | Blocks — Clean Core compliance is acceptance criteria |
| Validation & Reconciliation Framework | [RDG-1590](../RDG-1590.md) | Blocks — framework code must also be compliant |
| Implementation Guide & Delivery Enablement | [RDG-1591](../RDG-1591.md) | Blocks — compliance constraints documented in guides |

## Objective

Verify which APIs are C1-Released (stable contract) for this use case, confirm ATC scan requirements, and clarify development constraints under ABAP Cloud / Tier 1 model.

## Expected Output

- Confirmed C1-Released API list (BAPIs, CDS Views, Classes)
- ATC variant and scan requirements for delivered code
- Custom table / RAP-managed approach decision
- Alternative APIs if primary ones are not released

---

## Questions

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

## Answer Template

| Question | Answer | Justification | Evidence | Answered By | Date |
|----------|--------|---------------|----------|-------------|------|
| Q-043 | | | | | |
| Q-044 | | | | | |
