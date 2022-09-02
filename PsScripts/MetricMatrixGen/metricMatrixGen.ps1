# $RGs = Get-AzResourceGroup
# $suggestedPercentage = 10
# $exclude = Get-Content -Path PsScripts\MetricMatrixGen\exclude.json | ConvertFrom-JSON
# $outputObject = @()
# $outputObjectVerbose = @()
# foreach ($rg in $RGs) {


#     $resourcesTypesInRG = Get-AzResource -ResourceGroupName $rg.ResourceGroupName | Select-Object -Unique -Property ResourceType -WarningAction SilentlyContinue

    
#     foreach($resourceTypeInRG in $resourcesTypesInRG){
#     $resourcesByTypeInRg = Get-AzResource -ResourceGroupName $rg.ResourceGroupName -ResourceType $resourceTypeInRG.ResourceType -WarningAction SilentlyContinue
#     $isExcludedResource = $exclude.resource | Where-Object {$_ -match $resourceTypeInRG.ResourceType} | Measure-Object
#     write-host "ResourceType In ExludeDico :" $resourceTypeInRG.ResourceType " --- " $isExcludedResource.Count -ForegroundColor Blue
#        if($isExcludedResource.Count -eq 0){
#         foreach ($resource in $resourcesByTypeInRg) {
#             try { 
                
#                 $metrics =  Get-AzMetricDefinition -ResourceId $resource.ResourceId -WarningAction SilentlyContinue  
#                  foreach($metric in $metrics)
#                 {

#                     ##TRESHOLD SUGGESTION##
#                     $metricValOnLastWeek = (Get-AzMetric -ResourceId $resource.ResourceId -TimeGrain 1.00:00:00 -StartTime (Get-Date).AddDays(-7) -AggregationType Average -MetricName $metric.Name.Value).Data | Select-Object Average  -WarningAction SilentlyContinue  
#                     $metricHighestValOnLastWeek = ($metricValOnLastWeek.Average | Measure-Object   -Maximum).Maximum
#                     $suggestedTresholdVal = $metricHighestValOnLastWeek + ($metricHighestValOnLastWeek*$suggestedPercentage) / 100 

#                     $metricSplitted = $metric.ResourceId -split('/')
#                     $propToCheck = $metricSplitted[6]+"/"+$metricSplitted[7].replace(' ','')
                    
                       
#                             $outputObjectVerbose += [PSCustomObject]@{targetResourceName=$resource.Name;resourceRG=$rg.ResourceGroupName;targetResourceType=$resourceTypeInRG.ResourceType;alertDescription="";alertMetricNameSpace=$propToCheck;alertMetricName=$metric.Name.Value;alertSev=1;alertDimensions="";alertOperator="GreaterThanOrEqual";alertTimeAggregation="Average";evaluationFreq="PT5M";windowsSize="PT30M";alertTreshold=$suggestedTresholdVal} ###retreivemtricunit to make it dynamic
                        
#                             $outputObject += [PSCustomObject]@{MtricNamespace=$propToCheck;MetricValue=$metric.Name.Value;Sev=1;EvaluationFreq="PT5M";TimeWindow="PT30M";TresHold="XX";} ###retreivemtricunit to make it dynamic
                        
                    
#                 } 
           
             
#             }
#             catch {
#                Write-Host "Execution finished with an error..." -ForegroundColor Red
                
#             }
#         } 

#     }

#     }
   

# }


# $outputObjectVerbose | Export-Csv -NoTypeInformation $env:clientFileNamePrefix"_verbosMetricMatrix.csv" #verbose csv

# $outputObject | Sort-Object -Property MtricNamespace,MetricValue -Unique | Export-Csv -NoTypeInformation $env:clientFileNamePrefix"_NonVerboseMetricMatrix.csv"

# Get-ChildItem -Recurse 

 