---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Get-TioExportAssetChunk

## SYNOPSIS

Get results of Asset Export request for the specified Chunk.

## SYNTAX

```powershell
Get-TioExportAssetChunk -ApiKeys <psobject> -Uuid <string> -Chunk <string> [-Uri <UriBuilder>] [-Method <string>] [<CommonParameters>]
```

## DESCRIPTION

Get results of Asset Export Request for the specfied Chunk. Results may be contained in multiple chunks, each chunk must be separately retrieved.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioExportAssetChunk -ApiKeys $TioApiKeys -Uuid 'ad082ebc-e375-4250-93b3-ded6dd2757ab' -Chunk 1
```

Retrieve results of the specified asset export chunk.

## PARAMETERS

### Uri

Optional. Defaults to **[https://cloud.tenable.com/]**, specify to override.

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### Method

Optional. HTTP Method to use with the API Call.  Defaults to GET.

Valid values: GET, POST, DELETE, PUT

### Uuid

Asset Export Request UUID.

### Chunk

ID of chunk of results to download.

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### Collection of System.Object

Collection of Objects containing Assets matching search criteria.

## NOTES

Downloads exported assets chunk by ID. Chunks are available for download for up to 24 hours after they have been created. Tenable.io returns a 404 message for expired chunks.

## RELATED LINKS

[Tenable Developer API Reference : Download Assets Chunk](https://developer.tenable.com/reference#exports-assets-download-chunk)
