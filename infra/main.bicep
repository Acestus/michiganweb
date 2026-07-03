targetScope = 'resourceGroup'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@minLength(2)
@maxLength(12)
param projectName string = 'michiganweb'

@allowed(['dev', 'prd'])
param environment string

@minLength(3)
@maxLength(3)
param instanceNumber string = '001'

@description('Resource tags.')
param tags object = {
  project: projectName
  environment: environment
  managedBy: 'bicep'
}

@description('SWA SKU. Free by default.')
@allowed([
  'Free'
  'Standard'
])
param staticWebAppSku string = 'Free'

var staticWebAppName = 'swa-${projectName}-${environment}-${instanceNumber}'

resource staticWebApp 'Microsoft.Web/staticSites@2023-12-01' = {
  name: staticWebAppName
  location: location
  tags: tags
  sku: {
    name: staticWebAppSku
    tier: staticWebAppSku
  }
  properties: {
    buildProperties: {
      skipGithubActionWorkflowGeneration: true
    }
  }
}

output staticWebAppName string = staticWebApp.name
output staticWebAppHostName string = staticWebApp.properties.defaultHostname
