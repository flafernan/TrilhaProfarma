targetScope = 'resourceGroup'

param clusterName string
param location string

resource aks 'Microsoft.ContainerService/managedClusters@2023-10-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned' // Identidade gerenciada pelo Azure para o cluster
  }
  properties: {
    dnsPrefix: '${clusterName}-dns'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1 // Apenas 1 nó para poupar custos no seu ambiente pessoal
        vmSize: 'Standard_B2s' // Tamanho ideal e barato para laboratórios
        mode: 'System'
        osType: 'Linux'
      }
    ]
  }
}
