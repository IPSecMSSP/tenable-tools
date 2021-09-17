Describe 'Get-TioAsset' {
  BeforeAll {
    # Setup for Testing
    $here = Split-Path -Parent $PSCommandPath
    . $here\..\_InitializeTests.ps1
  }

  Context "When only passed URI and Credentials" {

    It 'Should return all Assets.' {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioAsset.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioAsset -Uri $TestUri -ApiKeys $ApiKeys).Count | Should -BeGreaterThan 1
    }

  }

  Context "When passed a Hostname" {
    It "Should return a single asset with expected content" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioAsset.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioAsset -Uri $TestUri -ApiKeys $ApiKeys -Hostname 'hostname').fqdn | Should -Be "hostname.domain.com"
    }
  }

  Context "When passed a UUID" {
    It "Should return a single asset with expected content" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioAsset-uuid.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioAsset -Uri $TestUri -ApiKeys $ApiKeys -Uuid '43542fe7-2a38-4fc6-bf7f-923b7d24c91f').fqdn | Should -Be "hostname.domain.com"
    }
  }

}
