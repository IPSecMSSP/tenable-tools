---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# New-TioCredential

## SYNOPSIS

Get details about one or more Tenable.io Assets.

## SYNTAX

```powershell
New-TioCredential [[-AccessKey] <string>] [[-SecretKey] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Build a new PSCustomObject that contains two PSCredential Objects with the Access Key and Secret Key for authentication to the Tenable.IO API.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = New-TioCredential
```

Create a new Tenable.IO Credential Object for authentication to the API.  Access Key and Secret Key will be prompted for.

### Example 2

```powershell
PS > $TioApiKeys = New-TioCredential -AccessKey 'ACCESS_KEY' -SecretKey 'SECRET_KEY'
```

Create a new Tenabe.IO Credential Object for authentication to the API.  Access Key and Secret Key supplied as part of the function call.

## PARAMETERS

### Uri

Optional. Defaults to **[https://cloud.tenable.com/](https://cloud.tenable.com)**, specify to override.

### AccessKey

Optional. A string containing the Access Key.

### SecretKey

Optional. A string containing the Secret Key.

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### API Keys

API Key parameters consisting of an Access Key and a Secret Key

## OUTPUTS

### System.Object with PSCredential Objects

Object containing a PSCredential Object for each of the Access Key and Secret Key.

## NOTES

API Keys are used to authenticate with the Tenable.io REST API (version 6.4 or greater) and passed with requests using the "X-ApiKeys" HTTP header. For more details, see the [API documentation](https://cloud.tenable.com/api#/authorization.)

Note: API Keys are only presented upon initial generation. Please store them in a safe location as they can not be retrieved later and will need to be regenerated if lost.  This will invalidate previously issued API Keys for that user.

## RELATED LINKS

[Tenable Developer API Reference : Assets](https://developer.tenable.com/reference#assets)
