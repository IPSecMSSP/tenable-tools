# Tenable.Tools

PowerShell module for interfacing to the Tenable.io API

## Overview

Tenable.Tools provides an interface to the Tenable.io API

## Getting Started

### PowerShell Gallery

Install Tenable.Tools from the [PowerShell Gallery](https://www.powershellgallery.com/) using `Install-Module`.

```powershell
Install-Module -Name Tenable.Tools -Scope CurrentUser
```

### Local Build

Use `Invoke-Build` to run a local build of Tenable.Tools...

```powershell
Invoke-Build -Task Build
```

Then you can import the built module into your PowerShell session.

```powershell
Import-Module "<ProjectRoot>\build\Tenable.Tools\Tenable.Tools.psd1" -Force
```

## Usage

TODO

## Uninstalling

Remove Tenable.Tools from your system using `Uninstall-Module`.

```powershell
Uninstall-Module -Name Tenable.Tools
```

## Importing From Source

If you are working on the module locally and want to import it into your PowerShell session without running through a compile/build, you can just import the module manifest directly from within the ```src``` directory.

```powershell
Import-Module "<ProjectRoot>\src\Tenable.Tools.psd1" -Force
```

## Contributions

Contributions are very welcome and there are many ways to contribute:

- Open a new bug report, feature request or just ask a question by creating a new issue.
- Participate in issue and pull requests discussion threads, and test fixes or new features.
- Submit your own fixes or features as a pull request.
  - If your change is substantial, please open an issue for discussion beforehand.
