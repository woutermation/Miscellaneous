# Change mabsserver name(s) and/or s

$sourceFolder = "\\mabsserver\c$\Program Files\Microsoft Azure Backup Server\DPM\DPM\ProtectionAgents\RA\13.0.415.0\amd64"
$mabsServer = "mabs.local"
$installFilename = "DPMAgentInstaller_KB5004579_AMD64.exe"
$agentTempFolder = "C:\MABS-Agent"

$mabsAgentLocation = "C:\Program Files\Microsoft Data Protection Manager\DPM\bin" # do not change

Write-Host "Create folder $($agentTempFolder)"
New-Item -ItemType Directory -Path $agentTempFolder -ErrorAction SilentlyContinue
Write-Host "Copy files"
Copy-Item "$($sourceFolder)\*" -Destination $agentTempFolder -Force

Write-Host "Install agent from $($agentTempFolder)"
Start-Process "$($agentTempFolder)\$($installFilename)" -ArgumentList "$($mabsServer)" -Wait #can take a while before process is stopped, this is normal.

Write-Host "Set DPMServer to $($mabsServer)"
Start-Process -FilePath "$($mabsAgentLocation)\SetDpmServer.exe" -ArgumentList "-dpmServerName $($mabsServer)" -Wait
