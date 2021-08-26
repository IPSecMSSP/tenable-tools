Describe 'Add-PrivateFunction' {
  BeforeAll {
    # Setup for Testing
    $here = Split-Path -Parent $PSCommandPath
    . $here\..\_InitializeTests.ps1
  }

  InModuleScope Tenable.Tools {

    Context "When not passed any parameters." {

      It 'Should write correct output.' {
        Add-PrivateFunction | Should -Be "Your private function ran!"
      }

    }

  }

}
