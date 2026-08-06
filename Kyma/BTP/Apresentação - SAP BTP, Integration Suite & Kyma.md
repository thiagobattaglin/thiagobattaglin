# 🧭 SAP BTP, Integration Suite & Kyma
## Guia para Desenvolvedores Non-SAP

---

# 📑 Agenda

1. O que é SAP BTP?
2. Estrutura Organizacional do BTP
3. Pilares do BTP
4. SAP Integration Suite — Componentes
5. SAP Integration Suite — Fluxo de Integração
6. SAP BTP Kyma Runtime — Arquitetura
7. SAP BTP Kyma Runtime — Fluxo Prático
8. Kyma vs Cloud Foundry
9. Como Tudo se Conecta — Big Picture
10. Resumo & Referências

---

# 1. O que é SAP BTP?

**SAP BTP (Business Technology Platform)** é o **PaaS (Platform as a Service)** da SAP — pense nele como o **"AWS/Azure/GCP" da SAP**.

Ele reúne tudo o que você precisa para **desenvolver, integrar, automatizar e analisar dados** no ecossistema SAP (e fora dele também).

### 🔑 Analogia

> Se o **SAP S/4HANA** (ERP) fosse um **prédio comercial**, o **SAP BTP** seria o **terreno + infraestrutura** (estradas, energia, água, internet) ao redor dele, permitindo construir **anexos, estacionamentos e lojas** sem tocar no prédio principal.

### 🧹 Conceito-Chave: "Clean Core"

A SAP incentiva a **NÃO modificar o ERP diretamente**. Em vez disso, use o BTP para criar **extensões side-by-side**:

| Abordagem | Analogia |
|-----------|----------|
| ❌ Modificar o ERP | Fazer **fork** de uma library e manter manualmente |
| ✅ Extensão via BTP | Criar um **plugin/extensão** que consome a API da library |

---

# 2. Estrutura Organizacional do BTP

```mermaid
graph TD
    GA["🏢 <b>Global Account</b><br/>(Company Account)"]

    GA --> DIR_PRD["📁 <b>Directory: Production</b>"]
    GA --> DIR_DEV["📁 <b>Directory: Development</b>"]

    DIR_PRD --> SUB_BR["📦 Subaccount<br/><b>Brazil - PRD</b><br/>region: us-east"]
    DIR_PRD --> SUB_EU["📦 Subaccount<br/><b>Europe - PRD</b><br/>region: eu-central"]

    DIR_DEV --> SUB_ALPHA["📦 Subaccount<br/><b>Team Alpha - DEV</b>"]
    DIR_DEV --> SUB_BETA["📦 Subaccount<br/><b>Team Beta - QA</b>"]

    style GA fill:#1a73e8,stroke:#0d47a1,color:#fff,rx:10
    style DIR_PRD fill:#c62828,stroke:#b71c1c,color:#fff,rx:8
    style DIR_DEV fill:#2e7d32,stroke:#1b5e20,color:#fff,rx:8
    style SUB_BR fill:#ffcdd2,stroke:#c62828,color:#000,rx:6
    style SUB_EU fill:#ffcdd2,stroke:#c62828,color:#000,rx:6
    style SUB_ALPHA fill:#c8e6c9,stroke:#2e7d32,color:#000,rx:6
    style SUB_BETA fill:#c8e6c9,stroke:#2e7d32,color:#000,rx:6
```

### Equivalência com o Mundo Non-SAP

| SAP BTP | Equivalente AWS |
|---------|-----------------|
| **Global Account** | AWS Organization |
| **Directory** | OU (Organizational Unit) |
| **Subaccount** | AWS Account individual |

---

# 3. Pilares do SAP BTP

```mermaid
graph TB
    subgraph BTP["☁️ SAP BTP (PaaS)"]
        direction TB

        subgraph Pillars[" "]
            direction LR
            DB["🗄️ <b>Database &<br/>Data Management</b><br/><br/>• HANA Cloud<br/>• DataSphere<br/>• Data Intelligence"]
            APP["⚙️ <b>App Dev &<br/>Integration</b><br/><br/>• Integration Suite<br/>• Kyma<br/>• Cloud Foundry"]
            AN["📊 <b>Analytics</b><br/><br/>• SAP Analytics<br/>  Cloud"]
            AI["🤖 <b>AI / ML</b><br/><br/>• AI Core<br/>• RPA<br/>• GenAI"]
        end

        subgraph Runtime["Runtimes"]
            direction LR
            CF["Cloud Foundry"]
            KY["Kyma (Kubernetes)"]
            AB["ABAP Environment"]
        end

        subgraph Infra["Infrastructure"]
            direction LR
            AWS["AWS"]
            AZ["Azure"]
            GCP["GCP"]
            ALI["Alibaba Cloud"]
        end
    end

    style BTP fill:#0a1628,stroke:#1a73e8,color:#fff,rx:10
    style Pillars fill:none,stroke:none
    style Runtime fill:none,stroke:none
    style Infra fill:none,stroke:none
    style DB fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style APP fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style AN fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style AI fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style CF fill:#fff3e0,stroke:#e65100,color:#000,rx:6
    style KY fill:#fff3e0,stroke:#e65100,color:#000,rx:6
    style AB fill:#fff3e0,stroke:#e65100,color:#000,rx:6
    style AWS fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:6
    style AZ fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:6
    style GCP fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:6
    style ALI fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:6
```

### 4 Pilares

| Pilar | O que faz | Destaques |
|-------|-----------|-----------|
| 🗄️ **Database & Data Mgmt** | Armazenamento e gestão de dados | HANA Cloud, DataSphere, Data Intelligence |
| ⚙️ **App Dev & Integration** | Desenvolvimento e integração de apps | Integration Suite, Kyma, Cloud Foundry |
| 📊 **Analytics** | Análise de dados e BI | SAP Analytics Cloud |
| 🤖 **AI / ML** | Inteligência artificial e automação | AI Core, RPA, GenAI |

---

# 4. SAP Integration Suite — Componentes

### 🔑 Analogia

> Se seus sistemas fossem **ilhas**, a Integration Suite seria a **rede de pontes, balsas e cabos submarinos** conectando todos eles.

É o **iPaaS (Integration Platform as a Service)** da SAP — equivalente a **Apache Kafka + MuleSoft + Kong API Gateway** — tudo em um.

```mermaid
graph TB
    subgraph IS["🔗 SAP Integration Suite"]
        direction TB

        subgraph Row1[" "]
            direction LR
            CI["☁️ <b>Cloud Integration</b><br/><br/>• Integration flows<br/>• Data mapping<br/>• 160+ adapters"]
            API["🔌 <b>API Management</b><br/><br/>• Publish APIs<br/>• Rate limiting<br/>• Monitoring<br/>• API Portal"]
            EM["📨 <b>Event Mesh</b><br/><br/>• Async Pub/Sub<br/>• SAP events<br/>• Decoupling"]
        end

        subgraph Row2[" "]
            direction LR
            OC["🔗 <b>Open Connectors</b><br/><br/>• Salesforce<br/>• Slack, Jira<br/>• 160+ SaaS"]
            IA["🤖 <b>Integration Advisor</b><br/><br/>• AI suggests mappings<br/>• B2B templates"]
            EIC["🏢 <b>Edge Integration Cell</b><br/><br/>• Runs on-prem<br/>• Managed from cloud"]
        end
    end

    style IS fill:#1a73e8,stroke:#0d47a1,color:#fff,rx:10
    style Row1 fill:none,stroke:none
    style Row2 fill:none,stroke:none
    style CI fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style API fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style EM fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style OC fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:8
    style IA fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:8
    style EIC fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:8
```

### Mapeamento para o Mundo Non-SAP

| SAP Integration Suite | Equivalente Non-SAP |
|-----------------------|---------------------|
| Cloud Integration | Apache Camel / MuleSoft / n8n |
| API Management | Kong / Apigee / AWS API Gateway |
| Event Mesh | Apache Kafka / RabbitMQ / AWS SNS+SQS |
| Open Connectors | Zapier / Workato (conectores prontos) |
| Integration Advisor | IA que sugere mapeamentos de dados |
| Edge Integration Cell | Agente on-prem gerenciado (tipo Azure Arc) |

---

# 5. SAP Integration Suite — Fluxo de Integração

```mermaid
graph LR
    ERP["🏭 <b>SAP S/4HANA</b><br/>(ERP)"]
    MOB["📱 <b>Mobile App</b>"]
    KYMA["⚙️ <b>Microservices</b><br/>(Kyma)"]

    subgraph IS["🔗 SAP Integration Suite"]
        direction TB
        CInt["☁️ Cloud Integration<br/><i>transforms, routes, maps</i>"]
        APIMgmt["🔌 API Management<br/><i>gateway</i>"]
        EvMesh["📨 Event Mesh<br/><i>pub/sub</i>"]
    end

    SF["💼 <b>Salesforce</b><br/>(CRM)"]
    PART["🤝 <b>Partners</b><br/>(EDI / B2B)"]
    IOT["📡 <b>IoT / Edge</b><br/>Devices"]

    ERP <-->|OData / REST| CInt
    CInt <-->|API| SF

    MOB <-->|HTTPS| APIMgmt
    APIMgmt <-->|EDI| PART

    EvMesh -->|events| KYMA
    EvMesh <-->|telemetry| IOT

    style IS fill:#1a73e8,stroke:#0d47a1,color:#fff,rx:10
    style CInt fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style APIMgmt fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style EvMesh fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style ERP fill:#fff3e0,stroke:#e65100,color:#000,rx:8
    style MOB fill:#f3e5f5,stroke:#6a1b9a,color:#000,rx:8
    style KYMA fill:#f3e5f5,stroke:#6a1b9a,color:#000,rx:8
    style SF fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:8
    style PART fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:8
    style IOT fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:8
```

### Como funciona:

| Componente | Papel no Fluxo | Protocolo |
|------------|----------------|-----------|
| **Cloud Integration** | Transforma, roteia e mapeia dados entre SAP e Salesforce | OData / REST / API |
| **API Management** | Gateway para apps mobile e parceiros B2B | HTTPS / EDI |
| **Event Mesh** | Pub/Sub assíncrono para microserviços e IoT | Eventos / Telemetria |

---

# 6. SAP BTP Kyma Runtime — Arquitetura

### 🔑 Analogia

> Se **Kubernetes** fosse um **terreno vazio com infraestrutura**, **Kyma** seria um **parque industrial pronto** — já tem portaria (API Gateway), sistema de alarme (observabilidade), correio (eventing) e conexão direta com a "fábrica SAP" ao lado.

**Kyma = Kubernetes gerenciado pela SAP**, equivalente ao **EKS/AKS/GKE**, mas com "baterias incluídas" para o ecossistema SAP.

```mermaid
graph TB
    subgraph KYMA["⚙️ SAP BTP Kyma Runtime (Managed Kubernetes)"]
        direction TB

        subgraph Workloads["Your Workloads"]
            direction LR
            MS1["🟦 Microservice<br/><b>Node.js</b>"]
            MS2["🟩 Microservice<br/><b>Go / Java</b>"]
            FN["⚡ Serverless<br/><b>Function</b><br/>(FaaS)"]
        end

        subgraph Components["Kyma Components (pre-installed)"]
            direction LR
            GW["🚪 API Gateway<br/>(Istio)"]
            EV["📨 Eventing<br/>(NATS /<br/>Event Mesh)"]
            SC["📋 Service<br/>Catalog<br/>(BTP Services)"]
            OB["📊 Observability<br/>(Logging,<br/>Tracing)"]
        end

        subgraph Services["SAP BTP Services"]
            direction LR
            HANA["🗄️ HANA Cloud"]
            XSUAA["🔐 XSUAA (Auth)"]
            DEST["🔗 Destination"]
            CONN["📡 Connectivity"]
        end
    end

    MS1 & MS2 & FN --> GW & EV & SC & OB
    GW & EV & SC & OB --> HANA & XSUAA & DEST & CONN

    S4["🏭 <b>SAP S/4HANA</b><br/>(OData / REST APIs)<br/>or other ERPs"]

    CONN --> S4

    style KYMA fill:#0a1628,stroke:#1a73e8,color:#fff,rx:10
    style Workloads fill:#1a237e,stroke:#3949ab,color:#fff,rx:8
    style Components fill:#1b5e20,stroke:#388e3c,color:#fff,rx:8
    style Services fill:#4a148c,stroke:#7b1fa2,color:#fff,rx:8
    style MS1 fill:#e3f2fd,stroke:#1565c0,color:#000,rx:6
    style MS2 fill:#e3f2fd,stroke:#1565c0,color:#000,rx:6
    style FN fill:#e3f2fd,stroke:#1565c0,color:#000,rx:6
    style GW fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:6
    style EV fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:6
    style SC fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:6
    style OB fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:6
    style HANA fill:#f3e5f5,stroke:#6a1b9a,color:#000,rx:6
    style XSUAA fill:#f3e5f5,stroke:#6a1b9a,color:#000,rx:6
    style DEST fill:#f3e5f5,stroke:#6a1b9a,color:#000,rx:6
    style CONN fill:#f3e5f5,stroke:#6a1b9a,color:#000,rx:6
    style S4 fill:#fff3e0,stroke:#e65100,color:#000,rx:8
```

### Camadas da Arquitetura

| Camada | Componentes | Função |
|--------|-------------|--------|
| **Your Workloads** | Microservices (Node.js, Go, Java), Serverless Functions | Seu código de negócio |
| **Kyma Components** | API Gateway (Istio), Eventing (NATS), Service Catalog, Observability | Infraestrutura pré-instalada |
| **BTP Services** | HANA Cloud, XSUAA, Destination, Connectivity | Serviços gerenciados da plataforma |
| **SAP S/4HANA** | OData / REST APIs | ERP e sistemas backend |

---

# 7. SAP BTP Kyma Runtime — Fluxo Prático

```mermaid
graph TD
    P1["1️⃣ <b>PROVISION</b><br/>BTP Cockpit → Create Kyma Environment<br/>SAP creates the K8s cluster"]
    P2["2️⃣ <b>DEVELOP</b><br/>Write code<br/>(Node.js, Go, Python, Java)"]
    P3["3️⃣ <b>CONTAINERIZE</b><br/>docker build & push"]
    P4["4️⃣ <b>DEPLOY</b><br/>kubectl apply -f deployment.yaml<br/>or CI/CD (GitHub Actions, Jenkins)"]

    P1 --> P2 --> P3 --> P4

    P4 --> P5

    subgraph P5["5️⃣ CONNECT TO SAP"]
        direction LR
        S4["🏭 <b>S/4HANA</b>"]
        EVT["📨 event:<br/><i>Order Created</i>"]
        FN["⚡ <b>Your Function in Kyma</b><br/><br/>→ Send email<br/>→ Update DB<br/>→ Call API"]
        S4 -->|emits| EVT -->|triggers| FN
    end

    P5 --> P6["6️⃣ <b>EXPOSE APIs</b><br/>API Gateway + Auth (Istio)"]
    P6 --> P7["7️⃣ <b>MONITOR</b><br/>Built-in dashboards:<br/>logs, metrics, traces"]

    style P1 fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style P2 fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style P3 fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style P4 fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style P5 fill:#fff3e0,stroke:#e65100,color:#000,rx:8
    style P6 fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:8
    style P7 fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:8
    style S4 fill:#ffcdd2,stroke:#c62828,color:#000,rx:6
    style EVT fill:#fff9c4,stroke:#f9a825,color:#000,rx:6
    style FN fill:#c8e6c9,stroke:#2e7d32,color:#000,rx:6
```

### Passo a Passo Detalhado

| Etapa | Ação | Ferramenta / Comando |
|-------|------|----------------------|
| 1️⃣ **Provision** | Criar ambiente Kyma | BTP Cockpit |
| 2️⃣ **Develop** | Escrever código em qualquer linguagem | VS Code, IntelliJ, etc. |
| 3️⃣ **Containerize** | Empacotar em containers Docker | `docker build` / `docker push` |
| 4️⃣ **Deploy** | Aplicar no cluster K8s | `kubectl apply -f` / CI/CD |
| 5️⃣ **Connect** | Receber eventos do SAP automaticamente | Kyma Eventing |
| 6️⃣ **Expose** | Expor APIs com autenticação | API Gateway (Istio) |
| 7️⃣ **Monitor** | Dashboards de logs, métricas e traces | Observability nativa |

---

# 8. Kyma vs Cloud Foundry

Os dois **runtimes** do SAP BTP lado a lado:

| Característica | ⚙️ Kyma | ☁️ Cloud Foundry |
|---------------|---------|-------------------|
| **Base** | Kubernetes | Cloud Foundry (PaaS) |
| **Controle** | Total (YAML, Helm, kubectl) | Abstraído (`cf push`) |
| **Curva de aprendizado** | Mais íngreme (requer K8s) | Mais suave (mais opinativo) |
| **Flexibilidade** | Muito alta | Média |
| **Ideal para** | Microservices, event-driven | Apps tradicionais, APIs |
| **Analogia** | EKS / AKS / GKE | Heroku / Railway |

### Quando usar qual?

```text
Kyma  → Você quer controle total, já conhece Kubernetes,
         precisa de event-driven architecture ou microservices complexos.

Cloud Foundry → Você quer simplicidade, deploy rápido com `cf push`,
                 ideal para apps tradicionais e APIs REST simples.
```

---

# 9. Como Tudo se Conecta — Big Picture

```mermaid
graph TB
    subgraph BTP["☁️ SAP BTP (PaaS)"]
        direction TB

        subgraph Runtimes[" "]
            direction LR
            KYMA["⚙️ <b>Kyma</b><br/>(K8s Runtime)<br/><br/>Microservices<br/>Functions<br/>Containers"]
            IS["🔗 <b>Integration Suite</b><br/>(iPaaS)<br/><br/>Cloud Integration<br/>API Management<br/>Event Mesh"]
        end

        KYMA <-->|events & APIs| IS

        subgraph SvcLayer["BTP Services Layer"]
            direction LR
            HANA["🗄️ HANA Cloud"]
            AUTH["🔐 XSUAA"]
            DEST["🔗 Destination"]
            MORE["⋯"]
        end

        KYMA & IS --> SvcLayer
    end

    S4["🏭 <b>SAP S/4HANA</b><br/>(on-prem or cloud)"]
    EXT["💼 <b>Salesforce</b><br/>ServiceNow<br/>Slack, etc."]
    APP["📱 <b>Your App</b><br/>(React, Mobile)"]

    SvcLayer --> S4
    SvcLayer --> EXT
    SvcLayer --> APP

    style BTP fill:#0a1628,stroke:#1a73e8,color:#fff,rx:10
    style Runtimes fill:none,stroke:none
    style SvcLayer fill:#1a237e,stroke:#3949ab,color:#fff,rx:8
    style KYMA fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style IS fill:#e3f2fd,stroke:#1565c0,color:#000,rx:8
    style HANA fill:#f3e5f5,stroke:#6a1b9a,color:#000,rx:6
    style AUTH fill:#f3e5f5,stroke:#6a1b9a,color:#000,rx:6
    style DEST fill:#f3e5f5,stroke:#6a1b9a,color:#000,rx:6
    style MORE fill:#f3e5f5,stroke:#6a1b9a,color:#000,rx:6
    style S4 fill:#fff3e0,stroke:#e65100,color:#000,rx:8
    style EXT fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:8
    style APP fill:#e8f5e9,stroke:#2e7d32,color:#000,rx:8
```

### Resumo da Conexão

| De | Para | Via |
|----|------|-----|
| **Kyma** (microservices) | **Integration Suite** | Eventos & APIs |
| **Integration Suite** | **SAP S/4HANA** | OData / REST / RFC |
| **Integration Suite** | **Salesforce, Slack, etc.** | Open Connectors / APIs |
| **BTP Services** | **Todos os componentes** | Service Catalog / Bindings |

---

# 10. Resumo em Uma Linha

| Componente | Uma frase |
|------------|-----------|
| **SAP BTP** | PaaS multi-cloud da SAP — o "terreno" onde se constrói, integra e analisa tudo. |
| **Integration Suite** | iPaaS que conecta SAP e non-SAP via APIs, eventos e flows — o "correio + pontes" entre sistemas. |
| **Kyma** | Kubernetes gerenciado com "baterias SAP" — onde se roda microservices e funções serverless. |

---

# 🔗 Referências Úteis

| Recurso | Link |
|---------|------|
| SAP BTP Overview 2025 | [PDF Oficial](https://assets.dm.ux.sap.com/sap-user-groups/pdfs/250218_sap_business_technoloy_platform_2025_overview.pdf) |
| SAP BTP Explained | [developers.dev](https://www.developers.dev/tech-talk/sap-btp-explained-the-backbone-of-a-modern-enterprise.html) |
| Guia Completo SAP BTP | [sapa2z.com](https://sapa2z.com/comprehensive-guide-to-sap-btp/) |
| Arquitetura SAP BTP | [kaartech.com](https://www.kaartech.com/blogs/sap-btp-architecture/) |
| SAP Integration Suite | [sap.com](https://www.sap.com/products/integration-suite.html) |
| Help Portal | [help.sap.com](https://help.sap.com/docs/integration-suite) |

---

> *Apresentação gerada a partir do guia SAP BTP, Integration Suite & Kyma para desenvolvedores non-SAP.*
