
param LogsAlertsParams array

module LogAlertResource 'BicepModules/logAlertModule.bicep' =  [for (logAlertsParams,i) in LogsAlertsParams: {
  name: 'LogAlertDeployment-${logAlertsParams.targetResourceTypeFriendlyName}-${i}'
  params: {
      alertDescription:''
      alertSev:int(logAlertsParams.alertSev)
      evaluationFreq:logAlertsParams.evaluationFreq
      windowsSize:logAlertsParams.windowsSize
      resourceRG:logAlertsParams.resourceRG
      alertTreshold:int(logAlertsParams.alertTreshold)
      targetResourceTypeFriendly:logAlertsParams.targetResourceTypeFriendlyName
      targetResourceName:logAlertsParams.targetResourceName
      targetResourceType:logAlertsParams.targetResourceType
      alertOperator:logAlertsParams.alertOperator
      alertTimeAggregation:logAlertsParams.alertTimeAggregation
      alertMeasureColumn: !empty(logAlertsParams.alertMeasurecolumn)  ? logAlertsParams.alertMeasurecolumn : '' //Metric Measure Column can not be specified on Time Aggregation of Count
      alertQuery:logAlertsParams.alertQuery
      actionGroupRGName:'rg-infra'
      alertDimensions: !empty(logAlertsParams.alertDimensions) ? logAlertsParams.alertDimensions : [] 
  }
}]
