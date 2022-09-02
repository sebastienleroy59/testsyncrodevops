$StorageAccountName = $env:StorageAccountName
$NameContainer = $env:NameContainer
$Subscription = $env:SubscriptionId

$azSub = Get-AzSubscription -SubscriptionId $Subscription

Set-AzContext $azSub.id | Out-Null

$outputObject = @()

$azMetriqueV2s = Get-AzMetricAlertRuleV2

    foreach ($azMetriqueV2 in $azMetriqueV2s){        
        
        $outputObject += [PSCustomObject]@{TargetResourceId=$azMetriqueV2.TargetResourceId;Severity=$azMetriqueV2.Severity;Enabled=$azMetriqueV2.Enabled;EvaluationFrequency=$azMetriqueV2.EvaluationFrequency;WindowSize=$azMetriqueV2.WindowSize;AutoMitigate=$azMetriqueV2.AutoMitigate;Name=$azMetriqueV2.Name}
    }


#$azSubName = $azSub.Name
#$FileV2 = 'AuditAlertRuleV2' + $azSubName + '.csv'

$outputObject | Export-Csv -Path $env:clientFileNamePrefix"_AuditAlertRuleV2.csv" -Delimiter ";" 

#Create a context object using Azure AD credentials
#$ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount

#Create a container object
#$container = Get-AzStorageContainer -Name $NameContainer -Context $ctx 

#$containerName = $container.Name

#Upload a single named file
#Set-AzStorageBlobContent -File $FileV2 -Container $containerName -Context $ctx