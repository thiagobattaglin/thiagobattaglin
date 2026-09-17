# Falhas potenciais e riscos da POC

Análise cruzando o que a POC promete (`https://think-misty-19230415.figma.site`)
com o que o serviço `/LTB/MIG_MC_ODATA_SRV` realmente exige, olhando a classe
DPC `/LTB/CL_MIG_MC_ODATA_DPC_EXT` e o metadata dos entity sets.

## 🔴 Bloqueadores (impedem o `POST MigrationProjectSet` de funcionar)

1. **CSRF token não representado.** O SAP Gateway rejeita qualquer `POST`, `PUT`, `MERGE` sem um handshake `X-CSRF-Token: fetch` seguido do envio do token. A POC não sinaliza esse passo nem armazenamento de cookie `SAP_SESSIONID_*`.
2. **`POST MigrationProjectSet` isolado não cria projeto.** No DPC EXT o `create_entity` de `MigrationProjectSet` é agrupado em `changeset_begin` (constante `CO_ACTION_CREATE_PROJ = 'CREPROJ'`) — precisa vir dentro de um `$batch` com `Content-Type: multipart/mixed` contendo `changeset` e, dependendo do caso, entidades filhas (`MigrationObject`, filtros, seleção de MO). Um único POST atomico como a POC sugere retorna erro `/IWBEP/CX_MGW_BUSI_EXCEPTION`.
3. **Autorização SAP obrigatória.** Todo request chama `cl_dmc_authority=>check_execute` (e `check_display` para GETs). Se o usuário SKP mapeado no destino RFC não tiver a autorização `S_DMC_MC`/`S_TCODE LTMC`, todas as chamadas retornam 403. A POC exibe apenas a tag `DEV – DEV` como se fosse o suficiente.
4. **`check_system_upgrade`.** Se o tenant estiver em `System Upgrade Running`, o próprio `create_entity` levanta exceção business e a UI simplesmente exibirá um botão sem feedback.

## 🟠 Riscos de alto impacto na execução real

5. **`Migration Approach` é hardcoded para `STAGING`.** Se a instalação SAP não expuser o cenário `STAGING` (ex.: Cloud com abordagem `FILE` apenas) o `MigrationApproachSet` retorna vazio e `maintain_project` falha em silêncio.
6. **UUIDs de staging por ambiente.** A própria POC destaca "Table UUIDs differ per environment", mas a listagem exibida usa `/1LT/DSS4100260x`. Se o payload gerado usar esses UUIDs literais em QA/PRD, o carregamento ETL tenta gravar em tabelas que não existem naquele sistema.
7. **`SetParallelJobs` sem validar `SAP Basis Max Workers`.** O slider vai até 50, mas o campo lateral diz 20. `SET_PARALLEL_JOBS` no ABAP valida contra as configurações do Basis (`CO_SET_PARALLEL_JOBS`); a POC deixa o usuário submeter valores maiores → mensagem confusa retornada pelo Gateway.
8. **Simulation não aparece no Execution Sequence.** A UI oferece o radio `Simulation`, mas o quadro "Execution Sequence" só lista `POST StartMigration`. A action correta seria `Simulation` (`CO_ACTION_MO_SIMULATION` → `MO_SIMULATION_TRANSACTION`). Executar Production em vez de Simulation cria PO reais no S/4HANA.
9. **Race condition SetParallelJobs → StartMigration.** `SET_PARALLEL_JOBS` roda de forma assíncrona; o botão "Apply parallel jobs first" só destrava o Start, mas não há confirmação de que o SAP já persistiu o novo `NumBackgroundJob`. A carga pode iniciar com o valor anterior.
10. **Idempotência.** Clicar em `POST MigrationProjectSet` duas vezes cria dois projetos com nomes iguais. Só existe `check_projname_availability` no ABAP, chamada durante o create; a POC não valida antes.
11. **Confirmação de Mapping Tasks (`ConfirmTask`).** Objetos LTMC frequentemente têm tarefas de mapeamento pendentes (`OpenTaskCount > 0` no metadata: MM PO já vem com `OpenTaskCount = 1`). O `StartMigration` falha se houver tarefas não confirmadas — passo ausente da POC.
12. **Copy de Migration Object.** O metadata mostra `IsCopied = true` para o exemplo, mas custom projects precisam explicitamente disparar `CopyActionSet`/`MigrationTemplateSet`. A POC pula essa etapa.

## 🟡 Riscos de dado / qualidade

13. **`PO_EKET_T` está com status `Error` em Step 2** — apesar disso a UI permite avançar para o Run & Monitor. Executar StartMigration com staging incompleto causa `Schedule Line` faltando → PO criado sem entrega, ou aborto.
14. **`S_ADRC` e `S_EKKO_TEXT` estão `Idle`.** Sem `Header Address` e `Header Texts` carregados, campos como `ADRNR` na `EKKO` ficam vazios (POs sem endereço de fornecedor válido).
15. **Field mapping mostra apenas 9 colunas de `S_EKKO`.** Faltam obrigatórios: `EBELP` (para item), `MATNR`, `MENGE`, `MEINS`, `NETPR`, `WERKS`, `LGORT` (`S_EKPO`). Sem esses o simulate falha em massa.
16. **Transformações limitadas.** Apenas `FORMAT_DATE` está exibido; conversões usuais (`LEADING_ZEROS` para `LIFNR`/`EBELN`, `CURR_CONVERT` para `NETPR`, `UNIT_CONVERT` para `MEINS`) não estão no combobox.
17. **Total staged (54 939) não bate com "Records Staged (5 847)".** Header vs total de linhas. Em uma UI real esse mismatch precisa ser explicado — hoje induz o usuário a achar que 54k pedidos serão migrados.

## 🟢 Observabilidade / operação

18. **Activity Log é volátil.** Os eventos exibidos parecem in-memory; para SOX/auditoria, precisa persistir via `DownloadShowMessagesRALMonitor` (`CO_DOWNLOADAPPLLOGRAL`) — não implementado.
19. **Readback simplista.** A tabela mostra `Legacy PO# → New SAP PO#`, mas o serviço não expõe endpoint dedicado. Depende de leitura de `MigrationInstanceSet` + join com `EKKO`; se o job for muito grande, a UI precisa paginar (não representado).
20. **Sem tratamento de retry.** Erros como `Vendor V-ABC003 not found` sinalizados como `WARN` na Simulation viram `ERR` em Production; a POC não oferece "Reprocessar apenas linhas com erro" (equivale ao `InstanceBulkProcess` do ABAP).
21. **Sem indicação de `RfcConnectionInvalid`/`IsDBConLost`.** Ambos existem no metadata (`MigrationProject`) e devem ser exibidos antes de deixar o usuário rodar carga — POC não mostra.
22. **Conflito de fuso horário.** Log usa horário local (`09:14:02`) sem zona; o backend usa UTC (`convert_time_stamp` no DPC). Divergência em auditoria multi-região.

## 🔵 Governança e mudança de escopo

23. **Ambiente PRD sem gate.** O dropdown NA/EU/APAC × DEV/QA/PRD é livre; não há confirmação/aprovação para `Production` (deveria pelo menos exigir duplo clique + ticket).
24. **Nome do job (`ZSKP_PO_LTMC_JOB`) hardcoded.** Reuso do mesmo nome em execuções paralelas pode gerar conflito de `TBTCO`.
25. **Multi-tenant / multi-projeto.** A POC assume um único projeto por vez. Não trata cenário em que múltiplas cargas concorrentes bloqueiem a mesma MO (`ENQUEUE_ECNV_PE_MC_LOCK`) — DPC chama `check_delete_lock`, mas a UI não expõe.

## 🧪 Sugestões de melhoria de curto prazo

- Adicionar chamada `X-CSRF-Token: fetch` antes do primeiro POST e persistir o token.
- Trocar o botão único por um `$batch` com changeset (`Content-Type: multipart/mixed`) que crie `MigrationProject` + `MigrationObject` de uma vez.
- Bloquear o "Next" da Etapa 2 enquanto houver mapeamento em status `Error` ou `Idle`.
- Refletir a escolha `Simulation`/`Production` na "Execution Sequence" (`POST Simulation` vs `POST StartMigration`).
- Exibir `MigrationProjectStatus`, `IsDBConLost`, `RfcConnectionInvalid` e `UpgradeState` antes de habilitar Start.
- Validar `NumBackgroundJob ≤ SAP Basis Max Workers` no client-side.
- Incluir passo de `ConfirmTask` / `PrepareMappingTasks` (`CO_ACTION_MO_PREPARE_MAPTSKS`) para MOs com `OpenTaskCount > 0`.
- Persistir Application Log em storage próprio via `DownloadShowMessagesRALMonitor` para trilha de auditoria.
