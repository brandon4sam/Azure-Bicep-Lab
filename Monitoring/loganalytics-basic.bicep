//Parameters
param workspaceName string ='law-biceplab-demo'
param location string = 'westus'

//Variables
var environment = 'sandbox'
var workload = 'test'
var owner = 'Brandon Orie'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
tags: {
    Environment: environment
    Workload: workload
    Owner: owner
  }
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  } 
}

output logAnalyticsWorkspaceNameOutput string = logAnalyticsWorkspace.name

output logAnalyticsWorkspaceLocationOutput string = logAnalyticsWorkspace.location
