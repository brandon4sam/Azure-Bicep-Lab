var environment = 'sandbox'
param storageAccountName string = 'biceplabstorage002'
param location string = 'eastus'

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  tags: {
    Environment: environment
  }
}
output storageAccountNameOutput string = storageaccount.name

output storageAccountLocationOutput string = storageaccount.location

output environmentOutput string = storageaccount.tags.Environment
