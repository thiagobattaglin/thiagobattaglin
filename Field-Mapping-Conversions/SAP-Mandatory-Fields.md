# SAP Mandatory Fields Reference

## Document Control

| Item | Value |
|---|---|
| Document Title | SAP Mandatory Fields by Process |
| Scope | ECC and S/4HANA data migration and posting interfaces |
| Audience | Functional consultants, migration teams, ABAP developers, data owners |
| Source Interfaces | BAPIs and SAP S/4HANA Migration Cockpit objects |
| Last Updated | 2026-08-10 |

---

## Executive Summary

This document defines the mandatory field sets for seven core SAP processes, mapped to:
- Technical posting interfaces (BAPIs)
- Migration Cockpit objects (LTMC / Migrate Your Data)

In this document, mandatory means required for successful posting under standard validation. Additional fields can become mandatory due to customizing, account determination, document type logic, partner determination, or localization rules.

---

## Process Coverage Matrix

| Process | Primary BAPI | Migration Cockpit Object (S/4HANA) | Primary Tables |
|---|---|---|---|
| Accounts Payable | `BAPI_ACC_DOCUMENT_POST` | Open items - Accounts Payable | `BKPF`, `BSEG`, `BSIK` |
| Accounts Receivable | `BAPI_ACC_DOCUMENT_POST` | Open items - Accounts Receivable | `BKPF`, `BSEG`, `BSID` |
| Work Orders (PM/CS) | `BAPI_ALM_ORDER_MAINTAIN` | Maintenance Order / Service Order | `AUFK`, `AFKO`, `AFVC`, `AFVV`, `RESB` |
| General Ledger | `BAPI_ACC_DOCUMENT_POST`, `BAPI_ACC_GL_POSTING_POST` | G/L account balances, Open and cleared postings | `BKPF`, `BSEG`, `FAGLFLEXA` |
| Sales Orders | `BAPI_SALESORDER_CREATEFROMDAT2` | Customer sales order | `VBAK`, `VBAP`, `VBKD`, `VBPA`, `VBEP` |
| Purchase Orders | `BAPI_PO_CREATE1` | Purchase Order | `EKKO`, `EKPO`, `EKET`, `EKKN` |
| Production Orders | `BAPI_PRODORD_CREATE` | Production Order | `AUFK`, `AFKO`, `AFPO`, `AFVC`, `AFVV`, `RESB` |

---

## 1. Accounts Payable (Vendor Open Items)

### 1.1 Interface Definition

| Item | Value |
|---|---|
| BAPI | `BAPI_ACC_DOCUMENT_POST` |
| Migration Object | FI - Open items in accounts payable accounting |
| Mandatory Posting Context | Vendor line + balancing G/L line + currency amounts |

### 1.2 Mandatory Header Fields (DOCUMENTHEADER)

| Field | Requirement | Notes |
|---|---|---|
| `BUS_ACT` | Mandatory | Usually `RFBU` |
| `USERNAME` | Mandatory | Posting user |
| `COMP_CODE` | Mandatory | Company code |
| `DOC_DATE` | Mandatory | Document date |
| `PSTNG_DATE` | Mandatory | Posting date |
| `DOC_TYPE` | Mandatory | E.g. `KR`, `KN` |
| `REF_DOC_NO` | Mandatory in most AP scenarios | Vendor invoice reference |
| `HEADER_TXT` | Recommended | Operational traceability |

### 1.3 Mandatory Line Fields

#### Vendor Line (ACCOUNTPAYABLE)

| Field | Requirement | Notes |
|---|---|---|
| `ITEMNO_ACC` | Mandatory | Item key |
| `VENDOR_NO` | Mandatory | `LIFNR` |
| `COMP_CODE` | Mandatory | Company code |
| `PMNTTRMS` | Mandatory in open-item scenarios | `ZTERM` |
| `BLINE_DATE` | Mandatory in due-date managed scenarios | `ZFBDT` |
| `SP_GL_IND` | Conditional | Mandatory for special G/L postings |

#### G/L Line (ACCOUNTGL)

| Field | Requirement | Notes |
|---|---|---|
| `ITEMNO_ACC` | Mandatory | Item key |
| `GL_ACCOUNT` | Mandatory | Offset account |
| `COMP_CODE` | Mandatory | Company code |
| `COSTCENTER` / `WBS_ELEM` / `ORDERID` | Conditional | Based on account assignment rules |
| `PROFIT_CTR` | Mandatory in S/4 in many ledgers | Depending on derivation setup |

#### Amounts (CURRENCYAMOUNT)

| Field | Requirement | Notes |
|---|---|---|
| `ITEMNO_ACC` | Mandatory | Item key |
| `CURRENCY` | Mandatory | Document currency |
| `AMT_DOCCUR` | Mandatory | Signed amount |
| `AMT_BASE` | Conditional | If tax base is required |
| `TAX_AMT` | Conditional | If tax posting applies |

### 1.4 Conditional Tax Fields (ACCOUNTTAX)

| Field | Requirement | Notes |
|---|---|---|
| `ITEMNO_ACC` | Conditional | Required when tax lines exist |
| `GL_ACCOUNT` | Conditional | Tax account |
| `TAX_CODE` | Conditional | `MWSKZ` |
| `COND_KEY` | Conditional | Pricing/tax condition key |

---

## 2. Accounts Receivable (Customer Open Items)

### 2.1 Interface Definition

| Item | Value |
|---|---|
| BAPI | `BAPI_ACC_DOCUMENT_POST` |
| Migration Object | FI - Open items in accounts receivable accounting |
| Mandatory Posting Context | Customer line + balancing G/L line + currency amounts |

### 2.2 Mandatory Header Fields (DOCUMENTHEADER)

AP structure applies, with typical AR values:
- `DOC_TYPE`: e.g. `DR`, `DZ`, `DG`
- `BUS_ACT`: `RFBU`

### 2.3 Mandatory Line Fields

#### Customer Line (ACCOUNTRECEIVABLE)

| Field | Requirement | Notes |
|---|---|---|
| `ITEMNO_ACC` | Mandatory | Item key |
| `CUSTOMER` | Mandatory | `KUNNR` |
| `COMP_CODE` | Mandatory | Company code |
| `PMNTTRMS` | Mandatory in open-item scenarios | Payment terms |
| `BLINE_DATE` | Mandatory in due-date managed scenarios | Baseline date |
| `SP_GL_IND` | Conditional | Special G/L postings |
| `DUNN_KEY` / `DUNN_AREA` | Conditional | Customizing dependent |

#### G/L and Amount Lines

Same mandatory structure used in AP:
- `ACCOUNTGL`
- `CURRENCYAMOUNT`

---

## 3. Work Orders (PM/CS)

### 3.1 Interface Definition

| Item | Value |
|---|---|
| BAPI | `BAPI_ALM_ORDER_MAINTAIN` |
| Migration Object | Maintenance Order / Service Order |
| Mandatory Posting Context | Header + operations; components and partners as applicable |

### 3.2 Mandatory Order Header Fields (IT_METHODS + IT_HEADER)

| Field | Requirement | Notes |
|---|---|---|
| `ORDER_TYPE` (`AUART`) | Mandatory | E.g. `PM01`, `PM02` |
| `PLANPLANT` (`IWERK`) | Mandatory | Planning plant |
| `MN_WK_CTR` (`VAPLZ`) | Mandatory in most templates | Main work center |
| `PLANT_WORKCENTER` (`VAWRK`) | Mandatory in most templates | Work center plant |
| `PRIORITY` (`PRIOK`) | Conditional | By customizing |
| `FUNCT_LOC` (`TPLNR`) | Mandatory if no equipment | Functional location |
| `EQUIPMENT` (`EQUNR`) | Mandatory if no functional location | Equipment |
| `SHORT_TEXT` (`KTEXT`) | Mandatory | Description |
| `START_DATE` / `FINISH_DATE` | Mandatory | Basic dates |
| `MN_ORDERID` | Mandatory in create flow | Temporary external ID |

### 3.3 Mandatory Operations (IT_OPERATION)

| Field | Requirement | Notes |
|---|---|---|
| `ACTIVITY` (`VORNR`) | Mandatory | Operation number |
| `CONTROL_KEY` (`STEUS`) | Mandatory | E.g. `PM01` |
| `WORK_CNTR` (`ARBPL`) | Mandatory | Work center |
| `PLANT` (`WERKS`) | Mandatory | Plant |
| `DESCRIPTION` (`LTXA1`) | Recommended | Operation text |

### 3.4 Conditional Components and Partners

#### Components (IT_COMPONENT)

| Field | Requirement | Notes |
|---|---|---|
| `MATERIAL` (`MATNR`) | Conditional | Required if component is loaded manually |
| `REQUIREMENT_QUANTITY` (`BDMNG`) | Conditional | Component quantity |
| `ITEM_CATEGORY` (`POSTP`) | Conditional | `L`, `N`, etc. |
| `PLANT` (`WERKS`) | Conditional | Component plant |

#### Partners (IT_PARTNER)

| Field | Requirement | Notes |
|---|---|---|
| `PARTN_ROLE` | Conditional | If partner determination is active |
| `PARTNER` | Conditional | Partner number |

---

## 4. General Ledger (Accounting Documents and Opening Balances)

### 4.1 Interface Definition

| Item | Value |
|---|---|
| BAPI | `BAPI_ACC_DOCUMENT_POST`, `BAPI_ACC_GL_POSTING_POST` |
| Migration Object | G/L account balances; FI open and cleared postings |
| Mandatory Posting Context | Balanced debit/credit line items per currency and company code |

### 4.2 Mandatory Header Fields (DOCUMENTHEADER)

| Field | Requirement | Notes |
|---|---|---|
| `BUS_ACT` | Mandatory | Usually `RFBU` |
| `COMP_CODE` | Mandatory | Company code |
| `DOC_DATE` | Mandatory | Document date |
| `PSTNG_DATE` | Mandatory | Posting date |
| `DOC_TYPE` | Mandatory | Common values: `SA`, `AB` |

### 4.3 Mandatory G/L Line Fields (ACCOUNTGL)

| Field | Requirement | Notes |
|---|---|---|
| `ITEMNO_ACC` | Mandatory | Item key |
| `GL_ACCOUNT` (`HKONT`) | Mandatory | G/L account |
| `COMP_CODE` | Mandatory | Company code |
| `DE_CRE_IND` | Mandatory | Derived from amount sign |
| `COSTCENTER` (`KOSTL`) | Conditional | If account requires cost object |
| `PROFIT_CTR` (`PRCTR`) | Frequently mandatory in S/4 | Depending on derivation |
| `WBS_ELEMENT` / `ORDERID` | Conditional | Alternative CO object |
| `SEGMENT` | Conditional/frequently derived | S/4 reporting context |
| `FUNC_AREA` | Conditional | If functional area is active |

### 4.4 Mandatory Amount Fields (CURRENCYAMOUNT)

| Field | Requirement | Notes |
|---|---|---|
| `ITEMNO_ACC` | Mandatory | Item key |
| `CURRENCY` | Mandatory | Currency |
| `AMT_DOCCUR` | Mandatory | Signed amount |
| `AMT_BASE` / `TAX_AMT` | Conditional | If tax applies |

**Control rule:** debit total must equal credit total by company code and currency.

---

## 5. Sales Orders (SD)

### 5.1 Interface Definition

| Item | Value |
|---|---|
| BAPI | `BAPI_SALESORDER_CREATEFROMDAT2` |
| Migration Object | Customer sales order |
| Mandatory Posting Context | Header + required partners + item + schedule lines |

### 5.2 Mandatory Header Fields (ORDER_HEADER_IN)

| Field | Requirement | Notes |
|---|---|---|
| `DOC_TYPE` (`AUART`) | Mandatory | E.g. `OR`, `TA` |
| `SALES_ORG` (`VKORG`) | Mandatory | Sales organization |
| `DISTR_CHAN` (`VTWEG`) | Mandatory | Distribution channel |
| `DIVISION` (`SPART`) | Mandatory | Division |
| `PURCH_NO_C` (`BSTKD`) | Commonly mandatory | Customer PO |
| `REQ_DATE_H` | Commonly mandatory | Requested date |
| `PRICE_DATE` | Conditional | Pricing relevance |

### 5.3 Mandatory Partners (ORDER_PARTNERS)

| Field | Requirement | Notes |
|---|---|---|
| `PARTN_ROLE` | Mandatory | At least sold-to/ship-to per procedure |
| `PARTN_NUMB` | Mandatory | Partner number |

Minimum roles in most implementations:
- `AG` (sold-to)
- `WE` (ship-to)

### 5.4 Mandatory Item and Schedule Fields

#### Items (ORDER_ITEMS_IN)

| Field | Requirement | Notes |
|---|---|---|
| `ITM_NUMBER` (`POSNR`) | Mandatory | Item number |
| `MATERIAL` (`MATNR`) | Mandatory | Material |
| `PLANT` (`WERKS`) | Mandatory in many ATP/shipping flows | Supplying plant |
| `TARGET_QTY` (`ZMENG`) | Mandatory | Quantity |
| `TARGET_QU` (`ZIEME`) | Mandatory | Sales unit |

#### Schedule Lines (ORDER_SCHEDULES_IN)

| Field | Requirement | Notes |
|---|---|---|
| `ITM_NUMBER` | Mandatory | Item reference |
| `SCHED_LINE` (`ETENR`) | Mandatory | Schedule number |
| `REQ_QTY` (`WMENG`) | Mandatory | Requested quantity |
| `REQ_DATE` (`EDATU`) | Mandatory | Requested date |

### 5.5 Conditional Pricing Fields (ORDER_CONDITIONS_IN)

| Field | Requirement | Notes |
|---|---|---|
| `ITM_NUMBER` | Conditional | Manual pricing scenario |
| `COND_TYPE` (`KSCHL`) | Conditional | Condition type |
| `COND_VALUE` | Conditional | Condition value |
| `CURRENCY` | Conditional | Condition currency |

---

## 6. Purchase Orders (MM)

### 6.1 Interface Definition

| Item | Value |
|---|---|
| BAPI | `BAPI_PO_CREATE1` |
| Migration Object | Purchase Order |
| Mandatory Posting Context | Header + item + schedule; account assignment when applicable |

### 6.2 Mandatory Header Fields (POHEADER + POHEADERX)

| Field | Requirement | Notes |
|---|---|---|
| `DOC_TYPE` (`BSART`) | Mandatory | E.g. `NB`, `UB` |
| `VENDOR` (`LIFNR`) | Mandatory | Vendor |
| `PURCH_ORG` (`EKORG`) | Mandatory | Purchasing organization |
| `PUR_GROUP` (`EKGRP`) | Mandatory | Purchasing group |
| `COMP_CODE` (`BUKRS`) | Mandatory | Company code |
| `DOC_DATE` | Mandatory | Document date |
| `CURRENCY` (`WAERS`) | Mandatory | Currency |

### 6.3 Mandatory Item and Schedule Fields

#### Items (POITEM + POITEMX)

| Field | Requirement | Notes |
|---|---|---|
| `PO_ITEM` (`EBELP`) | Mandatory | Item number |
| `MATERIAL` (`MATNR`) or `SHORT_TEXT` | Mandatory | One of both must exist |
| `PLANT` (`WERKS`) | Mandatory | Plant |
| `QUANTITY` (`MENGE`) | Mandatory | Quantity |
| `PO_UNIT` (`MEINS`) | Mandatory | Unit |
| `NET_PRICE` (`NETPR`) | Mandatory in priced documents | Net price |
| `PRICE_UNIT` (`PEINH`) | Conditional | Price unit |
| `TAX_CODE` (`MWSKZ`) | Frequently mandatory in S/4 | Tax code |
| `ITEM_CAT` (`PSTYP`) | Mandatory | Usually `0` |
| `ACCTASSCAT` (`KNTTP`) | Conditional | Mandatory when account assignment is used |

#### Schedule Lines (POSCHEDULE + POSCHEDULEX)

| Field | Requirement | Notes |
|---|---|---|
| `PO_ITEM` | Mandatory | Item reference |
| `SCHED_LINE` (`ETENR`) | Mandatory | Schedule number |
| `DELIVERY_DATE` (`EEIND`) | Mandatory | Delivery date |
| `QUANTITY` (`MENGE`) | Mandatory | Scheduled quantity |

### 6.4 Conditional Account Assignment (POACCOUNT + POACCOUNTX)

Applies when `KNTTP <> ' '`.

| Field | Requirement | Notes |
|---|---|---|
| `PO_ITEM` | Mandatory | Item reference |
| `SERIAL_NO` | Mandatory | Distribution line index |
| `GL_ACCOUNT` (`SAKTO`) | Mandatory | G/L account |
| `COSTCENTER` / `ORDERID` / `WBS_ELEMENT` / `ASSET_NO` | Conditional | Depends on assignment category |
| `QUANTITY` / `NET_VALUE` | Conditional | Distribution details |

---

## 7. Production Orders (PP)

### 7.1 Interface Definition

| Item | Value |
|---|---|
| BAPI | `BAPI_PRODORD_CREATE` |
| Related BAPIs | `BAPI_PRODORD_RELEASE`, `BAPI_PRODORD_CHANGE_STATUS` |
| Migration Object | Production Order |
| Mandatory Posting Context | Order header and quantity context; routing/BOM resolution |

### 7.2 Mandatory Creation Fields (ORDERDATA)

| Field | Requirement | Notes |
|---|---|---|
| `ORDER_TYPE` (`AUART`) | Mandatory | E.g. `PP01` |
| `PLANNING_PLANT` (`PWERK`) | Mandatory | Planning plant |
| `PRODUCTION_PLANT` (`PWERK`) | Mandatory | Production plant |
| `MATERIAL` (`MATNR`) | Mandatory | Header material |
| `ORDER_QUANTITY` (`GAMNG`) | Mandatory | Quantity |
| `UNIT` (`GMEIN`) | Mandatory | Unit of measure |
| `START_DATE` (`GSTRP`) | Mandatory | Basic start |
| `FINISH_DATE` (`GLTRP`) | Mandatory | Basic finish |
| `BOM_USAGE` | Conditional | Required if manual BOM selection |
| `ALTERNATIVE_BOM` | Conditional | Required if multiple alternatives |
| `ROUTING_GROUP` / `GROUP_COUNTER` | Conditional | Required if manual routing selection |

### 7.3 Conditional Component and Operation Details

#### Components (when not fully derived from BOM)

| Field | Requirement | Notes |
|---|---|---|
| `MATERIAL` (`MATNR`) | Conditional | Component material |
| `REQUIREMENT_QUANTITY` (`BDMNG`) | Conditional | Quantity |
| `UNIT` (`MEINS`) | Conditional | Unit |
| `ITEM_CATEGORY` (`POSTP`) | Conditional | `L` stock / `N` non-stock |
| `PLANT` (`WERKS`) | Conditional | Plant |
| `STGE_LOC` (`LGORT`) | Conditional | Storage location |

#### Operations (when not fully derived from routing)

| Field | Requirement | Notes |
|---|---|---|
| `ACTIVITY` (`VORNR`) | Conditional | Operation number |
| `WORK_CNTR` (`ARBPL`) | Conditional | Work center |
| `PLANT` (`WERKS`) | Conditional | Plant |
| `CONTROL_KEY` (`STEUS`) | Conditional | Control key |
| `STANDARD_VALUE` | Conditional | `VGW01...VGW06` |

---

## Cross-Process Implementation Rules

### 1. Commit and Rollback Discipline

- Execute `BAPI_TRANSACTION_COMMIT` with `WAIT = 'X'` only after successful validation.
- Execute `BAPI_TRANSACTION_ROLLBACK` whenever `RETURN` contains hard errors.

### 2. Return Message Gate

- Treat `RETURN-TYPE = 'E'` or `RETURN-TYPE = 'A'` as blocking.
- Log full message class, number, variables, and payload keys.

### 3. S/4HANA Specific Controls

- Profit center and segment derivation must be validated before productive loads.
- Partner functions must satisfy determination procedures.
- Business Partner model replaces direct customer/vendor master assumptions.
- Universal Journal consistency (`ACDOCA`) must be checked for FI postings.

### 4. Migration Cockpit Execution Standard

- Run each object in simulation mode first.
- Use generated XML/XLSX templates as release-specific mandatory-field contracts.
- Freeze mapping versions by object and release before cutover.

---

## Operational Checklist

| Checkpoint | Status Template |
|---|---|
| Customizing dependencies validated by process | Pending / Done |
| Mandatory field mapping approved by functional owners | Pending / Done |
| BAPI return handling implemented (E/A stop) | Pending / Done |
| Commit/rollback behavior tested | Pending / Done |
| Migration Cockpit simulation completed | Pending / Done |
| Reconciliation controls defined (counts/amounts) | Pending / Done |

---

## Versioning Note

This reference is intended as a baseline. Final mandatory fields must always be confirmed in the target client and release, including localization and customer-specific enhancements.
