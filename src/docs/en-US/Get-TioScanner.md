---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Get-TioScanner

## SYNOPSIS

Get details about one or more Tenable.io Scanners.

## SYNTAX

```powershell
Get-TioScanner -ApiKeys <psobject> [-Uri <UriBuilder>] [<CommonParameters>]

Get-TioScanner -ApiKeys <psobject> [-Uri <UriBuilder>] [-Id <string>] [<CommonParameters>]
```

## DESCRIPTION

Get details for either a single, or multiple Tenable.io Scanners.

When querying a single scanner by scanner UUID, returns all properties of the scanner. When querying in other ways, a subset of the scanner properties may be returned.

When no ID/Uuid is supplied, returns all scanners.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioScanner -ApiKeys $TioApiKeys
```

Get all scanners.

### Example 2

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioScanner -ApiKeys $TioApiKeys -Id ad082ebc-e375-4250-93b3-ded6dd2757ab
```

Get all available details for the scanner with UUID **ad082ebc-e375-4250-93b3-ded6dd2757ab**.

## PARAMETERS

### Uri

Optional. Defaults to **[https://cloud.tenable.com/](https://cloud.tenable.com)**, specify to override.

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### Id

Optional. Search by asset UUID, returns all details.

Alias: Uuid

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### List of Scanners

Optional. Either a bare list of Scanner UUIDs, or a list of Scanners from a previous call to another function.

## OUTPUTS

### System.Object Subset of details

Object containing subset of details about the scanner, unless queried by UUID.

creation_date            : 1710838511
group                    : True
id                       : 201305
key                      : REDACTED
last_connect             :
last_modification_date   : 1710838511
license                  : @{record_id=0016000001AKju8AAD; customer_id=14217; type=vm; activation_code=REDACTED; agents=-1; ips=200; scanners=-1; users=-1; enterprise_pause=False; expiration_date=1765670399; evaluation=False; apps=; scanners_used=1; agents_used=53}
linked                   : 1
name                     : UAE Cloud Scanners
network_name             : Default
num_scans                : 0
owner                    : system
owner_id                 : 1
owner_name               : system
owner_uuid               : 01de344d-60e1-4b8d-bd90-13f228892dfc
pool                     : True
scan_count               : 0
shared                   : 1
source                   : service
status                   : on
timestamp                : 1710838511
type                     : local
user_permissions         : 64
uuid                     : edec1b13-488d-4b5d-affd-a67fe1c71ca2
supports_remote_logs     : False
supports_webapp          : True
supports_remote_settings : False

## NOTES

In Tenable.io, scanners are used to execute vulnerabilities scans on the customer's environment from either inside the customer's network, or from one of Tenable.io's Cloud Scanners located in multiple regions.

## RELATED LINKS

[Tenable.Tools Project](https://github.com/IPSecMSSP/tenable-tools)
[Tenable Developer API Reference : Assets](https://developer.tenable.com/reference#assets)
