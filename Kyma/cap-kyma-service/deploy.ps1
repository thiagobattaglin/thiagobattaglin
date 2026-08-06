# ============================================================
# Script de Deploy - CAP Microservice para SAP BTP Kyma
# ============================================================
# Uso: .\deploy.ps1 -Registry <seu-registry>
# Exemplo: .\deploy.ps1 -Registry "meuregistry.azurecr.io"
# ============================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$Registry,

    [string]$ImageName = "cap-processamento",
    [string]$ImageTag = "latest",
    [string]$Namespace = "cap-service",
    [string]$KubeconfigPath = "..\kubeconfig.yaml"
)

$ErrorActionPreference = "Stop"
$FullImage = "$Registry/${ImageName}:${ImageTag}"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Deploy CAP Microservice para SAP BTP Kyma" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 1. Verificar pré-requisitos
Write-Host "[1/5] Verificando pré-requisitos..." -ForegroundColor Yellow
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error "Docker não encontrado. Instale o Docker Desktop."
    exit 1
}
if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
    Write-Error "kubectl não encontrado. Instale: https://kubernetes.io/docs/tasks/tools/"
    exit 1
}

# 2. Build da imagem Docker
Write-Host "[2/5] Construindo imagem Docker: $FullImage ..." -ForegroundColor Yellow
docker build -t $FullImage .
if ($LASTEXITCODE -ne 0) { Write-Error "Falha no build da imagem Docker"; exit 1 }

# 3. Push da imagem para o registry
Write-Host "[3/5] Enviando imagem para registry..." -ForegroundColor Yellow
docker push $FullImage
if ($LASTEXITCODE -ne 0) { Write-Error "Falha no push da imagem. Verifique autenticação no registry."; exit 1 }

# 4. Configurar kubectl com kubeconfig do Kyma
Write-Host "[4/5] Configurando kubectl com kubeconfig Kyma..." -ForegroundColor Yellow
$env:KUBECONFIG = (Resolve-Path $KubeconfigPath).Path
Write-Host "  KUBECONFIG = $env:KUBECONFIG"

# Verificar conexão com o cluster
Write-Host "  Testando conexão com o cluster Kyma..."
kubectl cluster-info
if ($LASTEXITCODE -ne 0) { 
    Write-Error "Falha na conexão com o cluster Kyma. Verifique o kubeconfig e faça login OIDC."
    exit 1 
}

# 5. Aplicar manifests Kubernetes
Write-Host "[5/5] Aplicando manifests no Kyma..." -ForegroundColor Yellow

# Criar namespace
kubectl apply -f k8s/namespace.yaml
if ($LASTEXITCODE -ne 0) { Write-Error "Falha ao criar namespace"; exit 1 }

# Atualizar imagem no deployment
Write-Host "  Atualizando imagem no deployment para: $FullImage"
(Get-Content k8s/deployment.yaml) -replace 'image: .*', "image: $FullImage" | Set-Content k8s/deployment.yaml

# Aplicar deployment, service e api-rule
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/api-rule.yaml

# Aguardar deployment ficar pronto
Write-Host "  Aguardando deployment ficar pronto..." -ForegroundColor Yellow
kubectl rollout status deployment/cap-processamento -n $Namespace --timeout=120s

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host " Deploy concluído com sucesso!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

# Mostrar URL da API
Write-Host "Verificando URL da APIRule..." -ForegroundColor Yellow
kubectl get apirule cap-processamento -n $Namespace -o jsonpath='{.status.APIRuleStatus.virtualService.host}'
Write-Host ""
Write-Host ""
Write-Host "Para testar o serviço, use:" -ForegroundColor Cyan
Write-Host '  curl -X POST https://<HOST>/odata/v4/processamento/processar -H "Content-Type: application/json" -d "{\"codigo\": 12345}"'
Write-Host ""
