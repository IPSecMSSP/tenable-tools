function Get-TioScanner {
  <#
  .SYNOPSIS
    Get Tenable Scanner Information
  .DESCRIPTION
    This function returns information about available Tenable Scanners
  .PARAMETER Uri
    Base API URL for the API Call
  .PARAMETER ApiKeys
    PSObject containing PSCredential Objects with AccessKey and SecretKey.
    Must contain PSCredential Objects named AccessKey and SecretKey with the respective keys stored in the Password property
  .OUTPUTS
    PSCustomObject containing results if successful.  May be $null if no data is returned
    ErrorObject containing details of error if one is encountered.
  #>
  [CmdletBinding(DefaultParameterSetName = 'ListAll')]

  param(
    [Parameter(Mandatory = $false,
      HelpMessage = 'Base URI for the Tenable Environment, defaults to Tenable Cloud')]
    [ValidateScript({
        $TypeName = $_ | Get-Member | Select-Object -ExpandProperty TypeName -Unique
        if ($TypeName -eq 'System.String' -or $TypeName -eq 'System.UriBuilder') {
          [System.UriBuilder]$_
        }
      })]
    [System.UriBuilder]  $Uri = 'https://cloud.tenable.com',

    [Parameter(Mandatory = $true,
      HelpMessage = 'PSObject containing PSCredential Objects with AccessKey and SecretKey')]
    [PSObject]  $ApiKeys,

    [Parameter(Mandatory = $false,
      ParameterSetName = 'ById',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = 'Id of Scanner for which to retrieve details')]
    [Alias("Uuid")]
    [string] $Id
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $Uri.Path = [io.path]::combine($Uri.Path, "scanners")

    $Method = 'GET'
  }

  Process {
    if ($PSBoundParameters.ContainsKey('Id')) {
      # We're looking up a specific Id
      $Uri.Path = [io.path]::combine($Uri.Path, $Id)
    }

    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    $Response = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys -Method $Method

    if ($Response.scanners) {
      Write-Output $Response.scanners
    } else {
      Write-Output $Response
    }
  }

  End {

  }
}