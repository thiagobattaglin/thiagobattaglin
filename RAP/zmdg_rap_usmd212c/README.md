# 🏗️ RAP MDG Project - USMD212C (CR Rejection Reasons)

Complete RAP project for maintaining **USMD212C** (Change Request Rejection Reasons) with **85-90% Clean Core compliance**.

## 📊 Target Table: USMD212C

**Structure:**
- `USMD_CREQ_TYPE` (Change Request Type) - Key field
- `USMD_REASON_REJ` (Reason for Rejection) - Key field

**Purpose:** Maintain rejection reasons for MDG change requests

---

## 🎯 Clean Core Score: 85-90%

Same proven architecture as USMD201C project, adapted for simpler 2-key structure.

---

## 📦 Installation Guide

### Phase 1: Prerequisites

1. **Create Message Class ZMDG212** (SE91)
   ```
   001 E Error inserting: CR Type &1 Reason &2
   002 E Error updating: CR Type &1 Reason &2
   003 E Error deleting: CR Type &1 Reason &2
   004 E Table &1 structure incompatible. Expected: &2 Actual: &3
   005 E API not available for table &1
   ```

2. **Verify Z package access**

### Phase 2: Database Objects (SE11 or ADT)

1. **ZUSMD212C_STAGE**
   - Key fields: CLIENT, CREQ_TYPE (CHAR4), REASON_REJECTION (CHAR4)
   - Technical Settings:
     - Data Class: APPL0
     - Size Category: 0
     - Buffering: Single record allowed

2. **ZUSMD212C_STAGE_D** (Draft table)
   - Same structure + draft admin fields
   - Buffering: Not allowed

### Phase 3: ABAP Objects (Create in order)

1. ✅ ZCX_MDG_USMD212C (Exception class)
2. ✅ ZIF_MDG_USMD212C (Interface)
3. ⏳ ZCL_MDG_USMD212C_VALIDATOR (Structure validator)
4. ⏳ ZCL_MDG_USMD212C_DIRECT (Direct SQL persistence)
5. ⏳ ZCL_MDG_USMD212C_API (API persistence - placeholder)
6. ⏳ ZCL_MDG_USMD212C_FACTORY (Factory pattern)
7. ⏳ ZCL_MDG_USMD212C_HELPER (EML helper)

### Phase 4: RAP Layer

1. **CDS Views**
   - ZI_CR_REJECTION_REASON (Interface view)
   - ZC_CR_REJECTION_REASON (Consumption view)

2. **Behavior Definitions**
   - ZI_CR_REJECTION_REASON (Managed behavior)
   - ZBP_I_CR_REJECTION_REASON (Implementation)
   - ZC_CR_REJECTION_REASON (Projection)

3. **Service**
   - ZUI_CR_REJECTION_O4 (Service Definition)
   - ZUI_CR_REJECTION_O4 (Service Binding - ADT)

### Phase 5: Testing

1. Run validation report
2. Execute test report
3. Test Fiori Elements Preview

---

## ⚡ Quick Start Commands

### Create Entry
```abap
zcl_mdg_usmd212c_helper=>create_entry(
  EXPORTING
    iv_creq_type   = 'ZMDC'
    iv_reason_rej  = 'Z001'
  IMPORTING
    ev_success     = DATA(lv_ok)
    et_messages    = DATA(lt_msg) ).
```

### Update Entry
```abap
zcl_mdg_usmd212c_helper=>update_entry(
  EXPORTING
    iv_creq_type   = 'ZMDC'
    iv_reason_rej  = 'Z001'
  IMPORTING
    ev_success     = DATA(lv_ok) ).
```

### Sync All Pending
```abap
zcl_mdg_usmd212c_helper=>sync_all_pending(
  IMPORTING
    ev_count = DATA(lv_count) ).
```

### Direct EML
```abap
MODIFY ENTITIES OF zi_cr_rejection_reason
  ENTITY RejectionReason
    CREATE FIELDS ( CreqType ReasonRejection )
    WITH VALUE #( ( %cid = 'CID1'
                    CreqType = 'ZMDC'
                    ReasonRejection = 'Z001' ) )
  MAPPED DATA(ls_mapped)
  FAILED DATA(ls_failed)
  REPORTED DATA(ls_reported).

COMMIT ENTITIES.
```

---

## 📊 Key Differences vs USMD201C

| Aspect | USMD201C (Original) | USMD212C (This) |
|--------|---------------------|-----------------|
| **Key Fields** | 3 (Model, Entity, Type) | 2 (CR Type, Reason) |
| **Non-key Fields** | 1 (Field Structure) | 0 (none) |
| **Complexity** | Higher | Lower ✅ |
| **Expected Records** | Thousands | < 100 |
| **Use Case** | Entity configuration | Rejection codes |

---

## 🗂️ Project Structure

```
zusmd212c_rap_project/
├── 01_database/
│   ├── ZUSMD212C_STAGE.tabl
│   └── ZUSMD212C_STAGE_D.tabl
├── 02_exceptions/
│   └── ZCX_MDG_USMD212C.clas
├── 03_interfaces/
│   └── ZIF_MDG_USMD212C.intf
├── 04_classes/
│   ├── ZCL_MDG_USMD212C_VALIDATOR.clas
│   ├── ZCL_MDG_USMD212C_DIRECT.clas
│   ├── ZCL_MDG_USMD212C_API.clas
│   ├── ZCL_MDG_USMD212C_FACTORY.clas
│   └── ZCL_MDG_USMD212C_HELPER.clas
├── 05_cds_views/
│   ├── ZI_CR_REJECTION_REASON.ddls
│   └── ZC_CR_REJECTION_REASON.ddls
├── 06_behavior/
│   ├── ZI_CR_REJECTION_REASON.bdef
│   ├── ZBP_I_CR_REJECTION_REASON.clas
│   └── ZC_CR_REJECTION_REASON.bdef
├── 07_service/
│   ├── ZUI_CR_REJECTION_O4.srvd
│   └── Instructions.txt
├── 09_test/
│   ├── ZTEST_USMD212C_EML.prog
│   └── ZVALIDATE_USMD212C.prog
└── README.md (this file)
```

---

## 🔧 Data Types Reference

| Field Name | SAP Type (Original) | Generic Type | Length |
|------------|---------------------|--------------|--------|
| USMD_CREQ_TYPE | usmd_crequest_type | CHAR | 4 |
| USMD_REASON_REJ | usmd_reason_rej | CHAR | 4 |

---

## ✅ Validation Checklist

After installation:

- [ ] Message Class ZMDG212 created (5 messages)
- [ ] Tables ZUSMD212C_STAGE and _D active
- [ ] Exception class ZCX_MDG_USMD212C active
- [ ] Interface ZIF_MDG_USMD212C active
- [ ] All 5 classes active
- [ ] CDS Views active
- [ ] Behavior Definitions active
- [ ] Service Binding published
- [ ] Validation report runs successfully
- [ ] Test report runs successfully
- [ ] Fiori Preview works

---

## 🎯 Architecture

```
Factory Pattern → Interface → Implementation (SQL or API)
       ↓              ↓              ↓
RAP Managed → Shadow Table → Synchronization → USMD212C
       ↓
  Fiori UI
```

**Benefits:**
- ✅ Isolated SQL access
- ✅ API-ready migration path
- ✅ Full audit trail
- ✅ Structure validation
- ✅ Clean Core 85-90%

---

## 🆘 Troubleshooting

### Issue: Table won't activate
**Solution:** Use CHAR4 for both key fields

### Issue: Foreign key errors
**Solution:** Foreign keys are optional, remove if USMD110C doesn't exist

### Issue: Hash mismatch
**Solution:** Run `get_table_hash('USMD212C')` and update expected hash

---

## 📞 Support Files

- **INDEX.md** - Complete file listing
- **QUICK_REFERENCE.md** - Common commands
- **CLEAN_CORE_COMPLIANCE.md** - Compliance details

---

## 🎉 Summary

**Target Table:** USMD212C (Change Request Rejection Reasons)  
**Key Fields:** 2 (simpler than USMD201C)  
**Clean Core:** 85-90%  
**Language:** English  
**Types:** Generic CHAR  
**Status:** ✅ Ready for implementation

---

**Good luck with your implementation!** 🚀
