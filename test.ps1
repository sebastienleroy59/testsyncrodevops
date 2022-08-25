$csvFileToConvert=import-csv -Delimiter ";" "AlertsDefinitions/activityAlerts.csv"
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

    $csvFileToConvert