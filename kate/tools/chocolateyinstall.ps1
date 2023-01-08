$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName = $env:ChocolateyPackageName
  file64      = "$toolsDir\kate-22.12.1-1906-windows-cl-msvc2019-x86_64.exe"
  destination = $toolsDir
  silentArgs  = "/S"
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $toolsDir\*.exe -ea 0
