$RGs = Get-AzResourceGroup
$suggestedPercentage = 10
$exclude = Get-Content -Path PsScripts\MetricMatrixGen\exclude.json | ConvertFrom-JSON
$outputObject = @()

foreach ($rg in $RGs) {


    $resourcesTypesInRG = Get-AzResource -ResourceGroupName $rg | Select-Object -Unique -Property ResourceType -WarningAction SilentlyContinue

    
    foreach($resourceTypeInRG in $resourcesTypesInRG){
    $resourcesByTypeInRg = Get-AzResource -ResourceGroupName $rg -ResourceType $resourceTypeInRG.ResourceType -WarningAction SilentlyContinue
    ####NO METRICS FOR FOLLOWING RESOURCES TYPES store in json later or do it by api call ?####
    if(!$resourceTypeInRG.ResourceType.Contains('networkSecurityGroups') -and !$resourceTypeInRG.ResourceType.Contains('virtualMachines/extensions') -and !$resourceTypeInRG.ResourceType.Contains('extensions') -and !$resourceTypeInRG.ResourceType.Contains('registries/replications')  -and !$resourceTypeInRG.ResourceType.Contains('virtualNetworkLinks')){ #skip Microsoft.Compute/virtualMachines/extensions
        foreach ($resource in $resourcesByTypeInRg) {
            try {
                write-host $resourceTypeInRG.ResourceType
                $metrics =  Get-AzMetricDefinition -ResourceId $resource.ResourceId -WarningAction SilentlyContinue  
                 foreach($metric in $metrics)
                {

                    ##TRESHOLD SUGGESTION##
                    $metricValOnLastWeek = (Get-AzMetric -ResourceId $resource.ResourceId -TimeGrain 1.00:00:00 -StartTime (Get-Date).AddDays(-7) -AggregationType Average -MetricName $metric.Name.Value).Data | Select-Object Average
                    $metricHighestValOnLastWeek = ($metricValOnLastWeek.Average | Measure-Object   -Maximum).Maximum
                    $suggestedTresholdVal = $metricHighestValOnLastWeek + ($metricHighestValOnLastWeek*$suggestedPercentage) / 100 

                    $metricSplitted = $metric.ResourceId -split('/')
                    $propToCheck = $metricSplitted[6]+"/"+$metricSplitted[7].replace(' ','')
                    $res= ($exclude.PSObject.Properties.Match($propToCheck).count -eq 1 -and $exclude.$propToCheck.Contains($metric.Name.Value) -eq $true )
                    if(!$res){
                        if($verboseOutput){
                            $outputObject += [PSCustomObject]@{targetResourceName=$resource.Name;resourceRG=$rg;targetResourceType=$resourceTypeInRG.ResourceType;alertDescription="";alertMetricNameSpace=$propToCheck;alertMetricName=$metric.Name.Value;alertSev=1;alertDimensions="";alertOperator="GreaterThanOrEqual";alertTimeAggregation="Average";evaluationFreq="PT5M";windowsSize="PT30M";alertTreshold=$suggestedTresholdVal} ###retreivemtricunit to make it dynamic
                        }else{
                            $outputObject += [PSCustomObject]@{MtricNamespace=$propToCheck;MetricValue=$metric.Name.Value;Sev=1;EvaluationFreq="PT5M";TimeWindow="PT30M";TresHold="XX";} ###retreivemtricunit to make it dynamic
                        }
                    }
                } 
           
             
            }
            catch {
                Write-Host "Execution finished with an error..." -ForegroundColor Red
                Write-Host $errors[0]
            }
        } 

    }

    }
   

}


$outputObject | Export-Csv -NoTypeInformation "clientNameVerboseMAtricx.csv" #verbose csv

$outputObject | Sort-Object -Property MtricNamespace,MetricValue -Unique | Export-Csv -NoTypeInformation "clientNameNonVerbosMatrix.csv"

Get-ChildItem -Recurse 

 