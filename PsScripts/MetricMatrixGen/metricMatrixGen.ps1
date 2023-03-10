$RGs = Get-AzResourceGroup
$suggestedPercentage = 10
$exclude = Get-Content -Path "PsScripts\MetricMatrixGen\exclude.json" | ConvertFrom-JSON
$outputObject = @()
$outputObjectVerbose = @()
foreach ($rg in $RGs) {


    $resourcesTypesInRG = Get-AzResource -ResourceGroupName $rg.ResourceGroupName | Select-Object -Unique -Property ResourceType -WarningAction SilentlyContinue

    
    foreach($resourceTypeInRG in $resourcesTypesInRG){
    $resourcesByTypeInRg = Get-AzResource -ResourceGroupName $rg.ResourceGroupName -ResourceType $resourceTypeInRG.ResourceType -WarningAction SilentlyContinue
    $isExcludedResource = $exclude.resource | Where-Object {$_ -match $resourceTypeInRG.ResourceType} | Measure-Object
    write-host "ResourceType In ExludeDico :" $resourceTypeInRG.ResourceType " --- " $isExcludedResource.Count -ForegroundColor Blue
       if($isExcludedResource.Count -eq 0){
        foreach ($resource in $resourcesByTypeInRg) {
            try { 
                
                $metrics =  Get-AzMetricDefinition -ResourceId $resource.ResourceId -WarningAction SilentlyContinue 
                Write-Host "Resource : " $resource.Name  "---" " ResourceType: " $resource.ResourceType "---" " MetricDefName: " $metrics.Name  
                 foreach($metric in $metrics)
                {

                    ##TRESHOLD SUGGESTION##
                    $metricValOnLastWeek = (Get-AzMetric -ResourceId $resource.ResourceId -TimeGrain 1.00:00:00 -StartTime (Get-Date).AddDays(-7) -AggregationType Average -MetricName $metric.Name.Value).Data | Select-Object Average  -WarningAction SilentlyContinue
                    Write-Host "Resource : " $resource.Name  "---" " ResourceType: " $resource.ResourceType "---" " MetricName: " $metric.Name  
                    $metricHighestValOnLastWeek = ($metricValOnLastWeek.Average | Measure-Object   -Maximum).Maximum
                    $suggestedTresholdVal = $metricHighestValOnLastWeek + ($metricHighestValOnLastWeek*$suggestedPercentage) / 100 

                    $metricSplitted = $metric.ResourceId -split('/')
                    $propToCheck = $metricSplitted[6]+"/"+$metricSplitted[7].replace(' ','')
                    
                       
                            $outputObjectVerbose += [PSCustomObject]@{MetricNamespace=$propToCheck;targetResourceName=$resource.Name;targetResourceTypeFriendlyName=$resource.Name.Substring(0,3);resourceRG=$rg.ResourceGroupName;targetResourceType=$resourceTypeInRG.ResourceType;alertDescription="";alertMetricNameSpace=$propToCheck;alertMetricName=$metric.Name.Value;alertSev=1;alertDimensions="";alertOperator="GreaterThanOrEqual";alertTimeAggregation="Average";evaluationFreq="PT5M";windowsSize="PT30M";alertTreshold=[math]::Round($suggestedTresholdVal)} ###retreivemtricunit to make it dynamic
                        
                            $outputObject += [PSCustomObject]@{MetricNamespace=$propToCheck;MetricValue=$metric.Name.Value;Sev=1;EvaluationFreq="PT5M";TimeWindow="PT30M";TresHold="XX";} ###retreivemtricunit to make it dynamic
                        
                    
                } 
           
             
            }
            catch {
               Write-Host "Execution finished with an error..." -ForegroundColor Red
                
            }
        } 

    }

    }
   

}


$outputObjectVerbose | Export-Csv -NoTypeInformation $env:clientFileNamePrefix"_verboseMetricMatrix.csv" -Delimiter ";" #verbose csv

$outputObject | Sort-Object -Property MetricNamespace,MetricValue -Unique | Export-Csv -NoTypeInformation $env:clientFileNamePrefix"_NonVerboseMetricMatrix.csv"  -Delimiter ";" 

Get-ChildItem -Recurse 

 