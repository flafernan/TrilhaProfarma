targetScope = 'subscription'

param environmentName string = 'trilha-flavio'
param location string = 'eastus'

// 1. Criando o Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-${environmentName}'
  location: location
}

// 2. Criando a VNet e Subnets de forma nativa
module network './vnet.bicep' = {
  name: 'vnet-deployment'
  scope: rg 
  params: {
    vnetName: 'vnet-${environmentName}'
    location: location
  }
}

// 3. Criando o Azure Container Registry (ACR) de forma nativa
module acr './acr.bicep' = {
  name: 'acr-deployment'
  scope: rg 
  params: {
    acrName: 'acr${uniqueString(rg.id)}' 
    location: location
  }
}

// 4. Criando o Azure Key Vault de forma nativa
module keyvault './keyvault.bicep' = {
  name: 'keyvault-deployment'
  scope: rg
  params: {
    kvName: 'kv-${take(uniqueString(rg.id), 20)}'
    location: location
  }
}

output resourceGroupName string = rg.name

// 5. Criando o Cluster AKS de forma nativa
module aks './aks.bicep' = {
  name: 'aks-deployment'
  scope: rg
  params: {
    clusterName: 'aks-${environmentName}'
    location: location
  }
}
