
param logsAlertsParams array


var measure ='ActivityIterationCount'
module LogAlertResource 'logAlertModule.bicep' =  [for (MetricAlertsParams,i) in logsAlertsParams: {
  name: 'LogAlertDeployment-${MetricAlertsParams.targetResourceTypeFriendlyName}-${i}'
  params: {
      alertDescription:''
      alertSev:int(MetricAlertsParams.alertSev)
      eveluationFreq:MetricAlertsParams.eveluationFreq
      windowsSize:MetricAlertsParams.windowsSize
      resourceRG:MetricAlertsParams.resourceRG
      alertTreshold:int(MetricAlertsParams.alertTreshold)
      targetResourceTypeFriendly:'ADFMETRICMEASURETEST'
      targetResourceName:'df-pocadf-dev'
      alertOperator:MetricAlertsParams.alertOperator
      alertTimeAggregation:MetricAlertsParams.alertTimeAggregation
      alertMeasureColumn: !empty(measure)  ? measure : '' //Metric Measure Column can not be specified on Time Aggregation of Count
      alertQuery:'ADFSandboxActivityRun\n| where Status == "Succeeded"\n| project Status, ActivityName, ResourceId\n| extend resourceName = split(ResourceId, \'/\')[-1]\n| where resourceName =="DF-POCADF-DEV"'
      alertDimensions: !empty(MetricAlertsParams.alertDimensions) ? [
        {
            name: MetricAlertsParams.alertDimensions//play with split maybe for multidimensions
            operator: 'Include'
            values: [
                '*'
            ]
        }
    ] : [] 
  }
}]
