param 
(
    [Parameter(Mandatory=$true,HelpMessage="Pass in the path where deepbluecli.ps1 is")]
        $scriptLocation,
    [Parameter(Mandatory=$true,HelpMessage="Path where log parses should output")]
        $output,
    [Parameter(Mandatory=$true,HelpMessage="Path where event logs are")]
        $source
)

$filter = @('Security.evtx', 'System.evtx', 'Application*.evtx', '*Sysmon*.evtx', '*Windows-Powershell*.evtx')
$eventLogs = Get-ChildItem -Recurse $source -Include $filter
Set-Location $scriptLocation
$output = "$output\Deepblue\"
if (!(Test-Path $output)) {
    New-Item $output -ItemType Directory
}
foreach ($log in $eventLogs) {
    Write-Host $log
    & "$scriptLocation\DeepBlue.ps1" $log | Out-File "$output$($log.Name).txt"
}
Get-ChildItem $output | where {$_.Length -eq 0} | Remove-Item
