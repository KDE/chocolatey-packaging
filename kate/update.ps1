import-module au

$releases = 'https://github.com/KDE/kate/tags'
$artifacts64 = 'https://binary-factory.kde.org/view/Windows%2064-bit/job/Kate_Release_win64/lastSuccessfulBuild/artifact/'

function global:au_GetLatest {  
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $url           = $download_page.links | ? href -match '.zip$' | select -First 1 -expand href
  $version       = ($url -split '/|.zip' | select -Last 1 -Skip 1).Replace('v','')
  $build64 = ((Invoke-WebRequest $artifacts64 -UseBasicParsing).links | ? href -match $version | select -First 1 -expand href) -split '-' | select -First 1 -Skip 2

    @{
        URL64        = 'https://binary-factory.kde.org/view/Windows%2064-bit/job/Kate_Release_win64/' + $build64 + '/artifact/kate-' + $version + '-' + $build64 + '-windows-cl-msvc2019-x86_64.exe'
        Version      = $version
        Copying      = 'https://invent.kde.org/utilities/kate/-/raw/v' + $version +'/LICENSES/LGPL-2.0-or-later.txt'
        ReleaseNotes = 'https://kde.org/announcements/changelogs/gear/' + $version + '/#kate'
    }
}

function global:au_BeforeUpdate {
        Invoke-WebRequest -Uri $Latest.Copying -OutFile "legal\LICENSE.txt"
        Get-RemoteFiles -Purge -NoSuffix
}

function global:au_SearchReplace {
        @{
        "kate.nuspec" = @{
            "(\<licenseUrl\>).*(\<\/licenseUrl\>)"     = "`${1}$($Latest.Copying)`$2"
            "(\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
            }
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
            }
        ".\legal\VERIFICATION.txt" = @{
            "(?i)(x86_64:).*"     = "`${1} $($Latest.URL64)"
            "(?i)(checksum64:).*" = "`${1} $($Latest.Checksum64)"
            "(?i)(The included 'LICENSE.txt' file have been obtained from:).*" = "`${1} $($Latest.Copying)"
            }
        }
}

try {
    update -ChecksumFor none
} catch {
    $ignore = 'Not Found'
    if ($_ -match $ignore) { Write-Host $ignore; 'ignore' }  else { throw $_ }
}
