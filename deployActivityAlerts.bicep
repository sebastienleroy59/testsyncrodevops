param ActivitiesAlertsParams array

module MetricAlertResource 'activityLogAlertModule.bicep' = [for (ActivityAlertsParam,i) in ActivitiesAlertsParams: {
name: 'MetricAlertDeployment-${ActivityAlertsParam.targetResourceTypeFriendlyName}-${i}'

params: {
    
    alertDescription:'test'
    levels:['Critical','Verbose']
    status:['Succeeded']
    alertSev:int(ActivityAlertsParam.alertSev)
    targetResourceType:'Microsoft.KeyVault/vaults'
    targetResourceTypeFriendly:'${ActivityAlertsParam.targetResourceTypeFriendly}s'
    alertOperationName:'Microsoft.KeyVault/vaults/delete'
    actionGroupRGName:'rg-infra'
   
  }
}] 

