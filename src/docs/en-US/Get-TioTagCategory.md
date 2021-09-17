---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Get-TioTagCategory

## SYNOPSIS

Get details about one or more Tenable.io Tag Categories.

## SYNTAX

```powershell
Get-TioTagCategory -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [<CommonParameters>]

Get-TioTagCategory -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Uuid <string>] [<CommonParameters>]

Get-TioTagCategory -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Filter <string>] [<CommonParameters>]

Get-TioTagCategory -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Name <string>] [<CommonParameters>]
```

## DESCRIPTION

Get details for either a single, or multiple Tenable.io Tag Categories.

When no criteria (Uuid, Filter or Name) are supplied, returns all Tag Categories.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioTagCategory -ApiKeys $TioApiKeys
```

List all Tag Categories

### Example 2

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioTagCategory -ApiKeys $TioApiKeys -Uuid ad082ebc-e375-4250-93b3-ded6dd2757ab
```

Get details for the Tag Category with UUID **ad082ebc-e375-4250-93b3-ded6dd2757ab**.

### Example 3

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioTagCategory -ApiKeys $TioApiKeys -Name 'Category 1'
```

Get details for the Tag Category with Name **Category 1**.

### Example 4

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioAsset -ApiKeys $TioApiKeys -Filter 'description:match:windows'
```

Get a list of Categories where the description contains **windows**.

## PARAMETERS

### Uri

Optional. Defaults to **[https://cloud.tenable.com/]**, specify to override.

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### Method

Optional. HTTP Method to use with the API Call.  Defaults to GET.

Valid values: GET, POST, DELETE, PUT

### Uuid

Optional. Search by Tag Category UUID.

Alias: Id

### Name

Optional. Search by Tag Category Name.

### Filter

Optional. Search using a filter.

A filter condition in the `field:operator:value` format, for example, `f=name:match:location`. Filter conditions can include:

* name:eq:**category_name**
* name:match:**partial_name**
* description:eq:**description**
* description:match:**partial_description**
* updated_at:date-eq:**timestamp_as_int**
* updated_at:date-gt:**timestamp_as_int**
* updated_at:date-lt:**timestamp_as_int**
* created_at:date-eq:**timestamp_as_int**
* created_at:date-gt:**timestamp_as_int**
* created_at:date-lt:**timestamp_as_int**
* updated_by:eq:**user_uuid**

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

Object containing subset of details about the asset, unless queried by UUID.

  uuid        : fda11a4e-ffe2-47a2-9492-54575c40e256
  created_at  : 23/09/2020 06:50:18
  created_by  : admin@domain.com
  updated_at  : 29/09/2020 04:32:25
  updated_by  : admin@domain.com
  name        : Linux Production Server
  description : Linux Production Server
  reserved    : False
  value_count : 3

## NOTES

With tags, you can categorize and create logical groupings of network assets in Tenable.io. Tags are uniquely named and applied
across your organization's network. You can provide descriptions of tags and tag categories to better explain their usage.

Use the API endpoints to perform standard CRUD operations on tag categories and values, and also assign tags to assets.

## RELATED LINKS

[Tenable Developer API Reference : Tags](https://developer.tenable.com/reference#tags)
