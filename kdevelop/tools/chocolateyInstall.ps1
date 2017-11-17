$ver         = "5.2.0"
$url32       = "https://download.kde.org/stable/kdevelop/{0}/bin/windows/kdevelop-{0}-x86-setup.exe" -f $ver
$url64       = "https://download.kde.org/stable/kdevelop/{0}/bin/windows/kdevelop-{0}-x64-setup.exe" -f $ver
$checksum32  = "0757a484c2c65ba7b5d2c1c43ea1beb5b96d24883ed95bb408f23e158bd00ae2"
$checksum64  = "0e8a860c8cdc4010d71ccf2f1d3762136b23dbb1f08a69b4a2151cb1eb4ae72e"


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
