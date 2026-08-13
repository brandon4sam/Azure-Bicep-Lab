@description('Azure Region')
param location string = resourceGroup().location

@description('Virtual Network Name')
param vnetName string = 'avd-bicep-vnet-demo2'

@description('Management Subnet Name')
param subnet1Name string = 'avd-management-snet'

@description('Session Hosts Subnet Name')
param subnet2Name string = 'avdsessionhosts-snet'

@description('Management Subnet Address Prefix')
param addressPrefix1 string = '10.50.0.0/24'

@description('Session Hosts Subnet Address Prefix')
param addressPrefix2 string = '10.50.1.0/24'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
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
        name: subnet1Name
        properties: {
          addressPrefix: addressPrefix1
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: addressPrefix2
        }
      }
    ]
  }
}

output virtualNetworkId string = virtualNetwork.id

output subnet1Id string = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetwork.name, subnet1Name)
output subnet2Id string = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetwork.name, subnet2Name)
