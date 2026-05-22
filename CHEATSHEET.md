## Troubleshoot rápido (Kubernetes)

| Cenário | Sintoma (Status / Erro) | Comando de Diagnóstico | Resolução Prática |
| :--- | :--- | :--- | :--- |
| **1. CrashLoopBackOff** | O container inicia, mas morre continuamente com erro no processo interno. | `kubectl logs <nome-do-pod>` | Corrigir o script/binário interno ou o parâmetro `command`/`args` no YAML. |
| **2. ImagePullBackOff** | O pod não sobe porque a imagem ou a tag informada não foi encontrada no registro. | `kubectl describe pod <nome-do-pod>` | Ajustar o nome do repositório ou corrigir a tag para uma versão existente no YAML. |
| **3. CreateContainerConfigError** | O container trava antes de nascer por dependência de recurso externo de configuração. | `kubectl describe pod <nome-do-pod>` | Criar o `ConfigMap` ou a `Secret` com o nome exato esperado pela aplicação. |
| **4. CreateContainerError** | A imagem é baixada, mas o runtime (containerd/Docker) falha ao tentar disparar o binário. | `kubectl describe pod <nome-do-pod>` | Remover comandos customizados inválidos ou ajustar as permissões de execução da imagem. |
| **5. OOMKilled (Exit 137)** | O container é assassinado pelo kernel do nó por estourar o limite rígido de memória RAM. | `kubectl describe pod <nome-do-pod>` | Executar o *Right-Sizing*, aumentando os valores de `limits.memory` no manifesto. |
| **6. InvalidImageName** | O pod falha imediatamente na API por violação de regras de escrita no nome da imagem. | `kubectl describe pod <nome-do-pod>` | Corrigir a ortografia da imagem, removendo caracteres especiais proibidos e letras maiúsculas. |


# 📑 CHEATSHEET - Diagnóstico Passo a Passo (Dia 3 / Bloco 3)

## 🔍 Fluxo de Observabilidade (Golden Path)
Para isolar a causa raiz em produção de forma rápida, seguimos sempre a ordem:
1. **ALERTA / MÉTRICA** -> Identifica o sintoma (Ex: Uso de CPU > 99%, esgotamento de memória, ou o status OOMKilled/CrashLoopBackOff no Datadog).
2. **LOG** -> Isolamento do erro explícito. Busca por logs de erro do pod no momento exato do alerta.
3. **TRACE (APM)** -> Rastreamento fim a fim para isolar gargalos em processamento, banco de dados ou dependências externas.
4. **RESOLUÇÃO** -> Ajuste de recursos (K8s), otimização de código ou correção de configuração.

## 💡 Definição de Bons Alertas (Signal vs Noise)
* **Anti-padrão (Ruído):** Alertar em consumo de infraestrutura puro (Ex: CPU > 80%). Máquinas têm picos normais que geram alertas falsos.
* **Boa Prática (Actionable):** Alertar com base em SLOs reais (Ex: Latência p95 > 2s por 5 min consecutivos ou Taxa de Erros 5xx > 1%).