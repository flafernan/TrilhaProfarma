// Escopo deste arquivo é o Resource Group
targetScope = 'resourceGroup'

param vnetName string
param location string

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-aks'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'snet-services'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}
