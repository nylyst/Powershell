<#
.Synopsis
    Microsoft.PowerShell_profile.ps1 - My PowerShell profile
.Description
    Microsoft.PowerShellISE_profile - Customizes the PowerShell ISE console
.Notes
    File Name   : Microsoft.PowerShellISE_profile.ps1
    Author      : Eric Walker - nylyst@gmail.com
#>
function prompt
{
	#$(if (test-path variable:/PSDebugContext) { '[DBG]: ' } else { '' }) + 'PS ' + $(Get-Location) + $(if ($nestedpromptlevel -ge 1) { '>>' }) + '> '
	# Print the current time:
	write-host ("[") -nonewline -foregroundcolor DarkGray
	write-host (get-date -format HH:mm:ss) -nonewline -foregroundcolor Gray
	write-host ("][") -nonewline -foregroundcolor DarkGray
	# Print the working directory:
	write-host ($PWD) -nonewline -foregroundcolor Gray
	write-host ("|") -nonewline -foregroundcolor DarkGray
	# Print the number of objects inside the current directory:
	write-host (get-childitem $PWD -Force).Length -nonewline -foregroundcolor Gray
	write-host ("]") -nonewline -foregroundcolor DarkGray
	# Print the prompt symbol:
	write-host ("#") -nonewline -foregroundcolor Green
	return " ";
}

function Get-Wallpaper
{
    $response = Invoke-WebRequest -Uri https://www.reddit.com/r/wallpaper -UseBasicParsing $links = $response.Links $imgurlinks = @() $storagedir = "C:\users\username\Pictures\Wallpaper" $webclient = New-Object System.Net.WebClient
    ForEach ($link in $links) {
        $href = $link.href
        $size = $link.outerHTML
        if ($href -like "*imgur.com*" -AND $size -like "*1920*") {    
            $filename = $href.Split("/")[-1]
            if ($filename -like "*?*") {
                $filename2 = $filename.Split("?")[0]
            }
            else {
                $filename2 = $filename
            }
            $file = "$storagedir\$filename2"
            $webclient.DownloadFile($href,$file)    
        }
    }
}

function start-elevatedpowershell
{
	start-process powershell -verb runas
}

function test-isadmin
{
 <#
.Synopsis
	Tests if the user is an administrator
.Description
	Returns true if a user is an administrator, false if the user is not an administrator       
.Example
	import-module
#>
	$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
	$principal = New-Object Security.Principal.WindowsPrincipal $identity
	$principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function whoami {
    [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
}

function backup-profile {
    Param([string]$destination = $backupHome)
    if(!(test-path $destination)) {
        new-item -path $destination -ItemType directory -force | out-null
    }
    $date = get-date -format s
    $backupName = "{0}.{1}.{2}.{3}" -f $env:COMPUTERNAME, $env:USERNAME, (rifc -stringIn $date.ToString() -replacementChar "-"), (split-path -path $profile -leaf)
    copy-item -path $profile -destination "$destination\$backupName" -force
}

function reload-profile {
    @(
        $profile.AllUsersAllHosts,
        $profile.AllUsersCurrentHost,
        $profile.CurrentUserAllHosts,
        $profile.CurrentUserCurrentHost
    ) | % {
        if(test-path $_) {
            Write-Verbose "Running $_"
            . $_
        }
    }    
}
 
function check-sessionarch {
    if ([System.IntPtr]::Size -eq 8) { return "x64" }
    else { return "x86" }
}

function test-consolehost {
    if(($host.Name -match 'consolehost')) {
        $true
    }
    Else {
        $false
    }
}



function replace-invalidfilecharacters
{
<#
.Synopsis
	Replaces characters that are not valid in file path/name(s)
.Description
	Uses [System.IO.Path]::GetInvalidFileNameChars() to replace characters not permitted in file path/name(s)       
.Example
	# Replace-InvalidFileCharacters "my?string"
    # Replace-InvalidFileCharacters (get-date).tostring()
#>
 Param ($stringIn, $replacementChar)

 $stringIN -replace "[$( [System.IO.Path]::GetInvalidFileNameChars() )]", $replacementChar

}

function Set-CodePage
{
    [CmdletBinding()]
    param(
        [ValidateSet("UTF8", "Default")]
        [string]$CodePage
    )

    $codePageToNum = @{
        UTF8 = 65001;
        Default = 437;
    }

    chcp $codePageToNum[$CodePage] | Out-Null
}

$assemblylist = 
"System.Windows.Forms",
"System.Drawing"

foreach ($asm in $assemblylist)
{
	add-type -assemblyname $asm
}


#new-psdrive -name H -psprovider FileSystem -root \\udhp.lancaster.labs\home\pw82

# Load Jump-Location profile
import-module 'C:\Chocolatey\lib\Jump-Location.0.6.0\tools\Jump.Location.psd1'

# Load gmail.ps module profile
import-module 'C:\Users\PW82\Documents\WindowsPowerShell\Modules\Gmail.ps\Gmail.ps.psd1'

#load PsReadLine
import-module PSReadLine

#Load StoredCredentials module
import-module StoredCredential

#Load PowerShellPack and SushiHangover modules
import-module PowerShellPack
import-module SushiHangover-Tools
import-module SushiHangover-Transcripts
import-module SushiHangover-RSACrypto
import-module BitsTransfer


#Aliases
set-alias np 	'C:\Program Files (x86)\Notepad++\notepad++.exe'
set-alias vs 	'C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\ide\devenv.exe'
set-alias vb 	'C:\Program Files (x86)\Microsoft Visual Studio\vb98\vb6.exe'
set-alias wd 	'C:\Program Files (x86)\Microsoft Office\Office14\Winword.exe'
set-alias xl 	'C:\Program Files (x86)\Microsoft Office\Office14\Excel.exe'
set-alias cr 	'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
set-alias px 	'C:\Program Files (x86)\Parallax\parallax.exe'
set-alias rpx 	'C:\Program Files (x86)\Parallax\run-parallax.exe'
set-alias grep	'select-string'
set-alias paint 'C:\Program Files\Paint.Net\PaintDotNet.exe'
set-alias cs	'get-childitem -Recurse -Include *.bas, *.c, *.cls, *.config, *.cpp, *.cs, *.csproj, *.ctl, *.dsr, *.fnc, *.frm, *.h, *.java, *.js, *.rc, *.resx, *.settings, *.sln, *.sql, *.vb, *.vbg, *.vbproj, *.xaml, *.xsc, *.xsd, *.xss, *.xslt'
set-alias sudo	'start-elevatedpowershell | out-null'
set-alias ep    'edit-profile'
set-alias tch   'test-consolehost | out-null'
set-alias rifc  'replace-invalidfilecharacters | out-null'

##Make sure PS Help topics are up to date on each session start
netsh winhttp import proxy source=ie
$webclient = New-Object System.Net.WebClient
##$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
##obtained with: 'password' | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
## replace password above with your password and then paste the output into the $pw variable below
## also keep an eye out for spaces added to the securestring, ConEMU was putting a space between lines
##$pw = '01000000d08c9ddf0115d1118c7a00c04fc297eb01000000ce19ec5c2b7d574986397d2051e351cc0000000002000000000003660000c000000010000000b5e77aeefd23fabbf9b021f4e5915a290000000004800000a000000010000000e4fe6263a66a954aa7601b031982815b200000001f166c030a940f8b7bef0d51905675abd5d7cadb6a305852f3c0736a259b1742140000005350db72ebf85585ae25bcf079fbe6edf3cda428'
##$pw = Read-Host -AsSecureString "`nEnter password:"
##$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, ($pw | ConvertTo-SecureString)
##$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pw
$cred = get-storedcredential ES-AREA1\PW82
$webclient.Proxy.Credentials = $cred
update-help

#if ($Host.Name -eq 'ConsoleHost')
if(test-isadmin)
	{ $host.UI.RawUI.WindowTitle = "Elevated PowerShell" }
else
	{ $host.UI.RawUI.WindowTitle = "$($env:USERNAME) Non-elevated Posh" }

if (!(test-path variable:backupHome))
{
    new-variable -name backupHome -value "h:\Backup"
}

[appdomain]::currentdomain.GetAssemblies()  #| sort -property Location

if(Test-Path Env:ConEmuBuild)
{
    Set-CodePage UTF8
}