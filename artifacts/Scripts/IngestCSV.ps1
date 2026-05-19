$DcrImmutableId = ${Env:DcrImmutableId}
$DcrIngestionEndpoint = ${Env:DcrIngestionEndpoint}
$StreamName = if ([string]::IsNullOrWhiteSpace(${Env:StreamName})) { "Custom-RawIngest" } else { ${Env:StreamName} }

if ([string]::IsNullOrWhiteSpace($DcrImmutableId) -or [string]::IsNullOrWhiteSpace($DcrIngestionEndpoint)) {
    throw "Environment variables DcrImmutableId and DcrIngestionEndpoint are required."
}

function Get-MonitorAccessToken {
    try {
        $azToken = Get-AzAccessToken -ResourceUrl "https://monitor.azure.com" -ErrorAction Stop
        return $azToken.Token
    }
    catch {
        $imdsUri = "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://monitor.azure.com"
        $imdsToken = Invoke-RestMethod -Method Get -Uri $imdsUri -Headers @{ Metadata = "true" } -ErrorAction Stop
        return $imdsToken.access_token
    }
}

function Send-LogsIngestionChunk {
    param(
        [Parameter(Mandatory = $true)]
        [array]$Records
    )

    $token = Get-MonitorAccessToken
    $uri = "{0}/dataCollectionRules/{1}/streams/{2}?api-version=2023-01-01" -f $DcrIngestionEndpoint.TrimEnd('/'), $DcrImmutableId, $StreamName
    $headers = @{ Authorization = "Bearer $token" }
    $body = $Records | ConvertTo-Json -Depth 20

    Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -ContentType "application/json" -Body $body -ErrorAction Stop | Out-Null
    return 204
}

function Convert-ToIngestionRecord {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$CsvRecord,
        [Parameter(Mandatory = $true)]
        [string]$SourceTable,
        [Parameter(Mandatory = $true)]
        [string]$SourceFile
    )

    return [pscustomobject]@{
        TimeGenerated = (Get-Date).ToUniversalTime().ToString("o")
        SourceTable   = $SourceTable
        SourceFile    = $SourceFile
        Record        = $CsvRecord
    }
}

function SendToLogA {
    param(
        [Parameter(Mandatory = $true)]
        [string]$url,
        [Parameter(Mandatory = $true)]
        [string]$eventsTable
    )

    $tempPath = Join-Path -Path $PWD -ChildPath "query_data.csv"

    try {
        Invoke-WebRequest -Uri $url -OutFile $tempPath -ErrorAction Stop
        $eventsData = Import-Csv $tempPath

        if ($null -eq $eventsData -or $eventsData.Count -eq 0) {
            Write-Host "No rows found in $url"
            return 204
        }

        $records = @()
        foreach ($row in $eventsData) {
            $records += Convert-ToIngestionRecord -CsvRecord $row -SourceTable $eventsTable -SourceFile ([System.IO.Path]::GetFileName($url))
        }

        $batchSize = 500
        for ($i = 0; $i -lt $records.Count; $i += $batchSize) {
            $endIndex = [Math]::Min($i + $batchSize - 1, $records.Count - 1)
            $chunk = $records[$i..$endIndex]
            $status = Send-LogsIngestionChunk -Records $chunk
            Write-Host "Sent $($chunk.Count) records from $eventsTable (status: $status)"
        }

        return 204
    }
    finally {
        if (Test-Path $tempPath) {
            Remove-Item $tempPath -Force
        }
    }
}

# Define the base URL as a variable
$BaseUrl = "https://raw.githubusercontent.com/msjpn-smecc-azure/handson-sentinel/refs/heads/features/sampledataingest"

$status = SendToLogA -url "$BaseUrl/artifacts/Telemetry/securityEvents.csv" -EventsTable "SecurityEvent"
Write-Host $status

$status = SendToLogA -url "$BaseUrl/artifacts/Telemetry/disable_accounts.csv" -EventsTable "SigninLogs"
Write-Host $status

$status = SendToLogA -url "$BaseUrl/artifacts/Telemetry/office_activity_inbox_rule.csv" -EventsTable "OfficeActivity"
Write-Host $status

$status = SendToLogA -url "$BaseUrl/artifacts/Telemetry/azureActivity_adele.csv" -EventsTable "AzureActivity"
Write-Host $status

$status = SendToLogA -url "$BaseUrl/artifacts/Telemetry/office_activity.csv" -EventsTable "OfficeActivity"
Write-Host $status

$status = SendToLogA -url "$BaseUrl/artifacts/Telemetry/sign-in_adelete.csv" -EventsTable "SigninLogs"
Write-Host $status

$status = SendToLogA -url "$BaseUrl/artifacts/Telemetry/model_evasion_detection_CL_alerts.csv" -EventsTable "OfficeActivity"
Write-Host $status

$status = SendToLogA -url "$BaseUrl/artifacts/Telemetry/solarigate-beacon-umbrella.csv" -EventsTable "Cisco_Umbrella_dns"
Write-Host $status

$status = SendToLogA -url "$BaseUrl/artifacts/Telemetry/AuditLogs_Hunting.csv" -EventsTable "AuditLogs"
Write-Host $status
