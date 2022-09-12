$StorageAccountName = $env:StorageAccountName
$NameContainer = $env:NameContainer
$Subscription = $env:SubscriptionId
$resourceGroupName = $env:resourceGroupName

$azSub = Get-AzSubscription -SubscriptionId $Subscription

Set-AzContext $azSub.id | Out-Null

$ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount

$container = Get-AzStorageContainer -Name $NameContainer -Context $ctx 

$containerName = $container.Name

Get-AzStorageBlobContent -Context $ctx -Container $containerName -Blob $env:clientFileNamePrefix"_MatriceParamDiag.csv" -Destination ".\PsScripts"

$CSV = Import-Csv -Path $env:clientFileNamePrefix"_MatriceParamDiag.csv" -Delimiter ";"

$logWkspcResourceId = Get-AzOperationalInsightsWorkspace -Name 'Supervision' -ResourceGroupName $resourceGroupName | Select-Object ResourceId

    foreach ($Line in $CSV) {

        if([string]::IsNullOrEmpty($Line.Logs)){ 
            $Metrics = $Line.Metrics.split(",")            
            Set-AzDiagnosticSetting -Name $Line.ResourceName -ResourceId $Line.ResourceId -MetricCategory $Metrics -Enabled $True -WorkspaceId $logWkspcResourceId
            Write-Host "Null Logs: " $Line.ResourceName
            
        }
        elseif([string]::IsNullOrEmpty($Line.Metrics)) {

            $Logs = $Line.Logs.split(",")
            Set-AzDiagnosticSetting -Name $Line.ResourceName -ResourceId $Line.ResourceId -Category $Logs -Enabled $True -WorkspaceId $logWkspcResourceId
            Write-Host "Null Metrics: " $Line.ResourceName
            
        }
        else{  
            $DefautLogs = $Line.Logs.split(",")    
            $DefautMetrics = $Line.Metrics.split(",")
            Set-AzDiagnosticSetting -Name $Line.ResourceName -ResourceId $Line.ResourceId -Category $DefautLogs -MetricCategory $DefautMetrics -Enabled $True -WorkspaceId $logWkspcResourceId
            Write-Host "Default: " $Line.ResourceName

        }

    }




        