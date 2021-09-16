function Get-TioExportAsset {
  <#
  .SYNOPSIS
    Exports all assets that match the request criteria.
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
    [string] $Method = "POST",

    [Parameter(Mandatory=$false,
      HelpMessage = 'Filter condition')]
    [string] $ChunkSize = 1000,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ByFilter',
      HelpMessage = 'Filter condition')]
    [string] $Filter,

    [Parameter(Mandatory=$true,
      ParameterSetName = 'ByTag',
      HelpMessage = 'Tag Category Filter condition')]
    [string] $TagCategory,

    [Parameter(Mandatory=$true,
      ParameterSetName = 'ByTag',
      HelpMessage = 'Tag Value Filter condition')]
    [string] $TagValue
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $RetryInterval = 30

    $Uri.Path = [io.path]::combine($Uri.Path, "assets/export")

    $Body = @{}
    $Body.Add('chunk_size',$ChunkSize)

    if ($PSBoundParameters.ContainsKey('TagCategory')) {
      $Body.Add('filters',@{})
      $Body.filters.add(('tag.' + $TagCategory),$TagValue)
    }

  }

  Process {
    # Initiate the Asset Export
    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    $AssetExport = Invoke-TioApiRequest -Uri $Uri -AccessKey $AccessKey -SecretKey $SecretKey -Method $Method -Body $Body -Debug

    Write-Verbose ($Me + ': Asset Export ID: ' + $AssetExport.export_uuid)
    # Start by checking the status
    $ExportStatus = Get-TioExportAssetStatus -AccessKey $AccessKey -SecretKey $SecretKey -Uuid $AssetExport.export_uuid

    if ($ExportStatus.Error) {
      Write-Error ("$Me : Exception: $($ExportStatus.Code) : $($ExportStatus.Note)")
    }

    Write-Verbose ($Me + ': Asset Export Status: ' +$ExportStatus.status)

    # Wait until the export is finished
    while ($ExportStatus.status -ne 'FINISHED') {
      Start-Sleep -Seconds $RetryInterval

      $ExportStatus = Get-TioExportAssetStatus -AccessKey $AccessKey -SecretKey $SecretKey -Uuid $AssetExport.export_uuid

      # Check for failures
      if ($ExportStatus.status -eq 'CANCELLED' -or $ExportStatus.status -eq 'ERROR') {
        Write-Error 'Asset Export Failed'
        exit 1
      }

      Write-Verbose ($Me + ': Asset Export Status: ' + $ExportStatus.status)
    }

    # We should have our results available for download now

    $Assets = @()

    foreach ($Chunk in $ExportStatus.chunks_available) {
      $Assets += Get-TioExportAssetChunk -AccessKey $AccessKey -SecretKey $SecretKey -Uuid $AssetExport.export_uuid -Chunk $Chunk
    }

    Write-Output $Assets

  }

  End {

  }
}