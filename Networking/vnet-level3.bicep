// Parameters
@description('Azure reigon')
param location string = resourceGroup().location

@description('virtual Network name')
param vnetName string = 'bicep-vnet-demo-2'

@description('subnet name')
param subnet1Name string = 'snet-bicepadvanced'

@description('Vnet address space')
param vnetAddressPrefix string = '10.70.0.0/16'

@description('subnet address space')
param subnet1AddressPrefix string = '10.70.1.0/24'

@description('subnet 2 name')
param subnet2Name string = 'snet-pep'

@description('subnet 2 address space')
param subnet2AddressPrefix string = '10.70.2.0/24'


//Variables 
var environment = 'sandbox'
var workload = 'bicep'
var owner = 'brandon orie'


// Virtual Network

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location

tags: {
  environment: environment
  Owner: owner
  workload: workload
}

  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
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
    ]
  }
}
