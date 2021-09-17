---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Get-TioFolder

## SYNOPSIS

Get details about one or more Tenable.io Folders.

## SYNTAX

```powershell
Get-TioFolder -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [<CommonParameters>]

Get-TioFolder -ApiKeys <psobject> -Name <string> [-Uri <UriBuilder>] [-Method <string>] [<CommonParameters>]

Get-TioFolder -ApiKeys <psobject> -Type <string> [-Uri <UriBuilder>] [-Method <string>] [<CommonParameters>]
```

## DESCRIPTION

Get details for either a single, or multiple Tenable.io Folders.

When no criteria (Name or Type) are supplied, returns a list of all folders.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioFolder -ApiKeys $TioApiKeys
```

List all Folders

### Example 2

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioFolder -ApiKeys $TioApiKeys -Name 'My Scans'
```

Get all available details for the Folder with name **My Scans**.

### Example 3

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioFolder -ApiKeys $TioApiKeys -Type 'custom'
```

List all folders of type **custom**.

## PARAMETERS

### Uri

Optional. Defaults to **[https://cloud.tenable.com/]**, specify to override.

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### Method

Optional. HTTP Method to use with the API Call.  Defaults to GET.

Valid values: GET, POST, DELETE, PUT

### Name

Optional. Search by Folder Name.

### Type

Optional. Search by Folder Type.

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

Object containing subset of details about the asset, unless queried by UUID.

  unread_count : 3
  custom       : 0
  default_tag  : 1
  type         : main
  name         : My Scans
  id           : 5

## NOTES

Tenable.io provides default folders that automatically organize scans. In addition, you can create custom folders to further organize your scans.

Use the API to create, list, rename, and delete folders.

## RELATED LINKS

[Tenable Developer API Reference : Folders](https://developer.tenable.com/reference#folders)
