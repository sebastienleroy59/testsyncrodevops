var actionGroupPrefix = 'Squadra'
var actionGroupShortPrefix ='SQDR'
var actionGroupSevSuffixes = ['Critical','Error','Warning','Informational']//find a way to pass as var to modules
var squadraMail = 'support@squa.com'
var squadraPhone = '34444444'
var squadraMailName = 'SquadraMail'
module LogAlertResource 'actionGroupModule.bicep' =  [for (actionGroupSevSuffix,i) in actionGroupSevSuffixes: {
  name: '${actionGroupPrefix}-${actionGroupSevSuffix}-${i}'
  params: {
      actionGroupName:'${actionGroupPrefix}-${actionGroupSevSuffix}'
      actionGroupShortName:'${actionGroupShortPrefix}-${substring(actionGroupSevSuffix,0,3)}'
      squadraMail:squadraMail
      squadraMailName:squadraMailName
      squadraPhoneNr: (actionGroupSevSuffix == 'Critical') ?  squadraPhone : ''
  }
}]
