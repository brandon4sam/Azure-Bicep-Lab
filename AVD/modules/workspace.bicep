@description('Azure Region')
param location string = resourceGroup().location

@description('Workspace Name')
param workspaceName string = 'avd-workspace-bicep-demo2'

@description ('Workspace Friendly Name')
param workspaceFriendlyName string = 'AVD-Workspace-2'

@description('Workspace Description')
param workspaceDescription string = 'AVD Workspace 2'

@description('Application Group Resource ID')
param appGroupId string

@description('Resource tags')
param resourceTags object = {
  workload: 'avd'
  ManagedBy: 'bicep'
  Environment: 'demo'
}

resource workSpace 'Microsoft.DesktopVirtualization/workspaces@2024-04-03' = {
  name: workspaceName
  location: location
  properties: {
    friendlyName: workspaceFriendlyName
    description: workspaceDescription
  
    applicationGroupReferences: [
      appGroupId
    ]

  }
  tags: resourceTags
}


output workspaceId string = workSpace.id
output workspaceName string = workSpace.name
