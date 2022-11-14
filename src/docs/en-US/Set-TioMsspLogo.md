---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Get-TioMsspLogo

## SYNOPSIS

Assign a logo to one or more Tenable.io Accounts.

## SYNTAX

```powershell
Set-TioMsspLogo -ApiKeys <psobject> -Uuid <string> -Accounts <string[]> [-Uri <UriBuilder>] [-Method <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Assign an already defined logo to one or more MSSP Accounts/Containers.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = New-TioCredential
PS > Get-TioMsspLogo -ApiKeys $TioApiKeys -Uuid '1fa3edcc-8edd-42f7-b6d1-1f5cd1599d4e' -Accounts 'f59e4a2c-183d-43d1-9985-b85abbc0f709'
```

Assign log with ID **1fa3edcc-8edd-42f7-b6d1-1f5cd1599d4e** to account with id **f59e4a2c-183d-43d1-9985-b85abbc0f709**

## PARAMETERS

### Uri

Optional. Defaults to **[https://cloud.tenable.com/](https://cloud.tenable.com)**, specify to override.

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### Uuid

Logo UUID to assign to nominated accounts.

### Accounts

List of Account Ids to assign logo to.

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

Object containing details of the account.

uuid container_uuid name filename

---

1fa3edcc-8edd-42f7-b6d1-1f5cd1599d4e cc747ae7-9843-4ebb-8793-9424bc9ed000 MSSP Logo 1 logo1.png

## NOTES

The Tenable.io Managed Security Service Provider (MSSP) Portal API provides a secure and accessible way for MSSP administrators to manage the logos of their customer's Tenable.io instances.
By default, the Tenable.io logo appears in the header of your customer's instances. The logo endpoints allow you to replace the Tenable.io logo with a logo appropriate to a customer's business context. Use these endpoints to add, assign, and delete logos.

For background information about logos in the Tenable.io MSSP Portal, see Logos in Tenable.io MSSP Portal User Guide.

## RELATED LINKS

[Tenable.Tools Project](https://github.com/IPSecMSSP/tenable-tools)
[Tenable Developer API Reference : MSSP : Logos](https://developer.tenable.com/reference#io-mssp-logos)
[Tenable.io MSSP Portal User Guide](https://docs.tenable.com/tenableio/mssp/Content/Welcome.htm)
