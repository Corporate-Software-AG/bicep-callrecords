param location string = resourceGroup().location

param strgAccName string = 'strg${uniqueString(resourceGroup().id)}'

param functionAppName string = 'funcName-${uniqueString(resourceGroup().id)}'
param appSrvPlanName string = 'appSrvPlan-${uniqueString(resourceGroup().id)}'

param logAnalyticsName string = 'logAnalytics-${uniqueString(resourceGroup().id)}'
param appInsightsName string = 'appInsights-${uniqueString(resourceGroup().id)}'

module storage 'modules/storage.bicep' = {
  name: '${deployment().name}-storage'
  params: {
    strgAccName: strgAccName
    location: location
  }
}

module monitoring 'modules/monitoring.bicep' = {
  name: '${deployment().name}-monitoring'
  params: {
    appInsightsName: appInsightsName
    location: location
    logAnalyticsName: logAnalyticsName
  }
}

module functionapp 'modules/functionapp.bicep' = {
  name: '${deployment().name}-functionapp'
  params: {
    appSrvPlanName: appSrvPlanName
    functionAppName: functionAppName
    location: location
    strgAccountName: storage.outputs.strgAccountName
    appInsightsName: monitoring.outputs.appInsightsName
  }
}
