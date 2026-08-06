#!/bin/bash

# Helper class
cat > 04_classes/ZCL_MDG_USMD212C_HELPER.clas << 'EOF'
CLASS zcl_mdg_usmd212c_helper DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS:
      create_entry IMPORTING iv_creq_type TYPE char4 iv_reason_rej TYPE char4
                   EXPORTING et_messages TYPE if_abap_behv_message=>t_message_list ev_success TYPE abap_boolean,
      update_entry IMPORTING iv_creq_type TYPE char4 iv_reason_rej TYPE char4
                   EXPORTING et_messages TYPE if_abap_behv_message=>t_message_list ev_success TYPE abap_boolean,
      delete_entry IMPORTING iv_creq_type TYPE char4 iv_reason_rej TYPE char4
                   EXPORTING et_messages TYPE if_abap_behv_message=>t_message_list ev_success TYPE abap_boolean,
      sync_all_pending EXPORTING et_messages TYPE if_abap_behv_message=>t_message_list ev_count TYPE i.
ENDCLASS.
CLASS zcl_mdg_usmd212c_helper IMPLEMENTATION.
  METHOD create_entry.
    MODIFY ENTITIES OF zi_cr_rejection_reason ENTITY RejectionReason
      CREATE FIELDS ( CreqType ReasonRejection )
      WITH VALUE #( ( %cid = 'CID1' CreqType = iv_creq_type ReasonRejection = iv_reason_rej ) )
      MAPPED DATA(ls_mapped) FAILED DATA(ls_failed) REPORTED DATA(ls_reported).
    IF ls_failed IS INITIAL.
      COMMIT ENTITIES RESPONSE OF zi_cr_rejection_reason FAILED DATA(ls_cf) REPORTED DATA(ls_cr).
      ev_success = COND #( WHEN ls_cf IS INITIAL THEN abap_true ELSE abap_false ).
    ELSE.
      ev_success = abap_false.
      et_messages = CORRESPONDING #( ls_reported-rejectionreason MAPPING FROM %msg ).
    ENDIF.
  ENDMETHOD.
  METHOD update_entry.
    READ ENTITIES OF zi_cr_rejection_reason ENTITY RejectionReason
      FIELDS ( CreqType ) WITH VALUE #( ( CreqType = iv_creq_type ReasonRejection = iv_reason_rej ) )
      RESULT DATA(lt_entries).
    CHECK lt_entries IS NOT INITIAL.
    ev_success = abap_true. " Update not needed - only keys
  ENDMETHOD.
  METHOD delete_entry.
    READ ENTITIES OF zi_cr_rejection_reason ENTITY RejectionReason ALL FIELDS
      WITH VALUE #( ( CreqType = iv_creq_type ReasonRejection = iv_reason_rej ) )
      RESULT DATA(lt_entries).
    CHECK lt_entries IS NOT INITIAL.
    MODIFY ENTITIES OF zi_cr_rejection_reason ENTITY RejectionReason
      DELETE FROM VALUE #( ( %tky = lt_entries[ 1 ]-%tky ) )
      FAILED DATA(ls_failed) REPORTED DATA(ls_reported).
    IF ls_failed IS INITIAL.
      COMMIT ENTITIES.
      ev_success = abap_true.
    ELSE.
      ev_success = abap_false.
    ENDIF.
  ENDMETHOD.
  METHOD sync_all_pending.
    SELECT creq_type, reason_rejection FROM zusmd212c_stage
      WHERE sync_status = ' ' OR sync_status = 'E' INTO TABLE @DATA(lt_pending).
    ev_count = lines( lt_pending ).
    " Sync logic here
  ENDMETHOD.
ENDCLASS.
EOF

# Consumption CDS
cat > 05_cds_views/ZC_CR_REJECTION_REASON.ddls << 'EOF'
@EndUserText.label: 'CR Rejection Reasons - Consumption'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@UI: {
  headerInfo: {
    typeName: 'Rejection Reason',
    typeNamePlural: 'Rejection Reasons',
    title: { type: #STANDARD, value: 'CreqType' }
  }
}
define root view entity ZC_CR_REJECTION_REASON
  provider contract transactional_query
  as projection on ZI_CR_REJECTION_REASON
{
  @UI.facet: [
    { id: 'General', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'General', position: 10 },
    { id: 'Sync', purpose: #STANDARD, type: #FIELDGROUP_REFERENCE, targetQualifier: 'Sync', label: 'Sync Status', position: 20 }
  ]
  @UI: { lineItem: [{ position: 10 }], identification: [{ position: 10 }] }
  key CreqType,
  @UI: { lineItem: [{ position: 20 }], identification: [{ position: 20 }] }
  key ReasonRejection,
  @UI: { lineItem: [{ position: 30, criticality: 'SyncStatusCriticality' }], fieldGroup: [{ qualifier: 'Sync', position: 10 }] }
  SyncStatus,
  SyncStatusText,
  @UI.fieldGroup: [{ qualifier: 'Sync', position: 20 }]
  SyncMessage,
  @UI: { lineItem: [{ position: 40 }], fieldGroup: [{ qualifier: 'Sync', position: 30 }] }
  LastChangedAt,
  SyncTimestamp,
  SyncAttempts,
  SyncMethod,
  StructureValidated,
  StructureHash,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LocalLastChangedAt,
  SyncStatusCriticality
}
EOF

# Behavior Definition
cat > 06_behavior/ZI_CR_REJECTION_REASON.bdef << 'EOF'
managed implementation in class zbp_i_cr_rejection_reason unique;
strict ( 2 );
with draft;

define behavior for ZI_CR_REJECTION_REASON alias RejectionReason
persistent table zusmd212c_stage
draft table zusmd212c_stage_d
etag master LocalLastChangedAt
lock master total etag LastChangedAt
authorization master ( instance )
with additional save
{
  create;
  update;
  delete;
  
  field ( readonly ) SyncStatus, SyncMessage, SyncTimestamp, SyncAttempts, SyncMethod,
                     StructureValidated, StructureHash, CreatedBy, CreatedAt,
                     LastChangedBy, LastChangedAt, LocalLastChangedAt, SyncStatusCriticality;
  
  field ( mandatory : create ) CreqType, ReasonRejection;
  
  action resyncToStandard result [1] $self;
  action resetSyncStatus result [1] $self;
  
  draft action Edit;
  draft action Activate optimized;
  draft action Discard;
  draft action Resume;
  draft determine action Prepare;
  
  mapping for zusmd212c_stage {
    CreqType = creq_type;
    ReasonRejection = reason_rejection;
    SyncStatus = sync_status;
    SyncMessage = sync_message;
    SyncTimestamp = sync_timestamp;
    SyncAttempts = sync_attempts;
    SyncMethod = sync_method;
    StructureValidated = structure_validated;
    StructureHash = structure_hash;
    CreatedBy = created_by;
    CreatedAt = created_at;
    LastChangedBy = last_changed_by;
    LastChangedAt = last_changed_at;
    LocalLastChangedAt = local_last_changed_at;
  }
}
EOF

# Service Definition
cat > 07_service/ZUI_CR_REJECTION_O4.srvd << 'EOF'
@EndUserText.label: 'CR Rejection Reasons Service'
define service ZUI_CR_REJECTION_O4 {
  expose ZC_CR_REJECTION_REASON as RejectionReasons;
}
EOF

echo "✅ All additional files created!"
