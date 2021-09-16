function Stop-TioExportAsset {
  <#
  .SYNOPSIS
    Cancel an in-progress asset export
  .DESCRIPTION
    This function returns information about one or more Tenable.io Assets
  .PARAMETER Uri
    Base API URL for the API Call
  .PARAMETER AccessKey
    PSCredential Object with the Access Key stored in the Password property of the object.
  .PARAMETER SecretKey
    PSCredential Object with the Secret Key stored in the Password property of the object.
  .PARAMETER Method
    Valid HTTP Method to use: GET (Default), POST, DELETE, PUT
  .PARAMETER Filter
    Specifies filters for exported assets. To return all assets, omit the filters object. If
    your request specifies multiple filters, the system combines the filters using the AND search operator.
  .OUTPUTS
    PSCustomObject containing results if successful.  May be $null if no data is returned
    ErrorObject containing details of error if one is encountered.
  #>
  [CmdletBinding(DefaultParameterSetName='ListAll',SupportsShouldProcess)]

  param(
    [Parameter(Mandatory=$false,
      HelpMessage = 'Full URI to requested resource, including URI parameters')]
    [ValidateScript({
      $TypeName = $_ | Get-Member | Select-Object -ExpandProperty TypeName -Unique
      if ($TypeName -eq 'System.String' -or $TypeName -eq 'System.UriBuilder') {
        [System.UriBuilder]$_
      }
    })]
		[System.UriBuilder]  $Uri = 'https://cloud.tenable.com',

    [Parameter(Mandatory=$true,
      HelpMessage = 'PSCredential Object containing the Access Key in the Password property')]
    [PSCredential]  $AccessKey,

    [Parameter(Mandatory=$true,
      HelpMessage = 'PSCredential Object containing the Secret Key in the Password property')]
    [PSCredential]  $SecretKey,

    [Parameter(Mandatory=$false,
      HelpMessage = 'Method to use when making the request. Defaults to GET')]
    [ValidateSet("Post","Get","Put","Delete")]
    [string] $Method = "POST",

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ById',
      HelpMessage = 'Filter condition')]
    [string] $Uuid
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $Uri.Path = [io.path]::combine($Uri.Path, "assets/export", $uuid, "cancel")

  }

  Process {
    # Initiate the Asset Export
    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    if ($PSCmdlet.ShouldProcess($Uri.Uri, "Cancel Asset Export")) {
      $ExportStatus = Invoke-TioApiRequest -Uri $Uri -AccessKey $AccessKey -SecretKey $SecretKey -Method $Method -Body $Filter
    }

    Write-Output $ExportStatus

  }

  End {

  }
}