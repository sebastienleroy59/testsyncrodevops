$StorageAccountName = $env:StorageAccountName
$NameContainer = $env:NameContainer
$Subscription = $env:SubscriptionId


$azSub = Get-AzSubscription -SubscriptionId $Subscription

Set-AzContext $azSub.id | Out-Null

$azResources = Get-AZResource

$azSubName = $azSub.Name
$File = 'AuditResource' + $azSubName + '.csv'

$azResources | Export-Csv -Path $File -Delimiter ";" 

#Create a context object using Azure AD credentials
$ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount

#Create a container object
$container = Get-AzStorageContainer -Name $NameContainer -Context $ctx 

$containerName = $container.Name

#Upload a single named file
Set-AzStorageBlobContent -File $File -Container $containerName -Context $ctx
