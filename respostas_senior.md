# Respostas Estimadas para as Perguntas do Sênior - Arquitetura Profarma

Este documento contém as respostas técnicas sugeridas para os cenários levantados, demonstrando o alinhamento com as boas práticas de mercado e os padrões esperados para a infraestrutura no AKS.

---

### 1. Estratégia de HPA (Horizontal Pod Autoscaler) e Métricas
* **Resposta:** Para o ambiente produtivo, utilizaremos o **Metrics Server** nativo do AKS para cenários de escalonamento padrão baseados em uso de CPU e Memória (HPA). No entanto, caso a API passe a consumir filas ou eventos (como Azure Service Bus), a recomendação ideal será acoplar o **KEDA (Kubernetes Event-driven Autoscaling)**, que permite escalar os pods para zero quando não houver demanda, otimizando os custos.

### 2. Gerenciamento de Segredos Globais (Azure Key Vault)
* **Resposta:** A boa prática de governança corporativa exige que nenhum segredo fique exposto em texto claro nos manifestos do Git. A abordagem correta para produção será a migração dos segredos para o **Azure Key Vault**, utilizando o **Secrets Store CSI Driver** do AKS. Isso permite que os segredos sejam injetados diretamente nos containers como volumes ou variáveis de ambiente em tempo de execução, de forma segura.

### 3. Ciclo de Vida de Imagens no ACR (Purge Policies)
* **Resposta:** Sim, para evitar custos excessivos de armazenamento com imagens antigas geradas por builds contínuos, configuraremos uma **Tarefa de Purga do ACR (ACR Purge Task)**. Essa política automatizada rodará periodicamente para deletar imagens que não possuem tags (*untagged*) ou que foram criadas há mais de 30 dias e não estão em uso no ambiente de produção.

### 4. Isolamento de Rede e Ingress Corporativo
* **Resposta:** Expor o Ingress Nginx diretamente com um IP público é aceitável apenas para testes. Para a arquitetura oficial da Profarma, o tráfego externo passará pelo **Azure Application Gateway** operando com **WAF (Web Application Firewall)** ativado para proteção contra ameaças (OWASP Top 10). O Ingress Controller do AKS operará de forma privada, recebendo requisições apenas através desse gateway de aplicação.

### 5. Estratégia de Atualização do Cluster (AKS Upgrade)
* **Resposta:** O processo de atualização do cluster seguirá uma estratégia controlada via **Terraform** em janelas de manutenção homologadas. Para os nós de trabalho (*Node Pools*), utilizaremos a estratégia de *Surge Upgrade* (com a flag `max-surge` configurada), o que garante a criação de nós novos na versão atualizada antes da remoção dos nós antigos, evitando qualquer indisponibilidade (*downtime*) para a API Node.js.