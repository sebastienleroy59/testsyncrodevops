param MetricsAlertsParams array
param logsAlertsParams array

/* 
module MetricAlertResource 'metricAlertModule.bicep' = [for (MetricAlertsParams,i) in MetricsAlertsParams: {
name: 'MetricAlertDeployment-${MetricAlertsParams.targetResourceTypeFriendlyName}-${i}'
params: {
    alertDescription:MetricAlertsParams.alertDescription
    alertSev:int(MetricAlertsParams.alertSev)
    eveluationFreq:MetricAlertsParams.eveluationFreq
    windowsSize:MetricAlertsParams.windowsSize
    targetResourceType:MetricAlertsParams.targetResourceType
    targetResourceTypeFriendly:MetricAlertsParams.targetResourceTypeFriendlyName
    targetResourceName:MetricAlertsParams.targetResourceName
    //alertTags:MetricAlertsParams.alertTags
    resourceRG:MetricAlertsParams.resourceRG
    alertTreshold:int(MetricAlertsParams.alertTreshold)
    alertMetricNameSpace:MetricAlertsParams.alertMetricNameSpace
    alertMetricName:MetricAlertsParams.alertMetricName
    alertOperator:MetricAlertsParams.alertOperator
    alertTimeAggregation:MetricAlertsParams.alertTimeAggregation
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
}] */






var measure ='ActivityIterationCount'
module LogAlertResource 'logAlertModule.bicep' =  [for (logAlertsParams,i) in logsAlertsParams: {
  name: 'LogAlertDeployment-${logAlertsParams.targetResourceTypeFriendlyName}-${i}'
  params: {
      alertDescription:''
      alertSev:int(logAlertsParams.alertSev)
      eveluationFreq:logAlertsParams.eveluationFreq
      windowsSize:logAlertsParams.windowsSize
      resourceRG:logAlertsParams.resourceRG
      alertTreshold:int(logAlertsParams.alertTreshold)
      targetResourceTypeFriendly:logAlertsParams.targetResourceTypeFriendlyName
      targetResourceName:logAlertsParams.targetResourceName
      alertOperator:logAlertsParams.alertOperator
      alertTimeAggregation:logAlertsParams.alertTimeAggregation
      alertMeasureColumn: !empty(measure)  ? measure : '' //Metric Measure Column can not be specified on Time Aggregation of Count
      alertQuery:'ADFSandboxActivityRun\n| where Status == "Succeeded"\n| project Status, ActivityName, ResourceId\n| extend resourceName = split(ResourceId, \'/\')[-1]\n| where resourceName =="DF-POCADF-DEV"'
      alertDimensions: !empty(logAlertsParams.alertDimensions) ? [
        {
            name: logAlertsParams.alertDimensions//play with split maybe for multidimensions
            operator: 'Include'
            values: [
                '*'
            ]
        }
    ] : [] 
  }
}]

