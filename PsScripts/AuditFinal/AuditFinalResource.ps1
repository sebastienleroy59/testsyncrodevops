$Subscription = $env:SubscriptionId


$azSub = Get-AzSubscription -SubscriptionId $Subscription

Set-AzContext $azSub.id | Out-Null

$azResources = Get-AZResource

$azResources | Export-Csv -Path $env:clientFileNamePrefix"_AuditFinalResource.csv" -Delimiter ";" 


