@description('Azure Region')
param location string = resourceGroup().location

@description ('AVD Host Pool Name')
param hostPoolName string = 'avd-hostpool-demo2'

@description ('avd Host Pool Friendly Name')
param hostPoolFriendlyName string = 'AVD-hostpool-2'

@description('maximum session limit for the host pool')
@minValue(1)
@maxValue(50)
param maxSessionLimit int = 10

@description('Host Pool Type')
@allowed([
  'Pooled'
  'Personal'
])
param hostPoolType string = 'Pooled'

resource hostPool 'Microsoft.DesktopVirtualization/hostpools@2024-04-03' = {
  name: hostPoolName
  location: location
  properties: {
    friendlyName: hostPoolFriendlyName
    hostPoolType: hostPoolType
    loadBalancerType: 'BreadthFirst'
    preferredAppGroupType: 'Desktop'
    maxSessionLimit: maxSessionLimit
    startVMOnConnect: true
  }
}


output hostPoolId string = hostPool.id
