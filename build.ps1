$CakeVersion = "0.25.0";
$NuGetVersion = "latest";
$DotnetVersion = "none";
$CoreClr = $false;
$Bootstrap = $true;

# Fix up the script root.
if(!$PSScriptRoot){
    $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}

# Make sure that cakeup is present.
$CakeupVersion = "0.2.19"
$Cakeup = Join-Path $PSScriptRoot "cakeup-x86_64-v$CakeupVersion.exe"
if (!(Test-Path $Cakeup)) {
    Write-Verbose -Message "Downloading cakeup.exe ($CakeupVersion)..."
    try {        
        $wc = (New-Object System.Net.WebClient);
        $wc.DownloadFile("https://cakeup.blob.core.windows.net/windows/cakeup-x86_64-v$CakeupVersion.exe", $Cakeup) } catch {
            Throw "Could not download cakeup.exe."
    }
}

# Execute Cakeup
&$Cakeup "--cake=$CakeVersion" "--nuget=$NuGetVersion" `
         "--sdk=$DotnetVersion" "--coreclr=$CoreClr" `
         "--bootstrap=$Bootstrap" "--execute" "--" "$args"

# Return the exit code from Cakeup.
exit $LASTEXITCODE;