param(
    [Parameter(Mandatory=$true)]
    #[ValidatePattern('^[a-zA-Z0-9]+$')]
    [String] $typeOfAlertstoFormat,
    
    [Parameter(Mandatory=$true)]
    #[ValidatePattern('^[a-zA-Z0-9]+$')]
    [String] $baseDir,
    
    [Parameter(Mandatory=$true)]
    #[ValidatePattern('^[a-zA-Z0-9]+$')]
    [String] $csvFilePath   
)


write-Host $typeOfAlertstoFormat - $csvFilePath

$csvFileToConvert=import-csv -Delimiter ";" $csvFilePath
$csvFileToConvert
if($typeOfAlertstoFormat -ne "activity"){
    
    
    foreach($alertLine in $csvFileToConvert){ ###DANS LE CSV Status|Exclude|test!test2!test3,ActivityName|Include|*;
        if($alertLine.alertDimensions -ne ""){
            $dimensionsArray=@()
            $dimensions = $alertLine.alertDimensions.Split(',')
        
            foreach($dimension in $dimensions){
                $splittedDimension = $dimension.Split('|')
                $dimensionsArray+=@{name = $splittedDimension[0];  operator = $splittedDimension[1]; values = ($splittedDimension[2] -ne "") ? @($splittedDimension[2].split('!')):"*" } 
            }
       
            $alertLine.alertDimensions = $dimensionsArray
            $alertLineIndex = $csvFileToConvert.IndexOf($alertLine)
            $csvFileToConvert[$alertLineIndex].alertDimensions= $alertLine.alertDimensions 
        }
    }
    
    $formattedAlerts = $csvFileToConvert | ConvertTo-Json -AsArray -Depth 4

    ((Get-Content -path "$($baseDir)/AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.json" -Raw) -replace '"--TOREPLACE--"',$formattedAlerts ) | Set-Content -Path "$($baseDir)/AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.json"
    Get-Content -Path "$($baseDir)/AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.json"
}else{
    
    foreach($alertLine in $csvFileToConvert){
        if($alertLine.alertLevels -ne ""){
            $levelsArray= $alertLine.alertLevels.Split('|')
            $alertLine.alertLevels = $levelsArray
        }
        if($alertLine.alertStatus -ne ""){
            $statusArray= $alertLine.alertStatus.Split('|')
            $alertLine.alertStatus = $statusArray
        }
    
    }

    $formattedAlerts = $csvFileToConvert | ConvertTo-Json -AsArray -Depth 4
    ((Get-Content -path "$($baseDir)/AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.json" -Raw) -replace '"--TOREPLACE--"',$formattedAlerts ) | Set-Content -Path "$($baseDir)/AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.json"
    Get-Content -Path "$($baseDir)/AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.json"
} 