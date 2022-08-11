
param actionGroupsWithNamesAndSeverity array = [//index 0 is critical index 4 verbose corresponding to alerts sev
  'SquadraCritical','SquadraError'
]

param targetResourceName string
param alertDescription string=''
param targetResourceTypeFriendly string=''
param alertSev int
param alertOperationName string=''
param targetResourceType string=''
//param alertTags object
var actionGroupRGName = 'supervisionbiceppoc'



resource alert 'Microsoft.Insights/activityLogAlerts@2020-10-01' = {
  name: '${targetResourceTypeFriendly}-${targetResourceName}-Activitylog-${alertSev}'
  location: resourceGroup().location
  //tags: {}
  properties: {
    scopes: [subscription().subscriptionId]
    condition: {
        allOf: [
            {
                field: 'category'
                equals: 'Administrative'
            }
            {
              field: 'resourceType'
              equals: targetResourceType//microsoft.datafactory/factories
            }
            {
                field: 'operationName'
                equals: alertOperationName//Microsoft.DataFactory/factories/write
            }

            /* {
              "field": "level",
              "containsAny": [
                  "critical",
                  "error"
              ]
          },
          {
              "field": "status",
              "containsAny": [
                  "failed",
                  "started"
              ]
          } */
        ]
    }
    actions: {
      actionGroups: [
        {
        actionGroupId: resourceId(actionGroupRGName, 'Microsoft.Insights/actionGroups', actionGroupsWithNamesAndSeverity[alertSev-1]) //mutiple Action groups needed ?
        }
      ]
      
    }
    enabled: true
    description: alertDescription
}
}
