param location string = resourceGroup().location

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

output vnet string = vnetResource.id
