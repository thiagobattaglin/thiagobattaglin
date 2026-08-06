# CAP Kyma Microservice - Processamento

Microserviço CAP simples rodando no SAP BTP Kyma Runtime que recebe um código numérico e retorna "Processado com sucesso".

## Estrutura do Projeto

```
cap-kyma-service/
├── srv/
│   ├── processamento-service.cds    # Definição do serviço CDS
│   └── processamento-service.js     # Handler (lógica de negócio)
├── k8s/
│   ├── namespace.yaml               # Namespace Kubernetes
│   ├── deployment.yaml              # Deployment do container
│   ├── service.yaml                 # Service Kubernetes
│   └── api-rule.yaml                # APIRule Kyma (exposição externa)
├── Dockerfile                       # Imagem Docker do serviço
├── deploy.ps1                       # Script de deploy automatizado
├── package.json                     # Dependências Node.js / CAP
└── .cdsrc.json                      # Configuração CDS
```

## Pré-requisitos

- **Node.js** 22+
- **Docker Desktop** instalado e rodando
- **kubectl** instalado
- **kubelogin** (plugin OIDC para kubectl)
- Acesso a um **Container Registry** (Docker Hub, ACR, GCR, etc.)
- **SAP BTP Kyma Runtime** provisionado

## Desenvolvimento Local

```bash
cd cap-kyma-service
npm install
npm run dev
```

O serviço estará disponível em: `http://localhost:4004`

### Testar localmente

```bash
# Via curl
curl -X POST http://localhost:4004/odata/v4/processamento/processar \
  -H "Content-Type: application/json" \
  -d '{"codigo": 12345}'
```

Resposta esperada:
```json
{
  "mensagem": "Processado com sucesso",
  "codigo": 12345,
  "status": "OK"
}
```

## Deploy no Kyma

### 1. Instalar kubelogin (se necessário)

```powershell
# Windows (Chocolatey)
choco install kubelogin

# Ou via Krew
kubectl krew install oidc-login
```

### 2. Deploy automatizado

```powershell
cd cap-kyma-service
.\deploy.ps1 -Registry "seu-registry.io"
```

### 3. Deploy manual passo a passo

```powershell
# Configurar kubeconfig
$env:KUBECONFIG = "c:\Codes\Kyma\kubeconfig.yaml"

# Build e push da imagem Docker
docker build -t seu-registry.io/cap-processamento:latest .
docker push seu-registry.io/cap-processamento:latest

# Atualizar a imagem no k8s/deployment.yaml

# Aplicar manifests
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/api-rule.yaml

# Verificar status
kubectl get pods -n cap-service
kubectl get apirule -n cap-service
```

### 4. Testar no Kyma

```bash
curl -X POST https://cap-processamento.<KYMA_DOMAIN>/odata/v4/processamento/processar \
  -H "Content-Type: application/json" \
  -d '{"codigo": 42}'
```

## API

### `POST /odata/v4/processamento/processar`

**Request Body:**
```json
{
  "codigo": 12345
}
```

**Response (200):**
```json
{
  "mensagem": "Processado com sucesso",
  "codigo": 12345,
  "status": "OK"
}
```

**Response (400) - código ausente:**
```json
{
  "error": {
    "message": "O campo \"codigo\" é obrigatório e deve ser um número."
  }
}
```
