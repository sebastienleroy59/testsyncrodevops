$Subscription = $env:SubscriptionId
$rg = $env:rg
$templatePathBICEPST = $env:templatePathBICEPST
$NameClient = $env:NameClient

$azSub = Get-AzSubscription -SubscriptionId $Subscription



Set-AzContext $azSub.id | Out-Null

$outputObject = @()

$azResources = Get-AZResource
    
    foreach ($azResource in $azResources ) {

        if(!$azResource.ResourceType.Contains('microsoft.operationalInsights/querypacks') -and !$azResource.ResourceType.Contains('microsoft.alertsmanagement/smartDetectorAlertRules') -and !$azResource.ResourceType.Contains('Microsoft.Network/networkWatchers') -and !$azResource.ResourceType.Contains('Microsoft.Compute/virtualMachines/extensions') -and !$azResource.ResourceType.Contains('Microsoft.DevTestLab/schedules') -and !$azResource.ResourceType.Contains('microsoft.Insights/actiongroups') -and !$azResource.ResourceType.Contains('Microsoft.Automation/automationAccounts/runbooks') -and !$azResource.ResourceType.Contains('microsoft.insights/activityLogAlerts') -and !$azResource.ResourceType.Contains('Microsoft.Insights/scheduledqueryrules') -and !$azResource.ResourceType.Contains('Microsoft.Maintenance/maintenanceConfigurations') -and !$azResource.ResourceType.Contains('Microsoft.OperationsManagement/solutions') -and !$azResource.ResourceType.Contains('microsoft.insights/metricalerts') -and !$azResource.ResourceType.Contains('Microsoft.ManagedIdentity/userAssignedIdentities') -and !$azResource.ResourceType.Contains('Microsoft.Network/privateDnsZones/virtualNetworkLinks') -and !$azResource.ResourceType.Contains('Microsoft.Web/certificates') -and !$azResource.ResourceType.Contains('microsoft.insights/workbooks') -and !$azResource.ResourceType.Contains('Microsoft.Portal/dashboards')){

            $Diag = Get-AzDiagnosticSettingCategory -TargetResourceId $azResource.id -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

            $outputObject += [PSCustomObject]@{Typeresource=$azResource.ResourceType;Location=$azResource.Location;Name=$Diag.Name -join ',';Category=$Diag.CategoryType -join ','} 
    
        }

    }

$Locations = $outputObject | Select-Object 'Location' -Unique 


    foreach ($Location in $Locations) {

            
        try {
            $templateParameterObject =@{}
            $templateParameterObject += @{'locationSA' = $Location.Location}
            $templateParameterObject += @{'NameClient' = $NameClient}

            New-AzResourceGroupDeployment -ResourceGroupName $rg -TemplateFile $templatePathBICEPST -TemplateParameterObject $templateParameterObject
            Write-Host "Bicep file was deployed in Resource Group : " $rg " for ST : " $Location -ForegroundColor Green
        }
        catch {
           Write-Host "Execution finished with an error..." -ForegroundColor Red
           Write-Host $_

        }

    }
          
            
       

    

