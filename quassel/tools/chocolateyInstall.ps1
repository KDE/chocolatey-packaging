$url32       = "http://www.quassel-irc.org/pub/quassel-x86-setup-0.12.4.exe"
$url64       = ""
$checksum32  = "96d189fe208978b16b32be63ebfa5967bc3f3c751ba5c6692cc3ca2706ca5f79"
$checksum64  = ""

$installArgs  = "/S"

$params = @{
  packageName    = "quassel"
  fileType       = "EXE"
  silentArgs     = $installArgs
  url            = $url32
  #url64Bit       = $url64
  checksum       = $checksum32
  #checksum64     = $checksum64
  checksumType   = "sha256"
  #checksumType64 = "sha256"
}

$ROOT=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
& "$ROOT/chocolateyUninstall.ps1"

Install-ChocolateyPackage @params

