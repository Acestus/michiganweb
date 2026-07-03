targetScope = 'resourceGroup'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@minLength(2)
@maxLength(12)
param projectName string = 'michiganweb'

@allowed(['dev'])
param environment string = 'dev'

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

@description('Custom domain to attach to the Static Web App, e.g. michigan2026.bluegreen.love. Leave empty to skip.')
param customDomainName string = ''

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

// Requires a CNAME record at the DNS provider (Hover) pointing
// customDomainName -> staticWebApp.properties.defaultHostname before this
// resource can validate. Apply this after the CNAME is confirmed to propagate.
resource customDomain 'Microsoft.Web/staticSites/customDomains@2023-12-01' = if (!empty(customDomainName)) {
  parent: staticWebApp
  name: customDomainName
  properties: {
    validationMethod: 'cname-delegation'
  }
}

output staticWebAppName string = staticWebApp.name
output staticWebAppHostName string = staticWebApp.properties.defaultHostname
