$StorageAccountName = $env:StorageAccountName
$NameContainer = $env:NameContainer
$Subscription = $env:SubscriptionId


$azSub = Get-AzSubscription -SubscriptionId $Subscription

Set-AzContext $azSub.id | Out-Null

$outputObject = @()

$azResources = Get-AZResource
    
    foreach ($azResource in $azResources ) {

        $outputObject2 = @()
        $outputObject3 = @()

        if(!$azResource.ResourceType.Contains('microsoft.operationalInsights/querypacks') -and !$azResource.ResourceType.Contains('microsoft.alertsmanagement/smartDetectorAlertRules') -and !$azResource.ResourceType.Contains('Microsoft.Network/networkWatchers') -and !$azResource.ResourceType.Contains('Microsoft.Compute/virtualMachines/extensions') -and !$azResource.ResourceType.Contains('Microsoft.DevTestLab/schedules') -and !$azResource.ResourceType.Contains('microsoft.insights/actiongroups') -and !$azResource.ResourceType.Contains('Microsoft.Insights/actiongroups') -and !$azResource.ResourceType.Contains('Microsoft.Automation/automationAccounts/runbooks') -and !$azResource.ResourceType.Contains('microsoft.insights/activityLogAlerts') -and !$azResource.ResourceType.Contains('Microsoft.Insights/scheduledqueryrules') -and !$azResource.ResourceType.Contains('Microsoft.Maintenance/maintenanceConfigurations') -and !$azResource.ResourceType.Contains('Microsoft.OperationsManagement/solutions') -and !$azResource.ResourceType.Contains('microsoft.insights/metricalerts') -and !$azResource.ResourceType.Contains('Microsoft.ManagedIdentity/userAssignedIdentities') -and !$azResource.ResourceType.Contains('Microsoft.Network/privateDnsZones/virtualNetworkLinks') -and !$azResource.ResourceType.Contains('Microsoft.Web/certificates') -and !$azResource.ResourceType.Contains('microsoft.insights/workbooks') -and !$azResource.ResourceType.Contains('Microsoft.Portal/dashboards')){
                        
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

    
$azSubName = $azSub.Name
$File = 'GetParamDiag' + $azSubName + '.csv'

$outputObject = $outputObject | Sort-Object 'Typeresource' -Unique 

$outputObject | Export-Csv -Path $File -Delimiter ";" 

#Create a context object using Azure AD credentials
$ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount

#Create a container object
$container = Get-AzStorageContainer -Name $NameContainer -Context $ctx 

$containerName = $container.Name

#Upload a single named file
Set-AzStorageBlobContent -File $File -Container $containerName -Context $ctx



    






    

    