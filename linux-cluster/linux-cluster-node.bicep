param location string = 'eastus'

param vmNames array = [
  'securai-vm11'
  'securai-vm12'
]

param vmSize string = 'Standard_D32as_v4'
param adminUsername string = 'azureuser'

param vnetName string = 'securai-vm01-vnet'
param subnetName string = 'securai-cluster-snet'

param adminPublicKey string

resource existingVnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: vnetName
}

resource existingSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' existing = {
  parent: existingVnet
  name: subnetName
}

resource nics 'Microsoft.Network/networkInterfaces@2024-05-01' = [for vmName in vmNames: {
  name: '${vmName}-nic'
  location: location
  tags: {
    environment: 'secure-ai'
    VM: vmName
  }
  properties: {
    enableAcceleratedNetworking: true
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: existingSubnet.id
          }
        }
      }
    ]
  }
}]

resource vms 'Microsoft.Compute/virtualMachines@2025-11-01' = [for (vmName, i) in vmNames: {
  name: vmName
  location: location
  tags: {
    environment: 'secure-ai'
    VM: vmName
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'ubuntu-pro'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${vmName}_OsDisk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'Delete'
      }
      dataDisks: [
        {
          lun: 0
          name: '${vmName}_DataDisk_0'
          createOption: 'Empty'
          caching: 'None'
          writeAcceleratorEnabled: false
          diskSizeGB: 2048
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
          deleteOption: 'Detach'
        }
      ]
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: adminPublicKey
            }
          ]
        }
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      allowExtensionOperations: true
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nics[i].id
          properties: {
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
}]
