# Revisao da Arquitetura de Alto Volume

## Conclusao

A arquitetura baseada em replicacao direta para tabelas de staging no SAP e superior ao transporte de documentos por HTTP ou RFC para o cenario de um milhao ou mais de objetos.

O principio central e separar completamente:

- plano de dados: replicacao em massa para staging persistente no SAP;
- plano de controle: ativacao, pausa, status, retry e reconciliacao;
- plano de execucao: dispatcher duravel e workers BAPI limitados;
- plano de resultado: status por objeto, mensagens, chave SAP e auditoria.

HTTP/RAP pode permanecer no plano de controle, mas nao deve transportar o payload massivo nem manter a requisicao aberta durante a criacao dos documentos.

## Validacao do `http-api-fail.txt`

### 1. Memoria do payload HTTP

A conclusao esta correta. `request->get_text()` exige a materializacao integral do body. O parser JSON e a estrutura ABAP criam representacoes adicionais. O valor exato de 500 MB a 1 GB depende do payload e deve ser medido com SAT/ST12 e memory snapshots, mas o risco arquitetural existe independentemente da estimativa.

Dividir um milhao de documentos em requests de 10 mil reduz o tamanho total por request, mas nao remove:

- pico de memoria por request;
- tempo de parse antes de qualquer progresso persistente;
- repeticao do custo de serializacao;
- perda de todo o request se a sessao falhar antes do staging.

### 2. Ausencia de streaming JSON util

A observacao e valida para a implementacao analisada: ela recebe texto completo e usa parsing materializado. Mesmo que outro parser incremental fosse introduzido, isso apenas reduziria o pico de ingestao. Nao resolveria controle de carga, retomada, idempotencia e pressao dos workers.

Portanto, streaming nao e o eixo principal da solucao. A replicacao bulk elimina o HTTP do plano de dados.

### 3. Paralelismo dentro da request

`cl_abap_parallel` em modo sincrono mantem a requisicao HTTP dependente da conclusao dos workers. Isso mistura timeout de rede, limite do work process, criacao de documentos e agregacao de resultados na mesma unidade operacional.

O modo assincrono reduz o tempo da resposta, mas ainda paga parse e persistencia na thread HTTP. O uso de tRFC/aRFC tambem precisa de observabilidade e recuperacao explicitas; disparar tarefas e ignorar excecoes nao constitui uma fila duravel de negocio.

### 4. Backpressure

A ausencia de backpressure e um bloqueador de producao. O sistema precisa limitar separadamente:

- taxa de replicacao;
- quantidade de packages publicados como `READY`;
- profundidade da fila de objetos;
- workers ativos por tipo de objeto;
- consumo de work processes;
- locks e tempo de banco;
- taxa de commits e update tasks.

Quando os limites forem atingidos, a publicacao ou o dispatch deve pausar. Criar mais workers nao pode ser a resposta automatica para backlog crescente.

## Avaliacao da Imagem

### O que esta correto

- O volume de negocio chega ao SAP por replicacao e termina em staging persistente.
- Workers consomem dados do staging em vez de receber JSON.
- O processamento BAPI ocorre de forma paralela e desacoplada da transferencia massiva.
- O scanner e o catalogo podem usar uma API separada para metadata, controle e consulta.

### O que deve ser alterado

#### HTTP API creates workers

A API deve somente registrar um comando curto, publicar ou ativar um package, ou solicitar retry. Um scheduler/evento acorda o dispatcher. O dispatcher aplica limites, cria claims persistentes e entrega apenas chaves aos workers.

Isso evita que disponibilidade e timeout HTTP controlem a execucao do lote.

#### Batch Commit / Commit per Worker

O default deve ser commit ou rollback por objeto de negocio. Um worker processa varios objetos sequencialmente, mas cada objeto tem resultado e LUW independentes.

Commit por worker ou micro-batch somente pode ser habilitado para um adapter que prove:

- suporte transacional da API usada;
- ausencia de efeitos colaterais entre objetos;
- recuperacao deterministica;
- ganho de performance medido;
- aceite do maior escopo de rollback.

#### Publicacao das tabelas de staging

Replicar headers, items e manifest em momentos diferentes pode expor objetos incompletos. O protocolo deve ser data-first:

1. Criar o run/package em estado `LOADING`.
2. Replicar todas as tabelas filhas e de cabecalho.
3. Validar contagens, relacionamentos, versao e hash.
4. Publicar o manifest como `READY` em uma operacao controlada.
5. Permitir que o dispatcher leia apenas `READY`.

Se o conector nao garantir ordenacao entre tabelas, a ativacao deve depender de contagens e marcadores de conclusao independentes, nao apenas da chegada de uma linha final.

## Avaliacao dos Prototipos Existentes

O projeto `rap-bapi-staging` demonstra conceitos reutilizaveis:

- `INSERT ... FROM TABLE` para staging;
- workers recebem somente `RunUuid` e range;
- leitura indexada por run e sequencia;
- commit ou rollback por documento.

Ele nao deve ser promovido diretamente para a arquitetura final porque:

- ainda recebe o payload completo por POST;
- ainda desserializa todo o JSON antes do staging;
- usa modelo name/value generico, que aumenta linhas, conversoes e custo de reconstrucao;
- dispara workers diretamente do dispatcher da requisicao;
- nao possui estado completo por documento na tabela de staging mostrada;
- excecoes de worker podem ser capturadas sem persistencia de erro;
- o range numerico nao substitui claim atomico, lease e recuperacao por objeto.

Para alto volume, preferir tabelas tipadas por contrato de objeto. O framework e generico no controle, mas os dados e adapters permanecem tipados.

## Arquitetura Recomendada

### Ingestao

- Replicacao bulk para tabelas Z dedicadas no SAP.
- Nenhuma escrita direta em tabelas standard SAP.
- Estruturas tipadas e versionadas por objeto.
- Indices orientados a `MANDT`, `RUN_ID`, `PACKAGE_ID`, `SOURCE_OBJECT_ID`, status e chaves parentais.
- Manifest publicado somente depois da carga completa.

O mecanismo exato de escrita no SAP/HANA precisa ser aprovado por Basis e pelo fornecedor. Escrita direta em tabelas de aplicacao fora de um mecanismo suportado pode contornar validacoes, client handling, buffering e governanca. O destino deve ser exclusivamente staging customizado e suportado.

### Dispatch

- Job/evento duravel identifica packages `READY`.
- Dispatcher aplica limites globais e por tipo de objeto.
- Objetos sao reclamados atomicamente com owner, lease e attempt.
- Worker recebe apenas identificadores persistidos.
- Lease expirado volta para reconciliacao antes de retry.

### Execucao

- Worker le o objeto completo por chave.
- Adapter tipado valida e monta a BAPI/API.
- Idempotencia e verificada antes da criacao.
- Commit ou rollback ocorre por objeto.
- Resultado e mensagens sao persistidos imediatamente.
- Erro tecnico nunca e descartado silenciosamente.

### Controle

RAP OData V4 e adequado para:

- metadata e contratos;
- ativacao de run/package;
- status agregado e por objeto;
- consulta de mensagens;
- pause/resume;
- retry seletivo;
- reconciliacao.

RAP nao deve ser usado para enviar o milhao de documentos nem para aguardar o processamento.

## Estado Minimo Persistente

### Package

`LOADING -> VALIDATING -> READY -> PROCESSING -> COMPLETED | COMPLETED_WITH_ERRORS | FAILED | PAUSED`

### Object

`NEW -> CLAIMED -> PROCESSING -> SUCCESS | BUSINESS_ERROR | TECHNICAL_ERROR | UNCERTAIN`

Campos operacionais minimos:

- `RUN_ID`
- `PACKAGE_ID`
- `OBJECT_TYPE`
- `CONTRACT_VERSION`
- `SOURCE_OBJECT_ID`
- `DATA_HASH`
- `STATUS`
- `ATTEMPT_NO`
- `LEASE_OWNER`
- `LEASE_UNTIL`
- `HEARTBEAT_TS`
- `SAP_OBJECT_KEY`
- `STARTED_TS`
- `COMPLETED_TS`

## Provas Necessarias Antes da Implementacao Completa

1. Replicar volume representativo para tabelas Z e medir rows/s, log volume e impacto no HANA.
2. Interromper a replicacao em cada etapa e provar que nenhum package parcial chega a `READY`.
3. Derrubar um worker antes da BAPI, depois da BAPI e depois do commit.
4. Provar claim atomico com varios workers concorrendo pelo mesmo objeto.
5. Medir BAPI throughput por complexidade de objeto, nao apenas por quantidade.
6. Encontrar o primeiro recurso saturado ao aumentar workers.
7. Pausar o dispatcher sob carga e provar retomada sem perda ou duplicidade.
8. Reconciliar origem, staging, fila, resultados e documentos SAP.

## Decisao Arquitetural

Para o volume proposto, adotar a imagem revisada em `flow-staging.mmd` como arquitetura alvo:

- replicacao direta para staging SAP como plano de dados;
- RAP/HTTP apenas como plano de controle;
- dispatcher persistente separado da request;
- workers com concorrencia limitada;
- transacao, idempotencia e resultado por objeto;
- publicacao atomica de packages completos;
- backpressure, reconciliacao e expurgo como capacidades obrigatorias.
