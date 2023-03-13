param GHESInstanceHostName string
param MicrosoftAppId string

@description('If using in non-proxy mode don\'t set the path, else append _msteams to path')
param pathParameter bool = true

var uniqueName = 'gh${uniqueString(resourceGroup().id, deployment().name)}'
var endpoint = (pathParameter ? 'https://${GHESInstanceHostName}/_msteams/teams/message' : 'https://${GHESInstanceHostName}/teams/message')

resource uniqueName_bot 'Microsoft.BotService/botServices@2021-03-01' = {
  name: '${uniqueName}-bot'
  location: 'global'
  kind: 'azurebot'
  sku: {
    name: 'F0'
  }
  properties: {
    displayName: 'GHE'
    endpoint: endpoint
    msaAppId: MicrosoftAppId
    msaAppType: 'MultiTenant'
  }
}

resource uniqueName_bot_MsTeamsChannel 'Microsoft.BotService/botServices/channels@2021-03-01' = {
  parent: uniqueName_bot
  name: 'MsTeamsChannel'
  location: 'global'
  properties: {
    channelName: 'MsTeamsChannel'
    properties: {
      acceptedTerms: true
      deploymentEnvironment: 'commercialdeployment'
      enableCalling: false
      incomingCallRoute: 'graphPma'
      isEnabled: true
    }
  }
}