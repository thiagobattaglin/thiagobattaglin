# High-Volume SAP Business Object Loader - Implementation Plan

## 1. Objective

Deliver a production-ready loading path from SKP to SAP for high-volume business objects, starting with sales orders and `BAPI_SALESORDER_CREATEFROMDAT2`.

The first implementation must prove:

- bulk replication into typed SAP staging tables without HTTP or RFC business payloads;
- atomic publication of complete, immutable processing packages;
- one SAP transaction per sales order;
- idempotent retries without duplicate SAP documents;
- bounded parallel execution based on measured SAP capacity;
- end-to-end correlation, reconciliation, and auditability.

The architecture must provide an object-independent core from the first release. Sales order is the first typed adapter used to validate that core; additional object adapters are onboarded only after the pilot meets its correctness and performance gates.

## 2. Context Assumptions

- SAP target: S/4HANA On-Premise 2022, ABAP Platform 2022.
- Initial business object: sales order.
- SAP business API: `BAPI_SALESORDER_CREATEFROMDAT2`.
- Primary data transport: bulk database replication from the migration working database into dedicated typed staging tables in SAP.
- External replication: Syniti Replicate or the product represented by the replication chain in the architecture diagram.
- HTTP/RAP is a control and status channel only; it does not carry the high-volume business payload or wait for BAPI processing.
- Processing packages and object work items are persisted in SAP before workers start.
- Commit and rollback scope is one business object, not one package or worker.
- The first release supports create-only processing. Change and cancel scenarios require separate contracts.

## 3. Decisions Required Before Build

| ID | Decision | Owner | Evidence required | Target phase |
| --- | --- | --- | --- | --- |
| D01 | Confirm the exact replication product, supported SAP target mechanism, throughput, consistency guarantees, and retry semantics | Integration / Basis | Connector documentation and a bulk replication spike | Discovery |
| D02 | Approve the sales-order field scope and source-to-BAPI mapping, including X structures | Functional SD / Data | Signed mapping workbook | Discovery |
| D03 | Define the immutable `SOURCE_OBJECT_ID`, `RUN_ID`, `PACKAGE_ID` (`ZCHUNK` if retained), `ATTEMPT_NO`, and `DATA_HASH` formats | Architecture / Data | Contract specification and examples | Discovery |
| D04 | Select the idempotency authority: SAP ledger, deterministic external reference, or both | Architecture / SAP | Duplicate and timeout recovery scenarios | Discovery |
| D05 | Confirm the authorization model for replication, control API, background processing, and business-object creation | Security / Basis | Role design and authorization trace | Pilot |
| D06 | Set initial package weight, queue depth, worker count, work-process, and database limits | Basis / Performance | Baseline measurements | Benchmark |
| D07 | Decide whether rejected objects allow other objects in the same package to continue | Business / Operations | Operational recovery policy | Discovery |
| D08 | Define retention and masking rules for staging payloads and SAP messages | Security / Operations | Data-classification decision | Pilot |
| D09 | Define the cross-table publication protocol that makes a package `READY` only after all rows, counts, and hashes are complete | Architecture / Data | Failure-injection test during replication | Discovery |
| D10 | Select the durable worker runtime and restart mechanism for S/4HANA 2022 | SAP / Basis | Restart, cancellation, and failover spike | Discovery |

## 4. Proposed End-to-End Contract

### 4.1 Package publication manifest

Each replicated package must have one manifest containing at least:

- `RUN_ID`
- `PACKAGE_ID` (`ZCHUNK` if retained for compatibility)
- `OBJECT_TYPE`
- `CONTRACT_VERSION`
- `ATTEMPT_NO`
- expected count for each collection
- aggregate payload hash
- creation timestamp

Business rows are replicated first. The manifest may transition to `READY` only after all expected tables, row counts, relationship checks, and hashes are complete. Workers must ignore packages in any pre-publication state. A retry reuses the same package identity and payload hash.

### 4.2 Typed SAP staging tables

Each object type has a versioned typed staging contract. The first sales-order contract should use separate tables for:

- headers;
- items;
- schedules;
- partners;
- conditions;
- texts, if they are in the approved pilot scope;
- object results;
- structured messages.

Every child row must carry enough correlation fields to resolve its header and parent item without relying on row order.

The worker receives only a package key plus object IDs or a small key range. It reads the complete object directly from SAP staging; no JSON or business collection is serialized between dispatcher and worker.

### 4.3 Control and status API

RAP OData V4 may expose metadata, package activation, pause, resume, status, error details, selective retry, and reconciliation. These operations must be short transactions. The API must never create or wait for the full worker pool inside the HTTP request.

### 4.4 Result semantics

Return exactly one result row per `SOURCE_OBJECT_ID`, plus zero or more message rows. Proposed terminal object statuses:

- `SUCCESS`
- `FAILED_VALIDATION`
- `FAILED_BUSINESS_API`
- `ALREADY_PROCESSED`
- `TECHNICAL_ERROR`

The package status is derived from object results and must not hide partial success.

## 5. SAP Artifact Plan

Names below are working names and must be aligned with the customer namespace and package conventions before creation.

| Artifact | Responsibility |
| --- | --- |
| Typed staging tables | Persist complete object data, package identity, source keys, version, and processing state |
| Run, package, queue, result, and message tables | Provide durable orchestration, leasing, restart, and auditability |
| RAP OData V4 control service | Expose metadata, trigger, status, retry, and reconciliation without transporting the bulk payload |
| Durable dispatcher | Lease only published packages, enforce backpressure, and assign object keys to workers |
| Worker entry point | Accept only persisted keys or small ranges and read complete objects from staging |
| Generic loader application class | Validate persisted contracts, dispatch complete objects, coordinate idempotency, and collect results |
| Object-adapter interface and registry | Resolve the typed implementation for `OBJECT_TYPE` and `CONTRACT_VERSION` |
| Sales-order adapter class | Isolate `BAPI_SALESORDER_CREATEFROMDAT2` mapping and invocation |
| Transaction adapter | Encapsulate commit and rollback so orchestration can be unit tested |
| Idempotency repository | Atomically claim an object identity and persist final SAP keys and payload hashes |
| Application Log integration | Persist operational diagnostics using an approved logging API |
| Authorization check | Restrict execution by object type or loader activity |
| ABAP Unit test include | Test grouping, validation, mapping, BAPI result interpretation, and retry decisions |

Standard BAPIs may be appropriate for the stated on-premise target. Each object adapter must document whether it uses a BAPI or released API and its transaction semantics. A cloud deployment requires a separate released-API assessment.

## 6. Replication and SKP Artifact Plan

| Artifact | Responsibility |
| --- | --- |
| Source package builder | Group complete objects using weighted limits and propagate package identity to all child rows |
| Replication mappings | Bulk load typed SAP staging tables without JSON materialization in ABAP |
| Publication step | Write or activate the manifest only after all package data is complete |
| Integrity validation | Reject or quarantine orphans, duplicates, count mismatches, and cross-package relationships |
| Control integration | Call only short trigger, status, retry, and reconciliation operations |
| Reconciliation queries | Compare source, replicated, published, claimed, successful, failed, and SAP-created totals |

## 7. Delivery Phases

### Phase 0 - Discovery and contract freeze

Deliverables:

- confirmed replication path, platform, and connector capabilities;
- approved minimum sales-order field mapping;
- representative data profiles, including maximum object cardinalities;
- idempotency and timeout-recovery design;
- versioned staging and control contract specification;
- security, retention, and operational decisions;
- non-functional targets for throughput, failure rate, and recovery time.

Exit criteria:

- all decisions D01-D04, D07, D09, and D10 are closed;
- a complete sample package can be represented without ambiguous relationships;
- expected throughput and SAP maintenance-window constraints are documented.

### Phase 1 - Generic core and thin vertical pilot

Scope:

- one sales-order scenario with header, items, schedules, and partners;
- object-independent manifest, dispatch, idempotency, result, and message services;
- one versioned sales-order adapter registered against the generic core;
- one small replicated and atomically published package;
- asynchronous processing fully detached from the control request;
- one commit or rollback per order;
- structured results and messages;
- SAP-side idempotency protection.

Exit criteria:

- valid orders are created and correlated to their source identities;
- one invalid order does not roll back successful siblings in the package;
- replaying the same package or source rows creates no duplicates;
- an interrupted replication never exposes a partial package as `READY`;
- a simulated worker termination after SAP commit can be reconciled safely;
- ABAP Unit and integration tests pass.

### Phase 2 - Correctness and recovery hardening

Deliverables:

- full relationship and count validation;
- hash mismatch rejection;
- lease expiry and retry handling;
- stale in-process claim recovery;
- queue backpressure, pause, resume, and emergency-stop controls;
- structured application logging;
- authorization and input-limit enforcement;
- restart and reconciliation runbook.

Exit criteria:

- all failure scenarios in section 9 have deterministic outcomes;
- operators can identify and safely retry an individual object or package;
- no business payload is logged outside approved retention rules.

### Phase 3 - Performance benchmark

Run a controlled matrix using representative object complexity, not only order count:

| Dimension | Initial values |
| --- | --- |
| Objects per worker claim | 1, 10, 25, 50, then measured increments |
| Concurrent workers | 1, 2, 4, 8, then capacity-approved increments |
| Replication package size | Sized by rows and bytes; test representative and maximum packages |
| Complexity | small, median, P95, and maximum supported object |
| Outcome mix | all success, functional errors, and mixed results |

Capture:

- orders, items, and schedule lines per minute;
- replication rows and bytes per second;
- publication delay and queue wait time;
- p50, p95, and p99 object and package duration;
- staging-table growth and database write/read volume;
- ABAP memory high-water mark;
- work-process utilization according to the selected durable worker runtime;
- database time, lock wait time, update-task time, and commit time;
- retry and duplicate-prevention counts.

Exit criteria:

- a safe operating envelope is approved by Basis;
- package weight, claim size, and concurrency defaults are based on measurements;
- peak memory, database load, lock contention, and work-process headroom remain within agreed thresholds;
- a sustained-volume soak test passes without throughput degradation or duplicate creation.

### Phase 4 - Production readiness

Deliverables:

- monitoring dashboard and alerts;
- support and restart runbooks;
- transport sequence and rollback plan;
- technical-user role approval;
- retention and purge jobs;
- production readiness review;
- controlled first-load and hypercare plan.

Exit criteria:

- reconciliation is signed off by business and data owners;
- operational ownership and escalation paths are assigned;
- production concurrency limits and emergency stop controls are configured.

### Phase 5 - Framework validation and expansion

Only after the sales-order path is stable:

- validate that manifest, result, message, lease, logging, dispatch, and idempotency components remain object-independent;
- onboard one second object type to prove reuse;
- version contracts independently by object type;
- document migration steps for contract changes.

## 8. Idempotency and Transaction Design

The object identity should be the tuple `OBJECT_TYPE + SOURCE_OBJECT_ID`, with `DATA_HASH` used to detect payload mutation. `RUN_ID` and `ATTEMPT_NO` describe execution history, not business uniqueness.

Before calling the business API, a worker must atomically claim the object identity. The behavior should be:

| Existing state | Incoming hash | Action |
| --- | --- | --- |
| none | any | claim and process |
| success | same | return the stored SAP key as `ALREADY_PROCESSED` |
| success | different | reject as a conflicting payload |
| failed | same | allow retry according to policy |
| in process | same | reject or defer until the claim expires |

For each business object, using the sales order in the pilot:

1. Validate and claim the source identity.
2. Build all BAPI and X structures.
3. Call the object-specific BAPI or released API.
4. Treat `A`, `E`, and approved business-specific message patterns as failure.
5. Roll back on failure; commit with wait on success.
6. Persist the terminal result and SAP key consistently with the idempotency design.

The crash window between SAP commit and result persistence must be resolved explicitly. A deterministic reference stored on the business object, or another SAP-side reconciliation key, is strongly preferred so an uncertain outcome can be looked up instead of blindly retried. A package or worker-level batch commit is not the default because it expands rollback scope and makes object-level recovery ambiguous.

## 9. Minimum Test Scenarios

### ABAP Unit

- grouping unordered flat rows into independent sales orders;
- missing header, orphan item, orphan schedule, and cross-object child;
- duplicate item and schedule keys;
- mandatory-field and contract-version validation;
- complete construction of BAPI X structures;
- interpretation of success, warning, error, and abort messages;
- commit for success and rollback for failure;
- same-key same-hash replay and same-key different-hash conflict;
- maximum configured rows and payload limits.

### Integration

- mixed valid and invalid orders in one package;
- duplicate source rows and duplicate manifest publication;
- replication interruption before data completion and before manifest publication;
- control API timeout before and after trigger acceptance;
- worker termination and expired lease recovery;
- malformed counts and payload hash mismatch;
- unavailable worker capacity and queue backpressure;
- authorization failure;
- result-write failure on the SKP side;
- concurrent submission of the same `SOURCE_OBJECT_ID`;
- reconciliation from source record through generated SAP document.

### Performance

- baseline with one worker;
- replication package and worker-claim-size matrix;
- concurrency ramp until the first constrained resource is identified;
- P95-complexity and maximum-supported orders;
- mixed-error workload;
- sustained soak test for the expected production window;
- controlled stop, restart, and backlog drain.

## 10. Initial Backlog

| Priority | Work item | Main owner | Dependency |
| --- | --- | --- | --- |
| 1 | Run a bulk replication spike into dedicated SAP staging tables | Integration / SAP / Basis | D01 |
| 2 | Profile source sales orders by items, schedules, partners, conditions, and payload size | Data | Source access |
| 3 | Produce and approve the minimum sales-order field mapping | Functional SD / Data / SAP | D02 |
| 4 | Write the version 1 publication manifest, state machine, and correlation-key specification | Architecture | D03 and D09 |
| 5 | Design the SAP idempotency ledger and uncertain-commit recovery | SAP / Architecture | D04 |
| 6 | Define typed SAP staging, queue, result, and message tables for contract version 1 | SAP | Items 2-5 |
| 7 | Implement source package building, replication mappings, publication, and integrity checks | Data / Integration | Items 1, 2, and 4 |
| 8 | Implement the durable dispatcher, bounded worker pool, generic loader core, sales-order adapter, and unit tests | SAP | D10 and Items 3, 5, and 6 |
| 9 | Implement the RAP control/status service and end-to-end pilot | SAP / Integration | Items 6-8 |
| 10 | Execute correctness, recovery, and benchmark matrices | QA / Basis / Team | Pilot complete |

## 11. First Planning Workshop

Required participants:

- SAP SD functional owner;
- ABAP lead;
- SKP data-model or SQL lead;
- Replicate integration lead;
- SAP Basis and security;
- operations and reconciliation owner.

Required inputs:

- current sales-order mapping or sample extracts;
- representative small, median, P95, and maximum-complexity objects;
- replication connector and SAP target documentation;
- SAP system capacity and batch-window constraints;
- duplicate-handling business policy;
- target throughput and permitted error rate.

Expected outputs:

- closed decisions D01-D04 and D07, or named owners and deadlines;
- pilot scope and exclusions;
- contract version 1 draft;
- benchmark success thresholds;
- owners and estimates for the first ten backlog items.

## 12. Key Risks

| Risk | Mitigation |
| --- | --- |
| Duplicate creation after an uncertain worker outcome | SAP-side claim plus a searchable deterministic reference and reconciliation flow |
| Replication or staging overwhelms the SAP database | Rate limits, partition-aware package sizing, retention, purge, and database monitoring |
| Partial or cross-package object data becomes visible | Data-first publication, manifest counts, immutable membership, hashes, and validation before `READY` |
| SAP saturation from independent parallel controls | One approved concurrency budget, monitored resource thresholds, and an emergency stop |
| Generic framework delays the first usable loader | Keep the core limited to shared envelope, dispatch, idempotency, results, and logging; prove it through one vertical sales-order adapter |
| Dispatcher or worker-runtime failure loses work | Persistent queue state, leases, heartbeats, expiry recovery, and a durable scheduler |
| Contract drift between SKP, replication, and SAP | Explicit contract versions, compatibility rules, and immutable published packages |
| Sensitive data exposed in logs or result tables | Field classification, masking, restricted authorization, and retention policies |
