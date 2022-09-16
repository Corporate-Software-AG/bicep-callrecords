param strgAccountName string

param functionAppName string
param appSrvPlanName string
param location string
param appId string
param appSecret string

param appInsightsName string

resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: strgAccountName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource appSrvPlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appSrvPlanName
  location: location
  kind: 'linux'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true
  }
}

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appSrvPlan.id
    siteConfig: {
      linuxFxVersion: 'NODE|16'
      appSettings: [
        {
          name: 'TENANT_ID'
          value: subscription().tenantId
        }
        {
          name: 'APP_ID'
          value: appId
        }
        {
          name: 'APP_SECRET'
          value: appSecret
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storage.listKeys().keys[0].value}'
        }
        {
          name: 'CONNECTION_STRING_LAKE'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storage.listKeys().keys[0].value}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~16'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
      ]
      minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}
