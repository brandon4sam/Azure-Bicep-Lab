// Parameters

@description('Azure Region')
param location string = resourceGroup().location

@description('VM Name')
@minLength(1)
@maxLength(64)
param vmName string = 'windowsservervm01'

@description('Windows computer name, Windows computer names are limited to 15 characters')
@minLength(1)
@maxLength(15)
param computerName string = 'winsrv01'

@description('Azure VM size')
@allowed([
  'Standard_DS1_v2'
  'Standard_D2s_v5'
  'Standard_D4s_v5'
])
param vmSize string = 'Standard_D2s_v5'

@description('Local admin username for the VM')
param adminUsername string = 'adminuser'

@secure()
@description('Local admin password for the VM')
param adminPassword string

@description('Storage type for the operating system managed disk')
@allowed([
  'Standard_LRS'
  'StandardSSD_LRS'
  'Premium_LRS'
])
param osDiskStorageType string = 'StandardSSD_LRS'

@description ('Size of the operating system disk in GB')
param osDiskSizeGB int = 127


@description('Resource ID of the existing subnet where the VM network interface will be deployed')
param subnetResourceId string

@description('Name of the network interface.')
param networkInterfaceName string = '${vmName}-nic'

@description('Private IP alllocation method for the network interface')
@allowed([
  'Dynamic'
  'Static'
])
param privateIPAllocationMethod string = 'Dynamic'

@description('Optional static private IPv4 address. Required only when privateIPAllocationmethod is Static')
param privateIPAddress string


@description('Tags applied to resrouces created by this template')
param tags object = {
  workload: 'WindowsServer'
  ManagedBy: 'bicep'
  Environment: 'lab'
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: networkInterfaceName
  location: location
  tags: tags

  properties: {
    enableAcceleratedNetworking: false
    enableIPForwarding: false

    ipConfigurations: [
      {
        name: '${networkInterfaceName}-ipconfig'

        properties: union(
          {
            primary: true
            privateIPAddressVersion: 'IPv4'
            privateIPAllocationMethod: privateIPAllocationMethod

            subnet: {
              id: subnetResourceId
            }
          },
          privateIPAllocationMethod == 'Static'
            ? {
                privateIPAddress: privateIPAddress
              }
            : {}
        )
      }
    ]
  }
}
resource windowsVM 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: vmName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    securityProfile: {
  securityType: 'TrustedLaunch'

  uefiSettings: {
    secureBootEnabled: true
    vTpmEnabled: true
  }
}
    hardwareProfile: {
      vmSize: vmSize
    }
    additionalCapabilities: {
      ultraSSDEnabled: false
    }
    osProfile: {
      computerName: computerName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
  provisionVMAgent: true
  enableAutomaticUpdates: true

  patchSettings: {
    patchMode: 'AutomaticByPlatform'
    assessmentMode: 'AutomaticByPlatform'
  }
}
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter-azure-edition-hotpatch'
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskStorageType
        }
        deleteOption: 'Delete'
        diskSizeGB: osDiskSizeGB
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
          properties: {
            primary: true
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}
