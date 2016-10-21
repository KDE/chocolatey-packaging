$url32       = "http://download.kde.org/stable/kdevelop/5.0.2/bin/windows/kdevelop-5.0.2-x86-setup.exe"
$url64       = "http://download.kde.org/stable/kdevelop/5.0.2/bin/windows/kdevelop-5.0.2-x64-setup.exe"
$checksum32  = "b17bef8d76fca5ffce7a2fe2d8e7417de824fee051d8c06296b249d06b614a8f"
$checksum64  = "11d0ea458916c7231734c7703836ae7ce0ad6b31ded0bf943d81dda93aff9d8e"


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
