<#
  .SYNOPSIS
    Synchronise Tenable.io Tag Cagegories into LogRhythm Lists
  .DESCRIPTION
    Tenable.IO allows organisations to create Tag Categories that may be used to set up scheduled scans, etc.  Each Tag Category has one or more values associated with it.

    Tenable.IO also allows these to be dynamically updated based on properties of assets that may come about as a result of a discovery scan, or other scans.

    This script begins by pulling a list of Tag Categories from Tenable.IO and storing these in a "Configuration" list in LogRhythm.
    A Subsequent list allows the tag categories that are to be synchronised to be specified by adding these to the list.

    The Synchronisation, when run, perform the following tasks:

    * Synchronise the list of available Tag Categories and save them in a list.
    * Iterate through the values in the "enabled" list, and synchronise those Tag Categories
      * Each Value within the Tag Category will result in a separate list

    List Naming Convention is as follows:

    TIO : Conf : Tag Category Available
    TIO : Conf : Tag Category Enabled
    TIO : Tag : Tag Category : Tag Value

    The List Prefix can be specified as a parameter and defaults to 'TIO'
  .PARAMETER ApiKeys
    PSObject containing PSCredential Objects with AccessKey and SecretKey.
    Must contain PSCredential Objects named AccessKey and SecretKey with the respective keys stored in the Password property
  .PARAMETER ListPrefix
    The Prefix to use on all lists created and managed by this invokation.

    Default: 'TIO'
  .PARAMETER EntityName
    Name of Entity in LogRhythm that will be set as the 'Entity' for the list.  Determines list visibility when used with Restricted Access types.
  .PARAMETER ListOwner
    Display Name of the 'Person' in LogRhythm that will be set as the list owner.
  .PARAMETER ListReadAccess
    Level of Read Permission to assign to new list.  Controls visibility of list to other users.

    Default: PublicGlobalAnalyst
  .PARAMETER ListWriteAccess
    Level or Write Permisssions to assign to new list.  Controls who is able to make changes to the list.

    Default: PublicGlobalAdmin
  .PARAMETER HostnameOnly
    Add only hostnames to the list
  .PARAMETER IPv4Only
    Add only IPv4 Addresses to the list
  .NOTES
    This script requires the presence of both the LogRhythm.Tools and Tenable.Tools PowerShell Modules. LogRhythm.Tools module must already be configured for the user running this script.
#>

param(
  [Parameter(Mandatory=$true)]
  [psobject]$ApiKeys,

  [Parameter(Mandatory=$false)]
  [string]$ListPrefix = 'TIO',

  [Parameter(Mandatory=$false)]
  [string]$EntityName = 'Primary Site',

  [Parameter(Mandatory=$false)]
  $ListOwner,

  [Parameter(Mandatory=$false)]
  [ValidateSet('private','publicall', 'publicglobaladmin', 'publicglobalanalyst', 'publicrestrictedadmin', `
  'publicrestrictedanalyst', ignorecase=$true)]
  [string]$ListReadAccess = 'PublicGlobalAnalyst',

  [Parameter(Mandatory=$false)]
  [ValidateSet('private','publicall', 'publicglobaladmin', 'publicglobalanalyst', 'publicrestrictedadmin', `
  'publicrestrictedanalyst', ignorecase=$true)]
  [string]$ListWriteAccess = 'PublicGlobalAdmin',

  [Parameter(Mandatory=$false)]
  [switch]$HostnameOnly,

  [Parameter(Mandatory=$false)]
  [switch]$IPv4Only
)

#region List Owner Details
If ($PSBoundParameters -contains 'ListOwner') {
  # List Owner was provided, perform some validation
  if ($ListOwner -is [int]) {
    # If the ListOwner is an integer, use that as the ID
    $ListOwnerId = $ListOwner
    Write-Verbose "$(Get-Timestamp)List Owner ID: $ListOwnerId"
  } else {
    $ListOwnerResults = Get-LrUsers -Name $ListOwner -Exact

    if ($ListOwnerResults) {
      $ListOwnerId = $ListOwnerResults | Select-Object -ExpandProperty number
      Write-Verbose "$(Get-Timestamp)List Owner ID: $ListOwnerId"
    } else {
      return "$(Get-timestamp) Error - Unable to retrieve user identity ID for user: $ListOwner"
    }
  }
} else {
  # List Owner was not provided, use ID from LR Token (ie, current user)
  $ListOwnerId = (Get-LrApiTokenInfo).UserId
}

#endregion

#region Available/Enabled Tag Categories

# Configuration List Names
$ListTioTagCategoryAvailable = '{0} : Conf : Tag Category Available' -f $ListPrefix
$ListTioTagCategoryEnabled = '{0} : Conf : Tag Category Enabled' -f $ListPrefix

# Available Tag Categories
# Determine if LR List exists
$ListStatus = Get-LrLists -Name $ListTioTagCategoryAvailable -Exact

# Create the list if it does not exist
if (!$ListStatus) {
    Write-Verbose "$(Get-TimeStamp) - Create New List: $ListTioTagCategoryAvailable."
    New-LrList -Name $ListTioTagCategoryAvailable -ListType "generalvalue" -UseContext "message" -ShortDescription "List of available Tenable.IO Tag Categories.  Do not modify this list manually." -ReadAccess $ListReadAccess -WriteAccess $ListWriteAccess -Owner $ListOwnerId -EntityName $EntityName
} else {
    Write-Verbose "$(Get-TimeStamp) - List Verification: $ListTioTagCategoryAvailable exists.  Synchronizing contents between Tenable.IO and this LogRhythm list."
}

# Sync Available Tag Categories
Try {
  $TioTagCategories = Get-TioTagCategory -ApiKeys $ApiKeys
} Catch {
  Write-Error "$(Get-timestamp) - Unable to retrieve Tenable.IO Tag Categories. See Get-TioTagCategory"
}

$TioTagCategoryNames = ($TioTagCategories | Select-Object -Property 'name').name

Write-Verbose "$(Get-TimeStamp) - Updating List Contents: $ListTioTagCategoryAvailable."
Sync-LrListItems -Name $ListTioTagCategoryAvailable -Value $TioTagCategoryNames

#Enabled Tag Categories
# Determine if LR List exists
$ListStatus = Get-LrLists -Name $ListTioTagCategoryEnabled -Exact

# Create the list if it does not exist
if (!$ListStatus) {
  Write-Verbose "$(Get-TimeStamp) - Create New List: $ListTioTagCategoryEnabled."
  New-LrList -Name $ListTioTagCategoryEnabled -ListType "generalvalue" -UseContext "message" -ShortDescription "List of enabled Tenable.IO Tag Categories.  Modify this list manually from values in $ListTioTagCategoryAvailable" -ReadAccess $ListReadAccess -WriteAccess $ListWriteAccess -Owner $ListOwnerId -EntityName $EntityName
} else {
  Write-Verbose "$(Get-TimeStamp) - List Verification: $ListTioTagCategoryEnabled exists."
}

#endregion

#region Value Sync - Tag Categories

# List of Enabled Tag Categories
$EnabledTioTagCategories = Get-LrlIstItems -Name $ListTioTagCategoryEnabled -Exact -ValuesOnly

if($EnabledTioTagCategories) {
  Write-Output "$(Get-TimeStamp) - Begin - Tenable.IO Tag Category Sync"

  foreach ($TioTagCategory in $EnabledTioTagCategories) {
    # Get available Values for this Tag Category
    Write-Verbose "$(Get-TimeStamp) - Synchronising Tag Category: $TioTagCategory"
    $TagCategoryValues = Get-TioTagValue -ApiKeys $ApiKeys -CategoryName $TioTagCategory
    $TagCategoryValueIds = ($TagCategoryValues).uuid
    #$TagCategoryValueNames = ($TagCategoryValues).value

    foreach ($TagUuid in $TagCategoryValueIds) {
      # Construct List Name
      $TioTagValue = Get-TioTagValue -ApiKeys $ApiKeys -Uuid $TagUuid
      $ListTioCategoryValueName = (Get-Culture).TextInfo.ToTitleCase(('{0} : Tag : {1} : {2}' -f $ListPrefix, $TioTagCategory, $TioTagValue.value))

      # Check for existence of list
      $ListStatus = Get-LrLists -Name $ListTioCategoryValueName -Exact

      # Create the list if it does not exist, else update it
      $ShortDescription = 'Tenable.IO Tag Category: {0}; Tag Value: {1}.  Do not modify this list manually, it is Synchronised from Tenable.IO.' -f $TioTagValue.category_description, $TioTagValue.description
      if (!$ListStatus) {
        Write-Verbose "$(Get-TimeStamp) - Creating List: $ListTioCategoryValueName."
        New-LrList -Name $ListTioCategoryValueName -ListType 'host' -ShortDescription $ShortDescription -ReadAccess $ListReadAccess -WriteAccess $ListWriteAccess -Owner $ListOwnerId -EntityName $EntityName
      } else {
        Write-Verbose "$(Get-TimeStamp) - List Verification: $ListTioCategoryValueName exists, updating."
        Update-LrList -Guid $ListStatus.guid -Name $ListTioCategoryValueName -ListType 'host' -ShortDescription $ShortDescription -ReadAccess $ListReadAccess -WriteAccess $ListWriteAccess -Owner $ListOwnerId -EntityName $EntityName
      }

      # Get entries from Tenable.IO
      Write-Verbose "$(Get-TimeStamp) - Running: Get-TioExportAsset -TagCategory $($TioTagValue.category_name) -TagValue $($TioTagValue.value)"
      $AssetList = Get-TioExportAsset -ApiKeys $ApiKeys -TagCategory $TioTagValue.category_name -TagValue $TioTagValue.value

      if (!$HostnameOnly) {
        # Build (a) list(s) of values to load into the list.
        $IPv4List = ($AssetList | Select-Object -Property 'ipv4s').ipv4s | Select-Object -Unique

        # Populate list with IPs
        if($IPv4List.Count -gt 0) {
          Write-Information "$(Get-TimeStamp) - Syncing Quantity: $($IPv4List.Count) IPv4 to List $ListTioCategoryValueName"
          $result = Sync-LrListItems -Value $IPv4List -Name $ListTioCategoryValueName
          if ($result.Error) {
            Write-Verbose "$(Get-TimeStamp) - IPv4 Items - Something went Wrong"
          }
        } else {
          Write-Information "$(Get-TimeStamp) - IPv4 Quantity: $($IPv4List.Count)"
        }
      }

      If(!$IPv4Only) {
        $HostnameList = ($AssetList | Select-Object -Property 'hostnames').hostnames | Select-Object -Unique

        # Populate list with HostNames
        if($HostnameList.Count -gt 0) {
          Write-Information "$(Get-TimeStamp) - Syncing Quantity: $($HostnameList.Count) IPv4 to List $ListTioCategoryValueName"
          $result = Sync-LrListItems -Value $HostnameList -Name $ListTioCategoryValueName
          if ($result.Error) {
            Write-Verbose "$(Get-TimeStamp) - Hostname Items - Something went Wrong"
          }
        } else {
          Write-Information "$(Get-TimeStamp) - IPv4 Quantity: $($HostnameList.Count)"
        }
      }

      Write-Verbose "$(Get-Timestamp) - Memory Management: Clearing Variables"
      Clear-Variable AssetList -ErrorAction SilentlyContinue
      Clear-Variable IPv4List -ErrorAction SilentlyContinue
      Clear-Variable HostnameList -ErrorAction SilentlyContinue
      Clear-Variable ListStatus -ErrorAction SilentlyContinue
      [GC]::Collect()
    }
    Write-Output "$(Get-TimeStamp) - End - Tenable.IO Tag Category Sync"
  }
}

#endregion