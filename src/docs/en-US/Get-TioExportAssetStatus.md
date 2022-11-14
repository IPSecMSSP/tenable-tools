---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Get-TioExportAssetStatus

## SYNOPSIS

Get details about one or more Tenable.io Asset Export Requests.

## SYNTAX

```powershell
Get-TioExportAssetStatus -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [<CommonParameters>]

Get-TioExportAssetStatus -ApiKeys <psobject> -Uuid <string> [-Uri <UriBuilder>] [-Method <string>] [<CommonParameters>]
```

## DESCRIPTION

Get details for either a single, or multiple Tenable.io asset export requests.

When no criteria are supplied, status of all recent export requests is returned.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioExportAssetStatus -ApiKeys $TioApiKeys
```

List all Asset Export Requests

### Example 2

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioExportAssetStatus -ApiKeys $TioApiKeys -Uuid ad082ebc-e375-4250-93b3-ded6dd2757ab
```

Get details for Asset Export Request with UUID **ad082ebc-e375-4250-93b3-ded6dd2757ab**.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object Request Details

Object containing subset of details about the asset, unless queried by UUID.

  uuid                 : 4f375b82-fa19-415d-9dfc-abc9fdadf025
  status               : FINISHED
  total_chunks         : 1
  filters              : {"tag.Windows Production Server":"Physical"}
  finished_chunks      : 1
  num_assets_per_chunk : 1000
  created              : 1631847707768

  uuid                 : 9a3c2986-1000-485e-8c52-e525797fe4c8
  status               : FINISHED
  total_chunks         : 1
  filters              : {"tag.Category 1":"Value 1"}
  finished_chunks      : 1
  num_assets_per_chunk : 1000
  created              : 1631847426722

### Collection of System.Object with all Requests

## NOTES

Returns the status of an assets export request. Tenable.io processes the chunks in parallel so the chunks may not complete in order, and the chunk IDs may not be arranged sequentially in the completed output.

If no UUID is supplied, retrieves a list of asset export jobs. This list includes the 1,000 most recent export jobs regardless of status.

## RELATED LINKS

[Tenable.Tools Project](https://github.com/IPSecMSSP/tenable-tools)
[Tenable Developer API Reference : Asset Export Status](https://developer.tenable.com/reference#exports-assets-export-status)
