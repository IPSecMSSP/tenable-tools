# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 2024-10-15

### Added

- Get-TioAgent
- Get-TioScanner
- Get-TioServer
- Get-TioServerStatus
- Get-TioVulnPluginFamily
- Get-TioVulnScan

### Changed

- Adjusted output level of response headers from Verbose to Debug

## [1.1.0] - 2024-01-16

### Added

- Example Script: Invoke-TioLrCategorySync.ps1 with documentation
- Get-TioExportVuln.ps1 - Export Vulnerabilities
- Get-TioExportVulnStatus.ps1 - Get Export Vulnerability Job Status
- Get-TioExportVulnChunk.ps1 - Export Vulerabilties by chunk
- Stop-TioExportVuln.ps1 - Cancel Vulnerabilty Export
- Get-TioVulnPlugin.ps1 - Export Vulnerability Plugin Details
- Documentation for the above

### Changed

- Support Pipelining of Stop-TioExportAsset.ps1
- Minor fixes in Documentation to suppress/fix Linting issues
- Build script support to sign code using certificate stored in Azure Key Vault

## [1.0.3] - 2022-11-15

### Fixed

- Use correct code signing certificate

## [1.0.2] - 2022-11-14

### Changed

- Switch Code Signing Certificate to `IPSec Pty Ltd`
- Updated project references

## [1.0.0] - 2022-10-31

### Added

- Code Signing using GitLab Windows Runner
- Publish to PSGallery when merging to main or master
- Temporarily signed with internal certificate

### Changed

- Migrated primary development back to IPSec internal
  - Code signing security reasons

## [0.0.2] - 2022-03-15

### Added

- New-TioCredential function to construct an expected object that can be used as the -ApiKeys parameter on other functions
- MSSP Support
  - Get-TioMsspAccount function to query the list of available MSSP accounts
  - Get-TioMsspLogo function to get list of available logos
  - Set-TioMsspLogo function to assign log to one or more accounts
  - Requires an MSSP Account
- Tests for added functions
- Documentation for added functions
- Added GitHub Actions Workflow for Megalinter

### Changed

- Migrated primary development to GitHub
- Updated project links to use GitHub
- Updated minimum PowerShell version to 7.0 due to `-ResponseHeadersVariable` use on `Invoke-RestMethod`
- Use the same PSScriptAnalyzer settings for Build Script as used by MegaLinter

## [0.0.1] - 2021-09-17

### Added

- Initial release of Tenable.Tools
- Get-TioAsset
- Get-TioExportAsset
- Get-TioExportAssetChunk
- Get-TioExportAssetStatus
- Stop-TioExportAsset
- Get-TioFolder
- Invoke-TioApiRequest
- Get-TioTagCategory
- Get-TioTagValue

### Changed

- Nothing

### Deprecated

- Nothing

### Removed

- Nothing

### Fixed

- Nothing

### Security

- Nothing

### Known Issues

[Unreleased]: https://github.com/jberkers42/tenable-tools/
[1.2.0]: https://github.com/IPSecMSSP/tenable-tools/releases/tag/v1.2.0
[1.1.0]: https://github.com/IPSecMSSP/tenable-tools/releases/tag/v1.1.0
[1.0.2]: https://github.com/IPSecMSSP/tenable-tools/releases/tag/v1.0.2
[1.0.0]: https://github.com/IPSecMSSP/tenable-tools/releases/tag/v1.0.0
[0.0.2]: https://github.com/IPSecMSSP/tenable-tools/releases/tag/v0.0.2
[0.0.1]: https://github.com/IPSecMSSP/tenable-tools/releases/tag/v0.0.1
