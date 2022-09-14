targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param name string

@minLength(1)
@description('Primary location for all resources')
param location string

@minLength(1)
@description('Primary location for all resources')
param azdEnvName string


var resourceToken = toLower(uniqueString(subscription().id, name, location))
var tags = { 'azd-env-name': azdEnvName }

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${name}'
  location: location
}

module resources 'resources.bicep' = {
  name: 'resources'
  scope: rg
  params: {
    appName: name
    environmentName: resourceToken
    appId: name
    location: location
    tags: tags
  }
}
