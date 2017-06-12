$version = "17.04.1-KF5.34"
$url32       = "https://download.kde.org/stable/kate/Kate-setup-$version-32bit.exe"
$url64       = "https://download.kde.org/stable/kate/Kate-setup-$version-64bit.exe"
$checksum32  = "a17cb888a608c1284a3b375202eadddc1cd65916866902966b961f4832510d31"
$checksum64  = "b5d6fd9c0653aea2bb453ed48f1e6a3f44824b1cc9326a8e6e0cd836d3e05cf2"

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
