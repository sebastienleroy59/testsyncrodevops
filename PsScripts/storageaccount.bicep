//param SubId string
param nameSA string = 'sup${(locationSA)}${(NameClient)}'
//param nameSA string = 'supervision-${(SubId)}''LocationSA'

param locationSA string 
param NameClient string
param skuname string = 'Standard_LRS'
param kind string = 'StorageV2'


resource SA 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: nameSA 
  location: locationSA
  sku: {
    name: skuname
  }
  kind: kind
}

output namesa string = SA.name
output locationsa string = SA.location
output skusa object = SA.sku
output kindsa string = SA.kind
output propertiessa object = SA.properties
output SAID string = SA.id
