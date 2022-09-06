$StorageAccountName = $env:StorageAccountName
$NameContainer = $env:NameContainer
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
                        
            $Diags = Get-AzDiagnosticSettingCategory -TargetResourceId $azResource.id -WarningAction SilentlyContinue -ErrorAction SilentlyContinue 

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

    
#$azSubName = $azSub.Name
#$File = 'GetParamDiag' + $azSubName + '.csv'

$outputObject = $outputObject | Sort-Object 'Typeresource' -Unique 

$outputObject | Export-Csv -Path $env:clientFileNamePrefix"_GetParamDiag.csv" -Delimiter ";" -NoTypeInformation

#Create a context object using Azure AD credentials
#$ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount

#Create a container object
#$container = Get-AzStorageContainer -Name $NameContainer -Context $ctx 

#$containerName = $container.Name

#Upload a single named file
#Set-AzStorageBlobContent -File $File -Container $containerName -Context $ctx



    






    

    