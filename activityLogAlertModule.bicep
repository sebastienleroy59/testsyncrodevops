
var actionGroupSevSuffixes = ['Critical','Error','Warning','Informational']
var actionGroupPrefix = 'Squadra'

var actionGroupsWithNamesAndSeverity = [for (actionGroupSevSuffix, i) in actionGroupSevSuffixes: {
  name: '${actionGroupPrefix}-${actionGroupSevSuffix}'
  
}]


param alertDescription string=''
param targetResourceTypeFriendly string=''
param alertSev int
param alertOperationName string=''
param targetResourceType string=''
param levels array
param status array
param actionGroupRGName string =''


resource alert 'Microsoft.Insights/activityLogAlerts@2020-10-01' = {
  name: '${targetResourceTypeFriendly}-Activitylog-${alertSev}' //split last operation name after /
  location: 'global'
  //tags: {}
  properties: {
    scopes: [
        subscription().id
    ]//to avoid to go out the 100 limit alerts
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
