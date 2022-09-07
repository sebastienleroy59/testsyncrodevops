$StorageAccountName = $env:StorageAccountName
$NameContainer = $env:NameContainer
$Subscription = $env:SubscriptionId

$azSub = Get-AzSubscription -SubscriptionId $Subscription

Set-AzContext $azSub.id | Out-Null

$outputObject = @()

$azMetriqueV2s = Get-AzMetricAlertRuleV2

    foreach ($azMetriqueV2 in $azMetriqueV2s){        
        
        $outputObject += [PSCustomObject]@{TargetResourceId=$azMetriqueV2.TargetResourceId;CriteriaMetricName=$azMetriqueV2.Criteria.MetricName;CriteriaOperator=$azMetriqueV2.Criteria.OperatorProperty;CriteriaThreshold=$azMetriqueV2.Criteria.Threshold;Severity=$azMetriqueV2.Severity;Enabled=$azMetriqueV2.Enabled;EvaluationFrequency=$azMetriqueV2.EvaluationFrequency;WindowSize=$azMetriqueV2.WindowSize;AutoMitigate=$azMetriqueV2.AutoMitigate;Name=$azMetriqueV2.Name}
    }




$outputObject | Export-Csv -Path $env:clientFileNamePrefix"_AuditFinalAlertRuleV2.csv" -Delimiter ";" 
