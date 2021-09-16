function Get-TioFolder {
  <#
  .SYNOPSIS
    Lists both Tenable-provided folders and the current user's custom folders.
  .DESCRIPTION
    This function returns information about one or more Tenable.io Folders
  .PARAMETER Uri
    Base API URL for the API Call
  .PARAMETER ApiKeys
    PSObject containing PSCredential Objects with AccessKey and SecretKey.
    Must contain PSCredential Objects named AccessKey and SecretKey with the respective keys stored in the Password property
  .PARAMETER Method
    Valid HTTP Method to use: GET (Default), POST, DELETE, PUT
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

    [Parameter(Mandatory=$true,
      ParameterSetName = 'ByName',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = 'Name of folder for which to retrieve details')]
    [string] $Name,

    [Parameter(Mandatory=$true,
      ParameterSetName = 'ByType',
      HelpMessage = 'Type of folder for which to retrieve details')]
    [ValidateSet('main', 'trash', 'custom')]
    [string] $Type
	)

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $Uri.Path = [io.path]::combine($Uri.Path, "folders")

  }

  Process {
    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    $Folders = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys

    Write-Debug ($Folders | ConvertTo-Json -depth 10)

    if ($PSBoundParameters.ContainsKey('Name')) {
      Write-Verbose ('Checking Folders by Name: ' + $Name)
      # We're looking up a specific Name
      foreach ($Folder in $Folders.folders) {
        Write-Verbose ('  Checking: ' + $Folder.name)
        if ($Folder.name -eq $Name) {
          Write-Output $Folder
        }
      }
    } elseif ($PSBoundParameters.ContainsKey('Type')) {
      Write-Verbose ('Checking Folders by Type: ' + $Type)
      # We're looking up a specific Type
      foreach ($Folder in $Folders.folders) {
        Write-Verbose ('  Checking: ' + $Folder.type)
        if ($Folder.type -eq $Type) {
          Write-Output $Folder
        }
      }
    } else {
      if ($Folders.folders) {
        Write-Output $Folders.folders
      } else {
        Write-Output $Folders
      }
    }


  }

  End {

  }
}