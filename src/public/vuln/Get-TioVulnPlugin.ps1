function Get-TioVulnPlugin {
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
      HelpMessage = 'Id of Vuln Plugin for which to retrieve details')]
    [string] $Id,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ListAll',
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      HelpMessage = 'The number of records to include in the result set')]
    [ValidateRange(1, 10000)]
    [int32] $Size = 1000,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ListAll',
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      HelpMessage = 'The page number of the result set')]
    [ValidateRange(1, 10000)]
    [int32] $Page = 1,

    [Parameter(Mandatory=$false,
      ParameterSetName = 'ListAll',
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      HelpMessage = 'Only provide Plugins updated since the provided date (YYY-MM-DD)')]
    [string] $LastUpdated

  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    $Uri.Path = [io.path]::combine($Uri.Path, "plugins/plugin")
  }

  Process {
    $QueryParam = [System.Web.HttpUtility]::ParseQueryString($Uri.Query)
    if ($PSBoundParameters.ContainsKey('Id')) {
      # We're looking up a specific Id
      $Uri.Path = [io.path]::combine($Uri.Path, $Id)
    } else {
      $QueryParam['size'] = $Size
      $QueryParam['page'] = $Page
      if ($PSBoundParameters.ContainsKey('LastUpdated')) {
        $QueryParam['last_updated'] = $LastUpdated
      }
    }

    $Uri.Query = $QueryParam.ToString()

    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    $Plugins = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys

    if (!($PSBoundParameters.ContainsKey('Page'))) {
      # A specific page was not requested, get all available pages
      $Page = 1
      if ($Plugins.data.plugin_details) {
        Write-Output $Plugins.data.plugin_details
        $ResCount = $Plugins.data.plugin_details.Count
      } else {
        Write-Output $Plugins
      }
      While ($ResCount -eq $size) {
        $Page++
        Write-Verbose ("{0} : Fetching Page {1}" -f $Me, $Page)
        $Plugins = Get-TioVulnPlugin -ApiKeys $ApiKeys -Method $Method -Size $Size -Page $Page
        Write-Output $Plugins
        $ResCount = $Plugins.Count
      }
    } else {
      # Provide only the requested page
      if ($Plugins.data.plugin_details) {
        Write-Output $Plugins.data.plugin_details
      } else {
        Write-Output $Plugins
      }
    }
  }

  End {

  }
}