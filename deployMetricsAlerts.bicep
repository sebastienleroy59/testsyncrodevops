param MetricsAlertsParams array

module MetricAlertResource 'BicepModules/metricAlertModule.bicep' = [for (MetricAlertsParams,i) in MetricsAlertsParams: {
name: 'MetricAlertDeployment-${MetricAlertsParams.targetResourceTypeFriendlyName}-${i}'
params: {
    alertDescription:MetricAlertsParams.alertDescription
    alertSev:int(MetricAlertsParams.alertSev)
    evaluationFreq:MetricAlertsParams.evaluationFreq
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
    actionGroupRGName:'rg-infra'
    alertDimensions: !empty(MetricAlertsParams.alertDimensions) ? MetricAlertsParams.alertDimensions : [] 
  }
}] 

