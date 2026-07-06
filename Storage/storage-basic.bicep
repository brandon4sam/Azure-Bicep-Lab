param storageAccountName string = 'biceplabstorage001'

resource storageaccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: 'eastus'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

output storageAccountNameOutput string = storageaccount.name
