# Public Function Example - Replace With Your Function
function Add-YourFirstFunction {
    <#
    .SYNOPSIS
        xxxx
    .DESCRIPTION
        xxxx
    .PARAMETER param1
        xxxx
    .PARAMETER param2
        xxxx
    .INPUTS
        xxxx
    .OUTPUTS
        xxxx
    .EXAMPLE
        xxxx
    .EXAMPLE
        xxxx
    .LINK
        https://url.to.repo/repo/path/
    #>

  [CmdletBinding()]

  Param (
    # Your parameters go here...
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $true,
      Position = 0
    )]
    [string] $param1 = "DefaultValue"
    )

    Begin {

    }

    Process {
        # Your function code goes here...
        Write-Output "Your first function ran!  Supplied Parameter: $param1"

    }

    End {

    }

}