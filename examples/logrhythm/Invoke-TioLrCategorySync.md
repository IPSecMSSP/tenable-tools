---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Invoke-TioLrCategorySync

## SYNOPSIS

Synchronise Tenable.io Tag Categories with LogRhythm Lists.

## SYNTAX

```powershell
Invoke-TioLrCategorySync.ps1 [-ApiKeys] <psobject> [[-ListPrefix] <string>] [[-EntityName] <string>] [-ListOwner] <Object> [[-ListReadAccess] <string>] [[-ListWriteAccess] <string>] [-HostnameOnly] [-IPv4Only] [<CommonParameters>]
```

## DESCRIPTION

This script allows for the assets with specific Tag Categories to be synchronised to a LogRhythm list, using either the Tenable Asset's `hostname` or `ipv4`, or both, properties.

This script assumes you have LogRhythm.Tools installed and configured in accordance with it's documentation.  It also defaults to using the ***cloud.tenable.com*** hostname to access the Tenable.io APIs.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Invoke-TioLrCategorySync -ApiKeys $TioApiKeys -ListPrefix 'Example TIO' -Entity Name 'Example' -ListOwner 1 -ListReadAccess 'publicrestrictedanalyst' -ListWriteAccess 'publicglobaladministrator' -HostnameOnly
```

Perform Tenable IO Tag Category Synchronisation, setting the List Prefix to ***Entity TIO***, lists to be created in entity ***Example***, with list owner ID 1.  Read permissions set to ***PublicRestrictedAnalyst**, write permission for ***PublicGlobalAdministrators***.

## PARAMETERS

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### ListPrefix

Prefix to use with lists created by the script.  Defaults to ***TIO***.

### EntityName

Entity to assign list to.  This has an effect on who can Read/Write the list, depending on permissions assigned.  Specifically, for ***restricted*** Access values, users in the same entity with the same or higher permission can interact with the list in the way specified.

Defalts to ***Primary Site***

***Ie:*** `-ListReadAccess restrictedanalyst` means that both RestictedAnalyst and RestrictedAdmin in the same Entity can see the list.

### ListOwner

Id or Name of owner to assign to list.

***Note:*** Due to a limitation in the `lr-admin-api`, if the PersonID and UserID values are out-of-sync in the LogRhythmEMDB database, specifying the name does not work as the list requires the `PersonID` and the `lr-admin-api` only returns the `UserID`.  To work around this, specify the numeric value of the intended user's `PersonID`.

### ListReadAccess

Read permissions to apply to list.  One of:

* private
* publicall
* publicglobaladmin
* publicgolbalanalyst
* publicrestrictedadmin
* publicrestrictedanalyst

Defaults to **publicglobalanalyst**.

### ListWriteAccess

Write permissions to apply to list.  One of:

* private
* publicall
* publicglobaladmin
* publicgolbalanalyst
* publicrestrictedadmin
* publicrestrictedanalyst

Defaults to **publicglobaladmin**

### HostnameOnly

Add only the Tenable.io hostname asset property to the lists(s).

### IPv4Only

Add only the Tenable.io ipv4 asset property to the list(s).

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

Contents in LogRhythm Lists.

## NOTES

This synchronisation script makes use of LogRhythm Lists to store the configuration related to which Tag Categories to synchronise.  On first run it will create the two Configuration Lists:

* TIO : Conf : Tag Category Available
* TIO : Conf : Tag Category Enabled

Values from the **Tag Category Available** list can be copied/pasted to the **Tag Category Enabled** list for the next run of the script.

For each Tag Category that is in the **Tag Category Enabled** list the script will get a list of available **Tag Values**.  Each Category/Value combination will result in the creation of a List in LogRhythm, conforming to the naming convention:

* TIO : Tag : `Category Name` : `Tag Value`

Eg.

* TIO : Tag : Windows Production Server : Physical
* TIO : Tag : Windows Production Server : Site A Virtual
* TIO : Tag : Windows Production Server : Site B Virtual

Each of these will be populated with entries obtained using the Tenable.IO Export Asset API, using a Tag Category filter.  Depending on whether either **HostnameOnly** or **IPv4Only** switch parameters are specified, either the hostname, ipv4 or both are added to the list.  To support this, the list is of type **Host**, allowing both data types to be present.

## RELATED LINKS

[Tenable Developer API Reference](https://developer.tenable.com/reference)
[LogRhythm Tools PowerShell Module](https://github.com/LogRhythm-Tools/LogRhythm.Tools)
