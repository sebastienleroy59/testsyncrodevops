#$StorageAccountName = $env:StorageAccountName
#$NameContainer = $env:NameContainer
$Subscription = '0410a600-1bea-44c9-b7ee-3e4847c6a600'

$azSub = Get-AzSubscription -SubscriptionId $Subscription

Set-AzContext $azSub.id | Out-Null

$outputObject = @()

$azMetriqueV2s = Get-AzMetricAlertRuleV2

    foreach ($azMetriqueV2 in $azMetriqueV2s){        

        #$Criteria = Get-AzMetricAlertRuleV2 | ForEach-Object {Write-Host $_.Name" -- "$_.Criteria.MetricName "---" $_.Criteria.MetricNameSpace "---" $_.Criteria.Threshold}
        
        $outputObject += [PSCustomObject]@{TargetResourceId=$azMetriqueV2.TargetResourceId;Criteria=$azMetriqueV2.Criteria.MetricName;Severity=$azMetriqueV2.Severity;Enabled=$azMetriqueV2.Enabled;EvaluationFrequency=$azMetriqueV2.EvaluationFrequency;WindowSize=$azMetriqueV2.WindowSize;AutoMitigate=$azMetriqueV2.AutoMitigate;Name=$azMetriqueV2.Name}
    }

$outputObject #| Export-Csv -Path $env:clientFileNamePrefix"_AuditAlertRuleV2.csv" -Delimiter ";" 

