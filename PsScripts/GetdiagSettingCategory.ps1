$Subscription = $env:SubscriptionId
$exclude = Get-Content -Path PsScripts\excluderesourcediag.json | ConvertFrom-JSON


$azSub = Get-AzSubscription -SubscriptionId $Subscription

Set-AzContext $azSub.id | Out-Null

$outputObject = @()

$azResources = Get-AZResource
    
    foreach ($azResource in $azResources ) {

        $outputObject2 = @()
        $outputObject3 = @()

        $isExcludedResource = $exclude.resource | Where-Object {$_ -match $azResource.ResourceType} | Measure-Object

        if($isExcludedResource.Count -eq 0){
                        
            $Diags = Get-AzDiagnosticSettingCategory -ResourceId $azResource.id -WarningAction SilentlyContinue -ErrorAction SilentlyContinue 

                foreach ($Diag in $Diags) {

                    if ($Diag.CategoryType -eq "Logs") {
                        $outputObject2 += [PSCustomObject]@{Logs = $Diag.Name -join ','}
                    }

                    else {
                        $outputObject3 = @()
                        $outputObject3 += [PSCustomObject]@{Metrics = $Diag.Name}
                    }

                }

            $outputObject += [PSCustomObject]@{Typeresource=$azResource.ResourceType;Logs = $outputObject2.Logs -join ',';Metrics = $outputObject3.Metrics -join ','}

        }

    }

$outputObject = $outputObject | Sort-Object 'Typeresource' -Unique 

$outputObject | Export-Csv -Path $env:clientFileNamePrefix"_GetParamDiag.csv" -Delimiter ";" -NoTypeInformation





    






    

    