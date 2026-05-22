# Perguntas para o Engenheiro Sênior - Arquitetura e Produção (Dia 3)

Com base no ambiente isolado (AKS + ACR + Ingress Nginx) provisionado para validação da API Node.js, mapeei as seguintes dúvidas de arquitetura para alinhar antes da promoção para os ambientes oficiais:

1. **Estratégia de HPA (Horizontal Pod Autoscaler) e Métricas:** Para o ambiente produtivo, o cluster já conta com o *Metrics Server* instalado por padrão para configurarmos o HPA baseado em CPU/Memória, ou precisaremos acoplar o KEDA para escalar a API via filas do Azure Service Bus?

2. **Gerenciamento de Segredos Globais (Azure Key Vault):** Pensando na esteira de CI/CD corporativa, a governança da Profarma exige a migração dos `Secrets` locais do Kubernetes para o *Azure Key Vault* integrado via *Secrets Store CSI Driver*, ou manteremos os manifests encriptados no repositório?

3. **Ciclo de Vida de Imagens no ACR (Purge Policies):** Como o build remoto (`az acr build`) gera novas tags a cada commit, existe alguma política de retenção automática configurada no ACR para limpar imagens órfãs (untagged) e evitar custos desnecessários de armazenamento?

4. **Isolamento de Rede e Ingress Corporativo:** O Ingress Controller que provisionamos expõe um IP público direto da Azure. Para os ambientes internos da Profarma, utilizaremos uma abordagem de Ingress privado integrado ao *Azure Application Gateway* (AGIC) com regras de WAF?

5. **Estratégia de Atualização do Cluster (AKS Upgrade):** Qual é a janela de manutenção e a política adotada pelo time para atualização da versão do Kubernetes no AKS? Utilizamos a abordagem de *Node Image Upgrades* automáticos ou realizamos o processo de forma controlada via Terraform?