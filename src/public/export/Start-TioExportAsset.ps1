function Start-TioExportAsset {
  <#
  .SYNOPSIS
    Starts an asynchronous export of all assets that match the request criteria.
  .DESCRIPTION
    This function returns the UUID of the export job that is executing in the Tenable.io environment
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
  [CmdletBinding(DefaultParameterSetName = 'ByTag', SupportsShouldProcess)]

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

    [Parameter(Mandatory = $false,
      HelpMessage = 'Results per chunk')]
    [int64] $ChunkSize = 1000,

    [Parameter(Mandatory=$true,
      ParameterSetName = 'ByFilter',
      HelpMessage = 'Filter condition')]
    [PSObject] $Filter,

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

    $Uri.Path = [io.path]::combine($Uri.Path, "assets/export")

    # Starting a new search
    $Body = @{}
    $Body.Add('chunk_size',$ChunkSize)

    if ($PSBoundParameters.ContainsKey('TagCategory')) {
      $Body.Add('filters',@{})
      $Body.filters.add(('tag.' + $TagCategory),$TagValue)
    } elseif ($PSBoundParameters.ContainsKey('Filter')) {
      $Body.Add('filters',$Filter)
    }

    Write-Debug ('{0}: Filters: {1}' -f $Me, ($Filter | ConvertTo-Json -Compress))
  }

  Process {

    # Initiate the Asset Export
    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    Write-Debug ('{0}: Body: {1}' -f $Me, ($Body | ConvertTo-Json -Depth 10 -Compress))

    if ($PSCmdlet.ShouldProcess("$Uri", "Start Asset Export Task")) {
      $AssetExport = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys -Method $Method -Body $Body
    }

    $Uuid = $AssetExport.export_uuid

    Write-Verbose ($Me + ': Asset Export ID: ' + $Uuid)

    Write-Output $Uuid

  }

  End {

  }
}