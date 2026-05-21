## Troubleshoot rápido (Kubernetes)

| Cenário | Sintoma (Status / Erro) | Comando de Diagnóstico | Resolução Prática |
| :--- | :--- | :--- | :--- |
| **1. CrashLoopBackOff** | O container inicia, mas morre continuamente com erro no processo interno. | `kubectl logs <nome-do-pod>` | Corrigir o script/binário interno ou o parâmetro `command`/`args` no YAML. |
| **2. ImagePullBackOff** | O pod não sobe porque a imagem ou a tag informada não foi encontrada no registro. | `kubectl describe pod <nome-do-pod>` | Ajustar o nome do repositório ou corrigir a tag para uma versão existente no YAML. |
| **3. CreateContainerConfigError** | O container trava antes de nascer por dependência de recurso externo de configuração. | `kubectl describe pod <nome-do-pod>` | Criar o `ConfigMap` ou a `Secret` com o nome exato esperado pela aplicação. |
| **4. CreateContainerError** | A imagem é baixada, mas o runtime (containerd/Docker) falha ao tentar disparar o binário. | `kubectl describe pod <nome-do-pod>` | Remover comandos customizados inválidos ou ajustar as permissões de execução da imagem. |
| **5. OOMKilled (Exit 137)** | O container é assassinado pelo kernel do nó por estourar o limite rígido de memória RAM. | `kubectl describe pod <nome-do-pod>` | Executar o *Right-Sizing*, aumentando os valores de `limits.memory` no manifesto. |
| **6. InvalidImageName** | O pod falha imediatamente na API por violação de regras de escrita no nome da imagem. | `kubectl describe pod <nome-do-pod>` | Corrigir a ortografia da imagem, removendo caracteres especiais proibidos e letras maiúsculas. |