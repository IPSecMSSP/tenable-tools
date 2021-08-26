# Define common module info variables.
$ModuleName = "FreshService.Tools"
$ModuleManifestName = "$ModuleName.psd1"
$ModuleManifestPath = "$PSScriptRoot\..\src\$ModuleManifestName"

# Remove module if already loaded, then import.
Get-Module $ModuleName | Remove-Module
Import-Module $ModuleManifestPath -Force -ErrorAction Stop

# Below here put any custom elements that always need to be present
# This might include "Fake Credentials", paths, URLs, etc that need to be passed as parameters in tests.

