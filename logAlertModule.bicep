
param actionGroupsWithNamesAndSeverity array = [//index 0 is critical index 4 verbose corresponding to alerts sev
  'SquadraCritical','SquadraError'
]

param targetResourceName string
param alertDescription string=''
param eveluationFreq string=''
param windowsSize string=''
param targetResourceType string=''
param targetResourceTypeFriendly string=''
param resourceRG string=''
param alertSev int
param alertTreshold int
param alertMeasureColumn string=''
param alertOperator string=''
param alertTimeAggregation string=''
param alertDimensions array
param alertQuery string=''

//param alertTags object
var actionGroupRGName = 'supervisionbiceppoc'

resource alert 'Microsoft.Insights/scheduledQueryRules@2021-08-01' = {
  name: '${targetResourceTypeFriendly}-${targetResourceName}-${alertSev}'
  location: resourceGroup().location
  //tags: {}
  properties: {
    description: alertDescription
    severity: alertSev-1
    enabled: true
    scopes: [
      resourceId(resourceRG,targetResourceType, targetResourceName)
    ]
    targetResourceTypes: [
      targetResourceType
    ]
    evaluationFrequency: eveluationFreq
    windowSize: windowsSize
    criteria: {
      allOf: [
          {
              query:alertQuery
              timeAggregation: alertTimeAggregation
              //metricMeasureColumn: alertMeasureColumn
              dimensions: alertDimensions
              operator: alertOperator
              threshold: alertTreshold
              failingPeriods: {
                  numberOfEvaluationPeriods: 1
                  minFailingPeriodsToAlert: 1
              }
          }
      ]
  }
   
    //muteActionsDuration: muteActionsDuration
    //autoMitigate: autoMitigate
    //checkWorkspaceAlertsStorageConfigured: checkWorkspaceAlertsStorageConfigured
    actions: {
      actionGroups: [
          resourceId(actionGroupRGName, 'Microsoft.Insights/actionGroups', actionGroupsWithNamesAndSeverity[alertSev-1]) //mutiple Action groups needed ?
      ]
      
    }
  }
}
