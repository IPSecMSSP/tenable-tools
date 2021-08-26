---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Add-YourFirstFunction

## SYNOPSIS

Make a request to the Tenable.io API

## SYNTAX

```powershell
Invoke-TioApiRequest [-Uri] <string> [-AccessKey] <pscredential> [-SecretKey] <pscredential> [[-Method] <string>] [[-Body] <psobject>] [[-Depth] <int>] [<CommonParameters>]
```

## DESCRIPTION

This is the base function for interacting with the Tenable.io API

## EXAMPLES

### Example 1

```powershell
PS C:> Invoke-TioApiRequest -Uri 'https://cloud.tenable.com/assets' -AccessKey (Get-PSCredential -UserName 'Access Key') -SecretKey (Get-PSCredential -UserName 'Secret Key')
```

List All Assets

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
