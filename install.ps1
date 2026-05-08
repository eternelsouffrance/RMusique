$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#region Variables
$RMusiqueFolderPath = "$env:LOCALAPPDATA\RMusique"
$RMusiqueOldFolderPath = "$HOME\RMusique-cli"
#endregion

#region Functions
function Write-Success {
    Write-Host ' > OK' -ForegroundColor Green
}

function Write-Unsuccess {
    Write-Host ' > ERROR' -ForegroundColor Red
}

function Test-Admin {
    Write-Host "Checking permissions..." -NoNewline

    $currentUser = New-Object Security.Principal.WindowsPrincipal(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    )

    return -not $currentUser.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

function Test-PowerShellVersion {
    $PSMinVersion = [version]'5.1'

    Write-Host 'Checking PowerShell version...' -NoNewline

    return $PSVersionTable.PSVersion -ge $PSMinVersion
}

function Move-OldRMusiqueFolder {
    if (Test-Path $RMusiqueOldFolderPath) {

        Write-Host 'Migrating old RMusique folder...' -NoNewline

        Copy-Item `
            -Path "$RMusiqueOldFolderPath\*" `
            -Destination $RMusiqueFolderPath `
            -Recurse `
            -Force

        Remove-Item $RMusiqueOldFolderPath -Recurse -Force

        Write-Success
    }
}

function Get-RMusique {

    if ($env:PROCESSOR_ARCHITECTURE -eq 'AMD64') {
        $architecture = 'x64'
    }
    elseif ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
        $architecture = 'arm64'
    }
    else {
        $architecture = 'x32'
    }

    Write-Host 'Fetching latest RMusique version...' -NoNewline

    # Mets ton dépôt GitHub ici
    $latestRelease = Invoke-RestMethod `
        -Uri 'https://api.github.com/repos/TONUSER/RMusique/releases/latest'

    $targetVersion = $latestRelease.tag_name -replace 'v',''

    Write-Success

    $archivePath = Join-Path $env:TEMP "RMusique.zip"

    Write-Host "Downloading RMusique v$targetVersion..." -NoNewline

    Invoke-WebRequest `
        -Uri "https://github.com/TONUSER/RMusique/releases/download/v$targetVersion/RMusique-$targetVersion-windows-$architecture.zip" `
        -OutFile $archivePath

    Write-Success

    return $archivePath
}

function Add-RMusiqueToPath {

    Write-Host 'Adding RMusique to PATH...' -NoNewline

    $user = [EnvironmentVariableTarget]::User
    $path = [Environment]::GetEnvironmentVariable('PATH', $user)

    if ($path -notlike "*$RMusiqueFolderPath*") {
        $path = "$path;$RMusiqueFolderPath"
    }

    [Environment]::SetEnvironmentVariable(
        'PATH',
        $path,
        $user
    )

    $env:PATH = $path

    Write-Success
}

function Install-RMusique {

    Write-Host 'Installing RMusique...'

    $archivePath = Get-RMusique

    Write-Host 'Extracting files...' -NoNewline

    Expand-Archive `
        -Path $archivePath `
        -DestinationPath $RMusiqueFolderPath `
        -Force

    Write-Success

    Add-RMusiqueToPath

    Remove-Item $archivePath -Force -ErrorAction SilentlyContinue

    Write-Host 'RMusique installed successfully!' -ForegroundColor Green
}
#endregion

#region Main
if (-not (Test-PowerShellVersion)) {

    Write-Unsuccess

    Write-Warning 'PowerShell 5.1 minimum required.'

    exit
}
else {
    Write-Success
}

if (-not (Test-Admin)) {

    Write-Unsuccess

    Write-Warning 'Run as normal user recommended.'
}
else {
    Write-Success
}

Move-OldRMusiqueFolder
Install-RMusique

Write-Host ""
Write-Host "Run " -NoNewline
Write-Host "RMusique -h" -ForegroundColor Cyan -NoNewline
Write-Host " to get started."
#endregion