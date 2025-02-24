import-module au

$releases = 'https://cdn.kde.org/ci-builds/utilities/kate/'

function global:au_GetLatest {  
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $version       = $download_page.links | ? href -match 'release' | select -Last 1 -expand href
  $version       = ($version -split '-' | select -Last 1).Replace('/','')

  $artifacts64 = 'https://cdn.kde.org/ci-builds/utilities/kate/release-' + $version + '/windows/'
  $build64 = ((Invoke-WebRequest $artifacts64 -UseBasicParsing).links | ? href -match '.exe$' | select -First 1 -expand href) -split '-' | select -First 3

    @{
        URL64        = 'https://cdn.kde.org/ci-builds/utilities/kate/release-' + $version + '/windows/kate-release_' + $version + '-' + $build64[2] + '-windows-cl-msvc2022-x86_64.exe'
        Version      = $version
        Copying      = 'https://invent.kde.org/utilities/kate/-/raw/v' + $version +'/LICENSES/LGPL-2.0-or-later.txt'
        ReleaseNotes = 'https://kde.org/announcements/changelogs/gear/' + $version + '/#kate'
    }
}

function global:au_BeforeUpdate {
        #Invoke-WebRequest -Uri $Latest.Copying -OutFile "legal\LICENSE.txt"
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
