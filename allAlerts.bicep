param MetricsAlertsParams array

module MetricAlertResource 'metricAlertModule.bicep' = [for (MetricAlertsParams,i) in MetricsAlertsParams: {
name: 'ActivtyLogAlertDeployment-${MetricAlertsParams.targetResourceTypeFriendlyName}-${i}'
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
    alertDimensions: [
                {
                    name: MetricAlertsParams.alertDimensions
                    operator: 'Include'
                    values: [
                        '*'
                    ]
                }
            ] //play with split maybe for multidimensions
  }
}]