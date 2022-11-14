---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Get-TioExportAsset

## SYNOPSIS

Get results of Asset Export request for the specified Chunk.

## SYNTAX

```powershell
Get-TioExportAsset -ApiKeys <psobject> -TagCategory <string> -TagValue <string> [-Uri <UriBuilder>] [-Method <string>] [-ChunkSize <long>] [<CommonParameters>]

Get-TioExportAsset -ApiKeys <psobject> -Filter <string> [-Uri <UriBuilder>] [-Method <string>] [-ChunkSize <long>] [<CommonParameters>]

Get-TioExportAsset -ApiKeys <psobject> -Uuid <string> [-Uri <UriBuilder>] [-Method <string>] [-ChunkSize <long>] [<CommonParameters>]
```

## DESCRIPTION

Initiate a new export request and retrieve results, or get results of a previous Asset Export Request.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioExportAsset -ApiKeys $TioApiKeys -Uuid 'ad082ebc-e375-4250-93b3-ded6dd2757ab'
```

Retrieve results of a previous asset export request with UUID of **ad082ebc-e375-4250-93b3-ded6dd2757ab**.

Use `Get-TioExportAssetStatus -ApiKeys $TioApiKeys` to get a list of available, recent, asset export requests.

### Example 2

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioExportAsset -ApiKeys $TioApiKeys -TagCategory 'Windows Server' -TagValue 'Physical'
```

Initiate a new Asset Export using a Tag Filter for Category **Windows Server** and Value **Physical**.

### Example 3

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > $Filter = @{}
PS > $Filter.Add('is_licensed',$true)
PS > Get-TioExportAsset -ApiKeys $TioApiKeys -Filter $Filter
```

Initiate a new Asset Export using a Specified Filter.  This filter returns only assets that are included in the asset count for the Tenable.io instance.

## PARAMETERS

### Uri

Optional. Defaults to **[https://cloud.tenable.com/](https://cloud.tenable.com)**, specify to override.

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### Method

Optional. HTTP Method to use with the API Call.  Defaults to GET.

Valid values: GET, POST, DELETE, PUT

### Uuid

Asset Export Request UUID.

### Filter

PSObject containing Filter parameters with which to initiate the search.  Refer to the Tenabe Developer reference linked below for details.

### TagCategory

Tag Category to use in a search filter.  Must also supply TagValue.

### TagValue

Tag Value to use in a search filter.  Must also supply TagCategory.

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### Collection of System.Object

Collection of Objects containing Assets matching search criteria.

## NOTES

Exports all assets that match the request criteria.

For using the **Filter** option, please refer to the referenced Tenable Developer API Reference beloe.

## RELATED LINKS

[Tenable.Tools Project](https://github.com/IPSecMSSP/tenable-tools)
[Tenable Developer API Reference : Export Asset Request](https://developer.tenable.com/reference#exports-assets-request-export)
