---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Get-TioMsspLogo

## SYNOPSIS

Get details about one or more Tenable.io MSSP Logos.

## SYNTAX

```powershell
Get-TioMsspLogo -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [<CommonParameters>]

Get-TioMsspLogo -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Uuid <string>] [<CommonParameters>]

Get-TioMsspLogo -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-ContainerId <string>] [<CommonParameters>]

Get-TioMsspLogo -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Name <string>] [-Exact] [<CommonParameters>]
```

## DESCRIPTION

Get details for either a single, or multiple Tenable.io MSSP Logos.

When no criteria (Uuid, Name or ContainerId) are supplied, returns a list of all MSSP Logos and their assignments in the portal.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = New-TioCredential
PS > Get-TioMsspLogo -ApiKeys $TioApiKeys
```

List all MSSP Accounts

### Example 2

```powershell
PS > $TioApiKeys = New-TioCredential
PS > Get-TioMsspLogo -ApiKeys $TioApiKeys -Uuid 'f59e4a2c-183d-43d1-9985-b85abbc0f709'
```

Get the available details for an logo with UUID **f59e4a2c-183d-43d1-9985-b85abbc0f709**.

### Example 3

```powershell
PS > $TioApiKeys = New-TioCredential
PS > Get-TioMsspLogo -ApiKeys $TioApiKeys -Name 'Customer'
```

List all logos with the text **Customer** in their name.

### Example 4

```powershell
PS > $TioApiKeys = New-TioCredential
PS > Get-TioMsspLogo -ApiKeys $TioApiKeys -Name 'Customer Name 1' -Exact
```

List only the logo with the custom name **Customer Name 1**.

### Example 5

```powershell
PS > $TioApiKeys = New-TioCredential
PS > Get-TioMsspLogo -ApiKeys $TioApiKeys -ContainerId '0f772c9f-acee-4cd0-b476-7bfd17c9a0b9'
```

Get the available details for a logo assigned to account with Container Id of **0f772c9f-acee-4cd0-b476-7bfd17c9a0b9**.

## PARAMETERS

### Uri

Optional. Defaults to **[https://cloud.tenable.com/](https://cloud.tenable.com)**, specify to override.

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### Uuid

Optional. Search by Logo UUID.

### Name

Optional. Search by Logo Name.

### ContainerId

Optional. Search by Container Id.

### Exact

Optional. Switch to make Logo Name exact. Useful if one account name matches a part of another account name.

Eg. **Customer** and **Customer - Eval**

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

[Tenable Developer API Reference : MSSP : Logos](https://developer.tenable.com/reference#io-mssp-logos)
[Tenable.io MSSP Portal User Guide](https://docs.tenable.com/tenableio/mssp/Content/Welcome.htm)
