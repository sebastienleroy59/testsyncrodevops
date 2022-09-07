$StorageAccountName = $env:StorageAccountName
$NameContainer = $env:NameContainer
$Subscription = $env:SubscriptionId


$azSub = Get-AzSubscription -SubscriptionId $Subscription

Set-AzContext $azSub.id | Out-Null

$outputObject = @()

$CSV = Import-Csv -Path $env:clientFileNamePrefix"_GetParamDiag.csv" -Delimiter ";"


    foreach ($Type in $CSV) {

        $outputObject2 = @()

        $Azresource = Get-AzResource -ResourceType $Type.Typeresource
        $outputObject2 += [PSCustomObject]@{Logs=$Type.Logs;Metrics=$Type.Metrics}

        foreach ($Resource in $Azresource) {

            $outputObject += [PSCustomObject]@{ResourceName=$Resource.Name -join ',';ResourceId=$Resource.id -join ',';Logs=$outputObject2.Logs -join ',';Metrics=$outputObject2.Metrics -join ','}

        }

    }

$outputObject | Export-Csv -Path $env:clientFileNamePrefix"_MatriceParamDiag.csv" -Delimiter ";" 
