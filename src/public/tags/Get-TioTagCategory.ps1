function Get-TioTagCategory {
  <#
  .SYNOPSIS
    Get Tag Category information
  .DESCRIPTION
    This function returns information about one or more Tenable.io Tag Categories
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
      HelpMessage = 'Id (UUID) of Category for which to retrieve details')]
    [string] $Uuid,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ByFilter',
      HelpMessage = 'Filter condition')]
    [string] $Filter,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ByName',
      HelpMessage = 'Get details of Asset Tag Categry by name')]
    [string] $Name
	)

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $Uri.Path = [io.path]::combine($Uri.Path, "tags/categories")

    # Uri Parameter based processing
    $UriQuery = [System.Web.HttpUtility]::ParseQueryString([string]$Uri.Query)

    if ($PSBoundParameters.ContainsKey('Filter')) {
      $UriQuery.Add('f',$Filter)
    } elseif ($PSBoundParameters.ContainsKey('Name')) {
      $NameFilter = 'name:eq:{0}' -f $Name
      $UriQuery.Add('f',$NameFilter)
    }

    # Add the parameters to the URI object
    $Uri.Query = $UriQuery.ToString()
  }

  Process {
    if ($PSBoundParameters.ContainsKey('Uuid')) {
      # We're looking up a specific Id
      $Uri.Path = [io.path]::combine($Uri.Path, $Uuid)
    }

    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    $Category = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys

    if ($Category.categories) {
      Write-Output $Category.categories
    } else {
      Write-Output $Category
    }
  }

  End {

  }
}