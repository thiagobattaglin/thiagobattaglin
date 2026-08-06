#!/bin/bash

# Test report
cat > 09_test/ZTEST_USMD212C.prog << 'EOF'
*&---------------------------------------------------------------------*
*& Report ZTEST_USMD212C
*& Description: Test EML operations for USMD212C RAP project
*&---------------------------------------------------------------------*
REPORT ztest_usmd212c.

DATA: lt_messages TYPE if_abap_behv_message=>t_message_list,
      lv_success  TYPE abap_boolean.

WRITE: / '=' INTENSIFIED ON, 'USMD212C RAP PROJECT TEST', '=' INTENSIFIED OFF.
SKIP.

" Test 1: Create entry
WRITE: / 'Test 1: CREATE entry'.
zcl_mdg_usmd212c_helper=>create_entry(
  EXPORTING iv_creq_type = 'ZMDC' iv_reason_rej = 'Z001'
  IMPORTING ev_success = lv_success et_messages = lt_messages ).
IF lv_success = abap_true.
  WRITE: / '  ✓ Success' COLOR COL_POSITIVE.
ELSE.
  WRITE: / '  ✗ Failed' COLOR COL_NEGATIVE.
ENDIF.

SKIP.

" Test 2: Delete entry
WRITE: / 'Test 2: DELETE entry'.
zcl_mdg_usmd212c_helper=>delete_entry(
  EXPORTING iv_creq_type = 'ZMDC' iv_reason_rej = 'Z001'
  IMPORTING ev_success = lv_success ).
IF lv_success = abap_true.
  WRITE: / '  ✓ Success' COLOR COL_POSITIVE.
ELSE.
  WRITE: / '  ✗ Failed' COLOR COL_NEGATIVE.
ENDIF.

SKIP.
WRITE: / '=' INTENSIFIED ON, 'TEST COMPLETED', '=' INTENSIFIED OFF.
EOF

# INDEX file
cat > INDEX.md << 'EOF'
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
EOF

# QUICK REFERENCE
cat > QUICK_REFERENCE.md << 'EOF'
# 🚀 Quick Reference - USMD212C

## Common Operations

### Create Entry
```abap
zcl_mdg_usmd212c_helper=>create_entry(
  EXPORTING
    iv_creq_type = 'ZMDC'
    iv_reason_rej = 'Z001'
  IMPORTING
    ev_success = DATA(lv_ok)
    et_messages = DATA(lt_msg) ).
```

### Delete Entry
```abap
zcl_mdg_usmd212c_helper=>delete_entry(
  EXPORTING
    iv_creq_type = 'ZMDC'
    iv_reason_rej = 'Z001'
  IMPORTING
    ev_success = DATA(lv_ok) ).
```

### Direct EML
```abap
MODIFY ENTITIES OF zi_cr_rejection_reason
  ENTITY RejectionReason
    CREATE FIELDS ( CreqType ReasonRejection )
    WITH VALUE #( ( %cid = 'CID1'
                    CreqType = 'ZMDC'
                    ReasonRejection = 'Z001' ) ).
COMMIT ENTITIES.
```

### Query Data
```sql
SELECT creq_type, reason_rejection, sync_status
  FROM zusmd212c_stage
  ORDER BY creq_type.
```

## Troubleshooting

**Issue:** Table won't activate
→ Use CHAR4 for both keys

**Issue:** Hash mismatch
→ Run get_table_hash('USMD212C') and update

**Issue:** Service won't publish
→ Verify CDS Views are active

---

**Target:** USMD212C
**Keys:** 2 (CR Type, Reason)
**Type:** CHAR4, CHAR4
EOF

echo "✅ Docs and tests created!"
