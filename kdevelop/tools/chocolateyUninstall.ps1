[array]$key = Get-UninstallRegistryKey -SoftwareName "Kdevelop*"
if ($key -ne $null) {
	Uninstall-ChocolateyPackage "kdevelop" "EXE" "/S" -File $key.UninstallString
	Uninstall-BinFile -Name "kdevelop" -Path $key.DisplayIcon
}
