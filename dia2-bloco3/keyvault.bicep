targetScope = 'resourceGroup'

param kvName string
param location string

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: kvName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard' // Camada padrão, ideal para o nosso laboratório
    }
    tenantId: subscription().tenantId
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    // Ativa o Azure RBAC para controle de acesso (padrão moderno recomendado pela Microsoft)
    enableRbacAuthorization: true 
  }
}

output kvId string = kv.id
