//Parameters
param nsgName string = 'bicep-nsg-demo'
param location string = 'eastus'
param nsgRuleName string = 'nsg-demo-rule'
param allowedSourceIP string = '47.196.90.232/32'
param destinationPortRange string = '3389'
param protocol string = 'Tcp'
param ruleAccess string = 'Allow'
param direction string = 'Inbound' 
param priority int = 100



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
          protocol: protocol
          sourcePortRange: '*'
          destinationPortRange: destinationPortRange
          sourceAddressPrefix: allowedSourceIP
          destinationAddressPrefix: '*'
          access: ruleAccess
          priority: priority
          direction: direction
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
