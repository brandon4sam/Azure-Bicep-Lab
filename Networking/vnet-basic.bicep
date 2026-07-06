//Parameters
param vnetName string = 'biceplab-vnet-demo'
param location string = 'eastus'
param subnet1Name string = 'management-snet'
param subnet2Name string = 'servers-snet'
var environment = 'sandbox'


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  tags: {
    Environment: environment
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.50.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: '10.50.1.0/24'
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: '10.50.2.0/24'
        }
      }
    ]
  }
}
output vnetNameOutput string = virtualNetwork.name
output vnetLocationOutput string = virtualNetwork.location
