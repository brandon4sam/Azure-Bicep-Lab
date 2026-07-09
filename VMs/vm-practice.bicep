// Parameters
param vmName string = 'bicep-vm-demo02'
param location string = resourceGroup().location
param adminUsername string = 'OrieAdmin'

@secure()
param adminPassword string

param vmSize string = 'Standard_D4s_v5'
param vnetName string = 'biceplab-vnet-demo'
param subnetName string = 'management-snet'
param publicIpName string = '${vmName}-pip'
param nicName string = '${vmName}-nic'

//Variables
var environment = 'sandbox'
var Workload = 'test'
var Owner = 'brandon orie'

//Existing Virtual Network
resource existingVnet 'Microsoft.Network/virtualNetworks@2019-12-01' existing = {
name: vnetName
}

//Existing Subnet
resource existingSubnet 'Microsoft.Network/virtualNetworks/subnets@2019-12-01' existing = {
  parent: existingVnet
  name: subnetName
}
//Public IP Address
resource publicIP 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: publicIpName
  location: location
  sku: {
    name:'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
tags: {
  Environment:environment
  Workload: Workload
  Owner: Owner
  }
}
//Network Interface
resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id:publicIP.id
          }
          subnet: {
            id: existingSubnet.id
          }
        }
      }
    ]
  }
}
// Windows Virtual Machine
resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
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
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-DataCenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
} 
