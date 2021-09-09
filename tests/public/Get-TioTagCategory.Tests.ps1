Describe 'Get-TioTagCategory' {
  BeforeAll {
    # Setup for Testing
    $here = Split-Path -Parent $PSCommandPath
    . $here\..\_InitializeTests.ps1
  }

  Context "When only passed URI and Credentials" {

    It 'Should return all Tag Categories.' {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioTagCategory.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioTagCategory -Uri $TestUri -AccessKey $AccessKey -SecretKey $SecretKey).Count | Should -BeGreaterThan 2
    }

  }

  Context "When passed a UUID" {
    It "Should return a single Asset with expected content" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioTagCategory-uuid.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioTagCategory -Uri $TestUri -AccessKey $AccessKey -SecretKey $SecretKey -Uuid '578aaf6f-9221-4fef-a09b-945f55aa2890').Name | Should -Be "Tag Category 1"
    }
  }

  Context "When passed a Name" {
    It "Should return a single Asset with expected content" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioTagCategory-uuid.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioTagCategory -Uri $TestUri -AccessKey $AccessKey -SecretKey $SecretKey -Name 'Tag Category 1').uuid | Should -Be "578aaf6f-9221-4fef-a09b-945f55aa2890"
    }
  }

}
