$Subscription = $env:SubscriptionId
$rg = $env:resourceGroupName
$templatePathBICEPST = $env:templatePathBICEPST
$NameClient = $env:clientName

$exclude = Get-Content -Path PsScripts\excluderesourcediag.json | ConvertFrom-JSON

$azSub = Get-AzSubscription -SubscriptionId $Subscription



Set-AzContext $azSub.id | Out-Null

$outputObject = @()

$azResources = Get-AZResource
    
    foreach ($azResource in $azResources ) {

        $isExcludedResource = $exclude.resource | Where-Object {$_ -match $azResource.ResourceType} | Measure-Object

        if($isExcludedResource.Count -eq 0){

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
          
            
       

    

