//Parameters

@description('Azure region')
param location string = resourceGroup().location

@description('Network Security Group name')
param nsgName string = 'nsg-bicepadvanced'

@description('Network Security Group rule name')
param nsgRule string = 'allow-rdp-inbound'

@description('Protocol Type')
param protocol string = 'Tcp'

@description('Destination Port Range')
param destinantionPortRange string = '3389'

// Variables

var environment = 'sandbox'
var workload = 'bicep'
var owner = 'brandon orie'

//Network Security Group 

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: nsgName
  location: location
tags: {
  environment: environment
  workload: workload
  owner: owner
}
  properties: {
    securityRules: [
      {
        name: nsgRule
        properties: {
          description: 'allowinboundrdp'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}
