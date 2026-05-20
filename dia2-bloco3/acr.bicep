// O escopo deste arquivo também é o Resource Group
targetScope = 'resourceGroup'

param acrName string
param location string

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Standard' // Camada recomendada para laboratórios e ambientes Profarma
  }
  properties: {
    adminUserEnabled: true // Permite autenticação simples via usuário admin para os laboratórios
  }
}

// Retorna o ID do ACR para podermos vincular ao AKS mais adiante
output acrLoginServer string = acr.properties.loginServer
