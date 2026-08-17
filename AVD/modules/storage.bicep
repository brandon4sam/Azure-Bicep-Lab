@description('Azure Region')
param location string = resourceGroup().location

@description('Storage Account Name')
param storageAccountName string = 'avdfslogixcloudst05'

@description('file share name for FSLogix profile containers')
param profileShareName string = 'profileshare'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'fileStorage'
  sku: {
    name: 'Premium_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

resource profileshare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-02-01' = {
  name: '${storageAccount.name}/default/${profileShareName}'
  properties: {
    shareQuota: 1024
  }
}


output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
output profileSharename string = profileShareName
output profilePath string = '\\\\${storageAccount.name}.file.core.windows.net\\${profileShareName}'
