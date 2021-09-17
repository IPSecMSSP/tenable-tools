# Tenable.Tools

## about_Tenable.Tools

### SHORT DESCRIPTION

A PowerShell Module to interface to the Tenable.io API

### LONG DESCRIPTION

This PowerShell Module interfaces to the Tenable.io API to allow interaction with the various objects stored therein.

#### Optional Subtopic

{{ Optional Subtopic Placeholder }}

##### Optional Subtopic Section

{{ Optional Subtopic Section Placeholder }}

### EXAMPLES

{{ Code or descriptive examples of how to leverage the functions described. }}

### NOTE

The core function in this module is **Invoke-TioApiRequest**.  This function handles the basic requirements for talking to the Tenable.io API, including the Authentication Headers.

Use of this PowerShell module requires the Tentable.io API Keys, which are comprised of an Access Key and a Secret Key.  These should be stored in a single PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey**.

### SEE ALSO

[Tenable API Explorer](https://developer.tenable.com/reference)
