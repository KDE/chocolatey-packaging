$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName = $env:ChocolateyPackageName
  file64      = "$toolsDir\kate-22.08.1-1789-windows-msvc2019_64-cl.exe"
  destination = $toolsDir
  silentArgs  = "/S"
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $toolsDir\*.exe -ea 0
