function Set-TioMsspLogo {
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
  [CmdletBinding(DefaultParameterSetName='ById',SupportsShouldProcess)]

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
    [string] $Method = "PUT",

    [Parameter(Mandatory=$true,
      ParameterSetName = 'ById',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = 'Id (UUID) of Logo for which to assign on account(s)')]
    [Alias("Id")]
    [string] $Uuid,

    [Parameter(Mandatory=$true,
      ParameterSetName = 'ById',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = 'Array of Account Ids to assign logo to')]
    [string[]] $Accounts
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $Uri.Path = [io.path]::combine($Uri.Path, "mssp/logos")
  }

  Process {

    Write-Verbose "$Me : Uri : $($Uri.Uri)"

    $Body = @{}
    $Body.Add('logo_uuid',$Uuid)

    if (($Accounts.GetType()).Name -eq 'String') {
      $AccountList = @()
      $AccountList += $Accounts
    } else {
      $AccountList = $Accounts
    }

    $Body.Add('account_uuids',$AccountList)

    if ($PSCmdlet.ShouldProcess("Logo ID $Uuid", "Assign to Accounts")) {
      $Logos = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys -Method $Method -Body $Body
    }

    Write-Output $Logos

  }

  End {

  }
}