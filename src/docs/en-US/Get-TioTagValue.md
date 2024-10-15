---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Get-TioTagValue

## SYNOPSIS

Get details about one or more Tenable.io Tag Category Values.

## SYNTAX

```powershell
Get-TioTagValue -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [<CommonParameters>]

Get-TioTagValue -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Uuid <string>] [<CommonParameters>]

Get-TioTagValue -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Filter <string>] [<CommonParameters>]

Get-TioTagValue -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Value <string>] [<CommonParameters>]

Get-TioTagValue -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-CategoryName <string>] [<CommonParameters>]
```

## DESCRIPTION

Get details for either a single, or multiple Tenable.io Tag Category Values.

When no criteria (Uuid, Filter, Value or CategoryName) are supplied, returns all Tag Values.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioTagValue -ApiKeys $TioApiKeys
```

List all Tag Category Values

### Example 2

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioTagValue -ApiKeys $TioApiKeys -Uuid ad082ebc-e375-4250-93b3-ded6dd2757ab
```

Get details for Tag Value with UUID **ad082ebc-e375-4250-93b3-ded6dd2757ab**.

### Example 3

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioTagValue -ApiKeys $TioApiKeys -Filter 'description:match:sitea'
```

Get details for all Tag Values where the description matches **sitea**.

### Example 4

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioTagValue -ApiKeys $TioApiKeys -Value 'Virtual'
```

Get all Tag Values that are equal to **Virtual**.

### Example 5

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioTagValue -ApiKeys $TioApiKeys -CategoryName 'Windows Production'
```

Get all Tag Values for the specified Tag Category.

## PARAMETERS

### Uri

Optional. Defaults to **[https://cloud.tenable.com/](https://cloud.tenable.com)**, specify to override.

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### Method

Optional. HTTP Method to use with the API Call.  Defaults to GET.

Valid values: GET, POST, DELETE, PUT

### Uuid

Optional. Search by Tag Value UUID.

### Value

Optional. Search by Tag Value.

### CategoryName

Optional. Search by CategoryName.

### Filter

Optional. Search using a filter.

A filter condition in the field:operator:value format, for example, f=value:match:rhel. Filters should match field:op:value format. Filter conditions can include:

* value:eq:**tag_value**
* value:match:**value_match**
* category_name:match:**partial_value**
* category_name:eq:**category_name**
* category_name:match:**partial_category_name**
* description:eq:**description**
* description:match:**partial_description**
* updated_at:date-eq:**timestamp_as_int**
* updated_at:date-gt:**timestamp_as_int**
* updated_at:date-lt:**timestamp_as_int**
* updated_by:eq:**user_uuid**

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object Subset of details

Object containing subset of details about the asset, unless queried by UUID.

  uuid                 : 8f68a869-1cbc-4544-a252-b253cb1f2aaf
  created_at           : 05/10/2020 03:22:50
  created_by           : `admin@domain.com`
  updated_at           : 05/10/2020 03:23:43
  updated_by           : `admin@domain.com`
  category_uuid        : 6fbd0c51-4eea-4bed-8490-65c590ece437
  value                : Site A Virtual
  description          :
  type                 : static
  category_name        : Linux Production Servers
  category_description :
  access_control       : @{current_user_permissions=System.Object[]}
  saved_search         : False

## NOTES

In Tenable.io, assets are defined as network entities that potentially represent security risks. Assets can include laptops, desktops,
servers, routers, mobile phones, virtual machines, software containers, and cloud instances. Tenable.io allows you to track assets that
belong to your organization, helping to eliminate potential security risks, identify under-utilized resources, and support compliance efforts.

Use the API to list assets, get individual asset information, import assets, and list and check the status of asset import jobs.

## RELATED LINKS

[Tenable.Tools Project](https://github.com/IPSecMSSP/tenable-tools)
[Tenable Developer API Reference : Assets](https://developer.tenable.com/reference#assets)
