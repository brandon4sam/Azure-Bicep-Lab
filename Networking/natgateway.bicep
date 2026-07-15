// Parameters

param natGatewayName string = 'ngw-avd-sessionhosts-snet'
param location string = resourceGroup().location
param publicIpName string = 'ngw-avd-pip'

param vnetName string = 'avd-bicep-vnet-demo'
param subnetName string = 'avd-sessionhosts-snet'

param addressPrefix string = '10.80.2.0/24'

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
name: vnetName
}
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' existing = {
  parent: vnet
  name:subnetName
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static' 
    }
  }
resource natGateway 'Microsoft.Network/natGateways@2023-09-01' = {
  name:natGatewayName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIpAddresses: [
      {
        id: publicIPAddress.id
      }
    ]
  }
}
resource subnetUpdate 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = {
  parent: vnet
  name: subnetName

  properties: {
    addressPrefix: addressPrefix
    natGateway: {
      id:natGateway.id
    }
  }
}
