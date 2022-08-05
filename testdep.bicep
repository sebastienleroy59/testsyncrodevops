

module MetricAlertResource 'logAlertModule.bicep' =  {
name: 'ActivtyLogAlertDeployment-ADFPOCKQL'
params: {
    alertDescription:''
    alertSev:1
    eveluationFreq:'PT5M'
    windowsSize:'PT30M'
    resourceRG:'POC-ADF'
   targetResourceTypeFriendly:'ADFPOCKQLTESTFROMTESTRG'
    targetResourceName:'df-pocadf-dev'
    targetResourceType:'Microsoft.DataFactory/factories'
    alertMeasureColumn:'CounterValue'
    alertTreshold:1
    alertOperator:'GreaterThan'
    alertTimeAggregation:'Count'
    alertDimensions:[]
    alertQuery:'ADFSandboxActivityRun\n'
  }
}
