# Time Estimate - Load of 1,000 Documents per Process

## Scope

Time estimate to create **1,000 documents** in each process below, using:
- **BAPIs** (custom integration)
- **SAP S/4HANA Migration Cockpit** (LTMC / Migrate Your Data)

Covered processes:
1. Accounts Payable
2. Accounts Receivable
3. Work Orders
4. GL
5. Sales Orders
6. Purchase Orders
7. Production Orders

---

## Estimation Assumptions

- Stable environment (no severe CPU, database, or table lock bottleneck).
- Cleansed and consistent source data (no quality rework).
- Standard commit strategy per document/small batch.
- No extreme parallelism (typical project operating mode).
- Mandatory fields mapped according to the baseline mandatory-fields document.

> Important: the times below represent **technical processing time** for the load.
> They do not include development time, initial mapping, UAT cycles, functional approval, or data correction.

---

## Estimate by Process (1,000 documents)

| Process | BAPI (range) | Migration Cockpit (range) | Complexity Note |
|---|---:|---:|---|
| Accounts Payable | 10 to 20 min | 33 to 83 min | FI with tax and due-date validations |
| Accounts Receivable | 10 to 20 min | 33 to 83 min | Similar to AP with dunning/partner rules |
| Work Orders (PM/CS) | 25 to 67 min | 67 to 167 min | Order + operations + possible components |
| GL | 7 to 17 min | 25 to 67 min | High volume, simple structure, balancing checks |
| Sales Orders | 20 to 50 min | 50 to 133 min | Partners, items, schedule lines, pricing |
| Purchase Orders | 25 to 58 min | 67 to 150 min | Items, schedules, account assignment |
| Production Orders | 33 to 83 min | 100 to 200 min | BOM/routing and planning rules |

---

## Consolidated Summary (7,000 documents total)

Scenario: 1,000 documents for each of the 7 processes.

- **Via BAPI (total):** approximately **2h10min to 5h15min**
- **Via Migration Cockpit (total):** approximately **6h15min to 14h43min**

---

## Planning Recommendation (Project)

For realistic planning, consider three layers:

1. **Technical load time** (table above)
2. **Operational overhead per wave** (monitoring, reprocessing, validation): +20% to +40%
3. **Risk buffer** (locks, timeout, customizing adjustments): +15% to +30%

Practical rule:
- **BAPI:** multiply by **1.4 to 1.7** for a realistic execution window.
- **Migration Cockpit:** multiply by **1.5 to 1.8** for a realistic execution window.

---

## Realistic Cutover Window (Example)

Total for all processes (7,000 docs):

- **BAPI:**
  - Base: 2h10 to 5h15
  - With operational factor (1.4 to 1.7): **~3h to ~9h**

- **Migration Cockpit:**
  - Base: 6h15 to 14h43
  - With operational factor (1.5 to 1.8): **~9h to ~26h**

---

## Main Time Drivers

- Number of errors per batch (`RETURN` messages of type E/A)
- Customizing dependencies (partner determination, account assignment, tax)
- S/4 derivation rules (`PRCTR`, `SEGMENT`, BP)
- Commit strategy and batch size
- Allowed parallelization by object/process
- Application server, database, and network performance

---

## Recommended Next Step

Run a **pilot with 100 documents per process** and recalibrate real client throughput rates to convert this estimate into a cutover baseline.