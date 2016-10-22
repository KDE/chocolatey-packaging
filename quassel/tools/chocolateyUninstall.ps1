[array]$key = Get-UninstallRegistryKey -SoftwareName "Quassel*"
if ($key -ne $null) {
	Uninstall-ChocolateyPackage "quassel" "EXE" "/S" -File $key.UninstallString
}
