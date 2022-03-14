---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Get-TioMsspAccount

## SYNOPSIS

Get details about one or more Tenable.io MSSP Accounts.

## SYNTAX

```powershell
Get-TioMsspAccount -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [<CommonParameters>]

Get-TioMsspAccount -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Uuid <string>] [<CommonParameters>]

Get-TioMsspAccount -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Container <string>] [<CommonParameters>]

Get-TioMsspAccount -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Name <string>] [-Exact] [<CommonParameters>]
```

## DESCRIPTION

Get details for either a single, or multiple Tenable.io MSSP Accounts.

When no criteria (Uuid, Name or Container) are supplied, returns a list of all MSSP Accounts in the portal.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = New-TioCredential
PS > Get-TioMsspAccount -ApiKeys $TioApiKeys
```

List all MSSP Accounts

### Example 2

```powershell
PS > $TioApiKeys = New-TioCredential
PS > Get-TioMsspAccount -ApiKeys $TioApiKeys -Uuid 'f59e4a2c-183d-43d1-9985-b85abbc0f709'
```

Get the available details for an account with UUID **f59e4a2c-183d-43d1-9985-b85abbc0f709**.

### Example 3

```powershell
PS > $TioApiKeys = New-TioCredential
PS > Get-TioMsspAccount -ApiKeys $TioApiKeys -Name 'Customer'
```

List all Accounts with the text **Customer** in their name.

### Example 4

```powershell
PS > $TioApiKeys = New-TioCredential
PS > Get-TioMsspAccount -ApiKeys $TioApiKeys -Name 'Customer Name 1' -Exact
```

List only the Account with the custom name **Customer Name 1**.

### Example 5

```powershell
PS > $TioApiKeys = New-TioCredential
PS > Get-TioMsspAccount -ApiKeys $TioApiKeys -Container 'dommain.com-1112'
```

Get the available details for an account with Container Name **domain.com-1112**.

## PARAMETERS

### Uri

Optional. Defaults to **[https://cloud.tenable.com/](https://cloud.tenable.com)**, specify to override.

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### Uuid

Optional. Search by Account UUID.

### Name

Optional. Search by Custom Name.

### Container

Optional. Search by Container Name.

### Exact

Optional. Switch to make Custom Name exact.  Useful if one account name matches a part of another account name.

Eg. **Customer** and **Customer - Eval**

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

Object containing details of the account.

  uuid                  : f5e877c6-b078-442e-90ff-b7cd4edff3e9
  container_name        : domain.com-1111
  custom_name           : Customer Name 1
  sso_username          : contact@customerone.com
  region                : Asia Pacific (Sydney)
  site_id               : ap-syd-1
  licensed_assets       : 0
  licensed_assets_limit : 100
  licensed_apps         : {lumin, consec, was, vm…}
  notes                 : Account for Customer Name 1

## NOTES

The Tenable.io Managed Security Service Provider (MSSP) Portal API provides a secure and accessible way for MSSP administrators to manage and maintain multiple customer instances of Tenable products. Account endpoints in the Tenable.io MSSP Portal API allow you to view and manage your MSSP customer accounts.

For background information about the Tenable.io MSSP Portal, see the Tenable.io MSSP Portal User Guide.

## RELATED LINKS

[Tenable Developer API Reference : MSSP : Accounts](https://developer.tenable.com/reference#io-mssp-accounts)
[Tenable.io MSSP Portal User Guide](https://docs.tenable.com/tenableio/mssp/Content/Welcome.htm)