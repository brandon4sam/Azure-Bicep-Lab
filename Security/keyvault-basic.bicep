//Parameters
param keyvaultName string = 'biceplab-kv-demo015'
param location string = 'eastus'
param enablerbac bool= true

//Variables
var environment = 'sandbox'
var workload = 'test'
var owner = 'Brandon Orie'

//Resource

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyvaultName
  location: location
tags:{
    Environment: environment
    Workload: workload
    Owner: owner
  }
  properties: {
    enabledForDeployment: false
    enabledForTemplateDeployment: false
    enabledForDiskEncryption: false
    
    tenantId: 'efc85bf0-0f07-4788-ae45-9a48edb6ad64'
  
    sku: {
      name: 'standard'  
      family: 'A'
    }
    enableRbacAuthorization: enablerbac
  }
}

//Outputs
output keyVaultNameOutput string = keyVault.name

output keyVaultLocationOutput string = keyVault.location

output keyVaultSkuOutput string = 'standard'
