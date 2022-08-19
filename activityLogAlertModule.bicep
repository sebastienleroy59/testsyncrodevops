
var actionGroupSevSuffixes = ['Critical','Error','Warning','Informational']
var actionGroupPrefix = 'Squadra'

var actionGroupsWithNamesAndSeverity = [for (actionGroupSevSuffix, i) in actionGroupSevSuffixes: {
  name: '${actionGroupPrefix}-${actionGroupSevSuffix}'
  
}]


param targetResourceScope string
param alertDescription string=''
param targetResourceTypeFriendly string=''
param alertSev int
param alertOperationName string=''
param targetResourceType string=''
param levels array
param status array
//param alertTags object
var actionGroupRGName = 'supervisionbiceppoc'


resource alert 'Microsoft.Insights/activityLogAlerts@2020-10-01' = {
  name: '${targetResourceTypeFriendly}-Activitylog-${alertSev}'
  location: 'global'
  //tags: {}
  properties: {
    scopes: ['/subscriptions/3d55714f-ef79-47c8-8f9e-1b229902ba0d/resourceGroups/POC-ADF/providers/Microsoft.DataFactory/factories']//to avoid to go out the 100 limit alerts
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
            {
              field:'level'
              containsAny:!empty(levels) ? levels : ['*']
            }
            {
                field:'status'
                containsAny:!empty(status) ? status : ['*']
            }

           
        ]
    }
    actions: {
      actionGroups: [
        {
        actionGroupId: resourceId(actionGroupRGName, 'Microsoft.Insights/actionGroups', actionGroupsWithNamesAndSeverity[alertSev-1].name) //mutiple Action groups needed ?
        }
      ]
      
    }
    enabled: true
    description: alertDescription
}
}
