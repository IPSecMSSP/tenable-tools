function Get-TioAgent {
  <#
  .SYNOPSIS
    Get Tenable Agent Information
  .DESCRIPTION
    This function returns information about available Tenable Agents
  .PARAMETER Uri
    Base API URL for the API Call
  .PARAMETER ApiKeys
    PSObject containing PSCredential Objects with AccessKey and SecretKey.
    Must contain PSCredential Objects named AccessKey and SecretKey with the respective keys stored in the Password property
  .PARAMETER Limit
    Maximum number of Agents to return per query
  .OUTPUTS
    PSCustomObject containing results if successful.  May be $null if no data is returned
    ErrorObject containing details of error if one is encountered.
  #>
  [CmdletBinding(DefaultParameterSetName = 'ListAll')]

  param(
    [Parameter(Mandatory = $false,
      HelpMessage = 'Base URI for the Tenable Environment, defaults to Tenable Cloud')]
    [ValidateScript({
        $TypeName = $_ | Get-Member | Select-Object -ExpandProperty TypeName -Unique
        if ($TypeName -eq 'System.String' -or $TypeName -eq 'System.UriBuilder') {
          [System.UriBuilder]$_
        }
      })]
    [System.UriBuilder]  $Uri = 'https://cloud.tenable.com',

    [Parameter(Mandatory = $true,
      HelpMessage = 'PSObject containing PSCredential Objects with AccessKey and SecretKey')]
    [PSObject]  $ApiKeys,

    [Parameter(Mandatory = $false,
      ParameterSetName = 'ById',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = 'Id of Scanner for which to retrieve details')]
    [Alias("Uuid")]
    [string] $Id,

    [Parameter(Mandatory = $false,
      ParameterSetName = 'ListAll',
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      HelpMessage = 'Maximum number of entries to return per API Call')]
    [int] $Size = 1000,

    [Parameter(Mandatory = $false,
      ParameterSetName = 'ListAll',
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      HelpMessage = 'The page number of the result set')]
    [ValidateRange(0, 10000)]
    [int32] $Page = 0
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose ('{0}: Entering function' -f $Me)

    $Uri.Path = [io.path]::combine($Uri.Path, 'scanners', 'null', 'agents')

    $Method = 'GET'
  }

  Process {
    # Intitialise result set
    $ResCount = 0

    # Parse exisint query parameters
    $QueryParam = [System.Web.HttpUtility]::ParseQueryString($Uri.Query)

    if ($PSBoundParameters.ContainsKey('Id')) {
      # We're looking up a specific Id
      $Uri.Path = [io.path]::combine($Uri.Path, $Id)
    } else {
      # We're not looking for a specific ID, so set limit and offset based on requested page
      $QueryParam['limit'] = $Size
      $QueryParam['offset'] = ($Page * $Size)
    }

    # Add the query back to the URI
    $Uri.Query = $QueryParam.ToString()

    # Make the call to the API
    Write-Verbose "$Me : Uri : $($Uri.Uri)"
    $Response = Invoke-TioApiRequest -Uri $Uri -ApiKeys $ApiKeys -Method $Method

    # Determine if we need to loop through pages
    if (!($PSBoundParameters.ContainsKey('Page'))) {
      # A specific page was not requested, get all available pages
      $Page = 0
      if ($Response.agents) {
        Write-Output $Response.agents

        Write-Debug ('{0}: Response: {1}' -f $Me, ($Response | ConvertTo-Json -Compress -Depth 10))
        $ResCount += $Response.agents.Count
        $TotalResults = $Response.pagination.total

        # Get the number pages of results (have to round up)
        $Pages = [Math]::Ceiling($TotalResults / $Size)
        Write-Verbose ('{0}: Fetching all pages. Total Results: {1}; Total Pages: {2}' -f $Me, $TotalResults, $Pages)

      } else {
        Write-Output $Response
      }

      # We have the first page, loop through the remainder (if there are any)
      for ($Page = 1; $Page -lt $Pages; $Page++ ) {
        Clear-Variable 'Response'
        Write-Verbose ("{0} : Fetching Page {1}" -f $Me, $Page)

        # Call ourselves to get the next page(s)
        $Response = Get-TioAgent -ApiKeys $ApiKeys -Size $Size -Page $Page

        Write-Debug ('{0}: Page: {1}; Response: {2}' -f $Me, $Page, ($Response | ConvertTo-Json -Compress -Depth 10))

        Write-Verbose ("{0} : Fetched Page {1}" -f $Me, $Page)
        Write-Output $Response
        $ResCount += $Response.Count
      }
    } else {
      if ($Response.agents) {
        Write-Output $Response.agents
      }
      else {
        Write-Output $Response
      }
    }

  }

  End {

  }
}