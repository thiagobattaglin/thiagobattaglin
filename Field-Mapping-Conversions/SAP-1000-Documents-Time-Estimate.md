# Estimativa de Tempo - Carga de 1.000 Documentos por Processo

## Escopo

Estimativa de tempo para criação de **1.000 documentos** em cada processo abaixo, usando:
- **BAPIs** (integração customizada)
- **SAP S/4HANA Migration Cockpit** (LTMC / Migrate Your Data)

Processos considerados:
1. Accounts Payable
2. Accounts Receivable
3. Work Orders
4. GL
5. Sales Orders
6. Purchase Orders
7. Production Orders

---

## Premissas da Estimativa

- Ambiente estável (sem gargalo severo de CPU, DB ou lock de tabela).
- Dados já higienizados e consistentes (sem retrabalho de qualidade).
- Execução com commit padrão por documento/lote curto.
- Sem paralelismo extremo (execução operacional típica de projeto).
- Campos obrigatórios mapeados conforme o documento base de mandatory fields.

> Importante: os tempos abaixo representam **tempo de processamento técnico** da carga.
> Não incluem tempo de desenvolvimento, mapeamento inicial, testes UAT, aprovação funcional e correção de dados.

---

## Estimativa por Processo (1.000 documentos)

| Processo | BAPI (faixa) | Migration Cockpit (faixa) | Observação de Complexidade |
|---|---:|---:|---|
| Accounts Payable | 10 a 20 min | 33 a 83 min | FI com validações fiscais e vencimento |
| Accounts Receivable | 10 a 20 min | 33 a 83 min | Similar AP com regras de cobrança/parceiro |
| Work Orders (PM/CS) | 25 a 67 min | 67 a 167 min | Ordem + operações + possíveis componentes |
| GL | 7 a 17 min | 25 a 67 min | Alto volume, estrutura simples e balanceamento |
| Sales Orders | 20 a 50 min | 50 a 133 min | Parceiros, itens, schedule lines, pricing |
| Purchase Orders | 25 a 58 min | 67 a 150 min | Itens, schedule, account assignment |
| Production Orders | 33 a 83 min | 100 a 200 min | BOM/routing e regras de planejamento |

---

## Resumo Consolidado (7.000 documentos no total)

Cenário: 1.000 documentos para cada um dos 7 processos.

- **Via BAPI (somatório):** aproximadamente **2h10min a 5h15min**
- **Via Migration Cockpit (somatório):** aproximadamente **6h15min a 14h43min**

---

## Recomendação de Planejamento (Projeto)

Para planejamento realista, considerar três camadas:

1. **Tempo técnico de carga** (tabela acima)
2. **Overhead operacional por onda** (monitoria, reprocesso, validação): +20% a +40%
3. **Buffer de risco** (locks, timeout, ajustes de customizing): +15% a +30%

Regra prática:
- **BAPI:** multiplicar por **1,4 a 1,7** para estimativa de janela de execução real.
- **Migration Cockpit:** multiplicar por **1,5 a 1,8** para estimativa de janela de execução real.

---

## Janela Realista de Cutover (Exemplo)

Somatório de todos os processos (7.000 docs):

- **BAPI:**
  - Base: 2h10 a 5h15
  - Com fator operacional (1,4 a 1,7): **~3h a ~9h**

- **Migration Cockpit:**
  - Base: 6h15 a 14h43
  - Com fator operacional (1,5 a 1,8): **~9h a ~26h**

---

## Fatores que Mais Impactam o Tempo

- Quantidade de erros por lote (mensagens `RETURN` tipo E/A)
- Dependências de customizing (partner determination, account assignment, tax)
- Regras de derivação em S/4 (`PRCTR`, `SEGMENT`, BP)
- Estratégia de commit e tamanho de lote
- Paralelização permitida por objeto/processo
- Performance do app server, banco e rede

---

## Próximo Passo Recomendado

Executar um **teste piloto com 100 documentos por processo** e recalibrar as taxas de throughput reais do cliente para converter esta estimativa em baseline de cutover.