using '../main.bicep'

param environment = 'dev'
param instanceNumber = '001'
param staticWebAppSku = 'Free'
// Re-enable once the Hover CNAME for michigan.acestus.com is confirmed (see mi-09)
param customDomainName = ''
