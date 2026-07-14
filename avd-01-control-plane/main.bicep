// Parameters

@description('Deployment Location')
param location string = resourceGroup().location

@description('Virtual Network Name')
param vnetName string = 'avd-bicep-vnet-demo'

@description('Management Subnet Name')
param managementSubnetName string = 'avd-snet'

@description('Session Host Subnet Name')
param sessionHostSubnetName string = 'avd-sessionhosts-snet'

@description('Host Pool Name')
param hostPoolName string = 'avd-hostpool-demo'

@description('Host Pool Friendly Name')
param friendlyName string = 'AVD Bicep Host Pool'

@description('Application Group Name')
param appGroupName string = 'avd-dag-bicep-demo'

@description('Application Group Friendly Name')
param appGroupFriendlyName string = 'AVD Desktop Application Group'

@description('Worksapce Name')
param workspaceName string = 'avd-workspace-bicep-demo'

@description('Workspace Friendly Name')
param workspaceFriendlyName string = 'AVD Demo Workspace'

@description('Session Host Name')
param sessionHostName string = 'avd-sh-bicep'

@description('Admin Username')
param adminUsername string 

@secure()
@description('Admin Password')
param adminPassword string 

@description('Session Host VM Size')
param vmSize string = 'Standard_D4s_v5'

@description('UTC Exipration time for AVD host pool registration token')
param registrationTokenExpirationTime string = '2026-07-15T23:59:59Z'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.80.0.0/16'
      ]
    }
    subnets: [
      {
        name: managementSubnetName
        properties: {
          addressPrefix: '10.80.1.0/24'
        }
      }
      {
        name: sessionHostSubnetName
        properties: {
          addressPrefix: '10.80.2.0/24'
        }
      }
    ]
  }
}
resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2024-04-03' = {
  name: hostPoolName
  location: location

  properties: {
    friendlyName: friendlyName
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    preferredAppGroupType: 'Desktop'
    maxSessionLimit:10

registrationInfo: {
  expirationTime: registrationTokenExpirationTime
  registrationTokenOperation: 'Update'
    }
  }
}
resource applicationGroup 'Microsoft.DesktopVirtualization/applicationgroups@2021-07-12' = {
  name: appGroupName
  location: location
  properties: {
    friendlyName: appGroupFriendlyName
    applicationGroupType: 'Desktop'
    hostPoolArmPath: hostPool.id
  }
}
resource workSpace 'Microsoft.DesktopVirtualization/workspaces@2021-07-12' = {
  name: workspaceName
  location: location
  properties: {
    friendlyName: workspaceFriendlyName
    applicationGroupReferences:[
      applicationGroup.id
    ]
  }
}
resource sessionHostNic 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: '${sessionHostName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId( 
              'Microsoft.Network/virtualNetworks/subnets',
              vnetName,
              sessionHostSubnetName
            )
          }

          privateIPAllocationMethod: 'Dynamic'
          }
        }
    ]
  }
}
resource sessionHostVm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: sessionHostName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: sessionHostName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'Windows-11'
        sku: 'win11-24h2-avd'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: sessionHostNic.id
        }
      ]
    }
    }
    }
resource testExtension 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = {
  parent:sessionHostVm
  name:'testExtension'
  location: location 

  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'

    settings: {
      commandToExecute: 'echo hello'
    }
  }
}
