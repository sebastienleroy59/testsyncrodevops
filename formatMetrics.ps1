param(
    [Parameter(Mandatory=$true)]
    #[ValidatePattern('^[a-zA-Z0-9]+$')]
    [String] $typeOfAlertstoFormat
   
)

Write-Host $typeOfAlertstoFormat
#$ResourceGroupName = "$($Prefix)rg"
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

    $formattedAlerts = $csvMetrics | ConvertTo-Json -AsArray -Depth 4
    ((Get-Content -path "AlertsDefinitions/"$typeOfAlertstoFormat"Alerts.json" -Raw) -replace '"--TOREPLACE--"',$formattedAlerts ) | Set-Content -Path "AlertsDefinitions/"$typeOfAlertstoFormat"Alerts.json"
    Get-Content -path "AlertsDefinitions/"$typeOfAlertstoFormat"Alerts.json" -Raw
}else{
    write-host "activitylogs deployment"
}