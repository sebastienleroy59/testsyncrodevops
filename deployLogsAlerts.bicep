
param LogsAlertsParams array

module LogAlertResource 'logAlertModule.bicep' =  [for (logAlertsParams,i) in LogsAlertsParams: {
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
      targetResourceType:logAlertsParams.targetResourceType
      alertOperator:logAlertsParams.alertOperator
      alertTimeAggregation:logAlertsParams.alertTimeAggregation
      alertMeasureColumn: !empty(logAlertsParams.alertMeasurecolumn)  ? logAlertsParams.alertMeasurecolumn : null //Metric Measure Column can not be specified on Time Aggregation of Count
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
