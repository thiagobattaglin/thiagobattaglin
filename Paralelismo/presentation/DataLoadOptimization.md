---
marp: true
theme: default
paginate: false
style: |
  section {
    font-family: 'Segoe UI', Arial, sans-serif;
    background: #ffffff;
    color: #1a1a2e;
    padding: 60px 80px;
    display: flex;
    flex-direction: column;
    justify-content: center;
  }

  /* ── TITLE SLIDE ── */
  section.title {
    background: #0f3460;
    color: #ffffff;
    text-align: center;
    align-items: center;
  }
  section.title h1 {
    font-size: 52px;
    color: #ffffff;
    margin: 0 0 12px 0;
    line-height: 1.2;
  }
  section.title .sub {
    font-size: 22px;
    color: #aaccee;
    margin-top: 8px;
  }
  section.title .meta {
    font-size: 17px;
    color: #7799bb;
    margin-top: 40px;
    border-top: 1px solid #2255aa;
    padding-top: 20px;
    width: 100%;
  }

  /* ── SLIDE HEADER BAR ── */
  section h1 {
    font-size: 32px;
    color: #ffffff;
    background: #0f3460;
    margin: -60px -80px 36px -80px;
    padding: 22px 80px;
    letter-spacing: 0.3px;
  }

  /* ── KICKER NUMBER (big stat) ── */
  .kicker {
    font-size: 96px;
    font-weight: 800;
    color: #e94560;
    line-height: 1;
    margin: 0;
  }
  .kicker-label {
    font-size: 20px;
    color: #555;
    margin-top: 4px;
    margin-bottom: 28px;
  }

  /* ── TWO-COLUMN ── */
  .cols { display: flex; gap: 48px; align-items: flex-start; }
  .col  { flex: 1; }

  /* ── TABLE ── */
  table { width: 100%; border-collapse: collapse; font-size: 19px; margin-top: 8px; }
  th { background: #0f3460; color: #fff; padding: 10px 16px; text-align: left; font-weight: 600; }
  td { padding: 9px 16px; border-bottom: 1px solid #e8e8e8; vertical-align: middle; }
  tr:nth-child(even) td { background: #f5f8fc; }
  tr.total td { background: #0f3460; color: #fff; font-weight: 700; }
  tr.highlight td { background: #fff3cd; font-weight: 600; }

  /* ── BAR CHART (CSS only) ── */
  .bar-wrap { margin-top: 12px; }
  .bar-row   { display: flex; align-items: center; margin-bottom: 10px; font-size: 18px; }
  .bar-label { width: 220px; flex-shrink: 0; color: #333; }
  .bar-fill  { height: 28px; background: #0f3460; border-radius: 3px; display: flex; align-items: center; padding-left: 10px; color: #fff; font-size: 16px; font-weight: 600; min-width: 30px; }
  .bar-fill.red  { background: #e94560; }
  .bar-fill.grn  { background: #38a169; }
  .bar-fill.gray { background: #b0b8c8; }
  .bar-val   { margin-left: 10px; color: #555; font-size: 16px; }

  /* ── CALLOUT BOX ── */
  .callout {
    background: #f0f6ff;
    border-left: 6px solid #0f3460;
    padding: 16px 24px;
    border-radius: 0 8px 8px 0;
    font-size: 20px;
    margin-top: 20px;
    color: #1a1a2e;
  }
  .callout.warn { background: #fff8f0; border-color: #e94560; }
  .callout.good { background: #f0fff6; border-color: #38a169; }

  /* ── PHASE BOXES ── */
  .phases { display: flex; gap: 24px; margin-top: 16px; }
  .phase-box {
    flex: 1;
    border-radius: 10px;
    padding: 20px 24px;
    font-size: 18px;
  }
  .phase-box h3 { margin: 0 0 10px 0; font-size: 20px; }
  .phase-box ul { margin: 0; padding-left: 18px; }
  .phase-box li { margin-bottom: 6px; }
  .ph1 { background: #e8f4fd; border-top: 5px solid #0f3460; }
  .ph2 { background: #fef9e7; border-top: 5px solid #f0a500; }
  .ph3 { background: #eafaf1; border-top: 5px solid #38a169; }

  strong { color: #0f3460; }
  em     { color: #e94560; font-style: normal; font-weight: 600; }
---

<!-- _class: title -->

# SAP S/4HANA — Data Load Optimization
<p class="sub">Syniti Surge · ConcentoRDG · RI-941</p>
<p class="meta">Thiago Battaglin &nbsp;|&nbsp; August 2026</p>

---

# Slide 1 — What Is the Current Problem?

<div class="cols">
<div class="col">

<p class="kicker">186h</p>
<p class="kicker-label">Total cutover data load window — 7 objects</p>

All objects run **sequentially**, **single-threaded**, with **one commit per record**.  
Business validations and custom BAdIs **fire on every record** — including logic designed for day-to-day operations, not migration.

<div class="callout warn">
  At 72.7 million records, sequential processing means <em>millions of unnecessary round-trips</em> to the database during the cutover window.
</div>

</div>
<div class="col">

| Object | Method | Hours |
|---|---|---:|
| Open Production Order | LSMW multipart | **60 h** |
| Material Equipment | LSMW / IDoc | **40 h** |
| Open PO Conversion | LSMW / IDoc | **30 h** |
| Inventory EWM | T-Code `/SCWM/ISU` | **24 h** |
| Open Purchase Orders | LSMW / IDoc | **12 h** |
| Vendor Open Items | LSMW / IDoc | **10 h** |
| Maintenance Work Order | Migration Cockpit | **10 h** |
| **TOTAL** | | **186 h** |

</div>
</div>

---

# Slide 2 — Where Do We Have Opportunities for Gains?

<div class="cols">
<div class="col">

| Object | Current | Savings | Result |
|---|---:|:---:|---:|
| Material Equipment | 40 h | **60%** | 10–20 h |
| Vendor Open Items | 10 h | **60%** | 3–5 h |
| Open PO Conversion | 30 h | **50%** | 12–18 h |
| Open Purchase Orders | 12 h | **50%** | 5–7 h |
| Open Production Order | 60 h | 30% | 36–48 h |
| Maintenance Work Order | 10 h | 15% | 8–9 h |
| Inventory EWM ★ | 24 h | Plan B | 6–14 h |
| **TOTAL** | **186 h** | | **94–131 h** |

<div class="callout good" style="margin-top:16px; font-size:18px;">
  ★ EWM gain comes from <strong>disabling BAdIs during load</strong>, not replacing the t-code.<br>No SAP involvement needed — Plan B is already defined.
</div>

</div>
<div class="col">

**Savings distribution** (conservative ~55h):

<div class="bar-wrap">
  <div class="bar-row"><span class="bar-label">Material Equipment</span><div class="bar-fill" style="width:180px">36%</div><span class="bar-val">20–30h</span></div>
  <div class="bar-row"><span class="bar-label">Open PO Conversion</span><div class="bar-fill" style="width:110px">22%</div><span class="bar-val">12–18h</span></div>
  <div class="bar-row"><span class="bar-label">Open Prod. Order</span><div class="bar-fill" style="width:110px">22%</div><span class="bar-val">12–24h</span></div>
  <div class="bar-row"><span class="bar-label">Open Purch. Orders</span><div class="bar-fill" style="width:44px; background:#3182ce">9%</div><span class="bar-val">5–7h</span></div>
  <div class="bar-row"><span class="bar-label">Vendor Open Items</span><div class="bar-fill" style="width:44px; background:#3182ce">9%</div><span class="bar-val">5–7h</span></div>
  <div class="bar-row"><span class="bar-label">Maint. Work Order</span><div class="bar-fill gray" style="width:10px">&nbsp;</div><span class="bar-val">2%</span></div>
</div>

<div class="callout" style="margin-top:20px; font-size:18px;">
  <strong>Top priority (≥50% savings):</strong> Material Equipment, Vendor Open Items, Open PO Conversion, Open Purchase Orders
</div>

</div>
</div>

---

# Slide 3 — How Will We Achieve the Gains?

<div class="cols" style="gap:32px">
<div class="col" style="flex:1.1">

**Replace LSMW with BAPI + Parallelism + Package Commit**

Instead of one commit per record, we process **batches of 100–500 records in parallel tasks** — each task commits independently, with full error logging per package.

| Before | After |
|---|---|
| 1 commit / record | 1 commit / 500 records |
| 1 thread | Up to 20 parallel tasks |
| BAdIs always on | BAdIs **off** during load window |

<div class="callout good" style="font-size:17px; margin-top:16px;">
  <strong>Zero-code quick win:</strong> Disabling BAdIs during the cutover window applies to <em>all objects immediately</em> and is the single highest-impact action available today.
</div>

</div>
<div class="col" style="flex:0.9">

<div class="phases">
<div class="phase-box ph1">
<h3>Phase 1 — Sprint 1–2</h3>
<ul>
  <li>Material Equipment → <strong>−20–30h</strong></li>
  <li>Vendor Open Items → <strong>−5–7h</strong></li>
  <li>Open PO Conversion → <strong>−12–18h</strong></li>
  <li>Open Purchase Orders → <strong>−5–7h</strong></li>
</ul>
</div>
</div>

<div class="phases" style="margin-top:12px">
<div class="phase-box ph2">
<h3>Phase 2 — Sprint 3</h3>
<ul>
  <li>Open Production Order → POC to validate gain potential</li>
</ul>
</div>
</div>

<div class="phases" style="margin-top:12px">
<div class="phase-box ph3">
<h3>Phase 3 — Keep As-Is</h3>
<ul>
  <li>Maintenance Work Order → Migration Cockpit</li>
  <li>Inventory EWM → BAdI Plan B (24h → 6–14h)</li>
</ul>
</div>
</div>

<div class="callout" style="margin-top:16px; font-size:17px; text-align:center;">
  <em>186h → 94–131h</em> &nbsp;·&nbsp; <strong>30–50% reduction</strong>
</div>

</div>
</div>
