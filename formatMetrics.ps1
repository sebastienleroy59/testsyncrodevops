param(
    [Parameter(Mandatory=$true)]
    #[ValidatePattern('^[a-zA-Z0-9]+$')]
    [String] $typeOfAlertstoFormat,
    
    [Parameter(Mandatory=$true)]
    #[ValidatePattern('^[a-zA-Z0-9]+$')]
    [String] $baseDir   
)


Write-Host $typeOfAlertstoFormat
Write-Host $baseDir

if($typeOfAlertstoFormat -ne "Activity"){
    $csvFileToConvert=import-csv -Delimiter ";" "AlertsDefinitions/$($typeOfAlertstoFormat)Alerts.csv"
    
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
    write-host "activitylogs deployment"
} 