param location string = resourceGroup().location

param spoke1ResourceId string = ''
param spoke2ResourceId string = ''
param addressPrefix string = '10.0.0.0/16'

var vnetName = 'vnet-hub'
var privateDNSZoneName = 'privatelink.table.${environment().suffixes.storage}'

var spoke1Exists = length(spoke1ResourceId) > 0
var spoke2Exists = length(spoke2ResourceId) > 0

// Private DNS Zone
resource privateDNSZoneResource 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDNSZoneName
  location: 'global'
}

// Link Private DNS Zone to VNET
resource privateDNSZoneLinkToVNETResource 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-01-01' = {
  name: '${privateDNSZoneResource.name}/${privateDNSZoneResource.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetResource.id
    }
  }
}

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
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'subnet002'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'subnet003-private-endpoint'
        properties: {
          addressPrefix: '10.0.2.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

resource vnetPeeringToSpoke1Resource 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-06-01' = if (spoke1Exists) {
  name: '${vnetResource.name}/hub-to-spoke1'
  properties: {
    remoteVirtualNetwork: {
      id: spoke1ResourceId
    }
  }
}

resource vnetPeeringToSpoke2Resource 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-06-01' = if (spoke2Exists) {
  name: '${vnetResource.name}/hub-to-spoke2'
  properties: {
    remoteVirtualNetwork: {
      id: spoke2ResourceId
    }
  }
}

output privateDNSZone string = privateDNSZoneResource.id