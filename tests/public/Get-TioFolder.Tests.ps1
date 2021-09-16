Describe 'Get-TioFolder' {
  BeforeAll {
    # Setup for Testing
    $here = Split-Path -Parent $PSCommandPath
    . $here\..\_InitializeTests.ps1
  }

  Context "When only passed URI and Credentials" {

    It 'Should return all Folders.' {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioFolder.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioFolder -Uri $TestUri -ApiKeys $ApiKeys).Count | Should -BeGreaterThan 2
    }

  }

  Context "When passed a Name" {
    It "Should return a single Folder with expected content" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioFolder.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioFolder -Uri $TestUri -ApiKeys $ApiKeys -Name 'My Scans').type | Should -Be "main"
    }
  }

}
