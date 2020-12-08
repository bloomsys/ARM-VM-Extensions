Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# Partition & Format the data disk	
# First we’ll scan the system for disks that are available for use in a storage pool, and write the array to the $PhysicalDisks variable
$PhysicalDisks = Get-StorageSubSystem -FriendlyName "Windows Storage*" | Get-PhysicalDisk -CanPool $True
# Create a new storage pool StoragePool1 and add the available disks ($PhysicalDisks)
New-StoragePool -FriendlyName StoragePool1 -StorageSubsystemFriendlyName "Windows Storage*" -PhysicalDisks $PhysicalDisks
# Thin provisioning allows me to specify a larger capacity, and add extra disk space later as needed
New-VirtualDisk -FriendlyName VirtualDisk1 -Size 10GB -StoragePoolFriendlyName StoragePool1 -ProvisioningType Thin
# Initialize the disk, create a new volume and format it
Initialize-Disk -VirtualDisk (Get-VirtualDisk -FriendlyName VirtualDisk1) -passthru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume
# Install PowerShell-Core 7
choco install powershell-core -y
# Instal Azure Data Studio
choco install azure-data-studio -y
# Enable the Windows Subsystem for Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# Enable Virtual Machine feature
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
