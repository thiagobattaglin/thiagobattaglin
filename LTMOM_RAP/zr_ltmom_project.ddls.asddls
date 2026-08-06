@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'LTMOM - Snapshot dos Projetos (read-only)'
@Metadata.ignorePropagatedAnnotations: true

/******************************************************************
 * View de LEITURA sobre as tabelas standard do Migration Cockpit.
 *
 * Objetivo: alimentar o BO ZR_MIG_RUN com o status atual reportado
 * pelo LTMOM/LTMC. Nao ha WRITE. Nao ha SUBMIT sobre reports SAP.
 *
 * ========================== ATENCAO ============================
 * Os nomes das tabelas standard variam por release. Verifique no
 * seu S/4 (ADT -> Data Preview) e ajuste a source apenas se
 * necessario. Candidatos comuns:
 *
 *   * dmc_c_projstats  – estatisticas por projeto/objeto
 *   * dmc_mc_prj       – header do projeto de migracao
 *   * dmc_mc_obj       – objetos de migracao dentro do projeto
 *   * dmc_mc_status    – status por execucao
 *   * dmc_c_mp_ltmc    – LTMC classic project stats
 *
 * A shape abaixo (colunas de saida) e o CONTRATO que o BO
 * consome. Se voce mudar a fonte, mantenha o alias das colunas.
 * ================================================================
 ******************************************************************/
define view entity ZR_LTMOM_PROJECT
  as select from dmc_c_projstats                       // TODO: ajustar por release
{
      // ---- Chaves lógicas ------------------------------------------
  key   cast( project_id    as abap.char( 30 ) )       as ProjectId,
  key   cast( subproject_id as abap.char( 30 ) )       as SubprojectId,
  key   cast( object_id     as abap.char( 30 ) )       as ObjectId,
  key   cast( phase         as abap.char( 10 ) )       as Phase,

      // ---- Status normalizado (N/R/S/E/C) --------------------------
      case status
        when 'NEW'      then 'N'
        when 'RUNNING'  then 'R'
        when 'FINISHED' then 'S'
        when 'ERROR'    then 'E'
        when 'CANCELED' then 'C'
        else                 'N'
      end                                              as Status,

      // ---- Contadores ---------------------------------------------
      cast( total_recs   as abap.int4 )                as TotalRecs,
      cast( success_recs as abap.int4 )                as SuccessRecs,
      cast( error_recs   as abap.int4 )                as ErrorRecs,

      // ---- Mensageria ---------------------------------------------
      cast( last_msg as abap.char( 220 ) )             as LastMsg,

      // ---- Timestamps ---------------------------------------------
      started_at                                       as StartedAt,
      finished_at                                      as FinishedAt
}
