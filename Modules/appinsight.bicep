// Parameters 

param workspaceSubscriptionId string = '0451fe17-f6c8-4574-8712-37215267d541'
param workspaceResourcgroupName string = 'sentinel-rg'
param logAnalyticsWorkspaceName string = 'security-log'
param appInsightName string = 'appi-enterprise-cockpit'
param location string = resourceGroup().location



resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' existing = {
  name: logAnalyticsWorkspaceName
  scope: resourceGroup(
    workspaceSubscriptionId,
    workspaceResourcgroupName
  )
}

resource appInsightsComponents 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}
output connectionString string = appInsightsComponents.properties.ConnectionString
