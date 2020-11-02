param location string = resourceGroup().location

param spoke1ResourceId string = ''
param addressPrefix string = '10.0.0.0/16'

var vnetName = 'vnet-hub'
var privateDNSZoneName = 'privatelink.table.${environment().suffixes.storage}'

// Private DNS Zone
resource privateDNSZoneResource 'Microsoft.Network/privateDnsZones@2018-09-01'= {
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

resource vnetPeeringToSpoke1Resource 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-06-01' = {
  name: 'hub-to-spoke1'
  // https://github.com/Azure/bicep/issues/186
  // Condition is not yet implemented
  // condition: false
  properties: {
    remoteVirtualNetwork: {
      id: spoke1ResourceId
    }
  }
}

output privateDNSZone string = privateDNSZoneResource.id
