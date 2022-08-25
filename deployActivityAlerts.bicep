param ActivitiesAlertsParams array

module MetricAlertResource 'activityLogAlertModule.bicep' = [for (ActivityAlertsParam,i) in ActivitiesAlertsParams: {
name: 'MetricAlertDeployment-${ActivityAlertsParam.targetResourceTypeFriendly}-${i}'

params: {
    
    alertDescription:'test'
    alertLevels:ActivityAlertsParam.alertLevels
    alertStatus:ActivityAlertsParam.alertStatus
    alertSev:int(ActivityAlertsParam.alertSev)
    targetResourceType:'Microsoft.KeyVault/vaults'
    targetResourceTypeFriendly:'${ActivityAlertsParam.targetResourceTypeFriendly}s'
    alertOperationName:'Microsoft.KeyVault/vaults/delete'
    actionGroupRGName:'rg-infra'
   
  }
}] 

