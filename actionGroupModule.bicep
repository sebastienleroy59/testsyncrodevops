param squadraMail string=''
param squadraMailName string=''
param squadraPhoneNr string=''
param actionGroupName string=''
param actionGroupShortName string=''
resource symbolicname 'Microsoft.Insights/actionGroups@2022-06-01' = {
  name: actionGroupName
  location: 'global'
/*   tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  } */
  properties: {
    groupShortName:actionGroupShortName
    emailReceivers: [
      {
        emailAddress: squadraMail
        name: squadraMailName
        useCommonAlertSchema: true
      }
      
    ]
    voiceReceivers: !(empty(squadraPhoneNr)) ? [
      {
         countryCode: '1'
         name:'Astreinte'
         phoneNumber:squadraPhoneNr //only US phones prefix supported
      }
    ]:null
    enabled: true
    
  }
}
