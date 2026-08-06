# SPIKE-013: Country-Specific Requirements

## Spike Summary

| Field | Value |
|-------|-------|
| **Type** | Spike (Technical Investigation) |
| **Priority** | High |
| **Timebox** | 3 days |
| **Assignee** | FI Consultant Team |
| **Labels** | `spike`, `fi-specification`, `localization`, `country-specific` |

## Dependencies

| Dependency | Link | Relationship |
|-----------|------|--------------|
| GL Historic Transaction Loading | [RDG-1592](../RDG-1592.md) | Blocks — country fields affect GL posting |
| AP Historic Transaction Loading | [RDG-1593](../RDG-1593.md) | Blocks — country fields critical for AP (tax, e-invoice) |
| AR Historic Transaction Loading | [RDG-1594](../RDG-1594.md) | Blocks — country fields critical for AR (tax, e-invoice) |
| Validation & Reconciliation Framework | [RDG-1590](../RDG-1590.md) | Informs — country-specific validations in reconciliation |
| Implementation Guide & Delivery Enablement | [RDG-1591](../RDG-1591.md) | Blocks — guides must specify supported countries |

## Objective

Define which countries the product supports in v1, which country-specific fields must be populated, and how to prevent electronic invoicing triggers from historic postings.

## Expected Output

- Supported countries list for v1
- Country-specific field requirements per country
- E-invoicing bypass strategy per country
- Multi-country customer handling approach

---

## Questions

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

## Answer Template

| Question | Answer | Justification | Evidence | Answered By | Date |
|----------|--------|---------------|----------|-------------|------|
| Q-049 | | | | | |
| Q-050 | | | | | |
