function Get-TioMsspLogo {
  <#
  .SYNOPSIS
    Get Logo information
  .DESCRIPTION
    This function returns information about one or more Tenable.io Logos
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
      HelpMessage = 'Id (UUID) of Logo for which to retrieve details')]
    [Alias("Id")]
    [string] $Uuid,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ByContainerId',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = 'Container Id of Logo for which to retrieve details')]
    [string] $ContainerId,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ByName',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = 'Custom name of Logo for which to retrieve details')]
    [string] $Name,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ByName',
      HelpMessage = 'Require an exact match')]
    [switch] $Exact
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $Uri.Path = [io.path]::combine($Uri.Path, "mssp/logos")
  }

  Process {
    if ($PSBoundParameters.ContainsKey('Uuid')) {
      # We're looking up a specific Id
      $Uri.Path = [io.path]::combine($Uri.Path, $Uuid)
    }

    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    $Logos = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys

    if ($PSBoundParameters.ContainsKey('ContainerId')) {
      Write-Verbose ('Checking Logos by ContainerId: ' + $ContainerID)
      # We're looking up by Container Id
      foreach ($Logo in $Logos.Logos) {
        Write-Verbose ('  Checking: ' + $Logo.container_uuid)
        if ($Logo.container_uuid -eq $ContainerId) {
          Write-Output $Logo
        }
      }
    } elseif ($PSBoundParameters.ContainsKey('Name')) {
      Write-Verbose ('Checking Logos by Custom Name: ' + $Name)
      # We're looking up by custom name
      foreach ($Logo in $Logos.logos) {
        if ($Exact) {
          Write-Verbose ('  Checking (exact): ' + $Logo.name)
          if ($Logo.name -eq $Name) {
            Write-Output $Logo
          }
        } else {
          Write-Verbose ('  Checking (match): ' + $Logo.name)
          if ($Logo.name -match $Name) {
            Write-Output $Logo
          }
        }
      }
    } else {
      if ($Logos.logos) {
        Write-Output $Logos.logos
      } else {
        Write-Output $Logos
      }
    }
  }

  End {

  }
}