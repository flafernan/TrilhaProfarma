# Runbook de Autonomia - Operações e Troubleshooting em AKS/ACR
Este documento compila 10 cenários práticos de administração, diagnóstico e resolução de problemas em ambientes Kubernetes (AKS) e Azure Container Registry (ACR).

---

## Cenário 1: Erros de Sintaxe e Quebra de Linha no Windows (PowerShell)
* **Problema:** Comandos longos copiados do Linux utilizando barras invertidas (`\`) falham no PowerShell com erros de "Expressão ausente" ou "Token inesperado".
* **Solução:** Remover as barras invertidas e consolidar o comando em uma única linha contínua, ou substituir as barras por backticks (`` ` ``) se precisar quebrar linhas no PowerShell.
* **Comando:**
    ```powershell
    az aks create --resource-group rg-autonomia-particular --name aks-autonomia-particular --node-count 1 --generate-ssh-keys --attach-acr acrautonomia99
    ```

## Cenário 2: Erro de Caminho Não Encontrado no kubectl (Contexto Local)
* **Problema:** O comando `kubectl apply -f pasta/` retorna erro informando que o caminho não existe, mesmo a pasta estando visível na árvore de arquivos.
* **Solução:** O PowerShell exige caminhos explícitos usando a sintaxe do Windows (`.\pasta\`) ou navegação relativa direta (`../pasta/`) caso o terminal esteja posicionado em um subdiretório.
* **Comando:**
    ```powershell
    kubectl apply -f ../k8s-autonomia/
    ```

## Cenário 3: Build de Imagens Sem Docker Desktop Local
* **Problema:** Necessidade de buildar e registrar imagens Docker em uma máquina sem o Docker Daemon instalado localmente.
* **Solução:** Utilizar o recurso de compilação remota do Azure Container Registry (`az acr build`), que envia o contexto para a nuvem, compila e armazena a imagem diretamente no registro.
* **Comando:**
    ```powershell
    az acr build --image api-node:latest --registry acrautonomia99 .
    ```

## Cenário 4: Ingress Sem IP Público Vinculado (<pending>)
* **Problema:** O recurso de Ingress é aplicado, mas a coluna `EXTERNAL-IP` permanece vazia ou indefinida indefinidamente.
* **Solução:** Instalar um Ingress Controller (como o Nginx Ingress via Helm) para que o Kubernetes possa solicitar e gerenciar um Load Balancer público na infraestrutura da Azure.
* **Comando:**
    ```powershell
    helm install ingress-nginx ingress-nginx/ingress-nginx --create-namespace --namespace ingress-basic
    ```

## Cenário 5: Investigação de Falhas de Inicialização do Pod (CrashLoopBackOff)
* **Problema:** O Pod é criado, mas falha continuamente e entra em estado de erro antes de ficar `Ready`.
* **Solução:** Verificar os logs internos da aplicação rodando no container para capturar exceções de código ou variáveis ausentes.
* **Comando:**
    ```powershell
    kubectl logs <nome-do-pod>
    ```

## Cenário 6: Diagnóstico de Falhas de Probes (Liveness/Readiness)
* **Problema:** O container inicia, mas o status do Pod não muda para `1/1 READY` e sofre reinicializações constantes devido a falhas nas rotas de teste.
* **Solução:** Inspecionar os eventos detalhados do Pod para identificar erros HTTP nas checagens de saúde (`/health`).
* **Comando:**
    ```powershell
    kubectl describe pod <nome-do-pod>
    ```

## Cenário 7: Erro de Autenticação no Pull da Imagem (ImagePullBackOff)
* **Problema:** O AKS não consegue baixar a imagem do container hospedada no ACR por falta de permissões de leitura.
* **Solução:** Vincular explicitamente a identidade do cluster AKS ao registro ACR usando a flag de anexação da CLI do Azure.
* **Comando:**
    ```powershell
    az aks update --resource-group rg-autonomia-particular --name aks-autonomia-particular --attach-acr acrautonomia99
    ```

## Cenário 8: Atualização de Variáveis de Configuração Sem Restart Manual
* **Problema:** Modificações realizadas em um `ConfigMap` não são refletidas imediatamente na aplicação dentro do container.
* **Solução:** Forçar um restart controlado dos pods associados para que eles leiam o novo estado do ConfigMap ao iniciarem.
* **Comando:**
    ```powershell
    kubectl rollout restart deployment/api-node-deployment
    ```

## Cenário 9: Conflito de Nomes Globais no Registro de Containers (ACR)
* **Problema:** Falha ao tentar criar um recurso ACR devido ao nome escolhido já estar em uso por outra corporação na Azure.
* **Solução:** Adotar uma nomenclatura padronizada com sufixos numéricos aleatórios ou identificadores de projeto exclusivos para garantir a unicidade global.
* **Comando:**
    ```powershell
    az acr create --resource-group rg-autonomia-particular --name acrautonomia99 --sku Basic
    ```

## Cenário 10: Rastreamento de Tráfego HTTP e Validação do Ingress
* **Problema:** Necessidade de validar se as requisições estão alcançando o controller e sendo distribuídas corretamente para o serviço interno.
* **Solução:** Monitorar o fluxo de requisições em tempo real inspecionando os logs de acesso gerados pelo container do controlador Nginx.
* **Comando:**
    ```powershell
    kubectl logs -n ingress-basic -l app.kubernetes.io/name=ingress-nginx --tail=50
    ```