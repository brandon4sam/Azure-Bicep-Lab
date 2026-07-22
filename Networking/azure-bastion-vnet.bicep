@description('Azure Reigon')
param location string = resourceGroup().location

@description('Existing Virtual Network Name')
param vnetName string 

@description('Azure Bastion')
param addressPrefix string = '10.80.0.0/24'

@description('Bastion Name')
param bastionName string = 'avd-bastion'

resource existingVnet 'Microsoft.Network/virtualNetworks@2024-10-01' existing = {
  name: vnetName
}
resource bastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '{$vnetName}/azureBastionSubnet'
  properties:{
    addressPrefix:addressPrefix
  }
}
resource bastionPublicIp 'Microsoft.Network/publicIPAddresses@2025-03-01' = {
  name: '${bastionName}-pip'
  location: location

  sku:{
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod:'Static'
    }
  }


