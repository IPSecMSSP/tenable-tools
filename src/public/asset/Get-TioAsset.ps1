function Get-TioAsset {
  <#
  .SYNOPSIS
    Get Asset information
  .DESCRIPTION
    This function returns information about one or more Tenable.io Assets
  .PARAMETER Uri
    Base API URL for the API Call
  .PARAMETER ApiKeys
    PSObject containing PSCredential Objects with AccessKey and SecretKey.
    Must contain PSCredential Objects named AccessKey and SecretKey with the respective keys stored in the Password property
  .PARAMETER Method
    Valid HTTP Method to use: GET (Default), POST, DELETE, PUT
  .PARAMETER Body
    PSCustomObject containing data to be sent as HTTP Request Body in JSON format.
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
      HelpMessage = 'PSObject containing PSCredential Objects with AccessKey and SecretKey')]
    [PSObject]  $ApiKeys,

    [Parameter(Mandatory=$false,
      HelpMessage = 'Method to use when making the request. Defaults to GET')]
    [ValidateSet("Post","Get","Put","Delete")]
    [string] $Method = "GET",

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ById',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = 'Id (UUID) of Asset for which to retrieve details')]
    [Alias("Id")]
    [string] $Uuid,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ByHostname',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = 'Hostname for which to retrieve details')]
    [string] $Hostname,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ByIpv4',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = 'IPv4 for which to retrieve details')]
    [string] $IPv4
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $Uri.Path = [io.path]::combine($Uri.Path, "assets")
  }

  Process {
    if ($PSBoundParameters.ContainsKey('Uuid')) {
      # We're looking up a specific Id
      $Uri.Path = [io.path]::combine($Uri.Path, $Uuid)
    }

    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    $Assets = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys

    if ($PSBoundParameters.ContainsKey('Hostname')) {
      Write-Verbose ('Checking Assets by Hostname: ' + $Hostname)
      # We're looking up a specific Hostname
      foreach ($Asset in $Assets.assets) {
        Write-Verbose ('  Checking: ' + $Folder.name)
        if ($asset.hostname -eq $Hostname) {
          Write-Output $Asset
        }
      }
    } elseif ($PSBoundParameters.ContainsKey('IPv4')) {
      Write-Verbose ('Checking Folders by Type: ' + $IPv4)
      # We're looking up a specific Type
      foreach ($Asset in $Assets.assets) {
        Write-Verbose ('  Checking: ' + $Asset.ipv4)
        if ($Asset.ipv4 -eq $Ipv4) {
          Write-Output $Asset
        }
      }
    } else {
      if ($Assets.assets) {
        Write-Output $Assets.assets
      } else {
        Write-Output $Assets
      }
    }
  }

  End {

  }
}