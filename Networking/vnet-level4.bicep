// Parameters
@description('Azure Region')
param location string = resourceGroup().location

@description('Virtual Network Name')
param vnetName string = 'vnet-bicep2-lab'

@description('Virtual Network Address Space')
param addressPrefixes array = [ 
  '10.50.0.0/16'
]

@description('Subnet 1 Name')
param subnet1Name string = 'Management-Snet'

@description('Subnet 2 Name')
param subnet2Name string = 'Sessionhost-Snet'

@description('Subnet 3 Name')
param subnet3Name string = 'pep-avd-Snet'

@description('Subnet Address Space ')
param subnet1AddressPrefix string = '10.50.1.0/24'

@description('Subnet 2 Address Space')
param subnet2AddressPrefix string = '10.50.2.0/24'

@description('Subnet 3 Address Space')
param subnet3AddressPrefix string = '10.50.3.0/24'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: vnetName
  location: location
  tags: {
    environment: 'rg-avd-bicep2-lab'
    workload: 'avd'
  }
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes 
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1AddressPrefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2AddressPrefix
        }
      }
      {
        name: subnet3Name
        properties:{
          addressPrefix:subnet3AddressPrefix
        } 
      }
    ]
  }
}
