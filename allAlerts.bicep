param MetricsAlertsParams array

module MetricAlertResource 'metricAlertModule.bicep' = [for (MetricAlertsParams,i) in MetricsAlertsParams: {
name: 'ActivtyLogAlertDeployment-${MetricAlertsParams.targetResourceTypeFriendlyName}-${i}'
params: {
    alertDescription:MetricAlertsParams.alertDescription
    alertSev:MetricAlertsParams.alertSev
    eveluationFreq:MetricAlertsParams.eveluationFreq
    windowsSize:MetricAlertsParams.windowsSize
    targetResourceType:MetricAlertsParams.targetResourceType
    targetResourceTypeFriendly:MetricAlertsParams.targetResourceTypeFriendlyName
    targetResourceName:MetricAlertsParams.targetResourceName
    //alertTags:MetricAlertsParams.alertTags
    resourceRG:MetricAlertsParams.resourceRG
    alertTreshold:MetricAlertsParams.alertTreshold
    alertMetricNameSpace:MetricAlertsParams.alertMetricNameSpace
    alertMetricName:MetricAlertsParams.alertMetricName
    alertOperator:MetricAlertsParams.alertOperator
    alertTimeAggregation:MetricAlertsParams.alertTimeAggregation
    alertDimensions:MetricAlertsParams.alertDimensions
  }
}]