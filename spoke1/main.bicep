param location string = resourceGroup().location

param hubResourceId string
param addressPrefix string = '10.1.0.0/16'

var vnetName = 'vnet-spoke1'
var storageAccountName = 'spoke1stor'

resource vnetResource 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'subnet001'
        properties: {
          addressPrefix: '10.1.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

resource vnetPeeringResource 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-06-01' = {
  name: '${vnetResource.name}/spoke1-to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: hubResourceId
    }
  }
}

resource storageAccountResource 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    networkAcls: {
      defaultAction: 'Deny'
    }
  }
}

resource privateEndpointResource 'Microsoft.Network/privateEndpoints@2020-05-01' = {
  name: 'privatelink-to-table'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'privatelink-to-table'
        properties: {
          privateLinkServiceId: storageAccountResource.id
          groupIds: [
            'table'
          ]
        }
      }
    ]
    subnet: {
      id: vnetResource.properties.subnets[0].id
    }
  }
}

output vnet string = vnetResource.id
