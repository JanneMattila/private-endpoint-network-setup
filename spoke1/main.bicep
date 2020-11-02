param location string = resourceGroup().location

param hubResourceId string
param addressPrefix string = '10.1.0.0/16'

var vnetName = 'vnet-spoke1'

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

output vnet string = vnetResource.id
