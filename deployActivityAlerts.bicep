param ActivitiesAlertsParams array

module MetricAlertResource 'activityLogAlertModule.bicep' = [for (ActivityAlertsParam,i) in ActivitiesAlertsParams: {
name: 'MetricAlertDeployment-${ActivityAlertsParam.targetResourceTypeFriendlyName}-${i}'

params: {
    
    alertDescription:'test'
    levels:['Critical','Verbose']
    status:[]
    alertSev:1//used for actiongroup
    targetResourceType:ActivityAlertsParam.targetResourceType
    //targetResourceType:'microsoft.datafactory/factories'
    targetResourceTypeFriendly:ActivityAlertsParam.targetResourceTypeFriendlyName
    //targetResourceTypeFriendly:'ADFACTIV'
    targetResourceScope:ActivityAlertsParam.targetResourceScope
    alertOperationName:ActivityAlertsParam.alertOperationName
    //alertOperationName:'Microsoft.DataFactory/factories/write'
    
   
  }
}] 

