function Get-TioExportVuln {
  <#
  .SYNOPSIS
    Exports all vulnerabilities that match the request criteria.
  .DESCRIPTION
    This function returns information about one or more Tenable.io Vulnerabilities
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
    [string] $Filter,

    [Parameter(Mandatory=$true,
      ParameterSetName = 'ByUuid',
      HelpMessage = 'Tag Value Filter condition')]
    [string] $Uuid
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $RetryInterval = 30

    $Uri.Path = [io.path]::combine($Uri.Path, "vulns/export")

    if (!$PSBoundParameters.ContainsKey('Uuid')) {
      # Starting a new search
      $Body = @{}
      $Body.Add('num_assets',$ChunkSize)

      if ($PSBoundParameters.ContainsKey('TagCategory')) {
        $Body.Add('filters',@{})
        $Body.filters.add(('tag.' + $TagCategory),$TagValue)
      } elseif ($PSBoundParameters.ContainsKey('Filter')) {
        $Body.Add('filters',$Filter)
      }
    }

    if ($PSBoundParameters.ContainsKey('IncludeUnlicensed')) {
      # Include Unlicensed Assets in Vulnerability Export
      $Body.Add('include_unlicensed','true')
    }

  }

  Process {

    if (!$PSBoundParameters.ContainsKey('Uuid')) {
      # Initiate the Vuln Export
      Write-Verbose "$Me : Uri : $($Uri.Uri)"
      $VulnExport = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys -Method $Method -Body $Body

      $Uuid = $VulnExport.export_uuid
    }

    Write-Verbose ($Me + ': Vuln Export ID: ' + $Uuid)
    # Start by checking the status
    $ExportStatus = Get-TioExportVulnStatus -ApiKeys $ApiKeys -Uuid $Uuid

    if ($ExportStatus.Error) {
      Write-Error ("$Me : Exception: $($ExportStatus.Code) : $($ExportStatus.Note)")
    }

    Write-Verbose ($Me + ': Vuln Export Status: ' +$ExportStatus.status)

    # Wait until the export is finished
    while ($ExportStatus.status -ne 'FINISHED') {
      Start-Sleep -Seconds $RetryInterval

      $ExportStatus = Get-TioExportVulnStatus -ApiKeys $ApiKeys -Uuid $Uuid

      # Check for failures
      if ($ExportStatus.status -eq 'CANCELLED' -or $ExportStatus.status -eq 'ERROR') {
        Write-Error 'Vuln Export Failed'
        exit 1
      }

      Write-Verbose ($Me + ': Vuln Export Status: ' + $ExportStatus.status)
    }

    # We should have our results available for download now

    $Vulns = @()

    foreach ($Chunk in $ExportStatus.chunks_available) {
      $Vulns += Get-TioExportVulnChunk -ApiKeys $ApiKeys -Uuid $Uuid -Chunk $Chunk
    }

    Write-Output $Vulns

  }

  End {

  }
}