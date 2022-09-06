$StorageAccountName = $env:StorageAccountName
$NameContainer = $env:NameContainer
$Subscription = $env:SubscriptionId


$azSub = Get-AzSubscription -SubscriptionId $Subscription

Set-AzContext $azSub.id | Out-Null

$outputObject = @()

#Create a context object using Azure AD credentials
#$ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount

#Create a container object
#$container = Get-AzStorageContainer -Name $NameContainer -Context $ctx 

#$containerName = $container.Name

#$azSubName = $azSub.Name
#$Blob = $env:clientFileNamePrefix + "_GetParamDiag.csv"

#Get-AzStorageBlobContent -Context $ctx -Container $containerName -Blob $Blob -Destination $Blob


$CSV = Import-Csv -Path $env:clientFileNamePrefix"_GetParamDiag.csv" -Delimiter ";"


    foreach ($Type in $CSV) {

        $outputObject2 = @()

        $Azresource = Get-AzResource -ResourceType $Type.Typeresource
        $outputObject2 += [PSCustomObject]@{Logs=$Type.Logs;Metrics=$Type.Metrics}

        foreach ($Resource in $Azresource) {

            $outputObject += [PSCustomObject]@{ResourceName=$Resource.Name -join ',';ResourceId=$Resource.id -join ',';Logs=$outputObject2.Logs -join ',';Metrics=$outputObject2.Metrics -join ','}

        }

    }

$outputObject | Export-Csv -Path $env:clientFileNamePrefix"_MatriceParamDiag.csv" -Delimiter ";" 


#Upload a single named file
#Set-AzStorageBlobContent -File $File -Container $containerName -Context $ctx