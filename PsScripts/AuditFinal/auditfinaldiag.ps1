$Subscription = $env:SubscriptionId



$azSub = Get-AzSubscription -SubscriptionId $Subscription
# Loop through all Azure Subscriptions

Set-AzContext $azSub.id | Out-Null

    $azlogs = @()

    # Get all Azure resources deployed in each Subscription
    $azResources = Get-AZResource

    # Get all Azure resources which have Diagnostic settings enabled and configured
    foreach ($azResource in $azResources) {

        $resourceId     = $azResource.ResourceId
        $azDiagSettings = Get-AzDiagnosticSetting -ResourceId $resourceId `
        -WarningAction SilentlyContinue -ErrorAction SilentlyContinue | Where-Object {$_.Id -ne $NULL}

        foreach ($azDiag in $azDiagSettings) {
            If ($azDiag.StorageAccountId) {
                [string]$storage = $azDiag.StorageAccountId
                [string]$storageAccount = $storage.Split('/')[-1]
            }
            If ($azDiag.WorkspaceId) {
                [string]$workspace = $azDiag.WorkspaceId
                [string]$logAnalytics = $workspace.Split('/')[-1]
            }
            If ($azDiag.EventHubAuthorizationRuleId) {
                [string]$eHub = $azDiag.EventHubAuthorizationRuleId
                [string]$eventHub = $eHub.Split('/')[-3]
            }
            [string]$resource     = $azDiag.id
            [string]$resourceName = $resource.Split('/')[-5]

            $azlogs += [PSCustomObject]@{DiagName = $azDiag.Name;ResourceName=$resourceName;Logs=$azDiag.Logs.Category -join ',';Metrics=$azDiag.Metrics.Category -join ',';StorageAccountName=$storageAccount;LogAnalytics=$logAnalytics;EventHub=$eventHub}
            
        }
        

        $azlogs | Export-csv -Path $env:clientFileNamePrefix"_AuditfinalParamDiag.csv" -Delimiter ";" 
    }


