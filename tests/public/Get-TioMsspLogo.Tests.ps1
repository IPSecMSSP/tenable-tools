Describe 'Get-TioMsspLogo' {
  BeforeAll {
    # Setup for Testing
    $here = Split-Path -Parent $PSCommandPath
    . $here\..\_InitializeTests.ps1
  }

  Context "When only passed Credentials" {

    It 'Should return all Logos.' {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioMsspLogo.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioMsspLogo -ApiKeys $ApiKeys).Count | Should -BeGreaterThan 1
    }

  }

  Context "When passed a Name and not exact" {
    It "Should return multiple accounts" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioMsspLogo.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioMsspLogo -ApiKeys $ApiKeys -Name 'MSSP').Count | Should -BeGreaterThan 1
    }
  }

  Context "When passed a Name and exact" {
    It "Should return an account with expected properties" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioMsspLogo.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioMsspLogo -ApiKeys $ApiKeys -Name 'MSSP Logo 1' -Exact).uuid | Should -Be '1fa3edcc-8edd-42f7-b6d1-1f5cd1599d4e'
    }
  }

  Context "When passed an Id" {
    It "Should return an account with expected properties" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioMsspLogo-uuid.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioMsspLogo -ApiKeys $ApiKeys -Uuid '1fa3edcc-8edd-42f7-b6d1-1f5cd1599d4e').container_uuid | Should -Be 'cc747ae7-9843-4ebb-8793-9424bc9ed000'
    }
  }

}
