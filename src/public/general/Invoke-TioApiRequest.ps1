
function Invoke-TioApiRequest {
  <#
  .SYNOPSIS
    Invoke the FreshService API
  .DESCRIPTION
    This function is intended to be called by other functions for specific resources/interactions
  .PARAMETER Uri
    Base API URL for the API Call
  .PARAMETER Credential
    PSCredential Object with the API Key stored in the Password property of the object.
  .PARAMETER Method
    Valid HTTP Method to use: GET (Default), POST, DELETE, PUT
  .PARAMETER Body
    PSCustomObject containing data to be sent as HTTP Request Body in JSON format.
  .PARAMETER Depth
    How deep are we going?
  .OUTPUTS
    PSCustomObject containing results if successful.  May be $null if no data is returned
    ErrorObject containing details of error if one is encountered.
  #>
  [CmdletBinding()]

  param(
    [Parameter(Mandatory=$true,
      HelpMessage = 'Full URI to requested resource, including URI parameters')]
		[string]  $Uri,

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
      HelpMessage = 'PsCustomObject containing data that will be sent as the Json Body')]
    [PsCustomObject] $Body,

    [Parameter(Mandatory=$false,
      HelpMessage = 'How deep are we?')]
    [int] $Depth = 0
	)

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose $Me

    if (($Method -eq 'GET') -and $Body) {
      throw "Cannot specify Request Body for Method GET."
    }

    $Header = @{}
    $ApiKey = "accessKey={0}; secretKey={1}" -f $AccessKey.GetNetworkCredential().Password, $SecretKey.GetNetworkCredential().Password
    #$Creds = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $ApiKey,$null)))
    $Header.Add('X-ApiKeys', ($ApiKey))
    $Header.Add('Content-Type', 'application/json')
    $Header.Add('Accept', 'application/json')

    $MaxRelLink = 10
    $RateLimitInterval = 60

    $OldRelLink = ''
  }

  Process {
    # Setup Error Object structure
    $ErrorObject = [PSCustomObject]@{
      Code                  =   $null
      Error                 =   $false
      Type                  =   $null
      Note                  =   $null
      Raw                   =   $_
    }

    $Results = $null

    # Enforce TLSv1.2
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

    # Make the API Call
    if ($Body) {
      # Make the API Call, using the supplied Body. Contents of $Body are the responsibility of the calling code.
      Write-Verbose "$Me : Body supplied"

      try {
        $Results = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $Header -Body ($Body|ConvertTo-Json -Depth 10) -FollowRelLink -MaximumFollowRelLink $MaxRelLink -ResponseHeadersVariable ResponseHeaders
      }
      catch {
        $Exception = $_.Exception
        Write-Verbose "$Me : Exception : $($Exception.StatusCode)"
        $ErrorObject.Error = $true
        $ErrorObject.Code = $Exception.StatusCode
        $ErrorObject.Note = $Exception.Message
        $ErrorObject.Raw = $Exception
        Write-Debug ($ErrorObject | ConvertTo-Json -Depth 2)

        return $ErrorObject
      }
      Write-Debug ($ResponseHeaders | ConvertTo-Json -Depth 5)
      Write-Debug ($Results | ConvertTo-Json -Depth 10)
    } else {
      # Make the API Call without a body. This is for GET requests, where details of what we want to get is in the URI
      Write-Verbose "$Me : No Body supplied"
      try {
        $Results = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $Header -FollowRelLink -MaximumFollowRelLink $MaxRelLink -ResponseHeadersVariable ResponseHeaders
      }
      catch {
        $Exception = $_.Exception
        Write-Verbose "$Me : Exception : $($Exception.StatusCode)"
        $ErrorObject.Error = $true
        $ErrorObject.Code = $Exception.Response.StatusCode.value__
        $ErrorObject.Note = $Exception.Message
        $ErrorObject.Raw = $Exception
        # Write-Debug ($ErrorObject | ConvertTo-Json -Depth 2)

        Throw "$Me : Encountered error getting response.  $($ErrorObject.Code) : $($ErrorObject.Note) from: $RelLink"

        return $ErrorObject
      }
    }
    Write-Verbose ($ResponseHeaders | ConvertTo-Json -Depth 5)

    Write-Output $Results

    # Check if we have a link to a next page
    if (($ResponseHeaders.ContainsKey('Link')) -and ($null -ne $ResponseHeaders.Link) -and ('' -ne $ResponseHeaders.Link)) {
      $Depth += 1
      Write-Verbose "Next Link: $($ResponseHeaders.Link) at Depth: $Depth"
      # Extract the URL from the link text which looks like '<https::domain.freshservice.com/api/v2/tickets?per_page=100&page=21>; Rel="next"'
      $RelLink = [regex]::match($ResponseHeaders.Link,'\<([^\>]+)\>.*').Groups[1].Value

      # If the link has not changed, don't follow it
      if ($RelLink -ne $OldRelLink) {
        # Check Rate Limiting
        $RateLimitMax = $ResponseHeaders.'X-RateLimit-Total'
        $RateLimitRemaining = $ResponseHeaders.'X-RateLimit-Remaining'
        $RateLimitUsedCurrentRequest = $ResponseHeaders.'X-RateLimit-Used-CurrentRequest'
        Write-Verbose "RateLimitMax: $RateLimitMax; RateLimitRemaining: $RateLimitRemaining; RateLimitUsedCurrentRequest: $RateLimitUsedCurrentRequest"

        if (($RateLimitUsedCurrentRequest * $MaxRelLink) -ge $RateLimitRemaining) {
          # Nearing Rate Limit
          Write-Verbose "Sleeping to evade API Rate Limit"
          Start-Sleep -Seconds $RateLimitInterval
        }

        Write-Verbose "Requesting Next set of results from $RelLink"
        # Make a nested call to myself to get the next batch of results within API limits
        # Since you cannot have multiple pages of results for "Creating" resources, a $Body is never required here
        $Results = Invoke-TioApiRequest -Uri $RelLink -Credential $Credential -Method $Method -Depth $Depth

        Write-Output $Results

        if ($Results -is [HashTable] -and $Results.ContainsKey('Error') -and $Results.Error) {
          Write-Debug ($Results | ConvertTo-Json)
          Throw "$Me : Encountered error getting additional results.  $($ErrorObject.Code) : $($ErrorObject.Note) from: $RelLink"
        } else {
          Write-Output $Results
        }
        $OldRelLink = $RelLink
      }
    }
  }

  End {
    Write-Verbose "Returning from Depth: $Depth"
    return
  }
}
