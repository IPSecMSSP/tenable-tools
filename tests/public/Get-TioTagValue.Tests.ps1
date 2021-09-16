Describe 'Get-TioTagValue' {
  BeforeAll {
    # Setup for Testing
    $here = Split-Path -Parent $PSCommandPath
    . $here\..\_InitializeTests.ps1
  }

  Context "When only passed URI and Credentials" {

    It 'Should return all Tag Categories.' {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioTagValue.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioTagValue -Uri $TestUri -ApiKeys $ApiKeys).Count | Should -BeGreaterThan 2
    }

  }

  Context "When passed a UUID" {
    It "Should return a single Asset with expected content" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioTagValue-uuid.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioTagValue -Uri $TestUri -ApiKeys $ApiKeys -Uuid '1bc82ba0-2b24-48a5-ab7c-40314ddf209c').value | Should -Be "Category 1, Value 1"
    }
  }

  Context "When passed a Category Name" {
    It "Should return multiple assets" {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioTagValue-CategoryName.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioTagValue -Uri $TestUri -ApiKeys $ApiKeys -CategoryName 'Tag Category 1').Count | Should -BeGreaterThan 1
    }
  }

}
