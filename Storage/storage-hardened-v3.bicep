// Parameters
param storageAccountName string = 's1stagentinstall'
param location string = 'eastus'
param skuName string = 'standard_LRS'
param kind string = 'StorageV2'
param accessTier string = 'Hot'
param minimumTlsVersion string = 'TLS1_2'

param allowBlobPublicAccess bool = false
param allowSharedKeyAccess bool = true
param supportHttpsTrafficOnly bool = true
param allowCrossTenantReplication bool = false

param publicNetworkAcess string = 'Enabled'

param blobVersioningEnabled bool = false
param blobSoftDeleteEnabled bool = false
param blobSoftDeleteRetentionDays int = 7

param containerSoftDeleteEnabled bool = true
param containerSoftDeleteRetentionDays int = 7

// Variables 
var enviornment = 'production'
var workload = 'storage'
var owner = 'Brandon Orie'
var createdBy = 'Brandon orie'

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  kind: kind
  sku: {
    name: skuName
  }
  properties: {
    accessTier: accessTier
    minimumTlsVersion: minimumTlsVersion
    allowBlobPublicAccess: allowBlobPublicAccess
    allowSharedKeyAccess: allowSharedKeyAccess
    supportsHttpsTrafficOnly: supportHttpsTrafficOnly
    allowCrossTenantReplication: allowCrossTenantReplication
    publicNetworkAccess: publicNetworkAcess
  }
  tags: {
    Environment: enviornment
    Workload: workload
    Owner: owner
    CreatedBy: createdBy
  }
}

// Blob Service Properties
// Blob Service Properties
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    isVersioningEnabled: blobVersioningEnabled
    deleteRetentionPolicy: {
      enabled: blobSoftDeleteEnabled
      days: blobSoftDeleteRetentionDays
    }
    containerDeleteRetentionPolicy: {
      enabled: containerSoftDeleteEnabled
      days: containerSoftDeleteRetentionDays
    }
    changeFeed: {
      enabled: false
    }
  }
}
