$Subscription = $env:SubscriptionId
$include = Get-Content -Path PsScripts\Audit\includeresourceextension.json | ConvertFrom-JSON


$azSub = Get-AzSubscription -SubscriptionId $Subscription

Set-AzContext $azSub.id | Out-Null

$azResources = Get-AZResource

foreach ($azResource in $azResources ) {

    $isIncludeResource = $include.resource | Where-Object {$_ -match $azResource.ResourceType} | Measure-Object

    if($isIncludeResource.Count -eq 1){

    $azResourcesType = Get-AZResource -ResourceType $azResource.ResourceType

    }

}

$azResourcesType | Export-Csv -Path $env:clientFileNamePrefix"_AuditExtensions.csv" -Delimiter ";" 

