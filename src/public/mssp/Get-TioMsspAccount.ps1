function Get-TioMsspAccount {
  <#
  .SYNOPSIS
    Get Account information
  .DESCRIPTION
    This function returns information about one or more Tenable.io Accounts
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
      HelpMessage = 'Id (UUID) of Account for which to retrieve details')]
    [Alias("Id")]
    [string] $Uuid,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ByContainerName',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = 'Container Name of account for which to retrieve details')]
    [string] $Container,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ByCustomName',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = 'Custom name of account for which to retrieve details')]
    [string] $Name,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ByCustomName',
      HelpMessage = 'Require an exact match')]
    [switch] $Exact
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $Uri.Path = [io.path]::combine($Uri.Path, "mssp/accounts")
  }

  Process {
    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    $Accounts = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys

    if ($PSBoundParameters.ContainsKey('Uuid')) {
      Write-Verbose ('Checking Accounts by Uuid: ' + $Uuid)
      # We're looking up a specific Uuid
      foreach ($Account in $Accounts.accounts) {
        Write-Verbose ('  Checking: ' + $Account.uuid)
        if ($Account.uuid -eq $Uuid) {
          Write-Output $Account
        }
      }
    } elseif ($PSBoundParameters.ContainsKey('Container')) {
      Write-Verbose ('Checking Accounts by Container: ' + $Container)
      # We're looking up by Container Name
      foreach ($Account in $Accounts.Accounts) {
        Write-Verbose ('  Checking: ' + $Account.container_name)
        if ($Account.container_name -eq $Container) {
          Write-Output $Account
        }
      }
    } elseif ($PSBoundParameters.ContainsKey('Name')) {
      Write-Verbose ('Checking Accounts by Custom Name: ' + $Name)
      # We're looking up by custom name
      foreach ($Account in $Accounts.Accounts) {
        if ($Exact) {
          Write-Verbose ('  Checking (exact): ' + $Account.custom_name)
          if ($Account.custom_name -eq $Name) {
            Write-Output $Account
          }
        } else {
          Write-Verbose ('  Checking (match): ' + $Account.custom_name)
          if ($Account.custom_name -match $Name) {
            Write-Output $Account
          }
        }
      }
    } else {
      if ($Accounts.accounts) {
        Write-Output $Accounts.accounts
      } else {
        Write-Output $Accounts
      }
    }
  }

  End {

  }
}