using '../main.bicep'

param environment = 'dev'
param instanceNumber = '001'
param staticWebAppSku = 'Free'
// Re-enable once the Hover CNAME for michigan2026.bluegreen.love is confirmed (see mi-09)
param customDomainName = ''
