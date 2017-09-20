$version = "17.08.1-KF5.38"
$url32       = "https://download.kde.org/stable/kate/Kate-setup-$version-32bit.exe"
$url64       = "https://download.kde.org/stable/kate/Kate-setup-$version-64bit.exe"
$checksum32  = "33a0f2600feeaf5d9f1bb9edb0ddb492615d7fc375877b0c41de8b9e2a3b6f93"
$checksum64  = "9ff450dc338cc4cae1011dbe99969c3fcd5e85a159198dd8616caadfc2ac8950"

$installArgs  = "/S"

$params = @{
  packageName    = "kate"
  fileType       = "EXE"
  silentArgs     = $installArgs
  url            = $url32
  url64Bit       = $url64
  checksum       = $checksum32
  checksum64     = $checksum64
  checksumType   = "sha256"
  checksumType64 = "sha256"
}

$ROOT=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
& "$ROOT/chocolateyUninstall.ps1"

Install-ChocolateyPackage @params

[array]$key = Get-UninstallRegistryKey -SoftwareName "Kate*"
if ($key -ne $null) {
	$instDir = Split-Path -Parent $key.UninstallString
	Install-BinFile -Name "kate" -Path "$instDir/bin/kate.exe"
}
