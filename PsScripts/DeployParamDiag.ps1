$StorageAccountName = $env:StorageAccountName
$NameContainer = $env:NameContainer
$Subscription = $env:SubscriptionId
$resourceGroupNameLog = $env:resourceGroupNameLog
$NameLOg = $env:NameLOg

$azSub = Get-AzSubscription -SubscriptionId $Subscription

Set-AzContext $azSub.id | Out-Null

$ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount

$container = Get-AzStorageContainer -Name $NameContainer -Context $ctx 

$containerName = $container.Name

Get-AzStorageBlobContent -Context $ctx -Container $containerName -Blob $env:clientFileNamePrefix"_MatriceParamDiag.csv" -Destination ".\PsScripts"

$Path = ".\PsScripts\" + $env:clientFileNamePrefix+"_MatriceParamDiag.csv"

$CSV = Import-Csv -Path $Path -Delimiter ";"

$logWkspcResourceId = Get-AzOperationalInsightsWorkspace -Name $NameLOg -ResourceGroupName $resourceGroupNameLog | Select-Object ResourceId

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




        