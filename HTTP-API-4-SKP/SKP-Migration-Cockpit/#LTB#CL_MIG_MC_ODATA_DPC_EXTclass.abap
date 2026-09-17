class /LTB/CL_MIG_MC_ODATA_DPC_EXT definition
  public
  inheriting from /LTB/CL_MIG_MC_ODATA_DPC
  create public .

public section.

  types:
    BEGIN OF ts_shlp_properties,
        fields     TYPE dfies,
        shlpinput	 TYPE	shlpinput,    " this flag indicates the field can get parameter ID
        shlpoutput TYPE	shlpoutput,   " this flag indicates the field can set parameter ID
        shlpselpos TYPE shlpselpos,   " position in the selection screen - input
        shlplispos TYPE shlplispos,   " position in the hit list - output
        shlpseldis TYPE	shlpseldis,   " this flag indicates that the field is read only field
        defaultval TYPE	ddshdefval,   " holds the search help field default value
      END   OF ts_shlp_properties .
  types:
    tt_shlp_properties TYPE STANDARD TABLE OF ts_shlp_properties .

  class-methods CLASS_CONSTRUCTOR .
  class-methods CONVERT_FILE_NAME
    importing
      !IV_FILE_NAME type STRING
    returning
      value(EV_FILE_NAME) type STRING .
  class-methods GET_ENTITY_COMPONENTS
    importing
      !IV_ENTITY_SET_NAME type STRING
      !IV_COMPONENT_NAME type STRING
    returning
      value(RV_COMPONENT_NAME) type STRING .
  class-methods GET_LONGTEXT_FROM_MSG
    importing
      !IV_MSGID type SYST_MSGID
      !IV_MSGNO type SYST_MSGNO
      !IV_MSGV1 type SYST_MSGV optional
      !IV_MSGV2 type SYST_MSGV optional
      !IV_MSGV3 type SYST_MSGV optional
      !IV_MSGV4 type SYST_MSGV optional
      !IV_BALOG type BALOGNR optional
      !IV_BAMSG type BALMNR optional
    exporting
      !EV_IS_LONGTEXT_EXIST type BOOLEAN
    returning
      value(RV_HTMLSTRING) type STRING .
  methods CONSTRUCTOR .

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CHANGESET_BEGIN
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CHANGESET_END
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CHANGESET_PROCESS
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~DELETE_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITYSET
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_IS_CONDITIONAL_IMPLEMENTED
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_ENTITY
    redefinition .
protected section.

  methods ACTIVITYMONITO01_GET_ENTITYSET
    redefinition .
  methods ACTIVITYMONITO02_GET_ENTITYSET
    redefinition .
  methods ACTIVITYMONITORS_GET_ENTITYSET
    redefinition .
  methods ACTIVITYTRACKSET_GET_ENTITYSET
    redefinition .
  methods APPLACTIVITYMO01_GET_ENTITYSET
    redefinition .
  methods APPLACTIVITYMO02_GET_ENTITYSET
    redefinition .
  methods APPLACTIVITYMONI_GET_ENTITYSET
    redefinition .
  methods APPLACTIVITYTRAC_GET_ENTITYSET
    redefinition .
  methods APPLICATIONLOG01_GET_ENTITYSET
    redefinition .
  methods APPLICATIONLOGOV_GET_ENTITY
    redefinition .
  methods APPLICATIONLOGSE_GET_ENTITY
    redefinition .
  methods APPLICATIONLOGSE_GET_ENTITYSET
    redefinition .
  methods AVAILABLEDOWNL01_GET_ENTITYSET
    redefinition .
  methods AVAILABLERESULTF_GET_ENTITYSET
    redefinition .
  methods AVAILABLETASKSET_GET_ENTITYSET
    redefinition .
  methods COMPANIESINMIGRA_GET_ENTITYSET
    redefinition .
  methods COMPANYCODEVHSET_GET_ENTITYSET
    redefinition .
  methods CONNECTIONVHSET_GET_ENTITYSET
    redefinition .
  methods COPYACTIONSET_GET_ENTITY
    redefinition .
  methods COPYACTIONSET_GET_ENTITYSET
    redefinition .
  methods CSVOPTIONDDLSET_GET_ENTITYSET
    redefinition .
  methods CSVSETTINGSSET_GET_ENTITY
    redefinition .
  methods CSVSETTINGSSET_UPDATE_ENTITY
    redefinition .
  methods FILTERF4VALUESET_GET_ENTITYSET
    redefinition .
  methods FILTERMETASET_GET_ENTITY
    redefinition .
  methods FILTERSINMIGRATI_GET_ENTITYSET
    redefinition .
  methods INDPROCESSLANESE_GET_ENTITYSET
    redefinition .
  methods INDPROCESSSELSET_GET_ENTITYSET
    redefinition .
  methods INDPROCESSSET_GET_ENTITYSET
    redefinition .
  methods ITEMCOLUMNSSET_GET_ENTITYSET
    redefinition .
  methods MESSAGEDETAILSET_GET_ENTITYSET
    redefinition .
  methods MESSAGEGROUPOVER_GET_ENTITY
    redefinition .
  methods MESSAGEGROUPSET_GET_ENTITY
    redefinition .
  methods MESSAGEGROUPSET_GET_ENTITYSET
    redefinition .
  methods MESSAGEINSTANCES_GET_ENTITYSET
    redefinition .
  methods MIGRATIONAPPROAC_GET_ENTITYSET
    redefinition .
  methods MIGRATIONFILEC01_GET_ENTITYSET
    redefinition .
  methods MIGRATIONFILEC02_GET_ENTITY
    redefinition .
  methods MIGRATIONFILEC02_GET_ENTITYSET
    redefinition .
  methods MIGRATIONFILECOU_GET_ENTITY
    redefinition .
  methods MIGRATIONFILESET_CREATE_ENTITY
    redefinition .
  methods MIGRATIONFILESET_GET_ENTITY
    redefinition .
  methods MIGRATIONFILESET_GET_ENTITYSET
    redefinition .
  methods MIGRATIONFILET01_GET_ENTITYSET
    redefinition .
  methods MIGRATIONGROUPIN_GET_ENTITYSET
    redefinition .
  methods MIGRATIONINSTA01_GET_ENTITYSET
    redefinition .
  methods MIGRATIONINSTA02_GET_ENTITYSET
    redefinition .
  methods MIGRATIONINSTANC_DELETE_ENTITY
    redefinition .
  methods MIGRATIONINSTANC_GET_ENTITY
    redefinition .
  methods MIGRATIONINSTANC_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJEC01_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJEC02_GET_ENTITY
    redefinition .
  methods MIGRATIONOBJEC02_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJEC03_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJEC04_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJEC05_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJEC06_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJEC07_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJEC08_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJEC09_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJEC10_GET_ENTITY
    redefinition .
  methods MIGRATIONOBJEC10_UPDATE_ENTITY
    redefinition .
  methods MIGRATIONOBJEC11_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJEC16_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJEC18_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJEC19_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJECTC_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJECTM_GET_ENTITY
    redefinition .
  methods MIGRATIONOBJECTM_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJECTS_GET_ENTITY
    redefinition .
  methods MIGRATIONOBJECTS_GET_ENTITYSET
    redefinition .
  methods MIGRATIONOBJECTU_GET_ENTITY
    redefinition .
  methods MIGRATIONOBJECTU_GET_ENTITYSET
    redefinition .
  methods MIGRATIONPROJE03_GET_ENTITY
    redefinition .
  methods MIGRATIONPROJE03_GET_ENTITYSET
    redefinition .
  methods MIGRATIONPROJE04_GET_ENTITY
    redefinition .
  methods MIGRATIONPROJE05_GET_ENTITYSET
    redefinition .
  methods MIGRATIONPROJE06_GET_ENTITY
    redefinition .
  methods MIGRATIONPROJECT_GET_ENTITY
    redefinition .
  methods MIGRATIONPROJECT_GET_ENTITYSET
    redefinition .
  methods MIGRATIONSCENARI_GET_ENTITYSET
    redefinition .
  methods MIGRATIONTEMPL01_GET_ENTITYSET
    redefinition .
  methods MIGRATIONTEMPLAT_GET_ENTITY
    redefinition .
  methods RECENTACTIONSET_GET_ENTITYSET
    redefinition .
  methods SEARCHHELPTEMPLA_GET_ENTITYSET
    redefinition .
  methods STAGINGOVERVIEWS_GET_ENTITY
    redefinition .
  methods STAGINGOVERVIEWS_GET_ENTITYSET
    redefinition .
  methods SYSTEMINFOSET_GET_ENTITYSET
    redefinition .
  methods TABLECOLUMNSSET_GET_ENTITYSET
    redefinition .
  methods TABLEDATASET_GET_ENTITYSET
    redefinition .
  methods TABLESTRUCTORSET_GET_ENTITYSET
    redefinition .
  methods TASKFILESET_GET_ENTITYSET
    redefinition .
  methods TASKITEMCOLUMNSE_GET_ENTITYSET
    redefinition .
  methods TASKITEMSET_GET_ENTITYSET
    redefinition .
  methods TASKITEMUSEDBYSE_GET_ENTITYSET
    redefinition .
  methods TASKITEMVHSET_GET_ENTITYSET
    redefinition .
  methods TASKOVERVIEWSET_GET_ENTITYSET
    redefinition .
  methods TASKPROCESSINGSE_GET_ENTITYSET
    redefinition .
  methods TASKPROCFILESET_GET_ENTITYSET
    redefinition .
  methods TASKSET_GET_ENTITY
    redefinition .
  methods TASKSET_GET_ENTITYSET
    redefinition .
  methods VALUEHELPFIELDSE_GET_ENTITYSET
    redefinition .
  methods MIGRATIONINSTA04_GET_ENTITYSET
    redefinition .
private section.

  constants CO_ABAP_MIGRATION_INST_ACTION type STRING value 'ACTION' ##NO_TEXT.
  constants CO_ABAP_MIGRATION_INST_FILTER type STRING value 'FILTER' ##NO_TEXT.
  constants CO_ABAP_MIGRATION_INST_GRP_IND type STRING value 'GROUPINDICATOR' ##NO_TEXT.
  constants CO_ABAP_MIGRATION_INST_STATUS type STRING value 'MIGRATIONINSTANCESTATUS' ##NO_TEXT.
  constants CO_ABAP_MIGRATION_INST_UUID type STRING value 'MIGRATIONINSTANCEUUID' ##NO_TEXT.
  constants CO_ABAP_MIGRATION_INST_MSGID type STRING value 'MSGID' ##NO_TEXT.
  constants CO_ABAP_MIGRATION_INST_MSGNO type STRING value 'MSGNO' ##NO_TEXT.
  constants CO_ABAP_MIGRATION_INST_MSGTY type STRING value 'MSGTY' ##NO_TEXT.
  constants CO_ABAP_MIGRATION_INST_EXEC_ID type STRING value 'MSGGROUPUUID' ##NO_TEXT.
  constants CO_ABAP_MIGRATION_OPTIONID type STRING value 'OPTIONID' ##NO_TEXT.
  constants CO_ABAP_MIGRATION_STEP type STRING value 'STEP' ##NO_TEXT.
  constants CO_ABAP_MIGRATION_OPTIONDESCR type STRING value 'OPTIONDESCR' ##NO_TEXT.
  constants CO_ABAP_MIGRATION_STEPDESCR type STRING value 'STEPDESCR' ##NO_TEXT.
  constants CO_ABAP_TABLE_UUID type STRING value 'TABLEUUID' ##NO_TEXT.
  constants CO_ACTION_CHECK_CONTENT_EXIST type STRING value 'CheckContentExist' ##NO_TEXT.
  constants CO_ACTION_CHECK_UPGRADE_STATE type STRING value 'CheckUpgradeState' ##NO_TEXT.
  constants CO_ACTION_CONFIRM_TASK type STRING value 'ConfirmTask' ##NO_TEXT.
  constants CO_ACTION_CONFIRM_TASK_VALUE type STRING value 'ConfirmTaskItemValue' ##NO_TEXT.
  constants CO_ACTION_CREATE_PROJ type STRING value 'CREPROJ' ##NO_TEXT.
  constants CO_ACTION_DOWNLOADUPLOADRAL type STRING value 'DownloadUploadedFileRALMonitor' ##NO_TEXT.
  constants CO_ACTION_DOWNLOADCORRECTRAL type STRING value 'DownloadCorrectionFileRALMonitor' ##NO_TEXT.
  constants CO_ACTION_DELETE_PROJECT type STRING value 'DeleteProject' ##NO_TEXT.
  constants CO_ACTION_EXCLUDE_INSTANCE type STRING value 'ExcludeInstance' ##NO_TEXT.
  constants CO_ACTION_EXPORT_PROJECT type STRING value 'ExportProject' ##NO_TEXT.
  constants CO_ACTION_FINISH_PROJECT type STRING value 'FinishProject' ##NO_TEXT.
  constants CO_ACTION_GET_ACT_MIG_COUNT type STRING value 'GetActiveMigrationCount' ##NO_TEXT.
  constants CO_ACTION_GET_FILE_CONTENT type STRING value 'GetFileContent' ##NO_TEXT.
  constants CO_ACTION_GET_INPROGRESS_MOS type STRING value 'InprogressMoList' ##NO_TEXT.
  constants CO_ACTION_GET_STAGING_CONTENT type STRING value 'GetStagingContent' ##NO_TEXT.
  constants CO_ACTION_INSTANCE_BULK_PROC type STRING value 'InstanceBulkProcess' ##NO_TEXT.
  constants CO_ACTION_MO_CLEARSTAGING type STRING value 'ClearStaging' ##NO_TEXT.
  constants CO_ACTION_MO_DATA_SELECTION type STRING value 'SelectData' ##NO_TEXT.
  constants CO_ACTION_MO_MIGRATION type STRING value 'StartMigration' ##NO_TEXT.
  constants CO_ACTION_MO_SIMULATION type STRING value 'Simulation' ##NO_TEXT.
  constants CO_ACTION_MO_SYNCSTAGING type STRING value 'SyncStaging' ##NO_TEXT.
  constants CO_ACTION_PROCESS_FILE type STRING value 'FileProcess' ##NO_TEXT.
  constants CO_ACTION_IMPORT_TASK_VALUE type STRING value 'ImportTaskValue' ##NO_TEXT.
  constants CO_ACTION_RESTART_PROJ_PREP type STRING value 'RestartProjectPreparation' ##NO_TEXT.
  constants CO_ACTION_UPDATE_PROJ type STRING value 'UPDPROJ' ##NO_TEXT.
  constants CO_ACTION_UPGRADE_CONTENT type STRING value 'UpgradeContent' ##NO_TEXT.
  constants CO_ACTION_GET_VALUE_HELP_VALUE type STRING value 'GetValueHelpValue' ##NO_TEXT.
  constants CO_ACTION_CHK_TASK_ITEM_VALUE type STRING value 'CheckTaskItemValue' ##NO_TEXT.
  constants CO_ACTION_CHECK_TASK type STRING value 'CheckTask' ##NO_TEXT.
  constants CO_ACTION_CHECK_DEV_CLASS type STRING value 'CheckDevclass' ##NO_TEXT.
  constants CO_ACTION_CHECK_DB_CONNECTION type STRING value 'CheckDbConnection' ##NO_TEXT.
  constants CO_ACTION_CHECK_COPY_PROJECT type STRING value 'CheckCopyProject' ##NO_TEXT.
  constants CO_ACTION_SET_JOBS type STRING value 'SetJobs' ##NO_TEXT.
  constants CO_ACTION_GET_ORG_EDITABILITY type STRING value 'GetOrgEditability' ##NO_TEXT.
  constants CO_ACTION_DOWNLOAD_MESSAGERAL type STRING value 'DownloadMigrationObjectMessageRALMonitor' ##NO_TEXT.
  constants CO_ACTION_MO_DOWNLOAD_MESSAGE type STRING value 'DownloadMigrationObjectMessage' ##NO_TEXT.
  constants CO_ACTION_DELETE_CSVFILE type STRING value 'DeleteCSVFile' ##NO_TEXT.
  constants CO_ACTION_IS_BDL_TRANSFERRED type STRING value 'IsBundleTransferred' ##NO_TEXT.
  constants CO_OBJECTMESSAGE_RAL type STRING value 'MigrationObjectMessageRALMonitor' ##NO_TEXT.
  constants CO_MESSAGEDETAIL_RAL type STRING value 'DownloadInstanceMessageDetailRAL' ##NO_TEXT.
  constants CO_DOWNLOADAPPLLOGRAL type STRING value 'DownloadShowMessagesRALMonitor' ##NO_TEXT.
  constants CO_ACTION_MESSAGEOVERVIEW_RAL type STRING value 'DownloadMessageOverviewDetailRALMonitor' ##NO_TEXT.
  constants CO_ACTION_INSTANCE_DOWNLOADRAL type STRING value 'DownloadMigrationInstanceRALMonitor' ##NO_TEXT.
  constants CO_ACTION_MO_RESULT_DOWNLOAD type STRING value 'DownloadMigrationResult' ##NO_TEXT.
  constants CO_ACTION_IND_PROCESS_ACTION type STRING value 'IndProcessAction' ##NO_TEXT.
  constants CO_ACTION_GET_FORWARD_NAVI type STRING value 'GetForwardNavigation' ##NO_TEXT.
  constants CO_ACTION_CANCEL_ACTIVITY type STRING value 'CancelActivity' ##NO_TEXT.
  constants CO_CHECK_AUTH type STRING value 'CheckAuth' ##NO_TEXT.
  constants CO_CLASS_NAME type SEOCLSNAME value '/LTB/CL_MIG_MC_ODATA_DPC_EXT' ##NO_TEXT.
  constants CO_DEFAULT_LANG type STRING value 'EN' ##NO_TEXT.
  constants CO_DEFAULT_LANG_PARAMETER type STRING value 'E' ##NO_TEXT.
  constants CO_DEPENDENCYLEVEL type STRING value 'DependencyLevel' ##NO_TEXT.
  constants CO_DOCUMENT_ID type STRING value 'DocumentId' ##NO_TEXT.
  constants CO_DOWNLOAD_FILE_NAME type STRING value 'DownloadFileName' ##NO_TEXT.
  constants CO_DOWNLOAD_TEMPLATE_COMPLETED type STRING value 'DOWNLOAD TEMPLATE COMPLETED' ##NO_TEXT.
  constants CO_ENTITY_FILE_CONTENT type STRING value 'MigrationFileContent' ##NO_TEXT.
  constants CO_ENTITY_TABLEDATA type STRING value 'TableData' ##NO_TEXT.
  constants CO_FILE_DOWNLOAD type STRING value 'DownloadFile' ##NO_TEXT.
  constants CO_FILE_GENERATION_COMPLETED type STRING value 'FILE GENERATION COMPLETED' ##NO_TEXT.
  constants CO_FILE_PROCUUID type STRING value 'MigrationFileProc' ##NO_TEXT.
  constants CO_FILE_TEMPLATE_ACTIVITYID type STRING value 'DownloadActivityID' ##NO_TEXT.
  constants CO_FILE_TEMPLATE_DOWNLOAD type STRING value 'DownloadFileTemplate' ##NO_TEXT.
  constants CO_FILTER_APPLLOGNR type STRING value 'ApplLognr' ##NO_TEXT.
  constants CO_FILTER_APPROACHFORTEMPLATE type STRING value 'Approach' ##NO_TEXT.
  constants CO_FILTER_DEPENDENTTYPE type STRING value 'DependencyType' ##NO_TEXT.
  constants CO_FILTER_ISCOPIED type STRING value 'IsCopied' ##NO_TEXT.
  constants CO_FILTER_MESSAGEDETAILUUID type STRING value 'MessageDetailUUID' ##NO_TEXT.
  constants CO_FILTER_MSGID type STRING value 'MsgMsgid' ##NO_TEXT.
  constants CO_FILTER_MSGNO type STRING value 'MsgMsgno' ##NO_TEXT.
  constants CO_FILTER_MSGNUMBER type STRING value 'MSGNUMBER' ##NO_TEXT.
  constants CO_FILTER_MSGTITLE type STRING value 'MsgTitle' ##NO_TEXT.
  constants CO_FILTER_MSGTY type STRING value 'MsgMsgty' ##NO_TEXT.
  constants CO_FILTER_MSGUUID type STRING value 'MsgUUID' ##NO_TEXT.
  constants CO_FILTER_SCENARIOFORTEMPLATE type STRING value 'Scenario' ##NO_TEXT.
  constants CO_FILTER_PRODPROJECTUUID type STRING value 'ProductiveProjectUUID' ##NO_TEXT.
  constants CO_GET_CHECK_MTID type STRING value 'GetCheckMTID' ##NO_TEXT.
  constants CO_MESSAGE_DISPLAY_OPTION type STRING value 'DisplayOption' ##NO_TEXT.
  constants CO_MIG_INST_DISPLAY_OPTION type STRING value 'DisplayOption' ##NO_TEXT.
  constants CO_MESSAGE_GROUP_UUID type STRING value 'MessageGroupUUID' ##NO_TEXT.
  constants CO_MIGRATION_ACTIVITY_UUID type STRING value 'MigrationActivityUUID' ##NO_TEXT.
  constants CO_MIGRATION_HISTORY_UUID type STRING value 'MigrationHistoryUUID' ##NO_TEXT.
  constants CO_MIGRATION_INSTANCE_UUID type STRING value 'MigrationInstanceUUID' ##NO_TEXT.
  constants CO_MIGRATION_INST_ACTION type STRING value 'ActionDescription' ##NO_TEXT.
  constants CO_MIGRATION_INST_GRP_IND type STRING value 'GroupIndicator' ##NO_TEXT.
  constants CO_MIGRATION_INST_STATUS type STRING value 'StatusDescription' ##NO_TEXT.
  constants CO_MIGRATION_ITEM_UUID type STRING value 'MigrationItemUUID' ##NO_TEXT.
  constants CO_MIGRATION_OBJECT_UUID type STRING value 'MigrationObjectUUID' ##NO_TEXT.
  constants CO_FILECATEGORY type STRING value 'FileCategory' ##NO_TEXT.
  constants CO_TECID type STRING value 'TechID' ##NO_TEXT.
  constants CO_CSVBUNDLEUUID type STRING value 'MigrationFileUUID' ##NO_TEXT.
  constants CO_CSVFILEUUID type STRING value 'CSVFileUUID' ##NO_TEXT.
  constants CO_MIGRATION_OBJ_HISTORY_UUID type STRING value 'MigrationObjectHistoryUUID' ##NO_TEXT.
  constants CO_MIGRATION_PROJECT_UUID type STRING value 'MigrationProjectUUID' ##NO_TEXT.
  constants CO_MIGRATION_PROJ_HISTORY_UUID type STRING value 'MigrationProjectHistoryUUID' ##NO_TEXT.
  constants CO_MIME_TYPE_COMPRESSED_ZIP type STRING value 'application/x-zip-compressed' ##NO_TEXT.
  constants CO_MIME_TYPE_CSV type STRING value 'text/csv' ##NO_TEXT.
  constants CO_MIME_TYPE_XML type STRING value 'text/xml' ##NO_TEXT.
  constants CO_MIME_TYPE_ZIP type STRING value 'application/zip' ##NO_TEXT.
  constants CO_PIECHART_STATUS_ERROR type STRING value 'Error' ##NO_TEXT.
  constants CO_PIECHART_STATUS_MIGRATED type STRING value 'Migrated' ##NO_TEXT.
  constants CO_PIECHART_STATUS_OPEN type STRING value 'Open' ##NO_TEXT.
  constants CO_PIECHART_STATUS_SIMULATED type STRING value 'Simulated' ##NO_TEXT.
  constants CO_RESET_STATUS type STRING value 'ResetStatus' ##NO_TEXT.
  constants CO_RESET_TRANSFER_STATUS type STRING value 'ResetTransferStatus' ##NO_TEXT.
  constants CO_RESTART_TRANSFER type STRING value 'RestartTransfer' ##NO_TEXT.
  constants CO_SET_PARALLEL_JOBS type STRING value 'SetParallelJobs' ##NO_TEXT.
  constants CO_SORT_DESCENDING type STRING value 'desc' ##NO_TEXT.
  constants CO_SORT_ASCENDING type STRING value 'asc' ##NO_TEXT.
  constants CO_STAGING_TABLE_NAME type STRING value 'TechID' ##NO_TEXT.
  constants CO_TABLE_UUID type STRING value 'TableUUID' ##NO_TEXT.
  constants CO_TAB_NAME type STRING value 'DMC_COBJ' ##NO_TEXT.
  constants CO_TASK_TOGGLE_MODE type STRING value 'TaskToggleMode' ##NO_TEXT.
  constants CO_TRANS_CONFIRM_TASK type STRING value 'transaction_confirm_task' ##NO_TEXT.
  constants CO_TRANS_CONFIRM_TASK_VALUE type STRING value 'transaction_confirm_task_value' ##NO_TEXT.
  constants CO_TRANS_CHECK_TASK_VALUE type STRING value 'transaction_check_task_value' ##NO_TEXT.
  constants CO_TRANS_CHECK_TASK type STRING value 'transaction_check_task' ##NO_TEXT.
  constants CO_TRANS_DELETE_PROJECT type STRING value 'transaction_delete_project' ##NO_TEXT.
  constants CO_TRANS_EXCLUSION type STRING value 'transaction_mo_exclusion' ##NO_TEXT.
  constants CO_TRANS_FINISH_PROJECT type STRING value 'transaction_finish_project' ##NO_TEXT.
  constants CO_TRANS_MIGRATION type STRING value 'transaction_mo_migration' ##NO_TEXT.
  constants CO_TRANS_RESTART_PREPARATION type STRING value 'transaction_restart_preparation' ##NO_TEXT.
  constants CO_TRANS_SELECTION type STRING value 'transaction_mo_selection' ##NO_TEXT.
  constants CO_TRANS_PREPARE_MAPPING_TASKS type STRING value 'transaction_mo_prepare_mapping_tasks' ##NO_TEXT.
  constants CO_TRANS_SIMULATION type STRING value 'transaction_mo_simulation' ##NO_TEXT.
  constants CO_TRANS_MO_DOWNLOAD_MESSAGE type STRING value 'transaction_mo_download_message' ##NO_TEXT.
  constants CO_DELETE_CSV_FILE type STRING value 'DeleteCSVFile' ##NO_TEXT.
  constants CO_DOWNLOAD_MO_INSTANCE type STRING value 'DownloadMigrationInstance' ##NO_TEXT.
  constants CO_UNDEFINED type STRING value 'undefined' ##NO_TEXT.
  constants CO_UPDATE_CUSTOM_FIELDS type STRING value 'UpdateCustomFields' ##NO_TEXT.
  constants CO_VALUE_HELP_SEARCH_HELP type STRING value 'search_help' ##NO_TEXT.
  constants CO_VALUE_HELP_CHECK_TABLE type STRING value 'check_table' ##NO_TEXT.
  constants CO_VALUE_HELP_DOMAIN type STRING value 'domain' ##NO_TEXT.
  constants CO_VALUE_HELP_CONTR_PARAM type STRING value 'control_parameter' ##NO_TEXT.
  constants CO_VALUE_HELP_STEP_IMPORT type INT2 value 1 ##NO_TEXT.
  constants CO_VALUE_HELP_STEP_EXPORT type INT2 value 2 ##NO_TEXT.
  constants CO_RESOLVE_ERRORS type STRING value 'ResolveErrors' ##NO_TEXT.
  constants CO_CONSISTENT_CHECK type STRING value 'CheckDataInconsistency' ##NO_TEXT.
  constants:
    BEGIN OF gc_dependency_level,
      single TYPE char1 VALUE 'S',
      all    TYPE char1 VALUE 'A',
    END OF gc_dependency_level .
  class-data:
    mt_default_text_pool TYPE TABLE OF textpool .
  data:
    mt_text_pool TYPE TABLE OF textpool .
  data MV_LANGUAGE type CHAR2 .
  data MV_TRANSACTION type STRING .
  constants CO_SYSTEMINFO_S4TYPE type STRING value 'S4TYPE' ##NO_TEXT.
  constants CO_SYSTEMINFO_EDITABLE type STRING value 'EDITABLE' ##NO_TEXT.
  constants CO_DT_OBJECT_LOAD_REQUIRED type STRING value 'LOADREQUIRED' ##NO_TEXT.
  constants CO_SYSTEMINFO_MAXFILESIZE type STRING value 'MAXFILESIZE' ##NO_TEXT.
  constants CO_DELETE_INSTANCE type STRING value 'DeleteInstance' ##NO_TEXT.
  constants CO_REMOVE_TASKPROC type STRING value 'RemoveTaskproc' ##NO_TEXT.
  constants CO_MIGRATION_TASK_LIST type STRING value 'MigrationTaskList' ##NO_TEXT.
  constants CO_WITH_VALUE type STRING value 'WithValue' ##NO_TEXT.
  constants CO_TASK_DESCR type STRING value 'TaskDescription' ##NO_TEXT.
  constants CO_FIELD_DESCR type STRING value 'FieldDescription' ##NO_TEXT.
  constants CO_ACTIVITY_UUID type STRING value 'ActivityUUID' ##NO_TEXT.
  constants CO_MIGRATION_TASK_UUID type STRING value 'MigrationTaskUUID' ##NO_TEXT.
  constants CO_DOWNLOAD_OPTION type STRING value 'DownloadOption' ##NO_TEXT.
  constants CO_TASK_FILE_UUID type STRING value 'TaskFileUUID' ##NO_TEXT.
  constants CO_DELETE_TASK_FILE type STRING value 'DeleteTaskFile' ##NO_TEXT.
  constants CO_ONPREMISE type STRING value 'OP' ##NO_TEXT.
  constants CO_CLOUD type STRING value 'CL' ##NO_TEXT.
  constants CO_ACTION_UUID type STRING value 'ActionUUID' ##NO_TEXT.
  constants CO_MESSAGE_TYPE type STRING value 'MessageGroupType' ##NO_TEXT.
  constants CO_MESSAGE_ID type STRING value 'MessageGroupMsgId' ##NO_TEXT.
  constants CO_MESSAGE_NO type STRING value 'MessageGroupMsgNo' ##NO_TEXT.
  constants CO_INSTANCE_COUNT type STRING value 'InstanceCount' ##NO_TEXT.
  constants CO_CHECK_PROJ_CONNECTION type STRING value 'CheckProjectConnection' ##NO_TEXT.
  constants CO_CHECK_FOR_UPD_AND_CUS_FLD type STRING value 'CheckForUpdateAndCustomField' ##NO_TEXT.
  constants CO_FILTER type STRING value 'Filter' ##NO_TEXT.
  constants CO_ACTION_DOWNLOADTASKRAL type STRING value 'DownloadMappingTaskFileRALMonitor' ##NO_TEXT.
  constants CO_ACTION_CHECK_RFC_CONNECTION type STRING value 'CheckRfcConnection' ##NO_TEXT.
  constants CO_RFC_TYPE_R3 type RFCDISPLAY-RFCTYPE value '3' ##NO_TEXT.
  constants CO_ACTION_MO_PREPARE_MAPTSKS type STRING value 'PrepareMappingTasks' ##NO_TEXT.
  constants CO_SEARCHHELP type STRING value 'CollectiveSHLPName' ##NO_TEXT.
  constants CO_ACTION_MAP_CSV_FILE type STRING value 'MapCSVFile' ##NO_TEXT.
  constants CO_ACTION_CLEAR_TASK_VALUES type STRING value 'ClearTaskValues' ##NO_TEXT.
  constants CO_ACTION_DELETE_TASK_VALUE type STRING value 'DeleteTaskValue' ##NO_TEXT.
  constants CO_CHECK_BEFORE_DEL_TASK_VALUE type STRING value 'CheckBeforeDeleteMappingValue' ##NO_TEXT.
  constants CO_IS_INSTANCE_IN_MO type STRING value 'IsInstanceInMO' ##NO_TEXT.

  methods IS_MIGRATION_FILE_TRANSFERRED
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CREATE_CSV_BUNDLE
    importing
      !IV_SLUG type STRING
    returning
      value(RV_SLUG) type STRING
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods IS_CSV_OR_XML
    importing
      !IV_DATA type XSTRING
    returning
      value(RV_RET) type CHAR1 .
  methods UPLOAD_MIGRATION_XML_FILE
    importing
      !IS_MEDIA_RESOURCE type TY_S_MEDIA_RESOURCE
      !IV_SLUG type STRING
    exporting
      !ER_ENTITY type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods DELETE_CSV_FILES
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods UPLOAD_PROJECT_FILE
    importing
      !IS_MEDIA_RESOURCE type TY_S_MEDIA_RESOURCE
    exporting
      !ER_ENTITY type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods UPLOAD_MIGRATION_CSV_BUNDLE
    importing
      !IS_MEDIA_RESOURCE type TY_S_MEDIA_RESOURCE
      !IV_SLUG type STRING
      !IV_TRIG_VALIDATION type ABAP_BOOL default ABAP_TRUE
    exporting
      !ER_ENTITY type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods UPLOAD_MIGRATION_CSV_FILE
    importing
      !IS_MEDIA_RESOURCE type TY_S_MEDIA_RESOURCE
      !IV_SLUG type STRING
    exporting
      !ER_ENTITY type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_STM_CSV_FILE
    importing
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
    returning
      value(RS_STREAM) type TY_S_MEDIA_RESOURCE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods UPLOAD_MIGRATION_FILE
    importing
      !IS_MEDIA_RESOURCE type TY_S_MEDIA_RESOURCE
      !IV_SLUG type STRING
    exporting
      !ER_ENTITY type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods CHECK_DELETE_LOCK
    importing
      !IV_PROJ_UUID type /LTB/MC_PROJ_UUID
    returning
      value(RV_LOCKED) type ABAP_BOOL .
  methods CHECK_FOR_UPD_AND_CUS_FLD
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    exceptions
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CHECK_PROJECT_CONNECTION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CHECK_TASK_TRANSACTION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CHECK_TASK_VALUES
    changing
      !IS_TASK_ITEM type /LTB/CL_MIG_MC_ODATA_MPC=>TS_TASKITEM optional
      !IT_TASK_ITEM type /LTB/CL_MIG_MC_ODATA_MPC=>TT_TASKITEM optional
    returning
      value(RT_ERRORS) type /LTB/IF_MC_CONSTANTS=>GTT_VALUE_ERROR
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods CHECK_TASK_VALUE_TRANSACTION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CLEAR_TRANSACTION .
  methods CONFIRM_TASK
    importing
      !IV_PROJECT_UUID type /LTB/MC_PROJ_UUID
      !IV_OBJECT_UUID type /LTB/MC_OBJECT_UUID
      !IV_TASK_UUID type /LTB/MC_TASK_UUID
    returning
      value(RT_ERRORS) type /LTB/IF_MC_CONSTANTS=>GTT_VALUE_ERROR
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods CONFIRM_TASK_TRANSACTION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CONFIRM_TASK_VALUES
    changing
      !IS_TASK_ITEM type /LTB/CL_MIG_MC_ODATA_MPC=>TS_TASKITEM optional
      !IT_TASK_ITEM type /LTB/CL_MIG_MC_ODATA_MPC=>TT_TASKITEM optional
    returning
      value(RT_ERRORS) type /LTB/IF_MC_CONSTANTS=>GTT_VALUE_ERROR
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods CONFIRM_TASK_VALUE_TRANSACTION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CONVERT_TIME_STAMP
    importing
      !IV_TIMESTAMP_LONG_FORMAT type TIMESTAMPL
    returning
      value(RV_TIMESTAMP) type TIMESTAMP .
  methods DATETIME_ROUND_DOWN
    importing
      !IV_DATETIME type BALTIMSTMP
    returning
      value(RV_DATETIME) type TIMESTAMP .
  methods DELETE_INSTANCES
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods DELETE_PROJECT_TRANSACTION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods DOWNLOAD_FILE_TEMPLATE
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods FILTER_TECH_MESSAGES
    changing
      !IT_MESSAGES type CNV_MBT_T_BAL_S_MSG .
  methods FINISH_PROJECT_TRANSACTION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods GET_ACTION_DESC
    importing
      !IV_ACTION type STRING
    returning
      value(RV_DESCRIPTION) type STRING .
  methods GET_ACTIVE_MIGRATION_COUNT
    returning
      value(RS_COUNT) type /LTB/CL_MIG_MC_ODATA_MPC=>TS_ACTIVEMIGRATIONCOUNT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_ATTACHEMENT_HEADER_VALUE
    importing
      !IV_FILENAME type STRING
      !IV_FILENAME_ENCODE type STRING
    returning
      value(RV_OUT) type STRING .
  methods GET_CHECK_MTID
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_MTID type /LTB/CL_MIG_MC_ODATA_MPC_EXT=>TS_MIGRATIONPROJECTMTID
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_COMPLEX_FILTER_SEL_OPTION
    importing
      !IV_ENTITY_NAME type STRING
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
      !IV_TECH_PROPERTY_NAME type ABAP_BOOL default ABAP_FALSE
    returning
      value(RT_SELECT_OPTION) type /IWBEP/T_MGW_SELECT_OPTION .
  methods GET_COMPLEX_FILTER_SEL_OPTION1
    importing
      !IV_ENTITY_NAME type STRING
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
      !IV_TECH_PROPERTY_NAME type ABAP_BOOL default ABAP_FALSE
    returning
      value(RT_SELECT_OPTION) type /IWBEP/T_MGW_SELECT_OPTION .
  methods GET_COPIED_MIGRATION_OBJECTS
    importing
      !IO_PROJECT_PROXY type ref to /LTB/IF_MC_PROJ_PROXY
      !IT_MIGRATION_OBJECT type /LTB/IF_MC_CONSTANTS=>GTT_MIGOBJ
    changing
      !CT_RESULT type /LTB/CL_MIG_MC_ODATA_MPC=>TT_MIGRATIONOBJECT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_FILE_PROC_STREAM
    importing
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
    returning
      value(RS_STREAM) type TY_S_MEDIA_RESOURCE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_INPROGRESS_MO_LIST
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    changing
      !CT_RESULT type /LTB/CL_MIG_MC_ODATA_MPC=>TT_MIGRATIONOBJECT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_LANGUAGE_BATCH
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST .
  methods GET_LATEST_EVENT_TEXT
    importing
      !IV_EVENT_TYPE type /LTB/MC_EVENT_TYPE
      !IV_MIGRATE_NUMBER type INT8
      !IV_SIMULATE_NUMBER type INT8
    returning
      value(RV_LATEST_EVENT) type STRING .
  methods GET_MO_TASK_LIST
    importing
      !IO_PROJ_PROXY type ref to /LTB/IF_MC_PROJ_PROXY
      !IV_OBJECT_ID type /LTB/MC_OBJECT_UUID
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET
    exporting
      !EV_OPEN_TASK_COUNT type INT8
      !EV_CONFIRMED_TASK_COUNT type INT8
      !EV_INFO_LOSS_TASK_COUNT type INT8
    changing
      !CT_RESULT type /LTB/CL_MIG_MC_ODATA_MPC=>TT_TASK optional
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_PROJECT_CONTENT_STREAM
    importing
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
    returning
      value(RS_STREAM) type TY_S_MEDIA_RESOURCE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_PROJECT_STATUS_TEXT
    importing
      !IV_STATUS type /LTB/IF_MC_CONSTANTS=>GTY_PROJ_STATUS
    returning
      value(RV_TEXT) type STRING .
  methods GET_SEARCH_HELP_FIELDS
    importing
      !IV_SEARCH_HELP_NAME type STRING
      !IV_SEARCH_HELP_STEP type INT2
    exporting
      !ET_FIELDS type /LTB/CL_MIG_MC_ODATA_MPC=>TT_VALUEHELPFIELD
    raising
      /IWBEP/CX_SBDSP_SHLP_PROVIDER .
  methods GET_SEARCH_HELP_PROPERTIES
    importing
      !IV_SHLP_NAME type SHLPNAME
    exporting
      !ET_FIELD_SET type TT_SHLP_PROPERTIES
      !EV_STAR_FIELD type FIELDNAME
    raising
      /IWBEP/CX_SBDSP_SHLP_PROVIDER .
  methods GET_SEARCH_HELP_VALUE
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA
    raising
      /IWBEP/CX_SBDSP_SHLP_PROVIDER .
  methods GET_STATUS_DESC
    importing
      !IV_STATUS type STRING
    returning
      value(RV_DESCRIPTION) type STRING .
  methods GET_STM_FILE_DOWNLOAD
    importing
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
    returning
      value(RS_STREAM) type TY_S_MEDIA_RESOURCE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_STM_MO_MESSAGE
    importing
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
    returning
      value(RS_STREAM) type TY_S_MEDIA_RESOURCE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_STM_MO_INSTANCE
    importing
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
    returning
      value(RS_STREAM) type TY_S_MEDIA_RESOURCE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_STM_STAGING_TAB_FLD_CSV
    importing
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
    returning
      value(RS_STREAM) type TY_S_MEDIA_RESOURCE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_STM_TASK_FILE
    importing
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
    returning
      value(RS_STREAM) type TY_S_MEDIA_RESOURCE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_STM_TASK_TEMPLATE
    importing
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
    returning
      value(RS_STREAM) type TY_S_MEDIA_RESOURCE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_STM_TASK_VALUE
    importing
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
    returning
      value(RS_STREAM) type TY_S_MEDIA_RESOURCE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_TASK_LIST
    importing
      !IV_OBJECT_ID type /LTB/MC_OBJECT_UUID optional
      !IT_OBJECT_ID type /LTB/MC_T_OBJECT_UUID optional
      !IV_PROJECT_ID type /LTB/MC_PROJ_UUID
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    exporting
      !EV_OPEN_TASK_COUNT type I
      !EV_CONFIRMED_TASK_COUNT type I
      !EV_INFO_LOSS_TASK_COUNT type I
    changing
      !CT_RESULT type /LTB/CL_MIG_MC_ODATA_MPC=>TT_TASK optional
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_TASK_STATUS_TEXT
    importing
      !IV_STATUS type /LTB/IF_MC_CONSTANTS=>GTY_TASK_STATUS
    returning
      value(RV_TEXT) type STRING .
  methods GET_TASK_TYPE_TEXT
    importing
      !IV_TYPE type /LTB/IF_MC_CONSTANTS=>GTY_TASK_TYPE
    returning
      value(RV_TEXT) type STRING .
  methods GET_TEXT
    importing
      !IV_ID type TEXTPOOL-KEY
    returning
      value(RV_TEXT) type STRING .
  methods GET_TRANSACTION
    exporting
      !EV_TRANSACTION type STRING .
  methods GET_WHERE_USED_LIST
    importing
      !IV_PROJECT_ID type /LTB/MC_PROJ_UUID
      !IV_OBJECT_ID type /LTB/MC_OBJECT_UUID
      !IV_TASK_ID type /LTB/MC_TASK_UUID
    changing
      !CT_RESULT type /LTB/CL_MIG_MC_ODATA_MPC=>TT_TASKITEMUSEDBY
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_CANCEL_ACTIVITY
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_CHECK_AUTH
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_CHECK_CONTENT_EXIST
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_CHECK_COPY_PROJECT
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_CHECK_DB_CONNECTION
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA .
  methods HANDLE_CHECK_DEV_CLASS
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA .
  methods HANDLE_CHECK_RFC_CONNECTION
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA .
  methods HANDLE_CHECK_UPGRADE_STATE
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods HANDLE_DATA_CONSISTENT_CHECK
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_DELETE_PROJECT
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_DELETE_TASK_FILE
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods HANDLE_DOWNLOADCORRECTRAL
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_MIGRATIONFILETEMPLATE type /LTB/CL_MIG_MC_ODATA_MPC_EXT=>TS_MIGRATIONFILETEMPLATE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_DOWNLOAD_INSTANCE_RAL
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_MIGRATIONINSTANCE type /LTB/CL_MIG_MC_ODATA_MPC_EXT=>TS_MIGRATIONFILETEMPLATE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_DOWNLOADTASKRAL
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_DOWNLOADTASKFILERAL type /LTB/CL_MIG_MC_ODATA_MPC_EXT=>TS_MIGRATIONTASKVALUEFILE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_DOWNLOAD_MESSAGERAL
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_DOWNLOADMESSAGE type /LTB/CL_MIG_MC_ODATA_MPC_EXT=>TS_MIGRATIONFILETEMPLATE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_INSMESDETAILRAL
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_DOWNLOADDETAIL type /LTB/CL_MIG_MC_ODATA_MPC_EXT=>TS_MESSAGEDETAILRAL
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_MESSAGEOVERDETAILRAL
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_DOWNLOADMESSAGEOVERVIEW type /LTB/CL_MIG_MC_ODATA_MPC_EXT=>TS_MESSAGEDETAILRAL
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_APPLICATIONLOGRAL
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_DOWNLOADAPPLOG type /LTB/CL_MIG_MC_ODATA_MPC_EXT=>TS_APPLICATIONLOGRAL
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_DOWNLOADUPLOADRAL
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_DOWNLOADMIGRATIONFILE type /LTB/CL_MIG_MC_ODATA_MPC_EXT=>TS_DOWNLOADMIGRATIONFILE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_DOWNLOAD_MESSAGE
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_MIGRATIONOBJECTMESSAGEDOWNL type /LTB/CL_MIG_MC_ODATA_MPC_EXT=>TS_MIGRATIONOBJECTMESSAGEDOWNL
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_OBJECTMESSAGES
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_MIGRATIONOBJECTMESSAGE type /LTB/CL_MIG_MC_ODATA_MPC_EXT=>TS_MIGRATIONOBJECTMESSAGE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_DOWNLOAD_INSTANCE
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_MIGRATIONINSTANCEDOWNLOAD type /LTB/CL_MIG_MC_ODATA_MPC_EXT=>TS_MIGRATIONINSTANCEDOWNLOAD
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_EXPORT_PROJECT
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_FILE_PROCESS
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods HANDLE_FINISH_PROJECT
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !EV_WARNING_EXIST type BOOLEAN
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_GET_FILE_CONTENT
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods HANDLE_GET_FORWARD_NAVI
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods HANDLE_GET_ORG_EDITABILITY
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_PROCESS_RESULT type /LTB/CL_MIG_MC_ODATA_MPC=>TS_PROCESSRESULT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_GET_STAGING_CONTENT
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods HANDLE_GET_VALUE_HELP_VALUE
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods HANDLE_SET_JOBS
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods HANDLE_UPDATE_CUSTOM_FIELDS
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods IMPORT_TASK_VALUE
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods INSTANCE_BULK_PROCESS
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods INSTANCE_IND_PROCESS
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ER_DATA type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods INSTANCE_RESET_STATUS
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods IS_SYSTEM_UPGRADE
    returning
      value(RV_IS_UPGRADE) type ABAP_BOOLEAN .
  methods IS_LOAD_OBJECT_REQUIRED
    returning
      value(RV_IS_REQUIRED) type ABAP_BOOLEAN .
  methods IS_DBCON_LOST
    importing
      !IV_DBCON_NAME type DBCON_NAME
    returning
      value(RV_IS_LOST) type ABAP_BOOL .
  methods IS_ELEMENTARY_SEARCH_HELP
    importing
      !IV_SHLP_NAME type SHLPNAME
    returning
      value(RV_IS_ELEM_SHLP) type BOOLE_D .
  methods IS_RFC_AVAILABLE
    importing
      !IV_CONNECTION type TEXT80
      !IV_CONNECTIONUUID type CNV_PE_COM_CA_UUID optional
    returning
      value(RV_RFC_INVALID) type CHAR1 .
  methods MAINTAIN_PROJECT
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
      !IV_CASE type STRING
    changing
      value(CT_CHANGESET_RESPONSE) type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods MO_CLEAR_STAGING_TRANSACTION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods MO_CONTENT_UPGRADE
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods MO_DOWNLOAD_MESSAGE
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods MO_INS_EXCLUSION_TRANSACTION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods MO_MIGRATION_TRANSACTION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods MO_PREPARE_MAPPING_TASKS_TRANS
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods MO_RESTART_TRANSFER
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods MO_SELECTION_TRANSACTION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods MO_SIMULATION_TRANSACTION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods MO_SYNC_STAGING_TRANSACTION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods NO_CACHE .
  methods PROJ_RESTART_PREPARATION
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      value(CT_CHANGESET_RESPONSE) type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods RAISE_BUSSINESS_EXCEPTION
    importing
      !IV_TEXTID like IF_T100_MESSAGE=>T100KEY
      !IT_MESSAGE type CNV_MBT_T_BAL_S_MSG optional
      !IO_MESSAGE_CONTAINER type ref to /IWBEP/IF_MESSAGE_CONTAINER optional
      !IV_MESSAGE_UNLIMITED type STRING optional
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods RELOAD_STAGING_TABLE_INFO
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods REMOVE_ESCAPE_SYMBOL
    changing
      !CT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION .
  methods REMOVE_TASKPROC
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods RESOLVE_ERRORS
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods SET_CONTEXT
    importing
      !IV_ENTITY_SET_NAME type STRING
      !IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER optional
      !IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION optional
      !IS_PAGING type /IWBEP/S_MGW_PAGING optional
      !IV_SEARCH_STRING type STRING optional
      !IO_CONTEXT type ref to /LTB/CL_MC_CNTXT_QUERY
      !IV_LANGUAGE type SYLANGU optional
    raising
      /LTB/CX_MC_CNTXT_ERROR .
  methods SET_PARALLEL_JOBS
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods SET_TRANSACTION
    importing
      !IV_TRANSACTION type STRING .
  methods STAGING_RESET_TRANSFER_STATUS
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods UPLOAD_TASK_FILE
    importing
      !IS_MEDIA_RESOURCE type TY_S_MEDIA_RESOURCE
      !IV_SLUG type STRING
    exporting
      !ER_ENTITY type DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods CHECK_SYSTEM_UPGRADE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods MAP_CSV_FILE
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods GET_BUNDLE_FILE_SIZE
    importing
      !IV_BUNDLE_UUID type /LTB/MC_FILEPROC_UUID
    returning
      value(RV_FILE_SIZE) type INT4 .
  methods CHECK_PROJNAME_AVAILABILITY
    importing
      !IV_PROJNAME type DMC_DESCR
    returning
      value(RV_AVAILABLE) type BOOLEAN
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods CHECK_DISPLAY_AUTH_FOR_REQUEST
    raising
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CHECK_EXECUTE_AUTH_FOR_REQUEST
    raising
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods GET_LATEST_EVENT_INFO
    importing
      !IV_LATEST_EVENT type /LTB/MC_EVENT_TYPE
    returning
      value(RS_EVENT_INFO) type /LTB/CL_MC_EVENTLOG_CUSTLOADER=>GTY_EVENT_INFO .
  methods GET_MIGRATION_OBJECT_STATUS
    importing
      !IV_NUMBER_MIGRATED_ERR type INT8
      !IV_NUMBER_SIMULATED_ERR type INT8
      !IV_NUMBER_MIGRATED type INT8
      !IV_NUMBER_REMAINING type INT8
      !IV_EVENT_STATUS type /LTB/MC_EVENT_STATUS
    returning
      value(RV_STATUS) type /LTB/IF_MC_CONSTANTS=>GTY_MIGOBJ_STATUS .
  methods CHECK_IS_INSTANCE_IN_MO
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_PROCESS_RESULT type /LTB/CL_MIG_MC_ODATA_MPC=>TS_PROCESSRESULT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods CLEAR_TASK_VALUES
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods DELETE_TASK_VALUE
    importing
      !IT_CHANGESET_REQUEST type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_REQUEST
    changing
      !CT_CHANGESET_RESPONSE type /IWBEP/IF_MGW_APPL_TYPES=>TY_T_CHANGESET_RESPONSE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods CHECK_BEFORE_DEL_TASK_VALUE
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
    exporting
      !ES_PROCESS_RESULT type /LTB/CL_MIG_MC_ODATA_MPC=>TS_PROCESSRESULT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods IS_DELETE_PROJ_RUNNING
    importing
      !IV_PROJ_UUID type /LTB/MC_PROJ_UUID
    returning
      value(RV_RUNNING) type BOOLEAN .
  methods IS_COPY_MO_RUNNING
    importing
      !IV_PROJ_UUID type /LTB/MC_PROJ_UUID
    returning
      value(RV_RUNNING) type BOOLEAN .
  methods GET_JSON_NAME_MAPPINGS
    importing
      !IS_DATA type ANY
    returning
      value(RT_NAME_MAPPINGS) type /UI2/CL_JSON=>NAME_MAPPINGS .
ENDCLASS.



CLASS /LTB/CL_MIG_MC_ODATA_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~changeset_begin.
    DATA: ls_operation_info TYPE /iwbep/s_mgw_operation_info.

    "For security purpose, at the very beginning, check authorization
    check_execute_auth_for_request( ).

    check_system_upgrade( ).
    "create&update project
    READ TABLE it_operation_info INTO ls_operation_info WITH KEY entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_migrationproject.
    IF sy-subrc = 0.
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-create_entity.
        "Create
        cv_defer_mode = abap_true.
        CALL METHOD set_transaction
          EXPORTING
            iv_transaction = co_action_create_proj.
      ELSEIF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-update_entity.
        "update project
        cv_defer_mode = abap_true.

        CALL METHOD set_transaction
          EXPORTING
            iv_transaction = co_action_update_proj.
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_migrationprojectprepinfo ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_migrationprojectprepinfo ].
      IF ls_operation_info-action_name = co_action_restart_proj_prep.
        cv_defer_mode = abap_true.
        CALL METHOD set_transaction
          EXPORTING
            iv_transaction = co_trans_restart_preparation.
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_taskitem ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_taskitem ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action
        AND ls_operation_info-action_name = co_action_confirm_task_value.
        cv_defer_mode = abap_true.
        CALL METHOD set_transaction
          EXPORTING
            iv_transaction = co_trans_confirm_task_value.
      ELSEIF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action
        AND ls_operation_info-action_name = co_action_delete_task_value.
        cv_defer_mode = abap_true.
        set_transaction( co_action_delete_task_value ).
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_task ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_task ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action
        AND ls_operation_info-action_name = co_action_confirm_task.
        cv_defer_mode = abap_true.
        CALL METHOD set_transaction
          EXPORTING
            iv_transaction = co_trans_confirm_task.
      ELSEIF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action
        AND ls_operation_info-action_name = co_action_clear_task_values.
        cv_defer_mode = abap_true.
        set_transaction( co_action_clear_task_values ).
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_processresult ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_processresult ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action.
        IF ls_operation_info-action_name = co_action_chk_task_item_value.
          cv_defer_mode = abap_true.
          CALL METHOD set_transaction
            EXPORTING
              iv_transaction = co_trans_check_task_value.
        ELSEIF ls_operation_info-action_name = co_action_check_task.
          cv_defer_mode = abap_true.
          CALL METHOD set_transaction
            EXPORTING
              iv_transaction = co_trans_check_task.
        ELSEIF ls_operation_info-action_name = co_action_is_bdl_transferred.
          cv_defer_mode = abap_true.
          set_transaction( co_action_is_bdl_transferred ).
        ENDIF.
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobject ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobject ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action.
        IF ls_operation_info-action_name = co_action_mo_simulation.
          cv_defer_mode = abap_true.
          CALL METHOD set_transaction
            EXPORTING
              iv_transaction = co_trans_simulation.
        ELSEIF ls_operation_info-action_name = co_action_mo_migration.
          cv_defer_mode = abap_true.
          CALL METHOD set_transaction
            EXPORTING
              iv_transaction = co_trans_migration.
        ELSEIF ls_operation_info-action_name = co_action_mo_data_selection.
          cv_defer_mode = abap_true.
          CALL METHOD set_transaction
            EXPORTING
              iv_transaction = co_trans_selection.
          "Prepare mapping tasks
        ELSEIF ls_operation_info-action_name = co_action_mo_prepare_maptsks.
          cv_defer_mode = abap_true.
          CALL METHOD set_transaction
            EXPORTING
              iv_transaction = co_trans_prepare_mapping_tasks.
        ELSEIF ls_operation_info-action_name = co_restart_transfer.
          cv_defer_mode = abap_true.
          CALL METHOD set_transaction
            EXPORTING
              iv_transaction = co_restart_transfer.
        ELSEIF ls_operation_info-action_name = co_action_upgrade_content.
          cv_defer_mode = abap_true.
          set_transaction( co_action_upgrade_content ).
        ELSEIF ls_operation_info-action_name = co_file_template_download.
          cv_defer_mode = abap_true.
          set_transaction( co_file_template_download ).
        ENDIF.
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_migrationinstance ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_migrationinstance ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action.
        IF ls_operation_info-action_name = co_action_exclude_instance.
          cv_defer_mode = abap_true.
          CALL METHOD set_transaction
            EXPORTING
              iv_transaction = co_trans_exclusion.
        ELSEIF ls_operation_info-action_name = co_reset_status.
          cv_defer_mode = abap_true.
          CALL METHOD set_transaction
            EXPORTING
              iv_transaction = co_reset_status.
        ENDIF.
      ELSEIF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-delete_entity.
        cv_defer_mode = abap_true.
        set_transaction( co_delete_instance ).
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_migrationproject ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_migrationproject ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action.
        IF ls_operation_info-action_name = co_action_delete_project.
          cv_defer_mode = abap_true.
          CALL METHOD set_transaction
            EXPORTING
              iv_transaction = co_trans_delete_project.
        ELSEIF ls_operation_info-action_name = co_action_finish_project.
          cv_defer_mode = abap_true.
          CALL METHOD set_transaction
            EXPORTING
              iv_transaction = co_trans_finish_project.
        ENDIF.
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_stagingoverview ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_stagingoverview ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action.
        IF ls_operation_info-action_name = co_action_mo_clearstaging.
          cv_defer_mode = abap_true.
          set_transaction( co_action_mo_clearstaging ).
        ELSEIF ls_operation_info-action_name = co_action_mo_syncstaging.
          cv_defer_mode = abap_true.
          set_transaction( co_action_mo_syncstaging ).
        ELSEIF ls_operation_info-action_name = co_reset_transfer_status.
          cv_defer_mode = abap_true.
          CALL METHOD set_transaction
            EXPORTING
              iv_transaction = co_reset_transfer_status.
        ENDIF.
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_migrationfile ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_migrationfile ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action.
        IF ls_operation_info-action_name = co_action_process_file.
          cv_defer_mode = abap_true.
          set_transaction( co_action_process_file ).
        ENDIF.
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_taskprocessing ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_taskprocessing ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-delete_entity.
        cv_defer_mode = abap_true.
        set_transaction( co_remove_taskproc ).
      ELSEIF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action.
        IF ls_operation_info-action_name = co_action_import_task_value.
          cv_defer_mode = abap_true.
          set_transaction( co_action_import_task_value ).
        ENDIF.
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_taskfile ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_taskfile ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-delete_entity.
        cv_defer_mode = abap_true.
        set_transaction( co_delete_task_file ).
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_processresult ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_processresult ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action.
        IF ls_operation_info-action_name = co_check_proj_connection.
          cv_defer_mode = abap_true.
          set_transaction( co_check_proj_connection ).
        ENDIF.
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_contentupdateandcustomfield ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_contentupdateandcustomfield ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action.
        IF ls_operation_info-action_name = co_check_for_upd_and_cus_fld.
          cv_defer_mode = abap_true.
          set_transaction( co_check_for_upd_and_cus_fld ).
        ENDIF.
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_applactivitymonitordetail ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_applactivitymonitordetail ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action.
        IF ls_operation_info-action_name = co_resolve_errors.
          cv_defer_mode = abap_true.
          set_transaction( co_resolve_errors ).
        ENDIF.
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_returnmessage ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_returnmessage ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-execute_action.
        IF ls_operation_info-action_name = co_action_delete_csvfile.
          cv_defer_mode = abap_true.
          set_transaction( co_action_delete_csvfile ).
        ENDIF.
      ENDIF.
    ENDIF.

    IF line_exists( it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobjectcsvfile ] ).
      ls_operation_info = it_operation_info[ entity_type = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobjectcsvfile ].
      IF ls_operation_info-operation_type = /iwbep/if_mgw_appl_types=>gcs_operation_type-update_entity.
        cv_defer_mode = abap_true.
        set_transaction( co_action_map_csv_file ).
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~changeset_end.
    CALL METHOD clear_transaction.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~changeset_process.

    get_language_batch( it_changeset_request = it_changeset_request ).

    CALL METHOD get_transaction
      IMPORTING
        ev_transaction = DATA(lv_transaction).

    CASE lv_transaction.
      WHEN co_action_create_proj.
        maintain_project(
          EXPORTING
            it_changeset_request  = it_changeset_request
            iv_case               = co_action_create_proj
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_action_update_proj.
        maintain_project(
          EXPORTING
            it_changeset_request  = it_changeset_request
            iv_case               = co_action_update_proj
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_trans_confirm_task_value.
        confirm_task_value_transaction(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_trans_check_task_value.
        check_task_value_transaction(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).

      WHEN co_trans_check_task.
        check_task_transaction(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_trans_confirm_task.
        confirm_task_transaction(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_trans_selection.
        mo_selection_transaction(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_trans_prepare_mapping_tasks.
        mo_prepare_mapping_tasks_trans(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
             ).
      WHEN co_trans_simulation.
        mo_simulation_transaction(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_trans_migration.
        mo_migration_transaction(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_trans_exclusion.
        mo_ins_exclusion_transaction(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_trans_delete_project.
        delete_project_transaction(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_trans_finish_project.
        finish_project_transaction(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_action_mo_clearstaging.
        mo_clear_staging_transaction(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_action_mo_syncstaging.
        mo_sync_staging_transaction(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_trans_restart_preparation.
        proj_restart_preparation(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_restart_transfer.
        mo_restart_transfer(
          EXPORTING
            it_changeset_request = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_reset_status.
        instance_reset_status(
          EXPORTING
            it_changeset_request = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_action_upgrade_content.
        mo_content_upgrade(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN co_file_template_download.
        download_file_template(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN co_action_process_file.
        handle_file_process(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN co_delete_instance.
        delete_instances(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN co_remove_taskproc.
        remove_taskproc(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN co_action_import_task_value.
        import_task_value(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN co_delete_task_file.
        handle_delete_task_file(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_check_proj_connection.
        check_project_connection(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response
        ).
      WHEN co_trans_mo_download_message.
        mo_download_message(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN co_check_for_upd_and_cus_fld.
        check_for_upd_and_cus_fld(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN co_resolve_errors.
        resolve_errors(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN co_action_delete_csvfile.
        delete_csv_files(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN co_action_map_csv_file.
        map_csv_file(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN co_action_is_bdl_transferred.
        is_migration_file_transferred(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN co_action_delete_task_value.
        delete_task_value(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN co_action_clear_task_values.
        clear_task_values(
          EXPORTING
            it_changeset_request  = it_changeset_request
          CHANGING
            ct_changeset_response = ct_changeset_response ).
      WHEN OTHERS.
        MESSAGE e009(/ltb/mc) WITH lv_transaction INTO DATA(lv_message).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lv_message
        ).
    ENDCASE.

  ENDMETHOD.


METHOD /iwbep/if_mgw_appl_srv_runtime~create_entity.

  "For security purpose, at the very beginning, check authorization
  check_execute_auth_for_request( ).

  super->/iwbep/if_mgw_appl_srv_runtime~create_entity(
    EXPORTING
      iv_entity_name          = iv_entity_name
      iv_entity_set_name      = iv_entity_set_name
      iv_source_name          = iv_source_name
      io_data_provider        = io_data_provider
      it_key_tab              = it_key_tab
      it_navigation_path      = it_navigation_path
      io_tech_request_context = io_tech_request_context
    IMPORTING
      er_entity               = er_entity ).

ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.

*   sometimes, unzipped file direct drag could lead to empty value
    if IS_MEDIA_RESOURCE-value is initial.
      raise EXCEPTION type /iwbep/cx_mgw_busi_exception
      exporting
        textid = /ltb/cx_mc_proxy_error=>empty_file_to_load.
    endif.

  "For security purpose, at the very beginning, check authorization
    check_execute_auth_for_request( ).

    check_system_upgrade( ).

    CLEAR er_entity.
    CASE iv_entity_name.
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_migrationprojectimportexpor.
        upload_project_file(
          EXPORTING
            is_media_resource = is_media_resource
          IMPORTING
            er_entity         = er_entity
        ).
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_migrationobjectfileupload.
        upload_migration_file(
          EXPORTING
            is_media_resource = is_media_resource
            iv_slug           = iv_slug
          IMPORTING
            er_entity         = er_entity
        ).
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_uploadtaskfile.
        upload_task_file(
          EXPORTING
            is_media_resource = is_media_resource
            iv_slug           = iv_slug
          IMPORTING
            er_entity         = er_entity
        ).
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_uploadcsvfile.
        upload_migration_csv_file(
          EXPORTING
            is_media_resource = is_media_resource
            iv_slug           = iv_slug
          IMPORTING
            er_entity         = er_entity
        ).
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_uploadcsvbundle.
        upload_migration_csv_bundle(
          EXPORTING
            is_media_resource = is_media_resource
            iv_slug           = iv_slug
            iv_trig_validation = abap_false
          IMPORTING
            er_entity         = er_entity
        ).
      WHEN OTHERS.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid = /iwbep/cx_mgw_busi_exception=>business_error.
    ENDCASE.



  ENDMETHOD.


METHOD /iwbep/if_mgw_appl_srv_runtime~delete_entity.

  "For security purpose, at the very beginning, check authorization
  check_execute_auth_for_request( ).

  CALL METHOD super->/iwbep/if_mgw_appl_srv_runtime~delete_entity(
    EXPORTING
      iv_entity_name          = iv_entity_name
      iv_entity_set_name      = iv_entity_set_name
      iv_source_name          = iv_source_name
      it_key_tab              = it_key_tab
      it_navigation_path      = it_navigation_path
      io_tech_request_context = io_tech_request_context
  ).

ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
    DATA:
      lt_migration_object            TYPE /ltb/cl_mig_mc_odata_mpc=>tt_migrationobject,
      ls_project_mtid                TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationprojectmtid,
      lt_migration_instance          TYPE /ltb/cl_mig_mc_odata_mpc=>tt_migrationinstance,
      ls_process_result              TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult,
      ls_migration_file              TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationfile,
      ls_download_migration_file     TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_downloadmigrationfile,
      ls_migration_file_template     TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationfiletemplate,
      ls_migration_task_value        TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationtaskvaluefile,
      ls_migrationinstancedownload   TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationinstancedownload,
      ls_messageoverviewdetail       TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_messagedetailral,
      ls_objectmessage               TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationobjectmessage,
      ls_appllog                     TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_applicationlogral,
      ls_detail                      TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_messagedetailral,
      ls_instancedownload_ral        TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationfiletemplate,
      ls_migrationobjectmessagedownl TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationobjectmessagedownl.

    "For security purpose, at the very beginning, check authorization
    check_execute_auth_for_request( ).

    CLEAR er_data.
    DATA(lv_function_name) = io_tech_request_context->get_function_import_name( ).
    CASE lv_function_name.
      WHEN co_action_delete_project.
        handle_delete_project( io_tech_request_context = io_tech_request_context ).
      WHEN co_action_finish_project.
        handle_finish_project( io_tech_request_context = io_tech_request_context ).
      WHEN co_action_get_inprogress_mos.
        get_inprogress_mo_list( EXPORTING io_tech_request_context = io_tech_request_context
                                CHANGING  ct_result               = lt_migration_object ).
        copy_data_to_ref( EXPORTING is_data = lt_migration_object
                          CHANGING  cr_data = er_data ).
      WHEN co_action_get_act_mig_count.
        DATA(ls_acitive_count) = get_active_migration_count( ).
        copy_data_to_ref( EXPORTING is_data = ls_acitive_count
                          CHANGING  cr_data = er_data ).
      WHEN co_action_export_project.
        handle_export_project( io_tech_request_context = io_tech_request_context ).
      WHEN co_get_check_mtid.
        get_check_mtid(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            es_mtid                 = ls_project_mtid
        ).
        copy_data_to_ref( EXPORTING is_data = ls_project_mtid
                          CHANGING  cr_data = er_data ).
      WHEN co_set_parallel_jobs.
        set_parallel_jobs( io_tech_request_context = io_tech_request_context ).

      WHEN co_action_get_staging_content.
        handle_get_staging_content(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data ).
      WHEN co_action_check_upgrade_state.
        handle_check_upgrade_state(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data ).
      WHEN co_update_custom_fields.
        handle_update_custom_fields(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data ).
      WHEN co_action_check_content_exist.
        handle_check_content_exist(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data ).
      WHEN co_action_get_file_content.
        handle_get_file_content(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data ).
      WHEN co_action_instance_bulk_proc.
        instance_bulk_process( io_tech_request_context = io_tech_request_context ).
      WHEN co_action_get_value_help_value.
        handle_get_value_help_value(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data ).
      WHEN co_action_set_jobs.
        handle_set_jobs( io_tech_request_context = io_tech_request_context ).

      WHEN co_action_get_org_editability.
        handle_get_org_editability( EXPORTING io_tech_request_context = io_tech_request_context
                                    IMPORTING es_process_result       = ls_process_result ).
        copy_data_to_ref( EXPORTING is_data = ls_process_result
                          CHANGING  cr_data = er_data ).
      WHEN co_action_downloaduploadral.
        handle_downloaduploadral(
          EXPORTING
            io_tech_request_context  = io_tech_request_context
          IMPORTING
            es_downloadmigrationfile = ls_download_migration_file ).
        copy_data_to_ref( EXPORTING is_data = ls_download_migration_file
                          CHANGING  cr_data = er_data ).
      WHEN co_action_downloadcorrectral.
        handle_downloadcorrectral(
          EXPORTING
            io_tech_request_context  = io_tech_request_context
          IMPORTING
            es_migrationfiletemplate = ls_migration_file_template ).
        copy_data_to_ref( EXPORTING is_data = ls_migration_file_template
                          CHANGING  cr_data = er_data ).
      WHEN co_action_downloadtaskral.
        handle_downloadtaskral(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            es_downloadtaskfileral  = ls_migration_task_value ).
        copy_data_to_ref( EXPORTING is_data = ls_migration_task_value
                          CHANGING  cr_data = er_data ).
      WHEN co_action_check_dev_class.
        handle_check_dev_class(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data ).
      WHEN co_action_check_db_connection.
        handle_check_db_connection(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data ).
      WHEN co_action_check_rfc_connection.
        handle_check_rfc_connection(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data ).
      WHEN co_action_check_copy_project.
        handle_check_copy_project(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data ).
      WHEN co_consistent_check.
        handle_data_consistent_check(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data ).
      WHEN co_action_ind_process_action.
        instance_ind_process(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data ).
*        CATCH /iwbep/cx_mgw_busi_exception. " Business Exception
      WHEN co_action_get_forward_navi.
        handle_get_forward_navi(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data
        ).
      WHEN co_action_cancel_activity.
        handle_cancel_activity(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data
        ).
      WHEN co_check_auth.
        handle_check_auth(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_data                 = er_data
        ).
      WHEN co_download_mo_instance.
        handle_download_instance(
          EXPORTING
            io_tech_request_context    = io_tech_request_context
          IMPORTING
            es_migrationinstancedownload = ls_migrationinstancedownload ).
        copy_data_to_ref( EXPORTING is_data = ls_migrationinstancedownload
                          CHANGING  cr_data = er_data ).
      WHEN co_action_instance_downloadral.
        handle_download_instance_ral(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            es_migrationinstance    = ls_instancedownload_ral ).
        copy_data_to_ref( EXPORTING is_data = ls_instancedownload_ral
                          CHANGING  cr_data = er_data ).

      WHEN co_action_mo_download_message.
        handle_download_message(
          EXPORTING
            io_tech_request_context        = io_tech_request_context
          IMPORTING
            es_migrationobjectmessagedownl = ls_migrationobjectmessagedownl ).
        copy_data_to_ref( EXPORTING is_data = ls_migrationobjectmessagedownl
                          CHANGING  cr_data = er_data ).
      WHEN co_action_download_messageral.
        handle_download_messageral(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            es_downloadmessage      = ls_migration_file_template ).
        copy_data_to_ref( EXPORTING is_data = ls_migration_file_template
                          CHANGING  cr_data = er_data ).

      WHEN co_action_messageoverview_ral.
        handle_messageoverdetailral(
          EXPORTING
            io_tech_request_context    = io_tech_request_context
          IMPORTING
            es_downloadmessageoverview = ls_messageoverviewdetail ).
        copy_data_to_ref( EXPORTING is_data = ls_messageoverviewdetail
                          CHANGING  cr_data = er_data ).
      WHEN co_objectmessage_ral.
        handle_objectmessages(
          EXPORTING
            io_tech_request_context   = io_tech_request_context
          IMPORTING
            es_migrationobjectmessage = ls_objectmessage ).
        copy_data_to_ref( EXPORTING is_data = ls_objectmessage
                          CHANGING  cr_data = er_data ).

      WHEN co_downloadappllogral.

        handle_applicationlogral(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            es_downloadapplog       = ls_appllog ).
        copy_data_to_ref( EXPORTING is_data = ls_appllog
                          CHANGING  cr_data = er_data ).

      WHEN  co_messagedetail_ral.
        handle_insmesdetailral(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            es_downloaddetail       = ls_detail ).
        copy_data_to_ref( EXPORTING is_data = ls_detail
                          CHANGING  cr_data = er_data ).

      WHEN co_delete_csv_file.

      WHEN co_check_before_del_task_value.
        check_before_del_task_value(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            es_process_result       = ls_process_result ).
        copy_data_to_ref( EXPORTING is_data = ls_process_result
                          CHANGING  cr_data = er_data ).
      WHEN co_is_instance_in_mo.
        check_is_instance_in_mo(
          EXPORTING
            io_tech_request_context = io_tech_request_context
          IMPORTING
            es_process_result       = ls_process_result ).

        copy_data_to_ref( EXPORTING is_data = ls_process_result
                          CHANGING  cr_data = er_data ).
      WHEN OTHERS.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid = /iwbep/cx_mgw_busi_exception=>resource_not_found.
    ENDCASE.
  ENDMETHOD.


METHOD /iwbep/if_mgw_appl_srv_runtime~get_entity.

  "For security purpose, at the very beginning, check authorization
  check_display_auth_for_request( ).


  super->/iwbep/if_mgw_appl_srv_runtime~get_entity(
    EXPORTING
      iv_entity_name          = iv_entity_name
      iv_entity_set_name      = iv_entity_set_name
      iv_source_name          = iv_source_name
      it_key_tab              = it_key_tab
      it_navigation_path      = it_navigation_path
      io_tech_request_context = io_tech_request_context
    IMPORTING
      er_entity               = er_entity
      es_response_context     = es_response_context
  ).

ENDMETHOD.


METHOD /iwbep/if_mgw_appl_srv_runtime~get_entityset.

  "For security purpose, at the very beginning, check authorization
  check_display_auth_for_request( ).

  super->/iwbep/if_mgw_appl_srv_runtime~get_entityset(
        EXPORTING
          iv_entity_name = iv_entity_name
          iv_entity_set_name = iv_entity_set_name
          iv_source_name = iv_source_name
          it_filter_select_options = it_filter_select_options
          it_order = it_order
          is_paging = is_paging
          it_navigation_path = it_navigation_path
          it_key_tab = it_key_tab
          iv_filter_string = iv_filter_string
          iv_search_string = iv_search_string
          io_tech_request_context = io_tech_request_context
       IMPORTING
         er_entityset = er_entityset
         es_response_context = es_response_context ).
ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_is_conditional_implemented.

*    IF iv_operation_type EQ /iwbep/if_mgw_appl_types=>gcs_operation_type-update_entity
*    AND iv_entity_set_name = 'MigrationProjectSet'.
*      rv_conditional_active = abap_true.
*    ENDIF.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.
    DATA ls_stream TYPE ty_s_media_resource.

    "For security purpose, at the very beginning, check authorization
    check_execute_auth_for_request( ).

    check_system_upgrade( ).
    CLEAR er_stream.
    CLEAR es_response_context.

    CASE iv_entity_name.
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_migrationprojectdownload.
        ls_stream = get_project_content_stream( it_key_tab ).
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_migrationfiletemplate.
        ls_stream = get_file_proc_stream( it_key_tab ).
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_stagingtablefieldcsv.
        ls_stream = get_stm_staging_tab_fld_csv( it_key_tab ).
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_downloadmigrationfile.
        ls_stream = get_stm_file_download( it_key_tab ).
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_migrationinstancedownload.
        ls_stream = get_stm_mo_instance( it_key_tab ).
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_migrationtasktemplate.
        ls_stream = get_stm_task_template( it_key_tab ).
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_migrationtaskvaluefile.
        ls_stream = get_stm_task_value( it_key_tab ).
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_downloadtaskfile.
        ls_stream = get_stm_task_file( it_key_tab ).
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_migrationobjectmessagedownl.
        ls_stream = get_stm_mo_message( it_key_tab ).
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_downloadcsvfile.
        ls_stream = get_stm_csv_file( it_key_tab ).
    ENDCASE.

    IF iv_entity_name NE /ltb/cl_mig_mc_odata_mpc=>gc_migrationobjectmessagedownl AND
       ls_stream-value IS INITIAL.
      es_response_context-no_content = abap_true.
      RETURN.
    ENDIF.

    copy_data_to_ref( EXPORTING is_data = ls_stream
                      CHANGING  cr_data = er_stream ).

  ENDMETHOD.


METHOD /iwbep/if_mgw_appl_srv_runtime~update_entity.

  "For security purpose, at the very beginning, check authorization
  check_execute_auth_for_request( ).

  super->/iwbep/if_mgw_appl_srv_runtime~update_entity(
    EXPORTING
      iv_entity_name          = iv_entity_name
      iv_entity_set_name      = iv_entity_set_name
      iv_source_name          = iv_source_name
      io_data_provider        = io_data_provider
      it_key_tab              = it_key_tab
      it_navigation_path      = it_navigation_path
      io_tech_request_context = io_tech_request_context
    IMPORTING
      er_entity               = er_entity
    ).

ENDMETHOD.


  METHOD activitymonito01_get_entityset.
    DATA: lv_project_uuid TYPE /ltb/mc_proj_uuid,
          lt_order        TYPE /iwbep/t_mgw_sorting_order,
          lo_contx        TYPE REF TO /ltb/cl_mc_cntxt_query.

    CONSTANTS: co_proj_uuid          TYPE string VALUE 'MigrationProjectUUID',
               co_default_sort_field TYPE string VALUE 'EventStartedAt'.

    CASE iv_source_name.
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_migrationproject.
        "Project activity monitor detail
        TRY.
            IF line_exists( it_key_tab[ name = co_proj_uuid ] ).
              lv_project_uuid = it_key_tab[ name = co_proj_uuid ]-value.
            ENDIF.
            DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
            DATA(lo_proj_context) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
            lo_contx = lo_proj_context.
            lt_order = it_order.
            IF lt_order IS INITIAL.
              "set default order by EventTimeAt entityname descending
              lt_order = VALUE #( ( property = co_default_sort_field
                                    order    = co_sort_descending ) ).
            ENDIF.

            IF it_filter_select_options IS INITIAL AND iv_filter_string IS NOT INITIAL.
              "Handle complec filter
              DATA(lt_filter_select_options) = get_complex_filter_sel_option(
                EXPORTING
                  io_tech_request_context = io_tech_request_context
                  iv_entity_name          = iv_entity_name ).
            ELSE.
              lt_filter_select_options = it_filter_select_options.
            ENDIF.
            set_context( iv_entity_set_name = iv_entity_set_name
              is_paging = is_paging
              iv_search_string = iv_search_string
              it_order = lt_order
              it_filter_select_options = lt_filter_select_options
              io_context = lo_contx ).

            lo_project->get_activity_monitor_detail(
              EXPORTING
                io_cntxt = lo_contx
              IMPORTING
                et_activity = DATA(lt_activity)
                ev_count    = DATA(lv_count) ).

          CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
            raise_bussiness_exception(
              EXPORTING
                iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
                iv_message_unlimited = lo_exception->get_text( )
            ).

        ENDTRY.

        et_entityset = VALUE #( FOR activity IN lt_activity
                                ( migrationprojectuuid = lv_project_uuid
                                  activityobjecttype   = activity-activity_object_type
                                  activityobjecttypeid = activity-activity_object_typeid
                                  activityobjectname   = activity-activity_object_name
                                  migrationobjectuuid  = activity-migration_object_uuid
                                  migrationtaskuuid    = activity-migration_task_uuid
                                  eventuuid            = activity-event_uuid
                                  eventtypeid          = activity-event_type_id
                                  eventtype            = activity-event_type
                                  eventstatusid        = activity-event_status_id
                                  eventstatus          = activity-event_status
                                  eventdescr           = activity-event_descr
                                  eventstartedat       = activity-event_started_at
                                  eventstartedby       = activity-event_started_by
                                  activejobs           = activity-active_jobs
                                  settingjobs          = activity-setting_jobs
                                  eventfinishedat      = activity-event_finished_at
                                  itemsprocessed       = activity-item_processed
                                  itemstotal           = activity-item_total
                                  actions              = activity-actions
                                  eventactivityuuid    = activity-event_activity_uuid
                                  filename             = activity-filename
                                  appllognr            = activity-appl_lognr
                                 ) ).

        es_response_context-inlinecount = lv_count.  " handle paging functionality

        IF io_tech_request_context->has_count( ) = abap_true.
          es_response_context-count = lv_count.
          RETURN.
        ENDIF.

      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.


  METHOD activitymonito02_get_entityset.
    DATA: lv_project_uuid TYPE /ltb/mc_proj_uuid,
          lt_order        TYPE /iwbep/t_mgw_sorting_order,
          lo_contx        TYPE REF TO /ltb/cl_mc_cntxt_query.

    CONSTANTS: co_proj_uuid          TYPE string VALUE 'MigrationProjectUUID',
               co_default_sort_field TYPE string VALUE 'FieldCode'.

    CASE iv_source_name.
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_migrationproject.

        TRY.
            IF line_exists( it_key_tab[ name = co_proj_uuid ] ).
              lv_project_uuid = it_key_tab[ name = co_proj_uuid ]-value.
            ELSE.
              RETURN.
            ENDIF.
            DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
            DATA(lo_proj_context) = NEW /ltb/cl_mc_cntxt_proj_detail( ).


            lt_order = it_order.
            IF lt_order IS INITIAL.
              "set default order by EventTimeAt entityname descending
              lt_order = VALUE #( ( property = co_default_sort_field
                                    order    = co_sort_descending ) ).
            ENDIF.

            set_context( iv_entity_set_name = iv_entity_set_name
                      is_paging = is_paging
                      iv_search_string = iv_search_string
                      it_order = lt_order
                      it_filter_select_options = it_filter_select_options
                      io_context = lo_proj_context ).

            lo_project->get_event_filter_values(
              EXPORTING
                io_cntxt = lo_proj_context
              IMPORTING
                et_filter_values = DATA(lt_filter_values)
                ev_count         = DATA(lv_count) ).

            et_entityset = VALUE #( FOR value IN lt_filter_values
                                   ( fieldcode = value-field_code
                                     filtervalue = value-filter_value
                                     filterdescription = value-filter_descr ) ).
          CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
            raise_bussiness_exception(
              EXPORTING
                iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
                iv_message_unlimited = lo_exception->get_text( )
            ).
        ENDTRY.
    ENDCASE.
    es_response_context-inlinecount = lv_count.  " handle paging functionality

    IF io_tech_request_context->has_count( ) = abap_true.
      es_response_context-count = lv_count.
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD activitymonitors_get_entityset.
    DATA: lv_project_uuid TYPE /ltb/mc_proj_uuid,
          lt_order        TYPE /iwbep/t_mgw_sorting_order,
          lo_contx        TYPE REF TO /ltb/cl_mc_cntxt_query.

    CONSTANTS: co_proj_uuid          TYPE string VALUE 'MigrationProjectUUID',
               co_default_sort_field TYPE string VALUE 'EventTimeAt'.

    CASE iv_source_name.
      WHEN /ltb/cl_mig_mc_odata_mpc=>gc_migrationproject.
        "Project activity monitor
        TRY.
            IF line_exists( it_key_tab[ name = co_proj_uuid ] ).
              lv_project_uuid = it_key_tab[ name = co_proj_uuid ]-value.
            ENDIF.
            DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
            DATA(lo_proj_context) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
            lo_contx = lo_proj_context.
            lt_order = it_order.
            IF lt_order IS INITIAL.
              "set default order by EventTimeAt entityname descending
              lt_order = VALUE #( ( property = co_default_sort_field
                                    order    = co_sort_descending ) ).
            ENDIF.
            set_context( iv_entity_set_name = iv_entity_set_name
              is_paging = is_paging
              iv_search_string = iv_search_string
              it_order = lt_order
              it_filter_select_options = it_filter_select_options
              io_context = lo_contx ).

            lo_project->get_activity_monitor(
              EXPORTING
                io_cntxt = lo_contx
              IMPORTING
                et_activity = DATA(lt_activity)
                ev_count    = DATA(lv_count) ).
          CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
            raise_bussiness_exception(
              EXPORTING
                iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
                iv_message_unlimited = lo_exception->get_text( )
            ).

        ENDTRY.
        et_entityset = VALUE #( FOR activity IN lt_activity
                                ( migrationprojectuuid = lv_project_uuid
                                  activityobjecttype   = activity-activity_object_type
                                  activityobjectuuid   = activity-activity_object_uuid
                                  activityobjectname   = activity-activity_object_name
                                  eventuuid            = activity-event_uuid
                                  eventtypeid          = activity-event_type_id
                                  eventtype            = activity-event_type
                                  eventstatusid        = activity-event_status_id
                                  eventstatus          = activity-event_status
                                  eventdescr           = activity-event_descr
                                  eventtimeat          = activity-event_time_at
                                  eventactivityuuid    = activity-event_activity_uuid
                                  filename             = activity-file_name
                                  appllognr            = activity-appl_lognr
                                 ) ).

        es_response_context-inlinecount = lv_count.  " handle paging functionality

        IF io_tech_request_context->has_count( ) = abap_true.
          es_response_context-count = lv_count.
          RETURN.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.


  METHOD activitytrackset_get_entityset.
    DATA: lv_project_uuid TYPE /ltb/mc_proj_uuid,
          lt_order        TYPE /iwbep/t_mgw_sorting_order,
          lo_contx        TYPE REF TO /ltb/cl_mc_cntxt_query.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF io_tech_request_context->get_source_entity_set_name( ) IS NOT INITIAL.
      READ TABLE it_key_tab WITH KEY name = co_migration_project_uuid INTO DATA(ls_key).
      lv_project_uuid = ls_key-value.

      TRY.
          DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
          DATA(lo_proj_context) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
          " set query context: paging, full search, order, filter
          lo_contx = lo_proj_context.
          lt_order = it_order.
          IF lt_order IS INITIAL.
            "set default order by EventTimeAt entityname descending
            lt_order = VALUE #( ( property = 'EventTimeAt'
                      order    = co_sort_descending ) ).
          ENDIF.
          set_context( iv_entity_set_name = iv_entity_set_name
            is_paging = is_paging
            iv_search_string = iv_search_string
            it_order = lt_order
            it_filter_select_options = it_filter_select_options
            io_context = lo_contx ).

          "get activity tracking history
          lo_project->get_activities(
            EXPORTING
              io_cntxt = lo_contx
            IMPORTING
              et_activity = DATA(lt_activity)
              ev_count    = DATA(lv_count) ).
        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
          raise_bussiness_exception(
            EXPORTING
              iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
              iv_message_unlimited = lo_exception->get_text( )
          ).

      ENDTRY.

      et_entityset = VALUE #( FOR activity IN lt_activity
                              ( eventuuid            = activity-event_uuid
                                eventtypeid          = activity-event_action_id
                                eventtype            = activity-event_action
                                eventstatusid        = activity-event_status_id
                                eventstatus          = activity-event_status
                                migrationobjectname  = activity-migobj_descr
                                migrationobjectuuid  = activity-migobj_uuid
                                migrationprojectuuid = lv_project_uuid
                                eventtimeat          = activity-event_time
                                itemsprocessed       = activity-itemsprocessed
                                itemstotal           = activity-itemstotal
                                migrationactivityuuid = activity-act_uuid
                                appllognr             = activity-appllognr
                                numbackgroundjob = activity-no_jobs
                               ) ).

      es_response_context-inlinecount = lv_count.  " handle paging functionality

      IF io_tech_request_context->has_count( ) = abap_true.
        es_response_context-count = lv_count.
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD applactivitymo01_get_entityset.
    DATA: lt_order  TYPE /iwbep/t_mgw_sorting_order,
          lo_contxt TYPE REF TO /ltb/cl_mc_cntxt_query.

    CONSTANTS: co_default_sort_field TYPE string VALUE 'FieldCode'.


    TRY.
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        " set query context: paging, full search, order, filter
        lo_contxt = lo_cntxt_proj.
        lt_order = it_order.
        IF lt_order IS INITIAL.
          lt_order = VALUE #( ( property = co_default_sort_field
                                order    = co_sort_descending ) ).
        ENDIF.

        set_context( iv_entity_set_name = iv_entity_set_name
          is_paging = is_paging
          iv_search_string = iv_search_string
          it_order = lt_order
          it_filter_select_options = it_filter_select_options
          io_context = lo_contxt ).

        lo_appl_proxy->get_event_filter_values(
          EXPORTING
            io_cntxt = lo_contxt
          IMPORTING
            et_filter_values = DATA(lt_filter_values)
            ev_count    = DATA(lv_count) ).

        et_entityset = VALUE #( FOR value IN lt_filter_values
                       ( fieldcode = value-field_code
                         filtervalue = value-filter_value
                         filterdescription = value-filter_descr ) ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.

    es_response_context-inlinecount = lv_count.  " handle paging functionality

    IF io_tech_request_context->has_count( ) = abap_true.
      es_response_context-count = lv_count.
      RETURN.
    ENDIF.


  ENDMETHOD.


  method APPLACTIVITYMO02_GET_ENTITYSET.
    DATA lv_paging TYPE /iwbep/s_mgw_paging.

    CLEAR es_response_context.
    CLEAR et_entityset.

*    IF io_tech_request_context->get_source_entity_set_name( ) IS NOT INITIAL.
    TRY.
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        lv_paging-skip = 0.
        lv_paging-top = 3. "we only return the top 3 items to client from requirement

        set_context( iv_entity_set_name = iv_entity_set_name
          is_paging = lv_paging
          iv_search_string = iv_search_string
          it_order = it_order
          it_filter_select_options = it_filter_select_options
          io_context = lo_cntxt_proj ).

        "get running or failed activities
        lo_appl_proxy->get_activities_headline(
          EXPORTING
            io_cntxt = lo_cntxt_proj
          IMPORTING
            et_activity = DATA(lt_activity)
            ev_count    = DATA(lv_count) ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.

    et_entityset = VALUE #( FOR activity IN lt_activity
                            ( eventuuid             = activity-event_uuid
                              eventtypeid           = activity-event_action_id
                              eventtype             = activity-event_action
                              eventstatusid         = activity-event_status_id
                              eventstatus           = activity-event_status
                              migrationprojectuuid  = activity-migproj_uuid
                              migrationprojectname  = activity-migproj_descr
                              migrationapproach     = activity-migrationapproach
                              eventtimeat           = activity-event_time
                              itemsprocessed        = activity-itemsprocessed
                              itemstotal            = activity-itemstotal
                              migrationactivityuuid = activity-act_uuid
                              appllognr             = activity-appllognr
                              numbackgroundjob      = activity-no_jobs
                              eventdesc             = activity-event_descr
                              activityobjecttype    = activity-activity_object_type
                             ) ).

    es_response_context-inlinecount = lv_count.  " handle paging functionality

    IF io_tech_request_context->has_count( ) = abap_true.
      es_response_context-count = lv_count.
      RETURN.
    ENDIF.
  endmethod.


  METHOD applactivitymoni_get_entityset.
    DATA: lt_order  TYPE /iwbep/t_mgw_sorting_order,
          lo_contxt TYPE REF TO /ltb/cl_mc_cntxt_query.

    TRY.
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        " set query context: paging, full search, order, filter
        lo_contxt = lo_cntxt_proj.
        lt_order = it_order.
        IF lt_order IS INITIAL.
          "set default order by EventTimeAt entityname descending
          lt_order = VALUE #( ( property = 'EventStartedAt'
                    order    = co_sort_descending ) ).
        ENDIF.

        IF it_filter_select_options IS INITIAL AND iv_filter_string IS NOT INITIAL.
          "Handle complec filter
          DATA(lt_filter_select_options) = get_complex_filter_sel_option(
            EXPORTING
              io_tech_request_context = io_tech_request_context
              iv_entity_name          = iv_entity_name ).
        ELSE.
          lt_filter_select_options = it_filter_select_options.
        ENDIF.

        set_context( iv_entity_set_name = iv_entity_set_name
          is_paging = is_paging
          iv_search_string = iv_search_string
          it_order = lt_order
          it_filter_select_options = lt_filter_select_options
          io_context = lo_contxt ).

        lo_appl_proxy->get_activity_monitor_detail(
          EXPORTING
            io_cntxt = lo_contxt
          IMPORTING
            et_activity = DATA(lt_activity)
            ev_count    = DATA(lv_count) ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.

    et_entityset = VALUE #( FOR activity IN lt_activity
                            ( migrationprojectuuid  = activity-migproj_uuid
                              eventuuid             = activity-event_uuid
                              migrationapproach     = activity-migrationapproach
                              migrationprojectname  = activity-migproj_name
                              activityobjecttypeid  = activity-activity_object_typeid
                              activityobjecttype    = activity-activity_object_type
                              eventtypeid           = activity-event_type_id
                              eventtype             = activity-event_type
                              eventstatusid         = activity-event_status_id
                              eventstatus           = activity-event_status
                              eventdescr            = activity-event_descr
                              eventstartedat        = activity-event_started_at
                              eventstartedby        = activity-event_started_by
                              eventfinishedat       = activity-event_finished_at
                              itemsprocessed        = activity-itemsprocessed
                              itemstotal            = activity-itemstotal
                              actions               = activity-actions
                              eventactivityuuid     = activity-event_activity_uuid
                              appllognr             = activity-appllognr
                             ) ).

    es_response_context-inlinecount = lv_count.  " handle paging functionality

    IF io_tech_request_context->has_count( ) = abap_true.
      es_response_context-count = lv_count.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD applactivitytrac_get_entityset.
    DATA: lt_order TYPE /iwbep/t_mgw_sorting_order,
          lo_contx TYPE REF TO /ltb/cl_mc_cntxt_query.

    CLEAR es_response_context.
    CLEAR et_entityset.

*    IF io_tech_request_context->get_source_entity_set_name( ) IS NOT INITIAL.
    TRY.
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        " set query context: paging, full search, order, filter
        lo_contx = lo_cntxt_proj.
        lt_order = it_order.
        IF lt_order IS INITIAL.
          "set default order by EventTimeAt entityname descending
          lt_order = VALUE #( ( property = 'EventTimeAt'
                    order    = co_sort_descending ) ).
        ENDIF.
        set_context( iv_entity_set_name = iv_entity_set_name
          is_paging = is_paging
          iv_search_string = iv_search_string
          it_order = lt_order
          it_filter_select_options = it_filter_select_options
          io_context = lo_contx ).

        "get activity tracking history
        lo_appl_proxy->get_activities(
          EXPORTING
            io_cntxt = lo_contx
          IMPORTING
            et_activity = DATA(lt_activity)
            ev_count    = DATA(lv_count) ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.

    et_entityset = VALUE #( FOR activity IN lt_activity
                            ( eventuuid             = activity-event_uuid
                              eventtypeid           = activity-event_action_id
                              eventtype             = activity-event_action
                              eventstatusid         = activity-event_status_id
                              eventstatus           = activity-event_status
                              migrationprojectuuid  = activity-migproj_uuid
                              migrationprojectname  = activity-migproj_descr
                              migrationapproach     = activity-migrationapproach
                              eventtimeat           = activity-event_time
                              itemsprocessed        = activity-itemsprocessed
                              itemstotal            = activity-itemstotal
                              migrationactivityuuid = activity-act_uuid
                              appllognr             = activity-appllognr
                              numbackgroundjob      = activity-no_jobs
                             ) ).

    es_response_context-inlinecount = lv_count.  " handle paging functionality

    IF io_tech_request_context->has_count( ) = abap_true.
      es_response_context-count = lv_count.
      RETURN.
    ENDIF.
*    ENDIF.

  ENDMETHOD.


  METHOD applicationlog01_get_entityset.

    DATA: ls_key_pair      TYPE /iwbep/s_mgw_name_value_pair,
          lv_lognr         TYPE balognr,
          ls_filter        TYPE /ltb/if_mc_constants=>gty_filter_cond,
          lt_filter        TYPE /ltb/if_mc_constants=>gtt_filter_cond,
          lv_displayoption TYPE string,
          lv_proj_uuid     TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid      TYPE /ltb/mc_object_uuid.

    TRY.
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        DATA(lo_log_cntxt) = NEW /ltb/cl_mc_cntxt_appl_log( ).

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
        IF sy-subrc = 0.
          lv_proj_uuid = ls_key_pair-value.
        ENDIF.

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
        IF sy-subrc = 0.
          lv_obj_uuid = ls_key_pair-value.
        ENDIF.

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_filter_appllognr.
        IF sy-subrc = 0.
          lv_lognr = ls_key_pair-value.
          lo_log_cntxt->set_lognr( lv_lognr ).
        ENDIF.

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_filter_msgty.
        IF sy-subrc = 0.
          ls_filter-field = co_filter_msgty.
          ls_filter-sign  = 'I'.
          ls_filter-oper  = 'EQ'.
          ls_filter-low = ls_key_pair-value.
          APPEND ls_filter TO lt_filter.
        ENDIF.

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_filter_msgid.
        IF sy-subrc = 0.
          ls_filter-field = co_filter_msgid.
          ls_filter-sign  = 'I'.
          ls_filter-oper  = 'EQ'.
          ls_filter-low = ls_key_pair-value.
          APPEND ls_filter TO lt_filter.
        ENDIF.

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_filter_msgno.
        IF sy-subrc = 0.
          ls_filter-field = co_filter_msgno.
          ls_filter-sign  = 'I'.
          ls_filter-oper  = 'EQ'.
          ls_filter-low = ls_key_pair-value.
          APPEND ls_filter TO lt_filter.
        ENDIF.

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_message_display_option.
        IF sy-subrc = 0.
          lv_displayoption = ls_key_pair-value.
          IF lv_displayoption EQ /ltb/if_mc_constants=>gc_message_display_option-detail.
            READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_filter_msguuid.
            IF sy-subrc = 0.
              ls_filter-field = co_filter_msgnumber.
              ls_filter-sign  = 'I'.
              ls_filter-oper  = 'EQ'.
              ls_filter-low = ls_key_pair-value+20.
              APPEND ls_filter TO lt_filter.
            ELSE.
              READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_filter_messagedetailuuid.
              IF sy-subrc = 0.
                ls_filter-field = co_filter_msgnumber.
                ls_filter-sign  = 'I'.
                ls_filter-oper  = 'EQ'.
                ls_filter-low = ls_key_pair-value+20.
                APPEND ls_filter TO lt_filter.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
        IF lv_displayoption IS INITIAL.
          lv_displayoption = /ltb/if_mc_constants=>gc_message_display_option-group.
        ENDIF.

        IF lt_filter IS NOT INITIAL.
          lo_log_cntxt->set_filter_cond( lt_filter ).
        ENDIF.

        lo_log_cntxt->set_msggroup( iv_msg_group = abap_false ).

        " set query context: paging, full search, order, filter
        set_context( iv_entity_set_name = iv_entity_set_name
          is_paging = is_paging
          iv_search_string = iv_search_string
          it_order = it_order
          io_context = lo_log_cntxt ).

        IF lv_proj_uuid IS NOT INITIAL AND lv_obj_uuid IS NOT INITIAL AND
           lv_proj_uuid NE co_undefined AND lv_obj_uuid NE co_undefined.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
          DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).
          lo_object_proxy->check_authorization( io_cntxt = lo_log_cntxt ).
        ENDIF.

        "get application log
        "with message type&id&number, only one record can be returned
        lo_appl_proxy->get_appl_log(
          EXPORTING io_cntxt = lo_log_cntxt
          IMPORTING et_msg = DATA(lt_msg)
            ev_count = DATA(lv_count)
             ).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    "output
    et_entityset = VALUE #( FOR <item> IN lt_msg
      (
       messagedetailuuid = <item>-msguuid
       displayoption     = lv_displayoption
       messagedetailtitle = <item>-msgtitle
       messagedetailtype = <item>-msgmsgty
       messagedetailtypedesc = get_status_desc( CONV #( <item>-msgmsgty ) )
       messageuuid = <item>-msgmsgid
       messagenumber = <item>-msgmsgno
       messagedetaildatetime = CONV #( floor( <item>-lastdatetime ) )
       appllognr = <item>-appllognr
       messagedetailv1 = <item>-msgmsgv1
       messagedetailv2 = <item>-msgmsgv2
       messagedetailv3 = <item>-msgmsgv3
       messagedetailv4 = <item>-msgmsgv4
      ) ).

    IF io_tech_request_context->has_inlinecount( ) = abap_true.
      es_response_context-inlinecount = lv_count.
    ENDIF.

  ENDMETHOD.


  METHOD applicationlogov_get_entity.
    DATA: lv_proj_uuid      TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid       TYPE /ltb/mc_object_uuid,
          lv_act_uuid       TYPE /ltb/mc_act_uuid,
          ls_key_pair       TYPE /iwbep/s_mgw_name_value_pair,
          lv_lognr          TYPE balognr,
          ls_entity         TYPE /ltb/cl_mig_mc_odata_mpc=>ts_applicationlog,
          lv_is_mo_history  TYPE abap_bool,
          lv_history_type   TYPE string,
          lv_migration_name TYPE string,
          ls_proj_history   TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationprojecthistory,
          ls_object_history TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjecthistory,
          lv_displayoption  TYPE string,
          ls_filter         TYPE /iwbep/s_mgw_select_option,
          ls_filter_cond    TYPE /iwbep/s_cod_select_option.

    CLEAR es_response_context.
    CLEAR er_entity.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_filter_appllognr.
    IF sy-subrc = 0.
      lv_lognr = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_message_display_option.
    IF sy-subrc = 0.
      lv_displayoption = ls_key_pair-value.
    ENDIF.

    IF lv_displayoption IS INITIAL.
      lv_displayoption = /ltb/if_mc_constants=>gc_message_display_option-group.
    ENDIF.

    TRY.
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        DATA(lo_log_cntxt) = NEW /ltb/cl_mc_cntxt_appl_log( ).
        lo_log_cntxt->set_lognr( lv_lognr ).

        IF lv_displayoption NE /ltb/if_mc_constants=>gc_message_display_option-detail.
          lo_log_cntxt->set_msggroup( iv_msg_group = abap_true ).
        ELSE.
          lo_log_cntxt->set_msggroup( iv_msg_group = abap_false ).
        ENDIF.

        "get application log
        lo_appl_proxy->get_appl_log_count(
          EXPORTING
            io_cntxt = lo_log_cntxt
          IMPORTING
            ev_msg_count     = DATA(lv_msg_count)
            ev_error_count   = DATA(lv_error_count)
            ev_warning_count = DATA(lv_warning_count)
            ev_success_count = DATA(lv_success_count)
            ev_info_count    = DATA(lv_info_count) ).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    er_entity = VALUE #(
       appllognr              = lv_lognr
       displayoption          = lv_displayoption
       messagecount           = lv_msg_count
       errorcount             = lv_error_count
       warningcount           = lv_warning_count
       successcount           = lv_success_count
       infocount              = lv_info_count
       ).

  ENDMETHOD.


  METHOD applicationlogse_get_entity.

    DATA: ls_key_pair       TYPE /iwbep/s_mgw_name_value_pair,
          lv_lognr          TYPE balognr,
          ls_filter         TYPE /ltb/if_mc_constants=>gty_filter_cond,
          lt_filter         TYPE /ltb/if_mc_constants=>gtt_filter_cond,
          lv_proj_uuid      TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid       TYPE /ltb/mc_object_uuid,
          lv_act_uuid       TYPE /ltb/mc_act_uuid,
          lv_is_mo_history  TYPE abap_bool,
          lv_history_type   TYPE string,
          lv_migration_name TYPE string,
          ls_proj_history   TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationprojecthistory,
          ls_object_history TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjecthistory,
          lt_key_tab        TYPE /iwbep/t_mgw_name_value_pair,
          lv_displayoption  TYPE string.
    TRY.
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        DATA(lo_log_cntxt) = NEW /ltb/cl_mc_cntxt_appl_log( ).

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_filter_appllognr.
        IF sy-subrc = 0.
          lv_lognr = ls_key_pair-value.
          lo_log_cntxt->set_lognr( lv_lognr ).
        ENDIF.

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
        IF sy-subrc = 0.
          lv_proj_uuid = ls_key_pair-value.
        ENDIF.

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
        IF sy-subrc = 0.
          lv_obj_uuid = ls_key_pair-value.
          IF lv_obj_uuid IS NOT INITIAL AND
             lv_obj_uuid <> co_undefined.
            lv_is_mo_history = abap_true.
          ENDIF.
        ENDIF.

        "Change the key-name to migration object history/project history
        lt_key_tab = it_key_tab.
        READ TABLE lt_key_tab ASSIGNING FIELD-SYMBOL(<ls_key_pair>) WITH KEY name = co_migration_history_uuid.
        IF sy-subrc = 0.
          IF lv_is_mo_history = abap_true.
            <ls_key_pair>-name = co_migration_obj_history_uuid.
          ELSE.
            <ls_key_pair>-name = co_migration_proj_history_uuid.
          ENDIF.
        ENDIF.

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_filter_msgty.
        IF sy-subrc = 0.
          ls_filter-field = co_filter_msgty.
          ls_filter-sign  = 'I'.
          ls_filter-oper  = 'EQ'.
          ls_filter-low = ls_key_pair-value.
          APPEND ls_filter TO lt_filter.
        ENDIF.

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_filter_msgid.
        IF sy-subrc = 0.
          ls_filter-field = co_filter_msgid.
          ls_filter-sign  = 'I'.
          ls_filter-oper  = 'EQ'.
          ls_filter-low = ls_key_pair-value.
          APPEND ls_filter TO lt_filter.
        ENDIF.

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_filter_msgno.
        IF sy-subrc = 0.
          ls_filter-field = co_filter_msgno.
          ls_filter-sign  = 'I'.
          ls_filter-oper  = 'EQ'.
          ls_filter-low = ls_key_pair-value.
          APPEND ls_filter TO lt_filter.
        ENDIF.

        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_message_display_option.
        IF sy-subrc = 0.
          lv_displayoption = ls_key_pair-value.
        ENDIF.

        IF lv_displayoption IS INITIAL.
          lv_displayoption = /ltb/if_mc_constants=>gc_message_display_option-group.
        ENDIF.

        IF lv_displayoption NE /ltb/if_mc_constants=>gc_message_display_option-detail.
          lo_log_cntxt->set_msggroup( iv_msg_group = abap_true ).
        ELSE.
          READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_filter_msguuid.
          IF sy-subrc = 0.
            ls_filter-field = co_filter_msgnumber.
            ls_filter-sign  = 'I'.
            ls_filter-oper  = 'EQ'.
            ls_filter-low = ls_key_pair-value+20.
            APPEND ls_filter TO lt_filter.
          ENDIF.
          lo_log_cntxt->set_msggroup( iv_msg_group = abap_false ).
        ENDIF.

        IF lt_filter IS NOT INITIAL.
          lo_log_cntxt->set_filter_cond( lt_filter ).
        ENDIF.

        IF lv_proj_uuid IS NOT INITIAL AND lv_obj_uuid IS NOT INITIAL AND
           lv_proj_uuid NE co_undefined AND lv_obj_uuid NE co_undefined.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
          DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).
          lo_object_proxy->check_authorization( io_cntxt = lo_log_cntxt ).
        ENDIF.

        "get application log
        "with message type&id&number, only one record can be returned
        lo_appl_proxy->get_appl_log(
          EXPORTING
            io_cntxt = lo_log_cntxt
          IMPORTING
            et_msg   = DATA(lt_msg)
            ev_count = DATA(lv_count) ).

        IF lv_is_mo_history = abap_true.
          me->migrationobjec02_get_entity(
            EXPORTING
              iv_entity_name     = iv_entity_name
              iv_entity_set_name = iv_entity_set_name
              iv_source_name     = iv_source_name
              it_navigation_path = it_navigation_path
              it_key_tab         = lt_key_tab
            IMPORTING
              er_entity          = ls_object_history ).
          lv_history_type   = ls_object_history-migrationobjecthistorytype.
          lv_migration_name = ls_object_history-migrationobjectname.
          lv_proj_uuid      = ls_object_history-migrationprojectuuid.
          lv_obj_uuid       = ls_object_history-migrationobjectuuid.
          lv_act_uuid       = ls_object_history-migrationobjecthistoryuuid.
        ELSE.
          me->migrationproje03_get_entity(
            EXPORTING
              iv_entity_name     = iv_entity_name
              iv_entity_set_name = iv_entity_set_name
              iv_source_name     = iv_source_name
              it_navigation_path = it_navigation_path
              it_key_tab         = lt_key_tab
            IMPORTING
              er_entity          = ls_proj_history
              ).
          lv_history_type   = ls_proj_history-migrationprojecthistorytype.
          lv_migration_name = ls_proj_history-migrationprojectname.
          lv_proj_uuid      = ls_proj_history-migrationprojectuuid.
          lv_act_uuid       = ls_proj_history-migrationprojecthistoryuuid.
        ENDIF.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    "output
    READ TABLE lt_msg INTO DATA(item) INDEX 1.

    er_entity = VALUE #(
       msguuid              = item-msguuid
       displayoption        = lv_displayoption
       msgtitle             = item-msgtitle
       msgmsgcnt            = item-msgmsgcnt
       msgmsgty             = item-msgmsgty
       msgmsgid             = item-msgmsgid
       msgmsgno             = item-msgmsgno
       lastdatetime         = floor( item-lastdatetime )
       appllognr            = item-appllognr
       migrationname        = lv_migration_name
       migrationobjectuuid  = lv_obj_uuid
       migrationprojectuuid = lv_proj_uuid
       migrationhistoryuuid = lv_act_uuid
       migrationhistorytype = lv_history_type
       longtext             = get_longtext_from_msg(
                                EXPORTING
                                  iv_msgid = item-msgmsgid
                                  iv_msgno = item-msgmsgno
                                  iv_msgv1 = item-msgmsgv1
                                  iv_msgv2 = item-msgmsgv2
                                  iv_msgv3 = item-msgmsgv3
                                  iv_msgv4 = item-msgmsgv4 )

       ).

  ENDMETHOD.


  METHOD applicationlogse_get_entityset.

    DATA: lv_proj_uuid      TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid       TYPE /ltb/mc_object_uuid,
          lv_act_uuid       TYPE /ltb/mc_act_uuid,
          ls_key_pair       TYPE /iwbep/s_mgw_name_value_pair,
          lv_lognr          TYPE balognr,
          ls_entity         TYPE /ltb/cl_mig_mc_odata_mpc=>ts_applicationlog,
          lv_is_mo_history  TYPE abap_bool,
          lv_history_type   TYPE string,
          lv_migration_name TYPE string,
          ls_proj_history   TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationprojecthistory,
          ls_object_history TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjecthistory,
          lv_displayoption  TYPE string,
          ls_filter         TYPE /iwbep/s_mgw_select_option,
          ls_filter_cond    TYPE /iwbep/s_cod_select_option.

    CLEAR es_response_context.
    CLEAR et_entityset.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
    IF sy-subrc = 0.
      lv_proj_uuid = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
    IF sy-subrc = 0.
      lv_obj_uuid = ls_key_pair-value.
      IF lv_obj_uuid IS NOT INITIAL.
        lv_is_mo_history = abap_true.
      ENDIF.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_history_uuid.
    IF sy-subrc = 0.
      lv_act_uuid = ls_key_pair-value.
    ELSE.
      IF lv_is_mo_history = abap_true.
        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_obj_history_uuid.
        IF sy-subrc = 0.
          lv_act_uuid = ls_key_pair-value.
        ENDIF.
      ELSE.
        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_proj_history_uuid.
        IF sy-subrc = 0.
          lv_act_uuid = ls_key_pair-value.
        ENDIF.
      ENDIF.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_filter_appllognr.
    IF sy-subrc = 0.
      lv_lognr = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_message_display_option.
    IF sy-subrc = 0.
      lv_displayoption = ls_key_pair-value.
    ELSE.
      READ TABLE it_filter_select_options INTO ls_filter WITH KEY property = co_message_display_option.
      IF sy-subrc EQ 0.
        READ TABLE ls_filter-select_options INTO ls_filter_cond INDEX 1.
        IF sy-subrc EQ 0.
          lv_displayoption = ls_filter_cond-low.
        ENDIF.
      ENDIF.
    ENDIF.

    IF lv_displayoption IS INITIAL.
      lv_displayoption = /ltb/if_mc_constants=>gc_message_display_option-group.
    ENDIF.

    TRY.
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        DATA(lo_log_cntxt) = NEW /ltb/cl_mc_cntxt_appl_log( ).
        lo_log_cntxt->set_lognr( lv_lognr ).

        " set query context: paging, full search, order, filter
        set_context(
         EXPORTING
          iv_entity_set_name       = iv_entity_set_name
          is_paging                = is_paging
          iv_search_string         = iv_search_string
          it_order                 = it_order
          it_filter_select_options = it_filter_select_options
          io_context               = lo_log_cntxt ).

        IF lv_proj_uuid IS NOT INITIAL AND lv_obj_uuid IS NOT INITIAL AND
           lv_proj_uuid NE co_undefined AND lv_obj_uuid NE co_undefined.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
          DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).
          lo_object_proxy->check_authorization( io_cntxt = lo_log_cntxt ).
        ENDIF.

        "set flag to differentiate message group or message details
        IF lv_displayoption NE /ltb/if_mc_constants=>gc_message_display_option-detail.
          lo_log_cntxt->set_msggroup( iv_msg_group = abap_true ).
        ELSE.
          lo_log_cntxt->set_msggroup( iv_msg_group = abap_false ).
        ENDIF.

        "get application log
        lo_appl_proxy->get_appl_log(
          EXPORTING
            io_cntxt = lo_log_cntxt
          IMPORTING
            et_msg   = DATA(lt_msg)
            ev_count = DATA(lv_count) ).

        IF lv_is_mo_history = abap_true.
          me->migrationobjec02_get_entity(
            EXPORTING
              iv_entity_name     = iv_entity_name
              iv_entity_set_name = iv_entity_set_name
              iv_source_name     = iv_source_name
              it_navigation_path = it_navigation_path
              it_key_tab         = it_key_tab
            IMPORTING
              er_entity          = ls_object_history
              ).
          lv_history_type   = ls_object_history-migrationobjecthistorytype.
          lv_migration_name = ls_object_history-migrationobjectname.
        ELSE.
          me->migrationproje03_get_entity(
            EXPORTING
              iv_entity_name     = iv_entity_name
              iv_entity_set_name = iv_entity_set_name
              iv_source_name     = iv_source_name
              it_navigation_path = it_navigation_path
              it_key_tab         = it_key_tab
            IMPORTING
              er_entity          = ls_proj_history
              ).
          lv_history_type   = ls_proj_history-migrationprojecthistorytype.
          lv_migration_name = ls_proj_history-migrationprojectname.
        ENDIF.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    "output
    et_entityset = VALUE #( FOR <item> IN lt_msg
      (
       msguuid                 = <item>-msguuid
       displayoption           = lv_displayoption
       msgtitle                = <item>-msgtitle
       msgmsgcnt               = <item>-msgmsgcnt
       msgmsgty                = <item>-msgmsgty
       msgmsgtydesc            = get_status_desc( CONV #( <item>-msgmsgty ) )
       msgmsgid                = <item>-msgmsgid
       msgmsgno                = <item>-msgmsgno
       lastdatetime            = CONV #( floor( <item>-lastdatetime ) )
       appllognr               = <item>-appllognr
       migrationname           = lv_migration_name
       migrationobjecterrorcnt = <item>-migrationobjecterrorcnt
       migrationobjectuuid     = lv_obj_uuid
       migrationprojectuuid    = lv_proj_uuid
       migrationhistoryuuid    = lv_act_uuid
       migrationhistorytype    = lv_history_type
       longtext                = get_longtext_from_msg( iv_msgid = <item>-msgmsgid
                                                     iv_msgno = <item>-msgmsgno )

      ) ).

    IF io_tech_request_context->has_inlinecount( ) = abap_true.
      IF is_paging-top > lv_count.
        es_response_context-count = lv_count.
      ELSE.
        es_response_context-count = is_paging-top.
      ENDIF.
      es_response_context-inlinecount = lv_count.
    ENDIF.
  ENDMETHOD.


  METHOD availabledownl01_get_entityset.
    DATA: lv_proj_uuid     TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid      TYPE /ltb/mc_object_uuid,
          ls_key_pair      TYPE /iwbep/s_mgw_name_value_pair,
          lv_search_string TYPE string,
          lt_fields        TYPE /ltb/if_mc_constants=>gtt_download_field.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobject AND
       iv_entity_name = /ltb/cl_mig_mc_odata_mpc=>gc_availabledownloadmessagefie.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).


          lt_fields = lo_object_proxy->get_msg_download_fields( lo_obj_ctx ).

          et_entityset = VALUE #( FOR data IN lt_fields
                            ( migrationobjectuuid = lv_obj_uuid
                              migrationprojectuuid = lv_proj_uuid
                              fieldname = data-fieldname
                              fieldtechname = data-fieldtechname
                              fielddescription = data-fielddescription
                              fieldtype = data-fieldtype
                             ) ).

          DATA(lv_offset) = io_tech_request_context->get_skip( ).
          DATA(lv_limit) = io_tech_request_context->get_top( ).

          " When offset = lines of entityset, this delete won't be done
          IF lv_offset > 0 AND lv_offset =< lines( et_entityset ).
            DELETE et_entityset TO lv_offset.
          ENDIF.
          IF lv_limit > 0 AND lv_limit < lines( et_entityset ).
            DELETE et_entityset FROM lv_limit + 1.
          ENDIF.

        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD availableresultf_get_entityset.
    DATA: lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid,
          ls_key_pair  TYPE /iwbep/s_mgw_name_value_pair,
          lt_fields    TYPE /ltb/if_mc_constants=>gtt_download_field,
          ls_entity    TYPE /ltb/cl_mig_mc_odata_mpc=>ts_availabledownloadinstancefi.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobject AND
       iv_entity_name = /ltb/cl_mig_mc_odata_mpc=>gc_availabledownloadinstancefi.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      IF line_exists( it_filter_select_options[ property = 'FieldType' ] ).
        DATA(lt_filter) = it_filter_select_options[ property = 'FieldType' ]-select_options.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

          lt_fields = lo_object_proxy->get_result_download_fields( lo_obj_ctx ).

          IF lt_filter IS NOT INITIAL.
            DELETE lt_fields WHERE fieldtype NOT IN lt_filter.
          ENDIF.


          et_entityset = VALUE #( FOR data IN lt_fields
                            ( migrationobjectuuid = lv_obj_uuid
                              migrationprojectuuid = lv_proj_uuid
                              fieldname = data-fieldname
                              fieldtechname = data-fieldtechname
                              fielddescription = data-fielddescription
                              fieldtype = data-fieldtype
                             ) ).

          DATA(lv_offset) = io_tech_request_context->get_skip( ).
          DATA(lv_limit) = io_tech_request_context->get_top( ).

          " When offset = lines of entityset, this delete won't be done
          IF lv_offset > 0 AND lv_offset =< lines( et_entityset ).
            DELETE et_entityset TO lv_offset.
          ENDIF.
          IF lv_limit > 0 AND lv_limit < lines( et_entityset ).
            DELETE et_entityset FROM lv_limit + 1.
          ENDIF.

        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD availabletaskset_get_entityset.
    DATA:
      ls_parameter       TYPE /ltb/cl_mig_mc_odata_mpc=>ts_availabletask,
      lv_search_string   TYPE string,
      lt_sort_orders     TYPE abap_sortorder_tab,
      ls_sort_orders     TYPE abap_sortorder,
      lv_fulltext_search TYPE string.

    CONSTANTS:
      lco_task_desc  TYPE string VALUE 'TASKDESCRIPTION'.


    CLEAR es_response_context.
    CLEAR et_entityset.

    CONSTANTS gc_external_id TYPE balnrext VALUE 'Get Available Task'.


    DATA(lo_log_handler) = cl_dmc_log_handler=>get_or_create_loghandler( im_subobject   = cl_dmc_log_handler=>co_cobj_mnt
                                                                                     im_external_id = gc_external_id ).

    IF NOT io_tech_request_context->get_source_entity_set_name( ) IS INITIAL.
      io_tech_request_context->get_converted_source_keys(
        IMPORTING
          es_key_values = ls_parameter
      ).

      TRY .
          DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
          IF ls_parameter-migrationobjectuuid IS INITIAL.
            "get all task for this project
            DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).
            set_context( iv_entity_set_name = iv_entity_set_name
                         iv_search_string = iv_search_string
                         it_order = it_order
                         it_filter_select_options = it_filter_select_options
                         io_context = lo_cntxt_proj
                         is_paging = is_paging ).
            lo_project->get_all_tasks(
              EXPORTING
                io_cntxt = lo_cntxt_proj            " Context Specific Information
              IMPORTING
                et_data  = DATA(lt_data)
            ).

          ELSE.
            "only get the relevant object's task
            DATA(lo_object_proxy) = lo_project->get_migobj_proxy_by_uuid( iv_obj_uuid = ls_parameter-migrationobjectuuid ).
            DATA(lo_cntxt_obj) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
            set_context( iv_entity_set_name = iv_entity_set_name
             iv_search_string = iv_search_string
             it_order = it_order
             it_filter_select_options = it_filter_select_options
             io_context = lo_cntxt_obj
             is_paging = is_paging ).
            lo_object_proxy->get_all_tasks(
              EXPORTING
                io_cntxt =  lo_cntxt_obj                " Context Specific Information
              IMPORTING
                et_data  =  lt_data
            ).
          ENDIF.

          "hanled full search
          IF line_exists( it_filter_select_options[ property = co_task_descr ] ).
            DATA(lt_select_option) = it_filter_select_options[ property = co_task_descr ]-select_options.
            lv_search_string = lt_select_option[ 1 ]-low.
            SHIFT lv_search_string LEFT DELETING LEADING '*'.
            SHIFT lv_search_string RIGHT DELETING TRAILING '*'.
            CONDENSE lv_search_string.
            LOOP AT lt_data INTO DATA(ls_data).
              IF NOT ls_data-task_descr CS lv_search_string.
                DELETE lt_data WHERE task_uuid = ls_data-task_uuid.
              ENDIF.
            ENDLOOP.
          ENDIF.

          et_entityset = VALUE #( FOR data IN lt_data
                                        ( migrationobjectuuid = ls_parameter-migrationobjectuuid
                                          migrationprojectuuid = ls_parameter-migrationprojectuuid
                                          migrationtaskuuid = data-task_uuid
                                          taskname = data-task_name
                                          taskdescription = data-task_descr
                                          tasktype = data-task_type
                                          taskstatus = data-task_status
                                         ) ).
          IF io_tech_request_context IS SUPPLIED.
            DATA(lt_sort_options) = io_tech_request_context->get_orderby( ).
            lt_sort_orders = VALUE #( FOR <ls_order> IN lt_sort_options
                                      ( name = <ls_order>-property
                                        descending = COND #( WHEN <ls_order>-order = co_sort_descending
                                                             THEN abap_true
                                                             ELSE abap_false
                                                           )
                                      )
                                    ).
            "Sort by name as default
            IF lt_sort_orders IS INITIAL.
              ls_sort_orders-name = lco_task_desc.
              APPEND ls_sort_orders TO lt_sort_orders.
            ENDIF.

            SORT et_entityset BY (lt_sort_orders).

            DATA(lv_offset) = io_tech_request_context->get_skip( ).
            DATA(lv_limit) = io_tech_request_context->get_top( ).

            " When offset = lines of entityset, this delete won't be done
            IF lv_offset > 0 AND lv_offset =< lines( et_entityset ).
              DELETE et_entityset TO lv_offset.
            ENDIF.
            IF lv_limit > 0 AND lv_limit < lines( et_entityset ).
              DELETE et_entityset FROM lv_limit + 1.
            ENDIF.
          ENDIF.
        CATCH /ltb/cx_mc_proxy_error INTO DATA(lo_proxy_exception).
          DATA(lt_mc_messages) = lo_proxy_exception->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lo_cntxt_exception).
          lt_mc_messages = lo_cntxt_exception->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.
    ENDIF.


  ENDMETHOD.


  METHOD check_before_del_task_value.

    DATA: ls_parameter     TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskitem,
          ls_mo_statistics TYPE /ltb/if_mc_constants=>gty_migobj_stats,
          lo_cntxt         TYPE REF TO /ltb/if_mc_cntxt.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
        DATA(lo_object_proxy)  = /ltb/cl_mc_proxy_factory=>get_migobj_proxy_by_uuid( io_project  = lo_project_proxy
                                                                                     iv_obj_uuid = ls_parameter-migrationobjectuuid ).
        DATA(lo_task_proxy)    = /ltb/cl_mc_proxy_factory=>get_task_proxy_by_uuid( io_object    = lo_object_proxy
                                                                                   iv_task_uuid = ls_parameter-migrationtaskuuid ).
        lo_cntxt = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        DATA(lt_migobj_list) = lo_task_proxy->get_used_by_migobj( lo_cntxt ).

        LOOP AT lt_migobj_list ASSIGNING FIELD-SYMBOL(<fs_wu_migobj>).
          lo_object_proxy  = /ltb/cl_mc_proxy_factory=>get_migobj_proxy_by_uuid( io_project  = lo_project_proxy
                                                                                 iv_obj_uuid = <fs_wu_migobj>-object_uuid ).
          ls_mo_statistics = lo_object_proxy->get_statistics( lo_cntxt ).

          IF ls_mo_statistics-num_items_migrated > 0.
            es_process_result-returncode = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.

  ENDMETHOD.


  METHOD check_delete_lock.

    CALL FUNCTION 'ENQUEUE_ECNV_PE_MC_LOCK'
      EXPORTING
        mode_cnv_pe_mc_lock = 'X'
        mandt               = sy-mandt
        owner_id            = iv_proj_uuid
        lock_ident1         = 'DELETE'
      EXCEPTIONS
        foreign_lock        = 1
        system_failure      = 2
        OTHERS              = 3.

    IF sy-subrc = 0.
      CALL FUNCTION 'DEQUEUE_ECNV_PE_MC_LOCK'
        EXPORTING
          mandt       = sy-mandt
          owner_id    = iv_proj_uuid
          lock_ident1 = 'DELETE'.
      rv_locked = abap_false.
    ELSE.
      rv_locked = abap_true.
    ENDIF.

  ENDMETHOD.


METHOD check_display_auth_for_request.
  cl_dmc_authority=>check_display(
    EXCEPTIONS
      no_authority = 1
      OTHERS       = 2 ).
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
      EXPORTING
        "User does not have the sufficient authorizations
        textid = /iwbep/cx_mgw_tech_exception=>missing_authorization.
  ENDIF.

ENDMETHOD.


METHOD check_execute_auth_for_request.
  cl_dmc_authority=>check_execute(
    EXCEPTIONS
      no_authority = 1
      OTHERS       = 2 ).
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
      EXPORTING
        "User does not have the sufficient authorizations
        textid = /iwbep/cx_mgw_tech_exception=>missing_authorization.
  ENDIF.

ENDMETHOD.


  METHOD check_for_upd_and_cus_fld.

    DATA:
      ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
      ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkforupdateandcustomfiel,
      ls_update_custfld     TYPE /ltb/cl_mig_mc_odata_mpc=>ts_contentupdateandcustomfield.

    IF lines( it_changeset_request ) <= /ltb/cl_mc_proj_proxy_mwb=>get_max_num_mig_tmpl( ).
      DATA(online_check) = abap_true.
    ENDIF.

    LOOP AT it_changeset_request ASSIGNING FIELD-SYMBOL(<fs_request>).
      CAST /iwbep/if_mgw_req_func_import( <fs_request>-request_context )->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
      ).

      IF online_check = abap_true.
        TRY.
            DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
            DATA(lo_object_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).

            DATA(ls_result) = lo_object_proxy->check_update_custfield( ).

            ls_update_custfld-iscontentupdaterequired  = ls_result-is_update_required.
            ls_update_custfld-iscustomfieldrequired    = ls_result-is_custfield_required.
            ls_update_custfld-migrationobjectname      = ls_result-migobj_name.
            ls_update_custfld-migrationobjectdesc      = ls_result-migobj_descr.

          CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
            DATA(lt_messages) = lx_exception->get_messages( ).

            IF lt_messages IS INITIAL.
              APPEND VALUE #( msgty = 'E'
                              msgid = lx_exception->if_t100_message~t100key-msgid
                              msgno = lx_exception->if_t100_message~t100key-msgno
                              msgv1 = lx_exception->msgv1
                              msgv2 = lx_exception->msgv2
                              msgv3 = lx_exception->msgv3
                              msgv4 = lx_exception->msgv4 ) TO lt_messages.

            ENDIF.

            LOOP AT lt_messages INTO DATA(ls_message).
              <fs_request>-msg_container->add_message(
                EXPORTING
                  iv_msg_type   = ls_message-msgty
                  iv_msg_id     = ls_message-msgid
                  iv_msg_number = ls_message-msgno
                  iv_msg_v1     = ls_message-msgv1
                  iv_msg_v2     = ls_message-msgv2
                  iv_msg_v3     = ls_message-msgv3
                  iv_msg_v4     = ls_message-msgv4
                  iv_add_to_response_header = abap_true ).
            ENDLOOP.
        ENDTRY.
      ENDIF.

      ls_update_custfld-migrationprojectuuid = ls_parameter-migrationprojectuuid.
      ls_update_custfld-migrationobjectuuid  = ls_parameter-migrationobjectuuid.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_update_custfld
        CHANGING
          cr_data = ls_changeset_response-entity_data ).

      ls_changeset_response-operation_no = <fs_request>-operation_no.
      APPEND ls_changeset_response TO ct_changeset_response.
      CLEAR: ls_update_custfld, ls_changeset_response.
    ENDLOOP.

  ENDMETHOD.


  METHOD check_is_instance_in_mo.

    DATA: ls_parameter     TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          ls_mo_statistics TYPE /ltb/if_mc_constants=>gty_migobj_stats,
          lo_cntxt         TYPE REF TO /ltb/if_mc_cntxt.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
        DATA(lo_object_proxy)  = /ltb/cl_mc_proxy_factory=>get_migobj_proxy_by_uuid( io_project  = lo_project_proxy
                                                                                     iv_obj_uuid = ls_parameter-migrationobjectuuid ).
        lo_cntxt = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        ls_mo_statistics = lo_object_proxy->get_statistics( lo_cntxt ).
        IF ls_mo_statistics-num_items_selected > 0.
          es_process_result-returncode = abap_true.
        ENDIF.

*        es_process_result-returncode = abap_false.
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.

  ENDMETHOD.


METHOD check_project_connection.
  DATA: ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkprojectconnection,
        lv_proj_uuid          TYPE /ltb/mc_proj_uuid,
        ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
        ls_result             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.

  LOOP AT it_changeset_request ASSIGNING FIELD-SYMBOL(<fs_request>).
    CLEAR: ls_parameter, ls_changeset_response,ls_result.

    CAST /iwbep/if_mgw_req_func_import( <fs_request>-request_context )->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter ).
    lv_proj_uuid = ls_parameter-migrationprojectuuid.
    TRY.
        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
        DATA(lo_cntxt) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        ls_result-returncode = lo_proj_proxy->check_db_connection_exist( lo_cntxt ).
      CATCH /ltb/cx_mc_proxy_error /ltb/cx_mc_cntxt_error.
        ls_result-returncode = abap_false.
    ENDTRY.

    copy_data_to_ref(
        EXPORTING
          is_data = ls_result
        CHANGING
          cr_data = ls_changeset_response-entity_data ).

    ls_changeset_response-operation_no = <fs_request>-operation_no.
    APPEND ls_changeset_response TO ct_changeset_response.
  ENDLOOP.

ENDMETHOD.


  METHOD check_projname_availability.
    DATA:
      lv_cnt         TYPE i,
      lt_filter_cond TYPE /ltb/if_mc_constants=>gtt_filter_cond.


    APPEND         VALUE  #(
                  field = /ltb/cl_mig_mc_odata_dpc_ext=>get_entity_components(
                                                                 iv_entity_set_name = 'MigrationProjectSet'
                                                                 iv_component_name  = 'MigrationProjectName'
                                                                 )
                    sign  = 'I'
                    oper  = 'EQ'
                    low   = iv_projname
                    high  = ''
                    ) TO  lt_filter_cond .
    TRY.
        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        lo_cntxt_proj->set_filter_cond(
          EXPORTING
            it_filter_cond = lt_filter_cond ).
        DATA(lo_app_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).


        DATA(lt_project_list) = lo_app_proxy->get_projects( EXPORTING io_cntxt = lo_cntxt_proj
                                                            IMPORTING ev_count = lv_cnt ).

        READ TABLE lt_project_list WITH KEY proj_name = iv_projname TRANSPORTING NO FIELDS.
        IF sy-subrc EQ 0.
          DATA(lx_mgw_bus) = NEW /iwbep/cx_mgw_busi_exception(
            textid = /iwbep/cx_mgw_busi_exception=>business_error
          ).

          lx_mgw_bus->get_msg_container( )->add_message(
            EXPORTING
              iv_msg_type               = 'E'
              iv_msg_id                 = '/LTB/MC'
              iv_msg_number             = '819'
              iv_add_to_response_header = abap_true
          ).

          RAISE EXCEPTION lx_mgw_bus.
        ELSE.
          rv_available = abap_true.

        ENDIF.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        DATA(lt_mc_messages) = lo_exception->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).

    ENDTRY.
  ENDMETHOD.


  METHOD check_system_upgrade.
    "Currently only cloud system needs to check system upgrade status and return message
    DATA(lv_is_cloud) = /ltb/cl_ext_cls_factory=>get_cos_utilities( )->is_cloud( ).
    IF lv_is_cloud = abap_false.
      "RETURN.
    ENDIF.

    IF is_system_upgrade( ) = abap_true.
      DATA(lx_mgw_bus) = NEW /iwbep/cx_mgw_busi_exception(
                                 textid = /iwbep/cx_mgw_busi_exception=>business_error
                                 ).

      lx_mgw_bus->get_msg_container( )->add_message(
        EXPORTING
          iv_msg_type               = 'E'
          iv_msg_id                 = '/LTB/MC'
          iv_msg_number             = '814'
          iv_add_to_response_header = abap_true
      ).

      RAISE EXCEPTION lx_mgw_bus.
    ENDIF.
  ENDMETHOD.


  METHOD check_task_transaction.
    DATA:
      lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
      ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_task,
      ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
      ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checktask,
      lt_tasks              TYPE /ltb/tr_t_id,
      ls_result             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.

    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
      ).

      CLEAR ls_changeset_response.
      ls_entity-migrationprojectuuid = ls_parameter-migrationprojectuuid.
      APPEND ls_parameter-migrationtaskuuid TO lt_tasks.

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_result
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).
      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.

    CHECK lt_tasks IS NOT INITIAL.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_entity-migrationprojectuuid ).
        DATA(lo_cntxt) = NEW /ltb/cl_mc_cntxt_new_proj( ).
        lo_cntxt->set_checked_tasks( it_tasks = lt_tasks ).
        lo_project_proxy->check_tasks( io_cntxt = lo_cntxt ).
      CATCH cx_root INTO DATA(lx_root).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            previous = lx_root.
    ENDTRY.
  ENDMETHOD.


  METHOD check_task_values.
    DATA: lt_value        TYPE /ltb/if_mc_constants=>gtt_value,
          lt_source_value TYPE /ltb/if_mc_constants=>gtt_value_val,
          ls_value        TYPE /ltb/if_mc_constants=>gty_value,
          lr_values       TYPE REF TO data,
          lv_index        TYPE i,
          lv_last_field   TYPE i.

    DATA ls_error         TYPE /ltb/if_mc_constants=>gty_value_error.

    FIELD-SYMBOLS: <lt_values>    TYPE /ltb/if_mc_constants=>gtt_value,
                   <ls_values>    TYPE /ltb/if_mc_constants=>gty_value,
                   <lv_task_item> TYPE any.
    TRY.
        DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( is_task_item-migrationprojectuuid ).
        DATA(lo_object) = lo_project->get_migobj_proxy_by_uuid( is_task_item-migrationobjectuuid ).
        DATA(lo_task) = lo_object->get_task_proxy_by_uuid( is_task_item-migrationtaskuuid ).
        DATA(lo_task_context) = NEW /ltb/cl_mc_cntxt_task_confirm( ).
        lo_task_context->set_task_uuid( iv_task_uuid = is_task_item-migrationtaskuuid ).

        LOOP AT it_task_item INTO DATA(ls_task_item).
          CLEAR ls_value.
          CLEAR lt_source_value.
          CLEAR lv_last_field.
          DO 5 TIMES.
            lv_index = sy-index.
            DATA(lv_fieldname) = 'SOURCEVALUE' && sy-index. "#EC NOTEXT
            ASSIGN COMPONENT lv_fieldname OF STRUCTURE ls_task_item TO <lv_task_item>.
            IF sy-subrc = 0 .
              APPEND <lv_task_item> TO lt_source_value.
              IF <lv_task_item> IS NOT INITIAL.
                lv_last_field = lv_index.
              ENDIF.
            ENDIF.
          ENDDO.
          IF lv_last_field < 5.
            lv_last_field = lv_last_field + 1.
            DELETE lt_source_value FROM lv_last_field.
          ENDIF.
          ls_value-src_val = lt_source_value.
          ls_value-tgt_val = ls_task_item-targetvalue.
          APPEND ls_value TO lt_value.
        ENDLOOP.

        lo_task_context->set_value_mapping( lt_value ).
        rt_errors = lo_task->check_values( io_cntxt = lo_task_context ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        DATA(lt_mc_messages) = lo_exception->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
    ENDTRY.

  ENDMETHOD.


  METHOD check_task_value_transaction.
    DATA:
      lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
      ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskitem,
      lt_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>tt_taskitem,
      ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
      ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checktaskitemvalue,
      lv_message_detail     TYPE string,
      lv_entity_fieldname   TYPE string,
      lv_param_fieldname    TYPE string,
      ls_result             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.

    DATA: lv_exception_happened TYPE abap_bool,
          lv_mismatch           TYPE abap_bool.

    CONSTANTS: lc_sourcevalue TYPE string VALUE 'SOURCEVALUE',
               lc_source      TYPE string VALUE 'SOURCE'.

    FIELD-SYMBOLS: <lv_entity_sourcevalue> TYPE string,
                   <lv_param_source>       TYPE string.

    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      CLEAR ls_entity.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
      ).

      ls_entity-migrationprojectuuid = ls_parameter-projectuuid.
      ls_entity-migrationobjectuuid  = ls_parameter-objectuuid.
      ls_entity-migrationtaskuuid    = ls_parameter-taskuuid.
      ls_entity-targetvalue          = ls_parameter-targetvalue.

      DO 5 TIMES.
        UNASSIGN: <lv_entity_sourcevalue>, <lv_param_source>.
        lv_entity_fieldname = lc_sourcevalue && sy-index.
        lv_param_fieldname  = lc_source && sy-index.
        ASSIGN COMPONENT lv_entity_fieldname OF STRUCTURE ls_entity TO <lv_entity_sourcevalue>.
        ASSIGN COMPONENT lv_param_fieldname OF STRUCTURE ls_parameter TO <lv_param_source>.
        IF <lv_entity_sourcevalue> IS ASSIGNED AND
           <lv_param_source> IS ASSIGNED.
          IF <lv_param_source> EQ get_text( 'BLA' ).
            CLEAR <lv_entity_sourcevalue>.
          ELSE.
            <lv_entity_sourcevalue>        = <lv_param_source>.
          ENDIF.
        ENDIF.
      ENDDO.

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.
      APPEND ls_entity TO lt_entity.
    ENDLOOP.

    TRY.
        DATA(lt_error_message) = check_task_values(
          CHANGING
            is_task_item    = ls_entity
            it_task_item    = lt_entity
        ).

*        CLEAR lt_error_message.
      CATCH /iwbep/cx_mgw_busi_exception INTO DATA(lo_exeception).
        lv_exception_happened = abap_true.
        READ TABLE it_changeset_request INTO ls_changeset_request INDEX 1.
        IF sy-subrc EQ 0.
          DATA(lt_messages) = lo_exeception->message_container->get_messages( ).
          LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<ls_message>).
            IF <ls_message>-message IS NOT INITIAL.
              lv_message_detail = <ls_message>-message.
            ELSE.
              MESSAGE ID <ls_message>-id
                    TYPE <ls_message>-type
                  NUMBER <ls_message>-number
                    WITH <ls_message>-message_v1 <ls_message>-message_v2 <ls_message>-message_v3 <ls_message>-message_v4
                    INTO lv_message_detail.
            ENDIF.
            ls_changeset_request-msg_container->add_message_text_only(
              EXPORTING
                iv_msg_type               = <ls_message>-type
                iv_msg_text               = CONV #( lv_message_detail )
                iv_add_to_response_header = abap_true ).
          ENDLOOP.
        ENDIF.
    ENDTRY.

    LOOP AT it_changeset_request INTO ls_changeset_request ##INTO_OK.

      CLEAR ls_entity.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
      ).

      DO 5 TIMES.
        UNASSIGN: <lv_entity_sourcevalue>, <lv_param_source>.
        lv_entity_fieldname = lc_sourcevalue && sy-index.
        lv_param_fieldname  = lc_source && sy-index.
        ASSIGN COMPONENT lv_entity_fieldname OF STRUCTURE ls_entity TO <lv_entity_sourcevalue>.
        ASSIGN COMPONENT lv_param_fieldname OF STRUCTURE ls_parameter TO <lv_param_source>.
        IF <lv_entity_sourcevalue> IS ASSIGNED AND
           <lv_param_source> IS ASSIGNED.
          IF <lv_param_source> EQ get_text( 'BLA' ).
            CLEAR <lv_entity_sourcevalue>.
          ELSE.
            <lv_entity_sourcevalue>        = <lv_param_source>.
          ENDIF.
        ENDIF.
      ENDDO.

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.

      IF lt_error_message IS NOT INITIAL.
        ls_result-returncode = abap_true.
        LOOP AT lt_error_message INTO DATA(ls_error_message)  ##INTO_OK.
          "IF error message is for this request, set message
          CLEAR lv_mismatch.
          DO 5 TIMES.
            lv_entity_fieldname = lc_sourcevalue && sy-index.
            ASSIGN COMPONENT lv_entity_fieldname OF STRUCTURE ls_entity TO <lv_entity_sourcevalue>.
            IF line_exists( ls_error_message-src_val[ sy-index ] ).
              IF ls_error_message-src_val[ sy-index ] <> <lv_entity_sourcevalue>.
                lv_mismatch = abap_true.
                EXIT.
              ENDIF.
            ELSE.
              IF <lv_entity_sourcevalue> IS NOT INITIAL.
                lv_mismatch = abap_true.
                EXIT.
              ENDIF.
            ENDIF.
          ENDDO.

          IF lv_mismatch = abap_true.
            CONTINUE.
          ENDIF.

          CLEAR lv_message_detail.
          " Don't concatenate the source values for the message to keep consisten witch task check
          lv_message_detail = ls_error_message-error_text.

          ls_changeset_request-msg_container->add_message_text_only(
            EXPORTING
              iv_msg_type               = ls_error_message-error_type
              iv_msg_text               = CONV #( lv_message_detail )
              iv_add_to_response_header = abap_true
          ).
*          EXIT.
        ENDLOOP.
      ENDIF.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_result
        CHANGING
          cr_data = ls_changeset_response-entity_data ).

      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.
  ENDMETHOD.


  METHOD class_constructor.
    DATA lv_default_lang         TYPE spras.

    IF mt_default_text_pool IS INITIAL.
      lv_default_lang = co_default_lang_parameter.
      DATA(lv_class_pool_name) = cl_oo_classname_service=>get_classpool_name( co_class_name ).
      READ TEXTPOOL lv_class_pool_name INTO mt_default_text_pool LANGUAGE lv_default_lang.
    ENDIF.

  ENDMETHOD.


METHOD clear_task_values.

  DATA:
    ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
    ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_task,
    ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_task,
    lt_task_uuid          TYPE /ltb/mc_t_cntxt_info.

  LOOP AT it_changeset_request ASSIGNING FIELD-SYMBOL(<fs_request>).
    CAST /iwbep/if_mgw_req_func_import( <fs_request>-request_context )->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    lt_task_uuid = VALUE #( ( type  = /ltb/if_mc_constants=>gc_cntxt_type-task_uuid
                              value = ls_parameter-migrationtaskuuid ) ).

    CLEAR ls_entity.

    ls_entity-migrationprojectuuid  = ls_parameter-migrationprojectuuid.
    ls_entity-migrationobjectuuid   = ls_parameter-migrationobjectuuid.
    ls_entity-migrationtaskuuid     = ls_parameter-migrationtaskuuid.

    ls_changeset_response-operation_no = <fs_request>-operation_no.

    TRY.

        DATA(lo_proj_proxy)   = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid  ).
        DATA(lo_object_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( ls_parameter-migrationobjectuuid ).
        DATA(lo_cntxt)        = NEW /ltb/cl_mc_cntxt_task_detail( ).

        lo_cntxt->add_values( it_value = lt_task_uuid ).

*        lo_cntxt->add_value( iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-clear_taskitem_indicator
*                             iv_value = CONV #( abap_true ) ).

        lo_object_proxy->clear_task_values( lo_cntxt ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        LOOP AT lt_messages INTO DATA(ls_message).
          <fs_request>-msg_container->add_message(
            EXPORTING
              iv_msg_type   = ls_message-msgty
              iv_msg_id     = ls_message-msgid
              iv_msg_number = ls_message-msgno
              iv_msg_v1     = ls_message-msgv1
              iv_msg_v2     = ls_message-msgv2
              iv_msg_v3     = ls_message-msgv3
              iv_msg_v4     = ls_message-msgv4
              iv_add_to_response_header = abap_true ).

        ENDLOOP.
    ENDTRY.

    copy_data_to_ref(
    EXPORTING
      is_data = ls_entity
    CHANGING
      cr_data = ls_changeset_response-entity_data ).

    APPEND ls_changeset_response TO ct_changeset_response.
    CLEAR: ls_changeset_response.
  ENDLOOP.
ENDMETHOD.


  METHOD clear_transaction.
    CLEAR mv_transaction.
  ENDMETHOD.


  METHOD companiesinmigra_get_entityset.

    DATA: ls_project TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationproject.

    CLEAR es_response_context.
    CLEAR et_entityset.

    io_tech_request_context->get_converted_source_keys(
    IMPORTING
      es_key_values = ls_project
    ).

    TRY.
        "project proxy
        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_project-migrationprojectuuid ).
        DATA(lo_cntxt) = NEW /ltb/cl_mc_cntxt_new_proj( ).
        DATA(lt_bukrs) = lo_proj_proxy->get_selected_bukrs( lo_cntxt ).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    et_entityset = VALUE #( FOR <item> IN lt_bukrs
                    (
                      migrationprojectuuid = ls_project-migrationprojectuuid
                      companycode = <item>-bukrs
                      companycodename = <item>-butxt
                    )
           ).

  ENDMETHOD.


  METHOD companycodevhset_get_entityset.

    TYPES:
      BEGIN OF ty_s_bukrs,
        sign   TYPE sign,
        option TYPE option,
        low    TYPE butxt,
        high   TYPE butxt,
      END OF ty_s_bukrs,

      BEGIN OF ty_s_butxt,
        sign   TYPE sign,
        option TYPE option,
        low    TYPE butxt,
        high   TYPE butxt,
      END OF ty_s_butxt,

      BEGIN OF ty_s_connection,
        sign   TYPE sign,
        option TYPE option,
        low    TYPE string,
        high   TYPE string,
      END OF ty_s_connection.

    CONSTANTS: lc_uuid TYPE string VALUE 'COMPANYCODEUUID',
               lc_name TYPE string VALUE 'COMPANYCODENAME',
               lc_type TYPE string VALUE 'CONNECTIONNAME'.

    DATA: lt_filter_request TYPE /iwbep/t_mgw_select_option,
          ls_filter_request TYPE /iwbep/s_mgw_select_option,
          lt_so_bukrs       TYPE TABLE OF ty_s_bukrs,
          lt_so_butxt       TYPE TABLE OF ty_s_butxt,
          lt_so_connection  TYPE TABLE OF ty_s_connection,
          ls_so_connection  TYPE ty_s_connection,
          lt_filter         TYPE /ltb/if_mc_constants=>gtt_filter_cond.
    CONSTANTS:
      lco_msgid TYPE symsgid VALUE '/LTB/MC',
      lco_msgno TYPE symsgno VALUE '042'.

    CLEAR es_response_context.
    CLEAR et_entityset.

    lt_filter_request = io_tech_request_context->get_filter( )->get_filter_select_options( ).

    LOOP AT lt_filter_request INTO ls_filter_request ##INTO_OK.
      IF ls_filter_request-property = lc_uuid.
        MOVE-CORRESPONDING ls_filter_request-select_options TO lt_so_bukrs.
      ELSEIF ls_filter_request-property = lc_name.
        MOVE-CORRESPONDING ls_filter_request-select_options TO lt_so_butxt.
      ELSEIF ls_filter_request-property = lc_type.
        MOVE-CORRESPONDING ls_filter_request-select_options TO lt_so_connection.
      ENDIF.
    ENDLOOP.

    TRY.
        DATA(lo_cntxt) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        READ TABLE lt_so_connection INTO ls_so_connection INDEX 1.
        lo_cntxt->set_connection_name( ls_so_connection-low ).

        "two filters
        lt_filter = VALUE #( BASE lt_filter
                          FOR <filter> IN lt_so_bukrs
                          (
                            field = 'BUKRS'
                            sign  = <filter>-sign
                            oper  = <filter>-option
                            low   = <filter>-low
                            high  = <filter>-high )
                          ).

        lt_filter = VALUE #( BASE lt_filter
                          FOR filter IN lt_so_butxt
                          (
                            field = 'BUTXT'
                            sign  = filter-sign
                            oper  = filter-option
                            low   = filter-low
                            high  = filter-high )
                          ).

        lo_cntxt->set_filter_cond( lt_filter ).

        DATA(lo_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        DATA(lt_company_codes) = lo_proxy->get_all_bukrs( lo_cntxt ).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.
    IF lt_company_codes IS INITIAL.
*   if no exception raised , but we still don't get the company code, we should raise the warning message
      DATA(lo_msg_container) = me->mo_context->get_message_container( ).
      lo_msg_container->add_message(
          iv_msg_type               =  /iwbep/if_message_container=>gcs_message_type-warning
          iv_msg_id                 =  lco_msgid
          iv_msg_number             =  lco_msgno
          iv_entity_type            =  CONV #( /ltb/cl_mig_mc_odata_mpc=>gc_companycodevh )
          iv_add_to_response_header =  abap_true  " Flag for adding or not the message to the response header
      ).


    ENDIF.
    "output
    et_entityset = VALUE #( FOR <item> IN lt_company_codes
                        (
                          companycodeuuid = <item>-bukrs
                          companycodename = <item>-butxt
                        )
               ).

  ENDMETHOD.


  METHOD confirm_task.

    TRY.
        DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( iv_project_uuid ).
        DATA(lo_object) = lo_project->get_migobj_proxy_by_uuid( iv_object_uuid ).
        DATA(lo_task_context) = NEW /ltb/cl_mc_cntxt_task_confirm( ).
        lo_task_context->set_task_uuid( iv_task_uuid = iv_task_uuid ).
        rt_errors = lo_object->confirm_tasks( io_cntxt = lo_task_context ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        DATA(lt_mc_messages) = lo_exception->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
    ENDTRY.

  ENDMETHOD.


  METHOD confirm_task_transaction.
    DATA:
      lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
      ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_task,
      ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
      ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_confirmtask,
      lv_message_detail     TYPE string,
      lt_task_uuid          TYPE TABLE OF /ltb/mc_task_uuid.

    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
      ).

      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      ls_entity-migrationprojectuuid = ls_parameter-migrationprojectuuid.
      ls_entity-migrationobjectuuid = ls_parameter-migrationobjectuuid.
      ls_entity-migrationtaskuuid = ls_parameter-migrationtaskuuid.

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.

*      TRY.
      DATA(lt_error_message) = confirm_task(
        EXPORTING
          iv_project_uuid =  ls_parameter-migrationprojectuuid
          iv_object_uuid  =   ls_parameter-migrationobjectuuid
          iv_task_uuid    =   ls_parameter-migrationtaskuuid
      ).

      LOOP AT lt_error_message INTO DATA(ls_error_message) ##INTO_OK.

        CLEAR lv_message_detail.
        LOOP AT ls_error_message-src_val INTO DATA(task_value_src) ##INTO_OK.
          CONCATENATE lv_message_detail task_value_src INTO lv_message_detail SEPARATED BY space.
        ENDLOOP.

        IF lv_message_detail IS NOT INITIAL.
          CONCATENATE lv_message_detail ':' ls_error_message-error_text INTO lv_message_detail.
        ELSE.
          lv_message_detail = ls_error_message-error_text.
        ENDIF.

        ls_changeset_request-msg_container->add_message_text_only(
          EXPORTING
            iv_msg_type               = ls_error_message-error_type
            iv_msg_text               = CONV #( lv_message_detail )
            iv_add_to_response_header = abap_true
        ).
      ENDLOOP.

      IF lt_error_message IS NOT INITIAL.
        ls_entity-taskstatus = get_task_status_text( iv_status = /ltb/if_mc_constants=>gc_task_status-open ).
        ls_entity-taskstatusuuid = /ltb/if_mc_constants=>gc_task_status-open.
      ELSE.
        ls_entity-taskstatus = get_task_status_text( iv_status = /ltb/if_mc_constants=>gc_task_status-confirmed ).
        ls_entity-taskstatusuuid = /ltb/if_mc_constants=>gc_task_status-confirmed.
      ENDIF.


*        CATCH /iwbep/cx_mgw_busi_exception INTO DATA(lo_exception).
*          ls_entity-taskstatus = get_task_status_text( iv_status = /ltb/if_mc_constants=>gc_task_status-open ).
*          ls_changeset_request-msg_container->add_messages_from_container(
*                                                io_message_container = lo_exception->get_msg_container( ) ).
*      ENDTRY.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).
      APPEND ls_changeset_response TO ct_changeset_response.

    ENDLOOP.

  ENDMETHOD.


  METHOD confirm_task_values.
    DATA: lt_value        TYPE /ltb/if_mc_constants=>gtt_value,
          lt_source_value TYPE /ltb/if_mc_constants=>gtt_value_val,
          ls_value        TYPE /ltb/if_mc_constants=>gty_value,
          lr_values       TYPE REF TO data,
          lv_index        TYPE i,
          lv_last_field   TYPE i.

    FIELD-SYMBOLS: <lt_values>    TYPE /ltb/if_mc_constants=>gtt_value,
                   <ls_values>    TYPE /ltb/if_mc_constants=>gty_value,
                   <lv_task_item> TYPE any.
    TRY.
        DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( is_task_item-migrationprojectuuid ).
        DATA(lo_object) = lo_project->get_migobj_proxy_by_uuid( is_task_item-migrationobjectuuid ).
        DATA(lo_task) = lo_object->get_task_proxy_by_uuid( is_task_item-migrationtaskuuid ).
        DATA(lo_task_context) = NEW /ltb/cl_mc_cntxt_task_confirm( ).
        lo_task_context->set_task_uuid( iv_task_uuid = is_task_item-migrationtaskuuid ).

        LOOP AT it_task_item INTO DATA(ls_task_item).
          CLEAR ls_value.
          CLEAR lt_source_value.
          CLEAR lv_last_field.
          DO 5 TIMES.
            lv_index = sy-index.
            DATA(lv_fieldname) = 'SOURCEVALUE' && sy-index. "#EC NOTEXT
            ASSIGN COMPONENT lv_fieldname OF STRUCTURE ls_task_item TO <lv_task_item>.
            IF sy-subrc = 0 .
              APPEND <lv_task_item> TO lt_source_value.
              IF <lv_task_item> IS NOT INITIAL.
                lv_last_field = lv_index.
              ENDIF.
            ENDIF.
          ENDDO.
          IF lv_last_field < 5.
            lv_last_field = lv_last_field + 1.
            DELETE lt_source_value FROM lv_last_field.
          ENDIF.
          ls_value-src_val = lt_source_value.
          ls_value-tgt_val = ls_task_item-targetvalue.
          APPEND ls_value TO lt_value.
        ENDLOOP.

        lo_task_context->set_value_mapping( lt_value ).
        rt_errors = lo_task->confirm_values( io_cntxt = lo_task_context ).
        lr_values = lo_task_context->get_value_ref_by_type( /ltb/if_mc_constants=>gc_cntxt_type-value_mapping ).
        ASSIGN lr_values->* TO <lt_values>.
        IF <lt_values> IS ASSIGNED.
          READ TABLE <lt_values> ASSIGNING <ls_values> INDEX 1.
          IF <ls_values> IS ASSIGNED.
            ls_task_item-targetvalue = <ls_values>-tgt_val.
          ENDIF.
        ENDIF.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        DATA(lt_mc_messages) = lo_exception->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
    ENDTRY.

  ENDMETHOD.


  METHOD confirm_task_value_transaction.
    DATA:
      lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
      ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskitem,
      lt_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>tt_taskitem,
      ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
      ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_confirmtaskitemvalue,
      lv_message_detail     TYPE string,
      lv_entity_fieldname   TYPE string,
      lv_param_fieldname    TYPE string,
      lv_error              TYPE abap_bool.
    DATA: lv_exception_happened TYPE abap_bool,
          lv_mismatch           TYPE abap_bool.

    CONSTANTS: lc_sourcevalue TYPE string VALUE 'SOURCEVALUE',
               lc_source      TYPE string VALUE 'SOURCE'.

    FIELD-SYMBOLS: <lv_entity_sourcevalue> TYPE string,
                   <lv_param_source>       TYPE string.

    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      CLEAR ls_entity.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
      ).

      ls_entity-migrationprojectuuid = ls_parameter-projectuuid.
      ls_entity-migrationobjectuuid  = ls_parameter-objectuuid.
      ls_entity-migrationtaskuuid    = ls_parameter-taskuuid.
      ls_entity-targetvalue          = ls_parameter-targetvalue.

      DO 5 TIMES.
        UNASSIGN: <lv_entity_sourcevalue>, <lv_param_source>.
        lv_entity_fieldname = lc_sourcevalue && sy-index.
        lv_param_fieldname  = lc_source && sy-index.
        ASSIGN COMPONENT lv_entity_fieldname OF STRUCTURE ls_entity TO <lv_entity_sourcevalue>.
        ASSIGN COMPONENT lv_param_fieldname OF STRUCTURE ls_parameter TO <lv_param_source>.
        IF <lv_entity_sourcevalue> IS ASSIGNED AND
           <lv_param_source> IS ASSIGNED.
          IF <lv_param_source> EQ get_text( 'BLA' ).
            CLEAR <lv_entity_sourcevalue>.
          ELSE.
            <lv_entity_sourcevalue>        = <lv_param_source>.
          ENDIF.
        ENDIF.
      ENDDO.

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.
      APPEND ls_entity TO lt_entity.

    ENDLOOP.

    TRY.

        DATA(lt_error_message) = confirm_task_values(
          CHANGING
            is_task_item    = ls_entity
            it_task_item    = lt_entity
        ).
      CATCH /iwbep/cx_mgw_busi_exception INTO DATA(lo_exeception).
        lv_exception_happened = abap_true.
        READ TABLE it_changeset_request INTO ls_changeset_request INDEX 1.
        IF sy-subrc EQ 0.
          DATA(lt_messages) = lo_exeception->message_container->get_messages( ).
          LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<ls_message>).
            IF <ls_message>-message IS NOT INITIAL.
              lv_message_detail = <ls_message>-message.
            ELSE.
              MESSAGE ID <ls_message>-id
                    TYPE <ls_message>-type
                  NUMBER <ls_message>-number
                    WITH <ls_message>-message_v1 <ls_message>-message_v2 <ls_message>-message_v3 <ls_message>-message_v4
                    INTO lv_message_detail.
            ENDIF.
            ls_changeset_request-msg_container->add_message_text_only(
              EXPORTING
                iv_msg_type               = <ls_message>-type
                iv_msg_text               = CONV #( lv_message_detail )
                iv_add_to_response_header = abap_true ).
          ENDLOOP.
        ENDIF.
    ENDTRY.

    LOOP AT it_changeset_request INTO ls_changeset_request ##INTO_OK.

      CLEAR ls_entity.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
      ).

      ls_entity-migrationprojectuuid = ls_parameter-projectuuid.
      ls_entity-migrationobjectuuid  = ls_parameter-objectuuid.
      ls_entity-migrationtaskuuid    = ls_parameter-taskuuid.
      ls_entity-targetvalue          = ls_parameter-targetvalue.

      DO 5 TIMES.
        UNASSIGN: <lv_entity_sourcevalue>, <lv_param_source>.
        lv_entity_fieldname = lc_sourcevalue && sy-index.
        lv_param_fieldname  = lc_source && sy-index.
        ASSIGN COMPONENT lv_entity_fieldname OF STRUCTURE ls_entity TO <lv_entity_sourcevalue>.
        ASSIGN COMPONENT lv_param_fieldname OF STRUCTURE ls_parameter TO <lv_param_source>.
        IF <lv_entity_sourcevalue> IS ASSIGNED AND
           <lv_param_source> IS ASSIGNED.
          IF <lv_param_source> EQ get_text( 'BLA' ).
            CLEAR <lv_entity_sourcevalue>.
          ELSE.
            <lv_entity_sourcevalue>        = <lv_param_source>.
          ENDIF.
        ENDIF.
      ENDDO.

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.

      IF lv_exception_happened = abap_false.

        CLEAR lv_error.
        LOOP AT lt_error_message INTO DATA(ls_error_message)  ##INTO_OK.
          "IF error message is for this request, set message
          CLEAR lv_mismatch.
          DO 5 TIMES.
            lv_entity_fieldname = lc_sourcevalue && sy-index.
            ASSIGN COMPONENT lv_entity_fieldname OF STRUCTURE ls_entity TO <lv_entity_sourcevalue>.
            IF line_exists( ls_error_message-src_val[ sy-index ] ).
              IF ls_error_message-src_val[ sy-index ] <> <lv_entity_sourcevalue>.
                lv_mismatch = abap_true.
                EXIT.
              ENDIF.
            ELSE.
              IF <lv_entity_sourcevalue> IS NOT INITIAL.
                lv_mismatch = abap_true.
                EXIT.
              ENDIF.
            ENDIF.
          ENDDO.
          IF lv_mismatch = abap_true.
            CONTINUE.
          ENDIF.
          lv_error = abap_true.

          CLEAR lv_message_detail.
          LOOP AT ls_error_message-src_val INTO DATA(task_value_src) ##INTO_OK.
            IF task_value_src IS NOT INITIAL.
              CONCATENATE lv_message_detail task_value_src INTO lv_message_detail SEPARATED BY space.
            ENDIF.
          ENDLOOP.


          IF lv_message_detail IS NOT INITIAL.
            CONCATENATE lv_message_detail ':' ls_error_message-error_text INTO lv_message_detail.
          ELSE.
            lv_message_detail = ls_error_message-error_text.
          ENDIF.

          ls_changeset_request-msg_container->add_message_text_only(
            EXPORTING
              iv_msg_type               = ls_error_message-error_type
              iv_msg_text               = CONV #( lv_message_detail )
              iv_add_to_response_header = abap_true
          ).
          EXIT.
        ENDLOOP.

      ELSE.
        lv_error = abap_true.
      ENDIF.


      IF lv_error = abap_true.
        ls_entity-taskitemstatus = get_task_status_text( iv_status = /ltb/if_mc_constants=>gc_task_status-open ).
        ls_entity-taskitemstatusuuid = /ltb/if_mc_constants=>gc_task_status-open.
      ELSE.
        ls_entity-taskitemstatus = get_task_status_text( iv_status = /ltb/if_mc_constants=>gc_task_status-confirmed ).
        ls_entity-taskitemstatusuuid = /ltb/if_mc_constants=>gc_task_status-confirmed.
      ENDIF.

      DO 5 TIMES.
        UNASSIGN: <lv_entity_sourcevalue>, <lv_param_source>.
        lv_entity_fieldname = lc_sourcevalue && sy-index.
        lv_param_fieldname  = lc_source && sy-index.
        ASSIGN COMPONENT lv_entity_fieldname OF STRUCTURE ls_entity TO <lv_entity_sourcevalue>.
        ASSIGN COMPONENT lv_param_fieldname OF STRUCTURE ls_parameter TO <lv_param_source>.
        IF <lv_entity_sourcevalue> IS ASSIGNED AND
           <lv_param_source> IS ASSIGNED.
          IF <lv_param_source> EQ get_text( 'BLA' ).
            <lv_entity_sourcevalue>        = <lv_param_source>.
          ENDIF.
        ENDIF.
      ENDDO.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data ).

      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.

  ENDMETHOD.


  METHOD connectionvhset_get_entityset.

    CONSTANTS: lc_uuid TYPE char15 VALUE 'ConnectionUUID',
               lc_name TYPE char15 VALUE 'ConnectionName'.

    DATA: ls_filter_request TYPE /iwbep/s_mgw_select_option,
          ls_filter_option  TYPE /iwbep/s_cod_select_option,
          lt_filter         TYPE /ltb/if_mc_constants=>gtt_filter_cond,
          lv_message        TYPE bal_s_msg.

    CLEAR es_response_context.
    CLEAR et_entityset.

    TRY.
        DATA(lo_cntxt) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        LOOP AT it_filter_select_options INTO ls_filter_request ##INTO_OK.

          CASE ls_filter_request-property.
            WHEN lc_uuid.
              "filter options
              lt_filter = VALUE #( BASE lt_filter
                      FOR <filter> IN ls_filter_request-select_options
                      (
                        field = 'CONN_NAME'
                        sign  = <filter>-sign
                        oper  = <filter>-option
                        low   = <filter>-low
                        high  = <filter>-high )
                      ).
            WHEN lc_name.
              "filter options
              lt_filter = VALUE #( BASE lt_filter
                      FOR <filter> IN ls_filter_request-select_options
                      (
                        field = 'CONN_DESCR'
                        sign  = <filter>-sign
                        oper  = <filter>-option
                        low   = <filter>-low
                        high  = <filter>-high )
                      ).
            WHEN co_filter_approachfortemplate OR co_filter_scenariofortemplate.
              "approach and scenario flag
              READ TABLE ls_filter_request-select_options INTO ls_filter_option INDEX 1.

              IF ls_filter_request-property = co_filter_approachfortemplate.
                lo_cntxt->set_approach( CONV #( ls_filter_option-low ) ).
              ELSEIF ls_filter_request-property = co_filter_scenariofortemplate.
                lo_cntxt->set_scenario( CONV #( ls_filter_option-low ) ).
              ENDIF.
          ENDCASE.

        ENDLOOP.

        lo_cntxt->set_filter_cond( lt_filter ).

        DATA(lo_appl) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        DATA(lo_tmpl) = lo_appl->get_tmpl_proxy_by_appr_scen( lo_cntxt ).
        DATA(lt_conn) = lo_tmpl->get_connections( lo_cntxt ).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).
        IF lt_mc_messages IS INITIAL AND lx_cntxt_error->previous IS NOT INITIAL.
          DATA(lv_msg_txt) = lx_cntxt_error->previous->get_text( ).
          lv_message-msgid = 'DMC_RT_MSG'.
          lv_message-msgno = 000.
          lv_message-msgty = 'E'.
          lv_message-msgv1 = lv_msg_txt.
          APPEND lv_message TO lt_mc_messages.
        ENDIF.
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    SORT lt_conn BY conn_name.

    et_entityset = VALUE #( FOR <item> IN lt_conn
                        (
                          connectionuuid = <item>-conn_name
                          connectionname = <item>-conn_descr
                        )
               ).

  ENDMETHOD.


  METHOD constructor.
    super->constructor( ).
    "DATA(lo_dp_facade) = /iwbep/if_mgw_conv_srv_runtime~get_dp_facade( ).
    "DATA(lt_header_pair) = lo_dp_facade->get_request_header( ).
  ENDMETHOD.


  METHOD convert_file_name.
    DATA file_name_converted TYPE string.
    DATA utf8_c              TYPE string.
    DATA utf8_i              TYPE i.

    DATA(file_name_utf8) = cl_http_utility=>if_http_utility~encode_utf8( iv_file_name ).
    IF file_name_utf8 <> iv_file_name.
      CLEAR file_name_converted.
      DATA(length) = xstrlen( file_name_utf8 ).
      DO length TIMES.
        utf8_i = sy-index - 1.
        utf8_c = file_name_utf8+utf8_i(1).
        CONCATENATE file_name_converted `%` utf8_c INTO file_name_converted.
      ENDDO.

      ev_file_name = file_name_converted.
    ELSE.
      ev_file_name = iv_file_name.
    ENDIF.
  ENDMETHOD.


  METHOD convert_time_stamp.
    CONVERT TIME STAMP iv_timestamp_long_format TIME ZONE sy-zonlo INTO DATE DATA(lv_date) TIME DATA(lv_time).
    CONVERT DATE lv_date TIME lv_time INTO TIME STAMP rv_timestamp TIME ZONE sy-zonlo.
  ENDMETHOD.


  METHOD copyactionset_get_entity.
    CLEAR es_response_context.
    CLEAR er_entity.

    TRY.
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
*        "get copy enabled flag
        CALL METHOD lo_appl_proxy->get_copy_action
          IMPORTING
            ev_dtenabled = DATA(lv_dtenabled)
            ev_fsenabled = DATA(lv_fsenabled).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    er_entity = VALUE #(
       dtenabled          = lv_dtenabled
       fsenabled          = lv_fsenabled
       ).
  ENDMETHOD.


  METHOD copyactionset_get_entityset.
    CLEAR es_response_context.
    CLEAR et_entityset.

    TRY.
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
*        "get copy enabled flag
        CALL METHOD lo_appl_proxy->get_copy_action
          IMPORTING
            ev_dtenabled = DATA(lv_dtenabled)
            ev_fsenabled = DATA(lv_fsenabled).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    APPEND VALUE #(
      dtenabled          = lv_dtenabled
      fsenabled          = lv_fsenabled
      ) TO et_entityset.
  ENDMETHOD.


  METHOD create_csv_bundle.

    DATA:
      lt_xml_file TYPE TABLE OF /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectfileupload,
      lt_csv_file TYPE TABLE OF /ltb/cl_mig_mc_odata_mpc=>ts_uploadcsvbundle,
      ls_csv_file TYPE /ltb/cl_mig_mc_odata_mpc=>ts_uploadcsvbundle,
      lt_errors   TYPE cnv_mbt_t_bal_s_msg.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json        = iv_slug
        pretty_name = /ui2/cl_json=>pretty_mode-camel_case
      CHANGING
        data        = lt_xml_file
    ).

    READ TABLE lt_xml_file ASSIGNING FIELD-SYMBOL(<fs_xml_file>) INDEX 1.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    ls_csv_file = CORRESPONDING #( <fs_xml_file> ).

    DATA(l_offset) = strlen( ls_csv_file-filename ) - 4.

    DATA(l_bundle_name) = ls_csv_file-filename(l_offset).

    DATA(l_exists) = /ltb/cl_mc_fileproc_access=>check_file_name_exist(
      EXPORTING
        iv_proj_guid   = CONV #( ls_csv_file-migrationprojectuuid )
        iv_migobj_guid = CONV #( ls_csv_file-migrationobjectuuid )
        iv_file_name   = CONV #( l_bundle_name )
    ).

    IF l_exists = abap_true.
      APPEND VALUE #( msgty = 'E'
                      msgid = 'DMC_RT_MSG'
                      msgno = '630'
                      msgv1 = l_bundle_name ) TO lt_errors.

      raise_bussiness_exception(
        EXPORTING
          iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
          it_message = lt_errors
      ).
    ENDIF.

    ls_csv_file-csvbundleuuid = /ltb/cl_mc_file_proxy_mwb_csv=>create_csv_bundle(
      EXPORTING
        iv_proj_uuid     = CONV #( ls_csv_file-migrationprojectuuid )
        iv_migobj_uuid   = CONV #( ls_csv_file-migrationobjectuuid )
        iv_filename      = CONV #( l_bundle_name )
    ).

    IF ls_csv_file-csvbundleuuid IS INITIAL.
      APPEND VALUE #( msgty = sy-msgty
                      msgid = sy-msgid
                      msgno = sy-msgno
                      msgv1 = sy-msgv1
                      msgv2 = sy-msgv2
                      msgv3 = sy-msgv3
                      msgv4 = sy-msgv4 ) TO lt_errors.

      raise_bussiness_exception(
        EXPORTING
          iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
          it_message = lt_errors
      ).
    ENDIF.

    INSERT ls_csv_file INTO TABLE lt_csv_file.

    rv_slug = /ui2/cl_json=>serialize( lt_csv_file ).

  ENDMETHOD.


  METHOD csvoptionddlset_get_entityset.

    DATA:
      ls_csvopt_ddl_key TYPE /ltb/cl_mig_mc_odata_mpc=>ts_csvoptionddl,
      lo_csvopt         TYPE REF TO /ltb/if_mc_csv_options.

    IF line_exists( it_filter_select_options[ property = 'OptionName' ] ).
      ls_csvopt_ddl_key-optionname = it_filter_select_options[ property = 'OptionName' ]-select_options[ 1 ]-low.
    ENDIF.

    lo_csvopt = NEW /ltb/cl_mc_csv_options( ).

    DATA(lt_options) = lo_csvopt->get_options( CONV #( ls_csvopt_ddl_key-optionname ) ).

    et_entityset = VALUE #(
      FOR <opt> IN lt_options (
        optionname = ls_csvopt_ddl_key-optionname
        keyvalue   = COND #( WHEN <opt>-key = space THEN /ltb/if_mc_csv_options=>gc_null ELSE <opt>-key )
        keytext    = <opt>-text
      )
    ).

  ENDMETHOD.


  METHOD csvsettingsset_get_entity.

    DATA:
      ls_csvsettings_key TYPE /ltb/cl_mig_mc_odata_mpc=>ts_csvsettings.

    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values = ls_csvsettings_key
    ).

    TRY.
        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_csvsettings_key-migrationprojectuuid ) ).

        DATA(ls_settings) = lo_proj_proxy->get_csv_settings( ).

        er_entity = VALUE #(
          migrationprojectuuid = ls_settings-migrationprojectuuid
          linebreak            = ls_settings-linebreak
          linebreaktext        = ls_settings-linebreaktext
          columndelimiter      = ls_settings-columndelimiter
          columndelimitertext  = ls_settings-columndelimitertext
          cellqualifier        = ls_settings-cellqualifier
          cellqualifiertext    = ls_settings-cellqualifiertext
          escapecharacter      = ls_settings-escapecharacter
          escapecharactertext  = ls_settings-escapecharactertext
          encoding             = ls_settings-encoding
          fileheader           = ls_settings-enable_header
          skiprows             = ls_settings-skiprows
          dateformat           = COND #( WHEN ls_settings-dateformat = space THEN /ltb/if_mc_csv_options=>gc_null ELSE ls_settings-dateformat )
          dateformattext       = ls_settings-dateformattext
          timeformat           = COND #( WHEN ls_settings-timeformat = space THEN /ltb/if_mc_csv_options=>gc_null ELSE ls_settings-timeformat )
          timeformattext       = ls_settings-timeformattext
          decimalnotation      = COND #( WHEN ls_settings-decimalnotation = space THEN /ltb/if_mc_csv_options=>gc_null ELSE ls_settings-decimalnotation )
          decimalnotationtext  = ls_settings-decimalnotationtext
        ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_error).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lx_error->get_messages( )
        ).
    ENDTRY.

  ENDMETHOD.


  METHOD csvsettingsset_update_entity.

    DATA:
      ls_entity_key TYPE /ltb/cl_mig_mc_odata_mpc=>ts_csvsettings.

    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values = ls_entity_key
    ).

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = er_entity
    ).

    DATA(ls_csvopt) = VALUE /ltb/mc_csvopts(
      proj_uuid     = ls_entity_key-migrationprojectuuid
      linebreak     = er_entity-linebreak
      delimiter     = er_entity-columndelimiter
      qualifier     = er_entity-cellqualifier
      escapechar    = er_entity-escapecharacter
      enable_header = er_entity-fileheader
      skip_rows     = er_entity-skiprows
      date_format   = COND #( WHEN er_entity-dateformat      = /ltb/if_mc_csv_options=>gc_null THEN space ELSE er_entity-dateformat )
      time_format   = COND #( WHEN er_entity-timeformat      = /ltb/if_mc_csv_options=>gc_null THEN space ELSE er_entity-timeformat )
      dec_format    = COND #( WHEN er_entity-decimalnotation = /ltb/if_mc_csv_options=>gc_null THEN space ELSE er_entity-decimalnotation )
    ).

    TRY.
        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_entity_key-migrationprojectuuid ) ).

        DATA(lo_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).

        lo_ctx->add_value_ref(
          EXPORTING
            iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-csv_settings
            ir_value = REF #( ls_csvopt )
        ).

        lo_proj_proxy->update_csv_settings( lo_ctx ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_error).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lx_error->get_messages( )
        ).
    ENDTRY.

  ENDMETHOD.


  METHOD datetime_round_down.
    CALL FUNCTION 'ROUND'
      EXPORTING
        input         = iv_datetime
        sign          = '-'
      IMPORTING
        output        = rv_datetime
      EXCEPTIONS
        input_invalid = 1
        overflow      = 2
        type_invalid  = 3
        OTHERS        = 4.
    IF sy-subrc <> 0.
      CLEAR rv_datetime.
    ENDIF.
  ENDMETHOD.


  METHOD delete_csv_files.

    DATA:
      ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
      ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_deletecsvfile,
      ls_return             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_returnmessage.

    LOOP AT it_changeset_request ASSIGNING FIELD-SYMBOL(<fs_request>).
      CAST /iwbep/if_mgw_req_func_import( <fs_request>-request_context )->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
      ).

      TRY.
          DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
          DATA(lo_object_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).
          DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( ls_parameter-migrationfileuuid ) ).

          DATA(lo_csv_bundle) = CAST /ltb/if_mc_csv_bundle( lo_file_proxy ).

          lo_csv_bundle->delete_file( CONV #( ls_parameter-csvfileuuid ) ).

        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
          DATA(lt_messages) = lx_exception->get_messages( ).

          IF lt_messages IS INITIAL.
            APPEND VALUE #( msgty = 'E'
                            msgid = lx_exception->if_t100_message~t100key-msgid
                            msgno = lx_exception->if_t100_message~t100key-msgno
                            msgv1 = lx_exception->msgv1
                            msgv2 = lx_exception->msgv2
                            msgv3 = lx_exception->msgv3
                            msgv4 = lx_exception->msgv4 ) TO lt_messages.

          ENDIF.

          LOOP AT lt_messages INTO DATA(ls_message).
            <fs_request>-msg_container->add_message(
              EXPORTING
                iv_msg_type   = ls_message-msgty
                iv_msg_id     = ls_message-msgid
                iv_msg_number = ls_message-msgno
                iv_msg_v1     = ls_message-msgv1
                iv_msg_v2     = ls_message-msgv2
                iv_msg_v3     = ls_message-msgv3
                iv_msg_v4     = ls_message-msgv4
                iv_add_to_response_header = abap_true ).
          ENDLOOP.
      ENDTRY.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_return
        CHANGING
          cr_data = ls_changeset_response-entity_data ).

      ls_changeset_response-operation_no = <fs_request>-operation_no.
      APPEND ls_changeset_response TO ct_changeset_response.
      CLEAR: ls_changeset_response.
    ENDLOOP.

  ENDMETHOD.


  METHOD delete_instances.

    DATA:
      ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
      ls_instance           TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationinstance,
      lt_instance_uuid      TYPE TABLE OF string.

    LOOP AT it_changeset_request ASSIGNING FIELD-SYMBOL(<fs_request>).

      CAST /iwbep/if_mgw_req_entity_d( <fs_request>-request_context )->get_converted_keys(
        IMPORTING
          es_key_values = ls_instance
      ).

      APPEND ls_instance-migrationinstanceuuid TO lt_instance_uuid.

      ls_changeset_response-operation_no = <fs_request>-operation_no.

      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_instance-migrationprojectuuid ) ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_instance-migrationobjectuuid ) ).

        DATA(lo_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        lo_ctx->add_values( VALUE #( FOR <instance> IN lt_instance_uuid
            (
              type  = /ltb/if_mc_constants=>gc_cntxt_type-instance_uuid
              value = CONV #( <instance> )
            ) )
        ).

        lo_object_proxy->delete_instances( lo_ctx ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).
        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD delete_project_transaction.
    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_deleteproject,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationproject,
          lv_lognr              TYPE balognr,
          lo_log_handler        TYPE REF TO cl_dmc_log_handler,
          lv_error_count        TYPE i VALUE 0.
    CONSTANTS: co_external_id    TYPE balnrext VALUE 'Delete Project'.
    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
       ).
      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      ls_entity-migrationprojectuuid = ls_parameter-migrationprojectuuid.
      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).
      ls_changeset_response-operation_no = ls_changeset_request-operation_no.

      TRY .
          DATA(lv_act_uuid) = /ltb/cl_mc_eventlog_access=>get_new_act_uuid( ).
          lo_log_handler = cl_dmc_log_handler=>get_or_create_loghandler( im_subobject   = cl_dmc_log_handler=>co_cobj_mnt
                                                                     im_external_id = co_external_id ).
          handle_delete_project( io_tech_request_context = lo_request ).
        CATCH /iwbep/cx_mgw_busi_exception INTO DATA(lo_exception).
          lv_error_count += 1.
*          ls_changeset_request-msg_container->add_messages_from_container(
*                                                io_message_container = lo_exception->get_msg_container( ) ).
          DATA(lv_msg_container) = lo_exception->get_msg_container( ).
          DATA(lt_messages) = lv_msg_container->get_messages( ).
          LOOP AT lt_messages INTO DATA(ls_message).
            lo_log_handler->set_message(
            EXPORTING
                im_message_type = ls_message-type
                im_message_id = ls_message-id
                im_message_number = ls_message-number
                im_message_variable_1 = ls_message-message_v1
                im_message_variable_2 = ls_message-message_v2
                im_message_variable_3 = ls_message-message_v3
                im_message_variable_4 = ls_message-message_v4
                ).
          ENDLOOP.
      ENDTRY.
      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.

    IF lv_error_count = 0.
      IF 1 = 0.
        "Project delete successfully
        MESSAGE i121(/ltb/mc).
      ENDIF.
      ls_changeset_request = it_changeset_request[ 1 ].
      ls_changeset_request-msg_container->add_message(
        EXPORTING
          iv_msg_type   = 'I'
          iv_msg_id     = '/LTB/MC'
          iv_msg_number = '121'
          iv_add_to_response_header = abap_true
          ).
    ELSE.
      IF 1 = 0.
        "&1 projects are failed delete, check activity panel for details.
        MESSAGE e122(/ltb/mc).
      ENDIF.
      ls_changeset_request = it_changeset_request[ 1 ].
      ls_changeset_request-msg_container->add_message(
        EXPORTING
          iv_msg_type   = 'E'
          iv_msg_id     = '/LTB/MC'
          iv_msg_number = '122'
          iv_msg_v1     = CONV #( lv_error_count )
          iv_add_to_response_header = abap_true
          ).
    ENDIF.
  ENDMETHOD.


METHOD delete_task_value.

  DATA:
    ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
    ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskitem,
    ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskitem,
    lt_taskitem           TYPE TABLE OF /ltb/cl_mig_mc_odata_mpc=>ts_taskitem,
    lv_entity_fieldname   TYPE string,
    lv_param_fieldname    TYPE string.

  FIELD-SYMBOLS: <lv_entity_sourcevalue> TYPE string,
                 <lv_param_source>       TYPE string.

  CONSTANTS: lc_sourcevalue TYPE string VALUE 'SOURCEVALUE'.


  LOOP AT it_changeset_request ASSIGNING FIELD-SYMBOL(<fs_request>).
    CAST /iwbep/if_mgw_req_func_import( <fs_request>-request_context )->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    CLEAR ls_entity.

    ls_entity-migrationprojectuuid  = ls_parameter-migrationprojectuuid.
    ls_entity-migrationobjectuuid   = ls_parameter-migrationobjectuuid.
    ls_entity-migrationtaskuuid     = ls_parameter-migrationtaskuuid.
    ls_entity-migrationtaskitemuuid = ls_parameter-migrationtaskitemuuid.
    ls_entity-sourcevalue1          = ls_parameter-sourcevalue1.
    ls_entity-sourcevalue2          = ls_parameter-sourcevalue2.
    ls_entity-sourcevalue3          = ls_parameter-sourcevalue3.
    ls_entity-sourcevalue4          = ls_parameter-sourcevalue4.
    ls_entity-sourcevalue5          = ls_parameter-sourcevalue5.

    ls_changeset_response-operation_no = <fs_request>-operation_no.

    copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data ).

    APPEND ls_changeset_response TO ct_changeset_response.
    CLEAR: ls_changeset_response.

    DO 5 TIMES.
      UNASSIGN: <lv_param_source>.
      lv_entity_fieldname = lc_sourcevalue && sy-index.
      ASSIGN COMPONENT lv_entity_fieldname OF STRUCTURE ls_parameter TO <lv_param_source>.
      IF <lv_param_source> IS ASSIGNED.
        IF <lv_param_source> EQ get_text( 'BLA' ).
          CLEAR <lv_param_source>.
        ELSE.

        ENDIF.
      ENDIF.
    ENDDO.

    lt_taskitem = VALUE #( BASE lt_taskitem ( CORRESPONDING #( ls_parameter ) ) ).

  ENDLOOP.

  CHECK lt_taskitem IS NOT INITIAL.

  TRY.

      DATA(lo_proj_proxy)   = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid  ).
      DATA(lo_object_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( ls_parameter-migrationobjectuuid ).
      DATA(lo_task_proxy)   = lo_object_proxy->get_task_proxy_by_uuid( ls_parameter-migrationtaskuuid ).
      DATA(lo_cntxt)        = NEW /ltb/cl_mc_cntxt_task_detail( ).

      lo_cntxt->add_value_ref( iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-task_item
                               ir_value = REF #( lt_taskitem ) ).

      lo_task_proxy->delete_values( lo_cntxt ).

    CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
      DATA(lt_messages) = lx_exception->get_messages( ).

      IF lt_messages IS INITIAL.
        APPEND VALUE #( msgty = 'E'
                        msgid = lx_exception->if_t100_message~t100key-msgid
                        msgno = lx_exception->if_t100_message~t100key-msgno
                        msgv1 = lx_exception->msgv1
                        msgv2 = lx_exception->msgv2
                        msgv3 = lx_exception->msgv3
                        msgv4 = lx_exception->msgv4 ) TO lt_messages.

      ENDIF.

      LOOP AT lt_messages INTO DATA(ls_message).
        <fs_request>-msg_container->add_message(
          EXPORTING
            iv_msg_type   = ls_message-msgty
            iv_msg_id     = ls_message-msgid
            iv_msg_number = ls_message-msgno
            iv_msg_v1     = ls_message-msgv1
            iv_msg_v2     = ls_message-msgv2
            iv_msg_v3     = ls_message-msgv3
            iv_msg_v4     = ls_message-msgv4
            iv_add_to_response_header = abap_true ).
      ENDLOOP.
      raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_messages ).

  ENDTRY.
ENDMETHOD.


  METHOD download_file_template.
    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_downloadfiletemplate,
          lv_project_uuid       TYPE /ltb/mc_proj_uuid,
          lv_prev_project_uuid  TYPE /ltb/mc_proj_uuid,
          lv_object_uuid        TYPE /ltb/mc_object_uuid,
          lt_selected_migobj    TYPE /ltb/mc_t_object_uuid,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationobject,
          ls_mc_message         TYPE bal_s_msg,
          lt_mc_messages        TYPE cnv_mbt_t_bal_s_msg.


    TRY.
        DATA(lo_proj_cntxt) = NEW /ltb/cl_mc_cntxt_proj_detail( ).

        LOOP AT it_changeset_request INTO DATA(ls_changeset_request).
          lo_request ?= ls_changeset_request-request_context.
          lo_request->get_converted_parameters(
              IMPORTING
                es_parameter_values = ls_parameter
          ).
          lv_project_uuid     = ls_parameter-migrationprojectuuid.
          lv_object_uuid      = ls_parameter-migrationobjectuuid.
          IF lv_prev_project_uuid IS NOT INITIAL AND lv_prev_project_uuid <> lv_project_uuid.
            "Error occured during download template for migration object &1
            IF 1 = 0. MESSAGE e129(/ltb/mc) WITH lv_object_uuid. ENDIF.
            ls_mc_message-msgid = '/LTB/MC'.
            ls_mc_message-msgno = '129'.
            ls_mc_message-msgty = 'E'.
            ls_mc_message-msgv1 = lv_object_uuid.
            APPEND ls_mc_message TO lt_mc_messages.
            raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
          ELSE.
            lv_prev_project_uuid = lv_project_uuid.
            "Collect selected migration object UUID
            INSERT lv_object_uuid INTO TABLE lt_selected_migobj.
          ENDIF.
          ls_entity-migrationprojectuuid  = lv_project_uuid .
          ls_entity-migrationobjectuuid   = lv_object_uuid .

          ls_changeset_response-operation_no = ls_changeset_request-operation_no.
          copy_data_to_ref(
          EXPORTING
            is_data = ls_entity
          CHANGING
            cr_data = ls_changeset_response-entity_data ).

          INSERT ls_changeset_response INTO TABLE ct_changeset_response.
        ENDLOOP.
        IF lt_selected_migobj IS INITIAL.
          "this should be avoided from frontend
          RETURN.
        ENDIF.

        lo_proj_cntxt->set_selected_migration_obj( lt_selected_migobj ).
        lo_proj_cntxt->set_proj_uuid( lv_project_uuid ).
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
        CASE TYPE OF lo_project_proxy.
          WHEN TYPE /ltb/cl_mc_proj_proxy_mwb.
            DATA(lv_act_uuid) =  CAST /ltb/cl_mc_proj_proxy_mwb( lo_project_proxy )->download_file_template( lo_proj_cntxt ).
            DATA(lv_max_templates) = cl_dmc_util_factory=>get_rt_parameter_provider( )->get_parameter_value(
                                      if_dmc_rt_parameter_provider=>gc_param_name-migration_max_tmpl_download ).
            IF lv_max_templates = 0.
              lv_max_templates = /ltb/cl_mc_proj_proxy_mwb=>gc_max_templates.
            ENDIF.
            IF lines( lt_selected_migobj ) <= lv_max_templates.
              "Send a message which contains activityuuid to UI for downloading using get_stream
              IF 1 = 0. MESSAGE i124(/ltb/mc). ENDIF.
              ls_changeset_request = it_changeset_request[ 1 ].
              ls_changeset_request-msg_container->add_message(
              EXPORTING
                iv_msg_type   = 'I'
                iv_msg_id     = '/LTB/MC'
                iv_msg_number = '124'
                iv_msg_v1     = CONV #( lv_act_uuid )
                iv_add_to_response_header = abap_true
                ).
            ENDIF.

          WHEN OTHERS.
            "this should not happen
            IF 1 = 0. MESSAGE e131(/ltb/mc). ENDIF.
            ls_mc_message-msgid = '/LTB/MC'.
            ls_mc_message-msgno = '131'. "Download of Excel templates not possible for this project
            ls_mc_message-msgty = 'E'.
            APPEND ls_mc_message TO lt_mc_messages.
            raise_bussiness_exception(
              EXPORTING
                iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
                it_message = lt_mc_messages ).
        ENDCASE.

      CATCH: /ltb/cx_mc_static_check_msg INTO DATA(lx_mc_exception) .
        "Error
        lt_mc_messages = lx_mc_exception->get_messages( ).
        raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
    ENDTRY.

  ENDMETHOD.


  METHOD filterf4valueset_get_entityset.
    TYPES:
      BEGIN OF ty_s_filters,
        sign   TYPE sign,
        option TYPE option,
        low    TYPE string,
        high   TYPE string,
      END OF ty_s_filters.

    DATA lo_filter_proxy    TYPE REF TO /ltb/if_mc_filter_proxy.
    DATA lt_filter_values   TYPE /ltb/if_mc_constants=>gtt_filter_value.
    DATA lt_filter          TYPE /ltb/if_mc_constants=>gtt_filter_cond.

    DATA:
      lt_filter_request TYPE /iwbep/t_mgw_select_option,
      ls_filter_request TYPE /iwbep/s_mgw_select_option,
      lt_so_filters     TYPE TABLE OF ty_s_filters,
      lt_so_descr       TYPE TABLE OF ty_s_filters,
      lt_so_scenario    TYPE TABLE OF ty_s_filters,
      lt_so_approach    TYPE TABLE OF ty_s_filters,
      lt_so_connection  TYPE TABLE OF ty_s_filters,
      ls_so_approach    TYPE ty_s_filters,
      ls_so_scenario    TYPE ty_s_filters,
      ls_so_connection  TYPE ty_s_filters.

    CONSTANTS: lc_value TYPE string VALUE 'VALUE',
               lc_descr TYPE string VALUE 'DESCR',
               lc_type  TYPE string VALUE 'CONNECTIONNAME',
               lc_scen  TYPE string VALUE 'MIGRATIONSCENARIOUUID',
               lc_appro TYPE string VALUE 'MIGRATIONAPPROACHUUID'.

    lt_filter_request = io_tech_request_context->get_filter( )->get_filter_select_options( ).

    LOOP AT lt_filter_request INTO ls_filter_request ##INTO_OK.
      IF ls_filter_request-property = lc_value.
        MOVE-CORRESPONDING ls_filter_request-select_options TO lt_so_filters.
      ELSEIF ls_filter_request-property = lc_descr.
        MOVE-CORRESPONDING ls_filter_request-select_options TO lt_so_descr.
      ELSEIF ls_filter_request-property = lc_type.
        MOVE-CORRESPONDING ls_filter_request-select_options TO lt_so_connection.
      ELSEIF ls_filter_request-property = lc_scen.
        MOVE-CORRESPONDING ls_filter_request-select_options TO lt_so_scenario.
      ELSEIF ls_filter_request-property = lc_appro.
        MOVE-CORRESPONDING ls_filter_request-select_options TO lt_so_approach.
      ENDIF.
    ENDLOOP.

    TRY.
        READ TABLE lt_so_scenario INTO ls_so_scenario INDEX 1.
        READ TABLE lt_so_approach INTO ls_so_approach INDEX 1.

        lo_filter_proxy = /ltb/cl_mc_proxy_factory=>get_filter_proxy_by_apprscen( iv_approach = CONV #( ls_so_approach-low )
                                                                                  iv_scenario = CONV #( ls_so_scenario-low ) ).

        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        READ TABLE lt_so_connection INTO ls_so_connection INDEX 1.

        IF ls_so_approach-low EQ /ltb/if_mc_constants=>gc_approach-sap_direct.
          DATA(lo_com_utils) = cl_cnv_pe_factory=>get_com_utils( ).
          IF lo_com_utils->is_ca_config_required( ) EQ abap_true.
            DATA(lt_ca) = lo_com_utils->get_all_registered_ca_0816( ).
            READ TABLE lt_ca ASSIGNING FIELD-SYMBOL(<ls_ca>) WITH KEY ca_name = ls_so_connection-low.
            IF sy-subrc EQ 0.
              ls_so_connection-low = <ls_ca>-rfcdest.
            ENDIF.
          ENDIF.
        ENDIF.

        lo_obj_ctx->set_connection_name( ls_so_connection-low ).


        "two filters
        lt_filter = VALUE #( BASE lt_filter
                          FOR <filter> IN lt_so_filters
                          (
                            field = 'FILTER_VALUE'
                            sign  = <filter>-sign
                            oper  = <filter>-option
                            low   = <filter>-low
                            high  = <filter>-high )
                          ).

        lt_filter = VALUE #( BASE lt_filter
                          FOR filter IN lt_so_descr
                          (
                            field = 'FILTER_DESCR'
                            sign  = filter-sign
                            oper  = filter-option
                            low   = filter-low
                            high  = filter-high )
                          ).

        lo_obj_ctx->set_filter_cond( lt_filter ).

        IF lo_filter_proxy IS BOUND.
          lo_filter_proxy->get_f4_values( EXPORTING io_cntxt = lo_obj_ctx
                                          IMPORTING et_value = lt_filter_values ).
        ENDIF.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    et_entityset = VALUE #( FOR <item> IN lt_filter_values
                    (
                      migrationapproachuuid = ls_so_approach-low
                      migrationscenariouuid = ls_so_scenario-low
                      connectionname = ls_so_connection-low
                      name = <item>-name
                      value = <item>-value
                      descr = <item>-descr
                    )
           ).

  ENDMETHOD.


  METHOD filtermetaset_get_entity.
    DATA lo_filter_proxy          TYPE REF TO /ltb/if_mc_filter_proxy.
    DATA ls_filter_meta           TYPE /ltb/if_mc_constants=>gty_filter_meta.

    CLEAR es_response_context.
    no_cache( ).
    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values = er_entity
    ).

    TRY.
        lo_filter_proxy = /ltb/cl_mc_proxy_factory=>get_filter_proxy_by_apprscen( iv_approach = CONV #( er_entity-migrationapproachuuid )
                                                                                  iv_scenario = CONV #( er_entity-migrationscenariouuid ) ).

        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        IF lo_filter_proxy IS BOUND.
          ls_filter_meta = lo_filter_proxy->get_metadata( io_cntxt = lo_obj_ctx ).
        ENDIF.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    er_entity = VALUE #( BASE er_entity
                         name = ls_filter_meta-name
                         descr = ls_filter_meta-descr
                         value_heading = ls_filter_meta-value_heading
                         descr_heading = ls_filter_meta-descr_heading
                         issingleselection = ls_filter_meta-is_single_selection ).


  ENDMETHOD.


  METHOD filtersinmigrati_get_entityset.
    DATA ls_project             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_filtersinmigrationproject.
    DATA ls_filter_meta         TYPE /ltb/if_mc_constants=>gty_filter_meta.
    DATA lt_filters             TYPE /ltb/if_mc_constants=>gtt_filter_value.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF io_tech_request_context IS BOUND.
      io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_project
      ).
    ENDIF.

    TRY.
        "project proxy
        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_project-migrationprojectuuid ) ).
        DATA(lo_filter_proxy) = lo_proj_proxy->get_filter_proxy( ).
        DATA(lo_cntxt) = NEW /ltb/cl_mc_cntxt_proj_detail( ).

        IF lo_filter_proxy IS BOUND.
          ls_filter_meta = lo_filter_proxy->get_metadata( lo_cntxt ).
        ENDIF.
        IF ls_filter_meta-name IS NOT INITIAL.
          lo_cntxt->set_selected_filter_name( ls_filter_meta-name ).

          lo_proj_proxy->get_selected_filter_values( EXPORTING io_cntxt = lo_cntxt
                                                     IMPORTING et_value = lt_filters ).
        ENDIF.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    et_entityset = VALUE #( FOR <item> IN lt_filters
                    (
                      migrationprojectuuid = ls_project-migrationprojectuuid
                      name = <item>-name
                      descr = ls_filter_meta-descr
                      value = <item>-value
                      value_descr = <item>-descr
                    )
           ).

  ENDMETHOD.


  METHOD filter_tech_messages.
    DATA: lv_msg                TYPE string,
          lv_exist_tech_message TYPE boolean VALUE abap_false.
    CONSTANTS: cns_syntax_error TYPE string VALUE 'SYNTAX ERROR'.

    IF it_messages IS NOT INITIAL.
      LOOP AT it_messages ASSIGNING FIELD-SYMBOL(<ls_message>).
        CLEAR lv_msg.
        MESSAGE ID <ls_message>-msgid TYPE <ls_message>-msgty NUMBER <ls_message>-msgno INTO lv_msg
          WITH <ls_message>-msgv1 <ls_message>-msgv2 <ls_message>-msgv3 <ls_message>-msgv4.
        IF lv_msg CS cns_syntax_error.
          DELETE TABLE it_messages FROM <ls_message>.
          lv_exist_tech_message = abap_true.
        ENDIF.
      ENDLOOP.

      IF lv_exist_tech_message = abap_true.
        DATA(ls_message) = VALUE bal_s_msg( msgty = 'E'
                                            msgid = '/LTB/MC'
                                            msgno = '063' ).
        APPEND ls_message TO it_messages.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD finish_project_transaction.
    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_finishproject,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationproject,
          lo_log_handler        TYPE REF TO cl_dmc_log_handler,
          lv_error_count        TYPE i VALUE 0,
          lv_warning_count      TYPE i VALUE 0,
          lv_msg                TYPE string,
          lv_msg_v1             TYPE symsgv,
          lv_warning_exist      TYPE abap_bool.
    CONSTANTS: co_external_id    TYPE balnrext VALUE 'Finish Project'.

    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
       ).
      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      ls_entity-migrationprojectuuid = ls_parameter-migrationprojectuuid.
      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).
      ls_changeset_response-operation_no = ls_changeset_request-operation_no.

      DATA(lv_act_uuid) = /ltb/cl_mc_eventlog_access=>get_new_act_uuid( ).

      TRY .
          lo_log_handler = cl_dmc_log_handler=>get_or_create_loghandler( im_subobject   = cl_dmc_log_handler=>co_cobj_mnt
                                                                         im_external_id = co_external_id ).
          handle_finish_project( EXPORTING io_tech_request_context   = lo_request
                                 IMPORTING ev_warning_exist          = lv_warning_exist ).
        CATCH /iwbep/cx_mgw_busi_exception INTO DATA(lo_exception).
          lv_error_count += 1.
          DATA(lv_msg_container) = lo_exception->get_msg_container( ).
          DATA(lt_messages) = lv_msg_container->get_messages( ).
          LOOP AT lt_messages INTO DATA(ls_message).
            lo_log_handler->set_message(
              EXPORTING
                im_message_type = ls_message-type
                im_message_id = ls_message-id
                im_message_number = ls_message-number
                im_message_variable_1 = ls_message-message_v1
                im_message_variable_2 = ls_message-message_v2
                im_message_variable_3 = ls_message-message_v3
                im_message_variable_4 = ls_message-message_v4
            ).
          ENDLOOP.
          lo_log_handler->save_log( ).
          "Record event
          /ltb/cl_mc_eventlog_access=>record_event(
              iv_proj_uuid   = ls_parameter-migrationprojectuuid
              iv_act_uuid    = lv_act_uuid
              iv_event_type  = /ltb/cl_mc_eventlog_access=>gc_event_type-project_finish_error
              iv_lognr = lo_log_handler->lognumber ).
      ENDTRY.
      IF lv_warning_exist = abap_true.
        lv_warning_count += 1.
      ENDIF.
      APPEND ls_changeset_response TO ct_changeset_response.
      CLEAR lv_warning_exist.
    ENDLOOP.

    IF lv_error_count = 0.
      IF lv_warning_count <> 0.
        MESSAGE w296(/ltb/mc) INTO lv_msg WITH lv_warning_count.
        ls_changeset_request = it_changeset_request[ 1 ].
        lv_msg_v1 = lv_warning_count.
        CONDENSE lv_msg_v1 NO-GAPS.
        ls_changeset_request-msg_container->add_message(
          EXPORTING
            iv_msg_type   = 'W'
            iv_msg_id     = '/LTB/MC'
            iv_msg_number = '296'
            iv_msg_v1     = lv_msg_v1
            iv_add_to_response_header = abap_true
            ).
      ELSE.
        "Project finished successfully
        MESSAGE i119(/ltb/mc) INTO lv_msg.
        ls_changeset_request = it_changeset_request[ 1 ].
        ls_changeset_request-msg_container->add_message(
          EXPORTING
            iv_msg_type   = 'I'
            iv_msg_id     = '/LTB/MC'
            iv_msg_number = '119'
            iv_add_to_response_header = abap_true
            ).
      ENDIF.
    ELSE.
      "&1 projects are failed finish, check project history table for details.
      MESSAGE e120(/ltb/mc) INTO lv_msg.
      ls_changeset_request = it_changeset_request[ 1 ].
      ls_changeset_request-msg_container->add_message(
        EXPORTING
          iv_msg_type   = 'E'
          iv_msg_id     = '/LTB/MC'
          iv_msg_number = '120'
          iv_add_to_response_header = abap_true
          ).
    ENDIF.

  ENDMETHOD.


  METHOD get_action_desc.
    CASE iv_action.
      WHEN ''.
        rv_description = get_text( EXPORTING iv_id = 'A01' ). "Initial
      WHEN 'L'.
        rv_description = get_text( EXPORTING iv_id = 'A02' ). "Selected
      WHEN 'V'.
        rv_description = get_text( EXPORTING iv_id = 'A05' ). "Validate
      WHEN 'S'.
        rv_description = get_text( EXPORTING iv_id = 'A03' ). "Simulated
      WHEN 'M'.
        rv_description = get_text( EXPORTING iv_id = 'A04' ). "Migrated
    ENDCASE.
  ENDMETHOD.


  METHOD get_active_migration_count.
    TRY.
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        rs_count-number = lo_appl_proxy->get_num_active_projects( ).
      CATCH /ltb/cx_mc_proxy_error INTO DATA(lo_exception).
        MESSAGE e010(/ltb/mc) INTO DATA(lv_message).
        DATA(lt_mc_messages) = lo_exception->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_mc_messages
            iv_message_unlimited = lv_message
        ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_attachement_header_value.

    rv_out = |attachment; | &&
             |filename="{ iv_filename }"; | &&
             |filename*=UTF-8''{ iv_filename_encode }|.

  ENDMETHOD.


  METHOD get_bundle_file_size.

    DATA(lt_csv_files) = NEW /ltb/cl_mc_csv_file_access( )->/ltb/if_mc_csv_file_access~get_by_bundle( iv_bundle_uuid ).

    LOOP AT lt_csv_files INTO DATA(ls_csv_file)
      WHERE status = /ltb/if_mc_csv_file_access=>gc_status-mapped.
      rv_file_size += ls_csv_file-filesize.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_check_mtid.
    DATA:
      ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationprojectmtid,
      lv_available TYPE char1.

    CONSTANTS: BEGIN OF lc_getcheckindicator,
                 get   TYPE i VALUE 0,
                 check TYPE i VALUE 1,
               END OF lc_getcheckindicator.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    TRY.
        IF ls_parameter-indicator = lc_getcheckindicator-get.
          DATA(lv_next_start_mtid)  = ls_parameter-mtid.
          es_mtid-indicator         = ls_parameter-indicator.
          es_mtid-mtid              = /ltb/cl_mc_proj_proxy_abstract=>get_next_mtid( CONV #( to_upper( lv_next_start_mtid ) ) ).
          es_mtid-available         = abap_true.
        ELSEIF ls_parameter-indicator = lc_getcheckindicator-check.
          es_mtid-indicator         = ls_parameter-indicator.
          es_mtid-mtid              = to_upper( ls_parameter-mtid ).
          lv_available              = /ltb/cl_mc_proj_proxy_abstract=>check_mtid_availability( CONV #( es_mtid-mtid ) ).
          es_mtid-available         = SWITCH #( lv_available
                                          WHEN '0' THEN abap_true
                                          ELSE abap_false ).
          CASE lv_available.
            WHEN /ltb/cl_mc_proj_proxy_abstract=>co_mtid_availability-invalid_mtid.
              MESSAGE e090(/ltb/mc) INTO es_mtid-message.
            WHEN /ltb/cl_mc_proj_proxy_abstract=>co_mtid_availability-already_exist.
              MESSAGE e092(/ltb/mc) INTO es_mtid-message.
          ENDCASE.
        ELSE.
          MESSAGE e049(/ltb/mc) INTO DATA(lv_message).
          raise_bussiness_exception(
            EXPORTING
              iv_textid             = /iwbep/cx_mgw_busi_exception=>business_error
              iv_message_unlimited  = lv_message
          ).
        ENDIF.
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        MESSAGE e049(/ltb/mc) INTO lv_message.
        DATA(lt_mc_messages) = lo_exception->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_mc_messages
            iv_message_unlimited = lv_message
        ).
    ENDTRY.

  ENDMETHOD.


METHOD get_complex_filter_sel_option.
  DATA: lt_conv_comp_filter_condition TYPE if_sadl_public_types=>tt_condensed_condition,
        lt_complext_filter_condition  TYPE if_sadl_public_types=>tt_condensed_condition,
        ls_complext_filter_condition  TYPE if_sadl_public_types=>ty_condensed_condition,
        ls_sel_option                 TYPE /iwbep/s_cod_select_option,
        lt_filter_select_options      TYPE /iwbep/t_mgw_select_option,
        ls_filter_select_options      TYPE /iwbep/s_mgw_select_option,
        lt_clone_filter_condition     TYPE if_sadl_public_types=>tt_condensed_condition,
        lv_logic_oper                 TYPE string,
        lv_logic_oper_found           TYPE abap_bool,
        lv_oper_andnot_deleted        TYPE abap_bool,
        lv_oper_andand_deleted        TYPE abap_bool,
        lv_del_index_or               TYPE sy-tabix,
        lv_del_index_and              TYPE sy-tabix,
        lv_del_index_and_2            TYPE sy-tabix,
        lv_del_index_not              TYPE sy-tabix,
        lv_index_bt                   TYPE sy-tabix,
        lv_pre_element                TYPE string,
        lv_element_counter            TYPE i,
        lv_oper_counter               TYPE i.

  CONSTANTS: lc_service_name    TYPE /iwbep/med_grp_technical_name VALUE '/LTB/MIG_MC_ODATA_SRV',
             lc_service_version TYPE /iwbep/med_grp_version VALUE '0001'.


  TYPES: BEGIN OF typ_oper_map,
           oper_src TYPE string,
           oper_trg TYPE string,
         END OF typ_oper_map.
  DATA: lt_oper_map TYPE TABLE OF typ_oper_map.

  " Map the loggic operator
  APPEND VALUE #( oper_src = 'GE' oper_trg = 'LT' ) TO lt_oper_map.
  APPEND VALUE #( oper_src = 'GT' oper_trg = 'LE' ) TO lt_oper_map.
  APPEND VALUE #( oper_src = 'LT' oper_trg = 'GE' ) TO lt_oper_map.
  APPEND VALUE #( oper_src = 'LE' oper_trg = 'GT' ) TO lt_oper_map.
*  APPEND VALUE #( oper_src = 'EQ' oper_trg = 'NE' ) TO lt_oper_map." 'NE' shouldn't exist, it should be converted to 'NOT' 'EQ'
  APPEND VALUE #( oper_src = 'NE' oper_trg = 'EQ' ) TO lt_oper_map.

  TRY.
      DATA(lo_request_tree)         =  io_tech_request_context->get_filter_expression_tree( ).
      IF lo_request_tree IS BOUND.
        cl_sadl_run_time_util=>start( cl_sadl_run_time_util=>cs_component-ext ).
        NEW cl_sadl_gw_filter_tree_parser( )->get_complex_condition( EXPORTING io_filter_tree = lo_request_tree
                                                                     IMPORTING et_condition = DATA(lt_complex_condition) ).
        cl_sadl_run_time_util=>stop( cl_sadl_run_time_util=>cs_component-ext ).
        cl_sadl_condition_util=>condense_condition( EXPORTING it_complex_condition   = lt_complex_condition
                                                    IMPORTING et_condensed_condition = lt_conv_comp_filter_condition ).
        IF lt_conv_comp_filter_condition IS NOT INITIAL.
          DATA(lo_metadata_provider) = /iwbep/cl_mgw_med_provider=>get_med_provider( ).
          DATA(ls_default_system_alias_info) = mo_context->get_system_alias_info( ).
          lo_metadata_provider->initialize(
            EXPORTING
              is_default_system_alias_info = ls_default_system_alias_info     " System Alias Information
              iv_is_busi_data_request      = abap_true                        "
           ).
          CALL FUNCTION '/IWBEP/FM_MGW_MODEL_LOAD_SET'.

          DATA(lo_model) = lo_metadata_provider->get_service_metadata(
                             iv_internal_service_name    = lc_service_name
                             iv_internal_service_version = lc_service_version
                           ).

          CALL FUNCTION '/IWBEP/FM_MGW_MODEL_LOAD_RESET'.
          "get the mapping for property name and technical name
          DATA(lo_entity_type) = lo_model->get_entity_type( iv_entity_name =  CONV #( iv_entity_name ) ).
          DATA(lt_properties) = lo_entity_type->get_properties( ).

          "First round, remove the logic operator 'AND' between fields
          LOOP AT lt_conv_comp_filter_condition INTO ls_complext_filter_condition.
            DATA(lv_index) = sy-tabix.
            IF ls_complext_filter_condition-element IS NOT INITIAL.
              IF lv_pre_element IS NOT INITIAL AND lv_pre_element <> ls_complext_filter_condition-element.
                "if filed name changes, remove its previous logic operator
                IF lv_element_counter <= lv_oper_counter.
                  DATA(lv_delete_counter) = lv_oper_counter - lv_element_counter + 1.
                  DO lv_delete_counter TIMES.
                    lv_index = lv_index - 1.
                    IF line_exists( lt_conv_comp_filter_condition[ lv_index ] ) AND
                       lt_conv_comp_filter_condition[ lv_index ]-operator = 'AND'.
                      DELETE lt_conv_comp_filter_condition INDEX lv_index.
                      lv_oper_counter = lv_oper_counter - 1.
                      IF lv_oper_counter < lv_element_counter.
                        EXIT.
                      ELSE.
                      ENDIF.
                    ENDIF.
                  ENDDO.
                ENDIF.

                lv_element_counter = 1.
                lv_oper_counter    = 0.
              ELSEIF  lv_pre_element <> ls_complext_filter_condition-element.
                lv_element_counter = 1.
                lv_oper_counter    = 0.
              ELSE.
                lv_element_counter = lv_element_counter + 1.
              ENDIF.
              lv_pre_element = ls_complext_filter_condition-element.
            ELSEIF ls_complext_filter_condition-operator <> 'NOT'. "NOT is a single value operator
              lv_oper_counter = lv_oper_counter + 1.
            ENDIF.
          ENDLOOP.
          "Remove the last operator
          IF lv_element_counter <= lv_oper_counter.
            lv_delete_counter = lv_oper_counter - lv_element_counter + 1.
            DO lv_delete_counter TIMES.

              IF line_exists( lt_conv_comp_filter_condition[ lv_index ] ) AND
                 lt_conv_comp_filter_condition[ lv_index ]-operator = 'AND'.
                DELETE lt_conv_comp_filter_condition INDEX lv_index.
                lv_oper_counter = lv_oper_counter - 1.
                IF lv_oper_counter < lv_element_counter.
                  EXIT.
                ELSE.
                  lv_index = lv_index - 1.
                ENDIF.
              ENDIF.
            ENDDO.
          ENDIF.


          "Second round, Find LE and GE , replace with BT
          LOOP AT lt_conv_comp_filter_condition INTO ls_complext_filter_condition WHERE operator = 'LE'.
            lv_index = sy-tabix.
            lv_index_bt = lv_index + 1.
            IF line_exists( lt_conv_comp_filter_condition[ lv_index_bt ] ).
              IF lt_conv_comp_filter_condition[ lv_index_bt ]-operator = 'GE'.
                lv_index_bt = lv_index_bt + 1.
                IF line_exists( lt_conv_comp_filter_condition[ lv_index_bt ] ).
                  IF lt_conv_comp_filter_condition[ lv_index_bt ]-operator = 'AND'.
                    "convert LE, GE to BT
                    ls_complext_filter_condition-operator = 'BT'.
                    lv_index_bt = lv_index + 1.
                    ls_complext_filter_condition-high     = ls_complext_filter_condition-low.
                    ls_complext_filter_condition-low      = lt_conv_comp_filter_condition[ lv_index_bt ]-low.
                    MODIFY lt_conv_comp_filter_condition FROM ls_complext_filter_condition INDEX lv_index.
                    DO 2 TIMES.
                      DELETE lt_conv_comp_filter_condition INDEX lv_index_bt.
                    ENDDO.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.

          "Third round , conver 'NE' to 'NOT' 'EQ'
          LOOP AT lt_conv_comp_filter_condition INTO ls_complext_filter_condition WHERE operator = 'NE'.
            lv_index = sy-tabix.
            ls_complext_filter_condition-operator = 'EQ'.
            MODIFY lt_conv_comp_filter_condition FROM ls_complext_filter_condition INDEX lv_index.
            CLEAR ls_complext_filter_condition.
            ls_complext_filter_condition-operator = 'NOT'.
            lv_index = lv_index + 1.
            INSERT ls_complext_filter_condition INTO lt_conv_comp_filter_condition INDEX lv_index.
          ENDLOOP.

          "Forth round, for each line which has element name, compose a range
          CLEAR lv_pre_element.
          LOOP AT lt_conv_comp_filter_condition INTO ls_complext_filter_condition.
            lv_index = sy-tabix.
            IF ls_complext_filter_condition-element IS NOT INITIAL.

              CLEAR lv_logic_oper.
              CLEAR lv_logic_oper_found.
              CLEAR lv_del_index_or.
              CLEAR lv_del_index_and.
              CLEAR lv_del_index_not.
              DATA(lv_current_element) = ls_complext_filter_condition-element.
              "Use a cloned table to check find its corresponding opeator
              lt_clone_filter_condition  = lt_conv_comp_filter_condition .
              LOOP AT lt_clone_filter_condition INTO DATA(ls_clone_filter_option) FROM lv_index.

                IF ls_clone_filter_option-element IS INITIAL.
                  IF ls_clone_filter_option-operator = 'NOT'.
                    IF lv_logic_oper = 'AND'.
                      lv_logic_oper = 'ANDNOT'.
                      lv_del_index_not = sy-tabix.
                      lv_logic_oper_found = abap_true.
                    ELSEIF lv_logic_oper = 'NOT'.
                      lv_logic_oper_found = abap_true.
                    ELSE.
                      lv_logic_oper = 'NOT'.
                      lv_del_index_not = sy-tabix.
                    ENDIF.
                  ELSEIF ls_clone_filter_option-operator = 'AND'.
                    IF lv_logic_oper = 'NOT' AND lv_logic_oper_found = abap_true.

                    ELSEIF lv_logic_oper = 'ANDNOT'.
                      lv_del_index_and_2 = sy-tabix.
                    ELSEIF lv_logic_oper = 'NOTAND'.
                      lv_del_index_and = sy-tabix.
                      lv_logic_oper_found = abap_true.
                    ELSEIF lv_logic_oper = 'NOT'.
                      lv_logic_oper = 'NOTAND'.
                      lv_del_index_and = sy-tabix.
                      lv_logic_oper_found = abap_true.
                    ELSE.
                      lv_logic_oper = 'AND'.
                      lv_del_index_and = sy-tabix.
                      lv_logic_oper_found = abap_true.
                    ENDIF.
                    IF lv_del_index_or IS NOT INITIAL.
                      CLEAR lv_del_index_or.
                    ENDIF.

                  ELSEIF ls_clone_filter_option-operator = 'OR'.
                    IF lv_logic_oper IS INITIAL.
                      lv_logic_oper = 'OR'.
                      lv_logic_oper_found = abap_true.
                      lv_del_index_or = sy-tabix.
                    ENDIF.
                  ENDIF.
                ELSEIF lv_logic_oper = 'ANDNOT'.
                  IF lv_del_index_and_2 IS NOT INITIAL.
                    EXIT.
                  ELSE.
                    CONTINUE.
                  ENDIF.
                ELSEIF ls_complext_filter_condition-element = ls_clone_filter_option-element.
                  CONTINUE.
                ELSE."ls_clone_filter_option-element IS INITIAL.
                  IF lv_logic_oper_found = abap_true.
                    EXIT.
                  ELSEIF ls_clone_filter_option-element <> lv_current_element.
                    EXIT.
                  ELSE.
                    CONTINUE.
                  ENDIF.
                ENDIF.
              ENDLOOP.

              IF lv_logic_oper = 'NOTAND'.
                APPEND INITIAL LINE TO lt_filter_select_options ASSIGNING FIELD-SYMBOL(<fs_sel_opt>).
                CLEAR ls_sel_option.

                IF iv_tech_property_name = abap_true.
                  <fs_sel_opt>-property = ls_complext_filter_condition-element.
                ELSE.
                  READ TABLE lt_properties ASSIGNING FIELD-SYMBOL(<fs_property>) WITH KEY technical_name = ls_complext_filter_condition-element.
                  <fs_sel_opt>-property = <fs_property>-name.
                ENDIF.

                ls_sel_option-sign  = 'E'.
                ls_sel_option-low     = ls_complext_filter_condition-low.
                ls_sel_option-high    = ls_complext_filter_condition-high.
                APPEND ls_sel_option TO <fs_sel_opt>-select_options.

                "translate option
                IF line_exists( lt_oper_map[ oper_src = <fs_sel_opt>-select_options[ 1 ]-option ] ).
                  <fs_sel_opt>-select_options[ 1 ]-option = lt_oper_map[ oper_src = <fs_sel_opt>-select_options[ 1 ]-option ]-oper_trg.
                ELSE.
                  <fs_sel_opt>-select_options[ 1 ]-option = ls_complext_filter_condition-operator.
                ENDIF.

                IF lv_del_index_and IS NOT INITIAL.
                  DELETE lt_conv_comp_filter_condition INDEX lv_del_index_and.
                ENDIF.
                IF lv_del_index_not IS NOT INITIAL.
                  DELETE lt_conv_comp_filter_condition INDEX lv_del_index_not.
                ENDIF.
              ELSEIF lv_logic_oper = 'ANDNOT'. "Only Exclude between is converted 'ANDNOT'

                IF lv_oper_andnot_deleted = abap_false.
                  lv_oper_andnot_deleted = abap_true.
                  APPEND INITIAL LINE TO lt_filter_select_options ASSIGNING <fs_sel_opt>.
                  CLEAR ls_sel_option.

                  IF iv_tech_property_name = abap_true.
                    <fs_sel_opt>-property = ls_complext_filter_condition-element.
                  ELSE.
                    READ TABLE lt_properties ASSIGNING <fs_property> WITH KEY technical_name = ls_complext_filter_condition-element.
                    <fs_sel_opt>-property = <fs_property>-name.
                  ENDIF.

                  ls_sel_option-sign  = 'E'.
                  ls_sel_option-option  = 'BT'.
                  IF ls_complext_filter_condition-operator = 'LE'.
                    ls_sel_option-high     = ls_complext_filter_condition-low.
                  ELSEIF ls_complext_filter_condition-operator = 'GE'.
                    ls_sel_option-low     = ls_complext_filter_condition-low.
                  ENDIF.
                  APPEND ls_sel_option TO <fs_sel_opt>-select_options.
                ELSE.
                  IF <fs_sel_opt> IS ASSIGNED.
                    IF ls_complext_filter_condition-operator = 'LE'.
                      <fs_sel_opt>-select_options[ 1 ]-high = ls_complext_filter_condition-low.
                    ELSEIF ls_complext_filter_condition-operator = 'GE'.
                      <fs_sel_opt>-select_options[ 1 ]-low = ls_complext_filter_condition-low.
                    ENDIF.
                  ENDIF.

                  IF lv_del_index_and_2 IS NOT INITIAL.
                    DELETE lt_conv_comp_filter_condition INDEX lv_del_index_and_2.
                  ENDIF.

                  IF lv_del_index_not IS NOT INITIAL.
                    DELETE lt_conv_comp_filter_condition INDEX lv_del_index_not.
                  ENDIF.
                  IF lv_del_index_and IS NOT INITIAL.
                    DELETE lt_conv_comp_filter_condition INDEX lv_del_index_and.
                  ENDIF.
                  CLEAR lv_oper_andnot_deleted.
                ENDIF.
              ELSEIF lv_logic_oper = 'AND' OR lv_logic_oper = 'NOT' .
                APPEND INITIAL LINE TO lt_filter_select_options ASSIGNING <fs_sel_opt>.
                CLEAR ls_sel_option.

                IF iv_tech_property_name = abap_true.
                  <fs_sel_opt>-property = ls_complext_filter_condition-element.
                ELSE.
                  READ TABLE lt_properties ASSIGNING <fs_property> WITH KEY technical_name = ls_complext_filter_condition-element.
                  <fs_sel_opt>-property = <fs_property>-name.
                ENDIF.

                ls_sel_option-sign  = 'E'.
                ls_sel_option-low     = ls_complext_filter_condition-low.
                ls_sel_option-high    = ls_complext_filter_condition-high.
                ls_sel_option-option  = ls_complext_filter_condition-operator.
                APPEND ls_sel_option TO <fs_sel_opt>-select_options.

                lt_clone_filter_condition  = lt_conv_comp_filter_condition.
                lv_index = lv_index + 1.
                LOOP AT lt_clone_filter_condition TRANSPORTING NO FIELDS FROM lv_index WHERE element = lv_current_element.
                  EXIT.
                ENDLOOP.
                IF sy-subrc = 0.
                  "convert option.
                  IF line_exists( lt_oper_map[ oper_src = <fs_sel_opt>-select_options[ 1 ]-option ] ).
                    <fs_sel_opt>-select_options[ 1 ]-option = lt_oper_map[ oper_src = <fs_sel_opt>-select_options[ 1 ]-option ]-oper_trg.
                  ELSE.
                    <fs_sel_opt>-select_options[ 1 ]-option = ls_complext_filter_condition-operator.
                  ENDIF.


                  IF lv_del_index_and IS NOT INITIAL.
                    DELETE lt_conv_comp_filter_condition INDEX lv_del_index_and.
                  ELSEIF lv_del_index_not IS NOT INITIAL.
                    DELETE lt_conv_comp_filter_condition INDEX lv_del_index_not.
                  ENDIF.

                ELSE.
                  <fs_sel_opt>-select_options[ 1 ]-sign = 'I'.
                  IF lv_del_index_and IS NOT INITIAL.
                    DELETE lt_conv_comp_filter_condition INDEX lv_del_index_and.
                  ENDIF.
                ENDIF.
              ELSEIF lv_logic_oper = 'OR'.
                APPEND INITIAL LINE TO lt_filter_select_options ASSIGNING <fs_sel_opt>.
                CLEAR ls_sel_option.

                IF iv_tech_property_name = abap_true.
                  <fs_sel_opt>-property = ls_complext_filter_condition-element.
                ELSE.
                  READ TABLE lt_properties ASSIGNING <fs_property> WITH KEY technical_name = ls_complext_filter_condition-element.
                  <fs_sel_opt>-property = <fs_property>-name.
                ENDIF.

                ls_sel_option-sign  = 'I'.
                ls_sel_option-low     = ls_complext_filter_condition-low.
                ls_sel_option-high    = ls_complext_filter_condition-high.
                ls_sel_option-option  = ls_complext_filter_condition-operator.
                APPEND ls_sel_option TO <fs_sel_opt>-select_options.

                IF lv_del_index_or IS NOT INITIAL.
                  DELETE lt_conv_comp_filter_condition INDEX lv_del_index_or.
                ENDIF.
              ELSEIF lv_logic_oper IS INITIAL.
                APPEND INITIAL LINE TO lt_filter_select_options ASSIGNING <fs_sel_opt>.
                CLEAR ls_sel_option.

                IF iv_tech_property_name = abap_true.
                  <fs_sel_opt>-property = ls_complext_filter_condition-element.
                ELSE.
                  READ TABLE lt_properties ASSIGNING <fs_property> WITH KEY technical_name = ls_complext_filter_condition-element.
                  <fs_sel_opt>-property = <fs_property>-name.
                ENDIF.

                ls_sel_option-sign  = 'I'.
                ls_sel_option-low     = ls_complext_filter_condition-low.
                ls_sel_option-high    = ls_complext_filter_condition-high.
                ls_sel_option-option  = ls_complext_filter_condition-operator.
                APPEND ls_sel_option TO <fs_sel_opt>-select_options.

                IF lv_del_index_or IS NOT INITIAL.
                  DELETE lt_conv_comp_filter_condition INDEX lv_del_index_or.
                ENDIF.
              ENDIF.
              lv_pre_element =  ls_complext_filter_condition-element.

            ELSE." IF ls_complext_filter_condition-element IS NOT INITIAL.

            ENDIF.
          ENDLOOP.
        ENDIF.

        "Combine select options
        IF lt_filter_select_options IS NOT INITIAL.
          SORT lt_filter_select_options BY property.

          LOOP AT lt_filter_select_options ASSIGNING <fs_sel_opt>.
            IF <fs_sel_opt>-select_options[ 1 ]-option = 'NL'.
              <fs_sel_opt>-select_options[ 1 ]-option = 'EQ'.
              <fs_sel_opt>-select_options[ 1 ]-low = 'null'.
            ELSEIF <fs_sel_opt>-select_options[ 1 ]-sign = 'I' AND <fs_sel_opt>-select_options[ 1 ]-option = 'NE'.
              " from frontend, cannot choose sign = 'I' and option = 'NE', it should be sign = 'E' and option = 'EQ'
              <fs_sel_opt>-select_options[ 1 ]-sign   = 'E'.
              <fs_sel_opt>-select_options[ 1 ]-option = 'EQ'.
            ENDIF.
            IF ls_filter_select_options-property IS INITIAL.
              ls_filter_select_options-property = <fs_sel_opt>-property.
              ls_filter_select_options-select_options = <fs_sel_opt>-select_options.
            ELSEIF ls_filter_select_options-property <> <fs_sel_opt>-property.
              SORT ls_filter_select_options-select_options BY sign DESCENDING.
              APPEND ls_filter_select_options TO rt_select_option.
              CLEAR ls_filter_select_options.
              ls_filter_select_options-property = <fs_sel_opt>-property.
              ls_filter_select_options-select_options = <fs_sel_opt>-select_options.

            ELSEIF ls_filter_select_options-property = <fs_sel_opt>-property.
              APPEND LINES OF <fs_sel_opt>-select_options TO ls_filter_select_options-select_options.
            ENDIF.
          ENDLOOP.

          IF ls_filter_select_options IS NOT INITIAL.
            SORT ls_filter_select_options-select_options BY sign DESCENDING.
            APPEND ls_filter_select_options TO rt_select_option.
          ENDIF.
        ENDIF.
      ENDIF.
    CATCH cx_root.  "Ignore exception, return a blank filter range
  ENDTRY.

ENDMETHOD.


METHOD get_complex_filter_sel_option1.
  DATA: lt_conv_comp_filter_condition TYPE if_sadl_public_types=>tt_condensed_condition,
        lt_complext_filter_condition  TYPE if_sadl_public_types=>tt_condensed_condition,
        ls_complext_filter_condition  TYPE if_sadl_public_types=>ty_condensed_condition,
        ls_sel_option                 TYPE /iwbep/s_cod_select_option,
        lt_filter_select_options      TYPE /iwbep/t_mgw_select_option,
        ls_filter_select_options      TYPE /iwbep/s_mgw_select_option,
        lt_clone_filter_condition     TYPE if_sadl_public_types=>tt_condensed_condition,
        lv_logic_oper                 TYPE string,
        lv_logic_oper_found           TYPE abap_bool,
        lv_oper_andnot_deleted        TYPE abap_bool,
        lv_oper_andand_deleted        TYPE abap_bool,
        lv_del_index_or               TYPE sy-tabix,
        lv_del_index_and              TYPE sy-tabix,
        lv_del_index_and_2            TYPE sy-tabix,
        lv_del_index_not              TYPE sy-tabix,
        lv_index_bt                   TYPE sy-tabix,
        lv_pre_element                TYPE string,
        lv_element_counter            TYPE i,
        lv_oper_counter               TYPE i.

  CONSTANTS: lc_service_name    TYPE /iwbep/med_grp_technical_name VALUE '/LTB/MIG_MC_ODATA_SRV',
             lc_service_version TYPE /iwbep/med_grp_version VALUE '0001'.


  TYPES: BEGIN OF typ_oper_map,
           oper_src TYPE string,
           oper_trg TYPE string,
         END OF typ_oper_map.
  DATA: lt_oper_map TYPE TABLE OF typ_oper_map.

  " Map the loggic operator
  APPEND VALUE #( oper_src = 'GE' oper_trg = 'LT' ) TO lt_oper_map.
  APPEND VALUE #( oper_src = 'GT' oper_trg = 'LE' ) TO lt_oper_map.
  APPEND VALUE #( oper_src = 'LT' oper_trg = 'GE' ) TO lt_oper_map.
  APPEND VALUE #( oper_src = 'LE' oper_trg = 'GT' ) TO lt_oper_map.
  APPEND VALUE #( oper_src = 'EQ' oper_trg = 'NE' ) TO lt_oper_map.
  APPEND VALUE #( oper_src = 'NE' oper_trg = 'EQ' ) TO lt_oper_map.

  TRY.
      DATA(lo_request_tree)         =  io_tech_request_context->get_filter_expression_tree( ).
      IF lo_request_tree IS BOUND.
        cl_sadl_run_time_util=>start( cl_sadl_run_time_util=>cs_component-ext ).
        NEW cl_sadl_gw_filter_tree_parser( )->get_complex_condition( EXPORTING io_filter_tree = lo_request_tree
                                                                     IMPORTING et_condition = DATA(lt_complex_condition) ).
        cl_sadl_run_time_util=>stop( cl_sadl_run_time_util=>cs_component-ext ).
        cl_sadl_condition_util=>condense_condition( EXPORTING it_complex_condition   = lt_complex_condition
                                                    IMPORTING et_condensed_condition = lt_conv_comp_filter_condition ).
        IF lt_conv_comp_filter_condition IS NOT INITIAL.
          DATA(lo_metadata_provider) = /iwbep/cl_mgw_med_provider=>get_med_provider( ).
          DATA(ls_default_system_alias_info) = mo_context->get_system_alias_info( ).
          lo_metadata_provider->initialize(
            EXPORTING
              is_default_system_alias_info = ls_default_system_alias_info     " System Alias Information
              iv_is_busi_data_request      = abap_true                        "
           ).
          CALL FUNCTION '/IWBEP/FM_MGW_MODEL_LOAD_SET'.

          DATA(lo_model) = lo_metadata_provider->get_service_metadata(
                             iv_internal_service_name    = lc_service_name
                             iv_internal_service_version = lc_service_version
                           ).

          CALL FUNCTION '/IWBEP/FM_MGW_MODEL_LOAD_RESET'.
          "get the mapping for property name and technical name
          DATA(lo_entity_type) = lo_model->get_entity_type( iv_entity_name =  CONV #( iv_entity_name ) ).
          DATA(lt_properties) = lo_entity_type->get_properties( ).

          "First round, remove the logic operator 'AND' between fields
          LOOP AT lt_conv_comp_filter_condition INTO ls_complext_filter_condition.
            DATA(lv_index) = sy-tabix.
            IF ls_complext_filter_condition-element IS NOT INITIAL.
              IF lv_pre_element IS NOT INITIAL AND lv_pre_element <> ls_complext_filter_condition-element.
                "if filed name changes, remove its previous logic operator
                IF lv_element_counter <= lv_oper_counter.
                  DATA(lv_delete_counter) = lv_oper_counter - lv_element_counter + 1.
                  DO lv_delete_counter TIMES.
                    lv_index = lv_index - 1.
                    IF line_exists( lt_conv_comp_filter_condition[ lv_index ] ) AND
                       lt_conv_comp_filter_condition[ lv_index ]-operator = 'AND'.
                      DELETE lt_conv_comp_filter_condition INDEX lv_index.
                      lv_oper_counter = lv_oper_counter - 1.
                      IF lv_oper_counter < lv_element_counter.
                        EXIT.
                      ELSE.
                      ENDIF.
                    ENDIF.
                  ENDDO.
                ENDIF.

                lv_element_counter = 1.
                lv_oper_counter    = 0.
              ELSEIF  lv_pre_element <> ls_complext_filter_condition-element.
                lv_element_counter = 1.
                lv_oper_counter    = 0.
              ELSE.
                lv_element_counter = lv_element_counter + 1.
              ENDIF.
              lv_pre_element = ls_complext_filter_condition-element.
            ELSEIF ls_complext_filter_condition-operator <> 'NOT'. "NOT is a single value operator
              lv_oper_counter = lv_oper_counter + 1.
            ENDIF.
          ENDLOOP.
          "Remove the last operator
          IF lv_element_counter <= lv_oper_counter.
            lv_delete_counter = lv_oper_counter - lv_element_counter + 1.
            DO lv_delete_counter TIMES.

              IF line_exists( lt_conv_comp_filter_condition[ lv_index ] ) AND
                 lt_conv_comp_filter_condition[ lv_index ]-operator = 'AND'.
                DELETE lt_conv_comp_filter_condition INDEX lv_index.
                lv_oper_counter = lv_oper_counter - 1.
                IF lv_oper_counter < lv_element_counter.
                  EXIT.
                ELSE.
                  lv_index = lv_index - 1.
                ENDIF.
              ENDIF.
            ENDDO.
          ENDIF.


          "Second round, Find LE and GE , replace with BT
          LOOP AT lt_conv_comp_filter_condition INTO ls_complext_filter_condition WHERE operator = 'LE'.
            lv_index = sy-tabix.
            lv_index_bt = lv_index + 1.
            IF line_exists( lt_conv_comp_filter_condition[ lv_index_bt ] ).
              IF lt_conv_comp_filter_condition[ lv_index_bt ]-operator = 'GE'.
                lv_index_bt = lv_index_bt + 1.
                IF line_exists( lt_conv_comp_filter_condition[ lv_index_bt ] ).
                  IF lt_conv_comp_filter_condition[ lv_index_bt ]-operator = 'AND'.
                    "convert LE, GE to BT
                    ls_complext_filter_condition-operator = 'BT'.
                    lv_index_bt = lv_index + 1.
                    ls_complext_filter_condition-high     = ls_complext_filter_condition-low.
                    ls_complext_filter_condition-low      = lt_conv_comp_filter_condition[ lv_index_bt ]-low.
                    MODIFY lt_conv_comp_filter_condition FROM ls_complext_filter_condition INDEX lv_index.
                    DO 2 TIMES.
                      DELETE lt_conv_comp_filter_condition INDEX lv_index_bt.
                    ENDDO.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.

          "Third round, for each line which has element name, compose a range
          CLEAR lv_pre_element.
          LOOP AT lt_conv_comp_filter_condition INTO ls_complext_filter_condition.
            lv_index = sy-tabix.
            IF ls_complext_filter_condition-element IS NOT INITIAL.

              CLEAR lv_logic_oper.
              CLEAR lv_logic_oper_found.
              CLEAR lv_del_index_or.
              CLEAR lv_del_index_and.
              CLEAR lv_del_index_not.
              DATA(lv_current_element) = ls_complext_filter_condition-element.
              "Use a cloned table to check find its corresponding opeator
              lt_clone_filter_condition  = lt_conv_comp_filter_condition .
              LOOP AT lt_clone_filter_condition INTO DATA(ls_clone_filter_option) FROM lv_index.

                IF ls_clone_filter_option-element IS INITIAL.
                  IF ls_clone_filter_option-operator = 'NOT'.
                    IF lv_logic_oper = 'AND'.
                      lv_logic_oper = 'ANDNOT'.
                      lv_del_index_not = sy-tabix.
                      lv_logic_oper_found = abap_true.
                    ELSEIF lv_logic_oper = 'NOT'.
                      lv_logic_oper_found = abap_true.
                    ELSE.
                      lv_logic_oper = 'NOT'.
                      lv_del_index_not = sy-tabix.
                    ENDIF.
                  ELSEIF ls_clone_filter_option-operator = 'AND'.
                    IF lv_logic_oper = 'NOT' AND lv_logic_oper_found = abap_true.

                    ELSEIF lv_logic_oper = 'ANDNOT'.
                      lv_del_index_and_2 = sy-tabix.

                    ELSEIF lv_logic_oper = 'NOT'.
                      lv_logic_oper = 'NOTAND'.
                      lv_del_index_and = sy-tabix.
                      lv_logic_oper_found = abap_true.
                    ELSE.
                      lv_logic_oper = 'AND'.
                      lv_del_index_and = sy-tabix.
                      lv_logic_oper_found = abap_true.
                    ENDIF.
                    IF lv_del_index_or IS NOT INITIAL.
                      CLEAR lv_del_index_or.
                    ENDIF.

                  ELSEIF ls_clone_filter_option-operator = 'OR'.
                    IF lv_logic_oper IS INITIAL.
                      lv_logic_oper = 'OR'.
                      lv_logic_oper_found = abap_true.
                      lv_del_index_or = sy-tabix.
                    ENDIF.
                  ENDIF.
                ELSEIF lv_logic_oper = 'ANDNOT'.
                  IF lv_del_index_and_2 IS NOT INITIAL.
                    EXIT.
                  ELSE.
                    CONTINUE.
                  ENDIF.
                ELSEIF ls_complext_filter_condition-element = ls_clone_filter_option-element.
                  CONTINUE.
                ELSE."ls_clone_filter_option-element IS INITIAL.
                  IF lv_logic_oper_found = abap_true.
                    EXIT.
                  ELSEIF ls_clone_filter_option-element <> lv_current_element.
                    EXIT.
                  ELSE.
                    CONTINUE.
                  ENDIF.
                ENDIF.
              ENDLOOP.

              IF lv_logic_oper = 'NOTAND'.
                APPEND INITIAL LINE TO lt_filter_select_options ASSIGNING FIELD-SYMBOL(<fs_sel_opt>).
                CLEAR ls_sel_option.

                IF iv_tech_property_name = abap_true.
                  <fs_sel_opt>-property = ls_complext_filter_condition-element.
                ELSE.
                  READ TABLE lt_properties ASSIGNING FIELD-SYMBOL(<fs_property>) WITH KEY technical_name = ls_complext_filter_condition-element.
                  <fs_sel_opt>-property = <fs_property>-name.
                ENDIF.

                ls_sel_option-sign  = 'E'.
                ls_sel_option-low     = ls_complext_filter_condition-low.
                ls_sel_option-high    = ls_complext_filter_condition-high.
                APPEND ls_sel_option TO <fs_sel_opt>-select_options.

                "translate option
                IF line_exists( lt_oper_map[ oper_src = <fs_sel_opt>-select_options[ 1 ]-option ] ).
                  <fs_sel_opt>-select_options[ 1 ]-option = lt_oper_map[ oper_src = <fs_sel_opt>-select_options[ 1 ]-option ]-oper_trg.
                ELSE.
                  <fs_sel_opt>-select_options[ 1 ]-option = ls_complext_filter_condition-operator.
                ENDIF.

                IF lv_del_index_and IS NOT INITIAL.
                  DELETE lt_conv_comp_filter_condition INDEX lv_del_index_and.
                ENDIF.
                IF lv_del_index_not IS NOT INITIAL.
                  DELETE lt_conv_comp_filter_condition INDEX lv_del_index_not.
                ENDIF.
              ELSEIF lv_logic_oper = 'ANDNOT'. "Only Exclude between is converted 'ANDNOT'

                IF lv_oper_andnot_deleted = abap_false.
                  lv_oper_andnot_deleted = abap_true.
                  APPEND INITIAL LINE TO lt_filter_select_options ASSIGNING <fs_sel_opt>.
                  CLEAR ls_sel_option.

                  IF iv_tech_property_name = abap_true.
                    <fs_sel_opt>-property = ls_complext_filter_condition-element.
                  ELSE.
                    READ TABLE lt_properties ASSIGNING <fs_property> WITH KEY technical_name = ls_complext_filter_condition-element.
                    <fs_sel_opt>-property = <fs_property>-name.
                  ENDIF.

                  ls_sel_option-sign  = 'E'.
                  ls_sel_option-option  = 'BT'.
                  IF ls_complext_filter_condition-operator = 'LE'.
                    ls_sel_option-high     = ls_complext_filter_condition-low.
                  ELSEIF ls_complext_filter_condition-operator = 'GE'.
                    ls_sel_option-low     = ls_complext_filter_condition-low.
                  ENDIF.
                  APPEND ls_sel_option TO <fs_sel_opt>-select_options.
                ELSE.
                  IF <fs_sel_opt> IS ASSIGNED.
                    IF ls_complext_filter_condition-operator = 'LE'.
                      <fs_sel_opt>-select_options[ 1 ]-high = ls_complext_filter_condition-low.
                    ELSEIF ls_complext_filter_condition-operator = 'GE'.
                      <fs_sel_opt>-select_options[ 1 ]-low = ls_complext_filter_condition-low.
                    ENDIF.
                  ENDIF.

                  IF lv_del_index_and_2 IS NOT INITIAL.
                    DELETE lt_conv_comp_filter_condition INDEX lv_del_index_and_2.
                  ENDIF.

                  IF lv_del_index_not IS NOT INITIAL.
                    DELETE lt_conv_comp_filter_condition INDEX lv_del_index_not.
                  ENDIF.
                  IF lv_del_index_and IS NOT INITIAL.
                    DELETE lt_conv_comp_filter_condition INDEX lv_del_index_and.
                  ENDIF.
                  CLEAR lv_oper_andnot_deleted.
                ENDIF.
              ELSEIF lv_logic_oper = 'AND' OR lv_logic_oper = 'NOT' .
                APPEND INITIAL LINE TO lt_filter_select_options ASSIGNING <fs_sel_opt>.
                CLEAR ls_sel_option.

                IF iv_tech_property_name = abap_true.
                  <fs_sel_opt>-property = ls_complext_filter_condition-element.
                ELSE.
                  READ TABLE lt_properties ASSIGNING <fs_property> WITH KEY technical_name = ls_complext_filter_condition-element.
                  <fs_sel_opt>-property = <fs_property>-name.
                ENDIF.

                ls_sel_option-sign  = 'E'.
                ls_sel_option-low     = ls_complext_filter_condition-low.
                ls_sel_option-high    = ls_complext_filter_condition-high.
                ls_sel_option-option  = ls_complext_filter_condition-operator.
                APPEND ls_sel_option TO <fs_sel_opt>-select_options.

                lt_clone_filter_condition  = lt_conv_comp_filter_condition.
                lv_index = lv_index + 1.
                LOOP AT lt_clone_filter_condition TRANSPORTING NO FIELDS FROM lv_index WHERE element = lv_current_element.
                  EXIT.
                ENDLOOP.
                IF sy-subrc = 0.
                  "convert option.
                  IF line_exists( lt_oper_map[ oper_src = <fs_sel_opt>-select_options[ 1 ]-option ] ).
                    <fs_sel_opt>-select_options[ 1 ]-option = lt_oper_map[ oper_src = <fs_sel_opt>-select_options[ 1 ]-option ]-oper_trg.
                  ELSE.
                    <fs_sel_opt>-select_options[ 1 ]-option = ls_complext_filter_condition-operator.
                  ENDIF.


                  IF lv_del_index_and IS NOT INITIAL.
                    DELETE lt_conv_comp_filter_condition INDEX lv_del_index_and.
                  ELSEIF lv_del_index_not IS NOT INITIAL.
                    DELETE lt_conv_comp_filter_condition INDEX lv_del_index_not.
                  ENDIF.

                ELSE.
                  <fs_sel_opt>-select_options[ 1 ]-sign = 'I'.
                  IF lv_del_index_and IS NOT INITIAL.
                    DELETE lt_conv_comp_filter_condition INDEX lv_del_index_and.
                  ENDIF.
                ENDIF.
              ELSEIF lv_logic_oper = 'OR'.
                APPEND INITIAL LINE TO lt_filter_select_options ASSIGNING <fs_sel_opt>.
                CLEAR ls_sel_option.

                IF iv_tech_property_name = abap_true.
                  <fs_sel_opt>-property = ls_complext_filter_condition-element.
                ELSE.
                  READ TABLE lt_properties ASSIGNING <fs_property> WITH KEY technical_name = ls_complext_filter_condition-element.
                  <fs_sel_opt>-property = <fs_property>-name.
                ENDIF.

                ls_sel_option-sign  = 'I'.
                ls_sel_option-low     = ls_complext_filter_condition-low.
                ls_sel_option-high    = ls_complext_filter_condition-high.
                ls_sel_option-option  = ls_complext_filter_condition-operator.
                APPEND ls_sel_option TO <fs_sel_opt>-select_options.

                IF lv_del_index_or IS NOT INITIAL.
                  DELETE lt_conv_comp_filter_condition INDEX lv_del_index_or.
                ENDIF.
              ELSEIF lv_logic_oper IS INITIAL.
                APPEND INITIAL LINE TO lt_filter_select_options ASSIGNING <fs_sel_opt>.
                CLEAR ls_sel_option.

                IF iv_tech_property_name = abap_true.
                  <fs_sel_opt>-property = ls_complext_filter_condition-element.
                ELSE.
                  READ TABLE lt_properties ASSIGNING <fs_property> WITH KEY technical_name = ls_complext_filter_condition-element.
                  <fs_sel_opt>-property = <fs_property>-name.
                ENDIF.

                ls_sel_option-sign  = 'I'.
                ls_sel_option-low     = ls_complext_filter_condition-low.
                ls_sel_option-high    = ls_complext_filter_condition-high.
                ls_sel_option-option  = ls_complext_filter_condition-operator.
                APPEND ls_sel_option TO <fs_sel_opt>-select_options.

                IF lv_del_index_or IS NOT INITIAL.
                  DELETE lt_conv_comp_filter_condition INDEX lv_del_index_or.
                ENDIF.
              ENDIF.
              lv_pre_element =  ls_complext_filter_condition-element.

            ELSE." IF ls_complext_filter_condition-element IS NOT INITIAL.

            ENDIF.
          ENDLOOP.
        ENDIF.

        "Combine select options
        IF lt_filter_select_options IS NOT INITIAL.
          SORT lt_filter_select_options BY property.

          LOOP AT lt_filter_select_options ASSIGNING <fs_sel_opt>.
            IF <fs_sel_opt>-select_options[ 1 ]-option = 'NL'.
              <fs_sel_opt>-select_options[ 1 ]-option = 'EQ'.
              <fs_sel_opt>-select_options[ 1 ]-low = 'null'.
            ELSEIF <fs_sel_opt>-select_options[ 1 ]-sign = 'I' AND <fs_sel_opt>-select_options[ 1 ]-option = 'NE'.
              " from frontend, cannot choose sign = 'I' and option = 'NE', it should be sign = 'E' and option = 'EQ'
              <fs_sel_opt>-select_options[ 1 ]-sign   = 'E'.
              <fs_sel_opt>-select_options[ 1 ]-option = 'EQ'.
            ENDIF.
            IF ls_filter_select_options-property IS INITIAL.
              ls_filter_select_options-property = <fs_sel_opt>-property.
              ls_filter_select_options-select_options = <fs_sel_opt>-select_options.
            ELSEIF ls_filter_select_options-property <> <fs_sel_opt>-property.
              SORT ls_filter_select_options-select_options BY sign DESCENDING.
              APPEND ls_filter_select_options TO rt_select_option.
              CLEAR ls_filter_select_options.
              ls_filter_select_options-property = <fs_sel_opt>-property.
              ls_filter_select_options-select_options = <fs_sel_opt>-select_options.

            ELSEIF ls_filter_select_options-property = <fs_sel_opt>-property.
              APPEND LINES OF <fs_sel_opt>-select_options TO ls_filter_select_options-select_options.
            ENDIF.
          ENDLOOP.

          IF ls_filter_select_options IS NOT INITIAL.
            SORT ls_filter_select_options-select_options BY sign DESCENDING.
            APPEND ls_filter_select_options TO rt_select_option.
          ENDIF.
        ENDIF.
      ENDIF.
    CATCH cx_root.  "Ignore exception, return a blank filter range
  ENDTRY.

ENDMETHOD.


  METHOD get_copied_migration_objects.
    CHECK it_migration_object IS NOT INITIAL AND io_project_proxy IS NOT INITIAL.
    DATA(lt_obj_id) = VALUE /ltb/mc_t_object_uuid( FOR migration_object IN it_migration_object ( migration_object-migobj_uuid ) ).

    TRY.
        DATA(lo_project_context) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
        lo_project_context->set_filter_cond( VALUE #(
           (
             field = 'DEP_TYPE'
             sign  = 'I'
             oper  = 'EQ'
             low   = /ltb/if_mc_constants=>gc_dependency_type-predecessor
           )
       ) ).
        lo_project_context->set_selected_migration_obj( it_selected_migration_obj = lt_obj_id ).
        DATA(lv_proj_uuid) = io_project_proxy->get_project_uuid( ).
        DATA(lt_statistics) = io_project_proxy->get_migobj_statistics( io_cntxt = lo_project_context ).
        DATA(ls_proj_detail) = io_project_proxy->get_proj_details( lo_project_context ).

        LOOP AT it_migration_object INTO DATA(ls_mo) WHERE migobj_is_template = abap_true.
          READ TABLE lt_statistics INTO DATA(ls_statistic) WITH KEY migobj_uuid = ls_mo-migobj_uuid.
          IF sy-subrc = 0.
            CLEAR ls_statistic.
            ls_statistic-migobj_uuid = ls_mo-migobj_uuid.
            MODIFY lt_statistics FROM ls_statistic INDEX sy-tabix.
          ENDIF.
        ENDLOOP.

        ct_result = VALUE #( FOR stats IN lt_statistics
                               LET ls_obj = it_migration_object[ migobj_uuid = stats-migobj_uuid ]
                                 IN (
                                     migrationprojectuuid   = lv_proj_uuid
                                     migrationobjectuuid    = ls_obj-migobj_uuid "stats-migobj_uuid
                                     migrationobjectname    = ls_obj-migobj_descr "stats-migobj_descr
                                     iscopied               = abap_true
                                     migrationobjectactiivestatusuu = ls_obj-migobj_active
                                     migrationobjectactiivestatus = ls_obj-migobj_active
                                     migrationsuccesscount  = stats-num_items_migrated
                                     migrationerrorcount    = stats-num_items_migrated_err
                                     simulationsuccesscount = stats-num_items_simulated
                                     simulationerrorcount   = stats-num_items_simulated_err
                                     simulationnotavailable = stats-sim_not_available
                                     selectioncount         = stats-num_items_selected
                                     opentaskcount          = stats-num_tasks_open
                                     confirmedtaskcount     = stats-num_tasks_done
                                     errortaskcount         = stats-num_tasks_error
                                     preparemapnotprocessedcount = stats-num_items_not_processed
                                     preparemappingerrorcount  = stats-num_items_prepared_err
                                     notmigratedcount       = stats-num_items_selected - stats-num_items_migrated - stats-num_items_migrated_err - stats-num_items_exclude - stats-num_items_migrt_inprocess - stats-num_items_partly_mig
                                     numofpredecessor       = stats-migobj_num_deps
                                     defaultaction          = stats-default_action
                                     numofstagingtable      = stats-num_staging_table
                                     latesteventstatus      = get_latest_event_info( CONV #( ls_obj-migobj_latest_event ) )-event_status
                                     migrationobjectstatus  = get_migration_object_status( iv_number_migrated_err = stats-num_items_migrated_err
                                                                                           iv_number_simulated_err = stats-num_items_simulated_err
                                                                                           iv_number_migrated = stats-num_items_migrated
                                                                                           iv_number_remaining = ( stats-num_items_selected - stats-num_items_migrated - stats-num_items_exclude )
                                                                                           iv_event_status = get_latest_event_info( CONV #( ls_obj-migobj_latest_event ) )-event_status )
                                     excludecount           = stats-num_items_exclude
                                     partlymigcount         = stats-num_items_partly_mig
                                     preliminaryopentaskcount = stats-num_pre_task_open
                                     hasmultsteps           = ls_obj-migobj_has_mult_steps
                                     finalsteps             = ls_obj-final_steps
                                     nonfinalsteps          = ls_obj-non_final_steps
                                     inprocesscount         = stats-num_items_inprocess
                                     numbackgroundjob       = ls_obj-migobj_num_jobs
                                     upgradestate           = ls_obj-migobj_upg_state
                                     lifecycletext          = ls_obj-lifecycle_text
                                     successorobjectuuid    = ls_obj-successor_object_uuid
                                     migrationobjectlatestevent = get_latest_event_info( CONV #( ls_obj-migobj_latest_event ) )-history_text
                                     preparemappingavailable   = stats-prepare_mapping_available
        )
).
      CATCH /ltb/cx_mc_static_check_msg.
        MESSAGE e006(/ltb/mc) INTO DATA(lv_message).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lv_message
        ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_entity_components.
    DATA(lv_component_name) = iv_component_name.

    CASE iv_entity_set_name.
      WHEN  'MigrationTemplateObjectSet'.
        TRANSLATE lv_component_name TO UPPER CASE.
        CASE lv_component_name.
          WHEN 'MIGRATIONOBJECTUUID'.
            rv_component_name = 'MIGOBJ_UUID'.
          WHEN 'MIGRATIONOBJECTNAME'.
            rv_component_name = 'MIGOBJ_DESCR'.
          WHEN 'DOCUMENTID'.
            rv_component_name = 'MIGOBJ_DOC_DESCR'.
          WHEN 'DOCUMENTURL'.
            rv_component_name = 'MIGOBJ_DOC_URL'.
          WHEN 'NUMOFDEPENDENCIES'.
            rv_component_name = 'MIGOBJ_NUM_DEPS'.
          WHEN 'NUMOFINUSE'.
            rv_component_name = 'MIGOBJ_NUM_PROJ'.
          WHEN 'DEPENDENCYTYPE'.
            rv_component_name = 'DEP_TYPE'.
          WHEN OTHERS.
            rv_component_name = lv_component_name.
        ENDCASE.
      WHEN  'MigrationObjectCopySet'.
        TRANSLATE lv_component_name TO UPPER CASE.
        CASE lv_component_name.
          WHEN 'MIGRATIONOBJECTUUID'.
            rv_component_name = 'MIGOBJ_UUID'.
          WHEN 'MIGRATIONOBJECTNAME'.
            rv_component_name = 'MIGOBJ_DESCR'.
          WHEN 'DOCUMENTID'.
            rv_component_name = 'MIGOBJ_DOC_DESCR'.
          WHEN 'DOCUMENTURL'.
            rv_component_name = 'MIGOBJ_DOC_URL'.
          WHEN 'NUMOFDEPENDENCIES'.
            rv_component_name = 'MIGOBJ_NUM_DEPS'.
          WHEN 'NUMOFINUSE'.
            rv_component_name = 'MIGOBJ_NUM_PROJ'.
          WHEN 'DEPENDENCYTYPE'.
            rv_component_name = 'DEP_TYPE'.
          WHEN 'ACTIVE'.
            rv_component_name = 'MIGOBJ_ACTIVE'.
          WHEN OTHERS.
            rv_component_name = lv_component_name.
        ENDCASE.
      WHEN 'ActivityTrackSet'.
        CASE lv_component_name.
          WHEN 'MigrationObjectName'.
            rv_component_name = 'MIGOBJ_DESCR'.
          WHEN 'EventTimeAt'.
            rv_component_name = 'EVENT_TIME'.
          WHEN 'EventType'.
            rv_component_name = 'EVENT_ACTION'.
          WHEN 'EventStatus'.
            rv_component_name = 'EVENT_STATUS'.
        ENDCASE.
      WHEN 'ApplActivityTrackSet' OR 'ApplActivityMonitorSet'.
        CASE lv_component_name.
          WHEN 'MigrationProjectName'.
            rv_component_name = 'MIGPROJ_DESCR'.
          WHEN 'EventTimeAt'.
            rv_component_name = 'EVENT_TIME'.
          WHEN 'EventType'.
            rv_component_name = 'EVENT_ACTION'.
          WHEN 'EventStatus'.
            rv_component_name = 'EVENT_STATUS'.
        ENDCASE.
      WHEN 'MigrationObjectSet'.
        CASE lv_component_name.
          WHEN 'MigrationObjectName'.
            rv_component_name = 'MIGOBJ_DESCR'.
          WHEN 'MigrationObjectActiveStatus'.
            rv_component_name = 'MIGOBJ_ACTIVE'.
          WHEN 'MigrationObjectStatus'.
            rv_component_name = 'MIGOBJ_STATUS'.
          WHEN 'ConfirmedTaskCount'.
            rv_component_name = 'NUM_TASKS_DONE'.
          WHEN 'SelectionCount'.
            rv_component_name = 'NUM_ITEMS_SELECTED'.
          WHEN 'OpenTaskCount'.
            rv_component_name = 'NUM_TASKS_OPEN'.
          WHEN 'SimulationSuccessCount'.
            rv_component_name = 'NUM_ITEMS_SIMULATED'.
          WHEN 'SimulationErrorCount'.
            rv_component_name = 'NUM_ITEMS_SIMULATED_ERR'.
          WHEN 'MigrationSuccessCount'.
            rv_component_name = 'NUM_ITEMS_MIGRATED'.
          WHEN 'MigrationErrorCount'.
            rv_component_name = 'NUM_ITEMS_MIGRATED_ERR'.
        ENDCASE.
      WHEN 'MessageGroupSet'.
        CASE lv_component_name.
          WHEN 'MessageGroupType'.
            rv_component_name = 'GROUP_MSGTY'.
          WHEN 'MessageGroupTitle'.
            rv_component_name = 'GROUP_TITLE'.
          WHEN 'MessageGroupMsgId'.
            rv_component_name = 'GROUP_MSGID'.
          WHEN 'MessageGroupMsgNo'.
            rv_component_name = 'GROUP_MSGNO'.
          WHEN 'MessageCount'.
            rv_component_name = 'GROUP_MSGCNT'.
          WHEN 'MigrationObjectName'.
            rv_component_name = 'MIGOBJ_NAME'.
          WHEN 'MessageGroupDateTime'.
            rv_component_name = 'LAST_DATETIME'.
          WHEN 'TypeDescription'.
            rv_component_name = 'GROUP_MSGTY'.
          WHEN 'DisplayOption'.
            rv_component_name = 'DISPLAYOPTION'.
          WHEN 'Event'.
            rv_component_name = 'GROUP_EVENT'.
        ENDCASE.
      WHEN 'MigrationProjectSet'.
        CASE lv_component_name.
          WHEN 'MigrationProjectUUID'.
            rv_component_name = 'MIGATIONPROJECTUUID'."'PROJ_UUID'.
          WHEN 'MigrationScenario'.
            rv_component_name = 'PROJECTSCENARIO'.
          WHEN 'MigrationProjectName'.
            rv_component_name = 'PROJECTDESCRIPTION'."'PROJ_NAME'.
          WHEN 'MigrationProjectStatusUUID' OR 'MigrationProjectStatus'.
            rv_component_name = 'PROJECTSTATUS'."'PROJ_STATUS'.
          WHEN 'MigrationApproachUUID' OR 'MigrationApproach'.
            rv_component_name = 'MIGRATIONAPPROACH'.
          WHEN 'ConnectionName'.
            rv_component_name = 'MIGRATIONDESTINATION'.
          WHEN 'CreateBy'.
            rv_component_name = 'CREATEDBY'."'PROJ_CREATED_BY'.
          WHEN 'CreatedAt'.
            rv_component_name = 'CREATEDON'.
          WHEN 'MigrationObjectCount'.
            rv_component_name = 'PROJECTNUMOBJECTS'.
          WHEN 'ConnectionDescr'.
            rv_component_name = 'MIGRATIONDESTINATIONDESCR'.
        ENDCASE.
      WHEN 'ApplicationLogSet'.
        CASE lv_component_name.
          WHEN 'ApplLognr'.
            rv_component_name = 'APPLLOGNR'.
          WHEN 'MsgMsgty' OR 'MsgMsgtyDesc'.
            rv_component_name = 'MSGMSGTY'.
          WHEN 'MsgMsgid'.
            rv_component_name = 'MSGMSGID'.
          WHEN 'MsgMsgno'.
            rv_component_name = 'MSGMSGNO'.
          WHEN 'MsgTitle'.
            rv_component_name = 'MSGTITLE'.
          WHEN 'LastDatetime'.
            rv_component_name = 'LASTDATETIME'.
          WHEN 'MsgMsgcnt'.
            rv_component_name = 'MSGMSGCNT'.
          WHEN 'MigrationObjectErrorcnt'.
            rv_component_name = 'MIGRATIONOBJECTERRORCNT'.
        ENDCASE.
      WHEN 'ApplicationLogDetailSet'.
        CASE lv_component_name.
          WHEN 'MessageDetailTitle'.
            rv_component_name = 'MSGTITLE'.
          WHEN 'MessageDetailDatetime'.
            rv_component_name = 'LASTDATETIME'.
          WHEN 'MessageDetailType' OR 'MessageDetailTypeDesc'.
            rv_component_name = 'MSGMSGTY'.
          WHEN 'MessageDetailV1'.
            rv_component_name = 'MSGMSGV1'.
          WHEN 'MessageDetailV2'.
            rv_component_name = 'MSGMSGV2'.
          WHEN 'MessageDetailV3'.
            rv_component_name = 'MSGMSGV3'.
          WHEN 'MessageDetailV4'.
            rv_component_name = 'MSGMSGV4'.
        ENDCASE.
      WHEN 'MessageDetailSet'.
        CASE lv_component_name.
          WHEN 'MessageDetailTitle'.
            rv_component_name = 'MSG_TITLE'.
          WHEN 'MessageDetailDatetime'.
            rv_component_name = 'MSG_DATETIME'.
          WHEN 'MessageDetailType'.
            rv_component_name = 'MSG_TYPE'.
          WHEN 'MessageDetailV1'.
            rv_component_name = 'MSG_VAR1'.
          WHEN 'MessageDetailV2'.
            rv_component_name = 'MSG_VAR2'.
          WHEN 'MessageDetailV3'.
            rv_component_name = 'MSG_VAR3'.
          WHEN 'MessageDetailV4'.
            rv_component_name = 'MSG_VAR4'.
        ENDCASE.
      WHEN 'TaskItemSet'.
        TRANSLATE lv_component_name TO UPPER CASE.
        CASE lv_component_name.
          WHEN 'TASKITEMSTATUS'.
            rv_component_name = 'STATUS'.
          WHEN 'TASKITEMSTATUSUUID'.
            rv_component_name = 'STATE'.
          WHEN 'TARGETVALUE'.
            rv_component_name = 'TGT_VAL'.
          WHEN 'SOURCEVALUE1'.
            rv_component_name = 'SRC_VAL1'.
          WHEN 'SOURCEVALUE2'.
            rv_component_name = 'SRC_VAL2'.
          WHEN 'SOURCEVALUE3'.
            rv_component_name = 'SRC_VAL3'.
          WHEN 'SOURCEVALUE4'.
            rv_component_name = 'SRC_VAL4'.
          WHEN 'SOURCEVALUE5'.
            rv_component_name = 'SRC_VAL5'.
        ENDCASE.
      WHEN 'TaskItemVHSet'.
        CASE lv_component_name.
          WHEN 'VALUE'.
            rv_component_name = 'TGT_VAL'.
        ENDCASE.
      WHEN 'TaskSet'.
        CASE lv_component_name.
          WHEN 'TASKSTATUSUUID'.
            rv_component_name = 'TASK_STATUS'.
        ENDCASE.
      WHEN 'MigrationProjectHistorySet'.
        CASE lv_component_name.
          WHEN 'MigrationProjectHistoryType'.
            rv_component_name = 'TEXT_HISTORY'.
          WHEN 'StartedBy'.
            rv_component_name = 'STARTED_BY_NAME'.
          WHEN 'StartedAt'.
            rv_component_name = 'STARTED_AT'.
          WHEN 'FinishedAt'.
            rv_component_name = 'FINISHED_AT'.
        ENDCASE.
      WHEN 'StagingOverviewSet'.
        CASE lv_component_name.
          WHEN 'Name'.
            rv_component_name = 'DESCRIPTION'.
          WHEN 'DataCount'.
            rv_component_name = 'NUM_RECORDS'.
          WHEN 'Status'.
            rv_component_name = 'IS_CONSISTENT'.
          WHEN 'TechID'.
            rv_component_name = 'TAB_UUID'.
          WHEN 'TechName'.
            rv_component_name = 'TABNAME'.
        ENDCASE.
      WHEN 'TableColumnsSet'.
        CASE lv_component_name.
          WHEN 'FieldType'.
            rv_component_name = 'FIELDTYPE'.
          WHEN 'Decimals'.
            rv_component_name = 'DECIMALS'.
          WHEN 'Description'.
            rv_component_name = 'TOOLTIP'.
          WHEN 'Group'.
            rv_component_name = 'GROUP'.
          WHEN 'FieldLength'.
            rv_component_name = 'FIELDLENGTH'.
          WHEN 'IsMandatory'.
            rv_component_name = 'IS_MANDATORY'.
          WHEN 'IsKey'.
            rv_component_name = 'IS_KEY'.
          WHEN 'FieldLabel'.
            rv_component_name = 'DESCRIPTION'.
          WHEN 'FieldName'.
            rv_component_name = 'FIELDNAME'.
          WHEN 'NotNull'.
            rv_component_name = 'NOTNULL'.
        ENDCASE.
      WHEN 'TableData'.
        rv_component_name = to_upper( lv_component_name ).
      WHEN 'MigrationFileContent' OR 'MigrationFileContentSet'.
        rv_component_name = to_upper( lv_component_name ).
      WHEN 'ActivityMonitorSet'.
        CASE lv_component_name.
          WHEN 'EventTimeAt'.
            rv_component_name = 'EVENT_TIME'.
          WHEN 'EventType'.
            rv_component_name = 'EVENT_ACTION'.
          WHEN 'EventStatus'.
            rv_component_name = 'EVENT_STATUS'.
        ENDCASE.
      WHEN 'ActivityMonitorDetailSet'.
        CASE lv_component_name.
          WHEN 'EventStartedAt'.
            rv_component_name = 'EVENT_STARTED_AT'.
          WHEN 'EventStartedBy'.
            rv_component_name = 'EVENT_STARTED_BY'.
          WHEN 'EventFinishedAt'.
            rv_component_name = 'EVENT_FINISHED_AT'.
          WHEN 'ActivityObjectTypeID'.
            rv_component_name = 'ACTIVITY_OBJECT_TYPEID'.
          WHEN 'ActivityObjectName'.
            rv_component_name = 'ACTIVITY_OBJECT_NAME'.
          WHEN 'EventTypeID'.
            rv_component_name = 'EVENT_TYPE_ID'.
          WHEN 'EventStatusID'.
            rv_component_name = 'EVENT_STATUS_ID'.
        ENDCASE.
      WHEN 'ActivityMonitorFilterFieldSet'.
        CASE lv_component_name.
          WHEN 'FieldCode'.
            rv_component_name = 'FIELD_CODE'.
        ENDCASE.
      WHEN 'MigrationObjectJobSet'.
        CASE lv_component_name.
          WHEN 'NumBackgroundJob'.
            rv_component_name = 'NUMBACKGROUNDJOB'.
          WHEN 'MigrationObjectDescription'.
            rv_component_name = 'MIGRATIONOBJECTDESCRIPTION'.
        ENDCASE.
      WHEN 'TaskProcessing'.
        CASE lv_component_name.
          WHEN 'TaskDescr'.
            rv_component_name = 'TASK_DESCR'.
          WHEN 'NumOfFiles'.
            rv_component_name = 'NUM_FILES'.
        ENDCASE.
      WHEN 'TaskProcessingSet'.
        CASE lv_component_name.
          WHEN 'TaskDescr'.
            rv_component_name = 'TASK_DESCR'.
        ENDCASE.
      WHEN 'MigrationObjectMessageDetailsSet'.
        CASE lv_component_name.
          WHEN 'MessageDateTime'.
            rv_component_name = 'DATA_AND_TIME'.
          WHEN 'MessageTitle'.
            rv_component_name = 'GROUP_TITLE'.
          WHEN 'InstanceKey'.
            rv_component_name = 'INSTANCE_KEY'.
        ENDCASE.
      WHEN 'MigrationObjectMessageSet'.
        CASE lv_component_name.
          WHEN 'MessageGroupTitle'.
            rv_component_name = 'GROUP_TITLE'.
          WHEN 'InstanceCount'.
            rv_component_name = 'GROUP_INS_COUNT'.
          WHEN 'ActionDescription'.
            rv_component_name = 'GROUP_ACT_DESCR'.
          WHEN 'MessageGroupType'.
            rv_component_name = 'GROUP_MSGTY'.
          WHEN 'MessageGroupMsgId'.
            rv_component_name = 'GROUP_MSGID'.
          WHEN 'MessageGroupMsgNo'.
            rv_component_name = 'GROUP_MSGNO'.
        ENDCASE.

      WHEN 'ApplActivityMonitorDetailSet'.
        CASE lv_component_name.
          WHEN 'EventStartedAt'.
            rv_component_name = 'EVENT_STARTED_AT'.
          WHEN 'EventStartedBy'.
            rv_component_name = 'EVENT_STARTED_BY'.
          WHEN 'EventFinishedAt'.
            rv_component_name = 'EVENT_FINISHED_AT'.
          WHEN 'ActivityObjectTypeID'.
            rv_component_name = 'ACTIVITY_OBJECT_TYPEID'.
          WHEN 'MigrationProjectName'.
            rv_component_name = 'MIGPROJ_NAME'.
          WHEN 'EventTypeID'.
            rv_component_name = 'EVENT_TYPE_ID'.
          WHEN 'EventStatusID'.
            rv_component_name = 'EVENT_STATUS_ID'.
        ENDCASE.
      WHEN 'ApplActivityMonitorFilterSet'.
        CASE lv_component_name.
          WHEN 'FieldCode'.
            rv_component_name = 'FIELD_CODE'.
        ENDCASE.
    ENDCASE.

  ENDMETHOD.


  METHOD get_file_proc_stream.
    DATA:
      lv_project_uuid     TYPE /ltb/mc_proj_uuid,
      lv_act_uuid         TYPE /ltb/mc_act_uuid,
      lv_object_uuid      TYPE /ltb/mc_object_uuid,
      lv_object_uuids     TYPE string,
      lt_object_uuid      TYPE TABLE OF /ltb/mc_object_uuid,
      lt_selected_migobj  TYPE /ltb/mc_t_object_uuid,
      ls_header           TYPE ihttpnvp,
      ls_mc_message       TYPE bal_s_msg,
      lt_mc_messages      TYPE cnv_mbt_t_bal_s_msg,
      lv_timestamp_string TYPE string,
      ls_event_data       TYPE /ltb/cl_mc_eventlog_access=>gty_fileproc_info,
      lv_fileproc_uuid    TYPE /ltb/mc_fileproc_uuid,
      ls_event            TYPE /ltb/mc_eventlog,
      lv_filename         TYPE string,
      lv_filename_encode  TYPE string,
      lv_file_category    TYPE /ltb/mc_fileproc_cat.

    CONSTANTS: cs_etl TYPE string VALUE 'Data from ETL Tool'.

    READ TABLE it_key_tab WITH KEY name = co_migration_project_uuid INTO DATA(ls_key).
    IF sy-subrc = 0.
      "Get project UUID
      lv_project_uuid = ls_key-value.
    ENDIF.

    READ TABLE it_key_tab WITH KEY name = co_file_template_activityid INTO ls_key.
    IF sy-subrc = 0.
      "Get activity ID, if activity ID is not initial, directly get the file content
      lv_act_uuid = ls_key-value.
    ENDIF.

    READ TABLE it_key_tab WITH KEY name = co_migration_object_uuid INTO ls_key.
    IF sy-subrc = 0.
      "Get migration object UUID,if it is not initial, download template first and then return the content.
      lv_object_uuids = ls_key-value.
      IF lv_object_uuids IS NOT INITIAL.
        SPLIT lv_object_uuids AT ',' INTO TABLE lt_object_uuid.
        LOOP AT lt_object_uuid INTO DATA(lv_uuid).
          INSERT  lv_uuid INTO TABLE lt_selected_migobj.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF line_exists( it_key_tab[ name = co_filecategory ] ).
      lv_file_category = it_key_tab[ name = co_filecategory ]-value.
    ELSE.
      lv_file_category = /ltb/if_mc_constants=>gc_fileproc-category-xml.
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
        DATA(lo_project_ctx)   = NEW /ltb/cl_mc_cntxt_proj_detail( ).

        CASE TYPE OF lo_project_proxy.
          WHEN TYPE /ltb/cl_mc_proj_proxy_mwb.
            DATA(lo_mwb_proj) = CAST /ltb/cl_mc_proj_proxy_mwb( lo_project_proxy ).
            IF lv_act_uuid IS NOT INITIAL.
              ls_event = /ltb/cl_mc_eventlog_access=>get_last_event_by_actuuid( iv_proj_uuid = lv_project_uuid
                                                                                       iv_act_uuid = lv_act_uuid ).
            ELSE.
              ls_event-event_type = space.
            ENDIF.

            CASE ls_event-event_type.
              WHEN co_download_template_completed OR
                   /ltb/cl_mc_eventlog_access=>gc_event_type-download_file_tmpl_comp_warn OR space.
                IF lv_act_uuid IS INITIAL AND lt_selected_migobj IS INITIAL.
                  "No object is selected
                  RETURN.
                ENDIF.
                IF lt_selected_migobj IS NOT INITIAL AND lv_act_uuid IS INITIAL..
                  lo_project_ctx->set_selected_migration_obj( lt_selected_migobj ).

                  lo_project_ctx->add_value(
                    EXPORTING
                      iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-fileproc-filecategory
                      iv_value = CONV #( lv_file_category )
                  ).

                  "activity uuid is blank, download content first
                  lv_act_uuid = CAST /ltb/cl_mc_proj_proxy_mwb( lo_project_proxy )->download_file_template( lo_project_ctx ).
                ENDIF.

                DATA(ls_project_detail) = lo_project_proxy->get_proj_details( io_cntxt = lo_project_ctx ).
                lv_fileproc_uuid = lv_act_uuid.

                IF lv_fileproc_uuid IS NOT INITIAL.
                  lo_project_ctx->set_act_uuid( iv_act_uuid = lv_fileproc_uuid ).

                  DATA(lt_migobj) = lo_project_ctx->get_values_by_type( /ltb/if_mc_constants=>gc_cntxt_type-migobj_uuid ).
                  IF lines( lt_migobj ) = 1.
                    "xml file for single MO template
                    rs_stream-mime_type = SWITCH #( lv_file_category
                      WHEN /ltb/if_mc_constants=>gc_fileproc-category-xml THEN co_mime_type_xml
                      WHEN /ltb/if_mc_constants=>gc_fileproc-category-csv THEN co_mime_type_compressed_zip
                    ).

                    "retrieve compressed data and then unzip it, only one file in the zip folder
                    DATA(lv_file_data) = lo_mwb_proj->get_file_template_data( lo_project_ctx ).

                    IF lv_file_category = /ltb/if_mc_constants=>gc_fileproc-category-xml.
                      /ltb/cl_mc_fileproc_access=>unzip_one_file(
                        EXPORTING
                          iv_zip_data   = lv_file_data
                        IMPORTING
                          ev_filename   = DATA(lv_file_name)
                          ev_unzip_data = DATA(lv_unzip_data)
                      ).
                    ENDIF.

                    DATA(l_migobj_uuid) = lt_migobj[ 1 ].

                    DATA(l_obj_name) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( l_migobj_uuid ) )->get_migobj_name( ).

                    "Source data for <object name>.xml
                    lv_filename = SWITCH #( lv_file_category
                      WHEN /ltb/if_mc_constants=>gc_fileproc-category-xml
                        THEN |{ /ltb/if_mc_constants=>gc_filename_prefix-srcdata-single } { l_obj_name }{ /ltb/if_mc_constants=>gc_filename_ext-xml }|
                      WHEN  /ltb/if_mc_constants=>gc_fileproc-category-csv
                        THEN |{ /ltb/if_mc_constants=>gc_filename_prefix-srcdata-single } { l_obj_name }{ /ltb/if_mc_constants=>gc_filename_ext-zip }|
                    ).

                    lv_filename = /ltb/cl_mc_odata_generic_func=>replace_special_c_in_filename( iv_filename = lv_filename ).

                    lv_filename_encode = convert_file_name( lv_filename ).

                    ls_header-value = get_attachement_header_value(
                      iv_filename        = lv_filename
                      iv_filename_encode = lv_filename_encode
                    ).

                    rs_stream-value = SWITCH #( lv_file_category
                      WHEN /ltb/if_mc_constants=>gc_fileproc-category-xml THEN lv_unzip_data
                      WHEN /ltb/if_mc_constants=>gc_fileproc-category-csv THEN lv_file_data
                    ).
                  ELSE.
                    "zip file for multiple MO template
                    DATA(l_proj_name) = ls_project_detail-proj_descr.

                    "Source data - <project name>.zip
                    lv_filename = |{ /ltb/if_mc_constants=>gc_filename_prefix-srcdata-multiple } - { l_proj_name }{ /ltb/if_mc_constants=>gc_filename_ext-zip }|.

                    lv_filename = /ltb/cl_mc_odata_generic_func=>replace_special_c_in_filename( iv_filename = lv_filename ).

                    lv_filename_encode = convert_file_name( lv_filename ).

                    ls_header-value = get_attachement_header_value(
                      iv_filename        = lv_filename
                      iv_filename_encode = lv_filename_encode
                    ).

                    rs_stream-mime_type = co_mime_type_compressed_zip.
                    rs_stream-value = lo_mwb_proj->get_file_template_data( lo_project_ctx ).
                  ENDIF.

                  ls_header-name = 'Content-Disposition' ##NO_TEXT.
                  set_header( is_header = ls_header ).
                ENDIF.

              WHEN co_file_generation_completed.
                "Parse the json string to get file ID and file name
                CALL TRANSFORMATION id SOURCE XML  ls_event-event_data
                   RESULT data =  ls_event_data .

                lv_fileproc_uuid = ls_event_data-fileproc_uuid.
                lv_file_name = ls_event_data-file_name.

                lv_file_name = replace(
                  val  = lv_file_name
                  sub  = /ltb/if_mc_constants=>gc_filename_ext-xml
                  with = ''
                  case = abap_false
                  occ  = 0
                ).

                "Correction file for <filename> (<timestamp>).zip
                IF lv_file_name = ''.
                  lv_filename = |{ /ltb/if_mc_constants=>gc_filename_prefix-corrfile } { cs_etl }{ /ltb/if_mc_constants=>gc_filename_ext-zip }|.
                ELSE.
                  lv_filename = |{ /ltb/if_mc_constants=>gc_filename_prefix-corrfile } { lv_file_name }{ /ltb/if_mc_constants=>gc_filename_ext-zip }|.
                ENDIF.

                lv_filename = /ltb/cl_mc_odata_generic_func=>replace_special_c_in_filename( iv_filename = lv_filename ).

                lv_filename_encode = convert_file_name( lv_filename ).

                ls_header-value = get_attachement_header_value(
                  iv_filename        = lv_filename
                  iv_filename_encode = lv_filename_encode
                ).

                IF lv_fileproc_uuid IS NOT INITIAL. "move up and leave its implementation intact
                  lo_project_ctx->set_act_uuid( iv_act_uuid = lv_fileproc_uuid ).
                  rs_stream-value = lo_mwb_proj->get_file_template_data( lo_project_ctx ).

                  rs_stream-mime_type = co_mime_type_compressed_zip.
                  ls_header-name = 'Content-Disposition' ##NO_TEXT.

                  set_header( is_header = ls_header ).
                ENDIF.
              WHEN OTHERS.
                RETURN.
            ENDCASE.

            IF lv_fileproc_uuid IS INITIAL.
              raise_bussiness_exception(
                EXPORTING
                  iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error ).
            ENDIF.
          WHEN OTHERS.
            "this should not happen
            IF 1 = 0. MESSAGE e131(/ltb/mc). ENDIF.
            ls_mc_message-msgid = '/LTB/MC'.
            ls_mc_message-msgno = '131'. "Download of Excel templates not possible for this project
            ls_mc_message-msgty = 'E'.
            APPEND ls_mc_message TO lt_mc_messages.
            raise_bussiness_exception(
              EXPORTING
                iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
                it_message = lt_mc_messages ).
        ENDCASE.
      CATCH  /ltb/cx_mc_static_check_msg INTO DATA(lo_mc_static_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_mc_static_exception->get_text( )
            it_message           = lo_mc_static_exception->get_messages( )
        ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_inprogress_mo_list.
    DATA:
      ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_inprogressmolist.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    TRY.
        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
        DATA(lo_cntxt_obj) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        lo_cntxt_obj->set_filter_cond( VALUE #( ( field = 'MIGOBJ_ACTIVE'
                                                  sign  = 'I'
                                                  oper  = 'EQ'
                                                  low   = /ltb/if_mc_constants=>gc_migobj_active-active ) ) ).
        DATA(lt_statisics) = lo_proj_proxy->get_migobj_statistics( io_cntxt = lo_cntxt_obj ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        DATA(lt_mc_messages) = lo_exception->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
    ENDTRY.

    ct_result = VALUE #( FOR stats IN lt_statisics
                           ( migrationprojectuuid   = ls_parameter-migrationprojectuuid
                             migrationobjectuuid    = stats-migobj_uuid
                             confirmedtaskcount     = stats-num_tasks_done
                             migrationerrorcount    = stats-num_items_migrated_err
                             migrationsuccesscount  = stats-num_items_migrated
                             opentaskcount          = stats-num_tasks_open
                             selectioncount         = stats-num_items_selected
                             simulationerrorcount   = stats-num_items_simulated_err
                             simulationsuccesscount = stats-num_items_simulated
                             notmigratedcount       = stats-num_items_selected - stats-num_items_migrated - stats-num_items_migrated_err
                             partlymigcount         = stats-num_items_partly_mig
                            ) ).

  ENDMETHOD.


  METHOD get_json_name_mappings.
    DATA lr_struc TYPE REF TO cl_abap_structdescr.
    DATA ls_name_mapping TYPE /ui2/cl_json=>name_mapping.

    DATA(lo_type_ref) = cl_abap_typedescr=>describe_by_data( p_data = is_data ).
    IF lo_type_ref->type_kind = cl_abap_typedescr=>typekind_struct1.
      "Get the fieldnames of the structure
      lr_struc ?= cl_abap_structdescr=>describe_by_data( is_data ).
      DATA(lt_comp) = lr_struc->get_components( ).

      "Concatenate '_' and '-'
      CONCATENATE /ltb/if_mc_constants=>gc_characters-underscore
                  /ltb/if_mc_constants=>gc_characters-hyphen INTO DATA(lv_slash_repl).

      LOOP AT lt_comp ASSIGNING FIELD-SYMBOL(<ls_comp>).
        FIND /ltb/if_mc_constants=>gc_characters-slash IN <ls_comp>-name.
        IF sy-subrc = 0.
          ls_name_mapping-abap = <ls_comp>-name.
          "Replace '/' with '_-'
          REPLACE ALL OCCURRENCES OF /ltb/if_mc_constants=>gc_characters-slash IN <ls_comp>-name WITH lv_slash_repl.
          ls_name_mapping-json = <ls_comp>-name.
          INSERT ls_name_mapping INTO TABLE rt_name_mappings.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD get_language_batch.
    CONSTANTS:
      lco_lang_parameter TYPE string VALUE 'accept-language',
      lco_default_lang   TYPE string VALUE 'EN'.
    READ TABLE it_changeset_request INTO DATA(ls_changeset_request) INDEX 1.
    IF line_exists( ls_changeset_request-request_headers[ name = lco_lang_parameter ] ).
      mv_language = ls_changeset_request-request_headers[ name = lco_lang_parameter ]-value.
      TRANSLATE mv_language TO UPPER CASE.
    ELSE.
      mv_language = lco_default_lang.
    ENDIF.
  ENDMETHOD.


  method GET_LATEST_EVENT_INFO.
    CHECK /ltb/cl_mc_eventlog_access=>is_event_type_assigned( iv_event_type      = iv_latest_event
                                                              iv_event_dimension = /ltb/cl_mc_eventlog_custloader=>gc_cust-dimension-visible_latest_history ) = abap_true.
    rs_event_info = /ltb/cl_mc_eventlog_access=>get_event_info( iv_latest_event ).
  endmethod.


  METHOD get_latest_event_text.

    IF /ltb/cl_mc_eventlog_access=>is_event_type_assigned(
                                                                   iv_event_type      = iv_event_type
                                                                   iv_event_dimension = /ltb/cl_mc_eventlog_custloader=>gc_cust-dimension-visible_latest_history ) = abap_true.
      rv_latest_event = /ltb/cl_mc_eventlog_access=>get_event_info( iv_event_type )-history_text.
    ELSE.
      IF iv_event_type = 'MIGRATION FAILED' ." AND iv_migrate_number = 0.
        rv_latest_event = /ltb/cl_mc_eventlog_access=>get_event_info( iv_event_type )-history_text.
      ELSEIF iv_event_type = 'SIMULATION FAILED' ." AND iv_simulate_number = 0.
        rv_latest_event = /ltb/cl_mc_eventlog_access=>get_event_info( iv_event_type )-history_text.
      ELSE.
        rv_latest_event = ''.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_longtext_from_msg.


    /ltb/cl_mc_odata_generic_func=>get_msg_longtext_as_html(
      EXPORTING
        iv_msgno = iv_msgno
        iv_msgid = iv_msgid
        iv_msgv1 = iv_msgv1
        iv_msgv2 = iv_msgv2
        iv_msgv3 = iv_msgv3
        iv_msgv4 = iv_msgv4
        iv_balog = iv_balog
        iv_bamsg = iv_bamsg
      IMPORTING
        ev_longtext_exists =  ev_is_longtext_exist
      RECEIVING
        rt_html            = DATA(lt_html)
    ).

    CONCATENATE LINES OF lt_html INTO rv_htmlstring  SEPARATED BY space RESPECTING BLANKS.

  ENDMETHOD.


  METHOD get_migration_object_status.
    IF iv_number_migrated_err > 0 OR
      iv_number_simulated_err > 0 OR
      iv_event_status CA 'EX'.
      rv_status = /ltb/if_mc_constants=>gc_migobj_status-error.
    ELSEIF iv_number_migrated > 0 AND iv_number_remaining = 0.
      rv_status = /ltb/if_mc_constants=>gc_migobj_status-success.
    ELSE.
      rv_status = /ltb/if_mc_constants=>gc_migobj_status-initial.
    ENDIF.
  ENDMETHOD.


  METHOD get_mo_task_list.
    DATA:
      ls_odata_task  TYPE /ltb/cl_mig_mc_odata_mpc=>ts_task,
      lt_filter_cond TYPE /ltb/if_mc_constants=>gtt_filter_cond.

    CONSTANTS:
      lco_task_status_field_name TYPE string VALUE 'TASK_STATUS',
      lco_task_status            TYPE string VALUE 'TASKSTATUSUUID'.

    CLEAR ev_confirmed_task_count.
    CLEAR ev_open_task_count.
    CLEAR ev_info_loss_task_count.
    TRY.
        DATA(lo_object_proxy) = io_proj_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = iv_object_id ).
        DATA(lo_task_context) = NEW /ltb/cl_mc_cntxt_task_detail( ).
        DATA(lo_taskitem_ctx) = NEW /ltb/cl_mc_cntxt_task_detail( ).
        DATA(ls_proj)         = io_proj_proxy->get_proj_details( lo_task_context ).

        IF io_tech_request_context IS BOUND.
          DATA(lt_filter_select_option) = io_tech_request_context->get_filter( )->get_filter_select_options( ).

          set_context( iv_entity_set_name = io_tech_request_context->get_entity_set_name( )
            iv_search_string = io_tech_request_context->get_search_string( )
            it_filter_select_options = lt_filter_select_option
            io_context = lo_task_context
            ).
        ENDIF.

        lo_object_proxy->get_tasks(
          EXPORTING io_cntxt = lo_task_context
          IMPORTING et_data  = DATA(lt_task) ).

        LOOP AT lt_task INTO DATA(ls_task)
            WHERE task_status = /ltb/if_mc_constants=>gc_task_status-confirmed OR
                  task_status = /ltb/if_mc_constants=>gc_task_status-info_loss OR
                  task_status = /ltb/if_mc_constants=>gc_task_status-open ##INTO_OK.
*         The task should not be duplicate
          READ TABLE ct_result WITH KEY migrationprojectuuid = ls_proj-proj_uuid
                                        migrationtaskuuid    = ls_task-task_uuid TRANSPORTING NO FIELDS.
          IF sy-subrc = 0.
            CONTINUE.
          ENDIF.
          DATA(lo_task) = lo_object_proxy->get_task_proxy_by_uuid( iv_task_uuid = ls_task-task_uuid ).
          lo_task->get_values(
            EXPORTING
              io_cntxt = lo_taskitem_ctx
            IMPORTING
              ev_count  = DATA(lv_value_count) ).

          ls_odata_task = VALUE #( migrationprojectuuid = ls_proj-proj_uuid
                                   migrationobjectuuid  = iv_object_id
                                   migrationtaskuuid    = ls_task-task_uuid
                                   taskname             = ls_task-task_descr
                                   tasktechname         = ls_task-task_name
                                   tasktempid           = ls_task-task_tmpl_uuid
                                   taskstatusuuid       = ls_task-task_status
                                   taskstatus           = get_task_status_text( iv_status = ls_task-task_status )
                                   tasktypeid           = ls_task-task_type
                                   tasktype             = get_task_type_text( ls_task-task_type )
                                   taskitemcount        = lv_value_count
                                   hascheck             = ls_task-hascheck
                                 ).

          IF ls_odata_task-taskstatusuuid = /ltb/if_mc_constants=>gc_task_status-confirmed.
            ev_confirmed_task_count = ev_confirmed_task_count + 1.
          ELSEIF ls_odata_task-taskstatusuuid = /ltb/if_mc_constants=>gc_task_status-open.
            ev_open_task_count = ev_open_task_count + 1.
          ELSEIF ls_odata_task-taskstatusuuid = /ltb/if_mc_constants=>gc_task_status-info_loss.
            ev_info_loss_task_count  = ev_info_loss_task_count + 1.
          ENDIF.

          APPEND ls_odata_task TO ct_result.
        ENDLOOP.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        DATA(lt_mc_messages) = lo_exception->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_project_content_stream.
    DATA:
      lv_project_uuid TYPE /ltb/mc_proj_uuid,
      lv_act_uuid     TYPE /ltb/mc_act_uuid,
      ls_header       TYPE ihttpnvp,
      lv_file_name    TYPE string.


    READ TABLE it_key_tab WITH KEY name = co_migration_project_uuid INTO DATA(ls_key).
    IF sy-subrc = 0.
      lv_project_uuid = ls_key-value.
    ENDIF.

    READ TABLE it_key_tab WITH KEY name = co_migration_activity_uuid INTO ls_key.
    IF sy-subrc = 0.
      lv_act_uuid = ls_key-value.
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
        DATA(lo_project_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
        DATA(ls_project_detail) = lo_project_proxy->get_proj_details( io_cntxt = lo_project_ctx ).

        lo_project_ctx->set_act_uuid( iv_act_uuid = lv_act_uuid ).

        rs_stream-value = lo_project_proxy->download_proj( io_cntxt = lo_project_ctx ).
        rs_stream-mime_type = co_mime_type_compressed_zip.

        ls_header-name = 'Content-Disposition' ##NO_TEXT.

        "Handle cracked file name in ZH language
        lv_file_name = ls_project_detail-proj_descr.
        lv_file_name = convert_file_name( lv_file_name ).

        CONCATENATE `attachment; filename="` lv_file_name `.zip";` INTO ls_header-value ##NO_TEXT.
        set_header( is_header = ls_header ).

      CATCH  /ltb/cx_mc_static_check_msg INTO DATA(lo_mc_static_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_mc_static_exception->get_text( )
        ).
    ENDTRY.

  ENDMETHOD.


  METHOD get_project_status_text.
    CASE iv_status.
      WHEN /ltb/if_mc_constants=>gc_proj_status-finished.
        rv_text = get_text( EXPORTING iv_id = 'P01' ). "Finished
      WHEN /ltb/if_mc_constants=>gc_proj_status-in_process.
        rv_text = get_text( EXPORTING iv_id = 'P02' ). "In progressing
      WHEN /ltb/if_mc_constants=>gc_proj_status-imported.
        rv_text = get_text( EXPORTING iv_id = 'P04' ). "Imported
      WHEN OTHERS.
        rv_text = rv_text = get_text( EXPORTING iv_id = 'P03' ). "Not Started
    ENDCASE.
  ENDMETHOD.


  METHOD get_search_help_fields.

    DATA lv_shlp_name         TYPE shlpname.
    DATA lv_shlp_step         TYPE i.
    DATA lt_shlp_properties   TYPE tt_shlp_properties.
    DATA ls_shlp_properties   TYPE ts_shlp_properties.
    DATA lt_import_properties TYPE tt_shlp_properties.
    DATA lt_export_properties TYPE tt_shlp_properties.
    DATA lv_ret_field TYPE fieldname.

    lv_shlp_name = iv_search_help_name.
    lv_shlp_step = iv_search_help_step.

    get_search_help_properties(
      EXPORTING
        iv_shlp_name = lv_shlp_name
      IMPORTING
        et_field_set = lt_shlp_properties
        ev_star_field = lv_ret_field ).

    CLEAR lt_import_properties.
    CLEAR lt_export_properties.

* Delete unsupported search properties
    LOOP AT lt_shlp_properties INTO ls_shlp_properties.
      IF ls_shlp_properties-shlplispos <> 0
        OR ls_shlp_properties-shlpoutput = abap_true.
        APPEND ls_shlp_properties TO lt_export_properties.
      ENDIF.

      IF  ls_shlp_properties-shlpselpos <> 0
        OR ls_shlp_properties-shlpinput = abap_true.
        APPEND ls_shlp_properties TO lt_import_properties.
      ENDIF.
    ENDLOOP.

* Set the sort order of range tables and output parameters based on SPos and LPos values
    SORT lt_export_properties BY shlplispos.
    SORT lt_import_properties BY shlpselpos.

    CASE lv_shlp_step.
      WHEN co_value_help_step_import.
        et_fields = VALUE #( FOR <fs_import> IN lt_import_properties
                                ( valuehelptype = co_value_help_search_help
                                  valuehelpname = lv_shlp_name
                                  valuehelpstep = lv_shlp_step
                                  fieldname = <fs_import>-fields-fieldname
                                  position  = <fs_import>-shlpselpos
                                  starfield = COND #( WHEN <fs_import>-fields-fieldname = lv_ret_field THEN abap_true ELSE abap_false )
                                  fielddesc = COND #( WHEN <fs_import>-fields-scrtext_l IS NOT INITIAL THEN <fs_import>-fields-scrtext_l
                                                      WHEN <fs_import>-fields-scrtext_m IS NOT INITIAL THEN <fs_import>-fields-scrtext_m
                                                      ELSE <fs_import>-fields-scrtext_s )
                                  fieldtype   = <fs_import>-fields-datatype
                                  fieldlength = <fs_import>-fields-outputlen ) ).

      WHEN co_value_help_step_export.
        et_fields = VALUE #( FOR <fs_export> IN lt_export_properties
                              ( valuehelptype = co_value_help_search_help
                                valuehelpname = lv_shlp_name
                                valuehelpstep = lv_shlp_step
                                fieldname = <fs_export>-fields-fieldname
                                position  = <fs_export>-shlplispos
                                starfield = COND #( WHEN <fs_export>-fields-fieldname = lv_ret_field THEN abap_true ELSE abap_false )
                                fielddesc = COND #( WHEN <fs_export>-fields-scrtext_l IS NOT INITIAL THEN <fs_export>-fields-scrtext_l
                                                    WHEN <fs_export>-fields-scrtext_m IS NOT INITIAL THEN <fs_export>-fields-scrtext_m
                                                    ELSE <fs_export>-fields-scrtext_s )
                                fieldtype   = <fs_export>-fields-datatype
                                fieldlength = <fs_export>-fields-outputlen ) ).

    ENDCASE.
  ENDMETHOD.


  METHOD get_search_help_properties.

    DATA: lo_shlp_facade     TYPE REF TO /iwbep/if_sbdsp_shlp_facade,
          ls_shlp_descr      TYPE shlp_descr,
          lt_shlp_properties TYPE tt_shlp_properties,
          ls_properties      LIKE LINE OF lt_shlp_properties.

    CREATE OBJECT lo_shlp_facade TYPE /iwbep/cl_sbdsp_shlp_facade.

    lo_shlp_facade->get_shlp_properties(
       EXPORTING
         iv_shlp_name = iv_shlp_name
       IMPORTING
         es_shlp      = ls_shlp_descr ).
    IF ls_shlp_descr-fielddescr IS INITIAL.
      " Search help not found
      RAISE EXCEPTION TYPE /iwbep/cx_sbdsp_shlp_provider
        EXPORTING
          textid    = /iwbep/cx_sbdsp_shlp_provider=>shlp_not_found
          shlp_name = iv_shlp_name.
    ENDIF.

    LOOP AT ls_shlp_descr-fielddescr INTO DATA(ls_fld_desc).
      ls_properties-fields = ls_fld_desc.
      READ TABLE ls_shlp_descr-fieldprop INTO DATA(ls_fieldprop)
        WITH KEY fieldname = ls_fld_desc-fieldname.
      IF sy-subrc = 0.
        ls_properties-shlpinput  = ls_fieldprop-shlpinput.
        ls_properties-shlpoutput = ls_fieldprop-shlpoutput.
        ls_properties-shlpselpos = ls_fieldprop-shlpselpos.  " position in the selection screen - input
        ls_properties-shlplispos = ls_fieldprop-shlplispos.  " position in the hit list - output
        ls_properties-shlpseldis = ls_fieldprop-shlpseldis.
        ls_properties-defaultval = ls_fieldprop-defaultval.
      ENDIF.

      APPEND ls_properties TO et_field_set.
    ENDLOOP.

    "Determine the return field
    LOOP AT ls_shlp_descr-fieldprop INTO ls_fieldprop.
      IF ls_fieldprop-shlpoutput = abap_true AND ev_star_field IS INITIAL.
        ev_star_field = ls_fieldprop-fieldname.
        EXIT.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_search_help_value.
    DATA: ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_getvaluehelpvalue.

    DATA: ls_entity TYPE /ltb/cl_mig_mc_odata_mpc=>ts_valuehelpvalue.

    DATA: lv_skip       TYPE int4,
          lv_top        TYPE int4,
          lt_order      TYPE /iwbep/t_mgw_sorting_order,
          ls_sort_order TYPE abap_sortorder,
          lt_sort_order TYPE abap_sortorder_tab,
          lt_shlp_value TYPE REF TO data.

    DATA: lo_sh_data       TYPE REF TO /iwbep/if_sb_shlp_data,
          lv_sort          TYPE abap_bool,
          lt_comp          TYPE abap_component_tab,
          ls_comp          TYPE abap_componentdescr,
          lt_result_fields TYPE tt_shlp_properties,
          lr_export_value  TYPE REF TO data.

    DATA: ls_selopt TYPE ddshselopt,
          lt_selopt TYPE ddshselops.

    FIELD-SYMBOLS: <ft_shlp_value> TYPE STANDARD TABLE.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    SPLIT ls_parameter-sortstring AT ',' INTO TABLE DATA(sorttab).

    LOOP AT sorttab ASSIGNING FIELD-SYMBOL(<fs_sort>).
      INSERT INITIAL LINE INTO TABLE lt_order ASSIGNING FIELD-SYMBOL(<fs_order>).
      SPLIT <fs_sort> AT space INTO <fs_order>-property <fs_order>-order.
    ENDLOOP.

    IF lt_order IS NOT INITIAL.
      lt_sort_order = VALUE #(
                               FOR <ls_order> IN lt_order
                               ( name       = <ls_order>-property
                                 descending = COND #( WHEN <ls_order>-order = co_sort_descending
                                 THEN abap_true
                                 ELSE abap_false )
                                )
                              ).
    ENDIF.

    lv_skip = ls_parameter-pageskip.
    lv_top = ls_parameter-pagetop.

    DATA(lv_shlp_name)         = ls_parameter-valuehelpname.
    DATA(lv_search_condition) = ls_parameter-searchcondition.
    DATA(lv_maxhit)           = ls_parameter-maxhit.

    get_search_help_properties(
      EXPORTING
        iv_shlp_name = CONV #( lv_shlp_name )
      IMPORTING
        et_field_set = DATA(lt_shlp_properties)
        ev_star_field = DATA(lv_star_field) ).

    SPLIT lv_search_condition AT '\' INTO TABLE DATA(lt_search_condition).
    LOOP AT lt_search_condition INTO DATA(lv_key_value).
      SPLIT lv_key_value AT '=' INTO DATA(lv_key) DATA(lv_value).

      READ TABLE lt_shlp_properties INTO DATA(ls_shlp_properties) WITH KEY fields-fieldname = lv_key.
      IF sy-subrc = 0.
        IF ls_shlp_properties-fields-lowercase = abap_true.
          "No change
        ELSE.
          lv_value = to_upper( lv_value ).
        ENDIF.

        "If search value equal max length, do exact search
        IF strlen( lv_value )  = ls_shlp_properties-fields-leng.
          CLEAR ls_selopt.
          ls_selopt-shlpname =  lv_shlp_name.
          ls_selopt-shlpfield = lv_key.
          ls_selopt-sign      = 'I'.
          ls_selopt-option    = 'EQ'.
          ls_selopt-low       = lv_value.
          APPEND ls_selopt TO lt_selopt.
        ELSE.
          CLEAR ls_selopt.
          ls_selopt-shlpname =  lv_shlp_name.
          ls_selopt-shlpfield = lv_key.
          ls_selopt-sign      = 'I'.
          ls_selopt-option    = 'CP'.


          DATA(lv_fuzzy_value) = |*{ lv_value }|.
          ls_selopt-low       = lv_fuzzy_value.
          APPEND ls_selopt TO lt_selopt.

          lv_fuzzy_value  = |{ lv_value }*|.
          ls_selopt-low       = lv_fuzzy_value.
          APPEND ls_selopt TO lt_selopt.

          lv_fuzzy_value  = |*{ lv_value }*|.
          ls_selopt-low       = lv_fuzzy_value.
          APPEND ls_selopt TO lt_selopt.

          ls_selopt-low       = lv_value.
          APPEND ls_selopt TO lt_selopt.
        ENDIF.
      ENDIF.

    ENDLOOP.

    lo_sh_data = /iwbep/cl_sb_shlp_data_factory=>get_sh_data_obj( ).
    lo_sh_data->/iwbep/if_sb_gendpc_shlp_data~get_search_help_values(
     EXPORTING
       iv_shlp_name      = CONV #( lv_shlp_name )
       iv_maxrows        = lv_maxhit
       iv_sort           = lv_sort
       iv_call_shlt_exit = abap_true
       it_selopt         = lt_selopt
     IMPORTING
       et_return_list    = DATA(lt_return_list)
       es_message        = DATA(ls_message) ).


    LOOP AT lt_shlp_properties INTO ls_shlp_properties.
      IF ls_shlp_properties-shlplispos <> 0
         OR ls_shlp_properties-shlpoutput = abap_true.
        APPEND ls_shlp_properties TO lt_result_fields.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_result_fields ASSIGNING FIELD-SYMBOL(<fs_export>).
      CLEAR ls_comp.
      ls_comp-name = <fs_export>-fields-fieldname.
      CASE <fs_export>-fields-inttype.
        WHEN cl_abap_elemdescr=>typekind_char.
          ls_comp-type = cl_abap_elemdescr=>get_c( CONV #( <fs_export>-fields-intlen ) ).
        WHEN cl_abap_elemdescr=>typekind_int.
          ls_comp-type = cl_abap_elemdescr=>get_i( ).
        WHEN cl_abap_elemdescr=>typekind_date.
          ls_comp-type = cl_abap_elemdescr=>get_d( ).
        WHEN cl_abap_elemdescr=>typekind_time.
          ls_comp-type = cl_abap_elemdescr=>get_t( ).
        WHEN cl_abap_elemdescr=>typekind_string.
          ls_comp-type = cl_abap_elemdescr=>get_string( ).
        WHEN cl_abap_elemdescr=>typekind_int1.
          ls_comp-type = cl_abap_elemdescr=>get_int1( ).
        WHEN cl_abap_elemdescr=>typekind_int2.
          ls_comp-type = cl_abap_elemdescr=>get_int2( ).
        WHEN  cl_abap_elemdescr=>typekind_int8.
          ls_comp-type = cl_abap_elemdescr=>get_int8( ).
        WHEN cl_abap_elemdescr=>typekind_num.
          ls_comp-type = cl_abap_elemdescr=>get_n( CONV #( <fs_export>-fields-leng ) ).
        WHEN cl_abap_elemdescr=>typekind_packed.
          ls_comp-type = cl_abap_elemdescr=>get_p( p_length   = CONV #( <fs_export>-fields-intlen )
                                                   p_decimals = CONV #( <fs_export>-fields-decimals ) ).
        WHEN cl_abap_elemdescr=>typekind_hex.
          ls_comp-type = cl_abap_elemdescr=>get_x( CONV #( <fs_export>-fields-leng ) ).
        WHEN cl_abap_elemdescr=>typekind_float.
          ls_comp-type = cl_abap_elemdescr=>get_f( ).
        WHEN cl_abap_elemdescr=>typekind_xstring.
          ls_comp-type = cl_abap_elemdescr=>get_xstring( ).
      ENDCASE.
      APPEND ls_comp TO lt_comp.
    ENDLOOP.
    DATA(lo_struct_descr) = cl_abap_structdescr=>create( p_components = lt_comp ).
    DATA(lo_table_descr) = cl_abap_tabledescr=>create( lo_struct_descr ).

    CREATE DATA lt_shlp_value TYPE HANDLE lo_table_descr.
    ASSIGN lt_shlp_value->* TO <ft_shlp_value>.

    IF ls_message-type <> 'E' AND lt_return_list IS NOT INITIAL.
      SORT lt_return_list BY record_number.

      LOOP AT lt_return_list ASSIGNING FIELD-SYMBOL(<fs_value>).
        AT NEW record_number.
          CREATE DATA lr_export_value TYPE HANDLE lo_struct_descr.
          ASSIGN lr_export_value->* TO FIELD-SYMBOL(<fs_export_value>).
        ENDAT.

        ASSIGN COMPONENT <fs_value>-field_name OF STRUCTURE <fs_export_value> TO FIELD-SYMBOL(<fv_field_value>).
        <fv_field_value> = <fs_value>-field_value.

        AT END OF record_number.
          APPEND <fs_export_value> TO <ft_shlp_value>.
        ENDAT.
      ENDLOOP.

      DATA(lv_count) = lines( <ft_shlp_value> ).

      IF lt_sort_order IS NOT INITIAL.
        SORT <ft_shlp_value> BY (lt_sort_order).
      ENDIF.

      IF lv_skip IS NOT INITIAL OR lv_top IS NOT INITIAL.
        DATA(lv_end) = lv_skip + lv_top + 1.
        DELETE <ft_shlp_value> FROM lv_end.
        IF lv_skip IS NOT INITIAL.
          DELETE <ft_shlp_value> TO lv_skip.
        ENDIF.
      ENDIF.

      DATA(writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
      CALL TRANSFORMATION id SOURCE data = <ft_shlp_value>
                                     RESULT XML writer.
      ls_entity-content = cl_abap_codepage=>convert_from( writer->get_output( ) ).
      ls_entity-count =  lv_count.

    ENDIF.

    copy_data_to_ref( EXPORTING is_data = ls_entity
                       CHANGING  cr_data = er_data ).

  ENDMETHOD.


  METHOD get_status_desc.
    CASE iv_status.
      WHEN 'E'.
        rv_description = get_text( EXPORTING iv_id = 'S02' ). "Error
      WHEN 'S'.
        rv_description = get_text( EXPORTING iv_id = 'S03' ). "Success
      WHEN 'W'.
        rv_description = get_text( EXPORTING iv_id = 'S04' ). "Warning
      WHEN 'I'.
        rv_description = get_text( EXPORTING iv_id = 'S05' ). "Information
      WHEN OTHERS.
        rv_description = get_text( EXPORTING iv_id = 'S01' ). "None
    ENDCASE.
  ENDMETHOD.


  METHOD get_stm_csv_file.
    DATA lv_project_uuid      TYPE /ltb/mc_proj_uuid.
    DATA lv_object_uuid       TYPE /ltb/mc_object_uuid.
    DATA lv_csv_bundle_uuid   TYPE /ltb/mc_fileproc_uuid.
    DATA lv_csv_file_uuid     TYPE string.
    DATA lv_filename          TYPE string.
    DATA lv_filename_encode   TYPE string.
    DATA ls_header            TYPE ihttpnvp.
    DATA lv_techid            TYPE dmc_stidt.
    DATA lt_csv_file_uuid     TYPE TABLE OF /ltb/mc_file_uuid.


    IF line_exists( it_key_tab[ name = co_migration_project_uuid ] ).
      lv_project_uuid = it_key_tab[ name = co_migration_project_uuid ]-value.
    ENDIF.

    IF line_exists( it_key_tab[ name = co_migration_object_uuid ] ).
      lv_object_uuid = it_key_tab[ name = co_migration_object_uuid ]-value.
    ENDIF.

    IF line_exists( it_key_tab[ name = co_csvbundleuuid ] ).
      lv_csv_bundle_uuid = it_key_tab[ name = co_csvbundleuuid ]-value.
    ENDIF.

    IF line_exists( it_key_tab[ name = co_csvfileuuid ] ).
      lv_csv_file_uuid = it_key_tab[ name = co_csvfileuuid ]-value.
    ENDIF.

    SPLIT lv_csv_file_uuid AT ',' INTO TABLE lt_csv_file_uuid.
    DESCRIBE TABLE lt_csv_file_uuid LINES DATA(lv_count).

    IF lv_count = 0.
      raise_bussiness_exception(
        EXPORTING
          iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
          it_message           = VALUE #( ( msgty = 'E'
                                            msgid = '/LTB/MC'
                                            msgno = '383' ) ) ).
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
        DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( lv_object_uuid ).
        DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( lv_csv_bundle_uuid ).
        DATA(lo_csv_bundle) = CAST /ltb/if_mc_csv_bundle( lo_file_proxy ).

        IF lv_count = 1.
          DATA(ls_csv_file) = lo_csv_bundle->get_file( CONV #( lv_csv_file_uuid ) ).

          rs_stream-mime_type = co_mime_type_csv.
          rs_stream-value = ls_csv_file-filedata.
          ls_header-name = 'Content-Disposition' ##NO_TEXT.

          lv_filename = ls_csv_file-filename.
          lv_filename_encode = convert_file_name( lv_filename ).

          ls_header-value = get_attachement_header_value(
            iv_filename        = lv_filename
            iv_filename_encode = lv_filename_encode
          ).

          set_header( ls_header ).
        ELSE.
          DATA(lo_zip_content) = NEW cl_abap_zip( ).
          lo_zip_content->support_unicode_names = abap_true.

          DATA(ls_fileproc) = /ltb/cl_mc_fileproc_access=>get_by_fileproc( lv_csv_bundle_uuid  ) .
          LOOP AT lt_csv_file_uuid INTO DATA(ls_csv_file_uuid).
            ls_csv_file = lo_csv_bundle->get_file( ls_csv_file_uuid ).
            IF line_exists( lo_zip_content->files[ name = ls_csv_file-filename ] ).
              DATA(offset) = strlen( ls_csv_file-filename ) - 4.
              DATA(lv_csv_filename) = ls_csv_file-filename(offset) && ls_csv_file-created_at && /ltb/if_mc_constants=>gc_filename_ext-csv.
            ELSE.
              lv_csv_filename = ls_csv_file-filename.
            ENDIF.

            lo_zip_content->add( name    = lv_csv_filename
                                 content = ls_csv_file-filedata ).
          ENDLOOP.

          rs_stream-mime_type = co_mime_type_zip.
          rs_stream-value = lo_zip_content->save( ).
          ls_header-name = 'Content-Disposition' ##NO_TEXT.

          lv_filename = ls_fileproc-file_name && /ltb/if_mc_constants=>gc_filename_ext-zip.
          lv_filename_encode = convert_file_name( lv_filename ).

          ls_header-value = get_attachement_header_value(
            iv_filename        = lv_filename
            iv_filename_encode = lv_filename_encode
          ).

          set_header( ls_header ).
        ENDIF.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_mc_static_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_mc_static_exception->get_text( )
            it_message           = lo_mc_static_exception->get_messages( )
        ).

    ENDTRY.

  ENDMETHOD.


  METHOD get_stm_file_download.

    DATA lt_fileprocuuid TYPE TABLE OF /ltb/mc_fileproc_uuid.
    DATA ls_header TYPE ihttpnvp.
    DATA lv_timestamp_string TYPE string.
    DATA lv_filename TYPE string.
    DATA lv_filename_encode TYPE string.
    DATA lv_filedata TYPE xstring.
    DATA lv_zipfilename TYPE string.


    FIELD-SYMBOLS <ls_key> TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab ASSIGNING <ls_key> WITH KEY name = co_file_procuuid.
    IF sy-subrc = 0.
      DATA(lv_fileprocuuid) = <ls_key>-value.
    ENDIF.

    SPLIT lv_fileprocuuid AT ',' INTO TABLE lt_fileprocuuid.

    DESCRIBE TABLE lt_fileprocuuid LINES DATA(lv_count).
    "get the object name
    READ TABLE lt_fileprocuuid INTO DATA(lv_fileproc_uuid) INDEX 1.
    DATA(ls_fileproc) = /ltb/cl_mc_fileproc_access=>get_by_fileproc( lv_fileproc_uuid  ) .

    "Get object name an d description
    SELECT SINGLE coalesce( e~descr, t~descr, c~cobj_alias )
    FROM dmc_cobj AS c
      LEFT JOIN dmc_cobjt AS e ON c~guid = e~guid AND e~langu = @sy-langu "#EC CI_SELECT_VERT_OK
      LEFT JOIN dmc_cobjt AS t ON c~guid = t~guid AND t~langu = 'E' "#EC CI_SELECT_VERT_OK
    WHERE c~guid = @ls_fileproc-migobj_uuid INTO @DATA(lv_obj_name).

    DATA(go_zip_content) = NEW cl_abap_zip( ).
    go_zip_content->support_unicode_names = abap_true.

    DATA(lo_csv_access) = CAST /ltb/if_mc_csv_file_access( NEW /ltb/cl_mc_csv_file_access( ) ).

    IF lv_count = 1.
      CASE ls_fileproc-fileproc_cat.
        WHEN /ltb/if_mc_constants=>gc_fileproc-category-csv.
          DATA(lt_csv_files) = lo_csv_access->get_by_bundle( ls_fileproc-fileproc_uuid ).

          LOOP AT lt_csv_files INTO DATA(ls_csv_file).
            IF line_exists( go_zip_content->files[ name = ls_csv_file-filename ] ).
              DATA(offset) = strlen( ls_csv_file-filename ) - 4.
              DATA(lv_csv_filename) = ls_csv_file-filename(offset) && ls_csv_file-created_at && /ltb/if_mc_constants=>gc_filename_ext-csv.
            ELSE.
              lv_csv_filename = ls_csv_file-filename.
            ENDIF.

            go_zip_content->add(
              EXPORTING
                name    = lv_csv_filename
                content = lo_csv_access->get_data( ls_csv_file-file_uuid )
            ).
          ENDLOOP.

          rs_stream-mime_type = co_mime_type_zip.
          rs_stream-value = go_zip_content->save( ).
          ls_header-name = 'Content-Disposition' ##NO_TEXT.

          lv_filename = ls_fileproc-file_name && /ltb/if_mc_constants=>gc_filename_ext-zip.
          lv_filename_encode = convert_file_name( lv_filename ).

          ls_header-value = get_attachement_header_value(
            iv_filename        = lv_filename
            iv_filename_encode = lv_filename_encode
          ).

          set_header( ls_header ).

        WHEN OTHERS.
          "only one file, download the xml file
          rs_stream-mime_type = co_mime_type_xml.
          rs_stream-value = ls_fileproc-filedata.
          ls_header-name = 'Content-Disposition' ##NO_TEXT.

          lv_filename = ls_fileproc-file_name.
          lv_filename_encode = convert_file_name( lv_filename ).

          ls_header-value = get_attachement_header_value(
            iv_filename        = lv_filename
            iv_filename_encode = lv_filename_encode
          ).

          lv_filename_encode = convert_file_name( lv_filename ).

          ls_header-value = get_attachement_header_value(
            iv_filename        = lv_filename
            iv_filename_encode = lv_filename_encode
          ).

          set_header( ls_header ).
          set_header( ls_header ).
      ENDCASE.

    ELSEIF lv_count > 1.

      LOOP AT lt_fileprocuuid INTO DATA(ls_fileprocuuid).
        ls_fileproc = /ltb/cl_mc_fileproc_access=>get_by_fileproc( ls_fileprocuuid  ) .

        CASE ls_fileproc-fileproc_cat.
          WHEN /ltb/if_mc_constants=>gc_fileproc-category-correction OR /ltb/if_mc_constants=>gc_fileproc-category-corr_csv.
            lv_zipfilename = |{ /ltb/if_mc_constants=>gc_filename_prefix-corrfile } { lv_obj_name }{ /ltb/if_mc_constants=>gc_filename_ext-zip }|.
            IF line_exists( go_zip_content->files[ name = ls_fileproc-file_name ] ).
              REPLACE ALL OCCURRENCES OF '.zip' IN ls_fileproc-file_name WITH space.
              ls_fileproc-file_name = ls_fileproc-file_name && ls_fileproc-created_ts && `.zip`.
            ENDIF.

            lv_filename = ls_fileproc-file_name.
            lv_filedata = ls_fileproc-filedata.
          WHEN /ltb/if_mc_constants=>gc_fileproc-category-csv.
            lv_zipfilename = |{ /ltb/if_mc_constants=>gc_filename_prefix-srcdata-single } { lv_obj_name }{ /ltb/if_mc_constants=>gc_filename_ext-zip }|.
            lt_csv_files = lo_csv_access->get_by_bundle( ls_fileproc-fileproc_uuid ).
            DATA(lo_zip_content) = NEW cl_abap_zip( ).
            lo_zip_content->support_unicode_names = abap_true.

            LOOP AT lt_csv_files INTO ls_csv_file.
              IF line_exists( lo_zip_content->files[ name = ls_csv_file-filename ] ).
                offset = strlen( ls_csv_file-filename ) - 4.
                lv_csv_filename = ls_csv_file-filename(offset) && ls_csv_file-created_at && /ltb/if_mc_constants=>gc_filename_ext-csv.
              ELSE.
                lv_csv_filename = ls_csv_file-filename.
              ENDIF.

              lo_zip_content->add(
                EXPORTING
                  name    = lv_csv_filename
                  content = lo_csv_access->get_data( ls_csv_file-file_uuid )
              ).
            ENDLOOP.

            lv_filename = ls_fileproc-file_name && /ltb/if_mc_constants=>gc_filename_ext-zip.
            lv_filedata = lo_zip_content->save( ).
          WHEN OTHERS.
            lv_zipfilename = |{ /ltb/if_mc_constants=>gc_filename_prefix-srcdata-single } { lv_obj_name }{ /ltb/if_mc_constants=>gc_filename_ext-zip }|.
            lv_filename = ls_fileproc-file_name.
            lv_filedata = ls_fileproc-filedata.
        ENDCASE.

        go_zip_content->add( name    =  lv_filename
                             content =  lv_filedata ).
      ENDLOOP.

      rs_stream-mime_type = co_mime_type_zip.
      rs_stream-value = go_zip_content->save( ).
      ls_header-name = 'Content-Disposition' ##NO_TEXT.

      "Source data for <object name>.zip
      lv_filename_encode = convert_file_name( lv_zipfilename ).

      ls_header-value = get_attachement_header_value(
        iv_filename        = lv_zipfilename
        iv_filename_encode = lv_filename_encode
      ).

      set_header( ls_header ).
    ELSE.
      "should never happen
      raise_bussiness_exception(
        EXPORTING
          iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error ).
    ENDIF.
  ENDMETHOD.


  METHOD GET_STM_MO_INSTANCE.
    DATA lv_project_uuid      TYPE /ltb/mc_proj_uuid.
    DATA lv_object_uuid       TYPE /ltb/mc_object_uuid.
    DATA lv_act_uuid          TYPE /ltb/mc_act_uuid.
    DATA lv_filename          TYPE string.
    DATA lv_filename_encode   TYPE string.
    DATA ls_header            TYPE ihttpnvp.
    DATA lv_display_option    TYPE string.
    DATA lv_prefix_name       TYPE string.


    READ TABLE it_key_tab WITH KEY name = co_migration_project_uuid INTO DATA(ls_key).
    IF sy-subrc = 0.
      lv_project_uuid = ls_key-value.
    ENDIF.

    READ TABLE it_key_tab WITH KEY name = co_migration_object_uuid INTO ls_key.
    IF sy-subrc = 0.
      lv_object_uuid = ls_key-value.
    ENDIF.

    READ TABLE it_key_tab WITH KEY name = co_activity_uuid INTO ls_key.
    IF sy-subrc = 0.
      lv_act_uuid = ls_key-value.
    ENDIF.

    READ TABLE it_key_tab WITH KEY name = co_mig_inst_display_option INTO ls_key.
    IF sy-subrc = 0.
      lv_display_option = ls_key-value.
    ENDIF.

    IF lv_display_option = /ltb/if_mc_constants=>gc_instance_display_option-standard.
      lv_prefix_name = /ltb/if_mc_constants=>gc_filename_prefix-stdfile.
    ELSE.
      lv_prefix_name = /ltb/if_mc_constants=>gc_filename_prefix-resultfile.
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
        DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( lv_object_uuid ).
        DATA(lo_object_ctx)    = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        lo_object_ctx->set_act_uuid( iv_act_uuid = lv_act_uuid ).
        rs_stream-value = lo_object_proxy->export_result_file( lo_object_ctx ).
        ls_header-name = 'Content-Disposition' ##NO_TEXT.

        DATA(l_obj_name) = lo_object_proxy->get_migobj_name( ).

        DATA(l_iso_ts) = /ltb/cl_bas_utils=>get_iso_ts_for_filename( ).

        "Messages for <object name> (<timestamp>).zip
        lv_filename = |{ lv_prefix_name } { l_obj_name } ({ l_iso_ts }){ /ltb/if_mc_constants=>gc_filename_ext-zip }|.

        lv_filename_encode = convert_file_name( lv_filename ).

        ls_header-value = get_attachement_header_value(
          iv_filename        = lv_filename
          iv_filename_encode = lv_filename_encode
        ).

        rs_stream-mime_type = co_mime_type_zip."zip

        set_header( is_header = ls_header ).
      CATCH  /ltb/cx_mc_static_check_msg INTO DATA(lo_mc_static_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_mc_static_exception->get_text( )
            it_message           = lo_mc_static_exception->get_messages( )
        ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_stm_mo_message.
    DATA lv_project_uuid      TYPE /ltb/mc_proj_uuid.
    DATA lv_object_uuid       TYPE /ltb/mc_object_uuid.
    DATA lv_act_uuid          TYPE /ltb/mc_act_uuid.
    DATA lv_filename         TYPE string.
    DATA lv_filename_encode  TYPE string.
    DATA ls_header            TYPE ihttpnvp.


    READ TABLE it_key_tab WITH KEY name = co_migration_project_uuid INTO DATA(ls_key).
    IF sy-subrc = 0.
      lv_project_uuid = ls_key-value.
    ENDIF.

    READ TABLE it_key_tab WITH KEY name = co_migration_object_uuid INTO ls_key.
    IF sy-subrc = 0.
      lv_object_uuid = ls_key-value.
    ENDIF.

    READ TABLE it_key_tab WITH KEY name = co_activity_uuid INTO ls_key.
    IF sy-subrc = 0.
      lv_act_uuid = ls_key-value.
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
        DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( lv_object_uuid ).
        DATA(lo_object_ctx)    = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        lo_object_ctx->set_act_uuid( iv_act_uuid = lv_act_uuid ).
        rs_stream-value = lo_object_proxy->export_message_file( lo_object_ctx ).
        ls_header-name = 'Content-Disposition' ##NO_TEXT.

        DATA(l_obj_name) = lo_object_proxy->get_migobj_name( ).

        DATA(l_iso_ts) = /ltb/cl_bas_utils=>get_iso_ts_for_filename( ).

        "Messages for <object name> (<timestamp>).zip
        lv_filename = |{ /ltb/if_mc_constants=>gc_filename_prefix-messages } { l_obj_name } ({ l_iso_ts }){ /ltb/if_mc_constants=>gc_filename_ext-zip }|.

        lv_filename_encode = convert_file_name( lv_filename ).

        ls_header-value = get_attachement_header_value(
          iv_filename        = lv_filename
          iv_filename_encode = lv_filename_encode
        ).

        rs_stream-mime_type = co_mime_type_zip."zip

        set_header( is_header = ls_header ).
      CATCH  /ltb/cx_mc_static_check_msg INTO DATA(lo_mc_static_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_mc_static_exception->get_text( )
            it_message           = lo_mc_static_exception->get_messages( )
        ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_stm_staging_tab_fld_csv.

    DATA lv_act_uuid TYPE /ltb/mc_act_uuid.
    DATA ls_header TYPE ihttpnvp.
    DATA lv_timestamp_string TYPE string.
    DATA lv_project_uuid TYPE /ltb/mc_proj_uuid.
    DATA lv_object_uuid TYPE /ltb/mc_object_uuid.
    DATA lo_obj_proxy_mwb_stag TYPE REF TO /ltb/cl_mc_obj_proxy_mwb_stag.
    DATA lo_project_proxy TYPE REF TO /ltb/if_mc_proj_proxy.
    DATA lv_filename TYPE string.
    DATA lv_filename_encode TYPE string.

    FIELD-SYMBOLS <ls_key> TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab ASSIGNING <ls_key> WITH KEY name = co_migration_project_uuid.
    IF sy-subrc = 0.
      lv_project_uuid = <ls_key>-value.
    ENDIF.

    READ TABLE it_key_tab ASSIGNING <ls_key> WITH KEY name = co_migration_object_uuid.
    IF sy-subrc = 0.
      lv_object_uuid = <ls_key>-value.
    ENDIF.

    READ TABLE it_key_tab ASSIGNING <ls_key> WITH KEY name = co_migration_activity_uuid.
    IF sy-subrc = 0.
      lv_act_uuid = <ls_key>-value.
    ENDIF.

    TRY.
        lo_project_proxy = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
        lo_obj_proxy_mwb_stag ?= lo_project_proxy->get_migobj_proxy_by_uuid( lv_object_uuid ).
        DATA(ls_obj_detail) = lo_obj_proxy_mwb_stag->/ltb/if_mc_obj_proxy~get_details( NEW /ltb/cl_mc_cntxt_obj_detail( ) ).
        rs_stream-value = lo_obj_proxy_mwb_stag->download_staging_table_field( ).
        rs_stream-mime_type = co_mime_type_csv.

        "Set header
        ls_header-name = 'Content-Disposition' ##NO_TEXT.

        DATA(l_obj_name) = ls_obj_detail-migobj_descr.

        "Metadata for <object name>.csv
        lv_filename = |{ /ltb/if_mc_constants=>gc_filename_prefix-metadata } { l_obj_name }{ /ltb/if_mc_constants=>gc_filename_ext-csv }|.

        lv_filename_encode = convert_file_name( lv_filename ).

        ls_header-value = get_attachement_header_value(
          iv_filename        = lv_filename
          iv_filename_encode = lv_filename_encode
        ).

        set_header( is_header = ls_header ).
      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_mc_proxy_error).
        raise_bussiness_exception(
          iv_textid = /iwbep/cx_mgw_busi_exception=>business_error
          it_message = lx_mc_proxy_error->get_messages( )
        ).
      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_mc_cntxt_error).
        raise_bussiness_exception(
          iv_textid = /iwbep/cx_mgw_busi_exception=>business_error
          it_message = lx_mc_cntxt_error->get_messages( )
        ).
    ENDTRY.

  ENDMETHOD.


  METHOD get_stm_task_file.
    DATA lv_project_uuid TYPE /ltb/mc_proj_uuid.
    DATA lv_file_uuid    TYPE /ltb/mc_fileproc_uuid.
    DATA ls_header TYPE ihttpnvp.
    DATA lv_file_name TYPE String.

    READ TABLE it_key_tab WITH KEY name = co_migration_project_uuid INTO DATA(ls_key).
    IF sy-subrc = 0.
      lv_project_uuid = ls_key-value.
    ENDIF.

    READ TABLE it_key_tab WITH KEY name = co_task_file_uuid INTO ls_key.
    IF sy-subrc = 0.
      lv_file_uuid = ls_key-value.
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
        DATA(ls_task_file) = lo_project_proxy->download_task_file( lv_file_uuid ).

        rs_stream-mime_type = co_mime_type_xml.
        rs_stream-value = ls_task_file-filedata.
        ls_header-name = 'Content-Disposition' ##NO_TEXT.

        "Handle cracked file name in ZH language
        lv_file_name = ls_task_file-file_name.
        DATA(lv_file_name_encode) = convert_file_name( lv_file_name ).

        ls_header-value = get_attachement_header_value(
          iv_filename        = lv_file_name
          iv_filename_encode = lv_file_name_encode
        ).

        set_header( ls_header ).

      CATCH  /ltb/cx_mc_static_check_msg INTO DATA(lo_mc_static_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_mc_static_exception->get_text( )
            it_message           = lo_mc_static_exception->get_messages( )
        ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_stm_task_template.
    DATA lv_project_uuid     TYPE /ltb/mc_proj_uuid.
    DATA lt_task_uuid  TYPE /ltb/mc_t_task_uuid.
    DATA lv_task_uuids     TYPE string.
    DATA ls_header       TYPE ihttpnvp.
    DATA lv_filename TYPE string.
    DATA lv_filename_encode TYPE string.

    READ TABLE it_key_tab WITH KEY name = co_migration_project_uuid INTO DATA(ls_key).
    IF sy-subrc = 0.
      "Get project UUID
      lv_project_uuid = ls_key-value.
    ENDIF.


    READ TABLE it_key_tab WITH KEY name = co_migration_task_list INTO ls_key.
    IF sy-subrc = 0.
      lv_task_uuids = ls_key-value.
      IF lv_task_uuids IS NOT INITIAL.
        SPLIT lv_task_uuids AT ',' INTO TABLE lt_task_uuid.
      ENDIF.
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
        DATA(lo_project_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
        DATA(ls_project_detail) = lo_project_proxy->get_proj_details( io_cntxt = lo_project_ctx ).

        DATA(lo_task_list_ctx) = NEW /ltb/cl_mc_cntxt_task_list( ).
        lo_task_list_ctx->set_task_uuid( lt_task_uuid ).

        IF lines( lt_task_uuid ) > 1.
          "zip file for multiple templates download
          rs_stream-value = lo_project_proxy->generate_taskval_tmpl( io_cntxt = lo_task_list_ctx ).
          rs_stream-mime_type = co_mime_type_compressed_zip.

          DATA(l_proj_name) = ls_project_detail-proj_descr.

          "Mapping Templates - <project name>.zip
          lv_filename = |{ /ltb/if_mc_constants=>gc_filename_prefix-tasktmpl } - { l_proj_name }{ /ltb/if_mc_constants=>gc_filename_ext-zip }|.

          lv_filename_encode = convert_file_name( lv_filename ).

          ls_header-value = get_attachement_header_value(
            iv_filename        = lv_filename
            iv_filename_encode = lv_filename_encode
          ).

        ELSE.
          "plain XML file for single template download
          rs_stream-mime_type = co_mime_type_csv.

          "retrieve compressed data and then unzip it, only one file in the zip folder
          DATA(lv_file_data) = lo_project_proxy->generate_taskval_tmpl( io_cntxt = lo_task_list_ctx ).
          /ltb/cl_mc_fileproc_access=>unzip_one_file( EXPORTING  iv_zip_data   = lv_file_data
                                                      IMPORTING  ev_filename   = DATA(lv_file_name)
                                                                 ev_unzip_data = DATA(lv_unzip_data) ).

          "Handle cracked file name in ZH language
          DATA(lv_file_name_encode) = convert_file_name( lv_file_name ).

          ls_header-value = get_attachement_header_value(
            iv_filename        = lv_file_name
            iv_filename_encode = lv_file_name_encode
          ).

          rs_stream-value = lv_unzip_data.
        ENDIF.

        ls_header-name = 'Content-Disposition' ##NO_TEXT.
        set_header( is_header = ls_header ).

      CATCH  /ltb/cx_mc_static_check_msg INTO DATA(lo_mc_static_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_mc_static_exception->get_text( )
        ).
    ENDTRY.


  ENDMETHOD.


  METHOD get_stm_task_value.
    DATA:
      lv_project_uuid    TYPE /ltb/mc_proj_uuid,
      lv_act_uuid        TYPE /ltb/mc_act_uuid,
      lv_task_uuids      TYPE string,
      lt_task_uuid       TYPE /ltb/mc_t_task_uuid,
      lv_download_option TYPE string,
      ls_header          TYPE ihttpnvp,
      ls_err_msg         TYPE bal_s_msg,
      lt_err_msgs        TYPE cnv_mbt_t_bal_s_msg,
      lv_filename        TYPE string,
      lv_filename_encode TYPE string.


    READ TABLE it_key_tab WITH KEY name = co_migration_project_uuid INTO DATA(ls_key).
    IF sy-subrc = 0.
      lv_project_uuid = ls_key-value.
    ENDIF.

    READ TABLE it_key_tab WITH KEY name = co_activity_uuid INTO ls_key.
    IF sy-subrc = 0.
      lv_act_uuid = ls_key-value.
    ENDIF.

    READ TABLE it_key_tab WITH KEY name = co_migration_task_uuid INTO ls_key.
    IF sy-subrc = 0.
      lv_task_uuids = ls_key-value.
      IF lv_task_uuids IS NOT INITIAL.
        SPLIT lv_task_uuids AT ',' INTO TABLE lt_task_uuid.
      ENDIF.
    ENDIF.

    READ TABLE it_key_tab WITH KEY name = co_download_option INTO ls_key.
    IF sy-subrc = 0.
      lv_download_option = ls_key-value.
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
        DATA(lo_project_ctx)   = NEW /ltb/cl_mc_cntxt_proj_detail( ).
        DATA(ls_project_detail) = lo_project_proxy->get_proj_details( io_cntxt = lo_project_ctx ).

        IF lv_act_uuid IS INITIAL.
          DATA(lo_task_list_ctx) = NEW /ltb/cl_mc_cntxt_task_list( ).
          lo_task_list_ctx->set_task_uuid( lt_task_uuid ).

          "For PE set download option
          lo_task_list_ctx->set_download_option( lv_download_option ).
          lv_act_uuid = lo_project_proxy->schedule_taskfile_generation( lo_task_list_ctx ).

          IF 1 = 0. MESSAGE i124(/ltb/mc). ENDIF.
          ls_err_msg-msgid = '/LTB/MC'.
          ls_err_msg-msgno = '124'.
          ls_err_msg-msgty = 'I'.
          ls_err_msg-msgv1 = 'background downloading'.

          APPEND ls_err_msg TO lt_err_msgs.
          RAISE EXCEPTION TYPE /ltb/cx_mc_proxy_error
            EXPORTING
              textid   = /ltb/cx_mc_proxy_error=>template_background_download
              messages = lt_err_msgs
              msgv1    = ls_err_msg-msgv1.
        ELSE.
          lo_project_ctx->set_act_uuid( iv_act_uuid = lv_act_uuid ).
          rs_stream-value = lo_project_proxy->export_taskval_file( lo_project_ctx ).
          rs_stream-mime_type = co_mime_type_compressed_zip.

          ls_header-name = 'Content-Disposition' ##NO_TEXT.

          DATA(l_proj_name) = ls_project_detail-proj_descr.

          "Mapping Values - <project name>.zip
          lv_filename = |{ /ltb/if_mc_constants=>gc_filename_prefix-taskvals } - { l_proj_name }{ /ltb/if_mc_constants=>gc_filename_ext-zip }|.

          lv_filename_encode = convert_file_name( lv_filename ).

          ls_header-value = get_attachement_header_value(
            iv_filename        = lv_filename
            iv_filename_encode = lv_filename_encode
          ).

          set_header( is_header = ls_header ).
        ENDIF.
      CATCH  /ltb/cx_mc_static_check_msg INTO DATA(lo_mc_static_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_mc_static_exception->get_text( )
            it_message           = lo_mc_static_exception->get_messages( )
        ).
    ENDTRY.


  ENDMETHOD.


  METHOD get_task_list.
    DATA:
      lt_object_id   TYPE /ltb/mc_t_object_uuid,
      lt_sort_orders TYPE abap_sortorder_tab,
      ls_sort_orders TYPE abap_sortorder,
      lv_proj_task_status_filter_on TYPE abap_bool.
    CONSTANTS:
      lco_task_name  TYPE string VALUE 'TASKNAME'.

    CLEAR ev_confirmed_task_count.
    CLEAR ev_open_task_count.
    CLEAR ev_info_loss_task_count.
    TRY.
        DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( iv_project_id ).

        IF it_object_id IS INITIAL.
          DATA(lo_object_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
          lo_object_context->set_ignore_detail( iv_ignore_detail = abap_true ).
          DATA(lt_object) = lo_project->get_migobjs( io_cntxt = lo_object_context  ).
          lt_object_id = VALUE #( FOR ls_object IN lt_object ( ls_object-migobj_uuid ) ).
        ELSE.
          APPEND LINES OF it_object_id TO lt_object_id.
        ENDIF.

        LOOP AT lt_object_id INTO DATA(lv_object_id) ##INTO_OK.
          get_mo_task_list(
            EXPORTING
              io_proj_proxy = lo_project
              iv_object_id  = lv_object_id
              io_tech_request_context = io_tech_request_context
            IMPORTING
              ev_confirmed_task_count = DATA(lv_confirmed_task_count)
              ev_open_task_count      = DATA(lv_open_task_count)
              ev_info_loss_task_count = DATA(lv_info_loss_task_count)
            CHANGING
              ct_result     = ct_result
          ).

          ev_confirmed_task_count = ev_confirmed_task_count + lv_confirmed_task_count.
          ev_open_task_count      = ev_open_task_count + lv_open_task_count.
          ev_info_loss_task_count = ev_info_loss_task_count + lv_info_loss_task_count.
        ENDLOOP.

*        IF it_object_id IS INITIAL.
*          "get the task directly from project, instead of from each object
*          DATA ls_odata_task  TYPE /ltb/cl_mig_mc_odata_mpc=>ts_task.
*          DATA(lo_task_context) = NEW /ltb/cl_mc_cntxt_task_detail( ).
*          DATA(lt_filter_select_option) = io_tech_request_context->get_filter( )->get_filter_select_options( ).
*
*          set_context( iv_entity_set_name = io_tech_request_context->get_entity_set_name( )
*            iv_search_string = io_tech_request_context->get_search_string( )
*            it_filter_select_options = lt_filter_select_option
*            io_context = lo_task_context
*            ).
*          LOOP AT lt_filter_select_option INTO DATA(ls_filter_selection_option).
*            CASE ls_filter_selection_option-property.
*              WHEN 'TASKSTATUSUUID'.
*                lv_proj_task_status_filter_on = abap_true.
*                EXIT.
*            ENDCASE.
*          ENDLOOP.
*          lo_project->get_tasks(
*                        EXPORTING
*                          io_cntxt = lo_task_context
*                        IMPORTING
*                          et_data  = DATA(lt_tasks) ).
*          SORT lt_tasks BY task_uuid.
*          DELETE ADJACENT DUPLICATES FROM lt_tasks COMpARING task_uuid.
*          DATA(lo_taskitem_ctx) = NEW /ltb/cl_mc_cntxt_task_detail( ).
*          LOOP AT lt_tasks INTO DATA(ls_task)
*            WHERE task_status = /ltb/if_mc_constants=>gc_task_status-confirmed OR
*                  task_status = /ltb/if_mc_constants=>gc_task_status-info_loss OR
*                  task_status = /ltb/if_mc_constants=>gc_task_status-open ##INTO_OK.
*            IF lv_proj_task_status_filter_on = abap_true.
*              CHECK ls_task-task_status IN ls_filter_selection_option-select_options.
*            ENDIF.
*            DATA(lo_object_proxy) = lo_project->get_migobj_proxy_by_uuid( ls_task-object_uuid ).
*            DATA(lo_task) = lo_object_proxy->get_task_proxy_by_uuid( iv_task_uuid = ls_task-task_uuid ).
*            lo_task->get_values(
*              EXPORTING
*                io_cntxt = lo_taskitem_ctx
*              IMPORTING
*                ev_count  = DATA(lv_value_count) ).
*            ls_odata_task = VALUE #( migrationprojectuuid = iv_project_id
*                                   migrationobjectuuid  = ls_task-object_uuid
*                                   migrationtaskuuid    = ls_task-task_uuid
*                                   taskname             = ls_task-task_descr
*                                   tasktechname         = ls_task-task_name
*                                   tasktempid           = ls_task-task_tmpl_uuid
*                                   taskstatusuuid       = ls_task-task_status
*                                   taskstatus           = get_task_status_text( iv_status = ls_task-task_status )
*                                   tasktype             = get_task_type_text( ls_task-task_type )
*                                   taskitemcount        = lv_value_count
*                                   hascheck             = ls_task-hascheck
*                                 ).
*            IF ls_odata_task-taskstatusuuid = /ltb/if_mc_constants=>gc_task_status-confirmed.
*              ev_confirmed_task_count = ev_confirmed_task_count + 1.
*            ELSEIF ls_odata_task-taskstatusuuid = /ltb/if_mc_constants=>gc_task_status-open.
*              ev_open_task_count = ev_open_task_count + 1.
*            ELSEIF ls_odata_task-taskstatusuuid = /ltb/if_mc_constants=>gc_task_status-info_loss.
*              ev_info_loss_task_count  = ev_info_loss_task_count + 1.
*            ENDIF.
*
*            APPEND ls_odata_task TO ct_result.
*            CLEAR lv_value_count.
*          ENDLOOP.
*        ELSE.
*          APPEND LINES OF it_object_id TO lt_object_id.
*          LOOP AT lt_object_id INTO DATA(lv_object_id) ##INTO_OK.
*            get_mo_task_list(
*              EXPORTING
*                io_proj_proxy = lo_project
*                iv_object_id  = lv_object_id
*                io_tech_request_context = io_tech_request_context
*              IMPORTING
*                ev_confirmed_task_count = DATA(lv_confirmed_task_count)
*                ev_open_task_count      = DATA(lv_open_task_count)
*                ev_info_loss_task_count = DATA(lv_info_loss_task_count)
*              CHANGING
*                ct_result     = ct_result
*            ).
*
*            ev_confirmed_task_count = ev_confirmed_task_count + lv_confirmed_task_count.
*            ev_open_task_count      = ev_open_task_count + lv_open_task_count.
*            ev_info_loss_task_count = ev_info_loss_task_count + lv_info_loss_task_count.
*          ENDLOOP.
*        ENDIF.

        IF io_tech_request_context IS SUPPLIED.
          DATA(lt_sort_options) = io_tech_request_context->get_orderby( ).
          lt_sort_orders = VALUE #( FOR <ls_order> IN lt_sort_options
                                    ( name = <ls_order>-property
                                      descending = COND #( WHEN <ls_order>-order = co_sort_descending
                                                           THEN abap_true
                                                           ELSE abap_false
                                                         )
                                    )
                                  ).
          "Sort by name as default
          IF lt_sort_orders IS INITIAL.
            ls_sort_orders-name = lco_task_name.
            APPEND ls_sort_orders TO lt_sort_orders.
          ENDIF.
          SORT ct_result BY (lt_sort_orders).

          DATA(lv_offset) = io_tech_request_context->get_skip( ).
          DATA(lv_limit) = io_tech_request_context->get_top( ).

          IF lv_offset > 0 AND lv_offset < lines( ct_result ).
            DELETE ct_result TO lv_offset.
          ENDIF.
          IF lv_limit > 0 AND lv_limit < lines( ct_result ).
            DELETE ct_result FROM lv_limit + 1.
          ENDIF.
        ENDIF.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        DATA(lt_mc_messages) = lo_exception->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_task_status_text.
    CASE iv_status.
      WHEN /ltb/if_mc_constants=>gc_task_status-confirmed.
        rv_text = get_text( EXPORTING iv_id = 'T01' ). "Confirmed
      WHEN /ltb/if_mc_constants=>gc_task_status-info_loss.
        rv_text = get_text( EXPORTING iv_id = 'T07' ). "Error
      WHEN OTHERS.
        rv_text = get_text( EXPORTING iv_id = 'T02' ). "Open
    ENDCASE.
  ENDMETHOD.


  METHOD get_task_type_text.
    CASE iv_type.
      WHEN /ltb/if_mc_constants=>gc_task_type-value_mapping.
        rv_text = get_text( EXPORTING iv_id = 'T03' ). "Value Mapping
      WHEN /ltb/if_mc_constants=>gc_task_type-fixed_value.
        rv_text = get_text( EXPORTING iv_id = 'T04' ). "Fixed Value
      WHEN /ltb/if_mc_constants=>gc_task_type-control_param.
        rv_text = get_text( EXPORTING iv_id = 'T05' ). "Control Parameter
      WHEN OTHERS.
        rv_text = get_text( EXPORTING iv_id = 'T06' ). "Not Defined type
    ENDCASE.
  ENDMETHOD.


  METHOD get_text.
    CONSTANTS:
      lco_lang_parameter         TYPE string VALUE 'accept-language'.

    IF mv_language IS INITIAL.
      TRY.
          DATA(lo_dp_facade) = /iwbep/if_mgw_conv_srv_runtime~get_dp_facade( ).
          DATA(lt_header_pair) = lo_dp_facade->get_request_header( ).
          IF line_exists( lt_header_pair[ name = lco_lang_parameter ] ).
            mv_language = lt_header_pair[ name = lco_lang_parameter ]-value.
            TRANSLATE mv_language TO UPPER CASE.
          ENDIF.
        CATCH /iwbep/cx_mgw_tech_exception.
          "do nothing here
      ENDTRY.
    ENDIF.

    IF mv_language IS INITIAL.
      mv_language = co_default_lang.
    ENDIF.

    IF mt_text_pool IS INITIAL.
      DATA(lv_class_pool_name) = cl_oo_classname_service=>get_classpool_name( co_class_name ).
      SELECT SINGLE spras FROM t002 WHERE  laiso = @mv_language INTO @DATA(lv_lang_parameter).
      IF sy-subrc <> 0.
        lv_lang_parameter = co_default_lang_parameter.
      ENDIF.
      READ TEXTPOOL lv_class_pool_name INTO mt_text_pool LANGUAGE lv_lang_parameter.
    ENDIF.

    IF line_exists( mt_text_pool[ key = iv_id ] ).   "Current language text pool
      rv_text = mt_text_pool[ key = iv_id ]-entry.
    ELSEIF line_exists( mt_default_text_pool[ key = iv_id ] ).  "English text pool
      rv_text = mt_default_text_pool[ key = iv_id ]-entry.
    ELSE.
      rv_text = space.
    ENDIF.
  ENDMETHOD.


  METHOD get_transaction.
    ev_transaction = mv_transaction.
  ENDMETHOD.


  METHOD get_where_used_list.
    TRY.
        DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( iv_project_id ).
        DATA(lo_object) = lo_project->get_migobj_proxy_by_uuid( iv_object_id ).
        DATA(lo_task) = lo_object->get_task_proxy_by_uuid( iv_task_id ).
        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_task_detail( ).
        DATA(lt_where_used) = lo_task->get_used_by_migobj( io_cntxt = lo_obj_ctx ).

        ct_result = VALUE #( FOR where_used IN lt_where_used
                               ( migrationprojectuuid         = iv_project_id
                                 migrationobjectuuid          = iv_object_id
                                 migrationtaskuuid            = iv_task_id
                                 referencemigrationobjectname = where_used-object_name
                                 referencemigrationobjectuuid = where_used-object_uuid
                               ) ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        DATA(lt_mc_messages) = lo_exception->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
    ENDTRY.
  ENDMETHOD.


  METHOD handle_applicationlogral.
    DATA: ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_applicationlogral.
    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).
*  this is dummy method only for RAL logging of downloading application log
    es_downloadapplog-migrationhistoryuuid = ls_parameter-migrationhistoryuuid .
    es_downloadapplog-migrationobjectuuid = ls_parameter-migrationobjectuuid.
    es_downloadapplog-migrationprojectuuid = ls_parameter-migrationprojectuuid.
    es_downloadapplog-appllognr = ls_parameter-appllognr.
    es_downloadapplog-displayoption = ls_parameter-displayoption.
    es_downloadapplog-msgmsgty = ls_parameter-msgmsgty.
    es_downloadapplog-msgmsgid = ls_parameter-msgmsgid.
    es_downloadapplog-msgmsgno = ls_parameter-msgmsgno.
    es_downloadapplog-msguuid = ls_parameter-msguuid.
  ENDMETHOD.


  METHOD handle_cancel_activity.
    DATA: ls_parameter  TYPE /ltb/cl_mig_mc_odata_mpc=>ts_cancelactivity.

    FIELD-SYMBOLS: <er_data> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).
        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        lo_obj_ctx->set_act_uuid( iv_act_uuid = CONV #( ls_parameter-eventactivityuuid ) ).
        DATA(lv_success) = lo_object_proxy->cancel_activity( lo_obj_ctx ).

        CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.
        ASSIGN er_data->* TO <er_data>.
        IF lv_success = abap_true.
          <er_data>-returncode = abap_true.
        ELSE.
          <er_data>-returncode = abap_false.
        ENDIF.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD handle_check_auth.
    DATA: ls_parameter  TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.
    DATA: lv_error TYPE boolean VALUE abap_false.
    DATA: lt_messages TYPE cnv_mbt_t_bal_s_msg.
    CONSTANTS c_btcoption_job_repo_activate TYPE btcoptions-btcoption VALUE 'JOB_REPO_ACTIVATE'.
    CONSTANTS c_value1_periodic_run         TYPE btcoptions-value1    VALUE 'PERIODIC_RUN'.
    FIELD-SYMBOLS: <er_data> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter ).

    TRY.
        CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.
        ASSIGN er_data->* TO <er_data>.
        "check job repository
        SELECT SINGLE * FROM btcoptions INTO @DATA(wa_opt) WHERE btcoption = @c_btcoption_job_repo_activate
                                                AND value1    = @c_value1_periodic_run.

        IF sy-subrc = 0.
          lv_error = abap_true.
          <er_data>-returncode = abap_false.
          APPEND VALUE #( msgty = 'E'
                      msgid = '/LTB/MC'
                      msgno = 289 ) TO lt_messages.
        ELSE.
          lv_error = abap_false.
          <er_data>-returncode = abap_true.
        ENDIF.

        "check system property
        IF /ltb/cl_ext_cls_factory=>get_cos_utilities( )->is_cloud( ) = abap_true.
          lv_error = abap_false.
          <er_data>-returncode = abap_true.
        ELSE.
          /ltb/cl_bas_utils=>is_system_editable( RECEIVING rv_editable = DATA(lv_editable) ).
          IF lv_editable = abap_true.
            lv_error = abap_false.
            <er_data>-returncode = abap_true.
          ELSE.
            lv_error = abap_true.
            <er_data>-returncode = abap_false.
            APPEND VALUE #( msgty = 'E'
                        msgid = '/LTB/MC'
                        msgno = 290 ) TO lt_messages.
          ENDIF.
        ENDIF.
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        lt_messages = lx_exception->get_messages( ).
        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).

    ENDTRY.

    IF lv_error = abap_true.
      raise_bussiness_exception(
        EXPORTING
          iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
          it_message           = lt_messages ).
    ENDIF.
  ENDMETHOD.


  METHOD handle_check_content_exist.
    TYPES:
      BEGIN OF ts_check_content_exist,
        checktype  TYPE int1,
        parameter1 TYPE string,
        parameter2 TYPE string,
        parameter3 TYPE string,
      END OF ts_check_content_exist .

    DATA:
      ls_parameter  TYPE ts_check_content_exist,
      lv_check_type TYPE i,
      lv_proj_uuid  TYPE /ltb/mc_proj_uuid,
      lv_act_uuid   TYPE /ltb/mc_act_uuid,
      lt_file_info  TYPE /ltb/mc_t_filestor,
      ls_event_data TYPE /ltb/cl_mc_eventlog_access=>gty_fileproc_info.

    FIELD-SYMBOLS:
      <er_data> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
       es_parameter_values = ls_parameter ).

    lv_proj_uuid  = ls_parameter-parameter1.
    lv_act_uuid   = ls_parameter-parameter2.
    lv_check_type = ls_parameter-checktype.

    CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.
    ASSIGN er_data->* TO <er_data>.

    CASE lv_check_type.
      WHEN 1. " Cehck Template File content
        "Check activity ID exist in file store
        DATA(ls_fileproc) = /ltb/cl_mc_fileproc_access=>get_by_fileproc( lv_act_uuid ).
        IF ls_fileproc IS NOT INITIAL.
          <er_data>-returncode = abap_true.
        ELSE.
          <er_data>-returncode = abap_false.
        ENDIF.

      WHEN 2 or 3 or 5. "2: Check task value content / 3: Migration Object Message details file / 5: Migration Result file
        "Check activity ID exist in file store
        lt_file_info = /ltb/cl_mc_filestor_access=>get_file_info( iv_proj_uuid = lv_proj_uuid iv_act_uuid = lv_act_uuid ).
        IF lt_file_info IS NOT INITIAL.
          <er_data>-returncode = abap_true.
        ELSE.
          <er_data>-returncode = abap_false.
        ENDIF.

      WHEN 4. "Correction file
        DATA(ls_event) = /ltb/cl_mc_eventlog_access=>get_last_event_by_actuuid(
          EXPORTING
            iv_proj_uuid = lv_proj_uuid
            iv_act_uuid  = lv_act_uuid
        ).

        CALL TRANSFORMATION id SOURCE XML ls_event-event_data
           RESULT data =  ls_event_data .

        DATA(ls_correction) = /ltb/cl_mc_fileproc_access=>get_by_fileproc( ls_event_data-fileproc_uuid ).
        IF ls_correction-filedata IS NOT INITIAL.
          <er_data>-returncode = abap_true.
        ELSE.
          <er_data>-returncode = abap_false.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD handle_check_copy_project.
    DATA:
      ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkcopyproject,
      lv_locked    TYPE abap_bool,
      lv_proj_id   TYPE /ltb/mc_proj_uuid,
      lt_msg       TYPE cnv_mbt_t_bal_s_msg,
      lv_message   TYPE string.

    FIELD-SYMBOLS:
      <er_data> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkcopyprojectresult.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
       es_parameter_values = ls_parameter ).

    lv_proj_id = ls_parameter-migrationprojectuuid.

    CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkcopyprojectresult.
    ASSIGN er_data->* TO <er_data>.
    CHECK <er_data> IS ASSIGNED.

    DATA(ls_project) = /ltb/cl_mc_proj_access=>get_by_uuid( lv_proj_id ).

    IF ls_project-approach = /ltb/if_mc_constants=>gc_approach-sap_direct.
      IF is_delete_proj_running( lv_proj_id ) = abap_true.
        <er_data>-checkresult = 'E'.
        "Cannot copy project. The system is currently deleting this project.
        MESSAGE e270(/ltb/mc) INTO <er_data>-message.
        RETURN.
      ENDIF.

      IF is_copy_mo_running( lv_proj_id ) = abap_true.
        <er_data>-checkresult = 'E'.
        "Cannot copy project. Project is not ready for processing.
        MESSAGE e825(/ltb/mc) INTO <er_data>-message.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        "Check whether at least one area of the project is not yet copied/prepared
        DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_id ).
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        DATA(lt_objects) = lo_project->get_migobjs( lo_cntxt_proj ).
        DELETE lt_objects WHERE migobj_active = /ltb/if_mc_constants=>gc_migobj_active-active.

        IF lines( lt_objects ) > 0.
          IF ls_project-approach = /ltb/if_mc_constants=>gc_approach-staging.
            <er_data>-checkresult = 'E'.
            <er_data>-message = |{ TEXT-w02 } { TEXT-w04 }|.
            RETURN.
          ELSE.
            <er_data>-checkresult = 'W'.
            <er_data>-message = |{ TEXT-w02 } { TEXT-w03 }|.
            RETURN.
          ENDIF.
        ENDIF.
        <er_data>-checkresult = 'S'.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).
        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD HANDLE_CHECK_DB_CONNECTION.
    DATA:
      ls_parameter  TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkdbconnection,
      lv_valid      TYPE abap_bool,
      lv_connection TYPE dbcon_name.

    FIELD-SYMBOLS:
      <er_data> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkdbconnectionresult.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
       es_parameter_values = ls_parameter ).

    lv_connection = ls_parameter-connection.

    CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkdbconnectionresult.
    ASSIGN er_data->* TO <er_data>.
    CHECK <er_data> IS ASSIGNED.
    IF is_dbcon_lost( lv_connection ) = abap_true.
      <er_data>-valid = abap_false.
    ELSE.
      <er_data>-valid = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD handle_check_dev_class.
    DATA:
      ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkdevclass,
      lv_existing  TYPE abap_bool,
      lv_editable  TYPE abap_bool,
      lv_devclass  TYPE devclass.

    FIELD-SYMBOLS:
      <er_data> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkdevclassresult.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
       es_parameter_values = ls_parameter ).

    lv_devclass = ls_parameter-devclass.

    CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkdevclassresult.
    ASSIGN er_data->* TO <er_data>.
    CHECK <er_data> IS ASSIGNED.

    IF lv_devclass IS INITIAL.
      <er_data>-valid = abap_false.
      MESSAGE e597(cnv_pe) INTO <er_data>-message.
      RETURN.
    ENDIF.

    TRANSLATE lv_devclass TO UPPER CASE.
    "Check, that defined DEVC exists and is editable
    CALL METHOD /ltb/cl_bas_utils=>is_devc_existing_and_editable
      EXPORTING
        iv_devc     = lv_devclass
      IMPORTING
        ev_existing = lv_existing
        ev_editable = lv_editable.
    IF lv_existing = abap_false.
      <er_data>-valid = abap_false.
      MESSAGE e598(cnv_pe) WITH lv_devclass INTO <er_data>-message.
      RETURN.
    ENDIF.
    IF lv_editable = abap_false.
      <er_data>-valid = abap_false.
      MESSAGE e599(cnv_pe) WITH lv_devclass INTO <er_data>-message.
      RETURN.
    ENDIF.

    <er_data>-valid = abap_true.
  ENDMETHOD.


  METHOD handle_check_rfc_connection.

    DATA ls_parameter  TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkrfcconnection.
    DATA lv_connection TYPE text80.
    DATA lv_connectionuuid TYPE CNV_PE_COM_CA_UUID.

    FIELD-SYMBOLS:
    <er_data> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkrfcconnectionresult.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
       es_parameter_values = ls_parameter ).

    lv_connection = ls_parameter-connection.
    "lv_connectionuuid = ls_parameter-connectionuuid.

    CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkrfcconnectionresult.
    ASSIGN er_data->* TO <er_data>.
    CHECK <er_data> IS ASSIGNED.

    "Check if connection works
    <er_data>-invalid = is_rfc_available( EXPORTING iv_connection     = lv_connection
                                                    iv_connectionuuid = lv_connectionuuid ).

  ENDMETHOD.


  METHOD handle_check_upgrade_state.

    DATA:
      ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_checkupgradestate.

    FIELD-SYMBOLS:
      <data> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectupgradestate.


    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter ).

    TRY.

        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).

        DATA(lo_migobj_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).

        DATA(ls_state) = lo_migobj_proxy->check_content_upgrade_state( ).

        CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectupgradestate.

        ASSIGN er_data->* TO <data>.

        <data>-migrationprojectuuid           = ls_state-project_uuid.
        <data>-migrationobjectuuid            = ls_state-migobj_uuid.
        <data>-migrationobjectname            = ls_state-migobj_descr.
        <data>-contentupgradestate            = ls_state-state.
        <data>-migrationobjectactiivestatusuu = ls_state-active_status.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).
        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD handle_data_consistent_check.
    DATA:
      ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
      lv_obj_id    TYPE /ltb/mc_object_uuid,
      lv_proj_id   TYPE /ltb/mc_proj_uuid,
      lt_messages  TYPE cnv_mbt_t_bal_s_msg.

    FIELD-SYMBOLS:
      <er_data> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.


    io_tech_request_context->get_converted_parameters(
      IMPORTING
       es_parameter_values = ls_parameter ).

    lv_proj_id = ls_parameter-migrationprojectuuid.
    lv_obj_id = ls_parameter-migrationobjectuuid.

    CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.
    ASSIGN er_data->* TO <er_data>.
    CHECK <er_data> IS ASSIGNED.

    TRY.

        DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_id ).
        DATA(lo_object)  = lo_project->get_migobj_proxy_by_uuid( lv_obj_id ).
        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
        lo_object->check_data_consistency( lo_obj_ctx ).

        <er_data>-returncode = abap_true.
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        <er_data>-returncode = abap_false.
        lt_messages = lx_exception->get_messages( ).
        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD handle_delete_project.
    DATA:
      ls_parameter         TYPE /ltb/cl_mig_mc_odata_mpc=>ts_deleteproject.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).
    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
        lo_project_proxy->delete_proj_async( io_cntxt = lo_obj_ctx ).
      CATCH /ltb/cx_mc_proxy_error  INTO DATA(lx_error).
        MESSAGE ID lx_error->if_t100_message~t100key-msgid TYPE 'E'
          NUMBER lx_error->if_t100_message~t100key-msgno INTO DATA(lv_msg)
          WITH lx_error->msgv1 lx_error->msgv2 lx_error->msgv3 lx_error->msgv4.
        DATA(lx_mgw_bus) = NEW /iwbep/cx_mgw_busi_exception(
            textid       = /iwbep/cx_mgw_busi_exception=>business_error
            message_unlimited = lv_msg ).

        lx_mgw_bus->get_msg_container( )->add_message(
          EXPORTING
            iv_msg_type               = 'E'
            iv_msg_id                 = lx_error->if_t100_message~t100key-msgid
            iv_msg_number             = lx_error->if_t100_message~t100key-msgno
            iv_msg_text               = CONV #( lv_msg )
            iv_msg_v1                 = lx_error->msgv1
            iv_msg_v2                 = lx_error->msgv2
            iv_msg_v3                 = lx_error->msgv3
            iv_msg_v4                 = lx_error->msgv4
*            iv_error_category         =
*            iv_is_leading_message     = abap_true
*            iv_entity_type            =
*            it_key_tab                =
            iv_add_to_response_header = abap_true
*            iv_message_target         =
        ).

        RAISE EXCEPTION lx_mgw_bus.
      CATCH /ltb/cx_mc_cntxt_error.
        MESSAGE e000(/ltb/mc) INTO DATA(lv_message).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid            = /iwbep/cx_mgw_busi_exception=>business_error
            message_unlimited = lv_message.
    ENDTRY.
  ENDMETHOD.


  METHOD handle_delete_task_file.

    DATA ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskfile.
    DATA ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response.


    LOOP AT it_changeset_request ASSIGNING FIELD-SYMBOL(<fs_request>).
      CLEAR: ls_parameter, ls_changeset_response.

      CAST /iwbep/if_mgw_req_entity_d( <fs_request>-request_context )->get_converted_keys(
        IMPORTING
          es_key_values = ls_parameter
      ).
      copy_data_to_ref(
        EXPORTING
          is_data = ls_parameter
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).
      ls_changeset_response-operation_no = <fs_request>-operation_no.
      APPEND ls_changeset_response TO ct_changeset_response.
      TRY .
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
          lo_obj_ctx->add_value(
            EXPORTING
              iv_type  =  /ltb/if_mc_constants=>gc_cntxt_type-fileproc-fileprocuuid       " Context Type
              iv_value =  CONV #( ls_parameter-taskfileuuid )                             " Context Value
          ).
          lo_project_proxy->delete_task_files( io_cntxt =  lo_obj_ctx ).
        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
          DATA(lt_messages) = lx_exception->get_messages( ).

          IF lt_messages IS INITIAL.
            APPEND VALUE #( msgty = 'E'
                            msgid = lx_exception->if_t100_message~t100key-msgid
                            msgno = lx_exception->if_t100_message~t100key-msgno
                            msgv1 = lx_exception->msgv1
                            msgv2 = lx_exception->msgv2
                            msgv3 = lx_exception->msgv3
                            msgv4 = lx_exception->msgv4 ) TO lt_messages.

          ENDIF.
          LOOP AT lt_messages INTO DATA(ls_message).
            <fs_request>-msg_container->add_message(
              EXPORTING
                iv_msg_type   = ls_message-msgty
                iv_msg_id     = ls_message-msgid
                iv_msg_number = ls_message-msgno
                iv_msg_v1     = ls_message-msgv1
                iv_msg_v2     = ls_message-msgv2
                iv_msg_v3     = ls_message-msgv3
                iv_msg_v4     = ls_message-msgv4
                iv_add_to_response_header = abap_true ).
          ENDLOOP.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.


  method handle_downloadcorrectral.
    data: ls_parameter type /ltb/cl_mig_mc_odata_mpc=>ts_downloadcorrectionfileralmo.
    io_tech_request_context->get_converted_parameters(
      importing
         es_parameter_values = ls_parameter
     ).
*  this is dummy method only for RAL logging of downloading correction XML file
    es_migrationfiletemplate-migrationobjectuuid = ls_parameter-migrationobjectuuid.
    es_migrationfiletemplate-downloadactivityid = ls_parameter-downloadactivityid.
    es_migrationfiletemplate-migrationprojectuuid = ls_parameter-migrationprojectuuid.
  endmethod.


  method HANDLE_DOWNLOADTASKRAL.
    data: ls_parameter type /ltb/cl_mig_mc_odata_mpc=>ts_migrationtaskvaluefile.
    io_tech_request_context->get_converted_parameters(
      importing
         es_parameter_values = ls_parameter
     ).
*  this is dummy method only for RAL logging of downloading mapping task XML file
    es_downloadtaskfileral-activityuuid = ls_parameter-activityuuid .
    es_downloadtaskfileral-downloadoption = ls_parameter-downloadoption.
    es_downloadtaskfileral-migrationprojectuuid = ls_parameter-migrationprojectuuid.
    es_downloadtaskfileral-migrationtaskuuid = ls_parameter-migrationtaskuuid.
  endmethod.


  method handle_downloaduploadral.
    data: ls_parameter type /ltb/cl_mig_mc_odata_mpc=>ts_downloaduploadedfileralmoni.

    io_tech_request_context->get_converted_parameters(
      importing
         es_parameter_values = ls_parameter
     ).
*  this is dummy method only for RAL logging of downloading uploaded XML file
    es_downloadmigrationfile-migrationfileproc = ls_parameter-migrationfileproc.

  endmethod.


  METHOD handle_download_instance.
    DATA ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_downloadmigrationinstance.
    DATA ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response.
    DATA ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationinstancedownload.
    DATA lt_msg                TYPE cnv_mbt_t_bal_s_msg.
    DATA lt_filter             TYPE /ltb/if_mc_constants=>tt_sel.
    DATA lt_filter_tmp         TYPE /ltb/if_mc_constants=>tt_sel.
    DATA ls_filter             TYPE /ltb/if_mc_constants=>ts_sel.
    DATA lt_selopt_t           TYPE /ltb/if_mc_constants=>tt_selopt.
    DATA ls_selopt             TYPE /ltb/if_mc_constants=>ts_selopt.
    DATA lx_error              TYPE REF TO /ltb/cx_mc_static_check_msg.
    DATA lv_field              TYPE string.
    DATA lt_sel_field          TYPE /ltb/if_mc_constants=>gtt_selected_field.
    DATA ls_sel_field          TYPE /ltb/if_mc_constants=>gty_selected_field.
    DATA lv_fieldname          TYPE fieldname.

    FIELD-SYMBOLS <ls_filter>  TYPE /ltb/if_mc_constants=>ts_sel.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
         es_parameter_values = ls_parameter
     ).
    TRY .
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
        DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).
        DATA(lo_object_ctx)    = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        DATA(lt_itemlist_metadata) = lo_object_proxy->get_itemlist_metadata( lo_object_ctx ).

        /ui2/cl_json=>deserialize( EXPORTING json        = ls_parameter-filter
                                             pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                   CHANGING  data        = lt_filter ).

        LOOP AT lt_filter ASSIGNING <ls_filter>.
          IF <ls_filter>-fieldname CP 'Result*'.
            lv_fieldname = <ls_filter>-fieldname.
            TRANSLATE lv_fieldname TO UPPER CASE.
            READ TABLE lt_itemlist_metadata ASSIGNING FIELD-SYMBOL(<ls_itemlist_metadata>) WITH KEY fieldname = lv_fieldname.
            IF sy-subrc = 0.
              <ls_filter>-fieldname = <ls_itemlist_metadata>-ori_name.
            ENDIF.
          ELSE.
            CHECK strlen( <ls_filter>-fieldname ) GT 9 AND
                  <ls_filter>-fieldname(9) = 'ItemField'.
            DATA(lv_position) = <ls_filter>-fieldname+9.
            DATA(lv_index) = CONV i( lv_position ).

            READ TABLE lt_itemlist_metadata ASSIGNING <ls_itemlist_metadata> INDEX lv_index.
            IF sy-subrc = 0.
              <ls_filter>-fieldname = <ls_itemlist_metadata>-fieldname.
            ENDIF.
          ENDIF.

        ENDLOOP.

        lv_field = ls_parameter-fieldname.
        IF lv_field IS NOT INITIAL.
          SPLIT lv_field AT ',' INTO TABLE lt_sel_field.
        ENDIF.

        ls_selopt-sign = 'I'.
        ls_selopt-option = 'EQ'.
        LOOP AT lt_sel_field INTO ls_sel_field.
          ls_selopt-low = ls_sel_field-fieldname.
          APPEND ls_selopt TO lt_selopt_t.
        ENDLOOP.
        ls_filter-fieldname = 'FIELD_NAME'.
        ls_filter-selopt_t = lt_selopt_t.
        APPEND ls_filter TO lt_filter.

        lo_object_ctx->set_filter( lt_filter ).
        lo_object_ctx->add_value( iv_type =  /ltb/if_mc_constants=>gc_cntxt_type-displayoption
                                   iv_value = CONV #( ls_parameter-displayoption ) ).
        lo_object_proxy->generate_mig_instance_file( lo_object_ctx ).

      CATCH /ltb/cx_mc_proxy_error /ltb/cx_mc_cntxt_error  INTO lx_error.
        DATA(lt_messages) = lx_error->get_messages( ).
        DESCRIBE TABLE lt_messages LINES DATA(lv_count).
        IF lv_count = 0.
          MESSAGE ID lx_error->if_t100_message~t100key-msgid TYPE 'E'
          NUMBER lx_error->if_t100_message~t100key-msgno INTO DATA(lv_msg)
          WITH lx_error->msgv1 lx_error->msgv2 lx_error->msgv3 lx_error->msgv4.
        ELSE.
          READ TABLE lt_messages INTO DATA(ls_message) INDEX 1.
          MESSAGE ID ls_message-msgid TYPE 'E' NUMBER ls_message-msgno INTO lv_msg
          WITH ls_message-msgv1 ls_message-msgv2 ls_message-msgv3 ls_message-msgv4.
        ENDIF.
        DATA(lx_mgw_bus) = NEW /iwbep/cx_mgw_busi_exception(
             textid       = /iwbep/cx_mgw_busi_exception=>business_error
             message_unlimited = lv_msg ).
        lx_mgw_bus->get_msg_container( )->add_message(
          EXPORTING
            iv_msg_type               = 'E'
            iv_msg_id                 = lx_error->if_t100_message~t100key-msgid
            iv_msg_number             = lx_error->if_t100_message~t100key-msgno
            iv_msg_text               = CONV #( lv_msg )
            iv_msg_v1                 = lx_error->msgv1
            iv_msg_v2                 = lx_error->msgv2
            iv_msg_v3                 = lx_error->msgv3
            iv_msg_v4                 = lx_error->msgv4
            iv_add_to_response_header = abap_true ).
        RAISE EXCEPTION lx_mgw_bus.
    ENDTRY.

*  this is dummy method only for RAL logging of downloading correction XML file
    es_migrationinstancedownload-migrationprojectuuid = ls_parameter-migrationprojectuuid.
    es_migrationinstancedownload-migrationobjectuuid = ls_parameter-migrationobjectuuid.
    es_migrationinstancedownload-displayoption = ls_parameter-displayoption.
  ENDMETHOD.


  METHOD handle_download_instance_ral.
    DATA: ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationfiletemplate.
    io_tech_request_context->get_converted_parameters(
      IMPORTING
         es_parameter_values = ls_parameter
     ).
*  this is dummy method only for RAL logging of downloading miragtion result file
    es_migrationinstance-migrationobjectuuid = ls_parameter-migrationobjectuuid.
    es_migrationinstance-downloadactivityid = ls_parameter-downloadactivityid.
    es_migrationinstance-migrationprojectuuid = ls_parameter-migrationprojectuuid.
  ENDMETHOD.


  METHOD handle_download_message.
    DATA ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_downloadmigrationinstance.
    DATA ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response.
    DATA ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationinstancedownload.
    DATA lt_msg                TYPE cnv_mbt_t_bal_s_msg.
    DATA lt_filter             TYPE /ltb/if_mc_constants=>tt_sel.
    DATA lt_filter_tmp         TYPE /ltb/if_mc_constants=>tt_sel.
    DATA ls_filter             TYPE /ltb/if_mc_constants=>ts_sel.
    DATA lt_selopt_t           TYPE /ltb/if_mc_constants=>tt_selopt.
    DATA ls_selopt             TYPE /ltb/if_mc_constants=>ts_selopt.
    DATA lx_error              TYPE REF TO /ltb/cx_mc_static_check_msg.
    DATA lv_field              TYPE string.
    DATA lt_sel_field          TYPE /ltb/if_mc_constants=>gtt_selected_field.
    DATA ls_sel_field          TYPE /ltb/if_mc_constants=>gty_selected_field.

    FIELD-SYMBOLS <ls_filter>  TYPE /ltb/if_mc_constants=>ts_sel.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
         es_parameter_values = ls_parameter
     ).
    TRY .
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
        DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).
        DATA(lo_object_ctx)    = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        DATA(lt_itemlist_metadata) = lo_object_proxy->get_itemlist_metadata( lo_object_ctx ).

        /ui2/cl_json=>deserialize( EXPORTING json        = ls_parameter-filter
                                             pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                   CHANGING  data        = lt_filter ).
        LOOP AT lt_filter ASSIGNING <ls_filter>.
          CASE <ls_filter>-fieldname.
            WHEN co_action_uuid.
              <ls_filter>-fieldname = 'ITEM_ACTION'.
            WHEN co_message_type.
              <ls_filter>-fieldname = 'ITEM_STATUS'.
            WHEN co_message_no.
              <ls_filter>-fieldname = 'MSGNO'.
            WHEN co_message_id.
              <ls_filter>-fieldname = 'MSGID'.
            WHEN OTHERS.
          ENDCASE.
        ENDLOOP.

        lv_field = ls_parameter-fieldname.
        IF lv_field IS NOT INITIAL.
          SPLIT lv_field AT ',' INTO TABLE lt_sel_field.
        ENDIF.

        ls_selopt-sign = 'I'.
        ls_selopt-option = 'EQ'.
        LOOP AT lt_sel_field INTO ls_sel_field.
          ls_selopt-low = ls_sel_field-fieldname.
          APPEND ls_selopt TO lt_selopt_t.
        ENDLOOP.
        ls_filter-fieldname = 'FIELD_NAME'.
        ls_filter-selopt_t = lt_selopt_t.
        APPEND ls_filter TO lt_filter.

        lo_object_ctx->set_filter( lt_filter ).
        lo_object_proxy->generate_message_file( lo_object_ctx ).

      CATCH /ltb/cx_mc_proxy_error /ltb/cx_mc_cntxt_error  INTO lx_error.
        DATA(lt_messages) = lx_error->get_messages( ).
        DESCRIBE TABLE lt_messages LINES DATA(lv_count).
        IF lv_count = 0.
          MESSAGE ID lx_error->if_t100_message~t100key-msgid TYPE 'E'
          NUMBER lx_error->if_t100_message~t100key-msgno INTO DATA(lv_msg)
          WITH lx_error->msgv1 lx_error->msgv2 lx_error->msgv3 lx_error->msgv4.
        ELSE.
          READ TABLE lt_messages INTO DATA(ls_message) INDEX 1.
          MESSAGE ID ls_message-msgid TYPE 'E' NUMBER ls_message-msgno INTO lv_msg
          WITH ls_message-msgv1 ls_message-msgv2 ls_message-msgv3 ls_message-msgv4.
        ENDIF.
        DATA(lx_mgw_bus) = NEW /iwbep/cx_mgw_busi_exception(
             textid       = /iwbep/cx_mgw_busi_exception=>business_error
             message_unlimited = lv_msg ).
        lx_mgw_bus->get_msg_container( )->add_message(
          EXPORTING
            iv_msg_type               = 'E'
            iv_msg_id                 = lx_error->if_t100_message~t100key-msgid
            iv_msg_number             = lx_error->if_t100_message~t100key-msgno
            iv_msg_text               = CONV #( lv_msg )
            iv_msg_v1                 = lx_error->msgv1
            iv_msg_v2                 = lx_error->msgv2
            iv_msg_v3                 = lx_error->msgv3
            iv_msg_v4                 = lx_error->msgv4
            iv_add_to_response_header = abap_true ).
        RAISE EXCEPTION lx_mgw_bus.
    ENDTRY.

*  this is dummy method only for RAL logging of downloading correction XML file
    es_migrationobjectmessagedownl-migrationprojectuuid = ls_parameter-migrationprojectuuid.
    es_migrationobjectmessagedownl-migrationobjectuuid = ls_parameter-migrationobjectuuid.
  ENDMETHOD.


  METHOD handle_download_messageral.
    DATA: ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationfiletemplate.
    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).
*  this is dummy method only for RAL logging of downloading mapping task XML file
    es_downloadmessage-downloadactivityid = ls_parameter-downloadactivityid .
    es_downloadmessage-migrationobjectuuid = ls_parameter-migrationobjectuuid.
    es_downloadmessage-migrationprojectuuid = ls_parameter-migrationprojectuuid.
  ENDMETHOD.


  METHOD handle_export_project.

    DATA: ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_exportproject.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
        DATA(lo_project_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
        lo_project_proxy->export_proj_async( io_cntxt = lo_project_ctx ).

      CATCH /ltb/cx_mc_proxy_error  INTO DATA(lx_error).
        MESSAGE ID lx_error->if_t100_message~t100key-msgid TYPE 'E'
          NUMBER lx_error->if_t100_message~t100key-msgno INTO DATA(lv_msg)
          WITH lx_error->msgv1 lx_error->msgv2 lx_error->msgv3 lx_error->msgv4.

        DATA(lx_mgw_bus) = NEW /iwbep/cx_mgw_busi_exception(
            textid       = /iwbep/cx_mgw_busi_exception=>business_error
            message_unlimited = lv_msg ).

        lx_mgw_bus->get_msg_container( )->add_message(
          EXPORTING
            iv_msg_type               = 'E'
            iv_msg_id                 = lx_error->if_t100_message~t100key-msgid
            iv_msg_number             = lx_error->if_t100_message~t100key-msgno
            iv_msg_text               = CONV #( lv_msg )
            iv_msg_v1                 = lx_error->msgv1
            iv_msg_v2                 = lx_error->msgv2
            iv_msg_v3                 = lx_error->msgv3
            iv_msg_v4                 = lx_error->msgv4
            iv_add_to_response_header = abap_true
        ).

        RAISE EXCEPTION lx_mgw_bus.

      CATCH /ltb/cx_mc_cntxt_error.
        MESSAGE e007(/ltb/mc) INTO DATA(lv_message).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid            = /iwbep/cx_mgw_busi_exception=>business_error
            message_unlimited = lv_message.
    ENDTRY.
  ENDMETHOD.


  METHOD handle_file_process.
    DATA ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_fileprocess.
    DATA ls_entity TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationfile.
    DATA ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response.
    DATA lt_fileproc_uuid TYPE /ltb/if_mc_constants=>gtt_fileproc_uuid.
    DATA lv_fileproc_action TYPE string.

    LOOP AT it_changeset_request ASSIGNING FIELD-SYMBOL(<fs_request>).
      CLEAR: ls_parameter, ls_entity, ls_changeset_response.

      CAST /iwbep/if_mgw_req_func_import( <fs_request>-request_context )->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter ).

      ls_entity = CORRESPONDING #( ls_parameter ).
      GET TIME STAMP FIELD ls_entity-createdat.
      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).

      ls_changeset_response-operation_no = <fs_request>-operation_no.
      APPEND ls_changeset_response TO ct_changeset_response.

      lv_fileproc_action = ls_parameter-migrationfileprocessaction.
      APPEND ls_parameter-migrationfileuuid TO lt_fileproc_uuid.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).

          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).

          CASE ls_parameter-migrationfileprocessaction.
            WHEN /ltb/if_mc_constants=>gc_fileproc-action-generate.

              DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

              lo_obj_ctx->set_grp_indicator( CONV #( ls_parameter-filegroupindicator ) ).

              lo_obj_ctx->add_value(
                EXPORTING
                  iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-fileproc-filecategory
                  iv_value = CONV #( ls_parameter-filecategory )
              ).

              lo_object_proxy->generate_correction_file( lo_obj_ctx ).

            WHEN /ltb/if_mc_constants=>gc_fileproc-action-validate OR
                 /ltb/if_mc_constants=>gc_fileproc-action-import-skipfile_mode OR
                 /ltb/if_mc_constants=>gc_fileproc-action-import-overwrite_mode.

              DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( ls_parameter-migrationfileuuid ) ).

              DATA(lo_file_ctx) = NEW /ltb/cl_mc_cntxt_file_detail( ).

              lo_file_ctx->set_action( CONV #( ls_parameter-migrationfileprocessaction ) ).

              lo_file_proxy->process_action( lo_file_ctx ).

          ENDCASE.
        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
          DATA(lt_messages) = lx_exception->get_messages( ).

          IF lt_messages IS INITIAL.
            APPEND VALUE #( msgty = 'E'
                            msgid = lx_exception->if_t100_message~t100key-msgid
                            msgno = lx_exception->if_t100_message~t100key-msgno
                            msgv1 = lx_exception->msgv1
                            msgv2 = lx_exception->msgv2
                            msgv3 = lx_exception->msgv3
                            msgv4 = lx_exception->msgv4 ) TO lt_messages.

          ENDIF.

          LOOP AT lt_messages INTO DATA(ls_message).
            <fs_request>-msg_container->add_message(
              EXPORTING
                iv_msg_type   = ls_message-msgty
                iv_msg_id     = ls_message-msgid
                iv_msg_number = ls_message-msgno
                iv_msg_v1     = ls_message-msgv1
                iv_msg_v2     = ls_message-msgv2
                iv_msg_v3     = ls_message-msgv3
                iv_msg_v4     = ls_message-msgv4
                iv_add_to_response_header = abap_true ).
          ENDLOOP.
      ENDTRY.
    ENDLOOP.

    IF lv_fileproc_action = /ltb/if_mc_constants=>gc_fileproc-action-delete.
      TRY.
          lo_object_proxy->delete_files( lt_fileproc_uuid ).
        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_mc_exception).
          lt_messages = lx_mc_exception->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
              it_message           = lt_messages
          ).
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD handle_finish_project.
    DATA ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_finishproject.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).
    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
        lo_obj_ctx->set_retention_time( iv_retention_time = ls_parameter-retentiontime ).
        lo_project_proxy->finish_proj( EXPORTING io_cntxt = lo_obj_ctx
                                       IMPORTING ev_warning_exist = ev_warning_exist ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        MESSAGE e004(/ltb/mc) INTO DATA(lv_message).
        DATA(lt_mc_messages) = lo_exception->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_mc_messages
        ).

    ENDTRY.
  ENDMETHOD.


  METHOD handle_get_file_content.

    DATA:
      ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_getfilecontent,
      lt_order     TYPE /iwbep/t_mgw_sorting_order.

    FIELD-SYMBOLS:
      <fs_data> TYPE STANDARD TABLE,
      <er_data> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationfilecontent.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter ).

    SPLIT ls_parameter-sortstring AT ',' INTO TABLE DATA(sorttab).

    LOOP AT sorttab ASSIGNING FIELD-SYMBOL(<fs_sort>).
      INSERT INITIAL LINE INTO TABLE lt_order ASSIGNING FIELD-SYMBOL(<fs_order>).
      SPLIT <fs_sort> AT space INTO <fs_order>-property <fs_order>-order.
    ENDLOOP.

    TRY.

        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).

        DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( ls_parameter-migrationfileuuid ) ).

        DATA(lo_file_ctx) = NEW /ltb/cl_mc_cntxt_file_detail( ).

        lo_file_ctx->set_tabname( CONV #( ls_parameter-tableident ) ).

        set_context(
          EXPORTING
            iv_entity_set_name = co_entity_file_content
            it_order           = lt_order
            is_paging          = VALUE #( top = ls_parameter-pagetop skip = ls_parameter-pageskip )
            iv_search_string   = ls_parameter-searchstring
            io_context         = lo_file_ctx ).

        lo_file_proxy->get_data(
          EXPORTING
            io_cntxt = lo_file_ctx
          IMPORTING
            er_data  = DATA(lr_data)
            ev_count = DATA(lv_count) ).

        ASSIGN lr_data->* TO <fs_data>.

        DATA(writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

        CALL TRANSFORMATION id SOURCE data = <fs_data>
                               RESULT XML writer.

        CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationfilecontent.

        ASSIGN er_data->* TO <er_data>.

        <er_data> = VALUE #(
          migrationprojectuuid = ls_parameter-migrationobjectuuid
          migrationobjectuuid  = ls_parameter-migrationobjectuuid
          migrationfileuuid    = ls_parameter-migrationfileuuid
          tableident           = ls_parameter-tableident
          numofentries         = lv_count
          filecontent          = cl_abap_codepage=>convert_from( writer->get_output( ) )
       ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  method HANDLE_GET_FORWARD_NAVI.
    DATA ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_getforwardnavigation.
    DATA lt_filter TYPE /ltb/if_mc_constants=>gtt_filter_cond.

    FIELD-SYMBOLS <er_data> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_forwardnavigation.

    io_tech_request_context->get_converted_parameters( IMPORTING es_parameter_values = ls_parameter ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).
        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        lo_obj_ctx->set_item_uuid( iv_item_uuid = ls_parameter-migrationinstanceuuid ).

        IF ls_parameter-optionid IS NOT INITIAL.
          lt_filter = VALUE #( BASE lt_filter
                ( field = 'OPTIONID'
                  sign  = 'I'
                  oper  = 'EQ'
                  low   = ls_parameter-optionid
                  high  = '' ) ).
        ENDIF.

        IF ls_parameter-step IS NOT INITIAL.
          lt_filter = VALUE #( BASE lt_filter
                ( field = 'STEP'
                  sign  = 'I'
                  oper  = 'EQ'
                  low   = ls_parameter-step
                  high  = '' ) ).
        ENDIF.

        IF lt_filter IS NOT INITIAL.
          lo_obj_ctx->set_filter_cond( lt_filter ).
        ENDIF.


        CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_forwardnavigation.
        ASSIGN er_data->* TO <er_data>.

        MOVE-CORRESPONDING lo_object_proxy->get_forward_navi( lo_obj_ctx ) TO <er_data>.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  endmethod.


  METHOD handle_get_org_editability.

    DATA ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_getorgeditability.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.

    TRY.
        es_process_result-returncode = lo_project_proxy->get_org_editability( ).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.
  ENDMETHOD.


  METHOD handle_get_staging_content.

    DATA:
      ls_parameter       TYPE /ltb/cl_mig_mc_odata_mpc=>ts_getstagingcontent,
      lv_item_uuid       TYPE /ltb/if_mc_constants=>gty_item_uuid,
      lt_order           TYPE /iwbep/t_mgw_sorting_order,
      ls_content_key     TYPE /ltb/cl_mig_mc_odata_mpc=>ts_tabledata,
      lo_staging_content TYPE REF TO data,
      ls_content_data    TYPE /ltb/cl_mig_mc_odata_mpc=>ts_stagingcontent.

    FIELD-SYMBOLS:
      <fs_staging_content> TYPE STANDARD TABLE.


    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter ).

    SPLIT ls_parameter-sortstring AT ',' INTO TABLE DATA(sorttab).

    LOOP AT sorttab ASSIGNING FIELD-SYMBOL(<fs_sort>).
      INSERT INITIAL LINE INTO TABLE lt_order ASSIGNING FIELD-SYMBOL(<fs_order>).
      SPLIT <fs_sort> AT space INTO <fs_order>-property <fs_order>-order.
    ENDLOOP.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).

        DATA(lo_item_proxy) = lo_object_proxy->get_item_proxy_by_uuid( lv_item_uuid ).

        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        set_context(
          EXPORTING
            iv_entity_set_name       = co_entity_tabledata
            it_order                 = lt_order
            is_paging                = VALUE #( top = ls_parameter-pagetop skip = ls_parameter-pageskip )
            iv_search_string         = ls_parameter-searchstring
            io_context               = lo_obj_ctx ).

        lo_obj_ctx->set_tab_uuid( CONV #( ls_parameter-stagingtechid ) ).

        lo_item_proxy->get_table_data(
          EXPORTING
            io_cntxt  = lo_obj_ctx
          IMPORTING
            et_data   = DATA(lt_data)
            ev_count  = DATA(lv_count) ).

        IF lt_data IS NOT INITIAL.

          READ TABLE lt_data ASSIGNING FIELD-SYMBOL(<fs_data>) INDEX 1.

          DATA(lo_struc_uuid) = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( ls_content_key ) ).

          DATA(lo_struc_data) = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data_ref( <fs_data>-data ) ).

          DATA(lt_struc_comp) = VALUE cl_abap_structdescr=>component_table(
            ( name = 'KEY'  type = CAST #( lo_struc_uuid ) as_include = abap_true )
            ( name = 'DATA' type = CAST #( lo_struc_data ) as_include = abap_true ) ).

          DATA(lo_struc_desc) = cl_abap_structdescr=>get( lt_struc_comp ).

          DATA(lo_table_desc) = cl_abap_tabledescr=>get( lo_struc_desc ).

          CREATE DATA lo_staging_content TYPE HANDLE lo_table_desc.

          ASSIGN lo_staging_content->* TO <fs_staging_content>.

          LOOP AT lt_data ASSIGNING <fs_data>.
            INSERT INITIAL LINE INTO TABLE <fs_staging_content> ASSIGNING FIELD-SYMBOL(<content>).

            ASSIGN <fs_data>-data->* TO FIELD-SYMBOL(<table_data>).

            MOVE-CORRESPONDING <table_data> TO <content>.

            ASSIGN COMPONENT 'MIGRATIONPROJECTUUID' OF STRUCTURE <content> TO FIELD-SYMBOL(<fs_proj_uuid>).
            IF <fs_proj_uuid> IS ASSIGNED.
              <fs_proj_uuid> = ls_parameter-migrationprojectuuid.
            ENDIF.

            ASSIGN COMPONENT 'MIGRATIONOBJECTUUID' OF STRUCTURE <content> TO FIELD-SYMBOL(<fs_obj_uuid>).
            IF <fs_obj_uuid> IS ASSIGNED.
              <fs_obj_uuid> = ls_parameter-migrationobjectuuid.
            ENDIF.

            ASSIGN COMPONENT 'TABLEUUID' OF STRUCTURE <content> TO FIELD-SYMBOL(<fs_table_uuid>).
            IF <fs_table_uuid> IS ASSIGNED.
              <fs_table_uuid> = ls_parameter-stagingtechid.
            ENDIF.

            ASSIGN COMPONENT 'GENERATEDKEY' OF STRUCTURE <content> TO FIELD-SYMBOL(<fs_generated_key>).
            IF <fs_generated_key> IS ASSIGNED.
              <fs_generated_key> = <fs_data>-generated_key.
            ENDIF.
          ENDLOOP.

          DATA(writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

          CALL TRANSFORMATION id SOURCE data = <fs_staging_content>
                                 RESULT XML writer.

          ls_content_data-content = cl_abap_codepage=>convert_from( writer->get_output( ) ).

        ENDIF.

        ls_content_data-count = lv_count.
        CONDENSE ls_content_data-count NO-GAPS.

        CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_stagingcontent.

        ASSIGN er_data->* TO FIELD-SYMBOL(<er_data>).

        <er_data> = ls_content_data.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).
        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD handle_get_value_help_value.

    DATA: ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_getvaluehelpvalue.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter ).

    DATA(lo_mc_value_help_factory) = NEW /ltb/cl_mc_value_help_factory( ).

    DATA(lo_value_help_srv) = lo_mc_value_help_factory->/ltb/if_mc_value_help_factory~get_value_help_srv( iv_value_help_type = ls_parameter-valuehelptype
                                                                                                          iv_value_help_name = ls_parameter-valuehelpname ).
    er_data = lo_value_help_srv->get_values( iv_cond = ls_parameter-searchcondition
                                             iv_maxhit = ls_parameter-maxhit
                                             iv_sort_string = ls_parameter-sortstring
                                             iv_skip = conv #( ls_parameter-pageskip )
                                             iv_top = conv #( ls_parameter-pagetop )  ).

  ENDMETHOD.


  METHOD handle_insmesdetailral.
    DATA: ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_messagedetailral.
    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).
*  this is dummy method only for RAL logging of downloading instance message detail

    es_downloaddetail-migrationobjectuuid = ls_parameter-migrationobjectuuid.
    es_downloaddetail-migrationprojectuuid = ls_parameter-migrationprojectuuid.
    es_downloaddetail-messagegroupuuid = ls_parameter-messagegroupuuid.
  ENDMETHOD.


  METHOD handle_messageoverdetailral.
    DATA: ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_messagedetailral.
    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).
*  this is dummy method only for RAL logging of downloading message overview detail
    es_downloadmessageoverview-migrationinstanceuuid = ls_parameter-migrationinstanceuuid .
    es_downloadmessageoverview-migrationobjectuuid = ls_parameter-migrationobjectuuid.
    es_downloadmessageoverview-migrationprojectuuid = ls_parameter-migrationprojectuuid.
    es_downloadmessageoverview-displayoption = ls_parameter-displayoption.
    es_downloadmessageoverview-messagegroupuuid = ls_parameter-messagegroupuuid.
    es_downloadmessageoverview-messageuuid = ls_parameter-messageuuid.
  ENDMETHOD.


  METHOD HANDLE_OBJECTMESSAGES.

  DATA: ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectmessage.
    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).
*  this is dummy method only for RAL logging of object message

    es_migrationobjectmessage-migrationobjectuuid = ls_parameter-migrationobjectuuid.
    es_migrationobjectmessage-migrationprojectuuid = ls_parameter-migrationprojectuuid.

  ENDMETHOD.


  METHOD handle_set_jobs.

    DATA: ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_setjobs.
    DATA: lt_mo_num TYPE /ltb/if_mc_constants=>gtt_migobj_job_num.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.


    /ui2/cl_json=>deserialize( EXPORTING json        = ls_parameter-migrationobjectsjobs
                                         pretty_name = /ui2/cl_json=>pretty_mode-low_case
                               CHANGING  data        = lt_mo_num ).

    DATA(lt_return) = lo_project_proxy->set_job_settings( iv_proj_num = ls_parameter-numbackgroundjob
                                                          it_mo_num   = lt_mo_num ).

    IF lt_return IS NOT INITIAL.
      raise_bussiness_exception(
        EXPORTING
          iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
          it_message           = lt_return
      ).
    ENDIF.


  ENDMETHOD.


  METHOD handle_update_custom_fields.
    DATA: ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_updatecustomfields.
    FIELD-SYMBOLS: <fs_processresult> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.
    ASSIGN er_data->* TO <fs_processresult>.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).
        <fs_processresult>-returncode = lo_object_proxy->update_custom_fields( ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).
        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD import_task_value.

    DATA:
      ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
      ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_importtaskvalue,
      lt_import_opt         TYPE /ltb/if_mc_constants=>gtt_task_import_opt.

    FIELD-SYMBOLS:
      <fs_taskproc>   TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskprocessing.

    LOOP AT it_changeset_request ASSIGNING FIELD-SYMBOL(<fs_request>).
      CAST /iwbep/if_mgw_req_func_import( <fs_request>-request_context )->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
      ).

      INSERT INITIAL LINE INTO TABLE lt_import_opt ASSIGNING FIELD-SYMBOL(<import_opt>).

      <import_opt>-proj_uuid   = ls_parameter-migrationprojectuuid.
      <import_opt>-task_uuid   = ls_parameter-taskuuid.
      <import_opt>-confirm_opt = ls_parameter-confirmopt.
      <import_opt>-load_opt    = ls_parameter-loadopt.

      CREATE DATA ls_changeset_response-entity_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskprocessing.
      ASSIGN ls_changeset_response-entity_data->* TO <fs_taskproc>.

      <fs_taskproc>-migrationprojectuuid = ls_parameter-migrationprojectuuid.
      <fs_taskproc>-taskuuid = ls_parameter-taskuuid.

      ls_changeset_response-operation_no = <fs_request>-operation_no.
      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).

        DATA(lo_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).

        lo_ctx->add_value_ref(
          EXPORTING
            iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-task_import_option
            ir_value = REF #( lt_import_opt )
        ).

        lo_project_proxy->schedule_taskval_transfer( lo_ctx ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).
        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.


  ENDMETHOD.


  METHOD indprocesslanese_get_entityset.
    DATA ls_indprocesslane TYPE /ltb/cl_mig_mc_odata_mpc=>ts_indprocesslane. "ts_migrationproject,
    DATA lo_contx          TYPE REF TO /ltb/cl_mc_cntxt_query.
    DATA lv_project_uuid TYPE /ltb/mc_proj_uuid.
    DATA lt_mc_messages TYPE cnv_mbt_t_bal_s_msg.

    CLEAR es_response_context.
    CLEAR et_entityset.

    io_tech_request_context->get_converted_source_keys( IMPORTING es_key_values = ls_indprocesslane ).

    TRY.
        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        "bind message container
        DATA(lo_msg_container) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
        lo_cntxt_proj->set_msg_container( NEW /ltb/cl_mc_msg_cont_iwbep_adap( lo_msg_container ) ).
        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_indprocesslane-migrationprojectuuid ).

        " set query context: paging, full search, order, filter
        lo_contx = lo_cntxt_proj.
        set_context( iv_entity_set_name = iv_entity_set_name
            is_paging = is_paging
            iv_search_string = iv_search_string
            it_order = it_order
            it_filter_select_options = it_filter_select_options
            io_context = lo_contx ).

        DATA(lo_object_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( ls_indprocesslane-migrationobjectuuid ).

        DATA(lt_indprocess_lane) = lo_object_proxy->get_indprocess_lane( io_cntxt = lo_cntxt_proj  ).
        LOOP AT lt_indprocess_lane INTO DATA(ls_indprocess_lane).
          READ TABLE et_entityset WITH KEY position = ls_indprocess_lane-position INTO DATA(ls_entityset).
          IF sy-subrc <> 0.
            MOVE-CORRESPONDING ls_indprocess_lane TO ls_entityset.
            ls_entityset-nodeid = ls_entityset-position.
            CONDENSE ls_entityset-nodeid.
            DATA(lv_step) = ls_indprocess_lane-step.
            SHIFT lv_step LEFT DELETING LEADING '0'.
            REPLACE '&' IN ls_entityset-label WITH lv_step.
            APPEND ls_entityset TO et_entityset.
          ENDIF.
        ENDLOOP.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        lt_mc_messages = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
                       ).
    ENDTRY.

  ENDMETHOD.


  METHOD indprocessselset_get_entityset.
    DATA ls_indprocess_sel TYPE /ltb/cl_mig_mc_odata_mpc=>ts_indprocesssel. "ts_migrationproject,
    DATA lo_contx          TYPE REF TO /ltb/cl_mc_cntxt_query.
    DATA lt_filter TYPE /ltb/if_mc_constants=>gtt_filter_cond.
    DATA ls_filter TYPE /ltb/if_mc_constants=>gty_filter_cond.
    DATA ls_entityset TYPE /ltb/cl_mig_mc_odata_mpc=>ts_indprocesssel.
    DATA lt_mc_messages TYPE cnv_mbt_t_bal_s_msg.

    CLEAR es_response_context.
    CLEAR et_entityset.

    io_tech_request_context->get_converted_source_keys( IMPORTING es_key_values = ls_indprocess_sel ).

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<lfs_filter_select_options>).

      lt_filter = VALUE #( BASE lt_filter
                           FOR <fs_select_options> IN <lfs_filter_select_options>-select_options
                           ( field = <lfs_filter_select_options>-property
                              sign  = <fs_select_options>-sign
                              oper  = <fs_select_options>-option
                              low   = <fs_select_options>-low
                              high  = <fs_select_options>-high
                            )
                          ).
    ENDLOOP.

    TRY.
        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        "bind message container
        DATA(lo_msg_container) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
        lo_cntxt_proj->set_msg_container( NEW /ltb/cl_mc_msg_cont_iwbep_adap( lo_msg_container ) ).
        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_indprocess_sel-migrationprojectuuid ).

        " set query context: paging, full search, order, filter
        lo_contx = lo_cntxt_proj.
        set_context( iv_entity_set_name = iv_entity_set_name
            is_paging = is_paging
            iv_search_string = iv_search_string
            it_order = it_order
            it_filter_select_options = it_filter_select_options
            io_context = lo_contx ).
        IF lt_filter IS NOT INITIAL.
          lo_contx->set_filter_cond( lt_filter ).
        ENDIF.

        DATA(lo_object_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( ls_indprocess_sel-migrationobjectuuid ).
        DATA(lt_indprocess_sel) = lo_object_proxy->get_indprocess_sel( io_cntxt = lo_cntxt_proj  ).
        LOOP AT lt_indprocess_sel INTO ls_indprocess_sel.
          MOVE-CORRESPONDING ls_indprocess_sel TO ls_entityset.
          IF ls_entityset-itemaction = /ltb/if_mc_constants=>gc_item_action-prepared.
            ls_entityset-itemaction = /ltb/if_mc_constants=>gc_bulk_action-prepare.
          ENDIF.
          APPEND ls_entityset TO et_entityset.
        ENDLOOP.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        lt_mc_messages = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
            ).
    ENDTRY.
  ENDMETHOD.


  METHOD indprocessset_get_entityset.
    DATA ls_indprocess TYPE /ltb/cl_mig_mc_odata_mpc=>ts_indprocess. "ts_migrationproject,
    DATA lo_contx      TYPE REF TO /ltb/cl_mc_cntxt_query.
    DATA lt_mc_messages TYPE cnv_mbt_t_bal_s_msg.
    CLEAR es_response_context.
    CLEAR et_entityset.

    io_tech_request_context->get_converted_source_keys( IMPORTING es_key_values = ls_indprocess ).

    TRY.
        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        "bind message container
        DATA(lo_msg_container) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
        lo_cntxt_proj->set_msg_container( NEW /ltb/cl_mc_msg_cont_iwbep_adap( lo_msg_container ) ).
        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_indprocess-migrationprojectuuid ).

        " set query context: paging, full search, order, filter
        lo_contx = lo_cntxt_proj.
        set_context( iv_entity_set_name = iv_entity_set_name
            is_paging = is_paging
            iv_search_string = iv_search_string
            it_order = it_order
            it_filter_select_options = it_filter_select_options
            io_context = lo_contx ).

        DATA(lo_object_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( ls_indprocess-migrationobjectuuid ).
        DATA(lt_indprocess) = lo_object_proxy->get_indprocess( io_cntxt = lo_cntxt_proj  ).
        MOVE-CORRESPONDING lt_indprocess TO et_entityset.
        LOOP AT et_entityset ASSIGNING FIELD-SYMBOL(<ls_entityset>).
          SHIFT <ls_entityset>-step LEFT DELETING LEADING '0'.
        ENDLOOP.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        lt_mc_messages = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
            ).
    ENDTRY.

  ENDMETHOD.


  METHOD instance_bulk_process.
    DATA ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_instancebulkprocess.
    DATA lt_filter    TYPE /ltb/if_mc_constants=>tt_sel.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).
        DATA(lo_obj_ctx)       = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        lo_obj_ctx->set_bulk_proc_action( CONV #( ls_parameter-action ) ).

        /ui2/cl_json=>deserialize( EXPORTING json        = ls_parameter-filter
                                             pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                   CHANGING  data        = lt_filter ).

        lo_obj_ctx->set_bulk_proc_filter( lt_filter ).

        lo_obj_ctx->set_bulk_proc_actionstatus( ls_parameter-actionstatus ).

        lo_obj_ctx->set_transfer_type( /ltb/if_mc_constants=>gc_transfer_type-bulk_proc ).

        IF ls_parameter-action = /ltb/if_mc_constants=>gc_bulk_action-migrate_next.
          lo_obj_ctx->set_single_step( abap_true ).
        ELSE.
          lo_obj_ctx->set_single_step( abap_false ).
        ENDIF.

        lo_object_proxy->execute_bulk_action( lo_obj_ctx ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD instance_ind_process.
    DATA ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_indprocessaction.
    DATA lt_action_status TYPE /ltb/if_mc_constants=>gtt_action_status.
    DATA lt_filter  TYPE /ltb/if_mc_constants=>gtt_filter_cond.
    FIELD-SYMBOLS:
      <er_data> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.

    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).
        DATA(lo_obj_ctx)       = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        lo_obj_ctx->set_bulk_proc_action( CONV #( ls_parameter-action ) ).
        lo_obj_ctx->set_transfer_type( /ltb/if_mc_constants=>gc_transfer_type-bulk_proc ).

        /ui2/cl_json=>deserialize( EXPORTING json        = ls_parameter-actionstatus
                                             pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                   CHANGING  data        = lt_action_status ).

*        IF ls_parameter-optionid IS NOT INITIAL.
*          lt_filter = VALUE #( BASE lt_filter
*                ( field = 'OPTIONID'
*                  sign  = 'I'
*                  oper  = 'EQ'
*                  low   = ls_parameter-optionid
*                  high  = '' ) ).
*        ENDIF.
*        IF ls_parameter-step IS NOT INITIAL.
*          lt_filter = VALUE #( BASE lt_filter
*                ( field = 'STEP'
*                  sign  = 'I'
*                  oper  = 'EQ'
*                  low   = ls_parameter-step
*                  high  = '' ) ).
*        ENDIF.

        IF lt_filter IS NOT INITIAL.
          lo_obj_ctx->set_filter_cond( lt_filter ).
        ENDIF.

        IF lt_action_status IS NOT INITIAL.
          lo_obj_ctx->set_action_status( lt_action_status ).
        ENDIF.

        lo_obj_ctx->set_single_step( abap_true ).

        lo_object_proxy->execute_ind_processing( lo_obj_ctx ).

        CREATE DATA er_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.
        ASSIGN er_data->* TO <er_data>.
        <er_data>-returncode = 'X'.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD instance_reset_status.
    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_resetstatus,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          lt_instancedata       TYPE TABLE OF string,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationinstance,
          lo_stag_obj           TYPE REF TO /ltb/cl_mc_obj_proxy_mwb_stag,
          lv_object_guid        TYPE /ltb/mc_object_uuid,
          lv_project_guid       TYPE /ltb/mc_proj_uuid,
          lv_has_error          TYPE boolean VALUE abap_false,
          ls_message            TYPE bal_s_msg,
          lo_job_facade         TYPE REF TO if_dmc_sin_job_facade,
          index                 TYPE i.
    FIELD-SYMBOLS: <fs_itemdata>   TYPE any,
                   <fv_fieldvalue> TYPE any,
                   <fv_itemfield>  TYPE any,
                   <fs_entity>     TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationinstance.
    CONSTANTS:
      lco_fieldcount       TYPE i       VALUE 14,
      gc_controller_job    TYPE dmc_uniform_name_acronym VALUE 'CTRL',
      lco_fieldname_prefix TYPE string  VALUE 'ITEMFIELD'.
    "batch job
    "insert all instance data into a inner table
    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
       ).
      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      CLEAR ls_message.

      CREATE DATA ls_changeset_response-entity_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationinstance.
      ASSIGN ls_changeset_response-entity_data->* TO <fs_entity>.

      <fs_entity>-migrationprojectuuid = ls_parameter-migrationprojectuuid.
      <fs_entity>-migrationobjectuuid = ls_parameter-migrationobjectuuid.

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.
      APPEND ls_changeset_response TO ct_changeset_response.

      lv_project_guid = ls_parameter-migrationprojectuuid.
      lv_object_guid = ls_parameter-migrationobjectuuid.
      APPEND ls_parameter-migrationinstancedata TO lt_instancedata.
    ENDLOOP.
    "all request are under the same project and object. only one lo_stag_obj is needed
    TRY .
        CLEAR lo_stag_obj.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_guid ).
        lo_stag_obj ?= lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = lv_object_guid ).
        DATA(lo_obj_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_object_guid ).
        DATA(ls_obj_detail) = lo_object_proxy->get_details( lo_obj_context ).

        lo_stag_obj->reset_status(
        EXPORTING
          io_cntxt = lo_obj_context
          it_instancedata = lt_instancedata
          is_return_needed = abap_true
        IMPORTING
          et_data = DATA(lt_data) ).
        LOOP AT lt_data INTO DATA(ls_itemlist_data).
*       Project UUID
          ls_entity-migrationprojectuuid       = lv_project_guid.
*       Object UUID
          ls_entity-migrationobjectuuid        = lv_object_guid.
*       Instatnce ID
          ls_entity-migrationinstanceuuid      = ls_itemlist_data-item_uuid.
*       MO name
          ls_entity-migrationobjectname        = ls_obj_detail-migobj_descr.
*       MO descr
          ls_entity-migrationobjectdescr       = ls_obj_detail-migobj_doc_descr.
*       Status
          ls_entity-migrationinstancestatus    = ls_itemlist_data-item_status.
*       Status description
          ls_entity-statusdescription          = ls_itemlist_data-item_status_desc.
*       Action
          ls_entity-action                     = ls_itemlist_data-item_action. "Action
*       Action description
          ls_entity-actiondescription          = ls_itemlist_data-item_action_desc.
*       Instance Title
          ls_entity-instancetitle              = ls_itemlist_data-item_name.
*       Group Indicator
          ls_entity-groupindicator             = ls_itemlist_data-item_group_indicator.
          ASSIGN ls_itemlist_data-item_data->* TO <fs_itemdata>.
          IF sy-subrc = 0.
            DO lco_fieldcount TIMES.
              DATA(lv_fieldname) = lco_fieldname_prefix && sy-index.

              ASSIGN COMPONENT lv_fieldname OF STRUCTURE ls_entity TO <fv_itemfield>.
              IF sy-subrc = 0.
                ASSIGN COMPONENT sy-index OF STRUCTURE <fs_itemdata> TO <fv_fieldvalue>.
                IF sy-subrc = 0.
                  <fv_itemfield> = CONV #( <fv_fieldvalue> ).
                ENDIF.
              ENDIF.
            ENDDO.
          ENDIF.
        ENDLOOP.
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_static_exception).
        lv_has_error = abap_true.
        LOOP AT lo_static_exception->get_messages( ) INTO ls_message ##INTO_OK.
          ls_changeset_request = it_changeset_request[ operation_no = ls_changeset_request-operation_no ].
          ls_changeset_request-msg_container->add_message(
            EXPORTING
              iv_msg_type   = ls_message-msgty
              iv_msg_id     = ls_message-msgid
              iv_msg_number = ls_message-msgno
              iv_msg_v1     = ls_message-msgv1
              iv_msg_v2     = ls_message-msgv2
              iv_msg_v3     = ls_message-msgv3
              iv_msg_v4     = ls_message-msgv4
              iv_add_to_response_header = abap_true
              ).
        ENDLOOP.
    ENDTRY.
*Give a successful message if nothing wrong happens
    IF lv_has_error = abap_false.
      IF 1 = 0.
        "Status of selected records reset to unprocessed
        MESSAGE i109(/ltb/mc).
      ENDIF.
      ls_changeset_request = it_changeset_request[ 1 ].
      ls_changeset_request-msg_container->add_message(
        EXPORTING
          iv_msg_type   = 'I'
          iv_msg_id     = '/LTB/MC'
          iv_msg_number = '109'
          iv_add_to_response_header = abap_true
          ).
    ENDIF.
  ENDMETHOD.


  METHOD is_copy_mo_running.
    "Check if COPY_MO lock exists
    cl_cnv_pe_mc_factory=>get_mc_lock( )->check_lock_exists(
      EXPORTING
        iv_owner_id = iv_proj_uuid
        iv_lock_ident1 = if_cnv_pe_mc_lock=>gc_lock_ident-copy_mo
        iv_passed_ident_only = abap_true
      IMPORTING
        ev_locked = DATA(lv_locked) ).
    IF lv_locked = abap_true.
      rv_running = abap_true.
      RETURN.
    ENDIF.

    "Check if COPY_MOS action is running
    IF cl_cnv_pe_jf_factory=>get_helper( )->is_action_running(
         iv_action   =  cl_cnv_pe_jf_constants=>gc_action-copy_mos
         iv_owner_id =  iv_proj_uuid ) = abap_true.
      rv_running = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD is_csv_or_xml.

    rv_ret = /ltb/if_mc_constants=>gc_fileproc-category-xml.

    DATA(lo_zip) = NEW cl_abap_zip( ).

    lo_zip->support_unicode_names = abap_true.

    lo_zip->load(
      EXPORTING
        zip             = iv_data
      EXCEPTIONS
        zip_parse_error = 1
        OTHERS          = 2
    ).

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CLEAR rv_ret.
    LOOP AT lo_zip->files ASSIGNING FIELD-SYMBOL(<fs_file>) WHERE size > 0.
      DATA(l_offset) = strlen( <fs_file>-name ) - 4.
      DATA(l_extension_name) = to_lower( <fs_file>-name+l_offset(4) ).

      IF l_extension_name <> /ltb/if_mc_constants=>gc_filename_ext-xml AND
         l_extension_name <> /ltb/if_mc_constants=>gc_filename_ext-csv.
        rv_ret = /ltb/if_mc_constants=>gc_fileproc-category-xml.
        RETURN.
      ELSEIF l_extension_name = /ltb/if_mc_constants=>gc_filename_ext-xml.
        rv_ret = /ltb/if_mc_constants=>gc_fileproc-category-xml.
        RETURN.
      ELSEIF l_extension_name = /ltb/if_mc_constants=>gc_filename_ext-csv.
        rv_ret = /ltb/if_mc_constants=>gc_fileproc-category-csv.
      ENDIF.
    ENDLOOP.

    IF rv_ret IS INITIAL. "Empty zip
      rv_ret = /ltb/if_mc_constants=>gc_fileproc-category-xml.
    ENDIF.

  ENDMETHOD.


  method IS_DBCON_LOST.
    DATA lo_con_ref TYPE REF TO cl_sql_connection.

    TRY.
        lo_con_ref = cl_sql_connection=>get_connection( iv_dbcon_name ).
        lo_con_ref->close( ).
      CATCH cx_sql_exception.
        rv_is_lost = abap_true.
        RETURN.
    ENDTRY.

    rv_is_lost = abap_false.

  endmethod.


  METHOD is_delete_proj_running.
    "Check if delete project lock exists
    IF check_delete_lock( iv_proj_uuid ) = abap_true.
      rv_running = abap_true.
      RETURN.
    ENDIF.
    "Check if delete project action is running
    IF cl_cnv_pe_jf_factory=>get_helper( )->is_action_running(
         iv_action   =  cl_cnv_pe_jf_constants=>gc_action-delproj
         iv_owner_id =  iv_proj_uuid ) = abap_true.
      rv_running = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD is_elementary_search_help.

    DATA lo_shlp_facade       TYPE REF TO /iwbep/if_sbdsp_shlp_facade.
    DATA ls_shlp_descr        TYPE shlp_descr.

    CREATE OBJECT lo_shlp_facade TYPE /iwbep/cl_sbdsp_shlp_facade.

    lo_shlp_facade->get_shlp_properties(
       EXPORTING
         iv_shlp_name = iv_shlp_name
       IMPORTING
         es_shlp      = ls_shlp_descr ).

    IF ls_shlp_descr-intdescr-issimple = abap_true.
      rv_is_elem_shlp = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD is_load_object_required.
    TRY.
        DATA(lv_load_required) = cl_cnv_pe_service=>is_load_required( ).
      CATCH cx_cnv_pe_generic.
        "It can happen that no import information is yet available
        "In this case lv_load_required will be abap_true.
        "A fixed time stamp is written in current client when load of template objects is processed
        "to avoid cancellation in case no import timestamp was written yet.
    ENDTRY.

    IF lv_load_required EQ abap_true.
      "configuration update required
      IF cl_cnv_pe_factory=>get_act_ctrl( )->is_load_required_ignored( ) EQ abap_false.
        "system/client settings are not allowing to move on (default)
        rv_is_required = abap_true.
      ELSE.
        "system/client settings are set to ignore it
        rv_is_required = abap_false.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD is_migration_file_transferred.

    DATA:
      ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
      ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_isbundletransferred,
      ls_return             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_processresult.

    LOOP AT it_changeset_request ASSIGNING FIELD-SYMBOL(<fs_request>).
      CAST /iwbep/if_mgw_req_func_import( <fs_request>-request_context )->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
      ).

      TRY.
          DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
          DATA(lo_object_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).
          DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( ls_parameter-migrationfileuuid ) ).
*
          ls_return-returncode = lo_file_proxy->is_imported( ).

        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
          DATA(lt_messages) = lx_exception->get_messages( ).

          IF lt_messages IS INITIAL.
            APPEND VALUE #( msgty = 'E'
                            msgid = lx_exception->if_t100_message~t100key-msgid
                            msgno = lx_exception->if_t100_message~t100key-msgno
                            msgv1 = lx_exception->msgv1
                            msgv2 = lx_exception->msgv2
                            msgv3 = lx_exception->msgv3
                            msgv4 = lx_exception->msgv4 ) TO lt_messages.

          ENDIF.

          LOOP AT lt_messages INTO DATA(ls_message).
            <fs_request>-msg_container->add_message(
              EXPORTING
                iv_msg_type   = ls_message-msgty
                iv_msg_id     = ls_message-msgid
                iv_msg_number = ls_message-msgno
                iv_msg_v1     = ls_message-msgv1
                iv_msg_v2     = ls_message-msgv2
                iv_msg_v3     = ls_message-msgv3
                iv_msg_v4     = ls_message-msgv4
                iv_add_to_response_header = abap_true ).
          ENDLOOP.
      ENDTRY.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_return
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).

      ls_changeset_response-operation_no = <fs_request>-operation_no.
      APPEND ls_changeset_response TO ct_changeset_response.
      CLEAR: ls_changeset_response.
    ENDLOOP.

  ENDMETHOD.


  METHOD is_rfc_available.

    DATA lv_trusted_rfc TYPE rfcdisplay-rfcslogin.
    DATA lv_conn_state  TYPE cnv_mbt_conn_state.
    DATA lv_rfc         TYPE rfcdest.

    DATA(lo_com_utils) = cl_cnv_pe_factory=>get_com_utils( ).
    IF lo_com_utils->is_ca_config_required( ) EQ abap_true.
      DATA(lt_ca) = lo_com_utils->get_all_registered_ca_0816( ).
*      READ TABLE lt_ca ASSIGNING FIELD-SYMBOL(<ls_ca>) WITH KEY ca_uuid = iv_connectionuuid.
      READ TABLE lt_ca ASSIGNING FIELD-SYMBOL(<ls_ca>) WITH KEY ca_name = iv_connection.
      IF sy-subrc EQ 0.
        lv_rfc = <ls_ca>-rfcdest.
      ELSE.
        "Not possible, it has been checked when enter connection
        RETURN.
      ENDIF.
    ELSE.
      lv_rfc = iv_connection.
    ENDIF.

    "Destination NONE is always available
    CHECK lv_rfc NE 'NONE'.

    "Check if connection is a "trusted RFC"
    CALL FUNCTION 'RFC_READ_R3_DESTINATION'
      EXPORTING
        destination             = lv_rfc
        authority_check         = abap_false
        bypass_buf              = abap_false
      IMPORTING
        trusted_system          = lv_trusted_rfc
      EXCEPTIONS
        authority_not_available = 1
        destination_not_exist   = 2
        information_failure     = 3
        internal_failure        = 4
        OTHERS                  = 5.

    IF lv_trusted_rfc = abap_true.
      rv_rfc_invalid = /ltb/if_mc_constants=>gc_rfc_invalid-trusted_rfc.
      RETURN.
    ENDIF.

    "Check if RFC connection works
    CALL FUNCTION 'CNV_MBT_RFC_CONNECTION_CHECK'
      EXPORTING
        ip_dest                      = lv_rfc
        ip_refresh                   = 'X'
      CHANGING
        ep_conn_state_set            = lv_conn_state
      EXCEPTIONS
        connection_failed            = 1
        name_or_password_incorrect   = 2
        connection_check_not_allowed = 3
        OTHERS                       = 4.
    IF sy-subrc <> 0
      OR ( lv_conn_state NE ' '
           AND lv_conn_state NE 'O' ).
      rv_rfc_invalid = /ltb/if_mc_constants=>gc_rfc_invalid-connection_loss.
    ENDIF.

  ENDMETHOD.


  METHOD is_system_upgrade.
    rv_is_upgrade = /ltb/cl_ext_cls_factory=>get_upgrade_proxy( )->is_upgrade_running( ).
  ENDMETHOD.


  METHOD itemcolumnsset_get_entityset.

    DATA: lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid,
          ls_key_pair  TYPE /iwbep/s_mgw_name_value_pair.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobject AND
       iv_entity_name = /ltb/cl_mig_mc_odata_mpc=>gc_itemcolumns.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

*       Get Itemlist structure.
          lo_obj_ctx->set_field_num( 14 ).

          DATA(lt_itemlist_metadata) = lo_object_proxy->get_itemlist_metadata( lo_obj_ctx ).

          "Delete the RESULTXXKEYXX lines
          DELETE lt_itemlist_metadata WHERE result_type = /ltb/if_mc_constants=>gc_result_type-key_field
                                         OR result_type = /ltb/if_mc_constants=>gc_result_type-value_field
                                         OR result_type = /ltb/if_mc_constants=>gc_result_type-descr_field
                                         OR result_type = /ltb/if_mc_constants=>gc_result_type-valid_field
                                         OR result_type = /ltb/if_mc_constants=>gc_result_type-time_field
                                         OR result_type = /ltb/if_mc_constants=>gc_result_type-user_field
                                         OR result_type = /ltb/if_mc_constants=>gc_result_type-step_seq_field.

          et_entityset = VALUE #( FOR ls_itemlist_metadata IN lt_itemlist_metadata
                                  ( fieldname            = ls_itemlist_metadata-fieldname
                                    iskey                = ls_itemlist_metadata-is_key
                                    datatype             = ls_itemlist_metadata-datatype
                                    displayorder         = ls_itemlist_metadata-position
                                    fieldlabel           = ls_itemlist_metadata-description
                                    displayoption        = SWITCH #( ls_itemlist_metadata-result_type WHEN '' THEN 'S'
                                                                                                      ELSE  'R' )
                                    migrationprojectuuid = lv_proj_uuid
                                    migrationobjectuuid  = lv_obj_uuid ) ).
        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD maintain_project.

    DATA: ls_changeset_request  TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_request,
          ls_project            TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationproject,
          ls_object             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationtemplateobject,
          ls_company            TYPE /ltb/cl_mig_mc_odata_mpc=>ts_companiesinmigrationproject,
          ls_filter             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_filtersinmigrationproject,
          lo_update_context     TYPE REF TO /iwbep/if_mgw_req_entity_u,
          lv_entity             TYPE /iwbep/mgw_tech_name,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          lt_mo                 TYPE /ltb/mc_t_object_uuid,
          ls_mo                 TYPE /ltb/mc_object_uuid,
          lt_bukrs              TYPE /ltb/mc_t_bukrs,
          lt_filter_values      TYPE /ltb/if_mc_constants=>gtt_filter_value,
          ls_filter_value       TYPE /ltb/if_mc_constants=>gty_filter_value,
          ls_bukrs              TYPE LINE OF /ltb/mc_t_bukrs,
          lv_only_hidden        TYPE /ltb/mc_scenario_hidden,
          ls_msg                TYPE bal_s_msg,
          lv_message            TYPE string,
          lv_copy               TYPE abap_bool.

    TRY.
        DATA(lo_proj_cntxt) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        DATA(lo_msg_container) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
        lo_proj_cntxt->set_msg_container( NEW /ltb/cl_mc_msg_cont_iwbep_adap( lo_msg_container ) ).

        CLEAR lv_copy.
        "because header is not in the first line item, find it via loop
        LOOP AT it_changeset_request INTO ls_changeset_request ##INTO_OK.
          "response
          CLEAR ls_changeset_response.
          ls_changeset_response-operation_no = ls_changeset_request-operation_no.

          lo_update_context ?= ls_changeset_request-request_context.
          lv_entity = lo_update_context->get_entity_type_name( ).

          IF lv_entity = /ltb/cl_mig_mc_odata_mpc=>gc_migrationproject.
            ls_changeset_request-entry_provider->read_entry_data( IMPORTING es_data = ls_project ).

            IF iv_case = co_action_create_proj
              AND ls_project-migrationprojecttempid IS NOT INITIAL."Copy Project
              TRY.
                  DATA(lo_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_project-migrationprojecttempid ) ).
                  lv_copy = abap_true.
                CATCH /ltb/cx_mc_proxy_error.
                  CLEAR lv_copy.
              ENDTRY.
            ENDIF.
            "project uuid
            lo_proj_cntxt->set_proj_uuid( ls_project-migrationprojectuuid ).

            "MTID for MWB project
            IF ls_project-migrationprojectmtid IS NOT INITIAL.
              lo_proj_cntxt->set_mtid( CONV #( ls_project-migrationprojectmtid ) ).
              "view for MWB project
              lo_proj_cntxt->set_proj_view( ls_project-activeviewname ).
            ENDIF.
            "project description
            lo_proj_cntxt->set_proj_name( CONV #( ls_project-migrationprojectname ) ).

            "approach
            lo_proj_cntxt->set_approach( ls_project-migrationapproachuuid ).

            "dev class
            lo_proj_cntxt->set_dev_class( ls_project-developmentclass ).

            "scenario
            IF ls_project-migrationscenariouuid IS INITIAL.
              " when only one scenario is available. UI won't transfer any value for scenario
              lv_only_hidden = COND /ltb/mc_scenario_hidden(
              WHEN /ltb/cl_ext_cls_factory=>get_cos_utilities( )->is_cloud( )
                THEN 'C'  "Hidden for Cloud only
              ELSE 'O'    "Hidden for On-Premise only
            ).

              SELECT SINGLE scenario INTO @ls_project-migrationscenariouuid
                FROM /ltb/mc_apprscen
                WHERE approach = @ls_project-migrationapproachuuid
                AND ( hidden <> @abap_true OR hidden <> @lv_only_hidden ).

              IF ls_project-migrationscenariouuid IS INITIAL.
                ls_project-migrationscenariouuid = /ltb/if_mc_constants=>gc_scenario-default.
              ENDIF.
            ENDIF.
            lo_proj_cntxt->set_scenario( ls_project-migrationscenariouuid ).

            "connection
            lo_proj_cntxt->set_connection_name( ls_project-connectionname ).
            lo_proj_cntxt->set_connection_uuid( ls_project-connectionuuid ).

            lo_proj_cntxt->set_retention_days( ls_project-retentiondays ).

            " Set response data
            copy_data_to_ref(
               EXPORTING
                 is_data = ls_project
               CHANGING
                 cr_data = ls_changeset_response-entity_data
                     ).

          ELSEIF lv_entity = /ltb/cl_mig_mc_odata_mpc=>gc_migrationtemplateobject.
            ls_changeset_request-entry_provider->read_entry_data( IMPORTING es_data = ls_object ).

            ls_mo = ls_object-migrationobjectuuid.
            INSERT ls_mo INTO TABLE lt_mo.

            " Set response data
            copy_data_to_ref(
               EXPORTING
                 is_data = ls_object
               CHANGING
                 cr_data = ls_changeset_response-entity_data
                     ).

          ELSEIF lv_entity = /ltb/cl_mig_mc_odata_mpc=>gc_companiesinmigrationproject.
            ls_changeset_request-entry_provider->read_entry_data( IMPORTING es_data = ls_company ).

            ls_bukrs = ls_company-companycode.
            INSERT ls_bukrs INTO TABLE lt_bukrs.

            lo_proj_cntxt->set_selected_bukrs( lt_bukrs ).

            " Set response data
            copy_data_to_ref(
               EXPORTING
                 is_data = ls_company
               CHANGING
                 cr_data = ls_changeset_response-entity_data
                     ).
          ELSEIF lv_entity = /ltb/cl_mig_mc_odata_mpc=>gc_filtersinmigrationproject.
            ls_changeset_request-entry_provider->read_entry_data( IMPORTING es_data = ls_filter ).
            ls_filter_value-name = ls_filter-name.
            ls_filter_value-value = ls_filter-value.
            ls_filter_value-descr = ls_filter-descr.
            INSERT ls_filter_value  INTO TABLE lt_filter_values.

            lo_proj_cntxt->set_selected_filter_values( lt_filter_values ).
            " Set response data
            copy_data_to_ref(
               EXPORTING
                 is_data = ls_filter
               CHANGING
                 cr_data = ls_changeset_response-entity_data
                     ).

          ENDIF.

          APPEND ls_changeset_response TO ct_changeset_response.
        ENDLOOP.


        lo_proj_cntxt->set_selected_migration_obj( lt_mo ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        DATA(lt_mc_messages) = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    TRY.
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).

        CASE iv_case.
          WHEN co_action_create_proj.
            check_projname_availability( iv_projname = CONV #( ls_project-migrationprojectname ) ).
            IF lv_copy = abap_true.
              DATA(lo_proj_proxy) = lo_appl_proxy->get_proj_proxy_by_uuid( CONV #( ls_project-migrationprojecttempid ) ).
              lo_proj_proxy->copy_proj( lo_proj_cntxt ).
            ELSE.
              lo_appl_proxy->new_proj( lo_proj_cntxt ).
            ENDIF.
          WHEN co_action_update_proj.
            "for project update
            lo_proj_cntxt->set_num_job( ls_project-numbackgroundjob ).
            lo_proj_proxy = lo_appl_proxy->get_proj_proxy_by_uuid( ls_project-migrationprojectuuid ).
            DATA(ls_proj_detail) = lo_proj_proxy->get_proj_details( io_cntxt = lo_proj_cntxt ).
            " project name is updated
            IF ls_proj_detail-proj_descr <> ls_project-migrationprojectname.
              check_projname_availability( iv_projname = CONV #( ls_project-migrationprojectname ) ).
            ENDIF.
            lo_proj_cntxt->set_proj_status( ls_proj_detail-proj_status ).
            TRY.
                lo_proj_proxy->change_proj( lo_proj_cntxt ).
              CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
                IF lx_proxy_error->if_t100_message~t100key = /ltb/cx_mc_proxy_error=>failed_to_set_remote_retention.
                  "Cannot set retention period for source system due to RFC connection error
                  MESSAGE w294(/ltb/mc) INTO lv_message.
                  MOVE-CORRESPONDING sy TO ls_msg.
                  ls_changeset_request = it_changeset_request[ 1 ].
                  ls_changeset_request-msg_container->add_message(
                    EXPORTING
                      iv_msg_type   = ls_msg-msgty
                      iv_msg_id     = ls_msg-msgid
                      iv_msg_number = ls_msg-msgno
                      iv_add_to_response_header = abap_true
                      ).
                ELSE.
                  RAISE EXCEPTION lx_proxy_error.
                ENDIF.
            ENDTRY.
        ENDCASE.

      CATCH /ltb/cx_mc_proxy_error INTO lx_proxy_error.

        lt_mc_messages = lx_proxy_error->get_messages( ).
        IF lt_mc_messages IS INITIAL.
           APPEND VALUE #( msgty = 'E'
                           msgid = lx_proxy_error->if_t100_message~t100key-msgid
                           msgno = lx_proxy_error->if_t100_message~t100key-msgno
                           msgv1 = lx_proxy_error->msgv1
                           msgv2 = lx_proxy_error->msgv2
                           msgv3 = lx_proxy_error->msgv3
                           msgv4 = lx_proxy_error->msgv4 ) TO lt_mc_messages.
        ENDIF.

        "convert project id to name.
        READ TABLE lt_mc_messages REFERENCE INTO DATA(ls_mc_messages) WITH KEY msgid = 'CNV_PE' msgno = '118'.
        IF sy-subrc = 0.
          ls_mc_messages->msgv4 = ls_proj_detail-proj_name.
        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO lx_cntxt_error.
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

    ENDTRY.

  ENDMETHOD.


  METHOD map_csv_file.
    DATA:
      ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
      ls_entity_key         TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectcsvfile,
      ls_entry_data         TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectcsvfile,
      ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectcsvfile,
      ls_return             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_returnmessage.

    LOOP AT it_changeset_request ASSIGNING FIELD-SYMBOL(<fs_request>).
      CAST /iwbep/if_mgw_req_entity_u( <fs_request>-request_context )->get_converted_keys(
        IMPORTING
          es_key_values = ls_entity_key  ).

      CAST /iwbep/if_mgw_entry_provider( <fs_request>-entry_provider )->read_entry_data(
        IMPORTING
          es_data = ls_entry_data   ).

      TRY.
          DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_entity_key-migrationprojectuuid ) ).
          DATA(lo_object_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( CONV #( ls_entity_key-migrationobjectuuid ) ).
          DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( ls_entity_key-migrationfileuuid ) ).

          DATA(lo_csv_bundle) = CAST /ltb/if_mc_csv_bundle( lo_file_proxy ).

          lo_csv_bundle->map_file(
            EXPORTING
              iv_file_uuid = CONV #( ls_entity_key-csvfileuuid )
              iv_struct    = CONV #( ls_entry_data-techid )
          ).

        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
          DATA(lt_messages) = lx_exception->get_messages( ).

          IF lt_messages IS INITIAL.
            APPEND VALUE #( msgty = 'E'
                            msgid = lx_exception->if_t100_message~t100key-msgid
                            msgno = lx_exception->if_t100_message~t100key-msgno
                            msgv1 = lx_exception->msgv1
                            msgv2 = lx_exception->msgv2
                            msgv3 = lx_exception->msgv3
                            msgv4 = lx_exception->msgv4 ) TO lt_messages.

          ENDIF.

          LOOP AT lt_messages INTO DATA(ls_message).
            <fs_request>-msg_container->add_message(
              EXPORTING
                iv_msg_type   = ls_message-msgty
                iv_msg_id     = ls_message-msgid
                iv_msg_number = ls_message-msgno
                iv_msg_v1     = ls_message-msgv1
                iv_msg_v2     = ls_message-msgv2
                iv_msg_v3     = ls_message-msgv3
                iv_msg_v4     = ls_message-msgv4
                iv_add_to_response_header = abap_true ).
          ENDLOOP.
      ENDTRY.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_return
        CHANGING
          cr_data = ls_changeset_response-entity_data ).

      ls_changeset_response-operation_no = <fs_request>-operation_no.
      APPEND ls_changeset_response TO ct_changeset_response.
      CLEAR: ls_changeset_response.
    ENDLOOP.

  ENDMETHOD.


  METHOD messagedetailset_get_entityset.

    DATA: lv_proj_uuid      TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid       TYPE /ltb/mc_object_uuid,
*        lv_instance_uuid  TYPE cnv_pe_wl_item_id,
          lv_instance_uuid  TYPE /ltb/if_mc_constants=>gty_item_uuid,
          lv_msg_group_uuid TYPE /ltb/if_mc_constants=>gty_msg_group_uuid,
          ls_key_pair       TYPE /iwbep/s_mgw_name_value_pair,
          ls_nav_path       TYPE /iwbep/s_mgw_navigation_path,
          lt_instance_uuid  TYPE /ltb/if_mc_constants=>gtt_item_uuid,
          lv_limit          TYPE int1,
          lv_offset         TYPE int4,
          lv_displayoption  TYPE string.
    CONSTANTS:
          lco_max_item_count TYPE int4 VALUE 255.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationinstance OR
       iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_messagegroup.
*   get project UUID
      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.

*   get object UUID
      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

*   get instance UUID
      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_instance_uuid.
      IF sy-subrc = 0.
        lv_instance_uuid = ls_key_pair-value.
      ENDIF.

*    Get display option(Group/Detail)
      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_message_display_option.
      IF sy-subrc = 0.
        lv_displayoption = ls_key_pair-value.
      ENDIF.

      IF lv_displayoption IS INITIAL.
        lv_displayoption = /ltb/if_mc_constants=>gc_message_display_option-group.
      ENDIF.

      IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationinstance.
        READ TABLE it_navigation_path INTO ls_nav_path WITH KEY nav_prop = 'to_MsgDetail'.
        IF sy-subrc = 0.
          READ TABLE ls_nav_path-key_tab INTO ls_key_pair WITH KEY name =  co_message_group_uuid.
          IF sy-subrc = 0.
            lv_msg_group_uuid = ls_key_pair-value.
          ENDIF.
        ENDIF.
      ELSEIF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_messagegroup.
        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_message_group_uuid.
        IF sy-subrc = 0.
          lv_msg_group_uuid = ls_key_pair-value.
        ENDIF.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

          lo_obj_ctx->set_item_uuid( EXPORTING iv_item_uuid = lv_instance_uuid ).

          DATA(ls_obj_detail) = lo_object_proxy->get_details( lo_obj_ctx ).

          APPEND lv_instance_uuid TO lt_instance_uuid.
          DATA(lo_message_proxy) = lo_object_proxy->get_message_group_by_uuid( iv_msg_group_uuid = lv_msg_group_uuid
                                                                               it_item_uuid      = lt_instance_uuid
                                                                               iv_displayoption  = lv_displayoption ).

          " set query context: paging, full search, order, filter
          set_context( iv_entity_set_name = iv_entity_set_name
            is_paging = is_paging
            iv_search_string = iv_search_string
            it_order = it_order
            io_context = lo_obj_ctx ).

          lo_message_proxy->get_message_details(
            EXPORTING
              io_cntxt = lo_obj_ctx
            IMPORTING
              et_msg_details = DATA(lt_message_details)
              ev_count = DATA(lv_count) ).

          DATA(ls_msg_group_detail) = lo_message_proxy->get_group_details( lo_obj_ctx ).

          et_entityset = VALUE #( FOR ls_message_detail IN lt_message_details
                                  ( migrationprojectuuid    = lv_proj_uuid
                                    migrationobjectuuid     = lv_obj_uuid
                                    migrationinstanceuuid   = lv_instance_uuid
                                    messagegroupuuid        = lv_msg_group_uuid
                                    displayoption           = lv_displayoption
                                    messagedetailuuid       = ls_message_detail-msg_uuid
                                    messagedetailtitle      = ls_message_detail-msg_title
                                    messagedetaildatetime   = convert_time_stamp( ls_message_detail-msg_datetime ) ##TYPE
                                    messagedetailtype       = ls_message_detail-msg_type
                                    typedescription         = get_status_desc( CONV #( ls_message_detail-msg_type ) )
                                    migrationobjectname     = ls_obj_detail-migobj_descr
                                    messagedetailv1         = ls_message_detail-msg_var1
                                    messagedetailv2         = ls_message_detail-msg_var2
                                    messagedetailv3         = ls_message_detail-msg_var3
                                    messagedetailv4         = ls_message_detail-msg_var4
                                    messageuuid             = ls_msg_group_detail-group_msgid
                                    messagenumber           = ls_msg_group_detail-group_msgno
                                    messagelongtext         = CONV #( get_longtext_from_msg( iv_msgid = ls_msg_group_detail-group_msgid
                                                                                             iv_msgno = ls_msg_group_detail-group_msgno
                                                                                             iv_msgv1 = ls_message_detail-msg_var1
                                                                                             iv_msgv2 = ls_message_detail-msg_var2
                                                                                             iv_msgv3 = ls_message_detail-msg_var3
                                                                                             iv_msgv4 = ls_message_detail-msg_var4 ) )
                                    ) ).

          IF io_tech_request_context->has_inlinecount( ) = abap_true.
            es_response_context-inlinecount = lv_count.
          ENDIF.

        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.

    ENDIF.
  ENDMETHOD.


  METHOD messagegroupover_get_entity.
    DATA: lv_proj_uuid     TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid      TYPE /ltb/mc_object_uuid,
          lv_displayoption TYPE string,
          lv_instance_uuid TYPE /ltb/if_mc_constants=>gty_item_uuid,
          ls_key_pair      TYPE /iwbep/s_mgw_name_value_pair,
          lt_order         TYPE /iwbep/t_mgw_sorting_order.

    CLEAR es_response_context.
    CLEAR er_entity.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
    IF sy-subrc = 0.
      lv_proj_uuid = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
    IF sy-subrc = 0.
      lv_obj_uuid = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_instance_uuid.
    IF sy-subrc = 0.
      lv_instance_uuid = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_message_display_option.
    IF sy-subrc = 0.
      lv_displayoption = ls_key_pair-value.
    ENDIF.

    IF lv_displayoption IS INITIAL.
      lv_displayoption = /ltb/if_mc_constants=>gc_message_display_option-group.
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

        lo_obj_ctx->set_item_uuid( EXPORTING iv_item_uuid = lv_instance_uuid ).

        "set flag to differentiate message group or message details
        IF lv_displayoption NE /ltb/if_mc_constants=>gc_message_display_option-detail.
          lo_obj_ctx->set_msggroup( iv_msg_group = abap_true ).
        ELSE.
          lo_obj_ctx->set_msggroup( iv_msg_group = abap_false ).
        ENDIF.

        DATA(ls_obj_detail) = lo_object_proxy->get_details( lo_obj_ctx ).

        lo_object_proxy->get_message_groups_count( EXPORTING io_cntxt         = lo_obj_ctx
                                                   IMPORTING ev_msg_count     = DATA(lv_esg_count)
                                                             ev_error_count   = DATA(lv_error_count)
                                                             ev_warning_count = DATA(lv_warning_count)
                                                             ev_success_count = DATA(lv_success_count)
                                                             ev_info_count    = DATA(lv_info_count) ).

        er_entity = VALUE #(
          migrationinstanceuuid = lv_instance_uuid
          migrationobjectuuid   = lv_obj_uuid
          migrationprojectuuid  = lv_proj_uuid
          displayoption         = lv_displayoption
          messagecount          = lv_esg_count
          errorcount            = lv_error_count
          warningcount          = lv_warning_count
          successcount          = lv_success_count
          infocount             = lv_info_count
         ).
      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
    ENDTRY.

  ENDMETHOD.


  METHOD messagegroupset_get_entity.

    DATA: lv_proj_uuid     TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid      TYPE /ltb/mc_object_uuid,
*        lv_instance_uuid TYPE cnv_pe_wl_item_id,
          lv_instance_uuid TYPE /ltb/if_mc_constants=>gty_item_uuid,
          ls_key_pair      TYPE /iwbep/s_mgw_name_value_pair,
          lv_msggroup_uuid TYPE /ltb/if_mc_constants=>gty_msg_group_uuid,
          lt_instance_uuid TYPE /ltb/if_mc_constants=>gtt_item_uuid,
          lv_displayoption TYPE string.

    CLEAR es_response_context.
    CLEAR er_entity.

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationinstance OR
       iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_messagegroup.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_instance_uuid.
      IF sy-subrc = 0.
        lv_instance_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_message_group_uuid.
      IF sy-subrc = 0.
        lv_msggroup_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_message_display_option.
      IF sy-subrc = 0.
        lv_displayoption = ls_key_pair-value.
      ENDIF.

      IF lv_displayoption IS INITIAL.
        lv_displayoption = /ltb/if_mc_constants=>gc_message_display_option-group.
      ENDIF.

      TRY.

          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

          lo_obj_ctx->set_item_uuid( EXPORTING iv_item_uuid = lv_instance_uuid ).

          DATA(ls_obj_detail) = lo_object_proxy->get_details( lo_obj_ctx ).

          APPEND lv_instance_uuid TO lt_instance_uuid.
          DATA(lo_msg_proxy) = lo_object_proxy->get_message_group_by_uuid( iv_msg_group_uuid = lv_msggroup_uuid
                                                                           it_item_uuid      = lt_instance_uuid
                                                                           iv_displayoption  = lv_displayoption ).
          DATA(ls_message_group) = lo_msg_proxy->get_group_details( lo_obj_ctx ).

          er_entity   = VALUE #(
                    migrationprojectuuid         = lv_proj_uuid
                    migrationobjectuuid          = lv_obj_uuid
                    migrationinstanceuuid        = lv_instance_uuid
                    messagegroupuuid             = ls_message_group-group_uuid
                    displayoption                = lv_displayoption
                    messagegroupdatetime         = datetime_round_down( ls_message_group-last_datetime ) ##TYPE
                    messagegrouptitle            = ls_message_group-group_title
                    messagegrouptype             = ls_message_group-group_msgty
                    typedescription              = get_status_desc( CONV #( ls_message_group-group_msgty ) )
                    messagegroupoccurrence       = SWITCH #( ls_message_group-group_event WHEN ''  THEN get_text( 'A01' )
                                                                                          WHEN 'L' THEN get_text( 'C03' )
                                                                                          WHEN 'S' THEN get_text( 'C04' )
                                                                                          WHEN 'M' THEN get_text( 'C02' ) )
                    messagegroupmsgid            = ls_message_group-group_msgid
                    messagegroupmsgno            = ls_message_group-group_msgno
                    messagecount                 = ls_message_group-group_msgcnt
                    messagegrouplongtext         = get_longtext_from_msg( iv_msgid = ls_message_group-group_msgid
                                                                          iv_msgno = ls_message_group-group_msgno
                                                                          iv_msgv1 = ls_message_group-group_msgv1
                                                                          iv_msgv2 = ls_message_group-group_msgv2
                                                                          iv_msgv3 = ls_message_group-group_msgv3
                                                                          iv_msgv4 = ls_message_group-group_msgv4 )
                    migrationobjectname          = ls_obj_detail-migobj_descr
                    event                        = get_action_desc( CONV #( ls_message_group-group_event ) )  "Event
                    ) .

        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.

    ENDIF.
  ENDMETHOD.


  METHOD messagegroupset_get_entityset.

    DATA: lv_proj_uuid     TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid      TYPE /ltb/mc_object_uuid,
*        lv_instance_uuid TYPE cnv_pe_wl_item_id,
          lv_instance_uuid TYPE /ltb/if_mc_constants=>gty_item_uuid,
          ls_key_pair      TYPE /iwbep/s_mgw_name_value_pair,
          lv_count         TYPE int4,
          lt_order         TYPE /iwbep/t_mgw_sorting_order.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationinstance.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_instance_uuid.
      IF sy-subrc = 0.
        lv_instance_uuid = ls_key_pair-value.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

          lo_obj_ctx->set_item_uuid( EXPORTING iv_item_uuid = lv_instance_uuid ).

          DATA(ls_obj_detail) = lo_object_proxy->get_details( lo_obj_ctx ).

          "Set context query: paging, full search, order, filter
          lt_order = it_order.
          IF lt_order IS INITIAL.
            "set default order by message group type
            lt_order = VALUE #( ( property = 'MessageGroupType'
                      order    = co_sort_descending ) ).
          ENDIF.
          set_context( iv_entity_set_name = iv_entity_set_name
            is_paging = is_paging
            iv_search_string = iv_search_string
            it_order = lt_order
            it_filter_select_options = it_filter_select_options
            io_context = lo_obj_ctx ).

          DATA(lt_message_group) = lo_object_proxy->get_message_groups( EXPORTING io_cntxt = lo_obj_ctx
                                                                        IMPORTING ev_count = lv_count ).

          et_entityset = VALUE #( FOR ls_message_group IN lt_message_group
                                  ( migrationprojectuuid         = lv_proj_uuid
                                    migrationobjectuuid          = lv_obj_uuid
                                    migrationinstanceuuid        = lv_instance_uuid
                                    messagegroupuuid             = ls_message_group-group_uuid
                                    displayoption                = ls_message_group-displayoption
                                    messagegroupdatetime         = datetime_round_down( ls_message_group-last_datetime ) ##TYPE
                                    messagegrouptitle            = ls_message_group-group_title
                                    messagegrouptype             = ls_message_group-group_msgty
                                    typedescription              = get_status_desc( CONV #( ls_message_group-group_msgty ) )
                                    messagegroupoccurrence       = SWITCH #( ls_message_group-group_event WHEN ''  THEN get_text( 'A01' )
                                                                                                          WHEN 'L' THEN get_text( 'C03' )
                                                                                                          WHEN 'S' THEN get_text( 'C04' )
                                                                                                          WHEN 'M' THEN get_text( 'C02' ) )
                                    messagegroupmsgid            = ls_message_group-group_msgid
                                    messagegroupmsgno            = ls_message_group-group_msgno
                                    messagecount                 = ls_message_group-group_msgcnt
                                    migrationobjectname          = ls_obj_detail-migobj_descr
                                    messagegrouplongtext         = get_longtext_from_msg( iv_msgid = ls_message_group-group_msgid
                                                                                          iv_msgno = ls_message_group-group_msgno )
                                    event                        = get_action_desc( CONV #( ls_message_group-group_event ) )  "Event
                                  ) ).

          IF io_tech_request_context->has_inlinecount( ) = abap_true.
            IF is_paging-top > lv_count.
              es_response_context-count = lv_count.
            ELSE.
              es_response_context-count = is_paging-top.
            ENDIF.
            es_response_context-inlinecount = lv_count.
          ENDIF.
        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD messageinstances_get_entityset.

    DATA: lv_proj_uuid     TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid      TYPE /ltb/mc_object_uuid,
          lv_instance_uuid TYPE /ltb/if_mc_constants=>gty_item_uuid,
          lv_msggroup_uuid TYPE char32,
          ls_key_pair      TYPE /iwbep/s_mgw_name_value_pair,
          lt_instance_uuid TYPE /ltb/if_mc_constants=>gtt_item_uuid,
          lv_displayoption TYPE string.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_messagegroup.
      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.


      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_instance_uuid.
      IF sy-subrc = 0.
        lv_instance_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_message_group_uuid.
      IF sy-subrc = 0.
        lv_msggroup_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_message_display_option.
      IF sy-subrc = 0.
        lv_displayoption = ls_key_pair-value.
      ENDIF.

      IF lv_displayoption IS INITIAL.
        lv_displayoption = /ltb/if_mc_constants=>gc_message_display_option-group.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

          DATA(lo_obj_ctx)       = NEW /ltb/cl_mc_cntxt_obj_detail( ).

          DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

          APPEND lv_instance_uuid TO lt_instance_uuid.
          DATA(lo_message_proxy) = lo_object_proxy->get_message_group_by_uuid( iv_msg_group_uuid = lv_msggroup_uuid
                                                                               it_item_uuid      = lt_instance_uuid
                                                                               iv_displayoption  = lv_displayoption ).

          CLEAR lt_instance_uuid.
          lo_message_proxy->get_used_by_items(
            EXPORTING
              io_cntxt = lo_obj_ctx
            IMPORTING
              et_item_uuid = lt_instance_uuid ).

          et_entityset = VALUE #( FOR <fs_inst_uuid> IN lt_instance_uuid
                                  ( messageinstanceuuid     = sy-tabix
                                    migrationprojectuuid  = lv_proj_uuid
                                    migrationobjectuuid   = lv_obj_uuid
                                    migrationinstanceuuid = <fs_inst_uuid>
                                    messagegroupuuid      = lv_msggroup_uuid
            ) ).
        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD migrationapproac_get_entityset.

    CLEAR es_response_context.
    CLEAR et_entityset.

    TRY.
        "get all records
        DATA(lo_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        DATA(lt_approach) = lo_proxy->get_approaches( ).

        SORT lt_approach BY approach.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    "output
    et_entityset = VALUE #( FOR <item> IN lt_approach
                        (
                          migrationapproachuuid = <item>-approach
                          migrationapproachname = <item>-text
                          MigrationApproachIsHidden = <item>-is_hidden
                        )
               ).

  ENDMETHOD.


  METHOD migrationfilec01_get_entityset.

    DATA:
      ls_filecol_key TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationfilecolumn.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_filecol_key ).

    TRY.

        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_filecol_key-migrationprojectuuid ) ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_filecol_key-migrationobjectuuid ) ).

        DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( ls_filecol_key-migrationfileuuid ) ).

        DATA(lo_file_ctx) = NEW /ltb/cl_mc_cntxt_file_detail( ).

        lo_file_ctx->set_tabname( CONV #( ls_filecol_key-tableident ) ).

        lo_file_proxy->get_fields(
          EXPORTING
            io_cntxt  = lo_file_ctx
          IMPORTING
            et_fields = DATA(lt_fields) ).

        et_entityset = VALUE #(
          FOR <field> IN lt_fields (
            migrationprojectuuid = ls_filecol_key-migrationprojectuuid
            migrationobjectuuid  = ls_filecol_key-migrationobjectuuid
            migrationfileuuid    = ls_filecol_key-migrationfileuuid
            tableident           = ls_filecol_key-tableident
            fieldpos             = <field>-field_pos
            fieldname            = <field>-field_name
            fieldgroup           = <field>-field_group
            fielddescription     = <field>-field_descr
            fieldlabel           = <field>-field_descr
            iskey                = <field>-is_key
          )
       ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationfilec02_get_entity.

    DATA:
      ls_filecontent_key TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationfilecontent.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_filecontent_key ).

    TRY.

        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_filecontent_key-migrationprojectuuid ) ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_filecontent_key-migrationobjectuuid ) ).

        DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( ls_filecontent_key-migrationfileuuid )  ).

        DATA(lo_file_ctx) = NEW /ltb/cl_mc_cntxt_file_detail( ).

        lo_file_ctx->set_tabname( CONV #( ls_filecontent_key-tableident ) ).

        lo_file_proxy->get_data(
          EXPORTING
            io_cntxt = lo_file_ctx
          IMPORTING
            er_data  = DATA(lr_data) ).

        ASSIGN lr_data->* TO FIELD-SYMBOL(<fs_data>).

        DATA(writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

        CALL TRANSFORMATION id SOURCE data = <fs_data>
                               RESULT XML writer.

        er_entity = VALUE #(
          migrationprojectuuid = ls_filecontent_key-migrationobjectuuid
          migrationobjectuuid  = ls_filecontent_key-migrationobjectuuid
          migrationfileuuid    = ls_filecontent_key-migrationfileuuid
          tableident           = ls_filecontent_key-tableident
          filecontent          = cl_abap_codepage=>convert_from( writer->get_output( ) )
       ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationfilec02_get_entityset.

    DATA:
      ls_filecontent_key TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationfilecontent.

    FIELD-SYMBOLS:
      <fs_data> TYPE STANDARD TABLE.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_filecontent_key ).

    TRY.

        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_filecontent_key-migrationprojectuuid ) ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_filecontent_key-migrationobjectuuid ) ).

        DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( ls_filecontent_key-migrationfileuuid )  ).

        DATA(lo_file_ctx) = NEW /ltb/cl_mc_cntxt_file_detail( ).

        lo_file_ctx->set_tabname( CONV #( ls_filecontent_key-tableident ) ).

        set_context(
          EXPORTING
            iv_entity_set_name       = iv_entity_set_name
            it_order                 = it_order
            is_paging                = is_paging
            iv_search_string         = iv_search_string
            it_filter_select_options = it_filter_select_options
            io_context               = lo_file_ctx ).

        lo_file_proxy->get_data(
          EXPORTING
            io_cntxt = lo_file_ctx
          IMPORTING
            er_data  = DATA(lr_data)
            ev_count = DATA(lv_count) ).

        ASSIGN lr_data->* TO <fs_data>.

        DATA(writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

        CALL TRANSFORMATION id SOURCE data = <fs_data>
                               RESULT XML writer.

        APPEND VALUE #(
          migrationprojectuuid = ls_filecontent_key-migrationobjectuuid
          migrationobjectuuid  = ls_filecontent_key-migrationobjectuuid
          migrationfileuuid    = ls_filecontent_key-migrationfileuuid
          tableident           = ls_filecontent_key-tableident
          numofentries         = lv_count
          filecontent          = cl_abap_codepage=>convert_from( writer->get_output( ) )
        ) TO et_entityset.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationfilecou_get_entity.

    DATA:
      ls_filecount_key TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationfilecount.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_filecount_key ).

    TRY.

        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_filecount_key-migrationprojectuuid ) ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_filecount_key-migrationobjectuuid ) ).

        DATA(lv_files_count) = lo_object_proxy->get_files_count( NEW /ltb/cl_mc_cntxt_obj_detail( ) ).

        er_entity = VALUE #(
          migrationprojectuuid = ls_filecount_key-migrationprojectuuid
          migrationobjectuuid  = ls_filecount_key-migrationobjectuuid
          filecount            = lv_files_count
       ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationfileset_create_entity.

    DATA:
      ls_file_key  TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationfile,
      lt_check_msg TYPE cnv_mbt_t_bal_s_msg.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_file_key
    ).
    "check file name

    IF ls_file_key-filename IS NOT INITIAL.
      IF abap_true = /ltb/cl_mc_fileproc_access=>check_file_name_exist(
                      iv_proj_guid   = CONV #( ls_file_key-migrationprojectuuid )
                      iv_migobj_guid = CONV #( ls_file_key-migrationobjectuuid )
                      iv_file_name   = CONV #( ls_file_key-filename ) ).

        APPEND VALUE #( msgty = 'E'
                        msgid = 'DMC_RT_MSG'
                        msgno = '630'
                        msgv1 = ls_file_key-filename ) TO lt_check_msg.

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_check_msg ).

      ENDIF.
    ENDIF.

    DATA(lv_fileproc_uuid) = /ltb/cl_mc_file_proxy_mwb_csv=>create_csv_bundle(
      EXPORTING
        iv_proj_uuid     = CONV #( ls_file_key-migrationprojectuuid )
        iv_migobj_uuid   = CONV #( ls_file_key-migrationobjectuuid )
        iv_filename      = CONV #( ls_file_key-filename )
    ).

    IF lv_fileproc_uuid IS INITIAL.
      APPEND VALUE #( msgty = sy-msgty
                      msgid = sy-msgid
                      msgno = sy-msgno
                      msgv1 = sy-msgv1
                      msgv2 = sy-msgv2
                      msgv3 = sy-msgv3
                      msgv4 = sy-msgv4 ) TO lt_check_msg.

      raise_bussiness_exception(
        EXPORTING
          iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
          it_message = lt_check_msg
      ).
    ENDIF.

    GET TIME STAMP FIELD er_entity-createdat.
    er_entity-createdby = sy-uname.
    er_entity-migrationfileuuid = lv_fileproc_uuid.
    er_entity-migrationobjectuuid =  ls_file_key-migrationobjectuuid.
    er_entity-migrationprojectuuid = ls_file_key-migrationprojectuuid.

  ENDMETHOD.


  METHOD migrationfileset_get_entity.

    DATA:
      ls_file_key TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationfile.

    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values = ls_file_key ).

    TRY.

        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_file_key-migrationprojectuuid ) ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_file_key-migrationobjectuuid ) ).

        DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( ls_file_key-migrationfileuuid ) ).

        DATA(ls_details) = lo_file_proxy->get_details( NEW /ltb/cl_mc_cntxt_file_detail( ) ).

        DATA(ls_proj_details) = lo_project_proxy->get_proj_details( NEW /ltb/cl_mc_cntxt_proj_detail( ) ).

        DATA(ls_obj_details) = lo_object_proxy->get_details( NEW /ltb/cl_mc_cntxt_obj_detail( ) ).

        er_entity  = VALUE #(
          migrationprojectuuid  = ls_details-proj_uuid
          migrationobjectuuid   = ls_details-migobj_uuid
          migrationfileuuid     = ls_details-fileproc_uuid
          filename              = ls_details-file_name
          filestatus            = ls_details-fileproc_status
          statusdescription     = ls_details-status_desc
          createdby             = /ltb/cl_mc_odata_generic_func=>get_fullname_by_uname( CONV #( ls_details-created_by ) )
          createdat             = ls_details-created_ts
          filesize              = ls_details-filesize
          numofinstances        = ls_details-instances_num
          migrationobjectname   = ls_obj_details-migobj_descr
          migrationprojectname  = ls_proj_details-proj_descr
          latesthistoryuuid     = ls_details-act_uuid
          applognr              = ls_details-lognr
          numberof1             = ls_details-numberof1
          numberof2             = ls_details-numberof2
          numberof3             = ls_details-numberof3
       ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationfileset_get_entityset.

    CONSTANTS:
      co_property_statusgroup TYPE string VALUE 'StatusGroup'.

    DATA:
      ls_file_key   TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationfile.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_file_key ).

    io_tech_request_context->get_navigation_path( ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_file_key-migrationprojectuuid ) ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_file_key-migrationobjectuuid ) ).
        DATA(lo_obj_cntxt) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        READ TABLE it_navigation_path INTO DATA(lv_navigation_path) INDEX 1.

        IF lv_navigation_path-nav_prop = 'to_Correction'.
          lo_obj_cntxt->set_filecategory( iv_filecategory = /ltb/if_mc_constants=>gc_fileproc-category-correction ).
        ELSEIF lv_navigation_path-nav_prop = 'to_File'.
          lo_obj_cntxt->set_filecategory( iv_filecategory = /ltb/if_mc_constants=>gc_fileproc-category-xml ).
        ENDIF.

        DATA(lt_files) = lo_object_proxy->get_files_list( lo_obj_cntxt ).

        et_entityset = VALUE #(
          FOR <file> IN lt_files (
            migrationprojectuuid = <file>-proj_uuid
            migrationobjectuuid  = <file>-migobj_uuid
            migrationfileuuid    = <file>-fileproc_uuid
            filename             = <file>-file_name
            filecategory         = <file>-fileproc_cat
            filestatus           = <file>-fileproc_status
            statusdescription    = <file>-status_desc
            statusgroup          = COND #(
              WHEN <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-uploaded OR
                   <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-uploaded_incomplete OR
                   <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-uploaded_ready OR
                   <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-map_sched OR
                   <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-map_sched_valid OR
                   <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-mapping OR
                   <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-created
                THEN  /ltb/if_mc_constants=>gc_fileproc-status_group-upload
              WHEN <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-validation_scheduled OR
                   <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-validated_error OR
                   <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-validating OR
                   <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-validated OR
                   <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-validated_warning
                THEN /ltb/if_mc_constants=>gc_fileproc-status_group-validation
              WHEN <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-import_scheduled OR
                   <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-imported_error OR
                   <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-importing
                THEN /ltb/if_mc_constants=>gc_fileproc-status_group-transfer
              WHEN <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-imported OR
                   <file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-imported_warning
                THEN /ltb/if_mc_constants=>gc_fileproc-status_group-finished
            )
            createdby            = /ltb/cl_mc_odata_generic_func=>get_fullname_by_uname( CONV #( <file>-created_by ) )
            createdat            = <file>-created_ts
            filesize             = COND #( WHEN <file>-fileproc_cat = /ltb/if_mc_constants=>gc_fileproc-category-csv
                                           THEN get_bundle_file_size( <file>-fileproc_uuid )
                                           ELSE <file>-filesize )
            numofinstances       = <file>-instances_num
            latesthistoryuuid    = <file>-act_uuid
            applognr             = <file>-lognr
            numberof1            = <file>-numberof1
            numberof2            = <file>-numberof2
            numberof3            = <file>-numberof3
          )
        ).

        IF io_tech_request_context->has_inlinecount( ) = abap_true.
          es_response_context-inlinecount = lines( et_entityset ).
        ENDIF.

        IF lv_navigation_path-nav_prop = 'to_File'.
          READ TABLE it_filter_select_options ASSIGNING FIELD-SYMBOL(<fs_filter>) WITH KEY property = co_property_statusgroup.
          IF sy-subrc = 0.
            DELETE et_entityset WHERE statusgroup NOT IN <fs_filter>-select_options.
          ENDIF.
        ELSEIF lv_navigation_path-nav_prop = 'to_Correction'.
          READ TABLE it_filter_select_options ASSIGNING <fs_filter> WITH KEY property = 'FileCategory'.
          IF sy-subrc = 0.
            DELETE et_entityset WHERE filecategory NOT IN <fs_filter>-select_options.
          ENDIF.

          DATA(lv_full_search) = to_upper( iv_search_string ).
          LOOP AT et_entityset INTO DATA(ls_entityset).
            IF NOT ( to_upper( ls_entityset-filename ) CS lv_full_search OR
                     to_upper( ls_entityset-statusdescription ) CS lv_full_search OR
                     to_upper( ls_entityset-createdby ) CS lv_full_search ).
              DELETE TABLE et_entityset FROM ls_entityset.
            ENDIF.
          ENDLOOP.
        ENDIF.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.
        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationfilet01_get_entityset.

    DATA:
      ls_filetab_key TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationfiletab.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_filetab_key ).

    TRY.

        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_filetab_key-migrationprojectuuid ) ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_filetab_key-migrationobjectuuid ) ).

        DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( ls_filetab_key-migrationfileuuid ) ).

        lo_file_proxy->get_tables(
          EXPORTING
            io_cntxt  = NEW /ltb/cl_mc_cntxt_file_detail( )
          IMPORTING
            et_tables = DATA(lt_tables) ).

        et_entityset = VALUE #(
          FOR <tab> IN lt_tables (
            migrationprojectuuid = ls_filetab_key-migrationprojectuuid
            migrationobjectuuid  = ls_filetab_key-migrationobjectuuid
            migrationfileuuid    = ls_filetab_key-migrationfileuuid
            tableident           = <tab>-struct_ident
            tabletechuuid        = <tab>-stg_tabname
            tabledescription     = <tab>-description
            numofrecords         = <tab>-num_records_total
            isheadertable        = <tab>-is_header_table
          )
       ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationgroupin_get_entityset.
    DATA: lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid.
    DATA: lv_search_string TYPE string.

    CLEAR es_response_context.
    CLEAR et_entityset.
    no_cache( ).

    check_system_upgrade( ).

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobject.
      READ TABLE it_key_tab INTO DATA(ls_key_pair) WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

          DATA(lo_file_ctx) = NEW /ltb/cl_mc_cntxt_file_detail( ).

          IF line_exists( it_filter_select_options[ property = co_migration_inst_grp_ind ] ).
            DATA(lt_select_option) = it_filter_select_options[ property = co_migration_inst_grp_ind ]-select_options.
            lv_search_string = lt_select_option[ 1 ]-low.
            SHIFT lv_search_string LEFT DELETING LEADING '*'.
            SHIFT lv_search_string RIGHT DELETING TRAILING '*'.
            CONDENSE lv_search_string.
          ENDIF.

          set_context(
              EXPORTING
                iv_entity_set_name       = iv_entity_set_name
                iv_search_string         = lv_search_string
                is_paging                = is_paging
                io_context               = lo_file_ctx ).

          DATA(lt_indicators) = lo_object_proxy->get_group_indicators( lo_file_ctx ).

          et_entityset = VALUE #( FOR <fs_indicators> IN lt_indicators
                                    ( migrationprojectuuid = lv_proj_uuid
                                      migrationobjectuuid  = lv_obj_uuid
                                      groupindicator       = <fs_indicators> ) ) .

        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD migrationinsta01_get_entityset.
    DATA: lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid,
          ls_key_pair  TYPE /iwbep/s_mgw_name_value_pair.

    CLEAR es_response_context.
    CLEAR et_entityset.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
    IF sy-subrc = 0.
      lv_proj_uuid = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
    IF sy-subrc = 0.
      lv_obj_uuid = ls_key_pair-value.
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

*       Get Itemlist structure.
        DATA(lt_itemlist_metadata) = lo_object_proxy->get_itemlist_metadata( lo_obj_ctx ).
        et_entityset = VALUE #( FOR ls_itemlist_metadata IN lt_itemlist_metadata WHERE ( result_type = '' )
                                ( fieldname            = ls_itemlist_metadata-fieldname
                                  fielddescription     = ls_itemlist_metadata-description
                                  migrationprojectuuid = lv_proj_uuid
                                  migrationobjectuuid  = lv_obj_uuid ) ).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationinsta02_get_entityset.
    DATA: lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid,
          ls_key_pair  TYPE /iwbep/s_mgw_name_value_pair.

    CLEAR es_response_context.
    CLEAR et_entityset.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
    IF sy-subrc = 0.
      lv_proj_uuid = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
    IF sy-subrc = 0.
      lv_obj_uuid = ls_key_pair-value.
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

        DATA(lt_bulk_action) = lo_object_proxy->get_bulk_action( lo_obj_ctx ).
        et_entityset = VALUE #( FOR ls_bulk_action IN lt_bulk_action
                                ( action               = ls_bulk_action-action
                                  actiondescription    = ls_bulk_action-actiondescription
                                  migrationprojectuuid = lv_proj_uuid
                                  migrationobjectuuid  = lv_obj_uuid ) ).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
    ENDTRY.
  ENDMETHOD.


  METHOD migrationinsta04_get_entityset.
    DATA: lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid.
    DATA: lv_search_string TYPE string.

    CLEAR es_response_context.
    CLEAR et_entityset.
    no_cache( ).

    check_system_upgrade( ).

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobject.
      READ TABLE it_key_tab INTO DATA(ls_key_pair) WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

          DATA(lo_file_ctx) = NEW /ltb/cl_mc_cntxt_file_detail( ).

          IF line_exists( it_filter_select_options[ property = co_migration_inst_grp_ind ] ).
            DATA(lt_select_option) = it_filter_select_options[ property = co_migration_inst_grp_ind ]-select_options.
            lv_search_string = lt_select_option[ 1 ]-low.
            SHIFT lv_search_string LEFT DELETING LEADING '*'.
            SHIFT lv_search_string RIGHT DELETING TRAILING '*'.
            CONDENSE lv_search_string.
          ENDIF.

          set_context(
              EXPORTING
                iv_entity_set_name       = iv_entity_set_name
                iv_search_string         = lv_search_string
                is_paging                = is_paging
                io_context               = lo_file_ctx ).

          DATA(lt_indicators) = lo_object_proxy->get_group_indicators(
                                  io_cntxt    =   lo_file_ctx
                                  iv_issource =   abap_true
                                ).

          et_entityset = VALUE #( FOR <fs_indicators> IN lt_indicators
                                    ( migrationprojectuuid = lv_proj_uuid
                                      migrationobjectuuid  = lv_obj_uuid
                                      source       = <fs_indicators> ) ) .

        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD migrationinstanc_delete_entity.
**TRY.
*CALL METHOD SUPER->MIGRATIONINSTANC_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
  ENDMETHOD.


  METHOD migrationinstanc_get_entity.

    DATA: lv_proj_uuid     TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid      TYPE /ltb/mc_object_uuid,
*        lv_instance_uuid TYPE cnv_pe_wl_item_id,
          lv_instance_uuid TYPE /ltb/if_mc_constants=>gty_item_uuid,
          ls_key_pair      TYPE /iwbep/s_mgw_name_value_pair,
          lv_displayoption TYPE string.

    FIELD-SYMBOLS: <fs_itemdata>   TYPE any,
                   <fv_fieldvalue> TYPE any,
                   <fv_itemfield>  TYPE any.

    CONSTANTS:
      lco_fieldcount       TYPE i       VALUE 14,
      lco_resultcount      TYPE i       VALUE 32,
      lco_fieldname_prefix TYPE string  VALUE 'ITEMFIELD'.

    CLEAR es_response_context.
    CLEAR er_entity.
    no_cache( ).
    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc_ext=>gc_migrationinstance AND iv_entity_name = /ltb/cl_mig_mc_odata_mpc_ext=>gc_migrationinstance.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.

      "TODO(Daniel) This was: name = '' (probably a bug?)
      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_instance_uuid.
      IF sy-subrc = 0.
        lv_instance_uuid  = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_mig_inst_display_option.
      IF sy-subrc = 0.
        lv_displayoption = ls_key_pair-value.
      ENDIF.
      IF lv_displayoption IS INITIAL.
        lv_displayoption = /ltb/if_mc_constants=>gc_instance_display_option-standard.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

          DATA(ls_obj_detail) = lo_object_proxy->get_details( lo_obj_ctx ).

          lo_obj_ctx->set_item_uuid( EXPORTING iv_item_uuid = lv_instance_uuid ).
          lo_obj_ctx->add_value( EXPORTING iv_type = /ltb/if_mc_constants=>gc_cntxt_type-displayoption
                                           iv_value = CONV #( lv_displayoption ) ).

          DATA(lo_item_proxy)    = lo_object_proxy->get_item_proxy_by_uuid( lv_instance_uuid ).
          DATA(ls_itemlist_data) = lo_item_proxy->get_details( lo_obj_ctx ).

          DATA(lt_itemlist_metadata) = lo_object_proxy->get_itemlist_metadata( lo_obj_ctx ).

*       Project UUID
          er_entity-migrationprojectuuid       = lv_proj_uuid.
*       Object UUID
          er_entity-migrationobjectuuid        = lv_obj_uuid.
*       Instatnce ID
          er_entity-migrationinstanceuuid      = lv_instance_uuid.
*       MO name
          er_entity-migrationobjectname        = ls_obj_detail-migobj_descr.
*       MO descr
          er_entity-migrationobjectdescr       = ls_obj_detail-migobj_doc_descr.
*       Status
          er_entity-migrationinstancestatus    = ls_itemlist_data-item_status.
*       Status description
*          er_entity-statusdescription          = get_status_desc( CONV #( er_entity-migrationinstancestatus ) ).
          er_entity-statusdescription          = ls_itemlist_data-item_status_desc.
*       Action
          er_entity-action                     = ls_itemlist_data-item_action. "Action
*       Action description
*          er_entity-actiondescription          = get_action_desc( CONV #( er_entity-action ) ).
          er_entity-actiondescription          = ls_itemlist_data-item_action_desc.
*       Instance Title
          er_entity-instancetitle              = ls_itemlist_data-item_name.
*       Group Indicator
          er_entity-groupindicator             = ls_itemlist_data-item_group_indicator.
*       Display Option
          er_entity-displayoption              = lv_displayoption.
          er_entity-optionid                   = ls_itemlist_data-item_option_id.
          er_entity-optiondescr                = ls_itemlist_data-item_option_full.
          er_entity-optionseq                  = ls_itemlist_data-item_option_seq.
          er_entity-step                       = ls_itemlist_data-item_step.
          er_entity-stepdescr                  = ls_itemlist_data-item_step_full.
          er_entity-stepdescrvalid             = ls_itemlist_data-item_descr_valid.

          ASSIGN ls_itemlist_data-item_data->* TO <fs_itemdata>.
          IF sy-subrc = 0.
            MOVE-CORRESPONDING <fs_itemdata> TO er_entity.
            "Set ItemField 1~14 according to its position from metadata
            LOOP AT lt_itemlist_metadata ASSIGNING FIELD-SYMBOL(<ls_itemlist_metadata>).
              IF <ls_itemlist_metadata>-position > lco_fieldcount.
                EXIT.
              ENDIF.
              DATA(lv_fieldname) = lco_fieldname_prefix && <ls_itemlist_metadata>-position.
              ASSIGN COMPONENT lv_fieldname OF STRUCTURE er_entity TO <fv_itemfield>.
              IF sy-subrc = 0.
                IF <ls_itemlist_metadata>-fieldname CP 'RESULT*'.
                  CONTINUE.
                ELSE.
                  ASSIGN COMPONENT <ls_itemlist_metadata>-fieldname OF STRUCTURE <fs_itemdata> TO <fv_fieldvalue>.
                  IF sy-subrc = 0.
                    <fv_itemfield> = CONV #( <fv_fieldvalue> ).
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDLOOP.
          ENDIF.

        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages ).

        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages ).
      ENDTRY.

    ENDIF.
  ENDMETHOD.


  METHOD migrationinstanc_get_entityset.

    DATA: lv_proj_uuid      TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid       TYPE /ltb/mc_object_uuid,
          ls_key_pair       TYPE /iwbep/s_mgw_name_value_pair,
          ls_entity         TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationinstance,
          lt_itemlist_data  TYPE /ltb/if_mc_constants=>gtt_item,
          lt_inst_uuid      TYPE /ltb/if_mc_constants=>gtt_item_uuid,
          lt_filter         TYPE /ltb/if_mc_constants=>gtt_filter_cond,
          ls_filter         TYPE /ltb/if_mc_constants=>gty_filter_cond,
          lv_limit          TYPE int4,
          lv_offset         TYPE int4,
          lt_order          TYPE /ltb/if_mc_constants=>gtt_sort_order,
          ls_order          TYPE /ltb/if_mc_constants=>gty_sort_order,
          lt_select_filter  TYPE /ltb/if_mc_constants=>tt_sel,
          ls_filter_request TYPE /iwbep/s_mgw_select_option,
          ls_filter_option  TYPE /iwbep/s_cod_select_option,
          lv_displayoption  TYPE string.
    CONSTANTS:
      lco_max_item_count   TYPE int4    VALUE 255,
      lco_msgid            TYPE symsgid VALUE '/LTB/MC',
      lco_msgno            TYPE symsgno VALUE '040',
      lco_fieldcount       TYPE i       VALUE 14,
      lco_fieldname_prefix TYPE string  VALUE 'ITEMFIELD',
      lco_item_status      TYPE string  VALUE 'ITEM_STATUS',
      lco_item_action      TYPE string  VALUE 'ITEM_ACTION',
      lco_group_indicator  TYPE string  VALUE '/1LT/GRP_INDICATOR'.


    FIELD-SYMBOLS: <fs_itemdata>      TYPE any,
                   <fv_fieldvalue>    TYPE any,
                   <fv_itemfield>     TYPE any,
                   <ls_select_option> TYPE /iwbep/s_cod_select_option
                   .

    CLEAR es_response_context.
    CLEAR et_entityset.
    no_cache( ).
    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobject OR
       iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationinstance.  " From migration instance

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_filter_select_options INTO ls_filter_request WITH KEY property = co_mig_inst_display_option.
      IF sy-subrc = 0.
        READ TABLE ls_filter_request-select_options INTO ls_filter_option INDEX 1.
        lv_displayoption = ls_filter_option-low.
      ELSE.
        lv_displayoption = /ltb/if_mc_constants=>gc_instance_display_option-standard.
      ENDIF.

      IF lv_displayoption IS INITIAL.
        lv_displayoption = /ltb/if_mc_constants=>gc_instance_display_option-standard.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
          DATA(lo_obj_ctx)       = NEW /ltb/cl_mc_cntxt_obj_detail( ).
          DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).
          DATA(ls_obj_detail) = lo_object_proxy->get_details( lo_obj_ctx ).
          "Get fieldname fieldlabel mapping.
          lo_obj_ctx->set_field_num( lco_fieldcount ).

          DATA(lt_itemlist_metadata) = lo_object_proxy->get_itemlist_metadata( lo_obj_ctx ).

*         Handle paging, at most one page contains 255 items
          IF is_paging-top > lco_max_item_count.
            lv_limit = lco_max_item_count.
          ELSE.
            lv_limit = is_paging-top.
          ENDIF.
          lv_offset = is_paging-skip.
          IF lv_limit <> 0 OR lv_offset <> 0.
            lo_obj_ctx->set_page( iv_offset = lv_offset iv_limit = lv_limit ).
          ENDIF.

*         Handle filter
          DATA(lt_filter_select_option) = io_tech_request_context->get_filter( )->get_filter_select_options( ).
          IF lt_filter_select_option IS INITIAL AND iv_filter_string IS NOT INITIAL.
            lt_filter_select_option = get_complex_filter_sel_option(
              EXPORTING
                io_tech_request_context = io_tech_request_context
                iv_entity_name          = iv_entity_name
                iv_tech_property_name   = abap_true ).
          ENDIF.

*         Remove escape symbol "#" from filter value
          remove_escape_symbol( CHANGING ct_filter_select_options = lt_filter_select_option ).

          LOOP AT lt_filter_select_option INTO DATA(ls_filter_select_option) ##INTO_OK.
            CLEAR ls_filter.
            CASE ls_filter_select_option-property.
              WHEN  co_abap_migration_inst_uuid.
                LOOP AT ls_filter_select_option-select_options INTO DATA(ls_select_option) ##INTO_OK.
                  CHECK ls_select_option-option = 'EQ'.
                  APPEND ls_select_option-low TO lt_inst_uuid.
                ENDLOOP.
              WHEN  co_abap_migration_inst_status.
                lt_filter = VALUE #( BASE lt_filter
                                     FOR <fs_select_options> IN ls_filter_select_option-select_options
                                     ( field = lco_item_status
                                       sign  = <fs_select_options>-sign
                                       oper  = <fs_select_options>-option
                                       low   = <fs_select_options>-low
                                       high  = <fs_select_options>-high
                                      )
                                     ).
              WHEN  co_abap_migration_inst_action.
                lt_filter = VALUE #( BASE lt_filter
                                     FOR <fs_select_options> IN ls_filter_select_option-select_options
                                     ( field = lco_item_action
                                       sign  = <fs_select_options>-sign
                                       oper  = <fs_select_options>-option
                                       low   = <fs_select_options>-low
                                       high  = <fs_select_options>-high
                                      )
                                     ).
              WHEN co_abap_migration_inst_grp_ind.
                lt_filter = VALUE #( BASE lt_filter
                                     FOR <fs_select_options> IN ls_filter_select_option-select_options
                                     ( field = lco_group_indicator
                                       sign  = <fs_select_options>-sign
                                       oper  = <fs_select_options>-option
                                       low   = <fs_select_options>-low
                                       high  = <fs_select_options>-high
                                      )
                                     ).
              WHEN co_abap_migration_inst_msgid OR
                   co_abap_migration_inst_msgno OR
                   co_abap_migration_inst_msgty OR
                   co_abap_migration_optionid OR
                   co_abap_migration_step OR
                   co_abap_migration_optiondescr OR
                   co_abap_migration_stepdescr OR
                   co_abap_migration_inst_exec_id.
                IF ls_filter_select_option-property = co_abap_migration_optionid
                  OR ls_filter_select_option-property = co_abap_migration_step.
                  READ TABLE ls_filter_select_option-select_options INDEX 1 INTO ls_select_option.
                  IF sy-subrc = 0 AND ( ls_select_option-low IS INITIAL OR ls_select_option-low = 'null' )
                    OR sy-subrc <> 0.
                    CONTINUE.
                  ENDIF.

                ENDIF.
                lt_filter = VALUE #( BASE lt_filter
                                     FOR <fs_select_options> IN ls_filter_select_option-select_options
                                     ( field = ls_filter_select_option-property
                                       sign  = <fs_select_options>-sign
                                       oper  = <fs_select_options>-option
                                       low   = <fs_select_options>-low
                                       high  = <fs_select_options>-high
                                      )
                                     ).
              WHEN co_abap_migration_inst_filter.
                READ TABLE ls_filter_select_option-select_options ASSIGNING <ls_select_option> INDEX 1.
                IF sy-subrc EQ 0.
                  /ui2/cl_json=>deserialize(
                    EXPORTING
                      json = <ls_select_option>-low
                      pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                    CHANGING
                      data = lt_select_filter ).
                  LOOP AT lt_select_filter ASSIGNING FIELD-SYMBOL(<ls_select_filter>).
                    lt_filter = VALUE #( BASE lt_filter
                         FOR <ls_range> IN <ls_select_filter>-selopt_t
                         ( field = <ls_select_filter>-fieldname
                           sign  = <ls_range>-sign
                           oper  = <ls_range>-option
                           low   = <ls_range>-low
                           high  = <ls_range>-high
                          )
                         ).
                  ENDLOOP.
                ENDIF.
              WHEN OTHERS.
                IF ls_filter_select_option-property CP 'RESULT*'.
                  READ TABLE lt_itemlist_metadata ASSIGNING FIELD-SYMBOL(<ls_itemlist_metadata>) WITH KEY fieldname = ls_filter_select_option-property.
                  IF sy-subrc = 0.
                    lt_filter = VALUE #( BASE lt_filter
                         FOR <fs_select_options> IN ls_filter_select_option-select_options
                         ( field = <ls_itemlist_metadata>-ori_name
                           sign  = <fs_select_options>-sign
                           oper  = <fs_select_options>-option
                           low   = <fs_select_options>-low
                           high  = <fs_select_options>-high
                          )
                         ).
                  ENDIF.
                ELSE.
                  CHECK strlen( ls_filter_select_option-property ) GT 9 AND
                        ls_filter_select_option-property(9) = lco_fieldname_prefix.
                  DATA(lv_position) = ls_filter_select_option-property+9.
                  DATA(lv_index) = CONV i( lv_position ).

                  READ TABLE lt_itemlist_metadata ASSIGNING <ls_itemlist_metadata> INDEX lv_index.
                  IF sy-subrc = 0.
                    lt_filter = VALUE #( BASE lt_filter
                         FOR <fs_select_options> IN ls_filter_select_option-select_options
                         ( field = <ls_itemlist_metadata>-fieldname
                           sign  = <fs_select_options>-sign
                           oper  = <fs_select_options>-option
                           low   = <fs_select_options>-low
                           high  = <fs_select_options>-high
                          )
                         ).
                  ENDIF.
                ENDIF.
            ENDCASE.
          ENDLOOP.
*         Set filter for instance
          IF lt_inst_uuid IS NOT INITIAL.
            lo_obj_ctx->set_item_uuid(
              EXPORTING
                it_item_uuid = lt_inst_uuid
            ).
          ENDIF.
*         Set filter for key fields, action and status
          IF lt_filter IS NOT INITIAL.
            lo_obj_ctx->set_filter_cond( lt_filter ).
          ENDIF.
*         Set fulltext search
          IF iv_search_string IS NOT INITIAL.
            lo_obj_ctx->set_fulltext_search( iv_search_string ).
          ENDIF.
*         Set sort by and sort order
          LOOP AT it_order ASSIGNING FIELD-SYMBOL(<fs_order>).
            CASE <fs_order>-property.
              WHEN co_migration_inst_status.
                lt_order = VALUE #( BASE lt_order
                                    ( property = lco_item_status
                                      order =  COND #( WHEN <fs_order>-order = co_sort_descending THEN /ltb/if_mc_constants=>gc_sort_order-descending
                                                                 ELSE /ltb/if_mc_constants=>gc_sort_order-ascending ) ) ).
              WHEN co_migration_inst_action.
                lt_order = VALUE #( BASE lt_order
                                    ( property = lco_item_action
                                      order =  COND #( WHEN <fs_order>-order = co_sort_descending THEN /ltb/if_mc_constants=>gc_sort_order-descending
                                                                 ELSE /ltb/if_mc_constants=>gc_sort_order-ascending ) ) ).
              WHEN co_migration_inst_grp_ind.
                lt_order = VALUE #( BASE lt_order
                                    ( property = lco_group_indicator
                                      order =  COND #( WHEN <fs_order>-order = co_sort_descending THEN /ltb/if_mc_constants=>gc_sort_order-descending
                                                                 ELSE /ltb/if_mc_constants=>gc_sort_order-ascending ) ) ).
              WHEN OTHERS.
                CHECK to_upper( <fs_order>-property(9) ) = lco_fieldname_prefix.

                lv_position = <fs_order>-property+9.
                lv_index = CONV i( lv_position ).

                READ TABLE lt_itemlist_metadata ASSIGNING <ls_itemlist_metadata> INDEX lv_index.
                IF sy-subrc = 0.
                  lt_order = VALUE #( BASE lt_order
                                      ( property = <ls_itemlist_metadata>-fieldname
                                        order =  COND #( WHEN <fs_order>-order = co_sort_descending THEN /ltb/if_mc_constants=>gc_sort_order-descending
                                                                   ELSE /ltb/if_mc_constants=>gc_sort_order-ascending ) ) ).
                ENDIF.
            ENDCASE.
          ENDLOOP.

          IF lt_order IS NOT INITIAL.
            lo_obj_ctx->set_sort_order( it_orders =  lt_order ).
          ENDIF.
          IF lv_displayoption = /ltb/if_mc_constants=>gc_instance_display_option-standard.
            "Get itemlist data
            lo_object_proxy->get_itemlist_data(
              EXPORTING
                io_cntxt = lo_obj_ctx
              IMPORTING
                et_data  = lt_itemlist_data
                ev_count = DATA(lv_count) ).
          ELSE.
            "Get resultlist data
            lo_object_proxy->get_resultlist_data(
              EXPORTING
                io_cntxt = lo_obj_ctx
              IMPORTING
                et_data  = lt_itemlist_data
                ev_count = lv_count ).
          ENDIF.

          LOOP AT lt_itemlist_data INTO DATA(ls_itemlist_data) ##INTO_OK.
            CLEAR ls_entity.
            ls_entity-migrationprojectuuid     = lv_proj_uuid.
            ls_entity-migrationobjectuuid      = lv_obj_uuid.
            ls_entity-migrationinstanceuuid    = ls_itemlist_data-item_uuid.
            ls_entity-migrationobjectname      = ls_obj_detail-migobj_descr.
            ls_entity-migrationobjectdescr     = ls_obj_detail-migobj_doc_descr.
            ls_entity-migrationinstancestatus  = ls_itemlist_data-item_status.
            ls_entity-statusdescription        = ls_itemlist_data-item_status_desc.
            ls_entity-action                   = ls_itemlist_data-item_action.
            ls_entity-actiondescription        = ls_itemlist_data-item_action_desc.
            ls_entity-groupindicator           = ls_itemlist_data-item_group_indicator.
            ls_entity-displayoption            = lv_displayoption.
            ls_entity-optionid                 = ls_itemlist_data-item_option_id.
            ls_entity-optiondescr              = ls_itemlist_data-item_option_full.
            ls_entity-optionseq                = ls_itemlist_data-item_option_seq.
            ls_entity-step                     = ls_itemlist_data-item_step.
            ls_entity-stepdescr                = ls_itemlist_data-item_step_full.
            ls_entity-stepdescrvalid           = ls_itemlist_data-item_descr_valid.

            ASSIGN ls_itemlist_data-item_data->* TO <fs_itemdata>.
            IF sy-subrc = 0.
              MOVE-CORRESPONDING <fs_itemdata> TO ls_entity.
              "Set ItemField 1~14 according to its position from metadata
              LOOP AT lt_itemlist_metadata ASSIGNING <ls_itemlist_metadata>.
                IF <ls_itemlist_metadata>-position > lco_fieldcount.
                  EXIT.
                ENDIF.
                DATA(lv_fieldname) = lco_fieldname_prefix && <ls_itemlist_metadata>-position.
                ASSIGN COMPONENT lv_fieldname OF STRUCTURE ls_entity TO <fv_itemfield>.
                IF sy-subrc = 0.
                  IF <ls_itemlist_metadata>-fieldname CP 'RESULT*'.
                    CONTINUE.
                  ELSE.
                    ASSIGN COMPONENT <ls_itemlist_metadata>-fieldname OF STRUCTURE <fs_itemdata> TO <fv_fieldvalue>.
                    IF sy-subrc = 0.
                      <fv_itemfield> = CONV #( <fv_fieldvalue> ).
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDLOOP.
            ENDIF.
            ls_entity-instancetitle = ls_itemlist_data-item_name.
            APPEND ls_entity TO et_entityset.
          ENDLOOP.

*       Handle inline count
          IF io_tech_request_context->has_inlinecount( ) = abap_true.
            es_response_context-inlinecount = lv_count.
          ENDIF.
          IF io_tech_request_context->has_count( ) = abap_true.
            es_response_context-count = lv_count.
          ENDIF.
        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages ).

        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD migrationobjec01_get_entityset.

    DATA: ls_object               TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          lv_proj_uuid            TYPE /ltb/mc_proj_uuid,
          lv_prod_proj_uuid       TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid             TYPE /ltb/mc_object_uuid,
          lo_tmpl_proxy           TYPE REF TO /ltb/if_mc_tmpl_proxy,
          lt_dependencies         TYPE /ltb/if_mc_constants=>gtt_migobj_dependency,
          lv_approach             TYPE /ltb/mc_approach,
          lv_scenario             TYPE /ltb/mc_scenario,
          lv_dependenttype        TYPE char1,
          ls_filter_select_option TYPE /iwbep/s_mgw_select_option,
          ls_filter_option        TYPE /iwbep/s_cod_select_option,
          lt_obj_uuid             TYPE /ltb/mc_t_object_uuid,
          lo_obj_proxy_pe         TYPE REF TO /ltb/cl_mc_obj_proxy_pe,
          lv_skip                 TYPE int4,
          lv_top                  TYPE int4,
          lo_obj_pe               TYPE REF TO cl_cnv_pe_area.

    CLEAR es_response_context.
    CLEAR et_entityset.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_object
    ).

    "lv_proj_uuid is the template project when copying project
    lv_proj_uuid = ls_object-migrationprojectuuid.
    lv_obj_uuid = ls_object-migrationobjectuuid.

    READ TABLE it_filter_select_options WITH KEY property = co_filter_approachfortemplate INTO ls_filter_select_option.
    IF sy-subrc = 0.
      READ TABLE ls_filter_select_option-select_options INTO ls_filter_option INDEX 1.
      lv_approach = ls_filter_option-low.
    ENDIF.

    READ TABLE it_filter_select_options WITH KEY property = co_filter_scenariofortemplate INTO ls_filter_select_option.
    IF sy-subrc = 0.
      READ TABLE ls_filter_select_option-select_options INTO ls_filter_option INDEX 1.
      lv_scenario = ls_filter_option-low.
    ENDIF.

    IF lv_scenario IS INITIAL.
      lv_scenario = /ltb/if_mc_constants=>gc_scenario-default.
    ENDIF.

    READ TABLE it_filter_select_options WITH KEY property = co_filter_dependenttype INTO ls_filter_select_option.
    IF sy-subrc = 0.
      READ TABLE ls_filter_select_option-select_options INTO ls_filter_option INDEX 1.
      lv_dependenttype = ls_filter_option-low.
    ENDIF.

    IF line_exists( it_filter_select_options[ property = co_migration_object_uuid ] ).
      DATA(lt_select_option) = it_filter_select_options[ property = co_migration_object_uuid ]-select_options.
      lt_obj_uuid = VALUE #( FOR select_option IN lt_select_option ( CONV #( select_option-low ) ) ).
    ENDIF.

    IF line_exists( it_filter_select_options[ property = co_dependencylevel ] ).
      lt_select_option = it_filter_select_options[ property = co_dependencylevel ]-select_options.
      IF lt_select_option[ 1 ]-low = gc_dependency_level-all.
        DATA(lv_all_dependency_level) = abap_true.
      ENDIF.
    ENDIF.

    "lv_prod_proj_uuid is the productive project when editing project
    READ TABLE it_filter_select_options WITH KEY property = co_filter_prodprojectuuid INTO ls_filter_select_option.
    IF sy-subrc = 0.
      READ TABLE ls_filter_select_option-select_options INTO ls_filter_option INDEX 1.
      IF sy-subrc = 0.
        lv_prod_proj_uuid = ls_filter_option-low.
      ENDIF.
    ENDIF.

    lv_skip = is_paging-skip.
    lv_top  = is_paging-top.

    TRY.
        "application proxy
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).

        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        "bind message container
        DATA(lo_msg_container) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
        lo_cntxt_proj->set_msg_container( NEW /ltb/cl_mc_msg_cont_iwbep_adap( lo_msg_container ) ).

        "lv_proj_uuid is the template project when copying project
        IF lv_proj_uuid = co_undefined OR lv_proj_uuid IS INITIAL.
          IF lv_approach IS NOT INITIAL AND lv_scenario IS NOT INITIAL.
            lo_cntxt_proj->set_approach( lv_approach ).
            lo_cntxt_proj->set_scenario( lv_scenario ).

            IF lv_obj_uuid IS NOT INITIAL.
              IF lv_approach EQ /ltb/if_mc_constants=>gc_approach-sap_direct.
                "For a PE project, there may be multiple MOs copied from one template
                "if given object uuid is a productive MO id, transform it to its template id
                TRY .
                    lo_obj_pe ?= cl_cnv_pe_obj_factory=>create_area( iv_area_id = lv_obj_uuid ).
                    IF lo_obj_pe->get_usage_type( ) EQ cl_cnv_pe_area=>gc_usage_type_proj.
                      lv_obj_uuid = lo_obj_pe->get_root_template_id( ).
                    ENDIF.
                  CATCH cx_cnv_pe_generic
                        cx_cnv_pe_object_error
                        /ltb/cx_bas_auth_error
                        /ltb/cx_tr_trule_error
                        .
                    "nothing
                ENDTRY.
              ENDIF.
              APPEND lv_obj_uuid TO lt_obj_uuid.
            ENDIF.

            lo_cntxt_proj->set_selected_migration_obj( lt_obj_uuid ).
            lo_cntxt_proj->set_dependency_level( iv_all_level = lv_all_dependency_level ).

            IF lv_prod_proj_uuid IS NOT INITIAL.
              lo_cntxt_proj->set_proj_uuid( lv_prod_proj_uuid ).
            ENDIF.

            lo_tmpl_proxy = lo_appl_proxy->get_tmpl_proxy_by_appr_scen( lo_cntxt_proj ).
            lt_dependencies  = lo_tmpl_proxy->get_migobj_dependencies( lo_cntxt_proj ).
          ENDIF.
        ELSE.
          DATA(lo_proj_proxy) = lo_appl_proxy->get_proj_proxy_by_uuid( lv_proj_uuid ).
          DATA(lo_obj_proxy)  = lo_proj_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).
*          lo_obj_proxy_pe     ?= lo_obj_proxy.
*          lt_dependencies     = lo_obj_proxy_pe->get_dep_status( lo_cntxt_proj ).
          lt_dependencies     = lo_obj_proxy->get_dependencies( lo_cntxt_proj ).
        ENDIF.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        DATA(lt_mc_messages) = lo_exception->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    "filter by dependent type
    IF lv_dependenttype IS NOT INITIAL.
      DELETE lt_dependencies WHERE dep_type <> lv_dependenttype.
    ENDIF.
    "Inline count
    es_response_context-inlinecount = lines( lt_dependencies ).
    "Paging
    SORT lt_dependencies BY dep_type migobj_descr.
    IF lv_skip IS NOT INITIAL OR lv_top IS NOT INITIAL.
      DATA(lv_end) = lv_skip + lv_top + 1.
      DELETE lt_dependencies FROM lv_end.
      IF lv_skip IS NOT INITIAL.
        DELETE lt_dependencies TO lv_skip.
      ENDIF.
    ENDIF.

    "output
    et_entityset = VALUE #( FOR <item> IN lt_dependencies
      (
        dependencytype = SWITCH #( <item>-dep_type
                         WHEN /ltb/if_mc_constants=>gc_dependency_type-predecessor THEN get_text( EXPORTING iv_id = 'DTP')
                         WHEN /ltb/if_mc_constants=>gc_dependency_type-successor   THEN get_text( EXPORTING iv_id = 'DTS') )

        dependencystatus = SWITCH #( <item>-dep_done
                           WHEN abap_true  THEN get_text( EXPORTING iv_id = 'DSD')
                           WHEN abap_false THEN get_text( EXPORTING iv_id = 'DSI') )

        migrationobjectuuid = lv_obj_uuid
        migrationobjectname = <item>-migobj_name
        migrationobjectdescription = <item>-migobj_descr
        dependentmigrationobjectuuid = <item>-migobj_uuid
        migrationprojectuuid = lv_proj_uuid
        lifecyclestate       = <item>-lifecycle_state
      )
    ).

  ENDMETHOD.


  METHOD migrationobjec02_get_entity.

    DATA: ls_history   TYPE /ltb/if_mc_constants=>gty_history,
          lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid,
          lv_act_uuid  TYPE /ltb/mc_act_uuid,
          ls_key_pair  TYPE /iwbep/s_mgw_name_value_pair,
          lv_limit     TYPE int1,
          lv_offset    TYPE int4.

    CONSTANTS: lco_max_item_count TYPE int4 VALUE 10.

    CLEAR es_response_context.
    CLEAR er_entity.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
    IF sy-subrc = 0.
      lv_proj_uuid = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
    IF sy-subrc = 0.
      lv_obj_uuid = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_obj_history_uuid.
    IF sy-subrc = 0.
      lv_act_uuid  = ls_key_pair-value.
    ENDIF.

    "start main process
    TRY.
        "application proxy
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).

        "project proxy
        DATA(lo_proj_proxy) = lo_appl_proxy->get_proj_proxy_by_uuid( lv_proj_uuid ).

        "Project approach
        DATA(ls_mc_proj) = /ltb/cl_mc_proj_access=>get_by_uuid( lv_proj_uuid ).
        DATA(lv_approach)   = ls_mc_proj-approach.

        "migration object proxy
        DATA(lo_obj_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).


        "get history table
        DATA(lo_obj_cntxt) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        IF lv_act_uuid IS NOT INITIAL.
          lo_obj_cntxt->set_act_uuid( iv_act_uuid = lv_act_uuid ).
        ENDIF.

        lo_obj_proxy->get_history(
          EXPORTING io_cntxt = lo_obj_cntxt
          IMPORTING et_history = DATA(lt_history)
                    ev_count = DATA(lv_count) ).

        IF lt_history IS NOT INITIAL.
          READ TABLE lt_history INTO ls_history INDEX 1.

          "get other needed fields
          DATA(ls_obj_detail) = lo_obj_proxy->get_details( io_cntxt = lo_obj_cntxt ).
        ENDIF.

        er_entity   = VALUE #(
                    migrationprojectuuid = lv_proj_uuid
                    migrationobjectuuid = lv_obj_uuid
                    migrationobjecthistoryuuid = lv_act_uuid
                    migrationobjecthistorytype = ls_history-event_type_desc
                    startedby = ls_history-started_by_name
                    startedat = ls_history-started_at
                    finishedat = ls_history-finished_at
                    appllognr = ls_history-appl_lognr
                    appllogty = ls_history-appl_logty
                    migrationobjecthistorystatus = ls_history-event_status
                    migrationobjectname = ls_obj_detail-migobj_descr
                    ) .

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationobjec02_get_entityset.

    DATA: ls_object    TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid,
          lv_limit     TYPE int4,
          lv_offset    TYPE int4.

    CONSTANTS: lco_max_item_count TYPE int4 VALUE 255.

    CLEAR es_response_context.
    CLEAR et_entityset.

    io_tech_request_context->get_converted_source_keys(
    IMPORTING
      es_key_values = ls_object
    ).

    lv_proj_uuid = ls_object-migrationprojectuuid.
    lv_obj_uuid = ls_object-migrationobjectuuid.

    "Handle paging, at most one page contains 10 items
    IF is_paging-top > lco_max_item_count.
      lv_limit = lco_max_item_count.
    ELSE.
      lv_limit = is_paging-top.
    ENDIF.
    lv_offset = is_paging-skip.

    "start main process
    TRY.
        "application proxy
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).

        "project proxy
        DATA(lo_proj_proxy) = lo_appl_proxy->get_proj_proxy_by_uuid( lv_proj_uuid ).

        "Project approach
        DATA(ls_mc_proj) = /ltb/cl_mc_proj_access=>get_by_uuid( lv_proj_uuid ).
        DATA(lv_approach)   = ls_mc_proj-approach.

        "migration object proxy
        DATA(lo_obj_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

        "get history table
        DATA(lo_obj_cntxt) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        IF lv_limit <> 0 OR lv_offset <> 0.
          lo_obj_cntxt->set_page( iv_offset = lv_offset iv_limit = lv_limit ).
        ENDIF.

        lo_obj_proxy->get_history(
          EXPORTING io_cntxt = lo_obj_cntxt
          IMPORTING et_history = DATA(lt_history)
                    ev_count = DATA(lv_count) ).

        "Handle inline count
        IF io_tech_request_context->has_inlinecount( ) = abap_true.
          es_response_context-inlinecount = lv_count.
        ENDIF.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    et_entityset = VALUE #( FOR <item> IN lt_history
      (
        migrationprojectuuid = lv_proj_uuid
        migrationobjectuuid = lv_obj_uuid
        migrationobjecthistoryuuid = <item>-act_uuid
        migrationobjecthistorytype = <item>-event_type_desc
        startedby = <item>-started_by_name
        startedat = <item>-started_at
        finishedat = <item>-finished_at
        appllognr = <item>-appl_lognr
        appllogty = <item>-appl_logty
        migrationobjecthistorystatus = <item>-event_status )
      ).

  ENDMETHOD.


  METHOD migrationobjec03_get_entityset.

    DATA: ls_object          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          lv_documentid      TYPE doku_obj,
          lt_html            TYPE htmltable,
          lv_document_string TYPE string,
          lv_proj_uuid       TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid        TYPE /ltb/mc_object_uuid,
          ls_filter_request  TYPE /iwbep/s_mgw_select_option,
          ls_filter_option   TYPE /iwbep/s_cod_select_option.

    CLEAR es_response_context.
    CLEAR et_entityset.

    io_tech_request_context->get_converted_source_keys(
    IMPORTING
      es_key_values = ls_object
    ).

    lv_proj_uuid = ls_object-migrationprojectuuid.
    lv_obj_uuid = ls_object-migrationobjectuuid.

    READ TABLE it_filter_select_options INTO ls_filter_request WITH KEY property = co_document_id.
    IF sy-subrc = 0.
      READ TABLE ls_filter_request-select_options INTO ls_filter_option INDEX 1.
      lv_documentid = ls_filter_option-low.
      IF lv_documentid IS NOT INITIAL.
        lv_document_string = /ltb/cl_mc_odata_generic_func=>get_document_as_string( lv_documentid ).
      ENDIF.
    ENDIF.
    "output
    et_entityset = VALUE #(
      (
        migrationobjectuuid = lv_obj_uuid
        migrationprojectuuid = lv_proj_uuid
        documentid = lv_documentid
        content = lv_document_string )
      ).

  ENDMETHOD.


  METHOD migrationobjec04_get_entityset.

    DATA: ls_object               TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          lv_proj_uuid            TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid             TYPE /ltb/mc_object_uuid,
          lo_tmpl_proxy           TYPE REF TO /ltb/if_mc_tmpl_proxy,
          lt_projects             TYPE /ltb/if_mc_constants=>gtt_used_by_project,
          lv_approach             TYPE /ltb/mc_approach,
          lv_scenario             TYPE /ltb/mc_scenario,
          ls_filter_select_option TYPE /iwbep/s_mgw_select_option,
          ls_filter_option        TYPE /iwbep/s_cod_select_option,
          lt_obj_uuid             TYPE /ltb/mc_t_object_uuid.

    CLEAR es_response_context.
    CLEAR et_entityset.

    io_tech_request_context->get_converted_source_keys(
    IMPORTING
      es_key_values = ls_object
    ).

    lv_proj_uuid = ls_object-migrationprojectuuid.
    lv_obj_uuid = ls_object-migrationobjectuuid.

    READ TABLE it_filter_select_options WITH KEY property = co_filter_approachfortemplate INTO ls_filter_select_option.
    IF sy-subrc = 0.
      READ TABLE ls_filter_select_option-select_options INTO ls_filter_option INDEX 1.
      lv_approach = ls_filter_option-low.
    ENDIF.

    READ TABLE it_filter_select_options WITH KEY property = co_filter_scenariofortemplate INTO ls_filter_select_option.
    IF sy-subrc = 0.
      READ TABLE ls_filter_select_option-select_options INTO ls_filter_option INDEX 1.
      lv_scenario = ls_filter_option-low.
    ENDIF.

    TRY.
        "application proxy
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).

        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        "bind message container
        DATA(lo_msg_container) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
        lo_cntxt_proj->set_msg_container( NEW /ltb/cl_mc_msg_cont_iwbep_adap( lo_msg_container ) ).

        IF lv_proj_uuid = co_undefined OR lv_proj_uuid IS INITIAL.
          IF lv_approach IS NOT INITIAL AND lv_scenario IS NOT INITIAL.
            lo_cntxt_proj->set_approach( lv_approach ).
            lo_cntxt_proj->set_scenario( lv_scenario ).

            APPEND lv_obj_uuid TO lt_obj_uuid.
            lo_cntxt_proj->set_selected_migration_obj( lt_obj_uuid ).

            lo_tmpl_proxy = lo_appl_proxy->get_tmpl_proxy_by_appr_scen( lo_cntxt_proj ).
            lt_projects  = lo_tmpl_proxy->get_migobj_used_by_projects( lo_cntxt_proj ).
          ENDIF.
        ELSE.
          DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
          DATA(lo_obj_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).
          lt_projects = lo_obj_proxy->get_used_by_projects( lo_cntxt_proj ).
        ENDIF.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    "output
    et_entityset = VALUE #( FOR <item> IN lt_projects
      (
        migrationobjectuuid = lv_obj_uuid
        migrationprojectuuid = <item>-proj_uuid
        migrationprojectname = <item>-proj_name )
      ).

  ENDMETHOD.


  METHOD migrationobjec05_get_entityset.

    DATA: ls_object    TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid.

    CLEAR es_response_context.
    CLEAR et_entityset.

    io_tech_request_context->get_converted_source_keys(
    IMPORTING
      es_key_values = ls_object
    ).

    lv_proj_uuid = ls_object-migrationprojectuuid.
    lv_obj_uuid = ls_object-migrationobjectuuid.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = lv_obj_uuid ).
        DATA(lo_obj_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        DATA(ls_object_statistics) = lo_object_proxy->get_statistics( io_cntxt = lo_obj_context ).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    IF ls_object_statistics-num_items_migrated + ls_object_statistics-num_items_simulated +
       ls_object_statistics-num_items_simulated_err + ls_object_statistics-num_items_migrated_err +
       ls_object_statistics-num_items_open = 0.
      RETURN.
    ENDIF.

    APPEND VALUE #(
        migrationprojectuuid = ls_object-migrationprojectuuid
        migrationobjectuuid = ls_object-migrationobjectuuid
        name = co_piechart_status_migrated
        number = ls_object_statistics-num_items_migrated
    ) TO et_entityset.

    APPEND VALUE #(
        migrationprojectuuid = ls_object-migrationprojectuuid
        migrationobjectuuid = ls_object-migrationobjectuuid
        name = co_piechart_status_simulated
        number = ls_object_statistics-num_items_simulated
    ) TO et_entityset.

    APPEND VALUE #(
        migrationprojectuuid = ls_object-migrationprojectuuid
        migrationobjectuuid = ls_object-migrationobjectuuid
        name = co_piechart_status_error
        number = ls_object_statistics-num_items_simulated_err + ls_object_statistics-num_items_migrated_err
    ) TO et_entityset.

    APPEND VALUE #(
        migrationprojectuuid = ls_object-migrationprojectuuid
        migrationobjectuuid = ls_object-migrationobjectuuid
        name = co_piechart_status_open
        number = ls_object_statistics-num_items_open
    ) TO et_entityset.

  ENDMETHOD.


  METHOD migrationobjec06_get_entityset.
    DATA: lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid.

    DATA: ls_filter_request TYPE /iwbep/s_mgw_select_option,
          ls_filter_option  TYPE /iwbep/s_cod_select_option,
          lt_filter         TYPE /ltb/if_mc_constants=>gtt_filter_cond,
          ls_entityset      TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectmessagecount.

    DATA: ls_filter         TYPE /ltb/if_mc_constants=>gty_filter_cond,
          lt_order          TYPE /ltb/if_mc_constants=>gtt_sort_order,
          ls_order          TYPE /ltb/if_mc_constants=>gty_sort_order,
          lv_instance_count TYPE int4.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF it_filter_select_options IS INITIAL AND iv_filter_string IS NOT INITIAL.
      DATA(lt_filter_select_options) = get_complex_filter_sel_option(
        EXPORTING
          io_tech_request_context = io_tech_request_context
          iv_entity_name          = iv_entity_name ).
    ELSE.
      lt_filter_select_options = it_filter_select_options.
    ENDIF.

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobjectmessagecount.
      LOOP AT lt_filter_select_options INTO ls_filter_request ##INTO_OK.
        CASE ls_filter_request-property.
          WHEN co_migration_project_uuid.
            READ TABLE ls_filter_request-select_options INTO ls_filter_option INDEX 1.
            IF sy-subrc EQ 0.
              lv_proj_uuid = ls_filter_option-low.
              ls_entityset-migrationprojectuuid = ls_filter_option-low.
            ENDIF.

          WHEN co_migration_object_uuid.
            READ TABLE ls_filter_request-select_options INTO ls_filter_option INDEX 1.
            IF sy-subrc EQ 0.
              ls_entityset-migrationobjectuuid = ls_filter_option-low.
              lv_obj_uuid = ls_filter_option-low.
            ENDIF.

          WHEN co_action_uuid.
            "filter options
            lt_filter = VALUE #( BASE lt_filter
                    FOR <filter> IN ls_filter_request-select_options
                    (
                      field = 'ITEM_ACTION'
                      sign  = <filter>-sign
                      oper  = <filter>-option
                      low   = <filter>-low
                      high  = <filter>-high )
                    ).

          WHEN co_message_type.
            "filter options
            lt_filter = VALUE #( BASE lt_filter
                    FOR <filter> IN ls_filter_request-select_options
                    (
                      field = 'ITEM_STATUS'
                      sign  = <filter>-sign
                      oper  = <filter>-option
                      low   = <filter>-low
                      high  = <filter>-high )
                    ).

          WHEN co_message_no.
            "filter options
            lt_filter = VALUE #( BASE lt_filter
                    FOR <filter> IN ls_filter_request-select_options
                    (
                      field = 'MSGNO'
                      sign  = <filter>-sign
                      oper  = <filter>-option
                      low   = <filter>-low
                      high  = <filter>-high )
                    ).


          WHEN co_message_id.
            "filter options
            lt_filter = VALUE #( BASE lt_filter
                    FOR <filter> IN ls_filter_request-select_options
                    (
                      field = 'MSGID'
                      sign  = <filter>-sign
                      oper  = <filter>-option
                      low   = <filter>-low
                      high  = <filter>-high )
                    ).

        ENDCASE.
      ENDLOOP.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
          DATA(lo_obj_ctx)       = NEW /ltb/cl_mc_cntxt_obj_detail( ).
          DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).
*       Set filter for key fields, action and status
          IF lt_filter IS NOT INITIAL.
            lo_obj_ctx->set_filter_cond( lt_filter ).
          ENDIF.
**       Set fulltext search
*          IF iv_search_string IS NOT INITIAL.
*            lo_obj_ctx->set_fulltext_search( iv_search_string ).
*          ENDIF.
**       Set sort by and sort order
*
*          IF lt_order IS NOT INITIAL.
*            lo_obj_ctx->set_sort_order( it_orders =  lt_order ).
*          ENDIF.

*         Get mo instances count
          lv_instance_count = lo_object_proxy->get_mo_instance_count( EXPORTING io_cntxt = lo_obj_ctx ).
          ls_entityset-instancecount = lv_instance_count.
          APPEND ls_entityset TO et_entityset.
        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD migrationobjec07_get_entityset.
    DATA: lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid,
          ls_object    TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          ls_entity    TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectinprocess.
    io_tech_request_context->get_converted_source_keys(
    IMPORTING
      es_key_values = ls_object
    ).

    lv_proj_uuid = ls_object-migrationprojectuuid.
    lv_obj_uuid = ls_object-migrationobjectuuid.

    TRY .
        "application proxy
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).

        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        "bind message container
        DATA(lo_msg_container) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
        lo_cntxt_proj->set_msg_container( NEW /ltb/cl_mc_msg_cont_iwbep_adap( lo_msg_container ) ).

        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
        DATA(lt_mig_objs) = lo_proj_proxy->get_inprocess_obj( io_cntxt = lo_cntxt_proj ).
        LOOP AT lt_mig_objs INTO DATA(ls_mig_obj).
          ls_entity = VALUE #( migrationprojectuuid  = CONV #( ls_mig_obj-project_uuid )
                               migrationobjectuuid = CONV #( ls_mig_obj-migobj_uuid )
                               migrationobjectname = CONV #( ls_mig_obj-migobj_name ) ).
          APPEND ls_entity TO et_entityset.
        ENDLOOP.
      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

    ENDTRY.
  ENDMETHOD.


  METHOD migrationobjec08_get_entityset.
    DATA: lv_proj_uuid      TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid       TYPE /ltb/mc_object_uuid,
          lv_group_uuid     TYPE string,
          lv_msg_group_uuid TYPE /ltb/if_mc_constants=>gty_msg_group_uuid,
          ls_key_pair       TYPE /iwbep/s_mgw_name_value_pair,
          ls_nav_path       TYPE /iwbep/s_mgw_navigation_path,
          lt_instance_uuid  TYPE /ltb/if_mc_constants=>gtt_item_uuid,
          ls_entity         TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationobjectmessagedetai,
          lv_limit          TYPE int1,
          lv_offset         TYPE int4,
          lv_displayoption  TYPE string.
    CONSTANTS:
          lco_max_item_count TYPE int4 VALUE 255.

    CLEAR es_response_context.
    CLEAR et_entityset.

*   get project UUID
    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
    IF sy-subrc = 0.
      lv_proj_uuid = ls_key_pair-value.
    ENDIF.

*   get object UUID
    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
    IF sy-subrc = 0.
      lv_obj_uuid = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_message_group_uuid.
    IF sy-subrc = 0.
      lv_group_uuid = ls_key_pair-value.
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        lo_obj_ctx->set_group_uuid( iv_group_uuid =  lv_group_uuid ).

        " set query context: paging, full search, order, filter
        set_context( iv_entity_set_name = iv_entity_set_name
          is_paging = is_paging
          iv_search_string = iv_search_string
          it_order = it_order
          io_context = lo_obj_ctx ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).
        lo_object_proxy->get_migobj_message_details( EXPORTING io_cntxt = lo_obj_ctx
                                                     IMPORTING et_msg_details = DATA(lt_msg_details)
                                                               ev_count = DATA(lv_count) ).
        LOOP AT lt_msg_details INTO DATA(ls_message_detail).
          ls_entity-migrationprojectuuid = ls_message_detail-migproj_uuid.
          ls_entity-migrationobjectuuid     = ls_message_detail-migobj_uuid.
          ls_entity-messageuuid        = ls_message_detail-message_uuid.
          ls_entity-messagegroupuuid   = lv_group_uuid.
          ls_entity-migrationinstanceuuid = ls_message_detail-instance_uuid.
          ls_entity-messagedatetime       = convert_time_stamp( ls_message_detail-date_and_time ).
          ls_entity-messagetitle      = ls_message_detail-group_title.
          get_longtext_from_msg(
            EXPORTING
              iv_msgid = ls_message_detail-msgid
              iv_msgno = ls_message_detail-msgno
              iv_msgv1 = ls_message_detail-msgv1
              iv_msgv2 = ls_message_detail-msgv2
              iv_msgv3 = ls_message_detail-msgv3
              iv_msgv4 = ls_message_detail-msgv4
            IMPORTING
              ev_is_longtext_exist = ls_entity-islongtextexist
            RECEIVING
              rv_htmlstring        = ls_entity-messagelongtext
          ).
          ls_entity-instancekey       = ls_message_detail-instance_key.
          ls_entity-instancekeyjson   = ls_message_detail-instance_key_json.
          APPEND ls_entity TO et_entityset.
        ENDLOOP.
        IF io_tech_request_context->has_inlinecount( ) = abap_true.
          es_response_context-inlinecount = lv_count.
        ENDIF.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationobjec09_get_entityset.
    DATA ls_project TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationproject.

    CLEAR es_response_context.
    CLEAR et_entityset.

    io_tech_request_context->get_converted_source_keys( IMPORTING es_key_values = ls_project ).

    TRY.
        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        "bind message container
        DATA(lo_msg_container) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
        lo_cntxt_proj->set_msg_container( NEW /ltb/cl_mc_msg_cont_iwbep_adap( lo_msg_container ) ).
        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_project-migrationprojectuuid ).

        " set query context: paging, full search, order, filter
        set_context( iv_entity_set_name       = iv_entity_set_name
                     is_paging                = is_paging
                     iv_search_string         = iv_search_string
                     it_order                 = it_order
                     it_filter_select_options = it_filter_select_options
                     io_context               = lo_cntxt_proj ).

        "Get migration object job number
        lo_proj_proxy->get_migobj_job_num( EXPORTING io_cntxt          = lo_cntxt_proj
                                           IMPORTING et_migobj_job_num = et_entityset ).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationobjec10_get_entity.
    DATA: ls_object    TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid.

    io_tech_request_context->get_converted_source_keys(
    IMPORTING
      es_key_values = ls_object
    ).

    lv_proj_uuid = ls_object-migrationprojectuuid.
    lv_obj_uuid = ls_object-migrationobjectuuid.


    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

        DATA(ls_current_view) = lo_object_proxy->get_current_view( ).

        er_entity-migrationprojectuuid = lv_proj_uuid.
        er_entity-migrationobjectuuid = lv_obj_uuid.
        er_entity-activeviewname = ls_current_view-view_name.
        er_entity-activeviewdescription = ls_current_view-view_desc.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.



  ENDMETHOD.


  METHOD migrationobjec10_update_entity.
    DATA: ls_new_view      TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectcurrentview,
          lv_proj_uuid     TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid      TYPE /ltb/mc_object_uuid,
          lv_new_view_name TYPE string,
          lt_mc_messages   TYPE cnv_mbt_t_bal_s_msg.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_new_view ).
    lv_proj_uuid = ls_new_view-migrationprojectuuid.
    lv_obj_uuid =  ls_new_view-migrationobjectuuid.
    lv_new_view_name = ls_new_view-activeviewname.

    DATA(lo_msg_container) = me->mo_context->get_message_container( ).

    IF /ltb/cl_ext_cls_factory=>get_cos_utilities( )->is_cloud( ) = abap_false AND /ltb/cl_bas_utils=>is_system_editable( ) = abap_false.
      "System is not modifiable
      lo_msg_container->add_message(
          iv_msg_type               =  /iwbep/if_message_container=>gcs_message_type-error
          iv_msg_id                 =  '/LTB/MC'
          iv_msg_number             =  '321'
          iv_entity_type            =  iv_entity_name
          iv_add_to_response_header =  abap_true
      ).
      RETURN.
    ENDIF.

    IF lv_new_view_name IS INITIAL.
      "Active view is a mandatory field;please select an active view
      lo_msg_container->add_message(
          iv_msg_type               =  /iwbep/if_message_container=>gcs_message_type-error
          iv_msg_id                 =  '/LTB/MC'
          iv_msg_number             =  '203'
          iv_entity_type            =  iv_entity_name
          iv_add_to_response_header =  abap_true
      ).
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

        DATA(ls_current_view) = lo_object_proxy->get_current_view( ).

        IF ls_current_view-view_name <> lv_new_view_name.
          DATA(lo_obj_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
          lo_obj_context->set_migobj_view( lv_new_view_name ).
          IF lo_object_proxy->is_data_exist( lo_obj_context ) = abap_true.
            "This migration object contains data;the active view will not be changed
            lo_msg_container->add_message(
                iv_msg_type               =  /iwbep/if_message_container=>gcs_message_type-error
                iv_msg_id                 =  '/LTB/MC'
                iv_msg_number             =  '201'
                iv_entity_type            =  iv_entity_name
                iv_add_to_response_header =  abap_true
            ).
          ELSE.
            lo_object_proxy->set_migobj_view( EXPORTING
                                                io_cntxt = lo_obj_context
                                              IMPORTING
                                                et_msg = lt_mc_messages ).

            LOOP AT lt_mc_messages ASSIGNING FIELD-SYMBOL(<fs_mc_message>).
              lo_msg_container->add_message(
                  iv_msg_type               =  <fs_mc_message>-msgty
                  iv_msg_id                 =  <fs_mc_message>-msgid
                  iv_msg_number             =  <fs_mc_message>-msgno
                  iv_msg_v1                 = <fs_mc_message>-msgv1
                  iv_msg_v2                 = <fs_mc_message>-msgv2
                  iv_msg_v3                 = <fs_mc_message>-msgv3
                  iv_msg_v4                 = <fs_mc_message>-msgv4
                  iv_entity_type            =  iv_entity_name
                  iv_add_to_response_header =  abap_true
              ).
            ENDLOOP.
          ENDIF.
        ENDIF.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        lt_mc_messages = lx_proxy_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationobjec11_get_entityset.
    DATA: ls_object    TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid.

    io_tech_request_context->get_converted_source_keys(
    IMPORTING
      es_key_values = ls_object
    ).

    lv_proj_uuid = ls_object-migrationprojectuuid.
    lv_obj_uuid = ls_object-migrationobjectuuid.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

        DATA(lt_available_views) = lo_object_proxy->get_available_views( ).

        et_entityset = VALUE #( FOR ls_avaible_view IN lt_available_views
                                 ( migrationprojectuuid = lv_proj_uuid
                                   migrationobjectuuid = lv_obj_uuid
                                   viewname = ls_avaible_view-view_name
                                   viewdescription = ls_avaible_view-view_desc ) ).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.
  ENDMETHOD.


  METHOD migrationobjec16_get_entityset.
    DATA:
      ls_entityset            TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationobjectcopy,
      ls_project              TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationtemplateproject,
      ls_filter_select_option TYPE /iwbep/s_mgw_select_option,
      ls_filter_option        TYPE /iwbep/s_cod_select_option,
      lo_str                  TYPE REF TO cl_abap_structdescr,
      lv_dependenttype        TYPE char1.

    FIELD-SYMBOLS:
      <ls_entity>    TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationobjectcopy.

    CLEAR es_response_context.
    CLEAR et_entityset.

    "get copied project
    io_tech_request_context->get_converted_source_keys( IMPORTING es_key_values = ls_project ).

    READ TABLE it_filter_select_options WITH KEY property = co_filter_dependenttype INTO ls_filter_select_option.
    IF sy-subrc = 0.
      READ TABLE ls_filter_select_option-select_options INTO ls_filter_option INDEX 1.
      lv_dependenttype = ls_filter_option-low.
    ENDIF.

    TRY.
        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        "bind message container
        DATA(lo_msg_container) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
        lo_cntxt_proj->set_msg_container( NEW /ltb/cl_mc_msg_cont_iwbep_adap( lo_msg_container ) ).

        IF ls_project-migrationapproachuuid IS NOT INITIAL
          AND ls_project-migrationscenariouuid IS NOT INITIAL.

          lo_cntxt_proj->set_approach( CONV #( ls_project-migrationapproachuuid ) ).
          lo_cntxt_proj->set_scenario( CONV #( ls_project-migrationscenariouuid ) ).

          lo_cntxt_proj->add_value( iv_type  = 'DEP_TYPE'
                                    iv_value = CONV #( lv_dependenttype ) ).

        ENDIF.

        IF ls_project-migrationprojectuuid IS NOT INITIAL.
          DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_project-migrationprojectuuid ) ).
          DATA(lt_objects) = lo_proj_proxy->get_migobjs( lo_cntxt_proj ).
          SORT lt_objects BY migobj_descr.
        ENDIF.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    lo_str ?= cl_abap_structdescr=>describe_by_data( p_data = ls_entityset ).
* prepare the mapping logic for the two internal table
    DATA(lt_mapper) = VALUE cl_abap_corresponding=>mapping_table(
        FOR ls_com IN lo_str->components
        WHERE ( name = 'MIGRATIONOBJECTUUID' OR name = 'MIGRATIONOBJECTNAME'
                OR name = 'DOCUMENTID' OR name = 'NUMOFDEPENDENCIES' OR name = 'DOCUMENTURL'
                OR name = 'NUMOFINUSE' OR name = 'ACTIVE' )
       (
         level = 0
         kind = 1
         dstname = CONV #( ls_com-name )
         srcname = /ltb/cl_mig_mc_odata_dpc_ext=>get_entity_components(
                                                iv_entity_set_name = iv_entity_set_name
                                                iv_component_name  = CONV #( ls_com-name )
                                                ) ) ).
***mapper begin

    DATA(lo_mapper) = cl_abap_corresponding=>create(
      source            = lt_objects
      destination       = et_entityset
      mapping           = lt_mapper
      ).
    lo_mapper->execute( EXPORTING source      = lt_objects
                         CHANGING  destination = et_entityset ).
* the three components 'migrationprojectuuid', 'approach','approach' are come from the second source
    LOOP AT et_entityset ASSIGNING FIELD-SYMBOL(<fs_entity>).
      <fs_entity>-migrationprojectuuid = ls_project-migrationprojectuuid.
      <fs_entity>-approach = ls_project-migrationapproachuuid.
      <fs_entity>-scenario = ls_project-migrationscenariouuid.
    ENDLOOP.

    DELETE et_entityset WHERE active <> /ltb/if_mc_constants=>gc_migobj_active-active.

    DATA(lv_migobj_count) = lines( et_entityset ).
    es_response_context-inlinecount = CONV #( lv_migobj_count ).

  ENDMETHOD.


  METHOD migrationobjec18_get_entityset.

    DATA:
      ls_csv_struct_key TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectcsvstruct.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_csv_struct_key
    ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_csv_struct_key-migrationprojectuuid ) ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_csv_struct_key-migrationobjectuuid ) ).
        DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( ls_csv_struct_key-migrationfileuuid ) ).

        DATA(lo_csv_bundle) = CAST /ltb/if_mc_csv_bundle( lo_file_proxy ).

        DATA(lt_items) = lo_csv_bundle->get_struct_items( ).

        et_entityset = VALUE #(
          FOR <item> IN lt_items (
            migrationprojectuuid = <item>-proj_uuid
            migrationobjectuuid  = <item>-migobj_uuid
            migrationfileuuid    = <item>-bundle_uuid
            techid               = <item>-struct_ident
            techname             = <item>-struct_descr
            mandatory            = <item>-is_mandatory
            numoffiles           = <item>-num_of_files
          )
        ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.
        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationobjec19_get_entityset.

    DATA:
      ls_entity_key TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectcsvstructand.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_entity_key
    ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_entity_key-migrationprojectuuid ) ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_entity_key-migrationobjectuuid ) ).
        DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( ls_entity_key-migrationfileuuid ) ).

        DATA(lo_csv_bundle) = CAST /ltb/if_mc_csv_bundle( lo_file_proxy ).

        DATA(lt_items) = lo_csv_bundle->get_struct_items( ).
        DATA(lt_files) = lo_csv_bundle->get_files( ).

        LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_item>).
          IF <fs_item>-num_of_files = 0.
            INSERT INITIAL LINE INTO TABLE et_entityset ASSIGNING FIELD-SYMBOL(<entity>).

            <entity> = VALUE #(
              migrationprojectuuid = <fs_item>-proj_uuid
              migrationobjectuuid  = <fs_item>-migobj_uuid
              migrationfileuuid    = <fs_item>-bundle_uuid
              techid               = <fs_item>-struct_ident
              techname             = <fs_item>-struct_descr
              mandatory            = <fs_item>-is_mandatory
            ).
          ELSE.
            LOOP AT <fs_item>-files ASSIGNING FIELD-SYMBOL(<fs_file>).
              INSERT INITIAL LINE INTO TABLE et_entityset ASSIGNING <entity>.

              <entity> = VALUE #(
                migrationprojectuuid = <fs_item>-proj_uuid
                migrationobjectuuid  = <fs_item>-migobj_uuid
                migrationfileuuid    = <fs_item>-bundle_uuid
                techid               = <fs_item>-struct_ident
                techname             = <fs_item>-struct_descr
                mandatory            = <fs_item>-is_mandatory
                csvfileuuid          = <fs_file>-file_uuid
                csvfilename          = <fs_file>-filename
                csvfilestatus        = <fs_file>-status
                createdby            = /ltb/cl_mc_odata_generic_func=>get_fullname_by_uname( CONV #( <fs_file>-created_by ) )
                createdat            = <fs_file>-created_at
                filesize             = <fs_file>-filesize
                numberofrows         = <fs_file>-num_of_records
                latesthistoryuuid    = <fs_file>-last_act_uuid
              ).

              IF line_exists( lt_files[ csvfile_uuid = <fs_file>-file_uuid ] ).
                <entity>-csvfilestatusdesc = lt_files[ csvfile_uuid = <fs_file>-file_uuid ]-status_descr.
                <entity>-applognr          = lt_files[ csvfile_uuid = <fs_file>-file_uuid ]-lognr.
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDLOOP.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.
        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationobjectc_get_entityset.

    DATA:
      ls_entity_key TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectcsvfile.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_entity_key
    ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_entity_key-migrationprojectuuid ) ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_entity_key-migrationobjectuuid ) ).
        DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( ls_entity_key-migrationfileuuid ) ).

        DATA(lo_csv_bundle) = CAST /ltb/if_mc_csv_bundle( lo_file_proxy ).

        DATA(lt_files) = lo_csv_bundle->get_files( ).

        et_entityset = VALUE #(
          FOR <file> IN lt_files (
            migrationprojectuuid = <file>-proj_uuid
            migrationobjectuuid  = <file>-migobj_uuid
            migrationfileuuid    = <file>-bundle_uuid
            csvfileuuid          = <file>-csvfile_uuid
            techid               = <file>-struct
            csvfilename          = <file>-filename
            csvfilestatus        = <file>-file_status
            csvfilestatusdesc    = <file>-status_descr
            createdby            = /ltb/cl_mc_odata_generic_func=>get_fullname_by_uname( CONV #( <file>-created_by ) )
            createdat            = <file>-created_at
            filesize             = <file>-filesize
            latesthistoryuuid    = <file>-act_uuid
            applognr             = <file>-lognr
          )
        ).

        IF line_exists( it_filter_select_options[ property = 'CSVFileStatus' ] ).
          IF io_tech_request_context->has_inlinecount( ) = abap_true.
            es_response_context-inlinecount = lines( et_entityset ).
          ENDIF.

          DELETE et_entityset WHERE csvfilestatus NOT IN  it_filter_select_options[ property = 'CSVFileStatus' ]-select_options.
        ELSEIF line_exists( it_filter_select_options[ property = 'TechID' ] ).
          DELETE et_entityset WHERE techid NOT IN it_filter_select_options[ property = 'TechID' ]-select_options.

          IF io_tech_request_context->has_inlinecount( ) = abap_true.
            es_response_context-inlinecount = lines( et_entityset ).
          ENDIF.
        ELSE.
          IF io_tech_request_context->has_inlinecount( ) = abap_true.
            es_response_context-inlinecount = lines( et_entityset ).
          ENDIF.
        ENDIF.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.
        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


METHOD migrationobjectm_get_entity.
  DATA: lv_proj_uuid     TYPE /ltb/mc_proj_uuid,
        lv_obj_uuid      TYPE /ltb/mc_object_uuid,
        lv_group_uuid    TYPE string,
        ls_key_pair      TYPE /iwbep/s_mgw_name_value_pair,
        lv_msggroup_uuid TYPE /ltb/if_mc_constants=>gty_msg_group_uuid.

  CLEAR es_response_context.
  CLEAR er_entity.

  IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobjectmessage.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
    IF sy-subrc = 0.
      lv_proj_uuid = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
    IF sy-subrc = 0.
      lv_obj_uuid = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_message_group_uuid.
    IF sy-subrc = 0.
      lv_group_uuid = ls_key_pair-value.
    ENDIF.

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
        DATA(lo_obj_ctx)       = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).
        lo_obj_ctx->set_group_uuid( iv_group_uuid =  lv_group_uuid ).

*         Get mo group messages
        lo_object_proxy->get_migobj_messages( EXPORTING io_cntxt = lo_obj_ctx
                                              IMPORTING
                                                et_messages = DATA(lt_messages) ).

        READ TABLE lt_messages INTO DATA(ls_message) INDEX 1.
        IF sy-subrc EQ 0.
          er_entity = VALUE #(
                                migrationprojectuuid         = lv_proj_uuid
                                migrationobjectuuid          = lv_obj_uuid
                                messagegroupuuid             = ls_message-group_uuid
                                messagegrouptitle            = ls_message-group_title
                                messagegrouptype             = ls_message-group_msgty
                                actionuuid                   = ls_message-group_act_uuid
                                actiondescription            = ls_message-group_act_descr
                                messagegroupmsgid            = ls_message-group_msgid
                                messagegroupmsgno            = ls_message-group_msgno
                                instancecount                = ls_message-group_ins_count
                                migrationprojectname         = ls_message-migproj_name
                                migrationobjectname          = ls_message-migobj_name
                              ).

        ENDIF.
      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.
  ENDIF.
ENDMETHOD.


  METHOD migrationobjectm_get_entityset.
    DATA: lv_proj_uuid     TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid      TYPE /ltb/mc_object_uuid,
          lv_instance_uuid TYPE /ltb/if_mc_constants=>gty_item_uuid,
          ls_key_pair      TYPE /iwbep/s_mgw_name_value_pair,
          lv_msggroup_uuid TYPE /ltb/if_mc_constants=>gty_msg_group_uuid.

    DATA: ls_filter_request TYPE /iwbep/s_mgw_select_option,
          ls_filter_option  TYPE /iwbep/s_cod_select_option,
          lt_filter         TYPE /ltb/if_mc_constants=>gtt_filter_cond,
          lt_order          TYPE /ltb/if_mc_constants=>gtt_sort_order,
          ls_order          TYPE /ltb/if_mc_constants=>gty_sort_order,
          ls_entityset      TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectmessage,
          lv_limit          TYPE int4,
          lv_offset         TYPE int4.

    FIELD-SYMBOLS <ls_filter_option> TYPE /iwbep/s_cod_select_option.

    CONSTANTS lco_max_item_count   TYPE int4    VALUE 255.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF it_filter_select_options IS INITIAL AND iv_filter_string IS NOT INITIAL.
      DATA(lt_filter_select_options) = get_complex_filter_sel_option(
        EXPORTING
          io_tech_request_context = io_tech_request_context
          iv_entity_name          = iv_entity_name ).
    ELSE.
      lt_filter_select_options = it_filter_select_options.
    ENDIF.

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobjectmessage.
      LOOP AT lt_filter_select_options INTO ls_filter_request ##INTO_OK.
        CASE ls_filter_request-property.
          WHEN co_migration_project_uuid.
            READ TABLE ls_filter_request-select_options INTO ls_filter_option INDEX 1.
            IF sy-subrc EQ 0.
              lv_proj_uuid = ls_filter_option-low.
            ENDIF.

          WHEN co_migration_object_uuid.
            READ TABLE ls_filter_request-select_options INTO ls_filter_option INDEX 1.
            IF sy-subrc EQ 0.
              lv_obj_uuid = ls_filter_option-low.
            ENDIF.

          WHEN co_action_uuid.
            "filter options
            lt_filter = VALUE #( BASE lt_filter
                    FOR <filter> IN ls_filter_request-select_options
                    (
                      field = 'ITEM_ACTION'
                      sign  = <filter>-sign
                      oper  = <filter>-option
                      low   = <filter>-low
                      high  = <filter>-high )
                    ).

          WHEN co_message_type.
            "filter options
            lt_filter = VALUE #( BASE lt_filter
                    FOR <filter> IN ls_filter_request-select_options
                    (
                      field = 'ITEM_STATUS'
                      sign  = <filter>-sign
                      oper  = <filter>-option
                      low   = <filter>-low
                      high  = <filter>-high )
                    ).

          WHEN co_message_no.
            "filter options
            lt_filter = VALUE #( BASE lt_filter
                    FOR <filter> IN ls_filter_request-select_options
                    (
                      field = 'MSGNO'
                      sign  = <filter>-sign
                      oper  = <filter>-option
                      low   = <filter>-low
                      high  = <filter>-high )
                    ).

          WHEN co_message_id.
            "filter options
            lt_filter = VALUE #( BASE lt_filter
                    FOR <filter> IN ls_filter_request-select_options
                    (
                      field = 'MSGID'
                      sign  = <filter>-sign
                      oper  = <filter>-option
                      low   = <filter>-low
                      high  = <filter>-high )
                    ).

        ENDCASE.
      ENDLOOP.

      LOOP AT it_order ASSIGNING FIELD-SYMBOL(<ls_order>).
        lt_order = VALUE #( BASE lt_order
                            ( property = /ltb/cl_mig_mc_odata_dpc_ext=>get_entity_components(
                                                           iv_entity_set_name = iv_entity_set_name
                                                           iv_component_name  = <ls_order>-property
                                                           )
                              order =  COND #( WHEN <ls_order>-order = co_sort_descending THEN /ltb/if_mc_constants=>gc_sort_order-descending
                                                         ELSE /ltb/if_mc_constants=>gc_sort_order-ascending ) ) ).
      ENDLOOP.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
          DATA(lo_obj_ctx)       = NEW /ltb/cl_mc_cntxt_obj_detail( ).
          DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

*         Handle paging, at most one page contains 255 items
          IF is_paging-top > lco_max_item_count.
            lv_limit = lco_max_item_count.
          ELSE.
            lv_limit = is_paging-top.
          ENDIF.
          lv_offset = is_paging-skip.
          IF lv_limit <> 0 OR lv_offset <> 0.
            lo_obj_ctx->set_page( iv_offset = lv_offset iv_limit = lv_limit ).
          ENDIF.

*       Set filter for key fields, action and status
          IF lt_filter IS NOT INITIAL.
            lo_obj_ctx->set_filter_cond( lt_filter ).
          ENDIF.
*       Set fulltext search
          IF iv_search_string IS NOT INITIAL.
            lo_obj_ctx->set_fulltext_search( iv_search_string ).
          ENDIF.
*       Set sort by and sort order

          IF lt_order IS NOT INITIAL.
            lo_obj_ctx->set_sort_order( it_orders =  lt_order ).
          ENDIF.

*         Get mo group messages
          lo_object_proxy->get_migobj_messages( EXPORTING io_cntxt = lo_obj_ctx
                                                IMPORTING
                                                  et_messages = DATA(lt_messages)
                                                  ev_count    = DATA(lv_count) ).


          et_entityset = VALUE #( FOR ls_message IN lt_messages
                                  ( migrationprojectuuid         = lv_proj_uuid
                                    migrationobjectuuid          = lv_obj_uuid
                                    messagegroupuuid             = ls_message-group_uuid
                                    messagegrouptitle            = ls_message-group_title
                                    messagegrouptype             = ls_message-group_msgty
                                    actionuuid                   = ls_message-group_act_uuid
                                    actiondescription            = ls_message-group_act_descr
                                    messagegroupmsgid            = ls_message-group_msgid
                                    messagegroupmsgno            = ls_message-group_msgno
                                    instancecount                = ls_message-group_ins_count
                                    migrationprojectname         = ls_message-migproj_name
                                    migrationobjectname          = ls_message-migobj_name
                                  ) ).

*       Handle inline count
          IF io_tech_request_context->has_inlinecount( ) = abap_true.
            es_response_context-inlinecount = lv_count.
          ENDIF.
          IF io_tech_request_context->has_count( ) = abap_true.
            es_response_context-count = lv_count.
          ENDIF.

        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages ).

        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD migrationobjects_get_entity.

    CLEAR es_response_context.
    CLEAR er_entity.

    DATA(lt_select_field) = io_tech_request_context->get_select_entity_properties( ).
    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values = er_entity
    ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( er_entity-migrationprojectuuid ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( er_entity-migrationobjectuuid ).
        DATA(lo_obj_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.

    IF line_exists( lt_select_field[ table_line = 'OPENTASKCOUNT' ] ) OR
       line_exists( lt_select_field[ table_line = 'CONFIRMEDTASKCOUNT' ] ) OR
       line_exists( lt_select_field[ table_line = 'SELECTIONCOUNT' ] ) OR
       line_exists( lt_select_field[ table_line = 'SIMULATIONSUCCESSCOUNT' ] ) OR
       line_exists( lt_select_field[ table_line = 'SIMULATIONERRORCOUNT' ] ) OR
       line_exists( lt_select_field[ table_line = 'MIGRATIONSUCCESSCOUNT' ] ) OR
       line_exists( lt_select_field[ table_line = 'MIGRATIONERRORCOUNT' ] ) OR
       line_exists( lt_select_field[ table_line = 'PREPAREMAPPINGERRORCOUNT' ] ) OR
       line_exists( lt_select_field[ table_line = 'PREPAREMAPNOTPROCESSEDCOUNT' ] ) OR
       line_exists( lt_select_field[ table_line = 'DEFAULTACTION' ] ).
      "TODO:
      "Normally, we should check every filed in the select field list, currently only migration overview will get the
      "statistics will set select field, so just directly use select field list as adjustment
      TRY.
          DATA(ls_object_statistics) = lo_object_proxy->get_statistics( io_cntxt = lo_obj_context ).
        CATCH /ltb/cx_mc_static_check_msg INTO lo_exception.
          raise_bussiness_exception(
            EXPORTING
              iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
              iv_message_unlimited = lo_exception->get_text( )
          ).
      ENDTRY.
      "migrationprojectuuid is a key field, should not be empty, should not be overriden here
      er_entity-migrationobjectuuid = ls_object_statistics-migobj_uuid.
      er_entity-migrationobjectname = ls_object_statistics-migobj_descr.
      er_entity-migrationobjectstatus = ls_object_statistics-migobj_status.
      er_entity-opentaskcount = ls_object_statistics-num_tasks_open.
      er_entity-confirmedtaskcount = ls_object_statistics-num_tasks_done.
      er_entity-selectioncount = ls_object_statistics-num_items_selected.
      er_entity-preparemapnotprocessedcount = ls_object_statistics-num_items_not_processed.
      er_entity-preparemappingerrorcount = ls_object_statistics-num_items_prepared_err.
      er_entity-simulationsuccesscount = ls_object_statistics-num_items_simulated.
      er_entity-simulationerrorcount = ls_object_statistics-num_items_simulated_err.
      er_entity-simulationnotavailable = ls_object_statistics-sim_not_available.
      er_entity-migrationsuccesscount = ls_object_statistics-num_items_migrated.
      er_entity-migrationerrorcount = ls_object_statistics-num_items_migrated_err.
      er_entity-defaultaction = ls_object_statistics-default_action.
      er_entity-excludecount = ls_object_statistics-num_items_exclude.
      er_entity-inprocesscount = ls_object_statistics-num_items_inprocess.
      er_entity-partlymigcount = ls_object_statistics-num_items_partly_mig.
      er_entity-notmigratedcount = ls_object_statistics-num_items_selected - ls_object_statistics-num_items_migrated
                                 - ls_object_statistics-num_items_migrated_err - ls_object_statistics-num_items_exclude.
      er_entity-preliminaryopentaskcount = ls_object_statistics-num_pre_task_open.
    ENDIF.

    TRY.
        DATA(ls_object_detail) = lo_object_proxy->get_details( io_cntxt = lo_obj_context ).
      CATCH /ltb/cx_mc_static_check_msg INTO lo_exception.
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.

    er_entity-migrationobjectname = ls_object_detail-migobj_descr.
    er_entity-documentid = ls_object_detail-migobj_doc_descr.
    er_entity-documenturl = ls_object_detail-migobj_doc_url.
    er_entity-migrationobjectactiivestatus   = ls_object_detail-migobj_active.
    er_entity-migrationobjectactiivestatusuu = ls_object_detail-migobj_active.
    er_entity-migrationobjectstatus = ls_object_detail-migobj_status.
    er_entity-migrationobjecttechname = ls_object_detail-migobj_name.
    er_entity-migrationobjecttempid = ls_object_detail-migobj_tmpl_uuid.
    er_entity-simulationnotavailable = ls_object_detail-migobj_sim_available.
    er_entity-numbackgroundjob = ls_object_detail-migobj_num_jobs.
    er_entity-upgradestate     = ls_object_detail-migobj_upg_state.
    er_entity-hasmultsteps     = ls_object_detail-migobj_has_mult_steps.
    DATA(lv_lastest_event) = lo_object_proxy->get_latest_event( ) .
    er_entity-migrationobjectlatestevent = get_latest_event_text( iv_event_type = CONV #( lv_lastest_event )
                                                                                          iv_simulate_number = ls_object_statistics-num_items_simulated
                                                                                          iv_migrate_number = ls_object_statistics-num_items_migrated ).
    er_entity-lifecycletext = ls_object_detail-lifecycle_text.
    er_entity-preparemappingavailable = ls_object_detail-prepare_mapping_available.

  ENDMETHOD.


  METHOD migrationobjects_get_entityset.

    DATA:ls_project TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationproject,
         lo_contx   TYPE REF TO /ltb/cl_mc_cntxt_query.

    DATA lr_sort_order              TYPE REF TO data.
    DATA lt_sort_order              TYPE abap_sortorder_tab.
    DATA ls_sort_order              LIKE LINE OF lt_sort_order.

    FIELD-SYMBOLS <lt_sort_order>   TYPE /ltb/if_mc_constants=>gtt_sort_order.

    CLEAR es_response_context.
    CLEAR et_entityset.

    io_tech_request_context->get_converted_source_keys( IMPORTING es_key_values = ls_project ).

    TRY.
        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        "bind message container
        DATA(lo_msg_container) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
        lo_cntxt_proj->set_msg_container( NEW /ltb/cl_mc_msg_cont_iwbep_adap( lo_msg_container ) ).
        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_project-migrationprojectuuid ).

        " set query context: paging, full search, order, filter
        lo_contx = lo_cntxt_proj.
        set_context( iv_entity_set_name = iv_entity_set_name
            is_paging = is_paging
            iv_search_string = iv_search_string
            it_order = it_order
            it_filter_select_options = it_filter_select_options
            io_context = lo_contx ).

        " get migration objects
        DATA(lt_objects) = lo_proj_proxy->get_migobjs( lo_contx ).

        lr_sort_order     = lo_contx->get_value_ref_by_type( /ltb/if_mc_constants=>gc_cntxt_type-sort_order ).


      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.
    get_copied_migration_objects(
        EXPORTING
          io_project_proxy    = lo_proj_proxy
          it_migration_object = lt_objects
        CHANGING
          ct_result           = et_entityset
      ).

    CLEAR ls_sort_order.
    IF lr_sort_order IS NOT INITIAL.
      ASSIGN lr_sort_order->* TO <lt_sort_order>.

      READ TABLE <lt_sort_order> ASSIGNING FIELD-SYMBOL(<ls_sort_order>) WITH KEY property = 'MIGOBJ_DESCR'.

      IF sy-subrc = 0.
        ls_sort_order-name = 'MIGRATIONOBJECTNAME'.
        IF <ls_sort_order>-order EQ /ltb/if_mc_constants=>gc_sort_order-descending.
          ls_sort_order-descending = abap_true.
        ELSE.
          ls_sort_order-descending = abap_false.
        ENDIF.
      ELSE.
        ls_sort_order-name = 'MIGRATIONOBJECTNAME'.
        ls_sort_order-descending = abap_false.
      ENDIF.
    ELSE.
      ls_sort_order-name = 'MIGRATIONOBJECTNAME'.
      ls_sort_order-descending = abap_false.
    ENDIF.

    APPEND ls_sort_order TO lt_sort_order.
    SORT et_entityset BY (lt_sort_order).

  ENDMETHOD.


  METHOD migrationobjectu_get_entity.

    DATA:
      lv_proj_uuid TYPE /ltb/mc_proj_uuid,
      lv_obj_uuid  TYPE /ltb/mc_object_uuid.

    READ TABLE it_key_tab INTO DATA(ls_project_key) WITH KEY name = co_migration_project_uuid.
    IF sy-subrc = 0.
      lv_proj_uuid = ls_project_key-value.
    ENDIF.

    READ TABLE it_key_tab INTO DATA(ls_obj_key) WITH KEY name = co_migration_object_uuid.
    IF sy-subrc = 0.
      lv_obj_uuid = ls_obj_key-value.
    ENDIF.

    TRY.

        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

        DATA(lo_migobj_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

        DATA(ls_details) = lo_migobj_proxy->get_details( NEW /ltb/cl_mc_cntxt_obj_detail( ) ).

        er_entity-migrationprojectuuid = lv_proj_uuid.
        er_entity-migrationobjectuuid  = ls_details-migobj_uuid.
        er_entity-migrationobjectname  = ls_details-migobj_descr.
        er_entity-contentupgradestate  = ls_details-migobj_upg_state.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).
        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationobjectu_get_entityset.

    DATA:
      lv_proj_uuid TYPE /ltb/mc_proj_uuid.

    READ TABLE it_key_tab INTO DATA(ls_project_key) WITH KEY name = co_migration_project_uuid.
    IF sy-subrc = 0.
      lv_proj_uuid = ls_project_key-value.
    ENDIF.

    TRY.

        DATA(ls_mc_proj) = /ltb/cl_mc_proj_access=>get_by_uuid( lv_proj_uuid ).

        CHECK ls_mc_proj-finished <> abap_true.

        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

        DATA(lt_objects) = lo_proj_proxy->get_migobjs( NEW /ltb/cl_mc_cntxt_proj_detail( ) ).

*        "Here we check update job/update state in case 'update_in_process' persist due to aborted job
*        "If this occurs, check state again to correct it.
*        IF lo_proj_proxy->is_upgrade_in_process( ) = abap_false.
*          LOOP AT lt_objects ASSIGNING FIELD-SYMBOL(<fs_obj>)
*            WHERE migobj_upg_state = /ltb/cl_mc_proj_proxy_abstract=>gc_upgrade_state-upgrade_in_process.
*
*            DATA(lo_migobj_proxy) = lo_proj_proxy->get_migobj_proxy_by_uuid( CONV #( <fs_obj>-migobj_uuid ) ).
*            <fs_obj>-migobj_upg_state = lo_migobj_proxy->check_content_upgrade_state( iv_with_log = abap_false ).
*          ENDLOOP.
*        ENDIF.

        LOOP AT lt_objects ASSIGNING FIELD-SYMBOL(<fs_obj>)
          WHERE migobj_upg_state = /ltb/cl_mc_proj_proxy_abstract=>gc_upgrade_state-upgrade_required OR
                migobj_upg_state = /ltb/cl_mc_proj_proxy_abstract=>gc_upgrade_state-modification_detected.

          INSERT INITIAL LINE INTO TABLE et_entityset ASSIGNING FIELD-SYMBOL(<fs_entityset>).

          <fs_entityset>-migrationprojectuuid = lv_proj_uuid.
          <fs_entityset>-migrationobjectuuid  = <fs_obj>-migobj_uuid.
          <fs_entityset>-contentupgradestate  = <fs_obj>-migobj_upg_state.
          <fs_entityset>-migrationobjectname  = <fs_obj>-migobj_descr.
        ENDLOOP.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).
        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationproje03_get_entity.
    DATA: ls_history      TYPE /ltb/if_mc_constants=>gty_history,
          ls_appl_history TYPE /ltb/if_mc_constants=>gty_appl_history,
          lv_proj_uuid    TYPE /ltb/mc_proj_uuid,
          lv_act_uuid     TYPE /ltb/mc_act_uuid,
          ls_key_pair     TYPE /iwbep/s_mgw_name_value_pair,
          lv_limit        TYPE int1,
          lv_offset       TYPE int4,
          lv_no_proj      TYPE abap_bool,
          lx_proxy_error  TYPE REF TO /ltb/cx_mc_proxy_error.

    CONSTANTS: lco_max_item_count TYPE int4 VALUE 10.

    CLEAR es_response_context.
    CLEAR er_entity.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
    IF sy-subrc = 0.
      lv_proj_uuid = ls_key_pair-value.
    ENDIF.

    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_proj_history_uuid.
    IF sy-subrc = 0.
      lv_act_uuid  = ls_key_pair-value.
    ENDIF.

    "application proxy
    DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).

    TRY .
        "project proxy
        DATA(lo_proj_proxy) = lo_appl_proxy->get_proj_proxy_by_uuid( lv_proj_uuid ).
        lv_no_proj = abap_false.
      CATCH /ltb/cx_mc_proxy_error.
        lv_no_proj = abap_true.
    ENDTRY.

    "start main process
    TRY.
        "get history table
        DATA(lo_obj_cntxt) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        IF lv_act_uuid IS NOT INITIAL.
          lo_obj_cntxt->set_act_uuid( iv_act_uuid = lv_act_uuid ).
        ENDIF.

        IF lv_no_proj EQ abap_true.

          lo_obj_cntxt->add_value( iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-proj_uuid
                                   iv_value = CONV #( lv_proj_uuid ) ).
          lo_appl_proxy->get_history(
            EXPORTING io_cntxt = lo_obj_cntxt
            IMPORTING et_history = DATA(lt_appl_history)
                      ev_count = DATA(lv_count) ).

          IF lt_appl_history IS NOT INITIAL.
            READ TABLE lt_appl_history INTO ls_appl_history INDEX 1.

          ENDIF.

          er_entity = VALUE #(
          migrationprojectuuid          = lv_proj_uuid
          migrationprojecthistoryuuid   = lv_act_uuid
          migrationprojecthistorytype   = ls_appl_history-event_type_desc
          startedby                     = ls_appl_history-started_by_name
          startedat                     = ls_appl_history-started_at
          finishedat                    = ls_appl_history-finished_at
          appllognr                     = ls_appl_history-appl_lognr
          appllogty                     = ls_appl_history-appl_logty
          migrationprojecthistorystatus = ls_appl_history-event_status
          migrationprojectname          = ls_appl_history-proj_name
          ) .

        ELSE.

          lo_proj_proxy->get_history(
            EXPORTING io_cntxt = lo_obj_cntxt
            IMPORTING et_history = DATA(lt_history) ).

          IF lt_history IS NOT INITIAL.
            READ TABLE lt_history INTO ls_history INDEX 1.

            "get other needed fields
            DATA(ls_proj_detail) = lo_proj_proxy->get_proj_details( io_cntxt = lo_obj_cntxt ).
          ENDIF.

          er_entity = VALUE #(
                    migrationprojectuuid          = lv_proj_uuid
                    migrationprojecthistoryuuid   = lv_act_uuid
                    migrationprojecthistorytype   = ls_history-event_type_desc
                    startedby                     = ls_history-started_by_name
                    startedat                     = ls_history-started_at
                    finishedat                    = ls_history-finished_at
                    appllognr                     = ls_history-appl_lognr
                    appllogty                     = ls_history-appl_logty
                    migrationprojecthistorystatus = ls_history-event_status
                    migrationprojectname          = ls_proj_detail-proj_descr
                    ) .

        ENDIF.


      CATCH /ltb/cx_mc_proxy_error INTO lx_proxy_error.

        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationproje03_get_entityset.
    DATA: ls_object      TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          lv_proj_uuid   TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid    TYPE /ltb/mc_object_uuid,
          lv_limit       TYPE int4,
          lv_offset      TYPE int4,
          lo_contx_query TYPE REF TO /ltb/cl_mc_cntxt_query.

    CONSTANTS: lco_max_item_count TYPE int4 VALUE 255.

    CLEAR es_response_context.
    CLEAR et_entityset.

    io_tech_request_context->get_converted_source_keys(
    IMPORTING
      es_key_values = ls_object
    ).

    lv_proj_uuid = ls_object-migrationprojectuuid.

    "Handle paging, at most one page contains 10 items
    IF is_paging-top > lco_max_item_count.
      lv_limit = lco_max_item_count.
    ELSE.
      lv_limit = is_paging-top.
    ENDIF.
    lv_offset = is_paging-skip.

    "start main process
    TRY.
        "application proxy
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).

        "project proxy
        DATA(lo_proj_proxy) = lo_appl_proxy->get_proj_proxy_by_uuid( lv_proj_uuid ).

        "get history table
        DATA(lo_obj_cntxt) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        IF lv_limit <> 0 OR lv_offset <> 0.
          lo_obj_cntxt->set_page( iv_offset = lv_offset iv_limit = lv_limit ).
        ENDIF.

        lo_contx_query = lo_obj_cntxt.
        set_context(
          EXPORTING
            iv_entity_set_name = iv_entity_set_name
            iv_search_string   = iv_search_string
            it_order           = it_order
            io_context         = lo_contx_query ).

        lo_proj_proxy->get_history(
          EXPORTING io_cntxt = lo_contx_query
          IMPORTING et_history = DATA(lt_history)
                    ev_count = DATA(lv_count) ).

        "Handle inline count
        IF io_tech_request_context->has_inlinecount( ) = abap_true.
          es_response_context-inlinecount = lv_count.
        ENDIF.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).

      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    et_entityset = VALUE #( FOR <item> IN lt_history
      (
        migrationprojectuuid          = lv_proj_uuid
        migrationprojecthistoryuuid   = <item>-act_uuid
        migrationprojecthistorytype   = <item>-event_type_desc
        startedby                     = <item>-started_by_name
        startedat                     = <item>-started_at
        finishedat                    = <item>-finished_at
        appllognr                     = <item>-appl_lognr
        appllogty                     = <item>-appl_logty
        migrationprojecthistorystatus = <item>-event_status )
      ).

  ENDMETHOD.


  METHOD migrationproje04_get_entity.
    DATA lv_project_uuid  TYPE /ltb/mc_proj_uuid.

    CLEAR es_response_context.
    CLEAR er_entity.

    READ TABLE it_key_tab WITH KEY name = co_migration_project_uuid INTO DATA(ls_key).
    lv_project_uuid = ls_key-value.

    TRY.
        DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).

        er_entity-migrationprojectuuid = lv_project_uuid.
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).
        lo_project->has_proj_prep_failed(
          EXPORTING io_cntxt = lo_cntxt_proj
          IMPORTING ev_failed = er_entity-preparefailed ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationproje05_get_entityset.

    DATA ls_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationprojectview.

    DATA(lv_is_cloud) = /ltb/cl_ext_cls_factory=>get_cos_utilities( )->is_cloud( ).

    SELECT * INTO TABLE @DATA(lt_view) FROM dmc_vm_view_def WHERE is_cloud_view = @lv_is_cloud.

    IF lt_view IS NOT INITIAL.
      SELECT view_ident,description INTO TABLE @DATA(lt_view_descr) FROM dmc_vm_view_deft FOR ALL ENTRIES IN @lt_view
        WHERE view_ident = @lt_view-view_ident AND spras = @sy-langu.
    ENDIF.

    LOOP AT lt_view INTO DATA(ls_view).
      READ TABLE lt_view_descr INTO DATA(ls_view_descr) WITH KEY view_ident = ls_view-view_ident.
      IF sy-subrc = 0.
        ls_data-migrationprojectviewname = ls_view-view_ident.
        ls_data-migrationprojectviewdescr = ls_view_descr-description.
        APPEND ls_data TO et_entityset.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD migrationproje06_get_entity.

    DATA:
      lv_project_uuid TYPE /ltb/mc_proj_uuid,
      lv_text_n01     TYPE char30.

    CLEAR es_response_context.
    CLEAR er_entity.

    READ TABLE it_key_tab WITH KEY name = co_migration_project_uuid INTO DATA(ls_key).
    lv_project_uuid = ls_key-value.

    TRY .
        DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
        DATA(lo_project_context) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
        DATA(ls_proj_job_info) = lo_project->get_job_info( io_cntxt = lo_project_context ).

        er_entity = VALUE #( migrationprojectuuid = lv_project_uuid
                             numbackgroundjob = ls_proj_job_info-proj_num_job
                             numofusedjob = ls_proj_job_info-proj_num_used_job
                             numofavailablejob = ls_proj_job_info-proj_num_available_job
                            ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.
  ENDMETHOD.


  METHOD migrationproject_get_entity.
    DATA:
      lv_project_uuid TYPE /ltb/mc_proj_uuid,
      lv_text_n01     TYPE char30.

    IF 1 = 0.
      " N01: RFC Connection
      lv_text_n01 = TEXT-n01.                               "#EC NEEDED
    ENDIF.

    CLEAR es_response_context.
    CLEAR er_entity.

    READ TABLE it_key_tab WITH KEY name = co_migration_project_uuid INTO DATA(ls_key).
    lv_project_uuid = ls_key-value.

    TRY.
        DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).
        DATA(lo_project_context) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
        lo_project->process_after_import( io_cntxt = lo_project_context ).
        DATA(ls_project_detail) = lo_project->get_proj_details( io_cntxt = lo_project_context ).
        DATA(lo_app_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        DATA(lt_approach) = lo_app_proxy->get_approaches( ).
        IF line_exists( lt_approach[ approach = ls_project_detail-proj_approach ] ).
          DATA(approach) = lt_approach[ approach = ls_project_detail-proj_approach ].
        ENDIF.
        DATA(lt_scenario) = lo_app_proxy->get_scenarios_by_approach( iv_approach = approach-approach ).
        IF line_exists( lt_scenario[  scenario = ls_project_detail-proj_scenario ] ).
          DATA(scenario) = lt_scenario[  scenario = ls_project_detail-proj_scenario ].
        ENDIF.

        DATA(lo_com_utils) = cl_cnv_pe_factory=>get_com_utils( ).
        DATA(lv_is_ca) = lo_com_utils->is_ca_config_required( ).

        er_entity = VALUE #( migrationprojectuuid   = ls_project_detail-proj_uuid
                             migrationprojectname   = ls_project_detail-proj_descr
                             connectionname = COND #( WHEN ls_project_detail-proj_dbcon IS NOT INITIAL THEN ls_project_detail-proj_dbcon
                                                      WHEN ls_project_detail-proj_rfccon IS NOT INITIAL THEN ls_project_detail-proj_rfccon
                                                      ELSE space )
                             connectionuuid         = ls_project_detail-proj_con_uuid
                             migrationapproachuuid  = ls_project_detail-proj_approach
                             migrationapproach      = approach-text
                             migrationscenario      = scenario-text
                             migrationscenariouuid  = ls_project_detail-proj_scenario
                             migrationprojectstatusuuid = ls_project_detail-proj_status
                             migrationprojectstatus = get_project_status_text( ls_project_detail-proj_status )
                             migrationobjectcount  = ls_project_detail-proj_num_obj
                             connectiontypename    = COND #( WHEN ls_project_detail-proj_dbcon IS NOT INITIAL THEN get_text( EXPORTING iv_id = 'N02' )
                                                             WHEN ls_project_detail-proj_rfccon IS NOT INITIAL AND lv_is_ca EQ abap_false THEN get_text( EXPORTING iv_id = 'N01' )
                                                             WHEN ls_project_detail-proj_rfccon IS NOT INITIAL AND lv_is_ca EQ abap_true THEN get_text( EXPORTING iv_id = 'N03' )
                                                             ELSE space )
                             createby = /ltb/cl_mc_odata_generic_func=>get_fullname_by_uname( iv_uname = ls_project_detail-proj_created_by )
                             createdat             = ls_project_detail-proj_created_at
                             migrationprojecttechname = ls_project_detail-proj_name
                             migrationprojecttempid = ls_project_detail-proj_tmpl_uuid
                             migrationprojectmtid   = ls_project_detail-proj_mtid
                             numbackgroundjob       = ls_project_detail-proj_num_jobs
                             isvieweditable = ls_project_detail-proj_isvieweditable
                             activeviewdescription = ls_project_detail-proj_actviewdescr
                             activeviewname = ls_project_detail-proj_actviewname
                             developmentclass = ls_project_detail-proj_devclass
                             isdbconlost = COND #( WHEN ls_project_detail-proj_dbcon IS NOT INITIAL
                                                    AND ls_project_detail-proj_dbcon <> /ltb/if_mc_constants=>gc_default_dbcon
                                                    THEN is_dbcon_lost( CONV #( ls_project_detail-proj_dbcon ) )
                                                  )
                             rfcconnectioninvalid = COND #( WHEN ls_project_detail-proj_rfccon IS NOT INITIAL
                                                             AND ls_project_detail-proj_rfccon <> /ltb/if_mc_constants=>gc_rfc_dest_none
                                                             THEN is_rfc_available( iv_connection = ls_project_detail-proj_rfccon
                                                                                    iv_connectionuuid = ls_project_detail-proj_con_uuid )
                                                           )
                             ).
        lo_project->get_proj_retention_info( IMPORTING ev_retention_start = er_entity-retentionstart
                                                       ev_retention_days = er_entity-retentiondays
                                                       ev_retention_message = er_entity-retentionmessage ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationproject_get_entityset.
    DATA:
      ls_entity      TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationproject,
      lv_limit       TYPE int1,
      lv_offset      TYPE int4,
      lv_flag_filter TYPE c,
      ls_sort_order  TYPE abap_sortorder,
      lt_sort_order  TYPE abap_sortorder_tab,
      lv_text_n01    TYPE char30,
      lv_cnt         TYPE i.




    FIELD-SYMBOLS:
      <fs_field>     TYPE any.

    IF 1 = 0.
      " N01: RFC Connection
      lv_text_n01 = TEXT-n01.                               "#EC NEEDED
    ENDIF.

    CLEAR es_response_context.
    CLEAR et_entityset.
    TRY.
        DATA(lo_app_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).

        DATA(lt_approach) = lo_app_proxy->get_approaches( ).

        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        "bind message container
        DATA(lo_msg_container) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
        lo_cntxt_proj->set_msg_container( NEW /ltb/cl_mc_msg_cont_iwbep_adap( lo_msg_container ) ).

        "check complex filter
        IF it_filter_select_options IS INITIAL AND iv_filter_string IS NOT INITIAL.
          DATA(lt_filter_select_options) = get_complex_filter_sel_option(
            EXPORTING
              io_tech_request_context = io_tech_request_context
              iv_entity_name          = iv_entity_name ).
        ELSE.
          lt_filter_select_options = it_filter_select_options.
        ENDIF.

        set_context( iv_entity_set_name = iv_entity_set_name
            iv_search_string = iv_search_string
            it_order = it_order
*            it_filter_select_options = it_filter_select_options
            it_filter_select_options = lt_filter_select_options
            io_context = lo_cntxt_proj
            is_paging = is_paging ).
        DATA(lt_project_list) = lo_app_proxy->get_projects( EXPORTING io_cntxt = lo_cntxt_proj
                                                            IMPORTING ev_count = lv_cnt ).

        DATA(lv_is_ca) = cl_cnv_pe_factory=>get_com_utils( )->is_ca_config_required( ).

        LOOP AT lt_project_list INTO DATA(project_info).
          IF line_exists( lt_approach[ approach = project_info-proj_approach ] ).
            DATA(approach) = lt_approach[ approach = project_info-proj_approach ].
            DATA(lt_scenario) = lo_app_proxy->get_scenarios_by_approach( iv_approach = approach-approach ).
            IF line_exists( lt_scenario[ scenario = project_info-proj_scenario ] ).
              DATA(scenario) = lt_scenario[ scenario = project_info-proj_scenario ].

              ls_entity-migrationprojectname = project_info-proj_name.
              ls_entity-migrationprojectuuid = project_info-proj_uuid.
              ls_entity-migrationprojectstatusuuid = project_info-proj_status.
              ls_entity-migrationprojectstatus = get_project_status_text( project_info-proj_status ).
              ls_entity-migrationapproachuuid = project_info-proj_approach.
              ls_entity-migrationapproach = approach-text.
              ls_entity-migrationscenario = CONV #( scenario-text ).
              ls_entity-migrationscenariouuid = project_info-proj_scenario.
              ls_entity-createby              = project_info-proj_created_by.
              ls_entity-createdat             = project_info-proj_created_at.
              ls_entity-connectionuuid        = project_info-proj_con_uuid.
              ls_entity-connectionname    = COND #( WHEN project_info-proj_dbcon IS NOT INITIAL THEN project_info-proj_dbcon
                                              WHEN project_info-proj_rfccon IS NOT INITIAL THEN project_info-proj_rfccon
                                              ELSE space
                                            ).
              ls_entity-connectiondescr    = COND #( WHEN project_info-proj_dbcon IS NOT INITIAL THEN project_info-proj_dbcon_descr
                                              WHEN project_info-proj_rfccon IS NOT INITIAL THEN project_info-proj_rfccon
                                              ELSE space
                                            ).
              ls_entity-migrationobjectcount  = project_info-proj_num_obj.
              ls_entity-connectiontypename    = COND #( WHEN project_info-proj_dbcon IS NOT INITIAL THEN get_text( EXPORTING iv_id = 'N02' )
                                                WHEN project_info-proj_rfccon IS NOT INITIAL AND lv_is_ca EQ abap_false THEN get_text( EXPORTING iv_id = 'N01' )
                                                WHEN project_info-proj_rfccon IS NOT INITIAL AND lv_is_ca EQ abap_true THEN get_text( EXPORTING iv_id = 'N03' )
                                              ELSE space
                                            ).

              DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( project_info-proj_uuid ).
              lo_project->get_proj_retention_info( IMPORTING ev_retention_start = ls_entity-retentionstart
                                                             ev_retention_days = ls_entity-retentiondays
                                                             ev_retention_message = ls_entity-retentionmessage ).

              "full search
*              IF iv_search_string IS NOT INITIAL.
*                CLEAR lv_flag_filter.
*
*                IF ls_entity-migrationprojectname CS iv_search_string
*                OR ls_entity-createby CS iv_search_string
*                OR ls_entity-migrationprojectstatus CS iv_search_string
*                OR ls_entity-migrationapproach CS iv_search_string
*                OR ls_entity-migrationscenario CS iv_search_string
*                OR ls_entity-connectionname CS iv_search_string.
*                  lv_flag_filter = abap_true.
*                ENDIF.
*              ELSE.
*                "no need for full search
*                lv_flag_filter = abap_true.
*              ENDIF.

              "filter fields
*              IF lv_flag_filter = abap_true.
*                IF it_filter_select_options IS NOT INITIAL.
*                  "filter result by each filter field.
*                  LOOP AT it_filter_select_options INTO DATA(ls_filter_select_option).
*                    ASSIGN COMPONENT ls_filter_select_option-property OF STRUCTURE ls_entity TO <fs_field>.
*
*                    "if one of filter conditions is not fulfilled, exit this loop
*                    IF  <fs_field> IS ASSIGNED AND <fs_field> IN ls_filter_select_option-select_options.
*                    ELSE.
*                      CLEAR lv_flag_filter.
*                      EXIT.
*                    ENDIF.
*                  ENDLOOP.
*                ENDIF.
*
*                IF lv_flag_filter = abap_true.
*                  APPEND ls_entity TO et_entityset.
*                ENDIF.
*              ENDIF.

              APPEND ls_entity TO et_entityset.
            ENDIF.
          ENDIF.
        ENDLOOP.

        IF io_tech_request_context->has_inlinecount( ) = abap_true.
          es_response_context-inlinecount = lv_cnt.
        ENDIF.

*        "sort
*        IF it_order IS NOT INITIAL.
*          lt_sort_order = VALUE #(
*                                   FOR <ls_order> IN it_order
*                                   ( name       = <ls_order>-property
*                                     descending = COND #( WHEN <ls_order>-order = co_sort_descending
*                                     THEN abap_true
*                                     ELSE abap_false )
*                                    )
*                                  ).
*          SORT et_entityset BY (lt_sort_order).
*        ENDIF.
*
*        "paging
*        IF is_paging-top > lco_max_item_count OR is_paging-top = 0.
*          lv_limit = lco_max_item_count.
*        ELSE.
*          lv_limit = is_paging-top.
*        ENDIF.
*        lv_offset = is_paging-skip.
*
*        IF lv_offset <> 0.
*          DELETE et_entityset FROM 1 TO lv_offset.
*        ENDIF.
*
*        DELETE et_entityset FROM lv_limit + 1.

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        DATA(lt_mc_messages) = lo_exception->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
    ENDTRY.

  ENDMETHOD.


  METHOD migrationscenari_get_entityset.

    TYPES:
      BEGIN OF ty_s_approach,
        sign   TYPE sign,
        option TYPE option,
        low    TYPE /ltb/mc_approach,
        high   TYPE /ltb/mc_approach,
      END OF ty_s_approach.

    CONSTANTS: lc_uuid TYPE char25 VALUE 'MIGRATIONAPPROACHUUID'.

    DATA: lt_filter      TYPE /iwbep/t_mgw_select_option,
          ls_filter      TYPE /iwbep/s_mgw_select_option,
          lt_so_approach TYPE TABLE OF ty_s_approach,
          ls_so_approach TYPE ty_s_approach.

    CLEAR es_response_context.
    CLEAR et_entityset.
    "get filters
    lt_filter = io_tech_request_context->get_filter( )->get_filter_select_options( ).

    LOOP AT lt_filter INTO ls_filter ##INTO_OK.
      IF ls_filter-property = lc_uuid.
        MOVE-CORRESPONDING ls_filter-select_options TO lt_so_approach.
      ENDIF.
    ENDLOOP.

    READ TABLE lt_so_approach INTO ls_so_approach INDEX 1.

    TRY.
        "get all records
        DATA(lo_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        DATA(lt_scenario) = lo_proxy->get_scenarios_by_approach(
        EXPORTING
          iv_approach = ls_so_approach-low
          ).

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).

        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    "output
    et_entityset = VALUE #( FOR <item> IN lt_scenario
                        (
                          migrationscenariouuid = <item>-scenario
                          migrationscenario = <item>-text
                          migrationapproachuuid = ls_so_approach-low
                        )
               ).

  ENDMETHOD.


  METHOD migrationtempl01_get_entityset.

    DATA:
      lt_entityset_tmpl TYPE /ltb/cl_mig_mc_odata_mpc=>tt_migrationtemplateobject,
      lt_entityset_mo   TYPE /ltb/cl_mig_mc_odata_mpc=>tt_migrationtemplateobject,
      ls_entityset      TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationtemplateobject,
      ls_project        TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationtemplateproject,
      lo_tmpl_proxy     TYPE REF TO /ltb/if_mc_tmpl_proxy,
      lt_tmpl_objs      TYPE /ltb/if_mc_constants=>gtt_migobj,
      lt_order          TYPE /iwbep/t_mgw_sorting_order,
      ls_order          LIKE LINE OF lt_order,
      lo_str            TYPE REF TO cl_abap_structdescr,
      lv_str_com        TYPE string,
      lv_message        TYPE bal_s_msg.


    FIELD-SYMBOLS:
      <ls_entity>    TYPE /ltb/cl_mig_mc_odata_mpc_ext=>ts_migrationtemplateobject.

    CLEAR es_response_context.
    CLEAR et_entityset.

    "get template project
    io_tech_request_context->get_converted_source_keys( IMPORTING es_key_values = ls_project ).

    lt_order = it_order.
    IF line_exists( it_filter_select_options[ property = co_dependencylevel ] ).
      DATA(lt_select_option) = it_filter_select_options[ property = co_dependencylevel ]-select_options.
      IF lt_select_option[ 1 ]-low = gc_dependency_level-all.
        DATA(lv_all_dependency_level) = abap_true.
      ENDIF.
    ENDIF.

    IF line_exists( it_filter_select_options[ property =  co_filter_iscopied ] ).
      DATA(lt_iscopied) = it_filter_select_options[ property = co_filter_iscopied ]-select_options.
      IF lt_iscopied[ 1 ]-low = abap_true.
        DATA(lv_is_copied) = abap_true.
      ENDIF.
    ENDIF.
    TRY.
        "context definition
        DATA(lo_cntxt_proj) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        "bind message container
        DATA(lo_msg_container) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
        lo_cntxt_proj->set_msg_container( NEW /ltb/cl_mc_msg_cont_iwbep_adap( lo_msg_container ) ).

        "application proxy
        DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).


        IF ls_project-migrationapproachuuid IS NOT INITIAL
        AND ls_project-migrationscenariouuid IS NOT INITIAL.
          "always get template objects
          lo_cntxt_proj->set_approach( CONV #( ls_project-migrationapproachuuid ) ).
          lo_cntxt_proj->set_scenario( CONV #( ls_project-migrationscenariouuid ) ).
          IF ls_project-migrationprojectuuid = co_undefined.
            lo_cntxt_proj->set_activity( CONV #( /ltb/if_mc_constants=>gc_project_activity-create ) ).
          ELSE.
            lo_cntxt_proj->set_proj_uuid( CONV #( ls_project-migrationprojectuuid ) ).
          ENDIF.

          IF lt_order IS INITIAL.

            lt_order = VALUE #(
            ( property = 'MigrationObjectName'
              order = /ltb/if_mc_constants=>gc_sort_order-ascending ) ).
          ENDIF.

*       Set fulltext search

          set_context( iv_entity_set_name = iv_entity_set_name
              iv_search_string = iv_search_string
              it_order = lt_order
              it_filter_select_options = it_filter_select_options
              is_paging  = is_paging
              io_context = lo_cntxt_proj ).
          lo_cntxt_proj->set_dependency_level( iv_all_level = lv_all_dependency_level ).
          lo_tmpl_proxy = lo_appl_proxy->get_tmpl_proxy_by_appr_scen( lo_cntxt_proj ).
          lo_tmpl_proxy->get_migobjs( EXPORTING io_cntxt = lo_cntxt_proj
                                      IMPORTING
                                                et_objects = lt_tmpl_objs
                                                ev_count   = DATA(lv_migobj_count) ).
          es_response_context-inlinecount = CONV #( lv_migobj_count ).
        ENDIF.

        "for update or display scenarios, need to get selected MOs
        IF ls_project-migrationprojectuuid IS NOT INITIAL AND ls_project-migrationprojectuuid <> co_undefined.
          DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_project-migrationprojectuuid ) ).
          DATA(lt_objects) = lo_proj_proxy->get_migobjs( lo_cntxt_proj ).
        ENDIF.

      CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
        DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
        DATA(lx_tmp_proxy_error) = lx_proxy_error->previous.
        WHILE lx_tmp_proxy_error->previous IS NOT INITIAL.
          lx_tmp_proxy_error = lx_tmp_proxy_error->previous.
        ENDWHILE.
        IF lt_mc_messages IS INITIAL AND lx_tmp_proxy_error IS NOT INITIAL.
          DATA(lv_msg_txt) = lx_tmp_proxy_error->get_text( ).
          lv_message-msgid = 'DMC_RT_MSG'.
          lv_message-msgno = 000.
          lv_message-msgty = 'E'.
          lv_message-msgv1 = lv_msg_txt.
          APPEND lv_message TO lt_mc_messages.
        ENDIF.
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
      CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
        lt_mc_messages = lx_cntxt_error->get_messages( ).
        DATA(lx_tmp_cntxt_error) = lx_cntxt_error->previous.
        WHILE lx_tmp_cntxt_error->previous IS NOT INITIAL.
          lx_tmp_cntxt_error = lx_tmp_cntxt_error->previous.
        ENDWHILE.
        IF lt_mc_messages IS INITIAL AND lx_tmp_cntxt_error IS NOT INITIAL.
          lv_msg_txt = lx_tmp_cntxt_error->get_text( ).
          lv_message-msgid = 'DMC_RT_MSG'.
          lv_message-msgno = 000.
          lv_message-msgty = 'E'.
          lv_message-msgv1 = lv_msg_txt.
          APPEND lv_message TO lt_mc_messages.
        ENDIF.
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages ).
    ENDTRY.

    lo_str ?= cl_abap_structdescr=>describe_by_data( p_data = ls_entityset ).
* prepare the mapping logic for the two internal table
    DATA(lt_mapper) = VALUE cl_abap_corresponding=>mapping_table(
        FOR ls_com IN lo_str->components
        WHERE ( name = 'MIGRATIONOBJECTUUID' OR name = 'MIGRATIONOBJECTNAME'
                OR name = 'DOCUMENTID' OR name = 'NUMOFDEPENDENCIES' OR name = 'DOCUMENTURL'
                OR name = 'NUMOFINUSE' )
       (
         level = 0
         kind = 1
         dstname = CONV #( ls_com-name )
         srcname = /ltb/cl_mig_mc_odata_dpc_ext=>get_entity_components(
                                                iv_entity_set_name = iv_entity_set_name
                                                iv_component_name  = CONV #( ls_com-name )
                                                ) ) ).
***mapper begin

    DATA(lo_mapper) = cl_abap_corresponding=>create(
      source            = lt_tmpl_objs
      destination       = et_entityset
      mapping           = lt_mapper
      ).
    lo_mapper->execute( EXPORTING source      = lt_tmpl_objs
                         CHANGING  destination = et_entityset ).
* the three components 'migrationprojectuuid', 'approach','approach' are come from the second source
    LOOP AT et_entityset ASSIGNING FIELD-SYMBOL(<fs_entity>).
      <fs_entity>-migrationprojectuuid = ls_project-migrationprojectuuid.
      <fs_entity>-approach = ls_project-migrationapproachuuid.
      <fs_entity>-scenario = ls_project-migrationscenariouuid.
    ENDLOOP.

***end

    "template objects that not copied & copeid objects & user defined objects
    "use real object names for productive objects
    lt_entityset_tmpl = et_entityset.
    LOOP AT lt_objects INTO DATA(ls_cobj) ##INTO_OK.
      READ TABLE lt_entityset_tmpl WITH KEY migrationobjectuuid = ls_cobj-migobj_tmpl_uuid INTO ls_entityset.
      IF sy-subrc = 0.
        ls_entityset-iscopied = abap_true.
        ls_entityset-migrationobjectname = ls_cobj-migobj_descr.
        IF ls_entityset-approach EQ /ltb/if_mc_constants=>gc_approach-sap_direct.
          "For a PE project, there may be multiple MOs copied from one template
          "pass productive MO id to keep key fields unique
          ls_entityset-migrationobjectuuid = ls_cobj-migobj_uuid.
        ENDIF.
        APPEND ls_entityset TO lt_entityset_mo.

        DELETE et_entityset WHERE migrationobjectuuid = ls_cobj-migobj_tmpl_uuid.
      ELSE.
        "if MO copy activity is not finished, the template MO UUID is not filled into corresponding field of et_entityset,
        "so we need to compare the migration object name
        READ TABLE lt_entityset_tmpl WITH KEY migrationobjectname = ls_cobj-migobj_descr INTO ls_entityset.
        IF sy-subrc = 0 AND ls_cobj-migobj_is_template EQ abap_true.
          ls_entityset-iscopied = abap_true.
          ls_entityset-migrationobjectname = ls_cobj-migobj_descr.
          IF ls_entityset-approach EQ /ltb/if_mc_constants=>gc_approach-sap_direct.
            "For a PE project, there may be multiple MOs copied from one template
            "pass productive MO id to keep key fields unique
            ls_entityset-migrationobjectuuid = ls_cobj-migobj_uuid.
          ENDIF.
          APPEND ls_entityset TO lt_entityset_mo.

          DELETE et_entityset WHERE migrationobjectname = ls_cobj-migobj_descr.
        ELSE.
          "add user defined MOs
          CLEAR ls_entityset.
          ls_entityset-migrationobjectuuid = ls_cobj-migobj_uuid.
          ls_entityset-migrationprojectuuid = ls_project-migrationprojectuuid.
          ls_entityset-migrationobjectname = ls_cobj-migobj_descr.
          ls_entityset-approach = ls_project-migrationapproachuuid.
          ls_entityset-scenario = ls_project-migrationscenariouuid.
          ls_entityset-iscopied = abap_true.
*          ls_entityset-numofdependencies = ls_cobj-migobj_num_deps.
          APPEND ls_entityset TO lt_entityset_mo.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lv_is_copied = abap_true.
      et_entityset = lt_entityset_mo.
    ELSE.
      APPEND LINES OF lt_entityset_mo TO et_entityset.
    ENDIF.

    SORT et_entityset BY migrationobjectname.
  ENDMETHOD.


  METHOD migrationtemplat_get_entity.

    DATA: ls_key_pair      TYPE /iwbep/s_mgw_name_value_pair.

    "this method has no real sense, just fill one field to ensure it's not initial.
    READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
    IF sy-subrc = 0.
      er_entity-migrationprojectuuid = ls_key_pair-value.
    ENDIF.

  ENDMETHOD.


  METHOD mo_clear_staging_transaction.
    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_clearstaging,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_stagingoverview,
          lo_stag_obj           TYPE REF TO /ltb/cl_mc_obj_proxy_mwb_stag,
          lv_has_error          TYPE boolean VALUE abap_false,
          ls_message            TYPE bal_s_msg,
          lv_is_job_running     TYPE boolean VALUE abap_false,
          lo_job_facade         TYPE REF TO if_dmc_sin_job_facade,
          lv_is_production      TYPE boolean.

    CONSTANTS: gc_controller_job TYPE dmc_uniform_name_acronym VALUE 'CTRL'.
    CONSTANTS gc_external_id TYPE balnrext VALUE 'clear staging table'.


    DATA(ls_changeset_request) = it_changeset_request[ 1 ].
    lo_request ?= ls_changeset_request-request_context.
    lo_request->get_converted_parameters(
      IMPORTING
       es_parameter_values = ls_parameter
     ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
        lo_stag_obj ?= lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = ls_parameter-migrationobjectuuid ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_static_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_static_exception->get_text( )
            it_message           = lo_static_exception->get_messages( )
        ).
    ENDTRY.

    "Check if system is currently deleting instance.
    CALL FUNCTION 'ENQUEUE_/LTB/E_DEL_INST'
      EXPORTING
        mode_/ltb/mc_del_inst = 'E'
        obj_uuid              = ls_parameter-migrationobjectuuid
      EXCEPTIONS
        foreign_lock          = 1
        system_failure        = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      ls_changeset_request-msg_container->add_message(
        EXPORTING
          iv_msg_type   = 'E'
          iv_msg_id     = '/LTB/MC'
          iv_msg_number = '338'
          iv_add_to_response_header = abap_true
          ).

      "Reload lastest staging table information into response.
      reload_staging_table_info( EXPORTING
                                   it_changeset_request = it_changeset_request
                                 CHANGING
                                   ct_changeset_response = ct_changeset_response ).
      RETURN.
    ENDIF.

    "In production system,we should not allow the deletion of records in case
    "there is at least a single instance which got migrated
    DATA(lv_is_cloud) = /ltb/cl_ext_cls_factory=>get_cos_utilities( )->is_cloud( ).
    IF lv_is_cloud = abap_true.
      lv_is_production = abap_true.
    ELSE.
      IF /ltb/cl_bas_utils=>is_system_editable( ) <> abap_true.
        lv_is_production = abap_true.
      ENDIF.
    ENDIF.

    IF lv_is_production = abap_true.
      TRY.
          DATA(lv_migrated_count) = lo_stag_obj->get_migrated_records_count( ).
        CATCH /ltb/cx_mc_static_check_msg INTO lo_static_exception.
          raise_bussiness_exception(
            EXPORTING
              iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
              iv_message_unlimited = lo_static_exception->get_text( )
              it_message           = lo_static_exception->get_messages( )
          ).
      ENDTRY.

      IF lv_migrated_count > 0.
        IF 1 = 0.
          MESSAGE e336(/ltb/mc).
        ENDIF.

        ls_changeset_request-msg_container->add_message(
          EXPORTING
            iv_msg_type   = 'E'
            iv_msg_id     = '/LTB/MC'
            iv_msg_number = '336'
            iv_add_to_response_header = abap_true
            ).

        "Reload lastest staging table information into response.
        reload_staging_table_info( EXPORTING
                                     it_changeset_request = it_changeset_request
                                   CHANGING
                                     ct_changeset_response = ct_changeset_response ).

        RETURN.
      ENDIF.
    ENDIF.

    DATA(lo_log_handler) = cl_dmc_log_handler=>get_or_create_loghandler( im_subobject   = cl_dmc_log_handler=>co_cobj_mnt
                                                                                     im_external_id = gc_external_id ).
    DATA(lv_delete_records_act_uuid) = /ltb/cl_mc_eventlog_access=>get_new_act_uuid( ).

    LOOP AT it_changeset_request INTO ls_changeset_request ##INTO_OK.
      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      CLEAR ls_message.
      TRY .
          lo_request ?= ls_changeset_request-request_context.
          lo_request->get_converted_parameters(
            IMPORTING
             es_parameter_values = ls_parameter
           ).

          DATA(lo_action_cntxt) = NEW /ltb/cl_mc_cntxt_action( ).

          lo_action_cntxt->add_value( iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-action
                                      iv_value = CONV #( /ltb/if_mc_action=>gc_action-del_record ) ).

          lo_action_cntxt->add_value( iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-proj_uuid
                                      iv_value = CONV #( ls_parameter-migrationprojectuuid ) ).

          lo_action_cntxt->add_value( iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-migobj_uuid
                                      iv_value = CONV #( ls_parameter-migrationobjectuuid ) ).

          lo_action_cntxt->add_value( iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-lock_indicator
                                      iv_value = CONV #( /ltb/if_mc_constants=>gc_conflict_lock_ind-lock ) ).

          "Lock action
          DATA(lo_action_checker) = /ltb/cl_mc_action_factory=>get_checker_instance( /ltb/if_mc_action=>gc_action-del_record ).
          lo_action_checker->lock( lo_action_cntxt ).

          "Conflict Check
          lo_action_checker->conflict_action_check( lo_action_cntxt ).

          "Register
          DATA ls_reg_data TYPE /ltb/cl_mc_action_queue_access=>gty_reg_data.

          ls_reg_data-action = VALUE #(
            project_guid = ls_parameter-migrationprojectuuid
            obj_guid     = ls_parameter-migrationobjectuuid
            action       = /ltb/if_mc_action=>gc_action-del_record
            scenario     = /ltb/if_mc_constants=>gc_action_scheduling-scenario-default
          ).

          ls_reg_data-param = VALUE #(
            (
              selname = 'TABNAME'
              selval  = ls_parameter-stagingtechid
            )
          ).
          DATA(lv_action_id) = /ltb/cl_mc_action_queue_access=>register_online_action( ls_reg_data ).
          TRY.
              "Clear staging table
              DATA(lo_action) = /ltb/cl_mc_action_factory=>get_instance( lv_action_id ).
              lo_action->online_process( ).
            CATCH /ltb/cx_mc_static_check_msg INTO lo_static_exception.
              lv_has_error = abap_true.
              LOOP AT lo_static_exception->get_messages( ) INTO ls_message ##INTO_OK.
                ls_changeset_request = it_changeset_request[ operation_no = ls_changeset_request-operation_no ].
                ls_changeset_request-msg_container->add_message(
                  EXPORTING
                    iv_msg_type   = ls_message-msgty
                    iv_msg_id     = ls_message-msgid
                    iv_msg_number = ls_message-msgno
                    iv_msg_v1     = ls_message-msgv1
                    iv_msg_v2     = ls_message-msgv2
                    iv_msg_v3     = ls_message-msgv3
                    iv_msg_v4     = ls_message-msgv4
                    iv_add_to_response_header = abap_true
                    ).
              ENDLOOP.
            IF lv_action_id IS NOT INITIAL.
              DATA(ls_action)  = /ltb/cl_mc_action_queue_access=>get_action( lv_action_id ).
              ls_action-status = /ltb/cl_mc_action_queue_access=>gc_action_status-failed.
              /ltb/cl_mc_action_queue_access=>update_action( ls_action ).
            ENDIF.
          ENDTRY.
         "Update action status
         IF lv_has_error = abap_false.
           ls_action  = /ltb/cl_mc_action_queue_access=>get_action( lv_action_id ).
           ls_action-status = /ltb/cl_mc_action_queue_access=>gc_action_status-finished.
           /ltb/cl_mc_action_queue_access=>update_action( ls_action ).
         ENDIF.
         "unlock the action
         lo_action_cntxt->clear_values_by_type( /ltb/if_mc_constants=>gc_cntxt_type-lock_indicator ).
         lo_action_cntxt->add_value( iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-lock_indicator
                                     iv_value = CONV #( /ltb/if_mc_constants=>gc_conflict_lock_ind-unlock ) ).
         lo_action_checker->lock(  lo_action_cntxt  ).

        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_action_error).
          lv_has_error = abap_true.
          lv_is_job_running = abap_true.
          LOOP AT lx_action_error->get_messages( ) INTO ls_message.
            ls_changeset_request = it_changeset_request[ operation_no = ls_changeset_request-operation_no ].
            ls_changeset_request-msg_container->add_message(
              EXPORTING
                iv_msg_type   = ls_message-msgty
                iv_msg_id     = ls_message-msgid
                iv_msg_number = ls_message-msgno
                iv_msg_v1     = ls_message-msgv1
                iv_msg_v2     = ls_message-msgv2
                iv_msg_v3     = ls_message-msgv3
                iv_msg_v4     = ls_message-msgv4
                iv_add_to_response_header = abap_true
                ).
          ENDLOOP.
      ENDTRY.
    ENDLOOP.

    "Reload lastest staging table information into response.
    reload_staging_table_info( EXPORTING
                                 it_changeset_request = it_changeset_request
                               CHANGING
                                 ct_changeset_response = ct_changeset_response ).


*Give a successful message if nothing wrong happens
    IF lv_has_error = abap_false.
      IF 1 = 0.
        "The data in the selected table has been successfully cleared
        MESSAGE i087(/ltb/mc).
      ENDIF.
      ls_changeset_request = it_changeset_request[ 1 ].
      ls_changeset_request-msg_container->add_message(
        EXPORTING
          iv_msg_type   = 'I'
          iv_msg_id     = '/LTB/MC'
          iv_msg_number = '087'
          iv_add_to_response_header = abap_true
          ).
      /ltb/cl_mc_eventlog_access=>record_event(
        EXPORTING
          iv_proj_uuid            = ls_parameter-migrationprojectuuid
          iv_migobj_uuid          = ls_parameter-migrationobjectuuid
          iv_act_uuid             = lv_delete_records_act_uuid                 " Activity UUID
          iv_event_type           = /ltb/cl_mc_eventlog_access=>gc_event_type-delete_record_completed
          iv_created_by           = sy-uname
          iv_lognr                = lo_log_handler->lognumber
            ).
    ELSE.
      "if the error is caused by the controller job, rasie to UI.
      IF lv_is_job_running = abap_true.
        IF 1 = 0.
          MESSAGE e113(/ltb/mc).
        ENDIF.
        ls_changeset_request = it_changeset_request[ 1 ].
        ls_changeset_request-msg_container->add_message(
          EXPORTING
            iv_msg_type   = 'E'
            iv_msg_id     = '/LTB/MC'
            iv_msg_number = '113'
            iv_add_to_response_header = abap_true
            ).
        RETURN.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD mo_content_upgrade.

    DATA:
      ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_upgradecontent,
      lt_obj_uuid  TYPE /ltb/mc_t_object_uuid,
      lv_obj_uuid  TYPE /ltb/mc_object_uuid,
      ls_response  TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response.

    FIELD-SYMBOLS:
      <fs_entity> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject.

    LOOP AT it_changeset_request ASSIGNING FIELD-SYMBOL(<fs_request>).
      CLEAR ls_parameter.

      CAST /iwbep/if_mgw_req_func_import( <fs_request>-request_context )->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter ).

      ls_response-operation_no = <fs_request>-operation_no.

      CREATE DATA ls_response-entity_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject.

      ASSIGN ls_response-entity_data->* TO <fs_entity>.

      <fs_entity>-migrationobjectuuid  = ls_parameter-migrationobjectuuid.
      <fs_entity>-migrationprojectuuid = ls_parameter-migrationprojectuuid.

      INSERT ls_response INTO TABLE ct_changeset_response.

      lv_obj_uuid = ls_parameter-migrationobjectuuid.

      INSERT lv_obj_uuid INTO TABLE lt_obj_uuid.
    ENDLOOP.

    TRY.

        DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).

        DATA(lo_proj_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).

        lo_proj_ctx->set_selected_migration_obj( lt_obj_uuid ).

        lo_proj_proxy->schedule_content_upgrade( lo_proj_ctx ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).
        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD mo_download_message.
    DATA lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import.
    DATA ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_downloadmigrationobjectmess.
    DATA ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response.
    DATA ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectmessagedownl.
    DATA lt_msg                TYPE cnv_mbt_t_bal_s_msg.
    DATA lt_filter             TYPE /ltb/if_mc_constants=>tt_sel.
    DATA lx_error              TYPE REF TO /ltb/cx_mc_static_check_msg.

    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters( IMPORTING es_parameter_values = ls_parameter ).

      TRY .
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
          DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).
          DATA(lo_object_ctx)    = NEW /ltb/cl_mc_cntxt_obj_detail( ).

          /ui2/cl_json=>deserialize( EXPORTING json        = ls_parameter-filter
                                               pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                     CHANGING  data        = lt_filter ).
          LOOP AT lt_filter ASSIGNING FIELD-SYMBOL(<ls_filter>).
            CASE <ls_filter>-fieldname.
              WHEN co_action_uuid.
                <ls_filter>-fieldname = 'ITEM_ACTION'.
              WHEN co_message_type.
                <ls_filter>-fieldname = 'ITEM_STATUS'.
              WHEN co_message_no.
                <ls_filter>-fieldname = 'MSGNO'.
              WHEN co_message_id.
                <ls_filter>-fieldname = 'MSGID'.
              WHEN OTHERS.
            ENDCASE.
          ENDLOOP.

          lo_object_ctx->set_filter( lt_filter ).
          lo_object_proxy->generate_message_file( lo_object_ctx ).

        CATCH /ltb/cx_mc_proxy_error /ltb/cx_mc_cntxt_error  INTO lx_error.
          DATA(lt_messages) = lx_error->get_messages( ).
          DESCRIBE TABLE lt_messages LINES DATA(lv_count).
          IF lv_count = 0.
            MESSAGE ID lx_error->if_t100_message~t100key-msgid TYPE 'E'
            NUMBER lx_error->if_t100_message~t100key-msgno INTO DATA(lv_msg)
            WITH lx_error->msgv1 lx_error->msgv2 lx_error->msgv3 lx_error->msgv4.
          ELSE.
            READ TABLE lt_messages INTO DATA(ls_message) INDEX 1.
            MESSAGE ID ls_message-msgid TYPE 'E' NUMBER ls_message-msgno INTO lv_msg
            WITH ls_message-msgv1 ls_message-msgv2 ls_message-msgv3 ls_message-msgv4.
          ENDIF.
          DATA(lx_mgw_bus) = NEW /iwbep/cx_mgw_busi_exception(
               textid       = /iwbep/cx_mgw_busi_exception=>business_error
               message_unlimited = lv_msg ).
          lx_mgw_bus->get_msg_container( )->add_message(
            EXPORTING
              iv_msg_type               = 'E'
              iv_msg_id                 = lx_error->if_t100_message~t100key-msgid
              iv_msg_number             = lx_error->if_t100_message~t100key-msgno
              iv_msg_text               = CONV #( lv_msg )
              iv_msg_v1                 = lx_error->msgv1
              iv_msg_v2                 = lx_error->msgv2
              iv_msg_v3                 = lx_error->msgv3
              iv_msg_v4                 = lx_error->msgv4
              iv_add_to_response_header = abap_true ).
          RAISE EXCEPTION lx_mgw_bus.
        CATCH /iwbep/cx_mgw_busi_exception INTO DATA(lo_exception).
          ls_changeset_request-msg_container->add_messages_from_container(
              io_message_container = lo_exception->get_msg_container( ) ).
      ENDTRY.

      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      ls_entity-migrationprojectuuid = ls_parameter-migrationprojectuuid.
      ls_entity-migrationobjectuuid = ls_parameter-migrationobjectuuid.

      copy_data_to_ref( EXPORTING is_data = ls_entity
                        CHANGING  cr_data = ls_changeset_response-entity_data ).
      ls_changeset_response-operation_no = ls_changeset_request-operation_no.

      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.
  ENDMETHOD.


  METHOD mo_ins_exclusion_transaction.
    TYPES:
      BEGIN OF lty_s_project,
        project_id     TYPE /ltb/mc_proj_uuid,
        object_id      TYPE /ltb/mc_object_uuid,
        object_context TYPE REF TO /ltb/cl_mc_cntxt_obj_detail,
        specific_key   TYPE /ltb/if_mc_constants=>gtt_item_uuid,
        operation_no   TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response-operation_no,
      END OF lty_s_project.

    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_excludeinstance,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationinstance,
          lt_project            TYPE TABLE OF lty_s_project WITH KEY project_id object_id,
          lv_has_error          TYPE abap_bool,
          lv_process            TYPE string,
          lv_msg_text           TYPE bapi_msg,
          lo_proxy_error        TYPE REF TO /ltb/cx_mc_proxy_error,
          lv_index              TYPE i.

    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
       ).

      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      ls_entity-migrationprojectuuid = ls_parameter-projectuuid.
      ls_entity-migrationobjectuuid = ls_parameter-objectuuid.

      TRY.
          IF NOT line_exists( lt_project[ project_id = ls_parameter-projectuuid object_id = ls_parameter-objectuuid ] ).
            DATA(lo_obj_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
            APPEND VALUE #( project_id = ls_parameter-projectuuid
                            object_id = ls_parameter-objectuuid
                            object_context = lo_obj_context
                            operation_no = ls_changeset_request-operation_no ) TO lt_project.
          ENDIF.

          ASSIGN lt_project[ project_id = ls_parameter-projectuuid object_id = ls_parameter-objectuuid ] TO FIELD-SYMBOL(<ls_project>).
          lo_obj_context = <ls_project>-object_context.

          IF ls_parameter-recordkey IS NOT INITIAL.
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-specific ).
            APPEND ls_parameter-recordkey TO <ls_project>-specific_key.
          ELSE.
            "default ls_parameter-allrecords = abap_true
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-all_items ).
          ENDIF.

        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lo_cntxt_exception).
          LOOP AT lo_cntxt_exception->get_messages( ) INTO DATA(ls_message) ##INTO_OK.
            ls_changeset_request-msg_container->add_message(
              EXPORTING
                iv_msg_type   = ls_message-msgty
                iv_msg_id     = ls_message-msgid
                iv_msg_number = ls_message-msgno
                iv_msg_v1     = ls_message-msgv1
                iv_msg_v2     = ls_message-msgv2
                iv_msg_v3     = ls_message-msgv3
                iv_msg_v4     = ls_message-msgv4
                ).
          ENDLOOP.
      ENDTRY.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.
      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.

    TRY.
        DATA(lv_run_id) = cl_system_uuid=>create_uuid_c32_static( ).
      CATCH cx_root.
*Do nothing
    ENDTRY.

    CLEAR lv_index.
    LOOP AT lt_project ASSIGNING <ls_project>.
      lv_index = lv_index + 1.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( <ls_project>-project_id ).
          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = <ls_project>-object_id ).

          <ls_project>-object_context->set_item_uuid(
            EXPORTING
              it_item_uuid = <ls_project>-specific_key ).
          <ls_project>-object_context->add_value(
            EXPORTING
              iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-run_id
              iv_value =    CONV #( lv_run_id ) ).

          IF lv_index EQ lines( lt_project ).
            <ls_project>-object_context->add_value(
             EXPORTING
               iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-no_trigger_controller
               iv_value =    CONV #( abap_false ) ).
          ELSE.
            <ls_project>-object_context->add_value(
             EXPORTING
               iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-no_trigger_controller
               iv_value =    CONV #( abap_true ) ).
          ENDIF.

          IF ls_parameter-exclude = abap_true.
            lo_obj_context->set_cntxt_exclude( iv_cntxt_exclude = /ltb/if_mc_constants=>gc_cntxt_exclude ).
          ELSE.
            lo_obj_context->set_cntxt_exclude( iv_cntxt_exclude = /ltb/if_mc_constants=>gc_cntxt_include ).
          ENDIF.

          lo_object_proxy->set_item_excluded( io_cntxt = lo_obj_context ).
        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_staic_exception).
          TRY .
              lo_proxy_error ?= lo_staic_exception.
              " This will block the selected activity to be executed when another confilict activity is running
              IF lo_proxy_error->if_t100_message~t100key = /ltb/cx_mc_proxy_error=>object_locked.
                DATA(lt_mc_messages) = lo_proxy_error->get_messages( ).
                IF lt_mc_messages IS NOT INITIAL.
                  LOOP AT lt_mc_messages INTO ls_message ##INTO_OK.
                    ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
                    ls_changeset_request-msg_container->add_message(
                      EXPORTING
                        iv_msg_type   = ls_message-msgty
                        iv_msg_id     = ls_message-msgid
                        iv_msg_number = ls_message-msgno
                        iv_msg_v1     = ls_message-msgv1
                        iv_msg_v2     = ls_message-msgv2
                        iv_msg_v3     = ls_message-msgv3
                        iv_msg_v4     = ls_message-msgv4
                        iv_add_to_response_header = abap_true
                        ).
                  ENDLOOP.
                ENDIF.
                RETURN.
              ENDIF.
            CATCH cx_sy_move_cast_error.
          ENDTRY.

          lt_mc_messages = lo_staic_exception->get_messages( ).
          IF lt_mc_messages IS NOT INITIAL.
            LOOP AT lt_mc_messages INTO ls_message ##INTO_OK.
              ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
              ls_changeset_request-msg_container->add_message(
                EXPORTING
                  iv_msg_type   = ls_message-msgty
                  iv_msg_id     = ls_message-msgid
                  iv_msg_number = ls_message-msgno
                  iv_msg_v1     = ls_message-msgv1
                  iv_msg_v2     = ls_message-msgv2
                  iv_msg_v3     = ls_message-msgv3
                  iv_msg_v4     = ls_message-msgv4
                  iv_add_to_response_header = abap_true
                  ).
            ENDLOOP.
          ENDIF.

          DATA(lv_text) = lo_staic_exception->if_message~get_text( ).
          IF lv_text IS NOT INITIAL.
            lv_msg_text = lv_text.
            ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
            ls_changeset_request-msg_container->add_message_text_only(
              EXPORTING
                iv_msg_type   = /iwbep/if_message_container=>gcs_message_type-error
                iv_msg_text   = lv_msg_text
                iv_add_to_response_header = abap_true
                ).
          ENDIF.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


  METHOD mo_migration_transaction.
    TYPES:
      BEGIN OF lty_s_project,
        project_id     TYPE /ltb/mc_proj_uuid,
        object_id      TYPE /ltb/mc_object_uuid,
        object_context TYPE REF TO /ltb/cl_mc_cntxt_obj_detail,
        specific_keys  TYPE /ltb/if_mc_constants=>gtt_item_uuid,
        operation_no   TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response-operation_no,
      END OF lty_s_project.

    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_startmigration,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          lt_project            TYPE TABLE OF lty_s_project WITH KEY project_id object_id,
          lo_proxy_error        TYPE REF TO /ltb/cx_mc_proxy_error,
          lv_msg_text           TYPE bapi_msg,
          lv_index              TYPE i.

    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
       ).

      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      ls_entity-migrationprojectuuid = ls_parameter-projectuuid.
      ls_entity-migrationobjectuuid = ls_parameter-objectuuid.

      TRY.
          IF NOT line_exists( lt_project[ project_id = ls_parameter-projectuuid object_id = ls_parameter-objectuuid ] ).
            DATA(lo_obj_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
            APPEND VALUE #( project_id = ls_parameter-projectuuid
                            object_id = ls_parameter-objectuuid
                            object_context = lo_obj_context
                            operation_no = ls_changeset_request-operation_no ) TO lt_project.
          ENDIF.

          ASSIGN lt_project[ project_id = ls_parameter-projectuuid object_id = ls_parameter-objectuuid ] TO FIELD-SYMBOL(<ls_project>).
          lo_obj_context = <ls_project>-object_context.
          IF ls_parameter-allerrorrecords = abap_true.
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-all_errors ).
          ELSEIF ls_parameter-percentageofallrecords IS NOT INITIAL.
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-random_10p ).
          ELSEIF ls_parameter-randomrecords IS NOT INITIAL.
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-random_500 ).
          ELSEIF ls_parameter-recordkey IS NOT INITIAL.
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-specific ).
            APPEND ls_parameter-recordkey TO <ls_project>-specific_keys.
          ELSEIF ls_parameter-simulatesuccess = abap_true.
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-simsuc ).
          ELSE.
            "default ls_parameter-allrecords = abap_true
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-all_items ).
          ENDIF.

          IF ls_parameter-singlestep = abap_true.
            lo_obj_context->set_single_step( abap_true ).
          ELSE.
            lo_obj_context->set_single_step( abap_false ).
          ENDIF.

        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lo_cntxt_exception).
          LOOP AT lo_cntxt_exception->get_messages( ) INTO DATA(ls_message) ##INTO_OK.
            ls_changeset_request-msg_container->add_message(
              EXPORTING
                iv_msg_type   = ls_message-msgty
                iv_msg_id     = ls_message-msgid
                iv_msg_number = ls_message-msgno
                iv_msg_v1     = ls_message-msgv1
                iv_msg_v2     = ls_message-msgv2
                iv_msg_v3     = ls_message-msgv3
                iv_msg_v4     = ls_message-msgv4
                ).
          ENDLOOP.
      ENDTRY.

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).
      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.

    TRY.
        DATA(lv_run_id) = cl_system_uuid=>create_uuid_c32_static( ).
      CATCH cx_root.
*Do nothing
    ENDTRY.

    CLEAR lv_index.
    LOOP AT lt_project ASSIGNING <ls_project>.
      lv_index = lv_index + 1.
      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( <ls_project>-project_id ).
          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = <ls_project>-object_id ).
          <ls_project>-object_context->set_item_uuid(
            EXPORTING
              it_item_uuid = <ls_project>-specific_keys ).
          <ls_project>-object_context->add_value(
                      EXPORTING
                        iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-run_id
                        iv_value =    CONV #( lv_run_id ) ).
          IF lv_index EQ lines( lt_project ).
            <ls_project>-object_context->add_value(
             EXPORTING
               iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-no_trigger_controller
               iv_value =    CONV #( abap_false ) ).
          ELSE.
            <ls_project>-object_context->add_value(
             EXPORTING
               iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-no_trigger_controller
               iv_value =    CONV #( abap_true ) ).
          ENDIF.

          lo_object_proxy->migrate_data_async( io_cntxt = <ls_project>-object_context ).
        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_staic_exception).
          TRY .
              lo_proxy_error ?= lo_staic_exception.
              " This will block the selected activity to be executed when another confilict activity is running
              IF lo_proxy_error->if_t100_message~t100key = /ltb/cx_mc_proxy_error=>object_locked.
                DATA(lt_mc_messages) = lo_proxy_error->get_messages( ).
                IF lt_mc_messages IS NOT INITIAL.
                  LOOP AT lt_mc_messages INTO ls_message ##INTO_OK.
                    ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
                    ls_changeset_request-msg_container->add_message(
                      EXPORTING
                        iv_msg_type   = ls_message-msgty
                        iv_msg_id     = ls_message-msgid
                        iv_msg_number = ls_message-msgno
                        iv_msg_v1     = ls_message-msgv1
                        iv_msg_v2     = ls_message-msgv2
                        iv_msg_v3     = ls_message-msgv3
                        iv_msg_v4     = ls_message-msgv4
                        iv_add_to_response_header = abap_true
                        ).
                  ENDLOOP.
                ENDIF.
                RETURN.
              ENDIF.
            CATCH cx_sy_move_cast_error.
          ENDTRY.

          lt_mc_messages = lo_staic_exception->get_messages( ).
          IF lt_mc_messages IS NOT INITIAL.
            LOOP AT lt_mc_messages INTO ls_message ##INTO_OK.
              ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
              ls_changeset_request-msg_container->add_message(
                EXPORTING
                  iv_msg_type   = ls_message-msgty
                  iv_msg_id     = ls_message-msgid
                  iv_msg_number = ls_message-msgno
                  iv_msg_v1     = ls_message-msgv1
                  iv_msg_v2     = ls_message-msgv2
                  iv_msg_v3     = ls_message-msgv3
                  iv_msg_v4     = ls_message-msgv4
                  iv_add_to_response_header = abap_true
                  ).
            ENDLOOP.
          ENDIF.

          DATA(lv_text) = lo_staic_exception->if_message~get_text( ).
          IF lv_text IS NOT INITIAL AND
             ( lo_staic_exception->if_t100_message~t100key NE lo_staic_exception->if_t100_message~t100key OR
               lo_staic_exception->messages IS INITIAL ).
            "When lv_text is "An exception was raised" and there is message in MESSAGES
            "Do not need to raise "An exception was raised", user can see detail message from MESSAGES
            lv_msg_text = lv_text.
            ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
            ls_changeset_request-msg_container->add_message_text_only(
              EXPORTING
                iv_msg_type   = /iwbep/if_message_container=>gcs_message_type-error
                iv_msg_text   = lv_msg_text
                iv_add_to_response_header = abap_true
                ).
          ENDIF.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.


  METHOD mo_prepare_mapping_tasks_trans.
    TYPES:
      BEGIN OF lty_s_project,
        project_id     TYPE /ltb/mc_proj_uuid,
        object_id      TYPE /ltb/mc_object_uuid,
        object_context TYPE REF TO /ltb/cl_mc_cntxt_obj_detail,
        specific_keys  TYPE /ltb/if_mc_constants=>gtt_item_uuid,
        operation_no   TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response-operation_no,
      END OF lty_s_project.

    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_preparemappingtasks,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          lt_project            TYPE TABLE OF lty_s_project WITH KEY project_id object_id,
          lo_proxy_error        TYPE REF TO /ltb/cx_mc_proxy_error,
          lv_msg_text           TYPE bapi_msg,
          lv_index              TYPE i.

    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
       ).

      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      ls_entity-migrationprojectuuid = ls_parameter-projectuuid.
      ls_entity-migrationobjectuuid = ls_parameter-objectuuid.

      TRY.
          IF NOT line_exists( lt_project[ project_id = ls_parameter-projectuuid object_id = ls_parameter-objectuuid ] ).
            DATA(lo_obj_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
            APPEND VALUE #( project_id = ls_parameter-projectuuid
                            object_id = ls_parameter-objectuuid
                            object_context = lo_obj_context
                            operation_no = ls_changeset_request-operation_no ) TO lt_project.
          ENDIF.
          ASSIGN lt_project[ project_id = ls_parameter-projectuuid object_id = ls_parameter-objectuuid ] TO FIELD-SYMBOL(<ls_project>).
          lo_obj_context = <ls_project>-object_context.
          IF ls_parameter-allerrorrecords = abap_true.
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-all_errors ).
          ELSEIF ls_parameter-recordkey IS NOT INITIAL.
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-specific ).
            APPEND ls_parameter-recordkey TO <ls_project>-specific_keys.
          ELSEIF ls_parameter-notprocessedrecords IS NOT INITIAL.
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-not_processed ).
          ELSE.
            "default is_parameter-allrecords = abap_true
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-all_items ).
          ENDIF.
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lo_cntxt_exception).
          LOOP AT lo_cntxt_exception->get_messages( ) INTO DATA(ls_message) ##INTO_OK.
            ls_changeset_request-msg_container->add_message(
              EXPORTING
                iv_msg_type   = ls_message-msgty
                iv_msg_id     = ls_message-msgid
                iv_msg_number = ls_message-msgno
                iv_msg_v1     = ls_message-msgv1
                iv_msg_v2     = ls_message-msgv2
                iv_msg_v3     = ls_message-msgv3
                iv_msg_v4     = ls_message-msgv4
                ).
          ENDLOOP.
      ENDTRY.

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).
      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.

    TRY.
        DATA(lv_run_id) = cl_system_uuid=>create_uuid_c32_static( ).
      CATCH cx_root.
*Do nothing
    ENDTRY.

    CLEAR lv_index.
    LOOP AT lt_project ASSIGNING <ls_project>.
      lv_index = lv_index + 1.
      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( <ls_project>-project_id ).
          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = <ls_project>-object_id ).
          <ls_project>-object_context->set_item_uuid(
            EXPORTING
              it_item_uuid = <ls_project>-specific_keys ).
          <ls_project>-object_context->add_value(
            EXPORTING
              iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-run_id
              iv_value =    CONV #( lv_run_id ) ).
          IF lv_index EQ lines( lt_project ).
            <ls_project>-object_context->add_value(
             EXPORTING
               iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-no_trigger_controller
               iv_value =    CONV #( abap_false ) ).
          ELSE.
            <ls_project>-object_context->add_value(
             EXPORTING
               iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-no_trigger_controller
               iv_value =    CONV #( abap_true ) ).
          ENDIF.
          lo_object_proxy->prepare_mapping_tasks_async( io_cntxt = <ls_project>-object_context ).
        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_staic_exception).
          TRY .
              lo_proxy_error ?= lo_staic_exception.
              " This will block the selected activity to be executed when another confilict activity is running
              IF lo_proxy_error->if_t100_message~t100key = /ltb/cx_mc_proxy_error=>object_locked.
                DATA(lt_mc_messages) = lo_proxy_error->get_messages( ).
                IF lt_mc_messages IS NOT INITIAL.
                  LOOP AT lt_mc_messages INTO ls_message ##INTO_OK.
                    ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
                    ls_changeset_request-msg_container->add_message(
                      EXPORTING
                        iv_msg_type   = ls_message-msgty
                        iv_msg_id     = ls_message-msgid
                        iv_msg_number = ls_message-msgno
                        iv_msg_v1     = ls_message-msgv1
                        iv_msg_v2     = ls_message-msgv2
                        iv_msg_v3     = ls_message-msgv3
                        iv_msg_v4     = ls_message-msgv4
                        iv_add_to_response_header = abap_true
                        ).
                  ENDLOOP.
                ENDIF.
                RETURN.
              ENDIF.
            CATCH cx_sy_move_cast_error.
          ENDTRY.

          lt_mc_messages = lo_staic_exception->get_messages( ).
          IF lt_mc_messages IS NOT INITIAL.
            LOOP AT lt_mc_messages INTO ls_message ##INTO_OK.
              ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
              ls_changeset_request-msg_container->add_message(
                EXPORTING
                  iv_msg_type   = ls_message-msgty
                  iv_msg_id     = ls_message-msgid
                  iv_msg_number = ls_message-msgno
                  iv_msg_v1     = ls_message-msgv1
                  iv_msg_v2     = ls_message-msgv2
                  iv_msg_v3     = ls_message-msgv3
                  iv_msg_v4     = ls_message-msgv4
                  iv_add_to_response_header = abap_true
                  ).
            ENDLOOP.
          ENDIF.

          DATA(lv_text) = lo_staic_exception->if_message~get_text( ).
          IF lv_text IS NOT INITIAL AND
             ( lo_staic_exception->if_t100_message~t100key NE lo_staic_exception->if_t100_message~t100key OR
               lo_staic_exception->messages IS INITIAL ).
            "When lv_text is "An exception was raised" and there is message in MESSAGES
            "Do not need to raise "An exception was raised", user can see detail message from MESSAGES
            ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
            ls_changeset_request-msg_container->add_message_text_only(
              EXPORTING
                iv_msg_type   = /iwbep/if_message_container=>gcs_message_type-error
                iv_msg_text   = CONV #( lv_text )
                iv_add_to_response_header = abap_true
                ).
          ENDIF.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


  METHOD mo_restart_transfer.
    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_restarttransfer,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          lo_stag_obj           TYPE REF TO /ltb/cl_mc_obj_proxy_mwb_stag,
          lv_object_guid        TYPE /ltb/mc_object_uuid,
          lv_project_guid       TYPE /ltb/mc_proj_uuid,
          lo_snd_staging        TYPE REF TO if_dmc_snd_staging,
          lo_job_facade         TYPE REF TO if_dmc_sin_job_facade,
          lv_has_error          TYPE boolean VALUE abap_false,
          ls_message            TYPE bal_s_msg,
          lv_lognr              TYPE balognr,
          lo_log_handler        TYPE REF TO cl_dmc_log_handler,
          lv_error_count        TYPE i.

    CONSTANTS: gc_controller_job TYPE dmc_uniform_name_acronym VALUE 'CTRL',
               co_external_id    TYPE balnrext VALUE 'Reset Transfer'.
    "batch job
    lv_error_count = 0.
    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
       ).

      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      CLEAR ls_message.

      TRY .
          CLEAR lo_stag_obj.
          lv_project_guid = ls_parameter-projectuuid.
          lv_object_guid = ls_parameter-objectuuid.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_guid ).
          lo_stag_obj ?= lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = lv_object_guid ).
          DATA(lo_obj_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
          DATA(lv_act_uuid) = /ltb/cl_mc_eventlog_access=>get_new_act_uuid( ).
          lo_log_handler = cl_dmc_log_handler=>get_or_create_loghandler( im_subobject   = cl_dmc_log_handler=>co_cobj_mnt
                                                                     im_external_id = co_external_id ).
          DATA(lo_scheduler) = /ltb/cl_mc_scheduler_factory=>get_scheduler( CONV #( ls_parameter-projectuuid ) ).

          lo_scheduler->lock_action(
              EXPORTING
                iv_action   = /ltb/if_mc_constants=>gc_action_scheduling-action-load
                iv_obj_guid = CONV #( ls_parameter-objectuuid )
            ).
          "check if there is any active action in the job queue
          /ltb/cl_mc_action_queue_access=>check_action_already_in_queue(
            EXPORTING
              iv_proj_guid  =   CONV #( ls_parameter-projectuuid )            " Project UUID
              iv_obj_guid   =   CONV #( ls_parameter-objectuuid )            " Object UUID
              iv_action     =   /ltb/if_mc_constants=>gc_action_scheduling-action-load               " Action for project level controller job
            RECEIVING
              rv_in_queue   =   DATA(lv_is_load_running)
          ).
          lv_has_error = lv_is_load_running.


          IF lv_has_error = abap_false.
            lo_stag_obj->restart_transfer( io_cntxt = lo_obj_context ).
          ELSE.
            lo_log_handler->set_message(
              EXPORTING
                im_message_type       =       'E'           " Nachrichtentyp
                im_message_id         =       '/LTB/MC'          " Nachrichtenklasse
                im_message_number     =       '116'        " Nachrichtennummer
                 ).
            lo_log_handler->save_log( ).
            "record the event reset failed
            /ltb/cl_mc_eventlog_access=>record_event(
                iv_proj_uuid   = CONV #( ls_parameter-projectuuid )
                iv_migobj_uuid = CONV #( ls_parameter-objectuuid )
                iv_act_uuid    = lv_act_uuid
                iv_event_type  = /ltb/cl_mc_eventlog_access=>gc_event_type-reset_failed
                iv_event_data  = ''
                iv_lognr = lo_log_handler->lognumber ).
          ENDIF.

          lo_scheduler->unlock_action(
              EXPORTING
                iv_action   = /ltb/if_mc_constants=>gc_action_scheduling-action-load
                iv_obj_guid = CONV #( ls_parameter-objectuuid )
            ).

        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_static_exception).
          lv_has_error = abap_true.
          lv_error_count = lv_error_count + 1.
          DATA(lt_err_msgs) = lo_static_exception->get_messages( ).
          LOOP AT lt_err_msgs INTO DATA(ls_err_msg).
            MESSAGE ID ls_err_msg-msgid TYPE ls_err_msg-msgty NUMBER ls_err_msg-msgno
            WITH ls_err_msg-msgv1 ls_err_msg-msgv2 ls_err_msg-msgv3 ls_err_msg-msgv4
            INTO cl_dmc_log_handler=>dummy.
            lo_log_handler->add_message( ).
          ENDLOOP.
          lo_log_handler->save_log( ).

          "record the event reset failed
          /ltb/cl_mc_eventlog_access=>record_event(
              iv_proj_uuid   = CONV #( ls_parameter-projectuuid )
              iv_migobj_uuid = CONV #( ls_parameter-objectuuid )
              iv_act_uuid    = lv_act_uuid
              iv_event_type  = /ltb/cl_mc_eventlog_access=>gc_event_type-reset_failed
              iv_event_data  = ''
              iv_lognr = lo_log_handler->lognumber ).
      ENDTRY.
      IF lv_has_error = abap_false.
        /ltb/cl_mc_eventlog_access=>record_event(
            iv_proj_uuid   = CONV #( ls_parameter-projectuuid )
            iv_migobj_uuid = CONV #( ls_parameter-objectuuid )
            iv_act_uuid    = lv_act_uuid
            iv_event_type  = /ltb/cl_mc_eventlog_access=>gc_event_type-reset_completed
            iv_event_data  = ''
            iv_lognr = lo_log_handler->lognumber ).
      ENDIF.
      ls_changeset_response-operation_no = ls_changeset_request-operation_no.
      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).
      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.
*Give a successful message if nothing wrong happens
    IF lv_has_error = abap_false.
      IF 1 = 0.
        "Transfer status has been reset
        MESSAGE i123(/ltb/mc).
      ENDIF.
      ls_changeset_request = it_changeset_request[ 1 ].
      ls_changeset_request-msg_container->add_message(
        EXPORTING
          iv_msg_type   = 'I'
          iv_msg_id     = '/LTB/MC'
          iv_msg_number = '123'
          iv_add_to_response_header = abap_true
          ).
    ELSE.
      IF 1 = 0.
        "$1 object failed reset, see this MO's details page history tab for detail information
        MESSAGE e117(/ltb/mc).
      ENDIF.
      ls_changeset_request = it_changeset_request[ 1 ].
      ls_changeset_request-msg_container->add_message(
        EXPORTING
          iv_msg_type   = 'E'
          iv_msg_id     = '/LTB/MC'
          iv_msg_number = '117'
          iv_msg_v1     = CONV #( lv_error_count )
          iv_add_to_response_header = abap_true
          ).

    ENDIF.
  ENDMETHOD.


  METHOD mo_selection_transaction.
    TYPES:
      BEGIN OF lty_s_project,
        project_id     TYPE /ltb/mc_proj_uuid,
        object_id      TYPE /ltb/mc_object_uuid,
        object_context TYPE REF TO /ltb/cl_mc_cntxt_obj_detail,
        specific_keys  TYPE /ltb/if_mc_constants=>gtt_item_uuid,
        operation_no   TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response-operation_no,
      END OF lty_s_project.

    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_selectdata,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          lt_project            TYPE TABLE OF lty_s_project WITH KEY project_id object_id,
          lt_err_objs           TYPE TABLE OF lty_s_project WITH KEY project_id object_id,
          lv_operation_no       TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response-operation_no,
          lo_proxy_error        TYPE REF TO /ltb/cx_mc_proxy_error,
          lv_lognr              TYPE balognr,
          lv_index              TYPE i.

    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
       ).

      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      ls_entity-migrationprojectuuid = ls_parameter-migrationprojectuuid.
      ls_entity-migrationobjectuuid = ls_parameter-migrationobjectuuid.

      TRY.
          IF NOT line_exists( lt_project[ project_id = ls_parameter-migrationprojectuuid object_id = ls_parameter-migrationobjectuuid ] ).
            DATA(lo_obj_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
            APPEND VALUE #( project_id = ls_parameter-migrationprojectuuid
                            object_id = ls_parameter-migrationobjectuuid
                            object_context = lo_obj_context
                            operation_no = ls_changeset_request-operation_no ) TO lt_project.
          ENDIF.
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lo_cntxt_exception).
          TRY.
              CLEAR lv_lognr.
              DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
              DATA(lt_msg) = lo_cntxt_exception->get_messages( ).

              lv_lognr = lo_appl_proxy->create_appl_log(
                                 EXPORTING
                                   iv_obj_id     = ls_parameter-migrationobjectuuid
                                   it_msg        = lt_msg
                                ).
            CATCH /ltb/cx_mc_proxy_error.
              "do noting, let the event log continue to create
          ENDTRY.

          DATA(ls_proj) = /ltb/cl_mc_proj_access=>get_by_uuid( ls_parameter-migrationprojectuuid ).

          DATA(lv_event_type) = COND /ltb/mc_event_type(
            WHEN ls_proj-approach = /ltb/if_mc_constants=>gc_approach-sap_direct
              THEN /ltb/cl_mc_eventlog_access=>gc_event_type-selection_failed
            WHEN ls_proj-approach = /ltb/if_mc_constants=>gc_approach-staging
              THEN /ltb/cl_mc_eventlog_access=>gc_event_type-preparation_failed ).

          /ltb/cl_mc_eventlog_access=>record_event(
            iv_proj_uuid   = ls_parameter-migrationprojectuuid
            iv_migobj_uuid = ls_parameter-migrationobjectuuid
            iv_event_type  = lv_event_type
            iv_lognr = lv_lognr ).

          APPEND VALUE #( project_id = ls_parameter-migrationprojectuuid
                          object_id = ls_parameter-migrationobjectuuid ) TO lt_err_objs.
      ENDTRY.

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).
      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.

    TRY.
        DATA(lv_run_id) = cl_system_uuid=>create_uuid_c32_static( ).
      CATCH cx_root.
*Do nothing
    ENDTRY.

    CLEAR lv_index.
    LOOP AT lt_project ASSIGNING FIELD-SYMBOL(<ls_project>).
      lv_index = lv_index + 1.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( <ls_project>-project_id ).
          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = <ls_project>-object_id ).
          <ls_project>-object_context->set_item_uuid(
            EXPORTING
              it_item_uuid = <ls_project>-specific_keys ).
          <ls_project>-object_context->add_value(
            EXPORTING
              iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-run_id
              iv_value =    CONV #( lv_run_id ) ).
          <ls_project>-object_context->add_value(
           EXPORTING
             iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-selection_mode
             iv_value =    CONV #( ls_parameter-selectionmode )  ).

          <ls_project>-object_context->add_value(
           EXPORTING
             iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-check_consistency
             iv_value =    CONV #( ls_parameter-checkconsistency ) ).

          IF lv_index EQ lines( lt_project ).
            <ls_project>-object_context->add_value(
             EXPORTING
               iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-no_trigger_controller
               iv_value =    CONV #( abap_false ) ).
          ELSE.
            <ls_project>-object_context->add_value(
             EXPORTING
               iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-no_trigger_controller
               iv_value =    CONV #( abap_true ) ).
          ENDIF.

          lo_object_proxy->select_data_async( io_cntxt = <ls_project>-object_context ).
        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_staic_exception).
          TRY .
              lo_proxy_error ?= lo_staic_exception.
              " This will block the selected activity to be executed when another confilict activity is running
              IF lo_proxy_error->if_t100_message~t100key = /ltb/cx_mc_proxy_error=>object_locked.
                DATA(lt_mc_messages) = lo_proxy_error->get_messages( ).
                IF lt_mc_messages IS NOT INITIAL.
                  LOOP AT lt_mc_messages INTO DATA(ls_message) ##INTO_OK.
                    ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
                    ls_changeset_request-msg_container->add_message(
                      EXPORTING
                        iv_msg_type   = ls_message-msgty
                        iv_msg_id     = ls_message-msgid
                        iv_msg_number = ls_message-msgno
                        iv_msg_v1     = ls_message-msgv1
                        iv_msg_v2     = ls_message-msgv2
                        iv_msg_v3     = ls_message-msgv3
                        iv_msg_v4     = ls_message-msgv4
                        iv_add_to_response_header = abap_true
                        ).
                  ENDLOOP.
                ENDIF.
                RETURN.
              ENDIF.
            CATCH cx_sy_move_cast_error.
          ENDTRY.

          lt_mc_messages = lo_staic_exception->get_messages( ).
          IF lt_mc_messages IS NOT INITIAL.
            LOOP AT lt_mc_messages INTO ls_message ##INTO_OK.
              ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
              ls_changeset_request-msg_container->add_message(
                EXPORTING
                  iv_msg_type   = ls_message-msgty
                  iv_msg_id     = ls_message-msgid
                  iv_msg_number = ls_message-msgno
                  iv_msg_v1     = ls_message-msgv1
                  iv_msg_v2     = ls_message-msgv2
                  iv_msg_v3     = ls_message-msgv3
                  iv_msg_v4     = ls_message-msgv4
                  iv_add_to_response_header = abap_true
                  ).
            ENDLOOP.
          ENDIF.

          DATA(lv_text) = lo_staic_exception->if_message~get_text( ).
          IF lv_text IS NOT INITIAL AND
             ( lo_staic_exception->if_t100_message~t100key NE lo_staic_exception->if_t100_message~t100key OR
               lo_staic_exception->messages IS INITIAL ).
            "When lv_text is "An exception was raised" and there is message in MESSAGES
            "Do not need to raise "An exception was raised", user can see detail message from MESSAGES
            ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
            ls_changeset_request-msg_container->add_message_text_only(
              EXPORTING
                iv_msg_type   = /iwbep/if_message_container=>gcs_message_type-error
                iv_msg_text   = CONV #( lv_text )
                iv_add_to_response_header = abap_true
                ).
          ENDIF.

          APPEND VALUE #( project_id = <ls_project>-project_id
                          object_id = <ls_project>-object_id ) TO lt_err_objs.
      ENDTRY.
    ENDLOOP.

    DATA(lv_num_failure) = lines( lt_err_objs ).
    IF lv_num_failure = 1.
      CLEAR lo_project_proxy.
      CLEAR lo_object_proxy.
      CLEAR lo_obj_context.
      DATA(lv_err_obj) = lt_err_objs[ 1 ]-object_id.
      TRY.
          lo_project_proxy = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lt_err_objs[ 1 ]-project_id ).
          lo_object_proxy = lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = lt_err_objs[ 1 ]-object_id ).
          lo_obj_context = NEW /ltb/cl_mc_cntxt_obj_detail( ).
          DATA(ls_detail) = lo_object_proxy->get_details( lo_obj_context ).
          lv_err_obj = ls_detail-migobj_descr.
        CATCH cx_root.
          lv_err_obj = lt_err_objs[ 1 ]-object_id.
      ENDTRY.

      ls_changeset_request = it_changeset_request[ 1 ].

      CASE ls_proj-approach.
        WHEN /ltb/if_mc_constants=>gc_approach-sap_direct.
          IF 1 = 0.
            "'&1' is failed selection, please check activity panel for details
            MESSAGE e080(/ltb/mc).
          ENDIF.

          ls_changeset_request-msg_container->add_message(
            EXPORTING
              iv_msg_type   = 'E'
              iv_msg_id     = '/LTB/MC'
              iv_msg_number = '080'
              iv_msg_v1     = CONV #( lv_err_obj )
              iv_add_to_response_header = abap_true
              ).
        WHEN /ltb/if_mc_constants=>gc_approach-staging.
          IF 1 = 0.
            "Preparation failed for ‘&1’; for details see ‘Activity Tracking’ area
            MESSAGE e138(/ltb/mc).
          ENDIF.

          ls_changeset_request-msg_container->add_message(
            EXPORTING
              iv_msg_type   = 'E'
              iv_msg_id     = '/LTB/MC'
              iv_msg_number = '138'
              iv_msg_v1     = CONV #( lv_err_obj )
              iv_add_to_response_header = abap_true
              ).
      ENDCASE.
    ELSEIF lv_num_failure > 1.
      ls_changeset_request = it_changeset_request[ 1 ].

      CASE ls_proj-approach.
        WHEN /ltb/if_mc_constants=>gc_approach-sap_direct.
          IF 1 = 0.
            "&1 objects are failed selection, check activity panel for details.
            MESSAGE e081(/ltb/mc).
          ENDIF.
          ls_changeset_request-msg_container->add_message(
            EXPORTING
              iv_msg_type   = 'E'
              iv_msg_id     = '/LTB/MC'
              iv_msg_number = '081'
              iv_msg_v1     = CONV #( lv_num_failure )
              iv_add_to_response_header = abap_true
              ).
        WHEN /ltb/if_mc_constants=>gc_approach-staging.
          IF 1 = 0.
            "Preparation failed for &1 objects; for details see ‘Activity Tracking’
            MESSAGE e139(/ltb/mc).
          ENDIF.

          ls_changeset_request-msg_container->add_message(
            EXPORTING
              iv_msg_type   = 'E'
              iv_msg_id     = '/LTB/MC'
              iv_msg_number = '139'
              iv_msg_v1     = CONV #( lv_err_obj )
              iv_add_to_response_header = abap_true
              ).
      ENDCASE.

    ENDIF.
  ENDMETHOD.


  METHOD mo_simulation_transaction.
    TYPES:
      BEGIN OF lty_s_project,
        project_id     TYPE /ltb/mc_proj_uuid,
        object_id      TYPE /ltb/mc_object_uuid,
        object_context TYPE REF TO /ltb/cl_mc_cntxt_obj_detail,
        specific_keys  TYPE /ltb/if_mc_constants=>gtt_item_uuid,
        operation_no   TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response-operation_no,
      END OF lty_s_project.

    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_simulation,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationobject,
          lt_project            TYPE TABLE OF lty_s_project WITH KEY project_id object_id,
          lo_proxy_error        TYPE REF TO /ltb/cx_mc_proxy_error,
          lv_msg_text           TYPE bapi_msg,
          lv_index              TYPE i.

    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
       ).

      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      ls_entity-migrationprojectuuid = ls_parameter-projectuuid.
      ls_entity-migrationobjectuuid = ls_parameter-objectuuid.

      TRY.
          IF NOT line_exists( lt_project[ project_id = ls_parameter-projectuuid object_id = ls_parameter-objectuuid ] ).
            DATA(lo_obj_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
            APPEND VALUE #( project_id = ls_parameter-projectuuid
                            object_id = ls_parameter-objectuuid
                            object_context = lo_obj_context
                            operation_no = ls_changeset_request-operation_no ) TO lt_project.
          ENDIF.

          ASSIGN lt_project[ project_id = ls_parameter-projectuuid object_id = ls_parameter-objectuuid ] TO FIELD-SYMBOL(<ls_project>).
          lo_obj_context = <ls_project>-object_context.
          IF ls_parameter-allerrorrecords = abap_true.
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-all_errors ).
          ELSEIF ls_parameter-percentageofallrecords IS NOT INITIAL.
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-random_10p ).
          ELSEIF ls_parameter-randomrecords IS NOT INITIAL.
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-random_500 ).
          ELSEIF ls_parameter-recordkey IS NOT INITIAL.
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-specific ).
            APPEND ls_parameter-recordkey TO <ls_project>-specific_keys.
          ELSE.
            "default ls_parameter-allrecords = abap_true
            lo_obj_context->set_transfer_type( iv_transfer_type = /ltb/if_mc_constants=>gc_transfer_type-all_items ).
          ENDIF.
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lo_cntxt_exception).
          LOOP AT lo_cntxt_exception->get_messages( ) INTO DATA(ls_message) ##INTO_OK.
            ls_changeset_request-msg_container->add_message(
              EXPORTING
                iv_msg_type   = ls_message-msgty
                iv_msg_id     = ls_message-msgid
                iv_msg_number = ls_message-msgno
                iv_msg_v1     = ls_message-msgv1
                iv_msg_v2     = ls_message-msgv2
                iv_msg_v3     = ls_message-msgv3
                iv_msg_v4     = ls_message-msgv4
                ).
          ENDLOOP.
      ENDTRY.

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.

      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).
      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.
    TRY.
        DATA(lv_run_id) = cl_system_uuid=>create_uuid_c32_static( ).
      CATCH cx_root.
*Do nothing
    ENDTRY.

    CLEAR lv_index.
    LOOP AT lt_project ASSIGNING <ls_project>.
      lv_index = lv_index + 1.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( <ls_project>-project_id ).
          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = <ls_project>-object_id ).
          <ls_project>-object_context->set_item_uuid(
            EXPORTING
              it_item_uuid = <ls_project>-specific_keys ).
          <ls_project>-object_context->add_value(
            EXPORTING
              iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-run_id
              iv_value =    CONV #( lv_run_id ) ).

          IF lv_index EQ lines( lt_project ).
            <ls_project>-object_context->add_value(
             EXPORTING
               iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-no_trigger_controller
               iv_value =    CONV #( abap_false ) ).
          ELSE.
            <ls_project>-object_context->add_value(
             EXPORTING
               iv_type  =    /ltb/if_mc_constants=>gc_cntxt_type-no_trigger_controller
               iv_value =    CONV #( abap_true ) ).
          ENDIF.

          lo_object_proxy->simulate_data_async( io_cntxt = <ls_project>-object_context ).
        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_staic_exception).
          TRY .
              lo_proxy_error ?= lo_staic_exception.
              " This will block the selected activity to be executed when another confilict activity is running
              IF lo_proxy_error->if_t100_message~t100key = /ltb/cx_mc_proxy_error=>object_locked.
                DATA(lt_mc_messages) = lo_proxy_error->get_messages( ).
                IF lt_mc_messages IS NOT INITIAL.
                  LOOP AT lt_mc_messages INTO ls_message ##INTO_OK.
                    ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
                    ls_changeset_request-msg_container->add_message(
                      EXPORTING
                        iv_msg_type   = ls_message-msgty
                        iv_msg_id     = ls_message-msgid
                        iv_msg_number = ls_message-msgno
                        iv_msg_v1     = ls_message-msgv1
                        iv_msg_v2     = ls_message-msgv2
                        iv_msg_v3     = ls_message-msgv3
                        iv_msg_v4     = ls_message-msgv4
                        iv_add_to_response_header = abap_true
                        ).
                  ENDLOOP.
                ENDIF.
                RETURN.
              ENDIF.
            CATCH cx_sy_move_cast_error.
          ENDTRY.

          lt_mc_messages = lo_staic_exception->get_messages( ).
          IF lt_mc_messages IS NOT INITIAL.
            LOOP AT lt_mc_messages INTO ls_message ##INTO_OK.
              ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
              ls_changeset_request-msg_container->add_message(
                EXPORTING
                  iv_msg_type   = ls_message-msgty
                  iv_msg_id     = ls_message-msgid
                  iv_msg_number = ls_message-msgno
                  iv_msg_v1     = ls_message-msgv1
                  iv_msg_v2     = ls_message-msgv2
                  iv_msg_v3     = ls_message-msgv3
                  iv_msg_v4     = ls_message-msgv4
                  iv_add_to_response_header = abap_true
                  ).
            ENDLOOP.
          ENDIF.

          DATA(lv_text) = lo_staic_exception->if_message~get_text( ).
          IF lv_text IS NOT INITIAL AND
             ( lo_staic_exception->if_t100_message~t100key NE lo_staic_exception->if_t100_message~t100key OR
               lo_staic_exception->messages IS INITIAL ).
            "When lv_text is "An exception was raised" and there is message in MESSAGES
            "Do not need to raise "An exception was raised", user can see detail message from MESSAGES
            lv_msg_text = lv_text.
            ls_changeset_request = it_changeset_request[ operation_no = <ls_project>-operation_no ].
            ls_changeset_request-msg_container->add_message_text_only(
              EXPORTING
                iv_msg_type   = /iwbep/if_message_container=>gcs_message_type-error
                iv_msg_text   = lv_msg_text
                iv_add_to_response_header = abap_true
                ).
          ENDIF.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.


  METHOD mo_sync_staging_transaction.
    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_syncstaging,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_stagingoverview,
          lo_stag_obj           TYPE REF TO /ltb/cl_mc_obj_proxy_mwb_stag,
          lv_has_error          TYPE boolean VALUE abap_false,
          ls_message            TYPE bal_s_msg,
          lv_is_job_running     TYPE boolean VALUE abap_false,
          lo_job_facade         TYPE REF TO if_dmc_sin_job_facade,
          lx_mo_lock_hander     TYPE REF TO cx_dmc_lock_handler,
          lv_object_guid        TYPE /ltb/mc_object_uuid,
          lv_is_check_needed    TYPE boolean.

    CONSTANTS: gc_controller_job TYPE dmc_uniform_name_acronym VALUE 'CTRL',
               co_external_id    TYPE balnrext VALUE 'Sync Staging'.

    DATA(lo_log_handler) = cl_dmc_log_handler=>get_or_create_loghandler(
                             im_subobject   = cl_dmc_log_handler=>co_cobj_mnt
                             im_external_id = co_external_id
                           ).

    CLEAR lv_object_guid.
    "initial set the check needed
    lv_is_check_needed = abap_true.
    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
       ).
      "only need to lock the MO and check the controller job once
      IF lv_object_guid IS INITIAL.
        lv_object_guid = ls_parameter-migrationobjectuuid.
        CLEAR ls_changeset_response.
        CLEAR ls_entity.
        CLEAR ls_message.
        DATA(lo_mo_lock_handler) = cl_dmc_migobj_lock_handler=>new(
                                           iv_guid         = CONV #( ls_parameter-migrationobjectuuid )
                                           iv_excl_staging = abap_true
                                           iv_excl_taskobj = abap_true
                                           iv_excl_taskval = abap_true
                                         ).
        "lock MO
        TRY .
            lo_mo_lock_handler->lock( ).
          CATCH cx_dmc_lock_handler INTO lx_mo_lock_hander.
            lv_has_error = abap_true.
            LOOP AT lx_mo_lock_hander->get_messages( ) INTO ls_message ##INTO_OK.
              ls_changeset_request = it_changeset_request[ operation_no = ls_changeset_request-operation_no ].
              ls_changeset_request-msg_container->add_message(
                EXPORTING
                  iv_msg_type   = ls_message-msgty
                  iv_msg_id     = ls_message-msgid
                  iv_msg_number = ls_message-msgno
                  iv_msg_v1     = ls_message-msgv1
                  iv_msg_v2     = ls_message-msgv2
                  iv_msg_v3     = ls_message-msgv3
                  iv_msg_v4     = ls_message-msgv4
                  iv_add_to_response_header = abap_true
                  ).
            ENDLOOP.
        ENDTRY.
      ENDIF.
      IF lv_has_error = abap_false.
        TRY.
            CLEAR lo_stag_obj.
            DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
            lo_stag_obj ?= lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = ls_parameter-migrationobjectuuid ).
            DATA(lo_obj_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
            lo_stag_obj->sync_staging_table( EXPORTING
                                               io_cntxt = lo_obj_context
                                               iv_tabname = CONV #( ls_parameter-stagingtechid )
                                               iv_struct_ident = CONV #( ls_parameter-techname )
                                             IMPORTING
                                               ev_staging_tab  = DATA(lv_staging_tab)
                                             ).
          CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_static_exception).
            lv_has_error = abap_true.
            "unlock the MO
            TRY .
                lo_mo_lock_handler->unlock( ).
              CATCH cx_dmc_lock_handler INTO lx_mo_lock_hander.
                lv_has_error = abap_true.
                LOOP AT lx_mo_lock_hander->get_messages( ) INTO ls_message ##INTO_OK.
                  ls_changeset_request = it_changeset_request[ operation_no = ls_changeset_request-operation_no ].
                  ls_changeset_request-msg_container->add_message(
                    EXPORTING
                      iv_msg_type   = ls_message-msgty
                      iv_msg_id     = ls_message-msgid
                      iv_msg_number = ls_message-msgno
                      iv_msg_v1     = ls_message-msgv1
                      iv_msg_v2     = ls_message-msgv2
                      iv_msg_v3     = ls_message-msgv3
                      iv_msg_v4     = ls_message-msgv4
                      iv_add_to_response_header = abap_true
                      ).
                ENDLOOP.
            ENDTRY.
            LOOP AT lo_static_exception->get_messages( ) INTO ls_message ##INTO_OK.
              ls_changeset_request = it_changeset_request[ operation_no = ls_changeset_request-operation_no ].
              ls_changeset_request-msg_container->add_message(
                EXPORTING
                  iv_msg_type   = ls_message-msgty
                  iv_msg_id     = ls_message-msgid
                  iv_msg_number = ls_message-msgno
                  iv_msg_v1     = ls_message-msgv1
                  iv_msg_v2     = ls_message-msgv2
                  iv_msg_v3     = ls_message-msgv3
                  iv_msg_v4     = ls_message-msgv4
                  iv_add_to_response_header = abap_true
                  ).
            ENDLOOP.
        ENDTRY.
      ENDIF.

      TRY.
*Reload lastest staging table information into response.
          lo_obj_context = NEW /ltb/cl_mc_cntxt_obj_detail( ).
          lo_obj_context->set_consistency_check( lv_is_check_needed ).
          "after the sync, the connection is closed, we should get a new obj
          CLEAR lo_stag_obj.
          CLEAR lo_project_proxy.
          lo_project_proxy = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
          lo_stag_obj ?= lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = ls_parameter-migrationobjectuuid ).
          DATA(ls_table_header) = lo_stag_obj->get_table_header(  io_cntxt = lo_obj_context
                                                                  iv_tabname = lv_staging_tab ).
          "after get_table_header, set the check not needed.
          lv_is_check_needed = abap_false.
          ls_entity = VALUE #( migrationprojectuuid = ls_parameter-migrationprojectuuid
                               migrationobjectuuid = ls_parameter-migrationobjectuuid
                               name = ls_table_header-description
                               techname = ls_table_header-tab_uuid
                               techid = lv_staging_tab
                               datacount = ls_table_header-num_records
                               status = ls_table_header-is_consistent
                               createdby = ls_table_header-createdby
                               createdon = ls_table_header-createdon ).
        CATCH /ltb/cx_mc_static_check_msg.
          ls_entity = VALUE #( migrationprojectuuid = ls_parameter-migrationprojectuuid
                               migrationobjectuuid = ls_parameter-migrationobjectuuid
                               techid = ls_parameter-stagingtechid ).
      ENDTRY.

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.
      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).
      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.


    "unlock the MO
    TRY .
        lo_mo_lock_handler->unlock( ).
      CATCH cx_dmc_lock_handler INTO lx_mo_lock_hander.
        lv_has_error = abap_true.
        LOOP AT lx_mo_lock_hander->get_messages( ) INTO ls_message ##INTO_OK.
          ls_changeset_request = it_changeset_request[ operation_no = ls_changeset_request-operation_no ].
          ls_changeset_request-msg_container->add_message(
            EXPORTING
              iv_msg_type   = ls_message-msgty
              iv_msg_id     = ls_message-msgid
              iv_msg_number = ls_message-msgno
              iv_msg_v1     = ls_message-msgv1
              iv_msg_v2     = ls_message-msgv2
              iv_msg_v3     = ls_message-msgv3
              iv_msg_v4     = ls_message-msgv4
              iv_add_to_response_header = abap_true
              ).
        ENDLOOP.
    ENDTRY.
*Give a successful message if nothing wrong happens
    IF lv_has_error = abap_false.
      IF 1 = 0.
        "The data in the selected table has been successfully cleared
        MESSAGE i088(/ltb/mc).
      ENDIF.
      ls_changeset_request = it_changeset_request[ 1 ].
      ls_changeset_request-msg_container->add_message(
        EXPORTING
          iv_msg_type   = 'I'
          iv_msg_id     = '/LTB/MC'
          iv_msg_number = '088'
          iv_add_to_response_header = abap_true
          ).
    ELSE.
      "if the error is caused by the controller job, rasie to UI.
      IF lv_is_job_running = abap_true.
        IF 1 = 0.
          MESSAGE e116(/ltb/mc).
        ENDIF.
        ls_changeset_request = it_changeset_request[ 1 ].
        ls_changeset_request-msg_container->add_message(
          EXPORTING
            iv_msg_type   = 'E'
            iv_msg_id     = '/LTB/MC'
            iv_msg_number = '116'
            iv_add_to_response_header = abap_true
            ).
        RETURN.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD no_cache.
    DATA: ls_header TYPE ihttpnvp.

    ls_header-name  = 'Cache-Control'.
    ls_header-value = 'no-cache, no-store'.
    me->/iwbep/if_mgw_conv_srv_runtime~set_header( is_header =  ls_header ).
    CLEAR ls_header.
    ls_header-name  = 'Pragma'.
    ls_header-value = 'no-cache'.
    me->/iwbep/if_mgw_conv_srv_runtime~set_header( is_header =  ls_header ).
  ENDMETHOD.


  METHOD proj_restart_preparation.

    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_restartprojectpreparation,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationprojectprepinfo,
          lv_proj_prep_status   TYPE /ltb/mc_proj_prep_status,
          lt_msg                TYPE cnv_mbt_t_bal_s_msg.

    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
       ).

      TRY .
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
          lo_project_proxy->restart_proj_prep(
            IMPORTING
              ev_proj_prep_status = lv_proj_prep_status ).
          IF lv_proj_prep_status = /ltb/if_mc_constants=>gc_proj_prep_status-error.
            IF 1 = 2. MESSAGE e102(/ltb/mc). ENDIF.
            "Failed to add migration objects to a project
            lt_msg = VALUE #( BASE lt_msg
                               (
                                 msgty       = 'E'
                                 msgid       = '/LTB/MC'
                                 msgno       = 102
                                )
                             ).

            RAISE EXCEPTION TYPE /ltb/cx_mc_proxy_error
              EXPORTING
                messages = lt_msg.
          ENDIF.
        CATCH /ltb/cx_mc_proxy_error  INTO DATA(lx_error).
          DATA(lt_messages) = lx_error->get_messages( ).
          DESCRIBE TABLE lt_messages LINES DATA(lv_count).
          IF lv_count = 0.
            MESSAGE ID lx_error->if_t100_message~t100key-msgid TYPE 'E'
            NUMBER lx_error->if_t100_message~t100key-msgno INTO DATA(lv_msg)
            WITH lx_error->msgv1 lx_error->msgv2 lx_error->msgv3 lx_error->msgv4.
          ELSE.
            READ TABLE lt_messages INTO DATA(ls_message) INDEX 1.
            MESSAGE ID ls_message-msgid TYPE 'E' NUMBER ls_message-msgno INTO lv_msg
            WITH ls_message-msgv1 ls_message-msgv2 ls_message-msgv3 ls_message-msgv4.
          ENDIF.
          DATA(lx_mgw_bus) = NEW /iwbep/cx_mgw_busi_exception(
               textid       = /iwbep/cx_mgw_busi_exception=>business_error
               message_unlimited = lv_msg ).
          lx_mgw_bus->get_msg_container( )->add_message(
            EXPORTING
              iv_msg_type               = 'E'
              iv_msg_id                 = lx_error->if_t100_message~t100key-msgid
              iv_msg_number             = lx_error->if_t100_message~t100key-msgno
              iv_msg_text               = CONV #( lv_msg )
              iv_msg_v1                 = lx_error->msgv1
              iv_msg_v2                 = lx_error->msgv2
              iv_msg_v3                 = lx_error->msgv3
              iv_msg_v4                 = lx_error->msgv4
              iv_add_to_response_header = abap_true ).
          RAISE EXCEPTION lx_mgw_bus.
        CATCH /iwbep/cx_mgw_busi_exception INTO DATA(lo_exception).
          ls_changeset_request-msg_container->add_messages_from_container(
              io_message_container = lo_exception->get_msg_container( ) ).
      ENDTRY.

      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      ls_entity-migrationprojectuuid = ls_parameter-migrationprojectuuid.
*      lo_project_proxy->has_proj_prep_failed( IMPORTING ev_failed = ls_entity-preparefailed ).

      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).
      ls_changeset_response-operation_no = ls_changeset_request-operation_no.

      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.
  ENDMETHOD.


  METHOD raise_bussiness_exception.
    DATA(lo_exception) = NEW /iwbep/cx_mgw_busi_exception( textid = iv_textid ).
    IF iv_message_unlimited IS SUPPLIED.
      lo_exception->message_unlimited = iv_message_unlimited.
    ENDIF.

    IF io_message_container IS BOUND.
      lo_exception->message_container = io_message_container.
    ENDIF.

    DATA(lt_messages) = it_message.

    filter_tech_messages( CHANGING it_messages = lt_messages ).

    IF lt_messages IS NOT INITIAL.
      IF lo_exception->message_container IS NOT BOUND.
        lo_exception->message_container = mo_context->get_message_container( ).
      ENDIF.

      LOOP AT lt_messages INTO DATA(ls_message) ##INTO_OK.
        lo_exception->message_container->add_message(
          EXPORTING
            iv_msg_type   = ls_message-msgty
            iv_msg_id     = ls_message-msgid
            iv_msg_number = ls_message-msgno
            iv_msg_v1     = ls_message-msgv1
            iv_msg_v2     = ls_message-msgv2
            iv_msg_v3     = ls_message-msgv3
            iv_msg_v4     = ls_message-msgv4
            ).
      ENDLOOP.
    ENDIF.
    RAISE EXCEPTION lo_exception.
  ENDMETHOD.


  METHOD recentactionset_get_entityset.
    DATA: lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid.

    DATA: ls_filter_request TYPE /iwbep/s_mgw_select_option,
          ls_filter_option  TYPE /iwbep/s_cod_select_option,
          lt_filter         TYPE /ltb/if_mc_constants=>gtt_filter_cond,
          ls_entityset      TYPE /ltb/cl_mig_mc_odata_mpc=>ts_recentaction.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_recentaction.
      READ TABLE it_filter_select_options WITH KEY property = co_migration_project_uuid
        INTO ls_filter_request.
      IF sy-subrc = 0.
        READ TABLE ls_filter_request-select_options INTO ls_filter_option INDEX 1.
        lv_proj_uuid = ls_filter_option-low.
      ENDIF.

      READ TABLE it_filter_select_options WITH KEY property = co_migration_object_uuid
        INTO ls_filter_request.
      IF sy-subrc = 0.
        READ TABLE ls_filter_request-select_options INTO ls_filter_option INDEX 1.
        lv_obj_uuid = ls_filter_option-low.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

          DATA(lt_actions) = lo_object_proxy->get_recent_action( ).

          et_entityset = VALUE #( FOR ls_action IN lt_actions
                                  ( migrationprojectuuid        = lv_proj_uuid
                                    migrationobjectuuid         = lv_obj_uuid
                                    actionuuid                  = ls_action-action_uuid
                                    actiondescription           = ls_action-action_descr
                                    actiontimeat                = ls_action-action_time_at
                                  ) ).

        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.

*
*      ls_entityset-migrationprojectuuid = lv_proj_uuid.
*      ls_entityset-migrationobjectuuid = lv_obj_uuid.
*      ls_entityset-actionuuid = 'S'.
*      ls_entityset-actiondescription = 'Simulation'.
*      APPEND ls_entityset TO et_entityset.
    ENDIF.
  ENDMETHOD.


  METHOD reload_staging_table_info.
    DATA: lo_stag_obj           TYPE REF TO /ltb/cl_mc_obj_proxy_mwb_stag,
          lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_clearstaging,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_stagingoverview.

    DATA(ls_changeset_request) = it_changeset_request[ 1 ].
    lo_request ?= ls_changeset_request-request_context.
    lo_request->get_converted_parameters(
      IMPORTING
       es_parameter_values = ls_parameter
     ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
        lo_stag_obj ?= lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = ls_parameter-migrationobjectuuid ).

        DATA(lo_obj_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
        lo_obj_context->set_consistency_check( abap_true ).
        LOOP AT it_changeset_request INTO ls_changeset_request.
          lo_request ?= ls_changeset_request-request_context.
          lo_request->get_converted_parameters(
            IMPORTING
             es_parameter_values = ls_parameter
           ).

          DATA(ls_table_header) = lo_stag_obj->get_table_header(  io_cntxt = lo_obj_context
                                                                  iv_tabname = CONV #( ls_parameter-stagingtechid ) ).
          ls_entity = VALUE #( migrationprojectuuid = ls_parameter-migrationprojectuuid
                               migrationobjectuuid = ls_parameter-migrationobjectuuid
                               name = ls_table_header-description
                               techname = ls_table_header-tab_uuid
                               techid = ls_parameter-stagingtechid
                               datacount = ls_table_header-num_records
                               status = ls_table_header-is_consistent
                               createdby = ls_table_header-createdby
                               createdon = ls_table_header-createdon ).

          ls_changeset_response-operation_no = ls_changeset_request-operation_no.

          copy_data_to_ref(
            EXPORTING
              is_data = ls_entity
            CHANGING
              cr_data = ls_changeset_response-entity_data
          ).
          APPEND ls_changeset_response TO ct_changeset_response.
        ENDLOOP.
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_mc_static_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_mc_static_exception->get_text( )
            it_message           = lo_mc_static_exception->get_messages( )
        ).
    ENDTRY.
  ENDMETHOD.


  METHOD remove_escape_symbol.
    LOOP AT ct_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter_select_option>).
      LOOP AT <ls_filter_select_option>-select_options ASSIGNING FIELD-SYMBOL(<ls_select_options>).
        IF <ls_select_options>-option = 'CP'.
          "Remove escape symbol "#"
          IF <ls_select_options>-low <> '*#+*' OR <ls_select_options>-low <> '*#**'."For case low has character only '+'
            REPLACE ALL OCCURRENCES OF '#+' IN <ls_select_options>-low WITH '+'.
            REPLACE ALL OCCURRENCES OF '#*' IN <ls_select_options>-low WITH '*'.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD remove_taskproc.

    DATA:
      ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response.

    FIELD-SYMBOLS
      <fs_taskproc>  TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskprocessing.

    LOOP AT it_changeset_request ASSIGNING FIELD-SYMBOL(<fs_request>).

      CREATE DATA ls_changeset_response-entity_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskprocessing.

      ASSIGN ls_changeset_response-entity_data->* TO <fs_taskproc>.

      CAST /iwbep/if_mgw_req_entity_d( <fs_request>-request_context )->get_converted_keys(
        IMPORTING
          es_key_values = <fs_taskproc>
      ).

      ls_changeset_response-operation_no = <fs_request>-operation_no.
      APPEND ls_changeset_response TO ct_changeset_response.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( <fs_taskproc>-migrationprojectuuid ) ).

          DATA(lo_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).

          lo_ctx->add_value(
            EXPORTING
              iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-task_uuid
              iv_value = CONV #( <fs_taskproc>-taskuuid )
          ).

          lo_project_proxy->remove_taskproc( lo_ctx ).

        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
          DATA(lt_messages) = lx_exception->get_messages( ).

          IF lt_messages IS INITIAL.
            APPEND VALUE #( msgty = 'E'
                            msgid = lx_exception->if_t100_message~t100key-msgid
                            msgno = lx_exception->if_t100_message~t100key-msgno
                            msgv1 = lx_exception->msgv1
                            msgv2 = lx_exception->msgv2
                            msgv3 = lx_exception->msgv3
                            msgv4 = lx_exception->msgv4 ) TO lt_messages.

          ENDIF.

          LOOP AT lt_messages INTO DATA(ls_message).
            <fs_request>-msg_container->add_message(
              EXPORTING
                iv_msg_type   = ls_message-msgty
                iv_msg_id     = ls_message-msgid
                iv_msg_number = ls_message-msgno
                iv_msg_v1     = ls_message-msgv1
                iv_msg_v2     = ls_message-msgv2
                iv_msg_v3     = ls_message-msgv3
                iv_msg_v4     = ls_message-msgv4
                iv_add_to_response_header = abap_true ).
          ENDLOOP.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD resolve_errors.
    DATA:
      ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
      ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_applactivitymonitordetail,
      lv_event_type         TYPE /ltb/mc_event_type,
      lv_count              TYPE i.

    FIELD-SYMBOLS <fs_entity>     TYPE /ltb/cl_mig_mc_odata_mpc=>ts_applactivitymonitordetail.
    DESCRIBE TABLE it_changeset_request LINES lv_count.
    LOOP AT it_changeset_request INTO DATA(ls_changeset_request) ##INTO_OK.
      CAST /iwbep/if_mgw_req_func_import( ls_changeset_request-request_context )->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter ).

      CLEAR ls_changeset_response.



      DATA(ls_event) = /ltb/cl_mc_eventlog_access=>get_event_by_uuid( iv_event_uuid = CONV #( ls_parameter-eventuuid ) ).
      DATA(ls_first_event) = /ltb/cl_mc_eventlog_access=>get_first_event_by_actuuid(
                         iv_proj_uuid = CONV #( ls_parameter-migrationprojectuuid )
                         iv_act_uuid  = CONV #( ls_parameter-eventactivityuuid )
                       ).
      CASE ls_event-event_type.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-project_deletion_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-project_delete_error_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-project_prep_error.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-project_prep_error_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_task-check_task_values_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_task-check_task_values_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_task-confirm_task_obj_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_task-confirm_task_obj_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_task-download_task_value_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_task-download_task_value_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_message-download_details_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_message-download_details_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-download_file_tmpl_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-download_file_tmpl_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_exclude-exclude_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_exclude-exclude_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_fileproc-generate-failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_fileproc-generate-resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_fileproc-import-failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_fileproc-import-resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_fileproc-validate-failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_fileproc-validate-resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_task-import_taskval_failed
          OR /ltb/cl_mc_eventlog_access=>gc_event_type_task-import_taskval_completed_error.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_task-import_taskval_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_delete_instance-delete_instance_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_delete_instance-delete_instance_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-instance_deletion_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-instance_deletion_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-migration_failed
          OR /ltb/cl_mc_eventlog_access=>gc_event_type-migration_completed_error.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-migration_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-migration_prep_error.
          lv_event_type = lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-migration_prep_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-migration_sched_error.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-migration_sched_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-object_copy_error.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-object_copy_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-object_prep_error.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-object_prep_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-preparation_failed
          OR /ltb/cl_mc_eventlog_access=>gc_event_type-preparation_completed_error.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-preparation_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-selection_failed
          OR /ltb/cl_mc_eventlog_access=>gc_event_type-selection_completed_error.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-selection_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_task-prepare_mapping_completed_err
          OR /ltb/cl_mc_eventlog_access=>gc_event_type_task-prepare_mapping_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_task-prepare_mapping_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-simulation_failed
          OR /ltb/cl_mc_eventlog_access=>gc_event_type-simulation_completed_error.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-simulation_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-simulation_prep_error.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-simulation_prep_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-simulation_sched_error.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-simulation_sched_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_task-taskfile_validation_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_task-taskfile_validation_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_exclude-undo_exclude_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_exclude-undo_exclude_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-upgrade_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-upgrade_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-upgrade_scheduled_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-upgrade_scheduled_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_data_check-data_check_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_data_check-data_check_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_after_import-process_after_import_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_after_import-process_after_import_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_sync_table-sync_staging_table_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_sync_table-sync_staging_table_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type-object_deletion_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type-object_deletion_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_appl_del_proj-delete_projects_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_appl_del_proj-delete_projects_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_copy_project-copy_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_copy_project-copy_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_system_task-create_system_task_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_system_task-create_system_task_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_type_system_task-execute_system_task_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_type_system_task-execute_system_task_resolved.
        WHEN /ltb/cl_mc_eventlog_access=>gc_event_delete_taskitem-del_failed.
          lv_event_type = /ltb/cl_mc_eventlog_access=>gc_event_delete_taskitem-del_resolved.
        WHEN OTHERS.
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception.
          " ##NO Need to handle
          "should not happen
      ENDCASE.

      /ltb/cl_mc_eventlog_access=>record_event(
        EXPORTING
          iv_proj_uuid            = ls_event-proj_uuid
          iv_migobj_uuid          = ls_event-migobj_uuid
          iv_act_uuid             = ls_event-act_uuid
          iv_event_type           = lv_event_type
          iv_event_data           = ls_first_event-event_data
          iv_jobname              = ls_event-jobname
          iv_jobcount             = ls_event-jobcount
          iv_lognr                = ls_event-lognr
          iv_task_uuid            = ls_event-task_uuid
          iv_with_commit          = abap_true
          iv_ignore_mc_proj_check = abap_false
          iv_created_by           = sy-uname
          iv_created_at           = ls_event-created_at
        RECEIVING
          rs_event                = DATA(ls_errors_resovled_event)
      ).

      CREATE DATA ls_changeset_response-entity_data TYPE /ltb/cl_mig_mc_odata_mpc=>ts_applactivitymonitordetail.
      ASSIGN ls_changeset_response-entity_data->* TO <fs_entity>.
      <fs_entity>-migrationprojectuuid = ls_parameter-migrationprojectuuid.
      <fs_entity>-eventuuid = ls_event-event_uuid.
      <fs_entity>-eventstartedat = ls_first_event-created_at.
      <fs_entity>-eventfinishedat = ls_event-created_at.
      ls_changeset_response-operation_no = ls_changeset_request-operation_no.
      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.

    IF lv_count = 1.
      IF 1 = 0.
        MESSAGE i278(/ltb/mc).
      ENDIF.
      ls_changeset_request = it_changeset_request[ 1 ].
      ls_changeset_request-msg_container->add_message(
        EXPORTING
          iv_msg_type   = 'I'
          iv_msg_id     = '/LTB/MC'
          iv_msg_number = '278'
          iv_add_to_response_header = abap_true
          ).
    ELSE.
      IF 1 = 0.
        MESSAGE i279(/ltb/mc).
      ENDIF.
      ls_changeset_request = it_changeset_request[ 1 ].
      ls_changeset_request-msg_container->add_message(
        EXPORTING
          iv_msg_type   = 'I'
          iv_msg_id     = '/LTB/MC'
          iv_msg_number = '279'
          iv_add_to_response_header = abap_true
          ).

    ENDIF.
  ENDMETHOD.


  METHOD searchhelptempla_get_entityset.
    DATA: lt_shlp               TYPE TABLE OF ddshdescr,
          ls_collectiveSHLPName TYPE  dd30l-shlpname,
          ls_filter_request     TYPE /iwbep/s_mgw_select_option,
          ls_filter_option      TYPE /iwbep/s_cod_select_option.


    READ TABLE it_filter_select_options WITH KEY property = co_searchhelp
     INTO ls_filter_request.
    IF sy-subrc = 0.
      READ TABLE ls_filter_request-select_options INTO ls_filter_option INDEX 1.
      ls_collectiveSHLPName = ls_filter_option-low.
    ENDIF.

    CALL FUNCTION 'DD_SHLP_RUNTIME_GET'
      EXPORTING
        shlpname      = ls_collectiveSHLPName
        langu         = sy-langu
      TABLES
        ddshdescr_tab = lt_shlp.
    et_entityset = VALUE #( FOR ls_value_help IN lt_shlp
                                      (  collectiveSHLPName = ls_collectiveSHLPName
                                      searchhelpname = ls_value_help-shlpname
                                         searchhelpdescr = ls_value_help-ddtext
                                         ) ).






  ENDMETHOD.


  METHOD set_context.
    DATA: lv_limit       TYPE int4,
          lv_offset      TYPE int4,
          lt_order       TYPE /ltb/if_mc_constants=>gtt_sort_order,
          lt_filter_cond TYPE /ltb/if_mc_constants=>gtt_filter_cond.

*  Set filter conditions
    IF it_filter_select_options IS NOT INITIAL.
      lt_filter_cond = VALUE #(
          FOR ls_filter IN it_filter_select_options
          FOR condition IN ls_filter-select_options
          (
            field = /ltb/cl_mig_mc_odata_dpc_ext=>get_entity_components(
                                                           iv_entity_set_name = iv_entity_set_name
                                                           iv_component_name  = ls_filter-property
                                                           )
              sign  = condition-sign
              oper  = condition-option
              low   = condition-low
              high  = condition-high
              ) ).
      io_context->set_filter_cond(
            EXPORTING
              it_filter_cond    = lt_filter_cond ).
    ENDIF.

*   Set full search
    IF iv_search_string IS NOT INITIAL.
      io_context->set_fulltext_search(
            EXPORTING
              iv_search    = iv_search_string ).
    ENDIF.

*   Set orders
    IF it_order IS NOT INITIAL.
      lt_order = VALUE #(
               FOR orders IN it_order
               (
               property =  /ltb/cl_mig_mc_odata_dpc_ext=>get_entity_components(
                                                    iv_entity_set_name = iv_entity_set_name
                                                    iv_component_name  = orders-property
                                                    )
               order = COND #( WHEN orders-order = co_sort_descending THEN /ltb/if_mc_constants=>gc_sort_order-descending
                               ELSE /ltb/if_mc_constants=>gc_sort_order-ascending )

               ) ).
      io_context->set_sort_order( it_orders =  lt_order ).
    ENDIF.

*   Set paging to context
    IF is_paging IS NOT INITIAL.
      lv_limit = is_paging-top.
      lv_offset = is_paging-skip.
      IF lv_limit <> 0 OR lv_offset <> 0.
        io_context->set_page( iv_offset = lv_offset iv_limit = lv_limit ).
      ENDIF.
    ENDIF.
*   Set the language
    IF iv_language IS NOT INITIAL.
      io_context->set_language( iv_language = iv_language ).
    ENDIF.
  ENDMETHOD.


  METHOD set_parallel_jobs.
    DATA: ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_setparalleljobs.
    io_tech_request_context->get_converted_parameters(
      IMPORTING
        es_parameter_values = ls_parameter
    ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_parameter-migrationprojectuuid ) ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( ls_parameter-migrationobjectuuid ) ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_exception->get_text( )
        ).
    ENDTRY.

    DATA(lt_return) = lo_object_proxy->set_num_job( iv_num_job = ls_parameter-numbackgroundjob ).

    IF lt_return IS NOT INITIAL.
      raise_bussiness_exception(
        EXPORTING
          iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
          it_message           = lt_return
      ).
    ENDIF.
  ENDMETHOD.


  METHOD set_transaction.
    mv_transaction = iv_transaction.
  ENDMETHOD.


  METHOD stagingoverviews_get_entity.
    DATA: lv_proj_uuid    TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid     TYPE /ltb/mc_object_uuid,
          lv_tab_name     TYPE tabname,
          ls_key_pair     TYPE /iwbep/s_mgw_name_value_pair,
          lo_object_proxy TYPE REF TO /ltb/cl_mc_obj_proxy_mwb_stag.

    CLEAR es_response_context.
    CLEAR er_entity.

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_stagingoverview.
      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_staging_table_name.
      IF sy-subrc = 0.
        lv_tab_name = ls_key_pair-value.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
          lo_object_proxy ?= lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).
          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
          lo_obj_ctx->set_consistency_check( abap_true ).
          DATA(ls_table_header) = lo_object_proxy->get_table_header(  io_cntxt = lo_obj_ctx
                                                                      iv_tabname = lv_tab_name ).
          er_entity = VALUE #(
                               migrationprojectuuid = lv_proj_uuid
                               migrationobjectuuid = lv_obj_uuid
                               name = ls_table_header-description
                               techname = ls_table_header-tab_uuid
                               techid = lv_tab_name
                               datacount = ls_table_header-num_records
                               status = ls_table_header-is_consistent
                               createdby = ls_table_header-createdby
                               createdon = ls_table_header-createdon
                         ).
        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).

      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD stagingoverviews_get_entityset.
    DATA: lv_proj_uuid TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid  TYPE /ltb/mc_object_uuid,
          ls_key_pair  TYPE /iwbep/s_mgw_name_value_pair.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobject.
      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).
          lo_obj_ctx->set_consistency_check( abap_true ).

          set_context(
            EXPORTING
              iv_entity_set_name       = iv_entity_set_name
              it_order                 = it_order
              is_paging                = is_paging
              iv_search_string         = iv_search_string
              io_context               = lo_obj_ctx ).

          DATA(lt_tables) = lo_object_proxy->get_tables( io_cntxt = lo_obj_ctx ).
          et_entityset = VALUE #(
                           FOR <tab> IN lt_tables
                             (
                               migrationprojectuuid = lv_proj_uuid
                               migrationobjectuuid = lv_obj_uuid
                               name = <tab>-description "structure description
                               techname     = <tab>-tabname "structure ident
                               techid    = <tab>-tab_uuid "staging table name
                               datacount = <tab>-num_records
                               status = <tab>-is_consistent
                              )
                         ).
          IF io_tech_request_context->has_inlinecount( ) = abap_true.
            es_response_context-inlinecount = lines( et_entityset ).
          ENDIF.
        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD staging_reset_transfer_status.
    DATA: lo_request            TYPE REF TO /iwbep/if_mgw_req_func_import,
          ls_parameter          TYPE /ltb/cl_mig_mc_odata_mpc=>ts_resettransferstatus,
          ls_changeset_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response,
          ls_entity             TYPE /ltb/cl_mig_mc_odata_mpc=>ts_stagingoverview,
          ls_message            TYPE bal_s_msg,
          lv_object_guid        TYPE /ltb/mc_object_uuid,
          lv_project_guid       TYPE /ltb/mc_proj_uuid,
          lv_tabname            TYPE string,
          lv_has_error          TYPE boolean VALUE abap_false,
          lv_is_job_running     TYPE boolean VALUE abap_false,
          lo_stag_obj           TYPE REF TO /ltb/cl_mc_obj_proxy_mwb_stag,
          lo_job_facade         TYPE REF TO if_dmc_sin_job_facade,
          lo_project_proxy      TYPE REF TO /ltb/if_mc_proj_proxy.

    CONSTANTS: gc_controller_job TYPE dmc_uniform_name_acronym VALUE 'CTRL'.
    "Obsolate, no longer use
    "batch job
    LOOP AT it_changeset_request INTO DATA(ls_changeset_request). ##INTO_OK
      lo_request ?= ls_changeset_request-request_context.
      lo_request->get_converted_parameters(
        IMPORTING
          es_parameter_values = ls_parameter
      ).
      CLEAR ls_changeset_response.
      CLEAR ls_entity.
      CLEAR ls_message.

      lv_project_guid = ls_parameter-migrationprojectuuid.
      lv_object_guid = ls_parameter-migrationobjectuuid.
      lv_tabname = ls_parameter-stagingtechid.

      TRY .
          "since all request should belongs to one project and one MO
          IF lo_project_proxy IS INITIAL.
            lo_project_proxy ?= /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_guid ).
            lo_stag_obj ?= lo_project_proxy->get_migobj_proxy_by_uuid( iv_obj_uuid = lv_object_guid ).
          ENDIF.
          DATA(lo_obj_context) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

          "Check controller job is running
          lo_job_facade ?= cl_dmc_job_facade_factory=>create_by_group( iv_group = cl_dmc_sin_job_facade=>gc_group ).
          SELECT SINGLE ident INTO @DATA(lv_cobj_ident) FROM dmc_cobj WHERE guid = @lv_object_guid.
          IF sy-subrc = 0.
            DATA(lv_jobname) = lo_job_facade->get_jobname_by_ident(
              EXPORTING
                iv_ident = lv_cobj_ident
                iv_task  = gc_controller_job ).
            lv_jobname = lv_jobname && '%'.
            IF /ltb/cl_job_queue_access=>is_job_scheduled_or_active( iv_job_name = lv_jobname ) = abap_true.
              lv_has_error = abap_true.
              lv_is_job_running = abap_true.
            ENDIF.
          ENDIF.
          IF lv_has_error = abap_false.
            lo_stag_obj->staging_reset_transfer_status(
              EXPORTING
                io_cntxt   =         lo_obj_context" Context Specific Information
                iv_tabname =         lv_tabname
            ).
          ENDIF.
        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_static_exception).
          lv_has_error = abap_true.
          LOOP AT lo_static_exception->get_messages( ) INTO ls_message ##INTO_OK.
            ls_changeset_request = it_changeset_request[ operation_no = ls_changeset_request-operation_no ].
            ls_changeset_request-msg_container->add_message(
              EXPORTING
                iv_msg_type   = ls_message-msgty
                iv_msg_id     = ls_message-msgid
                iv_msg_number = ls_message-msgno
                iv_msg_v1     = ls_message-msgv1
                iv_msg_v2     = ls_message-msgv2
                iv_msg_v3     = ls_message-msgv3
                iv_msg_v4     = ls_message-msgv4
                iv_add_to_response_header = abap_true
                ).
          ENDLOOP.
      ENDTRY.

      TRY.
*Reload lastest staging table information into response.
          lo_obj_context = NEW /ltb/cl_mc_cntxt_obj_detail( ).
          lo_obj_context->set_consistency_check( abap_true ).
          DATA(ls_table_header) = lo_stag_obj->get_table_header(  io_cntxt = lo_obj_context
                                                                  iv_tabname = CONV #( ls_parameter-stagingtechid ) ).
          ls_entity = VALUE #( migrationprojectuuid = ls_parameter-migrationprojectuuid
                               migrationobjectuuid = ls_parameter-migrationobjectuuid
                               name = ls_table_header-description
                               techname = ls_table_header-tab_uuid
                               techid = ls_parameter-stagingtechid
                               datacount = ls_table_header-num_records
                               status = ls_table_header-is_consistent
                               createdby = ls_table_header-createdby
                               createdon = ls_table_header-createdon ).
        CATCH /ltb/cx_mc_static_check_msg.
          ls_entity = VALUE #( migrationprojectuuid = ls_parameter-migrationprojectuuid
                               migrationobjectuuid = ls_parameter-migrationobjectuuid
                               techid = ls_parameter-stagingtechid ).
      ENDTRY.

      ls_changeset_response-operation_no = ls_changeset_request-operation_no.
      copy_data_to_ref(
        EXPORTING
          is_data = ls_entity
        CHANGING
          cr_data = ls_changeset_response-entity_data
      ).
      APPEND ls_changeset_response TO ct_changeset_response.
    ENDLOOP.

*Give a successful message if nothing wrong happens
    IF lv_has_error = abap_false.
      IF 1 = 0.
        "Transfer status has been reset
        MESSAGE i108(/ltb/mc).
      ENDIF.
      ls_changeset_request = it_changeset_request[ 1 ].
      ls_changeset_request-msg_container->add_message(
        EXPORTING
          iv_msg_type   = 'I'
          iv_msg_id     = '/LTB/MC'
          iv_msg_number = '108'
          iv_add_to_response_header = abap_true
          ).
    ELSE.
      "if the error is caused by the controller job, rasie to UI.
      IF lv_is_job_running = abap_true.
        IF 1 = 0.
          MESSAGE e116(/ltb/mc).
        ENDIF.
        ls_changeset_request = it_changeset_request[ 1 ].
        ls_changeset_request-msg_container->add_message(
          EXPORTING
            iv_msg_type   = 'E'
            iv_msg_id     = '/LTB/MC'
            iv_msg_number = '116'
            iv_add_to_response_header = abap_true
            ).
        RETURN.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD systeminfoset_get_entityset.
    DATA: ls_entity TYPE /ltb/cl_mig_mc_odata_mpc=>ts_systeminfo,
          lv_s4type TYPE /ltb/cl_mig_mc_odata_mpc=>ts_systeminfo-systeminfovalue.
    DATA lv_s4h TYPE abap_bool.
    TRY.
        ls_entity-systeminfokey = co_systeminfo_s4type.
        IF /ltb/cl_ext_cls_factory=>get_cos_utilities( )->is_cloud( ) = abap_true.
          ls_entity-systeminfovalue = lv_s4type = co_cloud.
        ELSE.
          ls_entity-systeminfovalue = lv_s4type = co_onpremise.
        ENDIF.
        APPEND ls_entity TO et_entityset.

        CLEAR ls_entity.
        ls_entity-systeminfokey = co_systeminfo_maxfilesize.
        cl_spfl_profile_parameter=>get_value( EXPORTING name = 'icm/HTTP/max_request_size_KB'
                                              IMPORTING value = ls_entity-systeminfovalue  ).
        APPEND ls_entity TO et_entityset.

        CLEAR ls_entity.
        ls_entity-systeminfokey = co_systeminfo_editable.
        IF lv_s4type = co_onpremise.
          /ltb/cl_bas_utils=>is_system_editable( RECEIVING rv_editable = ls_entity-systeminfovalue ).
        ELSE.
          ls_entity-systeminfovalue = abap_true.
*          DATA(lo_ato_service) = /ltb/cl_ext_cls_factory=>get_ato_service_factory( )->get_ato_service( ).
*          DATA(ls_settings) = lo_ato_service->get_settings( ).
*
*          IF ls_settings-is_ato_configured           = abap_true    AND
*             ls_settings-is_extensibility_dev_system = abap_false .
*            ls_entity-systeminfovalue = abap_false.
*          ELSE.
*            ls_entity-systeminfovalue = abap_true.
*          ENDIF.
        ENDIF.
        APPEND ls_entity TO et_entityset.

        CLEAR ls_entity.
        ls_entity-systeminfokey = co_dt_object_load_required.
        ls_entity-systeminfovalue = is_load_object_required( ).
        APPEND ls_entity TO et_entityset.
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).
        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD tablecolumnsset_get_entityset.

    DATA: lv_proj_uuid  TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid   TYPE /ltb/mc_object_uuid,
          lv_inst_uuid  TYPE /ltb/if_mc_constants=>gty_item_uuid,
          lv_table_uuid TYPE char32,
          ls_key_pair   TYPE /iwbep/s_mgw_name_value_pair,
          ls_nav_path   TYPE /iwbep/s_mgw_navigation_path,
          lv_offset          TYPE i,
          lv_limit           TYPE i,
          lv_end_pos         TYPE i,
          lv_total_count     TYPE i.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF ( iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationinstance OR
       iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_tablestructure OR
       iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_stagingoverview ) AND
       iv_entity_name = /ltb/cl_mig_mc_odata_mpc=>gc_tablecolumns.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.


      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_instance_uuid.
      IF sy-subrc = 0.
        lv_inst_uuid  = ls_key_pair-value.
      ENDIF.

      IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationinstance.
        READ TABLE it_navigation_path INTO ls_nav_path WITH KEY nav_prop = 'to_TableStructor'.
        IF sy-subrc = 0.
          READ TABLE ls_nav_path-key_tab INTO ls_key_pair WITH KEY name = co_table_uuid.
          IF sy-subrc = 0.
            lv_table_uuid = ls_key_pair-value.
          ENDIF.
        ENDIF.
      ELSEIF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_tablestructure.
        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_table_uuid.
        IF sy-subrc = 0.
          lv_table_uuid = ls_key_pair-value.
        ENDIF.
      ELSEIF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_stagingoverview.
        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_staging_table_name.
        IF sy-subrc = 0.
          lv_table_uuid = ls_key_pair-value.
        ENDIF.
      ENDIF.


      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).

          DATA(lo_item_proxy) = lo_object_proxy->get_item_proxy_by_uuid( lv_inst_uuid ).
*       Get table structure
          lo_obj_ctx->set_tab_uuid( lv_table_uuid ).

          set_context(
            EXPORTING
              iv_entity_set_name       = iv_entity_set_name
              it_order                 = it_order
              is_paging                = is_paging
              iv_search_string         = iv_search_string
              io_context               = lo_obj_ctx ).

          DATA(lt_table_metadata)    = lo_item_proxy->get_table_metadata( lo_obj_ctx ).

          "Paging
          lv_offset      = is_paging-skip.
          lv_limit       = is_paging-top .
          lv_end_pos     = lv_offset + lv_limit.
          lv_total_count = lines( lt_table_metadata ).

          IF lv_end_pos > 0.
            IF lines( lt_table_metadata ) > lv_end_pos.
              lv_end_pos =  lv_end_pos + 1.
              DELETE lt_table_metadata FROM lv_end_pos.
            ENDIF.

            IF lv_offset > 0.
              DELETE lt_table_metadata TO lv_offset.
            ENDIF.
          ENDIF.

          "replace '/' to avoid parse failed
          CONCATENATE /ltb/if_mc_constants=>gc_characters-underscore
                      /ltb/if_mc_constants=>gc_characters-hyphen
                 INTO DATA(lv_slash_repl).

          LOOP AT lt_table_metadata ASSIGNING FIELD-SYMBOL(<ls_table_metadata>).
            IF <ls_table_metadata>-fieldname CA /ltb/if_mc_constants=>gc_characters-slash.
              REPLACE ALL OCCURRENCES OF /ltb/if_mc_constants=>gc_characters-slash
              IN <ls_table_metadata>-fieldname
              WITH lv_slash_repl.
            ENDIF.
            <ls_table_metadata>-position = sy-tabix.
          ENDLOOP.

          et_entityset = VALUE #( FOR <fs_field> IN lt_table_metadata
                            ( tableuuid               = lv_table_uuid
                              tablename               = <fs_field>-tabname
                              fieldname               = <fs_field>-fieldname
                              iskey                   = <fs_field>-is_key
                              datatype                = <fs_field>-datatype
                              displayorder            = <fs_field>-position
                              fieldlabel              = <fs_field>-description
                              migrationprojectuuid    = lv_proj_uuid
                              migrationobjectuuid     = lv_obj_uuid
                              ismandatory             = <fs_field>-is_mandatory
                              fieldtype               = <fs_field>-fieldtype
                              fieldlength             = <fs_field>-fieldlength
                              decimals                = <fs_field>-decimals
                              group                   = <fs_field>-group
                              description             = <fs_field>-tooltip
                              notnull                 = <fs_field>-notnull
                            ) ).

          IF io_tech_request_context->has_inlinecount( ) = abap_true.
            es_response_context-inlinecount = lv_total_count.
          ENDIF.
          IF io_tech_request_context->has_count( ) = abap_true.
            es_response_context-count = lv_total_count.
          ENDIF.
        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD tabledataset_get_entityset.

    DATA: lv_proj_uuid     TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid      TYPE /ltb/mc_object_uuid,
          lv_instance_uuid TYPE /ltb/if_mc_constants=>gty_item_uuid,
          lv_table_uuid    TYPE char32,
          ls_key_pair      TYPE /iwbep/s_mgw_name_value_pair,
          ls_entity        TYPE /ltb/cl_mig_mc_odata_mpc=>ts_tabledata,
          lo_json          TYPE REF TO /ui2/cl_json,
          lv_count         TYPE int4.

    FIELD-SYMBOLS: <fs_itemdata>   TYPE any.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF ( iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationinstance OR
         iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_tablestructure OR
         iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_stagingoverview
         ).


      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_instance_uuid.
      IF sy-subrc = 0.
        lv_instance_uuid  = ls_key_pair-value.
      ENDIF.

      IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationinstance.
        DATA(lt_filter_select_option) = io_tech_request_context->get_filter( )->get_filter_select_options( ).
        READ TABLE lt_filter_select_option INTO DATA(ls_filter_select_option) WITH KEY property = co_abap_table_uuid.
        IF sy-subrc = 0.
          READ TABLE ls_filter_select_option-select_options INTO DATA(ls_sel_opt) INDEX 1.
          IF sy-subrc = 0.
            lv_table_uuid  = ls_sel_opt-low.
          ENDIF.
        ENDIF.
      ELSEIF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_tablestructure.
        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_table_uuid .
        IF sy-subrc = 0.
          lv_table_uuid = ls_key_pair-value.
        ENDIF.
        lt_filter_select_option = io_tech_request_context->get_filter( )->get_filter_select_options( ).
        READ TABLE lt_filter_select_option INTO ls_filter_select_option WITH KEY property = co_abap_migration_inst_uuid.
        IF sy-subrc = 0.
          READ TABLE ls_filter_select_option-select_options INTO ls_sel_opt INDEX 1.
          IF sy-subrc = 0.
            lv_instance_uuid  = ls_sel_opt-low.
          ENDIF.
        ENDIF.
      ELSEIF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_stagingoverview.
        READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_staging_table_name.
        IF sy-subrc = 0.
          lv_table_uuid = ls_key_pair-value.
        ENDIF.
      ENDIF.

      TRY.
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).

          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).
          IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_stagingoverview.
            set_context( iv_entity_set_name = iv_entity_set_name
             iv_search_string = iv_search_string
             it_filter_select_options = lt_filter_select_option
             it_order = it_order
             is_paging = is_paging
             io_context = lo_obj_ctx
              ).
          ENDIF.

          DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).
          lo_object_proxy->check_authorization( io_cntxt = lo_obj_ctx ).

          lo_obj_ctx->set_item_uuid( EXPORTING iv_item_uuid = lv_instance_uuid ).

          DATA(lo_item_proxy) = lo_object_proxy->get_item_proxy_by_uuid( lv_instance_uuid ).

          "in case staging scenario, the table name is /1LT/DS*
          "from frontend we will get the request which includes the table name like %2F1LT%2FDS*
          "%2F is converted from / by frontend
          REPLACE ALL OCCURRENCES OF '%2F' IN lv_table_uuid WITH '/'.

          lo_obj_ctx->set_tab_uuid( lv_table_uuid ).
          lo_item_proxy->get_table_data(
            EXPORTING
              io_cntxt  = lo_obj_ctx
            IMPORTING
              et_data   = DATA(lt_item_data)
              ev_count  = lv_count ).

          READ TABLE lt_item_data ASSIGNING FIELD-SYMBOL(<ls_item_data>) INDEX 1.
          IF sy-subrc = 0.
            ASSIGN <ls_item_data>-data->* TO FIELD-SYMBOL(<ls_itemdata>).
            CREATE OBJECT lo_json
              EXPORTING
                initial_date   = '"0000-00-00"'
                initial_time   = '"00:00:00"'
                numc_as_string = abap_true
                name_mappings  = get_json_name_mappings( <ls_itemdata> ).
          ENDIF.

          LOOP AT lt_item_data INTO DATA(ls_item_data) ##INTO_OK.
            CLEAR ls_entity.
            ls_entity-migrationprojectuuid       = lv_proj_uuid.
            ls_entity-migrationobjectuuid        = lv_obj_uuid.
            ls_entity-migrationinstanceuuid      = lv_instance_uuid.
            ls_entity-tableuuid                  = lv_table_uuid.
            ls_entity-generatedkey               = ls_item_data-generated_key.
            ASSIGN  ls_item_data-data->* TO <fs_itemdata>.
            IF sy-subrc = 0.
              "CALL TRANSFORMATION will dump if field type is P or N & value is empty
              ls_entity-combinedcolumns = lo_json->serialize_int(
                                            data             = <fs_itemdata>
                                            name             = 'DATA'  ).
              CONCATENATE `{` ls_entity-combinedcolumns `}` INTO ls_entity-combinedcolumns.
            ENDIF.
            APPEND ls_entity TO et_entityset.
          ENDLOOP.

*       Handle inline count
          IF io_tech_request_context->has_inlinecount( ) = abap_true.
            IF iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_stagingoverview.
              es_response_context-inlinecount = lv_count.
            ELSE.
              es_response_context-inlinecount = lines( et_entityset ).
            ENDIF.
          ENDIF.
        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.

    ENDIF.
  ENDMETHOD.


  METHOD tablestructorset_get_entityset.

    CONSTANTS: lc_drillstate_expanded TYPE string VALUE 'expanded' ##NO_TEXT,
               lc_drillstate_leaf     TYPE string VALUE 'leaf' ##NO_TEXT.

    DATA: lv_proj_uuid     TYPE /ltb/mc_proj_uuid,
          lv_obj_uuid      TYPE /ltb/mc_object_uuid,
          lv_instance_uuid TYPE /ltb/if_mc_constants=>gty_item_uuid,
          ls_key_pair      TYPE /iwbep/s_mgw_name_value_pair,
          ls_entity        TYPE /ltb/cl_mig_mc_odata_mpc=>ts_tablestructure,
          lv_index         TYPE sy-tabix.

    FIELD-SYMBOLS: <fs_mcsendertree> TYPE /ltb/cl_mig_mc_odata_mpc=>ts_tablestructure,
                   <fs_fieldvalue>   TYPE any.
    CONSTANTS: co_instanceDetailpage TYPE string VALUE 'InstanceDetail'.
    CLEAR es_response_context.
    CLEAR et_entityset.

    IF ( iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationobject OR
       iv_source_name = /ltb/cl_mig_mc_odata_mpc=>gc_migrationinstance ).

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_project_uuid.
      IF sy-subrc = 0.
        lv_proj_uuid = ls_key_pair-value.
      ENDIF.


      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_object_uuid.
      IF sy-subrc = 0.
        lv_obj_uuid = ls_key_pair-value.
      ENDIF.

      READ TABLE it_key_tab INTO ls_key_pair WITH KEY name = co_migration_instance_uuid.
      IF sy-subrc = 0.
        lv_instance_uuid  = ls_key_pair-value.
      ENDIF.
      DATA lv_var TYPE string.
      io_tech_request_context->get_at(
      IMPORTING
        ev_at = lv_var ).

      TRY.
*       Project proxy object
          DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_proj_uuid ).
*       Context
          DATA(lo_obj_ctx)       = NEW /ltb/cl_mc_cntxt_obj_detail( ).
          IF lv_var = co_instancedetailpage.
            lo_obj_ctx->set_skip_appl( abap_true ).
          ELSE.
            lo_obj_ctx->set_skip_appl( abap_false ).
          ENDIF.
*       Object proxy
          DATA(lo_object_proxy)  = lo_project_proxy->get_migobj_proxy_by_uuid( lv_obj_uuid ).
*       Get object tables
          DATA(lt_mc_tables)     = lo_object_proxy->get_tables( lo_obj_ctx ).
*       Prepare a table for check
          DATA(lt_mc_tables_4check) = lt_mc_tables.

          LOOP AT lt_mc_tables INTO DATA(ls_mc_table) ##INTO_OK.
            CLEAR ls_entity.
            ls_entity-migrationprojectuuid        = lv_proj_uuid.
            ls_entity-migrationobjectuuid         = lv_obj_uuid.
            ls_entity-migrationinstanceuuid       = lv_instance_uuid.
            ls_entity-tableuuid                   = ls_mc_table-tab_uuid.
            ls_entity-tablename                   = ls_mc_table-tabname.
            ls_entity-treenodeid                  = ls_mc_table-tab_uuid.
            ls_entity-sequencenumber              = ls_mc_table-position.
            ls_entity-tabledescription            = ls_mc_table-description.
            ls_entity-structurelevel              = ls_mc_table-level.
            ls_entity-parentid                    = ls_mc_table-parent.
            ls_entity-tablerecordnumber           = ls_mc_table-num_records.

            READ TABLE lt_mc_tables_4check WITH KEY parent = ls_mc_table-tabname TRANSPORTING NO FIELDS.
            IF sy-subrc = 0.
              ls_entity-drillstate = lc_drillstate_expanded.  " expanded node
            ELSE.
              ls_entity-drillstate = lc_drillstate_leaf.      " leaf node
            ENDIF.
            APPEND ls_entity TO et_entityset.
          ENDLOOP.
*       Handle the filter option
          DATA(lt_filter_select_option) = io_tech_request_context->get_filter( )->get_filter_select_options( ).
          LOOP AT et_entityset ASSIGNING <fs_mcsendertree>.
            lv_index = sy-tabix.
            LOOP AT lt_filter_select_option INTO DATA(ls_filter_select_option) ##INTO_OK.
              ASSIGN COMPONENT ls_filter_select_option-property OF STRUCTURE <fs_mcsendertree> TO <fs_fieldvalue>.
              IF <fs_fieldvalue> NOT IN ls_filter_select_option-select_options.
                DELETE et_entityset INDEX lv_index.
                EXIT.
              ENDIF.
            ENDLOOP.

          ENDLOOP.
        CATCH /ltb/cx_mc_proxy_error INTO DATA(lx_proxy_error).
          DATA(lt_mc_messages) = lx_proxy_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
        CATCH /ltb/cx_mc_cntxt_error INTO DATA(lx_cntxt_error).
          lt_mc_messages = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD taskfileset_get_entityset.
    CONSTANTS:
         co_property_statusgroup TYPE string VALUE 'StatusGroup'.

    DATA ls_file_key   TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskfile.
    DATA lv_project_uuid  TYPE /ltb/mc_proj_uuid.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_file_key ).

    lv_project_uuid = ls_file_key-migrationprojectuuid.

    TRY.

        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( lv_project_uuid ).

        DATA(lt_task_files) = lo_project_proxy->get_task_files( NEW /ltb/cl_mc_cntxt_proj_detail( ) ).

        et_entityset = VALUE #(
          FOR <ls_task_file> IN lt_task_files (
            migrationprojectuuid = <ls_task_file>-proj_uuid
            taskfileuuid         = <ls_task_file>-fileproc_uuid
            taskname             = <ls_task_file>-task_name
            filename             = <ls_task_file>-file_name
            filestatus           = <ls_task_file>-fileproc_status
            statusdescription    = <ls_task_file>-status_desc
            statusgroup          = COND #( WHEN <ls_task_file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-uploaded
                                             THEN  /ltb/if_mc_constants=>gc_fileproc-status_group-upload
                                           WHEN <ls_task_file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-validation_scheduled OR
                                                <ls_task_file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-validated_error OR
                                                <ls_task_file>-fileproc_status = /ltb/if_mc_constants=>gc_fileproc-status-validating
                                             THEN /ltb/if_mc_constants=>gc_fileproc-status_group-validation )
            createdby            = /ltb/cl_mc_odata_generic_func=>get_fullname_by_uname( CONV #( <ls_task_file>-created_by ) )
            createdat            = <ls_task_file>-created_ts
            filesize             = <ls_task_file>-filesize
            numofinstances       = <ls_task_file>-instances_num
            latesthistoryuuid    = <ls_task_file>-latest_act_id
            applognr             = <ls_task_file>-lognr
          )
        ).

        READ TABLE it_filter_select_options ASSIGNING FIELD-SYMBOL(<fs_filter>) WITH KEY property = co_property_statusgroup.
        IF sy-subrc = 0.
          DELETE et_entityset WHERE statusgroup NOT IN <fs_filter>-select_options.
        ENDIF.

        es_response_context-inlinecount = lines( et_entityset ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD taskitemcolumnse_get_entityset.
    DATA:
      ls_parameter     TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskitemcolumn,
      lv_valuehelptype TYPE string,
      lv_valuehelpname TYPE string.
    CLEAR es_response_context.
    CLEAR et_entityset.

    IF io_tech_request_context->get_source_entity_set_name( ) IS NOT INITIAL.
      io_tech_request_context->get_converted_source_keys(
        IMPORTING
          es_key_values = ls_parameter
      ).
      TRY.
          DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
          DATA(lo_proj_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
          DATA(lv_approach) = lo_project->get_proj_details( lo_proj_ctx )-proj_approach.
          DATA(lo_object) = lo_project->get_migobj_proxy_by_uuid( ls_parameter-migrationobjectuuid ).
          DATA(lo_task) = lo_object->get_task_proxy_by_uuid( ls_parameter-migrationtaskuuid ).
          IF lv_approach = /ltb/if_mc_constants=>gc_approach-file OR lv_approach = /ltb/if_mc_constants=>gc_approach-staging.
            DATA(lv_task_type) = CAST /ltb/cl_mc_task_proxy_mwb( lo_task )->get_task_type( ).
          ENDIF.

          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_task_detail( ).
          DATA(lt_task_value_metadata) = lo_task->get_value_metadata( io_cntxt = lo_obj_ctx ).
          SORT lt_task_value_metadata BY value_dir DESCENDING value_order ASCENDING.
          READ TABLE lt_task_value_metadata TRANSPORTING NO FIELDS WITH KEY value_dir = /ltb/if_mc_constants=>gc_value_dir-target.
          IF sy-subrc EQ 0.
            "Only first export parameter be used
            DATA(lv_line) = sy-tabix.
            IF lines( lt_task_value_metadata ) GT lv_line.
              lv_line = lv_line + 1.
              DELETE  lt_task_value_metadata FROM lv_line.
            ENDIF.
          ENDIF.

          CLEAR: lv_valuehelptype, lv_valuehelpname.
          IF lv_task_type = /ltb/if_mc_constants=>gc_task_type-control_param.
            lv_valuehelptype = co_value_help_contr_param.
          ELSE.
            READ TABLE lt_task_value_metadata INTO DATA(ls_value_metadata)
              WITH KEY value_dir = /ltb/if_mc_constants=>gc_value_dir-target.
            IF sy-subrc = 0. "Translation object
              IF ls_value_metadata-value_vh_shlp IS NOT INITIAL.
*                IF is_elementary_search_help( ls_value_metadata-value_vh_shlp ) = abap_true.
                  lv_valuehelptype = co_value_help_search_help.
                  lv_valuehelpname = COND #( WHEN ls_value_metadata-value_vh_shlpfld IS INITIAL THEN ls_value_metadata-value_vh_shlp
                                               ELSE ls_value_metadata-value_vh_shlp && `|` && ls_value_metadata-value_vh_shlpfld ).
*                ENDIF.
              ELSEIF ls_value_metadata-value_vh_domain IS NOT INITIAL.
                DATA(lo_mc_value_help_factory) = NEW /ltb/cl_mc_value_help_factory( ).
                DATA(lo_value_help_srv) = lo_mc_value_help_factory->/ltb/if_mc_value_help_factory~get_value_help_srv( iv_value_help_type = co_value_help_domain
                                                                                                                      iv_value_help_name = CONV #( ls_value_metadata-value_vh_domain ) ).
                IF CAST /ltb/cl_mc_value_help_domain( lo_value_help_srv )->is_value_range_maintained( ) = abap_true.
                  lv_valuehelptype = co_value_help_domain.
                  lv_valuehelpname = ls_value_metadata-value_vh_domain.
                ENDIF.
              ELSEIF ls_value_metadata-value_vh_checktab IS NOT INITIAL.
                lv_valuehelptype = co_value_help_check_table.
                lv_valuehelpname = ls_value_metadata-value_vh_checktab && '|' && ls_value_metadata-value_vh_checkfld.
              ENDIF.
            ELSE."Fixed value
              READ TABLE lt_task_value_metadata INTO ls_value_metadata
                WITH KEY value_dir = /ltb/if_mc_constants=>gc_value_dir-custom.
              IF sy-subrc = 0.
                IF ls_value_metadata-value_vh_shlp IS NOT INITIAL.
*                  IF is_elementary_search_help( ls_value_metadata-value_vh_shlp ) = abap_true.
                    lv_valuehelptype = co_value_help_search_help.
                    lv_valuehelpname = COND #( WHEN ls_value_metadata-value_vh_shlpfld IS INITIAL THEN ls_value_metadata-value_vh_shlp
                                                 ELSE ls_value_metadata-value_vh_shlp && `|` && ls_value_metadata-value_vh_shlpfld ).
*                  ENDIF.
                ELSEIF ls_value_metadata-value_vh_domain IS NOT INITIAL.
                  lo_mc_value_help_factory = NEW /ltb/cl_mc_value_help_factory( ).
                  lo_value_help_srv = lo_mc_value_help_factory->/ltb/if_mc_value_help_factory~get_value_help_srv( iv_value_help_type = co_value_help_domain
                                                                                                                   iv_value_help_name = CONV #( ls_value_metadata-value_vh_domain ) ).
                  IF CAST /ltb/cl_mc_value_help_domain( lo_value_help_srv )->is_value_range_maintained( ) = abap_true.
                    lv_valuehelptype = co_value_help_domain.
                    lv_valuehelpname = ls_value_metadata-value_vh_domain.
                  ENDIF.
                ELSEIF ls_value_metadata-value_vh_checktab IS NOT INITIAL.
                  lv_valuehelptype = co_value_help_check_table.
                  lv_valuehelpname = ls_value_metadata-value_vh_checktab && '|' && ls_value_metadata-value_vh_checkfld.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.


          SORT lt_task_value_metadata BY value_order.

          et_entityset = VALUE #( FOR task_value_metadata IN lt_task_value_metadata INDEX INTO current_index
                                  (
                                    migrationprojectuuid = ls_parameter-migrationprojectuuid
                                    migrationobjectuuid =  ls_parameter-migrationobjectuuid
                                    migrationtaskuuid = ls_parameter-migrationtaskuuid
                                    taskitemcolumnname = task_value_metadata-value_descr
                                    taskitemcolumntype = task_value_metadata-value_dtype
                                    taskitemcolumnlength = task_value_metadata-value_dlen
                                    taskitemcolumnistarget = COND #( WHEN task_value_metadata-value_dir = /ltb/if_mc_constants=>gc_value_dir-source
                                                                        THEN abap_false
                                                                     ELSE
                                                                         abap_true )
                                    taskitemcolumnorder = current_index
                                    taskitemcolumnuppercase = task_value_metadata-value_to_uppercase
                                    targetvaluehelptype  = COND #( WHEN task_value_metadata-value_dir = /ltb/if_mc_constants=>gc_value_dir-source
                                                                        THEN space
                                                                   ELSE
                                                                        lv_valuehelptype )
                                    targetvaluehelpname  = COND #( WHEN task_value_metadata-value_dir = /ltb/if_mc_constants=>gc_value_dir-source
                                                                        THEN space
                                                                   ELSE
                                                                        lv_valuehelpname )
                                    targetiscollectiveshlp = task_value_metadata-value_iscollective_shlp
                                    targetcolumnname  = COND #( WHEN task_value_metadata-value_dir = /ltb/if_mc_constants=>gc_value_dir-source
                                                                        THEN space
                                                                   ELSE
                                                                        ls_value_metadata-value_vh_targetcolumn )

                                  ) ).

        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_cntxt_error).
          DATA(lt_mc_messages) = lx_cntxt_error->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).

      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD taskitemset_get_entityset.
    DATA:
      ls_parameter   TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskitem,
      ls_entity      TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskitem,
      lt_filter_cond TYPE /ltb/if_mc_constants=>gtt_filter_cond,
      lv_limit       TYPE int1,
      lv_offset      TYPE int4,
      lv_field_name  TYPE string.
    FIELD-SYMBOLS <lv_sourcevalue> TYPE string.

    CONSTANTS:
      lco_task_value_target       TYPE string VALUE 'TARGETVALUE',
      lco_task_target_field_name  TYPE string VALUE 'TGT_VAL',
      lco_task_value_status_field TYPE string VALUE 'STATUS',
      lco_task_value_status       TYPE string VALUE 'TASKITEMSTATUS',
      lco_max_item_count          TYPE int4 VALUE 20,
      lco_field_name              TYPE string VALUE 'SOURCEVALUE'.

    CLEAR es_response_context.
    CLEAR et_entityset.
    no_cache( ).
    IF io_tech_request_context->get_source_entity_set_name( ) IS NOT INITIAL.

      io_tech_request_context->get_converted_source_keys(
        IMPORTING
          es_key_values = ls_parameter
      ).

      "Outdated>>>Handle paging, at most one page contains 20 items
      IF is_paging-top > lco_max_item_count.
        "Due to a frontUI paging issue in taskvalue detail screen, not restrict the limit number any more
*        lv_limit = lco_max_item_count.
        lv_limit = is_paging-top.
      ELSE.
        lv_limit = is_paging-top.
      ENDIF.
      lv_offset = is_paging-skip.

      TRY.
          DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
          DATA(lo_object) = lo_project->get_migobj_proxy_by_uuid( ls_parameter-migrationobjectuuid ).
          DATA(lo_task) = lo_object->get_task_proxy_by_uuid( ls_parameter-migrationtaskuuid ).
          DATA(lo_task_ctx) = NEW /ltb/cl_mc_cntxt_task_detail( ).

          IF lv_limit <> 0 OR lv_offset <> 0.
            lo_task_ctx->set_page(
              EXPORTING
                iv_offset = lv_offset
                iv_limit  = CONV #( lv_limit )
            ).
          ENDIF.

          IF it_filter_select_options IS INITIAL AND iv_filter_string IS NOT INITIAL.
            DATA(lt_filter_select_option) = get_complex_filter_sel_option(
              EXPORTING
                io_tech_request_context = io_tech_request_context
                iv_entity_name          = iv_entity_name ).
          ELSE.
            lt_filter_select_option = it_filter_select_options.
          ENDIF.

          set_context( iv_entity_set_name = iv_entity_set_name
           iv_search_string = iv_search_string
           it_filter_select_options = lt_filter_select_option
           it_order = it_order
           io_context = lo_task_ctx
            ).

          lo_task->get_values(
            EXPORTING
              io_cntxt = lo_task_ctx
            IMPORTING
              et_values = DATA(lt_task_values)
              ev_count  = DATA(lv_task_value_count) ).

          IF io_tech_request_context->has_count( ) = abap_true.
            es_response_context-count = lv_task_value_count.
            RETURN.
          ENDIF.

          LOOP AT lt_task_values INTO DATA(ls_task_item) ##INTO_OK.
            CLEAR ls_entity.
            ls_entity-migrationprojectuuid = ls_parameter-migrationprojectuuid.
            ls_entity-migrationobjectuuid = ls_parameter-migrationobjectuuid.
            ls_entity-migrationtaskuuid = ls_parameter-migrationtaskuuid.

            DATA(lt_source_value) = ls_task_item-src_val.

            LOOP AT lt_source_value INTO DATA(lv_source_value) ##INTO_OK.
              UNASSIGN <lv_sourcevalue>.
              lv_field_name = lco_field_name && sy-tabix.
              ASSIGN COMPONENT lv_field_name OF STRUCTURE ls_entity TO <lv_sourcevalue>.
              IF <lv_sourcevalue> IS ASSIGNED.
                IF lv_source_value IS NOT INITIAL.
                  <lv_sourcevalue> = lv_source_value.
                ELSE.
                  <lv_sourcevalue> = get_text( 'BLA' ).
                ENDIF.
              ENDIF.
            ENDLOOP.
            ls_entity-targetvalue = ls_task_item-tgt_val.
            ls_entity-taskitemstatus = get_task_status_text( iv_status = ls_task_item-status ).
            ls_entity-taskitemstatusuuid = ls_task_item-status.
            ls_entity-migrationtaskitemuuid = ls_task_item-value_uuid.
            APPEND ls_entity TO et_entityset.
          ENDLOOP.

          IF io_tech_request_context->has_inlinecount( ) = abap_true.
            es_response_context-inlinecount = lv_task_value_count.
          ENDIF.

        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
          DATA(lt_mc_messages) = lo_exception->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD taskitemusedbyse_get_entityset.
    DATA:
      ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskitemusedby.
    CLEAR es_response_context.
    CLEAR et_entityset.
    IF NOT io_tech_request_context->get_source_entity_set_name( ) IS INITIAL.
      io_tech_request_context->get_converted_source_keys(
        IMPORTING
          es_key_values = ls_parameter
      ).
      get_where_used_list(
        EXPORTING
          iv_project_id = ls_parameter-migrationprojectuuid
          iv_object_id  = ls_parameter-migrationobjectuuid
          iv_task_id    = ls_parameter-migrationtaskuuid
        CHANGING
          ct_result     = et_entityset
      ).
    ENDIF.
  ENDMETHOD.


  METHOD taskitemvhset_get_entityset.
    DATA:
      ls_parameter   TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskitemvh,
      lt_filter_cond TYPE /ltb/if_mc_constants=>gtt_filter_cond.
    CONSTANTS:
      lco_target_value      TYPE string VALUE 'VALUE',
      lco_target_field_name TYPE string VALUE 'TGT_VAL'.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF NOT io_tech_request_context->get_source_entity_set_name( ) IS INITIAL.
      io_tech_request_context->get_converted_source_keys(
        IMPORTING
          es_key_values = ls_parameter
      ).

      TRY.
          DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( ls_parameter-migrationprojectuuid ).
          DATA(lo_object) = lo_project->get_migobj_proxy_by_uuid( ls_parameter-migrationobjectuuid ).
          DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_task_detail( ).
          DATA(lo_task) = lo_object->get_task_proxy_by_uuid( ls_parameter-migrationtaskuuid ).
          DATA(lt_fields) = lo_task->get_value_metadata( lo_obj_ctx ).

          DATA(lo_proj_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
          DATA(lv_approach) = lo_project->get_proj_details( lo_proj_ctx )-proj_approach.

*          IF lv_approach = /ltb/if_mc_constants=>gc_approach-file OR lv_approach = /ltb/if_mc_constants=>gc_approach-staging.
*            DATA(lv_task_type) = CAST /ltb/cl_mc_task_proxy_mwb( lo_task )->get_task_type( ).
*          ENDIF.

          READ TABLE lt_fields INTO DATA(ls_field)
            WITH KEY value_dir = /ltb/if_mc_constants=>gc_value_dir-target.

          IF sy-subrc <> 0.
            READ TABLE lt_fields INTO ls_field
              WITH KEY value_dir = /ltb/if_mc_constants=>gc_value_dir-custom.
          ENDIF.

          IF ls_field-value_vh_domain IS NOT INITIAL.
            DATA(lo_vh_cntxt) = NEW /ltb/cl_mc_cntxt_value_help( ).
            lo_vh_cntxt->set_vh(
                iv_vh_type   = /ltb/if_mc_constants=>gc_vh_type-domain
                iv_vh_source = CONV #( ls_field-value_vh_domain ) ).
            IF lv_approach = /ltb/if_mc_constants=>gc_approach-file OR lv_approach = /ltb/if_mc_constants=>gc_approach-staging.
              lo_vh_cntxt->add_value(
                   iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-approach
                   iv_value = CONV #( lv_approach ) ).
*              lo_vh_cntxt->add_value(
*                   iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-task_type
*                   iv_value = CONV #( ls_parameter-migrationtaskuuid ) ).
            ENDIF.
          ELSEIF ls_field-value_vh_checktab IS NOT INITIAL AND ls_field-value_vh_checkfld IS NOT INITIAL.
            lo_vh_cntxt = NEW /ltb/cl_mc_cntxt_value_help( ).
            lo_vh_cntxt->set_vh(
                iv_vh_type    = /ltb/if_mc_constants=>gc_vh_type-checktab
                iv_vh_source  = CONV #( ls_field-value_vh_checktab )
                iv_vh_source2 = CONV #( ls_field-value_vh_checkfld ) ).
            IF lv_approach = /ltb/if_mc_constants=>gc_approach-file OR lv_approach = /ltb/if_mc_constants=>gc_approach-staging.
              lo_vh_cntxt->add_value(
                   iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-approach
                   iv_value = CONV #( lv_approach ) ).
            ENDIF.
          ELSE.
            IF lv_approach = /ltb/if_mc_constants=>gc_approach-file OR lv_approach = /ltb/if_mc_constants=>gc_approach-staging.
              lo_vh_cntxt = NEW /ltb/cl_mc_cntxt_value_help( ).
              lo_vh_cntxt->add_value(
                  iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-approach
                  iv_value = CONV #( lv_approach ) ).
              lo_vh_cntxt->add_value(
                  iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-task_type
                  iv_value = CONV #( ls_parameter-migrationtaskuuid ) ).
            ELSE.
              RETURN.
            ENDIF.
          ENDIF.
          DATA(lt_filter_select_option) = io_tech_request_context->get_filter( )->get_filter_select_options( ).

          set_context( iv_entity_set_name = iv_entity_set_name
                       it_filter_select_options = lt_filter_select_option
                       io_context = lo_vh_cntxt
                      ).
          IF is_paging-skip IS NOT INITIAL OR is_paging-top IS NOT INITIAL.
            lo_vh_cntxt->set_page( iv_offset =  is_paging-skip  iv_limit = is_paging-top  ).
          ENDIF.
          DATA(lo_appl_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
          DATA(lt_value_help) = lo_appl_proxy->get_value_help( lo_vh_cntxt ).

          et_entityset = VALUE #( FOR value_help IN lt_value_help
                                  ( migrationprojectuuid = ls_parameter-migrationprojectuuid
                                    migrationobjectuuid  = ls_parameter-migrationobjectuuid
                                    migrationtaskuuid    = ls_parameter-migrationtaskuuid
                                    value                = value_help-tgt_val
                                    description          = value_help-tgt_descr
                                  )
                                ).
        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
          DATA(lt_mc_messages) = lo_exception->get_messages( ).
          raise_bussiness_exception(
            EXPORTING
              iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
              it_message = lt_mc_messages
          ).
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD taskoverviewset_get_entityset.
    DATA:
      ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskoverview,
      lt_obj_uuid  TYPE /ltb/mc_t_object_uuid,
      ls_entity    TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskoverview.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF NOT io_tech_request_context->get_source_entity_set_name( ) IS INITIAL.
      io_tech_request_context->get_converted_source_keys(
        IMPORTING
          es_key_values = ls_parameter ).

      IF line_exists( it_filter_select_options[ property = co_migration_object_uuid ] ).
        DATA(lt_select_option) = it_filter_select_options[ property = co_migration_object_uuid ]-select_options.
        lt_obj_uuid = VALUE #( FOR select_option IN lt_select_option ( CONV #( select_option-low ) ) ).
      ENDIF.

      IF ls_parameter-migrationobjectuuid IS NOT INITIAL.
        APPEND ls_parameter-migrationobjectuuid TO lt_obj_uuid.
      ENDIF.

      get_task_list(
        EXPORTING
          it_object_id            = lt_obj_uuid
          iv_project_id           = ls_parameter-migrationprojectuuid
          io_tech_request_context = io_tech_request_context
        IMPORTING
          ev_open_task_count      = ls_entity-opentaskcount
          ev_confirmed_task_count = ls_entity-confirmedtaskcount
          ev_info_loss_task_count = ls_entity-errortaskcount
      ).

      ls_entity-migrationprojectuuid = ls_parameter-migrationprojectuuid.
      APPEND ls_entity TO et_entityset.
    ENDIF.
  ENDMETHOD.


  METHOD taskprocessingse_get_entityset.

    DATA:
      ls_taskproc TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskprocessing.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_taskproc ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_taskproc-migrationprojectuuid ) ).

        DATA(lo_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).

        set_context(
          EXPORTING
            iv_entity_set_name = iv_entity_set_name
            it_order           = it_order
            io_context         = lo_ctx
        ).

        DATA(lt_taskproc) = lo_project_proxy->get_taskproc_list( lo_ctx ).

        et_entityset = VALUE #(
          FOR <taskproc> IN lt_taskproc
          (
            migrationprojectuuid = <taskproc>-proj_uuid
            taskuuid             = <taskproc>-task_uuid
            tasktype             = <taskproc>-task_type
            taskident            = <taskproc>-task_ident
            taskdescr            = <taskproc>-task_descr
            numoffiles           = <taskproc>-num_files
            instancetotal        = <taskproc>-total_instance
          )
        ).

        es_response_context-inlinecount = lines( et_entityset ).
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD taskprocfileset_get_entityset.

    DATA:
      ls_taskprocfile TYPE /ltb/cl_mig_mc_odata_mpc=>ts_taskprocfile.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_taskprocfile ).

    TRY.
        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( ls_taskprocfile-migrationprojectuuid ) ).

        DATA(lo_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).

        lo_ctx->add_value(
          EXPORTING
            iv_type  = /ltb/if_mc_constants=>gc_cntxt_type-task_uuid
            iv_value = CONV #( ls_taskprocfile-taskuuid )
        ).

        DATA(lt_files) = lo_project_proxy->get_taskproc_files( lo_ctx ).

        et_entityset = VALUE #(
          FOR <file> IN lt_files
          (
            migrationprojectuuid = <file>-proj_uuid
            taskuuid             = <file>-task_uuid
            taskfileuuid         = <file>-file_uuid
            filename             = <file>-file_name
            filesize             = <file>-file_size
            createby             = /ltb/cl_mc_odata_generic_func=>get_fullname_by_uname( CONV #( <file>-created_by ) )
            createat             = <file>-created_at
            numofinstances       = <file>-num_instances
          )
        ).

        es_response_context-inlinecount = lines( et_entityset ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_exception).
        DATA(lt_messages) = lx_exception->get_messages( ).

        IF lt_messages IS INITIAL.
          APPEND VALUE #( msgty = 'E'
                          msgid = lx_exception->if_t100_message~t100key-msgid
                          msgno = lx_exception->if_t100_message~t100key-msgno
                          msgv1 = lx_exception->msgv1
                          msgv2 = lx_exception->msgv2
                          msgv3 = lx_exception->msgv3
                          msgv4 = lx_exception->msgv4 ) TO lt_messages.

        ENDIF.

        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            it_message           = lt_messages
            iv_message_unlimited = lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD taskset_get_entity.

    CLEAR es_response_context.
    no_cache( ).
    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values = er_entity
    ).
    TRY.
        DATA(lo_project) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( er_entity-migrationprojectuuid ).
        DATA(lo_object) = lo_project->get_migobj_proxy_by_uuid( er_entity-migrationobjectuuid ).
        DATA(lo_task) = lo_object->get_task_proxy_by_uuid( iv_task_uuid = er_entity-migrationtaskuuid ).
        DATA(lo_task_ctx) = NEW /ltb/cl_mc_cntxt_task_detail( ).

        lo_object->get_all_tasks(
          EXPORTING io_cntxt = lo_task_ctx
          IMPORTING et_data  = DATA(lt_all_tasks) ).

        lo_object->get_tasks(
          EXPORTING io_cntxt = lo_task_ctx
          IMPORTING et_data  = DATA(lt_tasks) ).

        READ TABLE lt_tasks INTO DATA(ls_task) WITH KEY task_uuid = er_entity-migrationtaskuuid.
        IF sy-subrc = 0.
          DATA(lv_description) = /ltb/cl_mc_odata_generic_func=>get_document_as_string( ls_task-task_doc_descr ).

          er_entity-taskname = ls_task-task_descr.
          er_entity-taskdescription = lv_description.
          er_entity-taskstatus = get_task_status_text( ls_task-task_status ).
          er_entity-taskstatusuuid = ls_task-task_status.
          er_entity-tasktypeid = ls_task-task_type.
          er_entity-tasktype = get_task_type_text( ls_task-task_type ).
          er_entity-tasktechname = ls_task-task_name.
          er_entity-tasktempid = ls_task-task_tmpl_uuid.
          er_entity-hascheck = ls_task-hascheck.
*          er_entity-tasklocked = ls_task-task_locked.
*          er_entity-taskmessage = ls_task-task_message.
          lo_task->get_values(
            EXPORTING
              io_cntxt  = lo_task_ctx
            IMPORTING
              ev_count  = er_entity-taskitemcount
          ).
        ELSE.
          READ TABLE lt_all_tasks INTO ls_task WITH KEY task_uuid = er_entity-migrationtaskuuid.
          IF sy-subrc = 0.
            lv_description = /ltb/cl_mc_odata_generic_func=>get_document_as_string( ls_task-task_doc_descr ).

            er_entity-taskname = ls_task-task_descr.
            er_entity-taskdescription = lv_description.
            er_entity-taskstatus = get_task_status_text( ls_task-task_status ).
            er_entity-taskstatusuuid = ls_task-task_status.
            er_entity-tasktypeid = ls_task-task_type.
            er_entity-tasktype = get_task_type_text( ls_task-task_type ).
            er_entity-tasktechname = ls_task-task_name.
            er_entity-tasktempid = ls_task-task_tmpl_uuid.
            er_entity-hascheck = ls_task-hascheck.
            lo_task->get_values(
              EXPORTING
                io_cntxt  = lo_task_ctx
              IMPORTING
                ev_count  = er_entity-taskitemcount
            ).
          ENDIF.
        ENDIF.
      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_exception).
        DATA(lt_mc_messages) = lo_exception->get_messages( ).
        raise_bussiness_exception(
          EXPORTING
            iv_textid  = /iwbep/cx_mgw_busi_exception=>business_error
            it_message = lt_mc_messages
        ).
    ENDTRY.
  ENDMETHOD.


  METHOD taskset_get_entityset.
    DATA:
      ls_parameter TYPE /ltb/cl_mig_mc_odata_mpc=>ts_task,
      lt_object_id TYPE /ltb/mc_t_object_uuid.

    CLEAR es_response_context.
    CLEAR et_entityset.

    IF NOT io_tech_request_context->get_source_entity_set_name( ) IS INITIAL.

      io_tech_request_context->get_converted_source_keys(
        IMPORTING
          es_key_values = ls_parameter
      ).

      IF ls_parameter-migrationobjectuuid IS NOT INITIAL.
        APPEND ls_parameter-migrationobjectuuid TO lt_object_id.
      ENDIF.

      IF line_exists( it_filter_select_options[ property = co_migration_object_uuid ] ).
        DATA(lt_select_option) = it_filter_select_options[ property = co_migration_object_uuid ]-select_options.
        lt_object_id = VALUE #( FOR select_option IN lt_select_option ( CONV #( select_option-low ) ) ).
      ENDIF.

      get_task_list(
        EXPORTING
          it_object_id  =  lt_object_id
          iv_project_id =  ls_parameter-migrationprojectuuid
          io_tech_request_context = io_tech_request_context
        IMPORTING
          ev_confirmed_task_count = DATA(lv_confirmed_task_count)
          ev_open_task_count      = DATA(lv_open_task_count)
          ev_info_loss_task_count = DATA(lv_info_loss_task_count)
        CHANGING
          ct_result     = et_entityset
      ).

      DATA(lv_count) = lv_confirmed_task_count + lv_open_task_count + lv_info_loss_task_count.

      IF io_tech_request_context->has_count( ) = abap_true.
        es_response_context-count = lv_count.
        RETURN.
      ENDIF.

      IF io_tech_request_context->has_inlinecount( ) = abap_true.
        es_response_context-inlinecount = lv_count.
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD upload_migration_csv_bundle.

    DATA:
      lt_csv_bundle TYPE TABLE OF /ltb/cl_mig_mc_odata_mpc=>ts_uploadcsvbundle.

    TRY .
        /ui2/cl_json=>deserialize(
          EXPORTING
            json        = iv_slug
            pretty_name = /ui2/cl_json=>pretty_mode-camel_case
          CHANGING
            data        = lt_csv_bundle
        ).

        READ TABLE lt_csv_bundle ASSIGNING FIELD-SYMBOL(<fs_csv_bundle>) INDEX 1.
        IF sy-subrc <> 0.
          RETURN.
        ENDIF.

        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( <fs_csv_bundle>-migrationprojectuuid ) ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( <fs_csv_bundle>-migrationobjectuuid ) ).
        DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( <fs_csv_bundle>-csvbundleuuid ) ).

        DATA(lo_csv_bundle) = CAST /ltb/if_mc_csv_bundle( lo_file_proxy ).

        lo_csv_bundle->upload(
          EXPORTING
            iv_filename  = <fs_csv_bundle>-filename
            iv_mime_type = is_media_resource-mime_type
            iv_trig_validation = iv_trig_validation
            iv_data      = is_media_resource-value
        ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_error).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lx_error->get_text( )
            it_message           = lx_error->get_messages( )
        ).
    ENDTRY.

    copy_data_to_ref(
      EXPORTING
        is_data = <fs_csv_bundle>
      CHANGING
        cr_data = er_entity
    ).

  ENDMETHOD.


  METHOD upload_migration_csv_file.
*
*    DATA:
*      lt_csv_file TYPE TABLE OF /ltb/cl_mig_mc_odata_mpc=>ts_uploadcsvfile.
*
*    IF is_media_resource-mime_type <> co_mime_type_csv.
**      raise_bussiness_exception( iv_textid = /ltb/cx_mc_proxy_error=>file_wrong_format ).
*    ENDIF.
*
*    TRY .
*        /ui2/cl_json=>deserialize(
*          EXPORTING
*            json        = iv_slug
*            pretty_name = /ui2/cl_json=>pretty_mode-camel_case
*          CHANGING
*            data        = lt_csv_file
*        ).
*
*        READ TABLE lt_csv_file ASSIGNING FIELD-SYMBOL(<fs_csv_file>) INDEX 1.
*
*        IF sy-subrc <> 0.
*          RETURN.
*        ENDIF.
*
*        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( <fs_csv_file>-migrationprojectuuid ) ).
*        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( CONV #( <fs_csv_file>-migrationobjectuuid ) ).
*        DATA(lo_file_proxy) = lo_object_proxy->get_file_proxy_by_uuid( CONV #( <fs_csv_file>-csvbundleuuid ) ).
*
*        DATA(lo_csv_bundle) = CAST /ltb/if_mc_csv_bundle( lo_file_proxy ).
*
*        lo_csv_bundle->save_file(
*          EXPORTING
*            iv_struct_ident = CONV #( <fs_csv_file>-techid )
*            iv_filename     = CONV #( <fs_csv_file>-filename )
*            iv_data         = is_media_resource-value
*        ).
*
*      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_error).
*        raise_bussiness_exception(
*          EXPORTING
*            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
*            iv_message_unlimited = lx_error->get_text( )
*            it_message           = lx_error->get_messages( )
*        ).
*
*    ENDTRY.
*
*    copy_data_to_ref(
*      EXPORTING
*        is_data = <fs_csv_file>
*      CHANGING
*        cr_data = er_entity
*    ).

  ENDMETHOD.


  METHOD upload_migration_file.

    IF is_media_resource-mime_type = co_mime_type_xml.
      upload_migration_xml_file(
        EXPORTING
          is_media_resource = is_media_resource
          iv_slug           = iv_slug
        IMPORTING
          er_entity         = er_entity
      ).
    ELSEIF is_media_resource-mime_type = co_mime_type_compressed_zip OR
           is_media_resource-mime_type = co_mime_type_zip.
      IF is_csv_or_xml( is_media_resource-value ) = /ltb/if_mc_constants=>gc_fileproc-category-xml.
        upload_migration_xml_file(
          EXPORTING
            is_media_resource = is_media_resource
            iv_slug           = iv_slug
          IMPORTING
            er_entity         = er_entity
        ).
      ELSE.
        DATA(l_slug) = create_csv_bundle( iv_slug ).

        upload_migration_csv_bundle(
          EXPORTING
            is_media_resource = is_media_resource
            iv_slug           = l_slug
          IMPORTING
            er_entity         = er_entity
        ).
      ENDIF.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = /ltb/cx_mc_proxy_error=>file_wrong_format.
    ENDIF.

  ENDMETHOD.


  METHOD upload_migration_xml_file.

    DATA:
      lt_xml_file TYPE TABLE OF /ltb/cl_mig_mc_odata_mpc=>ts_migrationobjectfileupload.

    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING
            json        = iv_slug
            pretty_name = /ui2/cl_json=>pretty_mode-camel_case
          CHANGING
            data        = lt_xml_file
        ).

        READ TABLE lt_xml_file ASSIGNING FIELD-SYMBOL(<fs_xml_file>) INDEX 1.
        IF sy-subrc <> 0.
          RETURN.
        ENDIF.

        DATA(lo_project_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( <fs_xml_file>-migrationprojectuuid ).
        DATA(lo_object_proxy) = lo_project_proxy->get_migobj_proxy_by_uuid( <fs_xml_file>-migrationobjectuuid ).

        DATA(lo_obj_ctx) = NEW /ltb/cl_mc_cntxt_obj_detail( ).

        lo_obj_ctx->set_filename( CONV #( <fs_xml_file>-filename ) ).

        lo_obj_ctx->set_mimetype( is_media_resource-mime_type ).

        lo_object_proxy->upload_file(
          EXPORTING
            io_cntxt = lo_obj_ctx
            iv_xdata = is_media_resource-value
        ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_error).
        DATA(lt_mc_messages) = lx_error->get_messages( ).

        IF lt_mc_messages IS NOT INITIAL.
          LOOP AT lt_mc_messages INTO DATA(ls_message).
            IF ls_message-msgid = 'CNV_DMC_MD_EXTRACTOR' AND ls_message-msgno = '011'.
              raise_bussiness_exception(
                EXPORTING
                  iv_textid            = /ltb/cx_mc_proxy_error=>file_too_large
                  iv_message_unlimited = lx_error->get_text( )
               ).
            ENDIF.
          ENDLOOP.
        ENDIF.
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lx_error->get_text( )
            it_message           = lx_error->get_messages( )
        ).
    ENDTRY.

    copy_data_to_ref(
      EXPORTING
        is_data = <fs_xml_file>
      CHANGING
        cr_data = er_entity
    ).

  ENDMETHOD.


  METHOD upload_project_file.

    DATA:
      ls_enity TYPE /ltb/cl_mig_mc_odata_mpc=>ts_migrationprojectimportexpor.

    IF is_media_resource-mime_type <> co_mime_type_compressed_zip AND is_media_resource-mime_type <> co_mime_type_zip.
      RETURN.
    ENDIF.

    TRY.
        DATA(lo_app_proxy) = /ltb/cl_mc_proxy_factory=>get_appl_proxy( ).
        DATA(lo_app_context) = NEW /ltb/cl_mc_cntxt_new_proj( ).

        ls_enity-migrationprojectuuid = lo_app_proxy->import_proj_async(
          EXPORTING
            io_cntxt         = lo_app_context
            iv_data          = is_media_resource-value
        ).

      CATCH /ltb/cx_mc_static_check_msg INTO DATA(lo_mc_static_exception).
        raise_bussiness_exception(
          EXPORTING
            iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
            iv_message_unlimited = lo_mc_static_exception->get_text( )
        ).
    ENDTRY.

    copy_data_to_ref(
      EXPORTING
        is_data = ls_enity
      CHANGING
        cr_data = er_entity
    ).

  ENDMETHOD.


  METHOD upload_task_file.

    TYPES:
      BEGIN OF ty_uploadtaskfile,
        filename             TYPE string,
        migrationprojectuuid TYPE string,
      END OF ty_uploadtaskfile.

    DATA:
      lt_uploadtaskfile     TYPE TABLE OF ty_uploadtaskfile,
      ls_upload_task_entity TYPE /ltb/cl_mig_mc_odata_mpc=>ts_uploadtaskfile.

    IF is_media_resource-mime_type = co_mime_type_compressed_zip OR
       is_media_resource-mime_type = co_mime_type_zip OR
       is_media_resource-mime_type = co_mime_type_xml.
      TRY.
          /ui2/cl_json=>deserialize(
            EXPORTING
              json = iv_slug
              pretty_name = /ui2/cl_json=>pretty_mode-camel_case
            CHANGING
              data = lt_uploadtaskfile ).

          LOOP AT lt_uploadtaskfile INTO DATA(ls_uploadtaskfile).
            DATA(lv_proj_uuid) = ls_uploadtaskfile-migrationprojectuuid.
            DATA(lo_proj_proxy) = /ltb/cl_mc_proxy_factory=>get_proj_proxy_by_uuid( CONV #( lv_proj_uuid ) ).
            DATA(lo_proj_ctx) = NEW /ltb/cl_mc_cntxt_proj_detail( ).
            DATA(lv_filename) = ls_uploadtaskfile-filename.

            lo_proj_ctx->set_filename( CONV #( lv_filename ) ).
            lo_proj_ctx->set_mimetype( is_media_resource-mime_type ).
            lo_proj_proxy->upload_task_file(
              EXPORTING
                io_cntxt = lo_proj_ctx
                iv_xdata = is_media_resource-value ).
          ENDLOOP.
        CATCH /ltb/cx_mc_static_check_msg INTO DATA(lx_error).
          "there are messages with long text
          DATA(lt_mc_messages) = lx_error->get_messages( ).
          IF lt_mc_messages IS NOT INITIAL.
            LOOP AT lt_mc_messages INTO DATA(ls_message).
              IF ls_message-msgid = 'CNV_DMC_MD_EXTRACTOR' AND ls_message-msgno = '011'.
                raise_bussiness_exception(
                  EXPORTING
                    iv_textid            = /ltb/cx_mc_proxy_error=>file_too_large
                    iv_message_unlimited = lx_error->get_text( )
                 ).

              ENDIF.
            ENDLOOP.
          ENDIF.
          raise_bussiness_exception(
            EXPORTING
              iv_textid            = /iwbep/cx_mgw_busi_exception=>business_error
              iv_message_unlimited = lx_error->get_text( )
              it_message           = lx_error->get_messages( )
          ).
      ENDTRY.
      ls_upload_task_entity-migrationprojectuuid = lv_proj_uuid.
    ENDIF.

    copy_data_to_ref( EXPORTING is_data = ls_upload_task_entity
                      CHANGING  cr_data = er_entity ).

  ENDMETHOD.


  METHOD valuehelpfieldse_get_entityset.

    DATA: ls_value_help TYPE /ltb/cl_mig_mc_odata_mpc=>ts_valuehelp.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_value_help ).

    DATA(lo_mc_value_help_factory) = NEW /ltb/cl_mc_value_help_factory( ).

    DATA(lo_value_help_srv) = lo_mc_value_help_factory->/ltb/if_mc_value_help_factory~get_value_help_srv( iv_value_help_type = ls_value_help-valuehelptype
                                                                                                          iv_value_help_name = ls_value_help-valuehelpname ).

    CASE ls_value_help-valuehelpstep.
      WHEN co_value_help_step_import.
        DATA(lt_search_fields) = lo_value_help_srv->get_search_fields( ).

        et_entityset = VALUE #( FOR ls_search_field IN lt_search_fields
                                    (  valuehelptype = ls_value_help-valuehelptype
                                       valuehelpname = ls_value_help-valuehelpname
                                       valuehelpstep = ls_value_help-valuehelpstep
                                       fieldname     = ls_search_field-field_name
                                       position      = ls_search_field-field_pos
                                       fielddesc     = ls_search_field-field_desc
                                       fieldtype     = ls_search_field-field_type
                                       fieldlength   = ls_search_field-field_length ) ).


      WHEN co_value_help_step_export.
        DATA(lt_output_fields) = lo_value_help_srv->get_output_fields( ).

        et_entityset = VALUE #( FOR ls_output_field IN lt_output_fields
                                    (  valuehelptype = ls_value_help-valuehelptype
                                       valuehelpname = ls_value_help-valuehelpname
                                       valuehelpstep = ls_value_help-valuehelpstep
                                       fieldname     = ls_output_field-field_name
                                       position      = ls_output_field-field_pos
                                       fielddesc     = ls_output_field-field_desc
                                       fieldtype     = ls_output_field-field_type
                                       fieldlength   = ls_output_field-field_length
                                       starfield     = ls_output_field-is_output_field ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.