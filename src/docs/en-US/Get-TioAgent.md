---
external help file: Tenable.Tools-help.xml
Module Name: Tenable.Tools
schema: 2.0.0
---

# Get-TioAgent

## SYNOPSIS

Get details about one or more Tenable.io Agents.

## SYNTAX

```powershell
Get-TioAgent -ApiKeys <psobject> [-Uri <UriBuilder>] [-Size <int>] [-Page <int>] [<CommonParameters>]

Get-TioAgent -ApiKeys <psobject> [-Uri <UriBuilder>] [-Id <string>] [<CommonParameters>]
```

## DESCRIPTION

Get details for either a single, or multiple Tenable.io Agents.

When querying a single agent by Agent UUID, returns all properties of the agent. When querying in other ways, a subset of the agent properties may be returned.

When no ID/Uuid is supplied, returns all agents using a default page size of 1000.

You can retrieve a specific page of assets, with a specified page size.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioAgent -ApiKeys $TioApiKeys
```

Get all agents.

### Example 2

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioAgent -ApiKeys $TioApiKeys -Id ad082ebc-e375-4250-93b3-ded6dd2757ab
```

Get all available details for the agent with UUID **ad082ebc-e375-4250-93b3-ded6dd2757ab**.

### Example 3

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioAgent -ApiKeys $TioApiKeys -Page 0
```

Get the first page of 1000 agents.

### Example 4

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioAgent -ApiKeys $TioApiKeys -Size 20 -Page 5
```

Get the sixth page of 20 agents.

## PARAMETERS

### Uri

Optional. Defaults to **[https://cloud.tenable.com/](https://cloud.tenable.com)**, specify to override.

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### Id

Optional. Search by asset UUID, returns all details.

Alias: Uuid

### Page

Optional. Page number of results to retrieve. Page numbers start at 0.

### Size

Optional. Size of Results pages. Defaults to 1000.

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### List of Agents

Optional. Either a bare list of Agent UUIDs, or a list of Agents from a previous call to another function.

## OUTPUTS

### System.Object Subset of details

Object containing subset of details about the agent, unless queried by UUID.

id                       : 41474261
uuid                     : b34ee2ba-4a61-49bc-92c9-26ed23025df7
name                     : hostname
platform                 : DARWIN
distro                   : macosx
ip                       : 10.1.1.11
last_scanned             : 1728950314
plugin_feed_id           : 202410141937
core_build               : 13
core_version             : 10.7.3
linked_on                : 1692088612
last_connect             : 1728953637
status                   : on
groups                   : {@{name=MacOS Tenable Agents; id=164396}}
supports_remote_logs     : True
network_uuid             : 00000000-0000-0000-0000-000000000000
network_name             : Default
profile_uuid             : 00000000-0000-0000-0000-000000000000
profile_name             : Default
supports_remote_settings : True
asset_uuid               : b50c097e-d80c-4fde-bb52-ab4bd9a82e9a
health                   : 20
health_state_name        : CRITICAL
runtime_scanning_health  : -1
nessus_scanning_health   : 20

### System.Object Full details

id                       : 41474261
uuid                     : b34ee2ba-4a61-49bc-92c9-26ed23025df7
name                     : hostname
platform                 : DARWIN
distro                   : macosx
ip                       : 10.1.1.11
last_scanned             : 1728950314
plugin_feed_id           : 202410141937
core_build               : 13
core_version             : 10.7.3
linked_on                : 1692088612
last_connect             : 1728968208
status                   : on
groups                   : {@{name=MacOS Tenable Agents; id=164396}}
supports_remote_logs     : True
network_uuid             : 00000000-0000-0000-0000-000000000000
network_name             : Default
profile_uuid             : 00000000-0000-0000-0000-000000000000
profile_name             : Default
remote_settings          : {@{name=Nessus Agent Log Level; setting=backend_log_level; type=select; description=This controls the Nessus Agent backend logging level.  Backend reload required.; backend_reload=True; status=current; value=normal; allowable_values=System.Object[];
                           default=normal}, @{name=Plugin Compilation Performance; setting=plugin_load_performance_mode; type=select; description=Controls the performance for plugin compilation; lower performance takes longer to compile, but uses fewer system processor resources.  Service
                           restart required.  Requires 8.1.0+; service_restart=True; status=current; value=high; allowable_values=System.Object[]; default=high}, @{name=Scan Performance; setting=scan_performance_mode; type=select; description=Controls the scan performance; lower performance
                           takes longer to scan, but uses fewer system processor resources.  Service restart required.  Requires 8.1.0+; service_restart=True; status=current; value=high; allowable_values=System.Object[]; default=high}, @{name=Nessus Agent Update Plan;
                           setting=agent_update_channel; type=select; description=The update plan to which Nessus Agent will track.  Requires 7.7.0+; status=current; value=ga; allowable_values=System.Object[]; default=ga}…}
supports_remote_settings : True
restart_pending          : False
asset_uuid               : b50c097e-d80c-4fde-bb52-ab4bd9a82e9a
health                   : 0
health_state_name        : HEALTHY
health_events            : {@{identifier=100; state=0; state_time=1728954985171; details=The Nessus Agent has enough available disk space to function normally.; muted=False; state_name=HEALTHY; identifier_name=System Disk Usage}, @{identifier=201; state=0; previous_state=20;
                           state_time=1728954734171; previous_state_time=1728953638000; details=Plugin update was successful.; previous_details=The Nessus Agent could not update plugins because the download failed due to an error. Failed plugin updates are retried daily. Status code: 400;
                           muted=False; state_name=HEALTHY; identifier_name=Plugin Updates; previous_state_name=CRITICAL}, @{identifier=202; state=0; state_time=1728954991171; details=Plugin integrity check was successful.; muted=False; state_name=HEALTHY; identifier_name=Plugins Integrity},
                           @{identifier=203; state=0; state_time=1728954985171; details=Plugin compilation was successful.; muted=False; state_name=HEALTHY; identifier_name=Plugin Compilation}}
runtime_scanning_health  : -1
nessus_scanning_health   : 0

## NOTES

In Tenable.io, agents are defined as installations of endpoint software running on assets within the customer's environment for the purpose of collecting vulnerability information related to the host the agent is installed on.

## RELATED LINKS

[Tenable.Tools Project](https://github.com/IPSecMSSP/tenable-tools)
[Tenable Developer API Reference : Assets](https://developer.tenable.com/reference#assets)
