$ver         = "5.1.2"
$url32       = "https://download.kde.org/stable/kdevelop/{0}/bin/windows/kdevelop-{0}-x86-setup.exe" -f $ver
$url64       = "https://download.kde.org/stable/kdevelop/{0}/bin/windows/kdevelop-{0}-x64-setup.exe" -f $ver
$checksum32  = "2c0ed9efc60ae336b93dab46cef4c47e7bbda59e05c1aecc982a7d1ee6c776c1"
$checksum64  = "ccbfab5e43f9ee236bd5c90a6021d17c54b76d7e0fc683eb83126f36b2cf555f"


$ErrorActionPreference = 'Stop';

(Get-WmiObject -Class Win32_OperatingSystem).Version -match "(?<Major>\d+).(?<Minor>\d+).(?<Build>\d+)" | Out-Null
[float]$winVer=$null
[float]::TryParse(("{0}.{1}{2}" -f $Matches.Major, $Matches.Minor, $Matches.Build), [ref]$winVer ) | Out-Null
if ($winVer -le 10.0)
{
    # Windows versions previous to Windows 10 require a prerequisite hotfix
    if (-not (Get-HotFix -Id KB2999226 -ErrorAction SilentlyContinue))
    {
        Write-Error "A prerequisite for installing Visual Studio 2015 applications is to have hotfix KB2999226 installed. See https://support.microsoft.com/en-us/kb/2999226 for more details"
    }
}

$installArgs  = "/S"

$params = @{
  packageName    = "kdevelop"
  fileType       = "EXE"
  silentArgs     = $installArgs
  url            = $url32
  url64Bit       = $url64
  checksum       = $checksum32
  checksum64     = $checksum64
  checksumType   = "sha256"
  checksumType64 = "sha256"
}

Install-ChocolateyPackage @params

[array]$key = Get-UninstallRegistryKey -SoftwareName "Kdevelop*"
if ($key -ne $null) {
	Install-BinFile -Name "kdevelop" -Path $key.DisplayIcon
}
