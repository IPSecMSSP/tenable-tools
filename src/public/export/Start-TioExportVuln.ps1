function Start-TioExportVuln {
  <#
  .SYNOPSIS
    Starts an export of all vulnerabilities that match the request criteria.
  .DESCRIPTION
    This function returns the UUID for the export task running in Tenable.io
  .PARAMETER Uri
    Base API URL for the API Call
  .PARAMETER ApiKeys
    PSObject containing PSCredential Objects with AccessKey and SecretKey.
    Must contain PSCredential Objects named AccessKey and SecretKey with the respective keys stored in the Password property
  .PARAMETER Method
    Valid HTTP Method to use: GET (Default), POST, DELETE, PUT
  .PARAMETER Filter
    Specifies filters for exported vulnerabilities. To return all vulnerabilities, omit the filters object. If
    your request specifies multiple filters, the system combines the filters using the AND search operator.
  .OUTPUTS
    PSCustomObject containing results if successful.  May be $null if no data is returned
    ErrorObject containing details of error if one is encountered.
  #>
  [CmdletBinding(DefaultParameterSetName='IncludeAll')]

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
      HelpMessage = 'Assets per chunk')]
    [int64] $ChunkSize = 1000,

    [Parameter(Mandatory=$false,
      HelpMessage = 'Include Unlicensed Assets')]
    [switch] $IncludeUnlicensed,

    [Parameter(Mandatory=$true,
      ParameterSetName = 'ByFilter',
      HelpMessage = 'Filter condition')]
    [psobject] $Filter
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me


    $Uri.Path = [io.path]::combine($Uri.Path, "vulns/export")

    # Starting a new search
    $Body = @{}
    $Body.Add('num_assets',$ChunkSize)

    if ($PSBoundParameters.ContainsKey('TagCategory')) {
      $Body.Add('filters',@{})
      $Body.filters.add(('tag.' + $TagCategory),$TagValue)
    } elseif ($PSBoundParameters.ContainsKey('Filter')) {
      $Body.Add('filters',$Filter)
    }

    if ($PSBoundParameters.ContainsKey('IncludeUnlicensed')) {
      # Include Unlicensed Assets in Vulnerability Export
      $Body.Add('include_unlicensed','true')
    }

  }

  Process {

    # Initiate the Vuln Export
    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    $VulnExport = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys -Method $Method -Body $Body

    $Uuid = $VulnExport.export_uuid

    Write-Verbose ($Me + ': Vuln Export ID: ' + $Uuid)

    Write-Output $Uuid

  }

  End {

  }
}