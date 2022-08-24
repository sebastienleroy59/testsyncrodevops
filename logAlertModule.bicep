
var actionGroupSevSuffixes = ['Critical','Error','Warning','Informational']
var actionGroupPrefix = 'Squadra'

var actionGroupsWithNamesAndSeverity = [for (actionGroupSevSuffix, i) in actionGroupSevSuffixes: {
  name: '${actionGroupPrefix}-${actionGroupSevSuffix}'
  
}]

param targetResourceName string
param alertDescription string=''
param evaluationFreq string=''
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
var actionGroupRGName = 'rg-infra'

var allOfCriterias = !empty(alertMeasureColumn) ?  [
  {
      query:alertQuery
      timeAggregation: alertTimeAggregation
      metricMeasureColumn: alertMeasureColumn
      dimensions: alertDimensions
      operator: alertOperator
      threshold: alertTreshold
      failingPeriods: {
          numberOfEvaluationPeriods: 1
          minFailingPeriodsToAlert: 1
      }
  }
] : [
  {
      query:alertQuery
      timeAggregation: alertTimeAggregation
      
      dimensions: alertDimensions
      operator: alertOperator
      threshold: alertTreshold
      failingPeriods: {
          numberOfEvaluationPeriods: 1
          minFailingPeriodsToAlert: 1
      }
  }
]
resource alert 'Microsoft.Insights/scheduledQueryRules@2021-08-01' = {
  name: '${targetResourceTypeFriendly}-${alertTreshold}-${alertTimeAggregation}-${alertSev}'
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
    evaluationFrequency: evaluationFreq
    windowSize: windowsSize
    criteria: {
      allOf: allOfCriterias
  }
   
    //muteActionsDuration: muteActionsDuration
    //autoMitigate: autoMitigate
    //checkWorkspaceAlertsStorageConfigured: checkWorkspaceAlertsStorageConfigured
    actions: {
      actionGroups: [
          resourceId(actionGroupRGName, 'Microsoft.Insights/actionGroups', actionGroupsWithNamesAndSeverity[alertSev-1].name) //mutiple Action groups needed ?
      ]
      
    }
  }
}
