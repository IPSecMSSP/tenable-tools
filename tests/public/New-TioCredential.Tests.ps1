Describe 'New-TioCredential' {
  BeforeAll {
    # Setup for Testing
    $here = Split-Path -Parent $PSCommandPath
    . $here\..\_InitializeTests.ps1
  }

  Context "When passed an Access and SecretKey" {

    It 'Should return an object containing two PSCredential Objects with specified usernames.' {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioMsspAccount.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }

      $Cred = New-TioCredential -AccessKey 'ACCESS_KEY' -SecretKey 'SECRET_KEY'
      $Cred.AccessKey.UserName | Should -Be 'AccessKey'
      $Cred.SecretKey.UserName | Should -Be 'SecretKey'
    }

  }

}
