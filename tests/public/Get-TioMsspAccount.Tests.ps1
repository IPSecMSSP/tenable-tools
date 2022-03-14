Describe 'Get-TioMsspAccount' {
  BeforeAll {
    # Setup for Testing
    $here = Split-Path -Parent $PSCommandPath
    . $here\..\_InitializeTests.ps1
  }

  Context "When only passed Credentials" {

    It 'Should return all Accounts.' {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioMsspAccount.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioMsspAccount -ApiKeys $ApiKeys).Count | Should -BeGreaterThan 2
    }

  }

  Context "When passed a Name and not exact" {
    It "Should return multiple accounts" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioMsspAccount.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioMsspAccount -ApiKeys $ApiKeys -Name 'Customer').Count | Should -BeGreaterThan 1
    }
  }

  Context "When passed a Name and exact" {
    It "Should return an account with expected properties" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioMsspAccount.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioMsspAccount -ApiKeys $ApiKeys -Name 'Customer Name 1' -Exact).uuid | Should -Be 'f5e877c6-b078-442e-90ff-b7cd4edff3e9'
    }
  }

  Context "When passed a Container" {
    It "Should return an account with expected properties" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioMsspAccount.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioMsspAccount -ApiKeys $ApiKeys -Container 'domain.com-1112').uuid | Should -Be '2c0e43c5-f681-4305-8ace-e595d0b1f072'
    }
  }

  Context "When passed an Id" {
    It "Should return an account with expected properties" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioMsspAccount.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioMsspAccount -ApiKeys $ApiKeys -Uuid '0229a359-d11e-424e-90e9-fe080608c74a').container_name | Should -Be 'domain.com-1113'
    }
  }

}
