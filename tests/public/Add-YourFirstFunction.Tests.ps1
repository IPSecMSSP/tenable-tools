Describe 'Add-YourFirstFunction' {
  BeforeAll {
    # Setup for Testing
    $here = Split-Path -Parent $PSCommandPath
    . $here\..\_InitializeTests.ps1
  }

  Context "When not passed any parameters." {

    It 'Should write correct output.' {
      Add-YourFirstFunction | Should -Be "Your first function ran!  Supplied Parameter: Default Value"
    }

  }

}
