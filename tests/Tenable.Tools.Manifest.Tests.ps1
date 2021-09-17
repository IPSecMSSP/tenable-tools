Describe "Tenable.Tools Module Manifest" {
  BeforeAll {
    # Setup for Testing
    $here = Split-Path -Parent $PSCommandPath
    $here += '/_InitializeTests.ps1'
    . $here

    $Manifest = Import-PowerShellDataFile -Path $ModuleManifestPath
    Write-Verbose $Manifest.RootModule
  }

  Context "Manifest Validation." {

    It "Has a valid manifest." {
      { Test-ModuleManifest -Path $ModuleManifestPath -ErrorAction Stop -WarningAction SilentlyContinue } | Should -Not -Throw
    }
    It 'Has a valid root module.' {
      $Manifest.RootModule | Should -Be "$ModuleName.psm1"
    }
    It 'Has a valid version in the manifest.' {
      $Manifest.ModuleVersion -as [Version] | Should -Not -BeNullOrEmpty
    }
    It 'Has a valid author.' {
      $Manifest.Author | Should -Not -BeNullOrEmpty
    }
    It 'Has a valid Description.' {
      $Manifest.Description | Should -Not -BeNullOrEmpty
    }
    It 'Has a valid guid.' {
      { [guid]::Parse($Manifest.Guid) } | Should -Not -Throw
    }
    It 'Has a valid copyright.' {
      $Manifest.Copyright | Should -Not -BeNullOrEmpty
    }

  }

}
