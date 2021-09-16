function Get-TioExportAssetChunk {
  <#
  .SYNOPSIS
    Download exported asset chunk by ID.
  .DESCRIPTION
    Download exported asset chunk by ID. Chunks are available for download for up to 24 hours after they have been created.
    Tenable.io returns a 404 message for expired chunks.
  .PARAMETER Uri
    Base API URL for the API Call
  .PARAMETER AccessKey
    PSCredential Object with the Access Key stored in the Password property of the object.
  .PARAMETER SecretKey
    PSCredential Object with the Secret Key stored in the Password property of the object.
  .PARAMETER Method
    Valid HTTP Method to use: GET (Default), POST, DELETE, PUT
  .PARAMETER Uuid
    The UUID of the export request.
  .PARAMETER Chunk
    The ID of the Asset Chunk you want to download
  .OUTPUTS
    PSCustomObject containing results if successful.  May be $null if no data is returned
    ErrorObject containing details of error if one is encountered.
  #>
  [CmdletBinding(DefaultParameterSetName='ListAll')]

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
    [string] $Method = "GET",

    [Parameter(Mandatory=$true,
      ParameterSetName = 'ById',
      HelpMessage = 'Asset Export UUID')]
    [string] $Uuid,

    [Parameter(Mandatory=$true,
      ParameterSetName = 'ById',
      HelpMessage = 'Asset Chunk Number')]
    [string] $Chunk
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $Uri.Path = [io.path]::combine($Uri.Path, "assets/export", $uuid, "chunks", $Chunk)

  }

  Process {
    # Initiate the Asset Export
    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    $ExportChunk = Invoke-TioApiRequest -Uri $Uri -AccessKey $AccessKey -SecretKey $SecretKey -Method $Method -Body $Filter

    Write-Output $ExportChunk

  }

  End {

  }
}