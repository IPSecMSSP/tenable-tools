# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- New-TioCredential function to construct an expected object that can be used as the -ApiKeys parameter on other functions
- MSSP Support
  - Get-TioMsspAccount function to query the list of available MSSP accounts
  - Get-TioMsspLogo function to get list of available logos
  - Set-TioMsspLogo function to assign log to one or more accounts
  - Requires an MSSP Account
- Tests for added functions
- Documentation for added functions

## [0.0.1] - Insert release date

### Added

- Initial release of Tenable.Tools

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

- [#1](https://gitlab.soc.ipsec.net.au/vendors/tenable/tenable-tools/-/issues/1) Documentation is somewhat lacking

[Unreleased]: https://gitlab.soc.ipsec.net.au/vendors/tenable/tenable-tools/
[0.0.1]: https://gitlab.soc.ipsec.net.au/vendors/tenable/tenable-tools/-/releases/v0.0.1
