function Get-TioAsset {
  <#
  .SYNOPSIS
    Get Tag Category information
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
  .PARAMETER Body
    PSCustomObject containing data to be sent as HTTP Request Body in JSON format.
  .OUTPUTS
    PSCustomObject containing results if successful.  May be $null if no data is returned
    ErrorObject containing details of error if one is encountered.
  #>
  [CmdletBinding(DefaultParameterSetName='ListAll')]

  param(
    [Parameter(Mandatory=$true,
      HelpMessage = 'Full URI to requested resource, including URI parameters')]
    [ValidateScript({
      $TypeName = $_ | Get-Member | Select-Object -ExpandProperty TypeName -Unique
      if ($TypeName -eq 'System.String' -or $TypeName -eq 'System.UriBuilder') {
        [System.UriBuilder]$_
      }
    })]
		[System.UriBuilder]  $Uri,

    [Parameter(Mandatory=$true,
      HelpMessage = 'PSCredential Object containing the Access Key in the Password property')]
    [PSCredential]  $AccessKey,

    [Parameter(Mandatory=$true,
      HelpMessage = 'PSCredential Object containing the Secret Key in the Password property')]
    [PSCredential]  $SecretKey,

    [Parameter(Mandatory=$false,
      HelpMessage = 'Method to use when making the request. Defaults to GET')]
    [ValidateSet("Post","Get","Put","Delete")]
    [string] $Method = "GET",

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ById',
      HelpMessage = 'Id (UUID) of Tag Category Value for which to retrieve details')]
    [string] $Uuid
	)

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $Uri.Path = [io.path]::combine($Uri.Path, "assets")

    # Uri Parameter based processing
    $UriQuery = [System.Web.HttpUtility]::ParseQueryString([string]$Uri.Query)

    if ($PSBoundParameters.ContainsKey('Filter')) {
      $UriQuery.Add('f',$Filter)
    } elseif ($PSBoundParameters.ContainsKey('Value')) {
      $TagFilter = 'value:eq:{0}' -f $Value
      $UriQuery.Add('f',$TagFilter)
    } elseif ($PSBoundParameters.ContainsKey('CategoryName')) {
      $TagFilter = 'category_name:eq:{0}' -f $CategoryName
      $UriQuery.Add('f',$TagFilter)
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
    $Category = Invoke-TioApiRequest -Uri $Uri -AccessKey $AccessKey -SecretKey $SecretKey

    if ($Category.values) {
      Write-Output $Category.values
    } else {
      Write-Output $Category
    }
  }

  End {

  }
}