$StorageAccountName = $env:StorageAccountName
$NameContainer = $env:NameContainer
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
        
        # Save Diagnostic settings report for each Azure Subscription
        #$azSubName = $azSub.Name
        #$Path = '$(System.DefaultWorkingDirectory)'
        #$File = 'AuditParamDiag' + $azSubName + '.csv'

        $azlogs | Export-csv -Path $env:clientFileNamePrefix"_AuditParamDiag.csv" -Delimiter ";" 
    }

    #Create a context object using Azure AD credentials
    #$ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount

    #Create a container object
    #$container = Get-AzStorageContainer -Name $NameContainer -Context $ctx 

    #$containerName = $container.Name

    #Upload a single named file
    #Set-AzStorageBlobContent -File $File -Container $containerName -Context $ctx

