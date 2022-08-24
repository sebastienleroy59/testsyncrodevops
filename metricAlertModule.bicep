
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
param alertMetricNameSpace string=''
param alertMetricName string=''
param alertOperator string=''
param alertTimeAggregation string=''
param alertDimensions array
//param alertTags object
var actionGroupRGName = 'rg-infra'

resource metricAlertResource 'microsoft.insights/metricAlerts@2018-03-01' ={
  //name: '${targetResourceTypeFriendly}-${targetResourceName}-${alertTimeAggregation}-${alertSev}'
    name: '${targetResourceTypeFriendly}-${alertTreshold}-${alertTimeAggregation}-${alertSev}'
    location: 'Global'
    //tags:alertTags
    properties: {
      severity: alertSev-1
      enabled: true
      scopes: [
        resourceId(resourceRG,targetResourceType, targetResourceName)
      ]
      evaluationFrequency: evaluationFreq
      windowSize: windowsSize
      criteria: {
        allOf: [
          {
            threshold: alertTreshold
            name: 'Metric1'
            metricNamespace: alertMetricNameSpace
            metricName: alertMetricName
            operator: alertOperator
            dimensions: alertDimensions
            timeAggregation: alertTimeAggregation
            criterionType: 'StaticThresholdCriterion'
          }
        ]
        'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      }
      autoMitigate: true
      targetResourceType: targetResourceType
      actions: [
        {
          actionGroupId: resourceId(actionGroupRGName, 'Microsoft.Insights/actionGroups', actionGroupsWithNamesAndSeverity[alertSev-1].name) //mutiple Action groups needed ?
          webHookProperties: {
          }
        }
      ]
      description:alertDescription
    }
  }
 
 
