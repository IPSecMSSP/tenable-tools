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
Get-TioAsset -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [<CommonParameters>]

Get-TioAsset -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Uuid <string>] [<CommonParameters>]

Get-TioAsset -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-Hostname <string>] [<CommonParameters>]

Get-TioAsset -ApiKeys <psobject> [-Uri <UriBuilder>] [-Method <string>] [-IPv4 <string>] [<CommonParameters>]
```

## DESCRIPTION

Get details for either a single, or multiple Tenable.io Assets.

When querying a single asset by Asset UUID, returns all properties of the asset.  When querying in other ways, a subset of the asset properties is returned.

When no criteria (Uuid, Hostname or IPv4) are supplied, returns the first 5000 assets.

***Note:*** If your environment has more than 5000 assets, use the Get-TioExportAsset function to filter or access all assets.  When working with the asset list capability, this function will only return the *first* 5000 assets.  There is currently no documented pagination control or filtering for this API Endpoint.

## EXAMPLES

### Example 1

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioAsset -ApiKeys $TioApiKeys
```

List up to 5000 Assets

### Example 2

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioAsset -ApiKeys $TioApiKeys -Uuid ad082ebc-e375-4250-93b3-ded6dd2757ab
```

Get all available details for the asset with UUID **ad082ebc-e375-4250-93b3-ded6dd2757ab**.

### Example 3

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioAsset -ApiKeys $TioApiKeys -HostName 'host.domain.com'
```

Get subset of details (from the first 5000 assets returned) for a host named **host.domain.com**.

### Example 4

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioAsset -ApiKeys $TioApiKeys -IPv4 '192.168.10.10'
```

Get subset of details (from the first 5000 assets returned) for a host with IPv4 Address **192.168.10.10**.

### Example 5

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > Get-TioAsset -ApiKeys $TioApiKeys -HostName 'host.domain.com' | Get-TioAsset -ApiKeys $TioApiKeys
```

Get all details (from the first 5000 assets returned) for a host named **host.domain.com** by pipelining the initial result into the function.  The **id** or **uuid** property will be used as the pipeline parameter.

### Example 6

```powershell
PS > $TioApiKeys = @{}
PS > $TioApiKeys.Add('AccessKey',(Get-Credential -UserName 'Access Key'))
PS > $TioApiKeys.Add('SecretKey',(Get-Credential -UserName 'Secret Key'))
PS > 'ad082ebc-e375-4250-93b3-ded6dd2757ab' | Get-TioAsset -ApiKeys $TioApiKeys
```

Get all details (from the first 5000 assets returned) for a host with UUID **ad082ebc-e375-4250-93b3-ded6dd2757ab** by pipelining the initial result into the function.  The pipeline value will be used as the **Uuid** parameter.

## PARAMETERS

### Uri

Optional. Defaults to **[https://cloud.tenable.com/]**, specify to override.

### ApiKeys

PSObject containing two PSCredential Objects named **AccessKey** and **SecretKey** with the respective Access Key and Secret Key stored in the password property of these.

### Method

Optional. HTTP Method to use with the API Call.  Defaults to GET.

Valid values: GET, POST, DELETE, PUT

### Uuid

Optional. Search by asset UUID, returns all details.

Alias: Id

### Hostname

Optional. Search by asset HostName.  Returns subset of details.

### IPv4

Optional. Search by asset IPv4 Address.  Returns subset of details.

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### List of Assets

Optional.  Either a bare list of Asset UUIDs, or a list of assets from a previous call to either Get-TioAsset or Get-TioExportAsset.

## OUTPUTS

### System.Object Subset of details

Object containing subset of details about the asset, unless queried by UUID.

  id                        : ad082ebc-e375-4250-93b3-ded6dd2757ab
  has_agent                 : False
  last_seen                 : 14/09/2021 23:36:13
  last_scan_target          : 192.168.10.10
  sources                   : {@{name=NESSUS_SCAN; first_seen=02/09/2020 21:24:44; last_seen=14/09/2021 23:36:13}}
  ipv4                      : {192.168.10.10}
  ipv6                      : {}
  fqdn                      : {hostname.domain.com}
  netbios_name              : {HOSTNAME}
  operating_system          : {Microsoft Windows Server 2016 Standard}
  hostname                  : {hostname}
  agent_name                : {}
  aws_ec2_name              : {}
  security_protection_level :
  security_protections      : {}
  exposure_confidence_value :
  mac_address               : {}

### System.Object Full details

  id                           : ad082ebc-e375-4250-93b3-ded6dd2757ab
  has_agent                    : False
  created_at                   : 02/09/2020 21:28:07
  updated_at                   : 14/09/2021 23:37:39
  first_seen                   : 02/09/2020 21:24:44
  last_seen                    : 14/09/2021 23:36:13
  last_scan_target             : 10.103.58.134
  last_authenticated_scan_date : 14/09/2021 23:36:13
  last_licensed_scan_date      : 14/09/2021 23:36:13
  last_scan_id                 : ad082ebc-e375-4250-93b3-ded6dd2757ac
  last_schedule_id             : template-3356eeaf-4db9-ff3f-aba5-2a8389b6a70c9788501811d6e056
  sources                      : {@{name=NESSUS_SCAN; first_seen=02/09/2020 21:24:44; last_seen=14/09/2021 23:36:13}}
  tags                         : {@{tag_uuid=d64191d3-3748-42f0-b742-8fbbc6646b2b; tag_key=Windows OS - Servers; tag_value=Windows Server 2016; added_by=58d31fc5-4158-418d-b199-9809cd0833eb;
                                added_at=29/03/2021 05:36:54}, @{tag_uuid=833f5e8f-5ef2-427a-9f75-20c6d3b93bdf; tag_key=Windows Server only- Reporting; tag_value=Windows - Reporting;
                                added_by=58d31fc5-4158-418d-b199-9809cd0833eb; added_at=22/03/2021 08:10:31}, @{tag_uuid=2311a3d5-0d63-4b3b-8dfe-92096e21b4fc; tag_key=Windows Production Server;
                                tag_value=Site A Virtual; added_by=494d456e-0752-4b5d-b256-8ee08a1d14ba; added_at=23/09/2020 20:50:59}}
  interfaces                   : {@{name=3; aliased=False; fqdn=System.Object[]; mac_address=System.Object[]; ipv4=System.Object[]; ipv6=System.Object[]}, @{name=UNKNOWN; fqdn=System.Object[];
                                mac_address=System.Object[]; ipv4=System.Object[]; ipv6=System.Object[]}}
  network_id                   : {00000000-0000-0000-0000-000000000000}
  ipv4                         : {192.168.10.10}
  ipv6                         : {}
  fqdn                         : {hostname.domain.com}
  mac_address                  : {00:12:34:56:78:9a}
  netbios_name                 : {HOSTNAME}
  operating_system             : {Microsoft Windows Server 2016 Standard}
  system_type                  : {general-purpose}
  tenable_uuid                 : {53ede5d70fe3464081846851a2cb372e}
  hostname                     : {hostname}
  agent_name                   : {}
  bios_uuid                    : {ad082ebc-e375-4250-93b3-ded6dd2757ad}
  aws_ec2_instance_id          : {}
  aws_ec2_instance_ami_id      : {}
  aws_owner_id                 : {}
  aws_availability_zone        : {}
  aws_region                   : {}
  aws_vpc_id                   : {}
  aws_ec2_instance_group_name  : {}
  aws_ec2_instance_state_name  : {}
  aws_ec2_instance_type        : {}
  aws_subnet_id                : {}
  aws_ec2_product_code         : {}
  aws_ec2_name                 : {}
  azure_vm_id                  : {}
  azure_resource_id            : {}
  gcp_project_id               : {}
  gcp_zone                     : {}
  gcp_instance_id              : {}
  ssh_fingerprint              : {}
  mcafee_epo_guid              : {}
  mcafee_epo_agent_guid        : {}
  qualys_asset_id              : {}
  qualys_host_id               : {}
  servicenow_sysid             : {}
  installed_software           : {cpe:/a:microsoft:.net_framework:2.0.50727, cpe:/a:microsoft:.net_framework:3.0…}
  bigfix_asset_id              : {}
  security_protection_level    :
  security_protections         : {}
  exposure_confidence_value    :

## NOTES

In Tenable.io, assets are defined as network entities that potentially represent security risks. Assets can include laptops, desktops,
servers, routers, mobile phones, virtual machines, software containers, and cloud instances. Tenable.io allows you to track assets that
belong to your organization, helping to eliminate potential security risks, identify under-utilized resources, and support compliance efforts.

Use the API to list assets, get individual asset information, import assets, and list and check the status of asset import jobs.

## RELATED LINKS

[Tenable Developer API Reference : Assets](https://developer.tenable.com/reference#assets)
