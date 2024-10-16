
function Invoke-TioApiRequest {
  <#
  .SYNOPSIS
    Invoke the Tenable.io API
  .DESCRIPTION
    This function is intended to be called by other functions for specific resources/interactions
  .PARAMETER Uri
    Base API URL for the API Call
  .PARAMETER ApiKeys
    PSObject containing PSCredential Objects with AccessKey and SecretKey.
    Must contain PSCredential Objects named AccessKey and SecretKey with the respective keys stored in the Password property
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
    [ValidateScript({
      $TypeName = $_ | Get-Member | Select-Object -ExpandProperty TypeName -Unique
      if ($TypeName -eq 'System.String' -or $TypeName -eq 'System.UriBuilder') {
        [System.UriBuilder]$_
      }
    })]
		[System.UriBuilder]  $Uri,

    [Parameter(Mandatory=$true,
      HelpMessage = 'PSObject containing PSCredential Objects with AccessKey and SecretKey')]
    [PSObject]  $ApiKeys,

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
    $ApiKey = "accessKey={0}; secretKey={1}" -f $ApiKeys.AccessKey.GetNetworkCredential().Password, $ApiKeys.SecretKey.GetNetworkCredential().Password
    $Header.Add('X-ApiKeys', ($ApiKey))
    $Header.Add('Content-Type', 'application/json')
    $Header.Add('Accept', 'application/json')

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
      Write-Debug ("$Me : Body : " + ($Body | ConvertTo-Json -Depth 10 -Compress))

      try {
        $Results = Invoke-RestMethod -Method $Method -Uri $Uri.Uri -Headers $Header -Body ($Body|ConvertTo-Json -Depth 10) -ResponseHeadersVariable ResponseHeaders
      }
      catch {
        $Exception = $_.Exception
        Write-Verbose "$Me : Exception : $($Exception.Response.StatusCode.value__) : $($Exception.Message)"
        $ErrorObject.Error = $true
        $ErrorObject.Code = $Exception.Response.StatusCode.value__
        $ErrorObject.Note = $Exception.Message
        $ErrorObject.Raw = $Exception
        Write-Debug ($ErrorObject | ConvertTo-Json -Depth 10)

        return $ErrorObject
      }
      Write-Debug ($ResponseHeaders | ConvertTo-Json -Depth 5)
      Write-Debug ($Results | ConvertTo-Json -Depth 10)
    } else {
      # Make the API Call without a body. This is for GET requests, where details of what we want to get is in the URI
      Write-Verbose "$Me : No Body supplied"
      try {
        $Results = Invoke-RestMethod -Method $Method -Uri $Uri.Uri -Headers $Header -ResponseHeadersVariable ResponseHeaders
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
    Write-Debug ($ResponseHeaders | ConvertTo-Json -Depth 5)

    Write-Output $Results
  }

  End {
    Write-Verbose "Returning from Depth: $Depth"
    return
  }
}
