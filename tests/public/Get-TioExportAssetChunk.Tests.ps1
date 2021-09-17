Describe 'Get-TioExportAssetChunk' {
  BeforeAll {
    # Setup for Testing
    $here = Split-Path -Parent $PSCommandPath
    . $here\..\_InitializeTests.ps1
  }

  Context "When Passed Export UUID and Chunk ID" {

    It 'Should return results.' {
      $TestDataFile = $PSScriptRoot + "\data\Get-TioExportAssetChunk.json"

      # Setup Mocking
      Mock -ModuleName Tenable.Tools Invoke-TioApiRequest {
        return Get-Content $TestDataFile | ConvertFrom-Json -depth 10
      }
      (Get-TioExportAssetChunk -ApiKeys $ApiKeys -Uuid '0c251c76-271e-47c1-b763-a380f413a590' -Chunk 1).Count | Should -BeGreaterThan 2
    }

  }

}
