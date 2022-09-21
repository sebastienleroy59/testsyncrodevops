param namela string 
param locationla string = resourceGroup().location
param skunamela string = 'PerGB2018'
param retentiondaysla int = 30

resource LA 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: namela
  location: locationla
  properties: {
    sku:{
      name: skunamela
    }
    retentionInDays:retentiondaysla

  }
}

 output nameLA string = LA.name
 output locationla string = LA.location
 output workspaceid string = LA.id
 output propertiesla object = LA.properties
