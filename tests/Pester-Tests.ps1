# Run Pester Tests

param (
  [Parameter(Mandatory=$false)]
  [string] $Path = $PSScriptRoot,

  [Parameter(Mandatory=$false)]
  [string] $Verbosity = 'Detailed'
)

# Ensure Pester is instaled
if (!(Get-InstalledModule -Name Pester -MinimumVersion '5.2.0' -ErrorAction SilentlyContinue)) {
  Install-Module -Name Pester -MinimumVersion '5.2.0' -Scope CurrentUser -Repository PSGallery -SkipPublisherCheck -Force
}

Import-Module Pester

$PesterConf = [PesterConfiguration]::Default
$PesterConf.TestResult.OutputFormat = 'JUnitXml'
$PesterConf.TestResult.Enabled = $true
$PesterConf.Run.Exit = $true
$PesterConf.Run.Path = $Path
$PesterConf.Output.Verbosity = $Verbosity

Invoke-Pester -Configuration $PesterConf
