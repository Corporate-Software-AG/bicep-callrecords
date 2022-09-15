param strgAccName string
param location string

resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: strgAccName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    isHnsEnabled: true
  }
}
output strgAccountName string = storage.name
