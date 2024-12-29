# PowerShell script to install OpenJDK, Maven, and Fiji ImageJ
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator!"
    Pause
    Exit 1
}

# Define file paths
$JavaZipPath = "$PSScriptRoot\openjdk-23.0.1_windows-x64_bin.zip"
$MavenZipPath = "$PSScriptRoot\apache-maven-3.9.9-bin.zip"
$FijiZipPath = "$PSScriptRoot\fiji-win64.zip"

# Define installation directories
$JavaInstallDir = "C:\Program Files\jdk-23.0.1"
$MavenInstallDir = "C:\Program Files\apache-maven-3.9.9"
$FijiInstallDir = "$HOME\ProlifMSC"

# Define Anaconda Scripts directory
$AnacondaScriptsDir = "C:\ProgramData\anaconda3\Scripts"

Write-Output "---------------------------------------"
Write-Output "Starting installation of OpenJDK, Maven, and Fiji ImageJ"
Write-Output "---------------------------------------"

# Check for administrative privileges
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator!"
    Pause
    Exit 1
}

# Install OpenJDK
Write-Output "\nInstalling OpenJDK..."
If (Test-Path $JavaZipPath) {
    If (-Not (Test-Path $JavaInstallDir)) { New-Item -ItemType Directory -Path $JavaInstallDir | Out-Null }
    Expand-Archive -Path $JavaZipPath -DestinationPath $JavaInstallDir -Force
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $JavaInstallDir, [System.EnvironmentVariableTarget]::Machine)
    [Environment]::SetEnvironmentVariable("Path", "$($Env:Path);%JAVA_HOME%\bin", [System.EnvironmentVariableTarget]::Machine)
    
    & java -version
    If ($?) {
        Write-Output "OpenJDK installed successfully!"
    } Else {
        Write-Error "Failed to install OpenJDK!"
        Pause
        Exit 1
    }
} Else {
    Write-Error "OpenJDK archive not found: $JavaZipPath"
    Pause
    Exit 1
}

# Install Maven
Write-Output "\nInstalling Maven..."
If (Test-Path $MavenZipPath) {
    If (-Not (Test-Path $MavenInstallDir)) { New-Item -ItemType Directory -Path $MavenInstallDir | Out-Null }
    Expand-Archive -Path $MavenZipPath -DestinationPath $MavenInstallDir -Force
    [Environment]::SetEnvironmentVariable("M2_HOME", $MavenInstallDir, [System.EnvironmentVariableTarget]::Machine)
    [Environment]::SetEnvironmentVariable("Path", "$($Env:Path);%M2_HOME%\bin", [System.EnvironmentVariableTarget]::Machine)
    
    & mvn -version
    If ($?) {
        Write-Output "Maven installed successfully!"
    } Else {
        Write-Error "Failed to install Maven!"
        Pause
        Exit 1
    }
} Else {
    Write-Error "Maven archive not found: $MavenZipPath"
    Pause
    Exit 1
}

# Install Fiji ImageJ
Write-Output "\nInstalling Fiji ImageJ..."
If (Test-Path $FijiZipPath) {
    If (-Not (Test-Path $FijiInstallDir)) { New-Item -ItemType Directory -Path $FijiInstallDir | Out-Null }
    Expand-Archive -Path $FijiZipPath -DestinationPath $FijiInstallDir -Force
    If (Test-Path "$FijiInstallDir\Fiji.app") {
        Write-Output "Fiji ImageJ installed successfully!"
    } Else {
        Write-Error "Failed to extract Fiji ImageJ!"
        Pause
        Exit 1
    }
} Else {
    Write-Error "Fiji archive not found: $FijiZipPath"
    Pause
    Exit 1
}

# Add Anaconda Scripts to Path
Write-Output "Adding Anaconda Scripts to Path..."
If (Test-Path $AnacondaScriptsDir) {
    [Environment]::SetEnvironmentVariable("Path", "$($Env:Path);$AnacondaScriptsDir", [System.EnvironmentVariableTarget]::Machine)
    Write-Output "Anaconda Scripts added to Path successfully!"
} Else {
    Write-Error "Anaconda Scripts directory not found: $AnacondaScriptsDir"
    Pause
    Exit 1
}

Write-Output "---------------------------------------"
Write-Output "OpenJDK, Maven, and Fiji installed and configured successfully."
Write-Output "---------------------------------------"
Write-Output "Please restart your terminal for environment variables to take effect."
Pause
