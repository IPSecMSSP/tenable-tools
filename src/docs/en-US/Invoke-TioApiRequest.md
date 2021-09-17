---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Invoke-TioApiRequest

## SYNOPSIS

Make a request to the Tenable.io API

## SYNTAX

```powershell
Invoke-TioApiRequest [-Uri] <UriBuilder> [-ApiKeys] <psobject> [[-Method] <string>] [[-Body] <psobject>] [[-Depth] <int>] [<CommonParameters>]
```

## DESCRIPTION

This is the base function for interacting with the Tenable.io API

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Invoke-TioApiRequest -Uri 'https://cloud.tenable.com/assets' -ApiKeys $TioApiKeys
```

List up to 5000 Assets

## PARAMETERS

### Uri

Text string or UriBuilder Object containing the URI to the specific API Endpoint being called, including any URI Parameters.

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### Method

HTTP Method to use with the API Call.  Defaults to GET.

Valid values: GET, POST, DELETE, PUT

### Body

Body to send with the request.  Should not be provided with a GET request.

### Depth

Used with recursion, primarily for pagination handling.

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

This is the core API interface function of the module. All other API Call functions call this function to make the actual request to the Tenable API.  This allows simplified, direct, calls to be made to the Tenable API where a specific capability is not yet implemented.

## RELATED LINKS

[Tenable Developer API Reference](https://developer.tenable.com/reference)
