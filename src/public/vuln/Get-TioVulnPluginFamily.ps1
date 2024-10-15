function Get-TioVulnPluginFamily {
  <#
  .SYNOPSIS
    Get Vuln Plugin information
  .DESCRIPTION
    This function returns information about one or more Tenable.io Vuln Plugins
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
      HelpMessage = 'The ID of the plugin family you want to retrieve the list of plugins for.')]
    [string] $Id,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ListAll',
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      HelpMessage = 'Specifies whether to return all plugin families. If true, the plugin families hidden in Tenable Vulnerability Management UI, for example, Port Scanners, are included in the list.')]
    [boolean] $All = $false

  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $Uri.Path = [io.path]::combine($Uri.Path, "plugins/families")
  }

  Process {
    if ($PSBoundParameters.ContainsKey('Id')) {
      # We're looking up a specific Id
      $Uri.Path = [io.path]::combine($Uri.Path, $Id)
    }

    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    $PluginFamilies = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys

    if ($PluginFamilies.families) {
      Write-Output $PluginFamilies.families
      $ResCount = $PluginFamilies.families.Count
    } elseif ($PluginFamilies.plugins) {
      Write-Output $PluginFamilies.plugins
      $ResCount = $PluginFamilies.plugins.count
    } else {
      Write-Output $PluginFamilies
    }
    While ($ResCount -eq $size) {
      $Page++
      Write-Verbose ("{0} : Fetching Page {1}" -f $Me, $Page)
      $PluginFamilies = Get-TioVulnPlugin -ApiKeys $ApiKeys -Method $Method -Size $Size -Page $Page
      Write-Output $PluginFamilies
      $ResCount = $PluginFamilies.Count
    }
  }

  End {

  }
}