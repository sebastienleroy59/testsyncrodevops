$StorageAccountName = $env:StorageAccountName
$NameContainer = $env:NameContainer
$Subscription = $env:SubscriptionId
$NameLOg = $env:NameLOg # Nom du LAW
$resourceGroupNameLog = $env:resourceGroupNameLog # RG du LAW
$NameDiagSettingSquadra = "SquadraDiagSetting" # Nom du DiagSetting crée par Squadra
$Path = ".\PsScripts\" + $env:clientFileNamePrefix+"_MatriceParamDiag.csv"
$File = ".\PsScripts\ErrLogs.txt"

$CSV = Import-Csv -Path $Path -Delimiter ";"
$logWkspcResource = Get-AzOperationalInsightsWorkspace -Name $NameLOg -ResourceGroupName $resourceGroupNameLog
$logWkspcResourceId = $logWkspcResource.ResourceId # Recuperation du LAW ID

if(Test-Path -Path $File){ #Si le fichier ErrLogs.txt existe, alors on clean son contenu
    Clear-Content -Path $File
}

foreach ($Line in $CSV) {
    $Error.clear()

    if([string]::IsNullOrEmpty($Line.Logs)){ # S'il n'y a pas de Logs, alors creation/update des Metriques

        Write-Host "Resource : " $Line.ResourceName
        $StrArr = $Line.Metrics.split(",") # On split le string pour créer un tableau
        $Array = @()
        foreach($str in $StrArr){ # On créer un Array qui contient tous les élements
            $Array += New-AzDiagnosticSettingMetricSettingsObject -Enabled $true -Category $str -RetentionPolicyDay 7 -RetentionPolicyEnabled $true
            Write-Host "Metric : " $str
        }

        $DiagSettingClientName = Get-AzDiagnosticSetting -ResourceId $Line.ResourceId # Nom du DiagSettingClient

        if([string]::IsNullOrEmpty($DiagSettingClientName.Name)){ # S'il n'y a pas de DiagSetting crée, alors on le créer
            New-AzDiagnosticSetting -Name "$Line.ResourceName-$NameDiagSettingSquadra" -ResourceId $Line.ResourceId -WorkspaceId $logWkspcResourceId -Metric $Array | Out-Null
            $Error | Out-File $File -Append
            Write-Host "Creation des Metriques --- DiagSettingName : $Line.ResourceName-$NameDiagSettingSquadra"
        }
        else{ # Sinon on update le DiagSetting du client
            New-AzDiagnosticSetting -Name $DiagSettingClientName.Name -ResourceId $Line.ResourceId -WorkspaceId $logWkspcResourceId -Metric $Array | Out-Null
            $Error | Out-File $File -Append
            Write-Host "Creation des Metriques --- DiagSettingName : " $DiagSettingClientName.Name
        }
    }
    elseif([string]::IsNullOrEmpty($Line.Metrics)) { # S'il n'y a pas de Metriques, alors creation/update des Logs

        Write-Host "Resource : " $Line.ResourceName
        $StrArr = $Line.Logs.split(",") # On split le string pour créer un tableau
        $Array = @()
        foreach($str in $StrArr){
            $Array += New-AzDiagnosticSettingLogSettingsObject -Enabled $true -Category $str -RetentionPolicyDay 7 -RetentionPolicyEnabled $true
            Write-Host "Log : " $str
        }
        
        $DiagSettingClientName = Get-AzDiagnosticSetting -ResourceId $Line.ResourceId # Nom du DiagSettingClient

        if([string]::IsNullOrEmpty($DiagSettingClientName.Name)){ # S'il n'y a pas de DiagSetting crée, alors on le créer
            New-AzDiagnosticSetting -Name "$Line.ResourceName-$NameDiagSettingSquadra" -ResourceId $Line.ResourceId -WorkspaceId $logWkspcResourceId -Log $Array | Out-Null
            $Error | Out-File $File -Append
            Write-Host "Creation des Logs --- DiagSettingName : $Line.ResourceName-$NameDiagSettingSquadra"
        }
        else{ # Sinon on update le DiagSetting du client
            New-AzDiagnosticSetting -Name $DiagSettingClientName.Name -ResourceId $Line.ResourceId -WorkspaceId $logWkspcResourceId -Log $Array | Out-Null
            $Error | Out-File $File -Append
            Write-Host "Creation des Logs --- DiagSettingName : " $DiagSettingClientName.Name
        }
    }
    else{  # S'il y a des Metriques et des Logs, alors creation/update des deux.
        
        Write-Host "Resource : " $Line.ResourceName
        $StrArr1 = $Line.Logs.split(",") # On split le string pour créer un tableau
        $StrArr2 = $Line.Metrics.split(",") # On split le string pour créer un tableau
        $Array1 = @()
        $Array2 = @()

        foreach($str in $StrArr1){
            $Array1 += New-AzDiagnosticSettingLogSettingsObject -Enabled $true -Category $str -RetentionPolicyDay 7 -RetentionPolicyEnabled $true 
            Write-Host "Logs : " $str
        }
        foreach($str in $StrArr2){
            $Array2 += New-AzDiagnosticSettingMetricSettingsObject -Enabled $true -Category $str -RetentionPolicyDay 7 -RetentionPolicyEnabled $true
            Write-Host "Metriques : " $str
        }
      
        $DiagSettingClientName = Get-AzDiagnosticSetting -ResourceId $Line.ResourceId # Nom du DiagSettingClient

        if([string]::IsNullOrEmpty($DiagSettingClientName.Name)){ # S'il n'y a pas de DiagSetting crée, alors on le créer
            New-AzDiagnosticSetting -Name $NameDiagSettingSquadra -ResourceId $Line.ResourceId -WorkspaceId $logWkspcResourceId -Log $Array1 -Metric $Array2 | Out-Null
            $Error | Out-File $File -Append
            Write-Host "Creation des Logs + Metriques --- DiagSettingName : $Line.ResourceName-$NameDiagSettingSquadra"
        }
        else{ # Sinon on update le DiagSetting du client
            New-AzDiagnosticSetting -Name $DiagSettingClientName.Name -ResourceId $Line.ResourceId -WorkspaceId $logWkspcResourceId -Log $Array1 -Metric $Array2 | Out-Null
            $Error | Out-File $File -Append
            Write-Host "Creation des Logs + Metriques --- DiagSettingName : " $DiagSettingClientName.Name
        }
    }
}
