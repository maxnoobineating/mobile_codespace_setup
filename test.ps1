$ClipPath_host=$(Join-Path $PWD.PATH "clipboard.txt")
$ClipExePath="C:\Windows\System32\clip.exe"

# while ($true) {
#     # Get-Content $ClipPath_host
#     Get-Content $ClipPath_host | & $ClipExePath
#     # Wait a short interval before checking again (adjust as needed)
#     Start-Sleep -Seconds 1
# }

$lastWriteFile = Get-Item $ClipPath_host
while ($true) {
    Start-Sleep -Seconds 1
    $currentWriteFile = Get-Item $ClipPath_host
    if ($currentWriteFile.LastWriteTime.ticks -ne $lastWriteFile.LastWriteTime.ticks) {
        Get-Content $currentWriteFile 
        $lastWriteFile = $currentWriteFile
    }
}