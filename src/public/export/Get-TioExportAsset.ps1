function Get-TioExportAsset {
  <#
  .SYNOPSIS
    Exports all assets that match the request criteria.
  .DESCRIPTION
    This function returns information about one or more Tenable.io Assets
  .PARAMETER Uri
    Base API URL for the API Call
  .PARAMETER ApiKeys
    PSObject containing PSCredential Objects with AccessKey and SecretKey.
    Must contain PSCredential Objects named AccessKey and SecretKey with the respective keys stored in the Password property
  .PARAMETER Method
    Valid HTTP Method to use: GET (Default), POST, DELETE, PUT
  .PARAMETER Filter
    Specifies filters for exported assets. To return all assets, omit the filters object. If
    your request specifies multiple filters, the system combines the filters using the AND search operator.
  .OUTPUTS
    PSCustomObject containing results if successful.  May be $null if no data is returned
    ErrorObject containing details of error if one is encountered.
  #>
  [CmdletBinding(DefaultParameterSetName='ByTag')]

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
      HelpMessage = 'PSObject containing PSCredential Objects with AccessKey and SecretKey')]
    [PSObject]  $ApiKeys,

    [Parameter(Mandatory=$false,
      HelpMessage = 'Method to use when making the request. Defaults to GET')]
    [ValidateSet("Post","Get","Put","Delete")]
    [string] $Method = "POST",

    [Parameter(Mandatory=$false,
      HelpMessage = 'Results per chunk')]
    [int64] $ChunkSize = 1000,

    [Parameter(Mandatory=$true,
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
    [string] $TagValue,

    [Parameter(Mandatory=$true,
      ParameterSetName = 'ByUuid',
      HelpMessage = 'Tag Value Filter condition')]
    [string] $Uuid
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $RetryInterval = 30

    $Uri.Path = [io.path]::combine($Uri.Path, "assets/export")

    if (!$PSBoundParameters.ContainsKey('Uuid')) {
      # Starting a new search
      $Body = @{}
      $Body.Add('chunk_size',$ChunkSize)

      if ($PSBoundParameters.ContainsKey('TagCategory')) {
        $Body.Add('filters',@{})
        $Body.filters.add(('tag.' + $TagCategory),$TagValue)
      } elseif ($PSBoundParameters.ContainsKey('Filter')) {
        $Body.Add('filters',$Filter)
      }
    }

  }

  Process {

    if (!$PSBoundParameters.ContainsKey('Uuid')) {
      # Initiate the Asset Export
      Write-Verbose "$Me : Uri : $($Uri.Uri)"
      $AssetExport = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys -Method $Method -Body $Body

      $Uuid = $AssetExport.export_uuid
    }

    Write-Verbose ($Me + ': Asset Export ID: ' + $Uuid)
    # Start by checking the status
    $ExportStatus = Get-TioExportAssetStatus -ApiKeys $ApiKeys -Uuid $Uuid

    if ($ExportStatus.Error) {
      Write-Error ("$Me : Exception: $($ExportStatus.Code) : $($ExportStatus.Note)")
    }

    Write-Verbose ($Me + ': Asset Export Status: ' +$ExportStatus.status)

    # Wait until the export is finished
    while ($ExportStatus.status -ne 'FINISHED') {
      Start-Sleep -Seconds $RetryInterval

      $ExportStatus = Get-TioExportAssetStatus -ApiKeys $ApiKeys -Uuid $Uuid

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
      $Assets += Get-TioExportAssetChunk -ApiKeys $ApiKeys -Uuid $Uuid -Chunk $Chunk
    }

    Write-Output $Assets

  }

  End {

  }
}