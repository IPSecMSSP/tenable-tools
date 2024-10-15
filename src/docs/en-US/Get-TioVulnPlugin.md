---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Get-TioAsset

## SYNOPSIS

Get details about one or more Tenable.io Assets.

## SYNTAX

```powershell
Get-TioVulnPlugin -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Size <int>] [-Page <int>] [-LastUpdated <string>] [<CommonParameters>]

Get-TioVulnPlugin -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Id <string>] [<CommonParameters>]
```

## DESCRIPTION

Get details for either a single, or multiple Tenable.io Vulnerability Scanning Plugins.

When querying a single plugin by Id, returns all properties of the Vulnerability Plugin.

When no page number is supplied, all Plugins are returned.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioVulnPlugin -ApiKeys $TioApiKeys
```

Get all Vulnerability Scanner plugin details

### Example 2

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioVulnPlugin -ApiKeys $TioApiKeys -Id 32
```

Get all available details for the plugin with Id **32**.

### Example 3

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioVulnPlugin -ApiKeys $TioApiKeys -LastUpdated '2023-12-01'
```

Get details of all Vuln Plugins updated since December 1, 2023

## PARAMETERS

### Uri

Optional. Defaults to **[https://cloud.tenable.com/](https://cloud.tenable.com)**, specify to override.

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### Method

Optional. HTTP Method to use with the API Call. Defaults to GET.

Valid values: GET, POST, DELETE, PUT

### Id

Optional. Search by Vuln Id, returns all details.

### LastUpdated

Optional. Search for all Plugins updated since provided date in 'YYYY-MM-DD' format.

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### List of Assets

Optional. Either a bare list of Asset UUIDs, or a list of assets from a previous call to either Get-TioAsset or Get-TioExportAsset.

## OUTPUTS

### System.Object Subset of details

Object containing subset of details about the plugin, unless queried by UUID.

id : 10278
name : Sendmail 8.6.9 IDENT Remote Overflow
family_name : SMTP problems
attributes : {@{attribute_name=fname; attribute_value=sendmail_ident.nasl}, @{attribute_name=plugin_name; attribute_value=Sendmail 8.6.9 IDENT Remote Overflow},
              @{attribute_name=script_version; attribute_value=1.18}, @{attribute_name=script_copyright; attribute_value=This script is Copyright (C) 2002-2018
              and is owned by Tenable, Inc. or an Affiliate thereof.}…}

## NOTES

In Tenable.io, vulnerabilities are detected through the use of plugins. A plugin defines the detection details for a specific vulnerability, and is part of a Plugin Family.

## RELATED LINKS

[Tenable.Tools Project](https://github.com/IPSecMSSP/tenable-tools)
[Tenable Developer API Reference : Assets](https://developer.tenable.com/reference/io-plugins-list)
