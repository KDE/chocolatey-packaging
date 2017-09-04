$version = "17.04.3-KF5.36"
$url32       = "https://download.kde.org/stable/kate/Kate-setup-$version-32bit.exe"
$url64       = "https://download.kde.org/stable/kate/Kate-setup-$version-64bit.exe"
$checksum32  = "d2213214eaa2bb8466036415019b2be24dc593edcb5c289491f5175268d2dd64"
$checksum64  = "8f1d596d9c2611c2f25ea2d909fd482d5c14e8506e42603c289b07910dbaeab3"

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
