targetScope = 'resourceGroup'

@description('Azure Region')
param location string = resourceGroup().location

@description('Admin Username')
param adminUsername string = 'azureuser'

@description('Admin Password')
@secure()
param adminPassword string

module network 'modules/network.bicep' = {
  name: 'network'
  params: {
    location: location
  }
}
module hostPool 'modules/hostpool.bicep' = {
  name: 'hostPool'
  params: {
    location: location
    hostPoolName: 'avd-hostpool-demo'
    hostPoolFriendlyName: 'AVD Bicep Host Pool'
  }
}

module sessionhost 'modules/sessionhost.bicep' = {
  name: 'sessionhost'
  params: {
    location: location
    vmName: 'avd-sh-demo2'
    vmSize: 'Standard_D4s_v5'
    adminUsername: adminUsername
    adminPassword: adminPassword
    subnetId: network.outputs.subnet2Id
  }
}

module applicationGroup 'modules/applicationgroup.bicep' = {
  name: 'applicationGroup'
  params: {
    location: location
    appGroupName: 'avd-dag-bicep-demo2'
    appGroupFriendlyName: 'AVD Desktop Application Group'
    appGroupDescription: 'AVD Desktop Application Group Bicep Demo 2'
    hostPoolId: hostPool.outputs.hostPoolId
  }
}
module workspace 'modules/workspace.bicep' = {
  name: 'workspace'
  params: {
    location: location
    appGroupId: applicationGroup.outputs.applicationGroupId
  }
}
