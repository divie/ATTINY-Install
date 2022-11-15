#This minimizes the window breifly after start
$Win32ShowWindowAsync = Add-Type -memberDefinition @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"@ -name "Win32ShowWindowAsync" -namespace Win32Functions -passThru

$s = Get-Process -Name "callbar-install"
$Win32ShowWindowAsync::ShowWindowAsync($s.MainWindowHandle, 6)

#This Creates the credentials to be used
$user = $env:UserName
$encpasswd = "IT1access" | ConvertTo-SecureString -AsPlainText -Force
$cred = new-object System.Management.AUtomation.PSCredential -ArgumentList '.\administrator',$encpasswd

Start-Sleep -Seconds 5

#This gets the current installed version and current available version.
$installed = Get-Process -Name "Callbar" -ErrorAction SilentlyContinue
$time=[DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
$version = Invoke-WebRequest -Uri https://downloadcallbar.talkdesk.com/release_metadata.json?timestamp=$time -UseBasicParsing | Select-Object -Expand Content | ConvertFrom-Json
$currentVersion = $version.version.Substring(0,$version.version.LastIndexOf('-'))

#if callbar is installed parse the information to get just the version number.
if($installed){
$installedVersion = Get-Process -Name "Callbar" -ErrorAction SilentlyContinue | Format-list -Property ProductVersion | Out-String
$installedVersion = $installedVersion.Substring(($installedVersion.LastIndexOf(":")+2),($installedVersion.LastIndexOf(".")-($installedVersion.LastIndexOf(":")+2)))
} 
else 
{
$installedVersion = ""
}

#If the current version is not equal to the installed version or if callbar is not installed, then download and install callbar
if ($currentVersion -ne $installedVersion -or !$installed)
{
    if ($installed -ne $null)
    {
        Start-Process -WindowStyle Hidden powershell -ArgumentList "-command ","Stop-Process -Name",$installed[0].name," -force" -Credential $cred
    }
    $url = "https://downloadcallbar.talkdesk.com/Callbar%20Setup%20" + $version.version + ".exe"
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest $url -O C:\Users\Public\Downloads\callbar.exe -UseBasicParsing
    $ProgressPreference = 'Continue'
    C:\Users\Public\Downloads\callbar.exe
    Start-Sleep -Seconds 30
    Remove-Item C:\Users\Public\Downloads\callbar.exe -Recurse
    Start-Sleep -Seconds 10
}

#if callbar doesn't have a link to start on startup, then create it
if (!(Test-Path -Path 'C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Callbar.lnk' -PathType Leaf))
{
    Start-Process -WindowStyle Hidden powershell -ArgumentList "-command ","New-Item -ItemType SymbolicLink -Path 'C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Callbar.lnk' -Target C:\Users\$user\AppData\Local\Programs\Callbar\Callbar.exe -Force" -Credential $cred
}
    Exit