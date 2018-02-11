[CmdletBinding()]
Param(
    [string]$Script = "build.cake",
    [Parameter(Position=0,Mandatory=$false,ValueFromRemainingArguments=$true)]
    [string[]]$ScriptArgs
)

$CakeVersion = "0.25.0";
$NuGetVersion = "latest";

# Fix up the script root.
if(!$PSScriptRoot){
    $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}

# Make sure that cakeup is present.
$CakeUp = Join-Path $PSScriptRoot "cakeup.exe"
if (!(Test-Path $CakeUp)) {
    Write-Verbose -Message "Downloading cakeup.exe..."
    try {        
        $wc = (New-Object System.Net.WebClient);
        $wc.DownloadFile("https://github.com/patriksvensson/example/releases/download/v0.1.0/cakeup.exe", $CakeUp) } catch {
            Throw "Could not download cakeup.exe."
    }
}

# Build the argument list.
$Arguments = @{
    script=$Script;
    cake=$CakeVersion;
    nuget=$NuGetVersion;
    bootstrap="true";
    execute="true";
}.GetEnumerator() | ForEach-Object{"`"--{0}={1}`"" -f $_.key, $_.value };

# Execute Cakeup
Invoke-Expression "& `"$CakeUp`" $Arguments -- $ScriptArgs"
exit $LASTEXITCODE;