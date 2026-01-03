param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]$TargetIP,

    [Parameter(Mandatory=$true, Position=1)]
    [int[]]$Ports,

    [int]$Timeout = 200
)

Write-Host "Iniciando scan em $TargetIP..." -ForegroundColor Cyan

foreach ($Port in $Ports) {
    $TcpClient = New-Object System.Net.Sockets.TcpClient
    $Connect = $TcpClient.BeginConnect($TargetIP, $Port, $null, $null)
    
    # Aguarda o tempo do timeout
    $Wait = $Connect.AsyncWaitHandle.WaitOne($Timeout, $false)
    
    if ($Wait) {
        try {
            $TcpClient.EndConnect($Connect) | Out-Null
            Write-Host "[+] TargetIP: $TargetIP - Port: $Port - OPEN" -ForegroundColor Green
            $TcpClient.Close()
        } catch {
            Write-Host "[-] TargetIP: $TargetIP - Port: $Port - CLOSED" -ForegroundColor Red
        }
    } else {
        Write-Host "[-] TargetIP: $TargetIP - Port: $Port - TIMEOUT" -ForegroundColor Red
    }
    
    $TcpClient.Dispose()
}