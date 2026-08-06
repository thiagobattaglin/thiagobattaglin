# Spikes Index — FI Technical Specification

## Overview

These Spikes are timeboxed technical investigations assigned to the **FI Consultant Team**. Each Spike contains questions that must be answered before development of the Historic AP/AR/GL Loading product can begin.

**Source Document**: [STORY_FI_TECHNICAL_QUESTIONS.md](../STORY_FI_TECHNICAL_QUESTIONS.md)  
**Feature**: [RI-871](../RI-871.md)

## Dependencies

All Spikes block the following deliverables:

| RDG | Title | Link |
|-----|-------|------|
| RDG-1590 | Validation & Reconciliation Framework | [RDG-1590.md](../RDG-1590.md) |
| RDG-1591 | Implementation Guide & Delivery Enablement | [RDG-1591.md](../RDG-1591.md) |
| RDG-1592 | GL Historic Transaction Loading | [RDG-1592.md](../RDG-1592.md) |
| RDG-1593 | AP Historic Transaction Loading | [RDG-1593.md](../RDG-1593.md) |
| RDG-1594 | AR Historic Transaction Loading | [RDG-1594.md](../RDG-1594.md) |

## Spike List

| # | Spike | Priority | Timebox | Questions | Status |
|---|-------|----------|---------|-----------|--------|
| 001 | [Scope & Document Types](SPIKE-001_scope_document_types.md) | P0 | 3 days | Q-001 to Q-006 | ⬜ Not Started |
| 002 | [Document Creation Strategy](SPIKE-002_document_creation_strategy.md) | P0 | 3 days | Q-007 to Q-011 | ⬜ Not Started |
| 003 | [Open Items vs. Cleared Items](SPIKE-003_open_items_vs_cleared.md) | P0 | 3 days | Q-012 to Q-015 | ⬜ Not Started |
| 004 | [S/4HANA Data Model — ACDOCA](SPIKE-004_acdoca_data_model.md) | P0 | 3 days | Q-016 to Q-019 | ⬜ Not Started |
| 005 | [Master Data Dependencies](SPIKE-005_master_data_dependencies.md) | High | 2 days | Q-020 to Q-023 | ⬜ Not Started |
| 006 | [Scenarios & Edge Cases](SPIKE-006_scenarios_edge_cases.md) | High | 5 days | Q-024 to Q-030 | ⬜ Not Started |
| 007 | [Material Ledger & Valuation](SPIKE-007_material_ledger.md) | Medium | 2 days | Q-031 to Q-032 | ⬜ Not Started |
| 008 | [Technical Integration Points](SPIKE-008_integration_points.md) | High | 3 days | Q-033 to Q-036 | ⬜ Not Started |
| 009 | [Reconciliation & Validation](SPIKE-009_reconciliation_validation.md) | P0 | 2 days | Q-037 to Q-038 | ⬜ Not Started |
| 010 | [Operational & Cutover](SPIKE-010_operational_cutover.md) | High | 3 days | Q-039 to Q-042 | ⬜ Not Started |
| 011 | [Clean Core & Compliance](SPIKE-011_clean_core_compliance.md) | P0 | 2 days | Q-043 to Q-044 | ⬜ Not Started |
| 012 | [Risk & Edge Cases](SPIKE-012_risk_edge_cases.md) | High | 3 days | Q-045 to Q-048 | ⬜ Not Started |
| 013 | [Country-Specific Requirements](SPIKE-013_country_specific.md) | High | 3 days | Q-049 to Q-050 | ⬜ Not Started |

## Total Effort Estimate

| Priority | Spikes | Total Timebox |
|----------|--------|---------------|
| P0 (Blocking) | 5 | 13 days |
| High | 6 | 20 days |
| Medium | 1 | 2 days |
| **TOTAL** | **13** | **35 days** |

> **Note**: Spikes can run in parallel if assigned to different consultants. Critical path = P0 Spikes (13 days if sequential, less if parallelized).

## Instructions for FI Consultants

For each question in each Spike, please provide:
1. **Answer** — clear, unambiguous response
2. **Justification** — why (business rule, SAP standard, customer requirement)
3. **Evidence** — SAP Note, transaction, config path, or documentation reference

Fill the Answer Template at the bottom of each Spike file.
