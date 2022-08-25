param(
    [Parameter(Mandatory=$true)]
    #[ValidatePattern('^[a-zA-Z0-9]+$')]
    [String] $typeOfAlertstoFormat,
    
    [Parameter(Mandatory=$true)]
    #[ValidatePattern('^[a-zA-Z0-9]+$')]
    [String] $baseDir   
)


write-Host $typeOfAlertstoFormat
#Write-Host $baseDir
$csvFileToConvert=import-csv -Delimiter ";" "AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.csv"
if($typeOfAlertstoFormat -ne "activity"){
    
    
    foreach($alertLine in $csvFileToConvert){
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
    #$formattedAlerts
    ((Get-Content -path "$($baseDir)/AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.json" -Raw) -replace '"--TOREPLACE--"',$formattedAlerts ) | Set-Content -Path "$($baseDir)/AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.json"
    Get-Content -Path "$($baseDir)/AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.json"
}else{
    
    foreach($alertLine in $csvFileToConvert){
    if($alertLine.alertLevels -ne ""){
        $levelsArray=@()
        $levels = $alertLine.alertLevels.Split('|')
    
        foreach($level in $levels){
           # $splittedLevel = $level.Split('|')
            $levelsArray+=$level; 
        }
   
        $alertLine.alertLevels = $levelsArray
        $alertLineIndex = $csvFileToConvert.IndexOf($alertLine)
        $csvFileToConvert[$alertLineIndex].alertLevels= $alertLine.alertLevels 
    }
    }

    $formattedAlerts = $csvFileToConvert | ConvertTo-Json -AsArray -Depth 4
    #$formattedAlerts
    ((Get-Content -path "$($baseDir)/AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.json" -Raw) -replace '"--TOREPLACE--"',$formattedAlerts ) | Set-Content -Path "$($baseDir)/AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.json"
    Get-Content -Path "$($baseDir)/AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.json"
} 