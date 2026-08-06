# Syniti Surge AP/AR/GL — Task Board Summary

> **Generated on**: April 30, 2026  
> **Based on**: Product Review + Architecture Review + Architecture Blueprint  
> **Total Tasks**: 80  
> **Total EPICs**: 10

---\

## EPICs Overview

| EPIC | Title | Tasks | Priority | Blocking? | Dependencies |
|------|-------|-------|----------|-----------|--------------|
| [EPIC-001](EPIC-001_decisoes_arquiteturais.md) | Architecture Decisions (ADRs) | TASK-001 to 010 | P0 | **YES** — blocks everything | None |
| [EPIC-002](EPIC-002_levantamento_tecnico_poc.md) | Technical Discovery & POC | TASK-011 to 020 | P0 | **YES** | EPIC-001 partial |
| [EPIC-003](EPIC-003_infrastructure_framework.md) | Infrastructure & Framework | TASK-021 to 028 | P0 | YES (for EPICs 4-6) | EPIC-001, EPIC-002 |
| [EPIC-004](EPIC-004_gl_loading.md) | GL Historic Loading | TASK-029 to 035 | P0 | YES (for EPICs 5-6) | EPIC-003 |
| [EPIC-005](EPIC-005_ap_loading.md) | AP Historic Loading | TASK-036 to 042 | P0 | No | EPIC-004 |
| [EPIC-006](EPIC-006_ar_loading.md) | AR Historic Loading | TASK-043 to 049 | P0 | No | EPIC-004 |
| [EPIC-007](EPIC-007_reconciliation_framework.md) | Reconciliation Framework | TASK-050 to 054 | P0 | YES (for go-live) | EPIC-004/005/006 |
| [EPIC-008](EPIC-008_performance_production.md) | Performance & Production | TASK-055 to 059 | P1 | YES (for go-live) | EPIC-004/005/006 |
| [EPIC-009](EPIC-009_documentation_enablement.md) | Documentation & Enablement | TASK-060 to 065 | P1 | No | All technical EPICs |
| [EPIC-010](EPIC-010_findings_resolution.md) | Findings Resolution | TASK-066 to 080 | P0/P1 | Partially | None (except ADRs) |

---

## Recommended Sequence (Timeline)

```
Sprint 1-2:  EPIC-001 (ADRs) + EPIC-010 (Document findings) + EPIC-002 (Research/POC)
Sprint 3-4:  EPIC-003 (Infrastructure) — framework development
Sprint 5-6:  EPIC-004 (GL Loading) — first transaction type
Sprint 7-8:  EPIC-005 (AP) + EPIC-006 (AR) — in parallel if resources available
Sprint 9:    EPIC-007 (Reconciliation) — final cross-module framework
Sprint 10:   EPIC-008 (Performance/Production) — stress test and tuning
Sprint 11:   EPIC-009 (Documentation) — guides and enablement
```

---

## Reference Documents

| Document | Type | Content |
|----------|------|---------|
| [RI-871.md](../RI-871.md) | Feature Document | Objective, Value Statement, Key Deliverables, DoD, Demo |
| [RDG-1590.md](../RDG-1590.md) | RDG | Validation & Reconciliation Framework |
| [RDG-1591.md](../RDG-1591.md) | RDG | Implementation Guide & Delivery Enablement |
| [RDG-1592.md](../RDG-1592.md) | RDG | GL Historic Transaction Loading |
| [RDG-1593.md](../RDG-1593.md) | RDG | AP Historic Transaction Loading |
| [RDG-1594.md](../RDG-1594.md) | RDG | AR Historic Transaction Loading |

---

## Blocking Decisions (Do not start dev without these)

| # | Decision | Owner | EPIC/Task |
|---|----------|-------|-----------|
| 1 | GL: document-level vs balance carry-forward | Product Owner + Finance | EPIC-001/TASK-002 |
| 2 | AP/AR: cleared items (individual vs summarized) | Product Owner + Finance | EPIC-001/TASK-003 |
| 3 | Migration Objects confirmed in LTMC | SAP Specialist | EPIC-002/TASK-012 |
| 4 | S/4HANA target version confirmed | Client IT | EPIC-002/TASK-011 |
| 5 | Document Splitting active? Config? | Client FI | EPIC-001/TASK-004 |

---

## Prioritization Criteria for Jira

- **P0 — Blocking**: Must be completed before starting the next phase
- **P1 — Essential**: Required for go-live but does not block intermediate development
- **P2 — Desirable**: Adds value but can be post-MVP

---

## How to use this board

1. **Import EPICs** as Epics in Jira
2. **Import TASKs** as Stories/Tasks linked to the corresponding EPIC
3. **Use checkboxes** ([ ]) within each task as sub-tasks or acceptance criteria
4. **Configure dependencies** in Jira per the "Prerequisites" column of each EPIC
5. **Assign owners** as indicated in each task
6. **Sprint planning**: follow the recommended sequence above
