$kubeconfig = "$PSScriptRoot\kubeconfig.yaml"

Write-Host "=== Criando Redis Instance no Kyma ===" -ForegroundColor Cyan

# Criar ServiceInstance + ServiceBinding
kubectl --kubeconfig $kubeconfig apply -f "$PSScriptRoot\redis-instance.yaml"

Write-Host "`n=== Aguardando provisionamento... ===" -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Verificar status
Write-Host "`n=== Status da ServiceInstance ===" -ForegroundColor Cyan
kubectl --kubeconfig $kubeconfig get serviceinstance redis-instance -n default -o wide

Write-Host "`n=== Status do ServiceBinding ===" -ForegroundColor Cyan
kubectl --kubeconfig $kubeconfig get servicebinding redis-binding -n default -o wide

Write-Host "`n=== Para verificar credenciais (apos Ready): ===" -ForegroundColor Green
Write-Host "kubectl --kubeconfig $kubeconfig get secret redis-credentials -n default -o jsonpath='{.data}'"
