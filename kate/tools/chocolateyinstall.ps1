$version = "16.08.3-KF5.28"
$url32       = "http://download.kde.org/stable/kate/Kate-setup-$version-32bit.exe"
$url64       = "http://download.kde.org/stable/kate/Kate-setup-$version-64bit.exe"
$checksum32  = "aacc2092cd9ca25d7e27821ae978de7fde28c7007047c9ef58544c3f96ae8877"
$checksum64  = "8c4ecce0d251a1692382af1c9373b213e506e7255c01c1e75cd47645c6e0e09b"

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
