// Parameters

@description('Azure region for the session host resources.')
param location string = resourceGroup().location

@description('Virtual machine name.')
param vmName string = 'avd-sh-demo2'

@description('Virtual machine size.')
param vmSize string = 'Standard_D4s_v5'

@description('Local administrator username for the session host.')
param adminUsername string = 'azureuser'

@description('Local administrator password for the session host.')
@secure()
param adminPassword string

@description('Subnet resource ID where the session host NIC will be deployed.')
param subnetId string

@description('OS disk type for the session host.')
@allowed([
  'Standard_LRS'
  'StandardSSD_LRS'
  'Premium_LRS'
])
param osDiskType string = 'Premium_LRS'

// Network Interface

resource networkInterface 'Microsoft.Network/networkInterfaces@2024-03-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

// Virtual Machine

resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }

    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
        }
      }
    }

    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'windows-11'
        sku: 'win11-24h2-avd'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
    }

    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
          properties: {
            primary: true
          }
        }
      ]
    }

    securityProfile: {
      securityType: 'TrustedLaunch'
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
    }

    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

// Outputs

output vmId string = virtualMachine.id
output vmName string = virtualMachine.name
output nicId string = networkInterface.id
