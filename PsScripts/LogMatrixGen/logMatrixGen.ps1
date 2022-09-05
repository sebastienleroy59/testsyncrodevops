#Créer une matrice CSV où l'on récupère les ressources de la subscription, puis on y ajoute les KQL logs associés (voir DicoLogs.json)

## On converti notre JSON en Array dans une variable $Logs
$Logs = Get-Content -Raw PsScripts\LogMatrixGen\Queries.json | ConvertFrom-Json

$outputObject = @()

## On récupère tous les resources de notre subscription
$Resources = Get-AzResource

## Boucle sur les resources de la subscription
foreach($Resource in $Resources){
    $ResourceType = Get-AzResource -ResourceId $Resource.Id
    
    ## Boucle sur élements du JSON
    foreach($Log in $Logs){
        
        ## Si Le nom de la TypeResource et égal au nom de la clé Resource du JSON, alors :
        if($ResourceType.ResourceType -eq $Log.resource){
            $index = $Logs.resource.IndexOf($Log.resource)
            Write-Host $Log.resource
            
            ## Boucle sur la taille de la query de la resource en question
            for ($i=0; $i -lt $Logs[$index].queries.Length; $i++){
                $outputObject += [PSCustomObject]@{
                    targetResourceName = $Resource.Name
                    ResourceRG = $Resource.ResourceGroupName
                    targetResourceType = $ResourceType.ResourceType
                    targetResourceTypeFriendlyName = ""
                    alertDescription = ""
                    alertSev = 1
                    alertOperator = "GreaterThanOrEqual"
                    alertTimeAggregation = "Total"
                    evaluationFreq = "PT1M"
                    windowsSize = "PT5M"
                    alertTreshold = ""
                    alertDimensions = ""
                    alertMeasureColumn = ""
                    alertQuery = $Logs[$index].queries[$i] -join ","
                }
            }
        }
    }
}


## Export en CSV
$outputObject | Export-Csv -Path $env:clientFileNamePrefix"_MatriceLogsKQL.csv" -Delimiter ";" -NoTypeInformation
