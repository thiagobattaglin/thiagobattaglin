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
