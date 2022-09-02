$logWkspcResourceId = $env:logWkspcResourceId
$StorageAccountName = $env:StorageAccountName
$NameContainer = $env:NameContainer
$Subscription = $env:SubscriptionId

$azSub = Get-AzSubscription -SubscriptionId $Subscription

Set-AzContext $azSub.id | Out-Null

$ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount

$container = Get-AzStorageContainer -Name $NameContainer -Context $ctx 

$containerName = $container.Name

$azSubName = $azSub.Name

$Blob = 'MatriceParamDiag' + $azSubName + '.csv'

Get-AzStorageBlobContent -Context $ctx -Container $containerName -Blob $Blob -Destination $Blob 

$CSV = Import-Csv -Path "./_InternalTooling/DiagnosticSettingsAudit/$Blob" -Delimiter ";"

$CSV

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




        