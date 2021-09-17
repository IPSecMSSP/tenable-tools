Describe 'Get-TioExportAssetStatus' {
  BeforeAll {
    # Setup for Testing
    $here = Split-Path -Parent $PSCommandPath
    . $here\..\_InitializeTests.ps1
  }

  Context "When only passed URI and Credentials" {

    It 'Should return all recent export requests.' {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioExportAssetStatus.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioExportAssetStatus -Uri $TestUri -ApiKeys $ApiKeys).Count | Should -BeGreaterThan 1
    }

  }

  Context "When passed a Name" {
    It "Should return a single Folder with expected content" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioExportAssetStatus-uuid.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioExportAssetStatus -Uri $TestUri -ApiKeys $ApiKeys -Uuid '4f375b82-fa19-415d-9dfc-abc9fdadf025').status | Should -Be "FINISHED"
    }
  }

}
