$ver         = "5.1.2"
$url32       = "https://download.kde.org/stable/kdevelop/{0}/bin/windows/kdevelop-{0}-x86-setup.exe" -f $ver
$url64       = "https://download.kde.org/stable/kdevelop/{0}/bin/windows/kdevelop-{0}-x64-setup.exe" -f $ver
$checksum32  = "54d071a30fe581355032d758b4d9a6c48ce793db5fed35a357d686d72881c5f2"
$checksum64  = "22d5d86afc603f02cc43b652cb82739a6600636476df2b7318e5fa45d504164b"


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
