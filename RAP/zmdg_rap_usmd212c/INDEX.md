# 📑 USMD212C Project - File Index

## Quick Reference

**Target Table:** USMD212C (CR Rejection Reasons)
**Total Files:** 20
**Clean Core:** 85-90%

## Installation Order

1. Message Class ZMDG212 (SE91)
2. ZUSMD212C_STAGE (Table)
3. ZUSMD212C_STAGE_D (Draft table)
4. ZCX_MDG_USMD212C (Exception)
5. ZIF_MDG_USMD212C (Interface)
6. ZCL_MDG_USMD212C_VALIDATOR
7. ZCL_MDG_USMD212C_DIRECT
8. ZCL_MDG_USMD212C_API
9. ZCL_MDG_USMD212C_FACTORY
10. ZCL_MDG_USMD212C_HELPER
11. ZI_CR_REJECTION_REASON (CDS)
12. ZC_CR_REJECTION_REASON (CDS)
13. ZI_CR_REJECTION_REASON (BDEF)
14. ZC_CR_REJECTION_REASON (BDEF)
15. ZUI_CR_REJECTION_O4 (Service)
16. Service Binding (ADT)

## File Structure

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
│   └── ZI_CR_REJECTION_REASON.bdef
├── 07_service/
│   └── ZUI_CR_REJECTION_O4.srvd
├── 09_test/
│   └── ZTEST_USMD212C.prog
├── README.md
└── INDEX.md
```

## Key Differences from USMD201C

- **Simpler:** Only 2 key fields vs 3
- **No non-key fields** in target table
- **Smaller dataset:** < 100 records expected
- **Same architecture:** Clean Core 85-90%

## Quick Start

```abap
// Create
zcl_mdg_usmd212c_helper=>create_entry(
  EXPORTING iv_creq_type = 'ZMDC' iv_reason_rej = 'Z001'
  IMPORTING ev_success = DATA(lv_ok) ).

// Delete
zcl_mdg_usmd212c_helper=>delete_entry(
  EXPORTING iv_creq_type = 'ZMDC' iv_reason_rej = 'Z001'
  IMPORTING ev_success = DATA(lv_ok) ).
```

---

**Status:** ✅ Ready for import
**Language:** English
**Types:** Generic CHAR
