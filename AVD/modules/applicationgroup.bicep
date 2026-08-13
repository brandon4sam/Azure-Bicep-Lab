@description ('Azure Region')
param location string = resourceGroup().location

@description('Application Group Name')
@minLength(3)
@maxLength(64)
param appGroupName string = 'avd-dag-bicep-demo2'

@description('Application Group Friendly Name')
param appGroupFriendlyName string = 'AVD-Application-Group-2'

@description('Application Group Description')
param appGroupDescription string = 'AVD Desktop Application Group Bicep Demo 2'

@description('Application Group Type')
@allowed([
  'RemoteApp'
  'Desktop'
])
param appGroupType string = 'Desktop'

param hostPoolId string 

@description('Resource tags')
param resourceTags object = {
  workload: 'avd'
  ManagedBy: 'bicep'
  Environment: 'demo'
}

resource applicationGroup 'Microsoft.DesktopVirtualization/applicationgroups@2024-04-03' = {
  name: appGroupName
  location: location
  properties: {
    friendlyName: appGroupFriendlyName
    applicationGroupType: appGroupType
    hostPoolArmPath: hostPoolId
  }
  tags: resourceTags
}

output applicationGroupId string = applicationGroup.id
