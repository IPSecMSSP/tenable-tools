# Define common module info variables.
$ModuleName = "Tenable.Tools"
$ModuleManifestName = "$ModuleName.psd1"
$ModuleManifestPath = "$PSScriptRoot\..\src\$ModuleManifestName"

# Remove module if already loaded, then import.
Get-Module $ModuleName | Remove-Module
Import-Module $ModuleManifestPath -Force -ErrorAction Stop

# Below here put any custom elements that always need to be present
# This might include "Fake Credentials", paths, URLs, etc that need to be passed as parameters in tests.

# Fake Secure String
$TestSecureAccessKey = ConvertTo-SecureString -String '54006500730074002000500061007300730077006f0072006400' -AsPlainText
$TestAccess = 'AccessKey'
$TestSecret = 'SecretKey'

$ApiKeys = @{}
$ApiKeys.Add('AccessKey',(New-Object System.Management.Automation.PSCredential ($TestAccess, $TestSecureAccessKey)))
$ApiKeys.Add('SecretKey',(New-Object System.Management.Automation.PSCredential ($TestSecret, $TestSecureAccessKey)))
$TestUri = 'https://cloud.tenable.com'

Write-Information "Using $($ApiKeys.AccessKey.UserName) and $($ApiKeys.SecretKey.UserName) for testing against $TestUri"

