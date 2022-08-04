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
param alertMetricNameSpace string=''
param alertMetricName string=''
param alertOperator string=''
param alertTimeAggregation string=''
param alertDimensions array
//param alertTags object
var actionGroupRGName = 'supervisionbiceppoc'

resource metricAlertResource 'microsoft.insights/metricAlerts@2018-03-01' ={
    name: '${targetResourceTypeFriendly}-${targetResourceName}-${alertSev}'
    location: 'Global'
    //tags:alertTags
    properties: {
      severity: alertSev
      enabled: true
      scopes: [
        resourceId(resourceRG,targetResourceType, targetResourceName)
      ]
      evaluationFrequency: eveluationFreq
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
          actionGroupId: resourceId(actionGroupRGName, 'Microsoft.Insights/actionGroups', actionGroupsWithNamesAndSeverity[alertSev-1]) //mutiple Action groups needed ?
          webHookProperties: {
          }
        }
      ]
      description:alertDescription
    }
  }
 
 
