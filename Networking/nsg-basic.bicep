//Parameters
param nsgName string = 'bicep-nsg-demo'
param location string = 'eastus'
param nsgRuleName string = 'nsg-demo-rule'

//Variables
var environment = 'sandbox'
var owner = 'Brandon Orie'
var workload = 'networking'

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: nsgName
  location: location

  tags: {
    Environment: environment
    Owner: owner
    Workload: workload
    }
  properties: {
    securityRules: [
      {
        name: nsgRuleName
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '47.196.90.232/32'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

output nsgNameOutput string = networkSecurityGroup.name
output nsgLocationOutput string = networkSecurityGroup.location
output environmentOutput string = networkSecurityGroup.tags.Environment
output ownerOutput string = networkSecurityGroup.tags.Owner
output workloadOutput string = networkSecurityGroup.tags.Workload
