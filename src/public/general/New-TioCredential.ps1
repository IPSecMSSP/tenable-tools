function New-TioCredential {
  <#
  .SYNOPSIS
    Build a new Tenable.io credential object
  .DESCRIPTION
    This function is intended to create a PSObject containing 2 PSCredential Objects containing the AccessKey and SecretKey
  .PARAMETER AccessKey
    String containing the Access Key.  If not specified, user will be prompted.
  .PARAMETER SecretKey
    String containing the Secret Key. If not specified, user will be prompted.
  .OUTPUTS
    PSCustomObject containing the AccessKey and SecretKey PSCredential Object, containing the keys supplied.
  #>
  [CmdletBinding(SupportsShouldProcess=$true)]
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]

  param(
    [Parameter(Mandatory=$false,
      HelpMessage = 'Tenable.IO Access Key')]
		[string]  $AccessKey,

    [Parameter(Mandatory=$false,
      HelpMessage = 'Tenable.IO Secret Key')]
    [string]  $SecretKey
	)

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

  }

  Process {

    $Credential = @{}

    if ($AccessKey) {
      Write-Verbose 'Access Key Supplied'
      $AccessKeyCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'AccessKey', ($AccessKey | ConvertTo-SecureString -AsPlainText -Force)
    } else {
      $AccessKeyCredential = (Get-Credential -UserName 'AccessKey' -Message 'Tenable.IO Access Key')
    }

    $Credential.Add('AccessKey', $AccessKeyCredential)

    if ($SecretKey) {
      Write-Verbose 'Secret Key Supplied'
      $SecretKeyCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'SecretKey', ($SecretKey | ConvertTo-SecureString -AsPlainText -Force)
    } else {
      $SecretKeyCredential = (Get-Credential -UserName 'SecretKey' -Message 'Tenable.IO Secret Key')
    }

    $Credential.Add('SecretKey', $SecretKeyCredential)

    if ($PSCmdlet.ShouldProcess("Tenable.IO Credential", "Generate a new Tenable.IO Credential Object")) {
      Write-Output $Credential
    }
  }

  End {
    return
  }
}
