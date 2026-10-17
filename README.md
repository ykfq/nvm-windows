<h1 align="center">NVM for Windows</h1>

> [!IMPORTANT]
> **This fork fully supports non-administrator accounts.** No admin rights, no elevation and no UAC prompt are needed to install it or to use it.
>
> The portable build configures everything inside *your own* user account — `NVM_HOME`, `NVM_SYMLINK` and `PATH` are written to `HKCU\Environment`, never machine-wide — and it switches Node.js versions using NTFS **junctions** instead of symlinks, which Windows allows a standard user to create. See [Portable, no-admin installation](#portable-no-admin-installation).

<div align="center">
  The <a href="https://docs.microsoft.com/en-us/windows/nodejs/setup-on-windows">Microsoft</a>/<a href="https://docs.npmjs.com/cli/v9/configuring-npm/install#windows-node-version-managers">npm</a>/<a href="https://cloud.google.com/nodejs/docs/setup#installing_nvm">Google</a> recommended Node.js version manager for <em>Windows</em>.<br/>

<details>
<summary><b>This is not the same thing as nvm!</b> (expand for details)</summary>

_The original [nvm](https://github.com/nvm-sh/nvm) is a completely separate project for Mac/Linux only._ This project uses an entirely different philosophy and is not just a clone of nvm. Details are listed in [Why another version manager?](#bulb-why-another-version-manager) and [what&#39;s the big difference?](#bulb-whats-the-big-difference).
</details>

[![Download Latest Now](https://img.shields.io/badge/-Download%20Now!-%2322A6F2)](https://github.com/ykfq/nvm-windows/releases) [![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/ykfq/nvm-windows?label=Latest%20Release&style=social&x=1)](https://github.com/ykfq/nvm-windows/releases) ![GitHub Release Date](https://img.shields.io/github/release-date/ykfq/nvm-windows?label=Released&style=social) ![GitHub all releases](https://img.shields.io/github/downloads/ykfq/nvm-windows/total?label=Downloads&style=social) [![Discuss](https://img.shields.io/badge/-Discuss-blue)](https://github.com/coreybutler/nvm-windows/discussions)
</div>

<div align="center"><b>Running into issues?</b> See the <a href="https://github.com/coreybutler/nvm-windows/wiki/Common-Issues">common issues wiki</a>.</div>

## Overview

Manage multiple installations of node.js on a Windows computer.

**tl;dr** Similar (not identical) to [nvm](https://github.com/creationix/nvm), but for Windows. [Download Now](https://github.com/ykfq/nvm-windows/releases)!

This has always been a node version manager, not an io.js manager, so there is no back-support for io.js. Node 4+ is supported. Running `nvm install` or `nvm use` does **not** require administrative rights: versions are switched using NTFS junctions and every setting lives in your own user account, so a normal, non-elevated shell is all you need (see [Portable, no-admin installation](#portable-no-admin-installation)). To install the latest version of Node.js, run `nvm install latest`. To install the latest stable version, run `nvm install lts`.

![NVM for Windows](https://github.com/coreybutler/staticassets/raw/master/images/nvm-1.1.8-screenshot.jpg)

There are situations where the ability to switch between different versions of Node.js can be very useful. For example, if you want to test a module you're developing with the latest bleeding edge version without uninstalling the stable version of node, this utility can help.

![Switch between stable and unstable versions.](https://github.com/coreybutler/staticassets/raw/master/images/nvm-usage-highlighted.jpg)

### Installation & Upgrades

#### :star: :star: Uninstall any pre-existing Node installations!! :star: :star:

The simplest (recommended) way to get NVM for Windows running properly is to uninstall any prior Node installation _before_ installing NVM for Windows. It avoids all of the pitfalls listed below. However; you may not wish to nuke your Node installation if you've highly customized it. NVM for Windows _can_ assume management of an existing installation, but there are nuances to this (dependent entirely on the permissions of the user running the installation). If you have an administrative account, it's relatively safe to install NVM for Windows before uninstalling the original Node version. If you are working in a closed environment, such as a corporate Active Directory environment where installations/uninstallations are controlled by group policy, you should really consider removing the original version of Node before installing NVM4W.

_Permission Problems_
For security reasons, Windows will not allow an application from one vendor to "uninstall" an application from a different vendor. The official NVM4W installer will attempt assume management of an existing installation of Node., but it cannot actually uninstall the original Node.js version. To work around this, NVM for Windows installer attempts to copy the original Node.js installation files to the NVM root. This includes global npm modules and configurations. Once this process is complete, the original Node.js installation can be uninstalled without losing data.

_PATH Installation Problems_
If you attempt to configure the `NVM_SYMLINK` to use an existing directory (like `C:\Program Files\nodejs`), it will fail because a symlink cannot overwrite a physical directory. This is not a problem if you choose a different symlink path (such as `C:\nvm\node`).

_PATH Conflicts_
If you do not uninstall the original version, running `nvm use` may appear to do nothing at all. Running `node -v` will always show the original installation version. This is due to a [`PATH` conflict](https://github.com/coreybutler/nvm-windows/wiki/Common-Issues#why-do-i-need-to-uninstall-nodejs-before-installing-nvm-for-windows) that presents when the same application is installed multiple times. In NVM4W 1.1.11+, run `nvm debug` to determine if you have a `PATH` conflict.

For simpliciy, we recommend uninstalling any existing versions of Node.js before using NVM for Windows. Delete any existing Node.js installation directories (e.g., `%ProgramFiles%\nodejs`) that might remain. NVM's generated symlink will not overwrite an existing (even empty) installation directory.

:eyes: **Backup any global `npmrc` config** :eyes:
(e.g. `%AppData%\npm\etc\npmrc`)

Alternatively, copy the settings to the user config `%UserProfile%\.npmrc`. Delete the existing npm install location (e.g. `%AppData%\npm`) to prevent global module conflicts.

#### Install nvm-windows

Two ways to install:

* **No administrator rights? Use the portable build.** Download `nvm-noinstall.zip` from the [releases page](https://github.com/ykfq/nvm-windows/releases) and follow [Portable, no-admin installation](#portable-no-admin-installation) below.
* **With administrator rights**, you can also use the [latest installer](https://github.com/coreybutler/nvm/releases) (comes with an uninstaller) or follow the  [manual installation](https://github.com/coreybutler/nvm-windows/wiki#manual-installation) guide.

_If NVM4W doesn't appear to work immediately after installation, restart the terminal/powershell (not the whole computer)._

![NVM for Windows Installer](https://github.com/coreybutler/staticassets/raw/master/images/nvm-installer.jpg)

#### Portable, no-admin installation

This is the recommended way to install NVM for Windows when you do **not** have administrator rights. Nothing in this path triggers a UAC prompt, and nothing is written outside your own user account.

1. Download **`nvm-noinstall.zip`** from the [releases page](https://github.com/ykfq/nvm-windows/releases) and extract it to a folder you can write to, for example `%USERPROFILE%\PortableApps\nvm`.

2. Run **`install.cmd`** from that folder (double-click it, or run it in an ordinary Command Prompt). It is interactive and asks for two paths:

   - `NVM_PATH` — the folder you extracted the files into; this becomes `NVM_HOME`, e.g. `C:\Users\me\PortableApps\nvm`.
   - `NVM_SYMLINK` — the folder where the link to the *active* Node.js will be created, e.g. `C:\Users\me\PortableApps\nodejs`. It must not already exist as a real directory.

   Press **Enter** at each prompt to accept the default, which is derived from the folder you extracted into.

3. **Open a new terminal** so the environment changes take effect, then install a version:

   ```
   nvm install lts
   nvm use lts
   node -v
   ```

Everything `install.cmd` does happens inside **your own user account**:

| What | How | Elevation |
|---|---|---|
| `NVM_HOME`, `NVM_SYMLINK` | `setx` **without** `/M` → `HKCU\Environment` | none |
| `PATH` | `setuserenv.vbs` appends `%NVM_HOME%;%NVM_SYMLINK%` to the *user* `PATH`, written as `REG_EXPAND_SZ` so the variables expand | none |
| nvm's own configuration | `settings.txt` next to `nvm.exe` (`root:`, `path:`, `arch:`, mirrors) | none |
| switching versions | `mklink /J` → an NTFS **junction** | none |

> [!NOTE]
> Older releases shelled out to `mklink /D`, which creates a real symlink and therefore required an Administrator shell. Version switching now creates a **junction** instead: the effect on `PATH` is the same, but a standard user is allowed to create one. An install-time `PATH.txt` and `settings.txt` are written next to `nvm.exe` to help with troubleshooting.

To undo the installation, delete the folder and remove `%NVM_HOME%` and `%NVM_SYMLINK%` from your user `PATH` — the `unsetuserenv.vbs` script in the same folder does exactly that.

#### Users in China: use a mirror

Downloads from `nodejs.org` are slow or blocked in mainland China. Point nvm at a mirror once and every later `nvm install` will use it:

```
nvm node_mirror https://npmmirror.com/mirrors/node
nvm npm_mirror  https://npmmirror.com/mirrors/npm
```

`node_mirror` serves the Node.js binaries; `npm_mirror` serves the npm release that nvm installs alongside Node.js. Both are saved in nvm's `settings.txt`, so they apply to every new terminal as well. Run either command with a blank URL to go back to the official servers:

```
nvm node_mirror
nvm npm_mirror
```

npm *packages* are still fetched from the npm registry, so to speed those up as well:

```
npm config set registry https://registry.npmmirror.com
```

#### Reinstall any global utilities

After install, reinstalling global utilities (e.g. yarn) will have to be done for each installed version of node:

```
nvm use 14.0.0
npm install -g yarn
nvm use 12.0.1
npm install -g yarn
```

### Upgrading nvm-windows

:bulb: _As of v1.1.8, there is an upgrade utility that will automate the upgrade process._

**To upgrade nvm-windows**, run the new installer. It will safely overwrite the files it needs to update without touching your node.js installations. Make sure you use the same installation and symlink folder. If you originally installed to the default locations, you just need to click "next" on each window until it finishes.

### Usage

**No Administrator shell is required.** An ordinary, non-elevated `powershell` or Command Prompt is enough to use nvm-windows — see [Portable, no-admin installation](#portable-no-admin-installation).

NVM for Windows is a command line tool. Simply type `nvm` in the console for help. The basic commands are:

- **`nvm arch [32|64]`**: Show if node is running in 32 or 64 bit mode. Specify 32 or 64 to override the default architecture.
- **`nvm debug`**: Check the NVM4W process for known problems.
- **`nvm current`**: Display active version.
- **`nvm install <version> [arch]`**:  The version can be a specific version, "latest" for the latest current version, or "lts" for the most recent LTS version. Optionally specify whether to install the 32 or 64 bit version (defaults to system arch). Set [arch] to "all" to install 32 AND 64 bit versions. Add `--insecure` to the end of this command to bypass SSL validation of the remote download server.
- **`nvm list [available]`**: List the node.js installations. Type `available` at the end to show a list of versions available for download.
- **`nvm on`**: Enable node.js version management.
- **`nvm off`**: Disable node.js version management (does not uninstall anything).
- **`nvm proxy [url]`**: Set a proxy to use for downloads. Leave `[url]` blank to see the current proxy. Set `[url]` to "none" to remove the proxy.
- **`nvm uninstall <version>`**: Uninstall a specific version.
- **`nvm use <version> [arch]`**: Switch to use the specified version. Optionally use `latest`, `lts`, or `newest`. `newest` is the latest _installed_ version. Optionally specify 32/64bit architecture. `nvm use <arch>` will continue using the selected version, but switch to 32/64 bit mode. For information about using `use` in a specific directory (or using `.nvmrc`), please refer to [issue #16](https://github.com/coreybutler/nvm-windows/issues/16).
- **`nvm root <path>`**: Set the directory where nvm should store different versions of node.js. If `<path>` is not set, the current root will be displayed.
- **`nvm version`**: Displays the current running version of NVM for Windows.
- **`nvm node_mirror <node_mirror_url>`**: Set the node mirror.People in China can use *https://npmmirror.com/mirrors/node/*
- **`nvm npm_mirror <npm_mirror_url>`**: Set the npm mirror.People in China can use *https://npmmirror.com/mirrors/npm/*

### :warning: Gotcha!

Please note that any global npm modules you may have installed are **not** shared between the various versions of node.js you have installed. Additionally, some npm modules may not be supported in the version of node you're using, so be aware of your environment as you work.

### :name_badge: Antivirus

Users have reported some problems using antivirus, specifically McAfee. It appears the antivirus software is manipulating access to the VBScript engine. See [issue #133](https://github.com/coreybutler/nvm-windows/issues/133) for details and resolution.

The binaries published by this fork are **not code signed**, so SmartScreen or your antivirus software may warn you the first time you run `nvm.exe`. If you want to be certain a downloaded copy is intact, compare it against the `nvm-noinstall.zip.checksum.txt` published next to it on the [releases page](https://github.com/ykfq/nvm-windows/releases).

### Using Yarn

**tldr;** `npm i -g yarn`

See the [wiki](https://github.com/coreybutler/nvm-windows/wiki/Common-Issues#how-do-i-use-yarn-with-nvm-windows) for details.

### Build from source

- Install go from http://golang.org
- Download source / Git Clone the repo
- Change GOARCH to amd64 in build.bat if you feel like building a 64-bit executable
- Fire up a Windows command prompt and change directory to project dir
- Execute `go get github.com/blang/semver`
- Execute `go get github.com/olekukonko/tablewriter`
- Execute `build.bat`
- Check the `dist`directory for generated setup program.

---

## :bulb: Why another version manager?

There are several version managers for node.js. Tools like [nvm](https://github.com/creationix/nvm) and [n](https://github.com/tj/n)
only run on Mac OSX and Linux. Windows users are left in the cold? No. [nvmw](https://github.com/hakobera/nvmw) and [nodist](https://github.com/marcelklehr/nodist)
are both designed for Windows. So, why another version manager for Windows?

The architecture of most node version managers for Windows rely on `.bat` files, which do some clever tricks to set or mimic environment variables. Some of them use node itself (once it's downloaded), which is admirable, but prone to problems. Right around node 0.10.30, the installation structure changed a little, causing some of these to just stop working with anything new.

Additionally, some users struggle to install these modules since it requires a little more knowledge of node's installation structure. I believe if it were easier for people to switch between versions, people might take the time to test their code on back and future versions... which is just good practice.

## :bulb: What's the big difference?

First and foremost, this version of nvm has no dependency on node. It's written in [Go](https://golang.org/), which is a much more structured approach than hacking around a limited `.bat` file. It does not rely on having an existing node installation. Go offers the ability to create a Mac/Linux version on the same code base. In fact, this is already underway.

The control mechanism is also quite different. There are two general ways to support multiple node installations with hot switching capabilities. The first is to modify the system `PATH` any time you switch versions, or bypass it by using a `.bat` file to mimic the node executable and redirect accordingly. This always seemed a little hackish to me, and there are some quirks as a result of this implementation.

The second option is to use a symlink. This concept requires putting the symlink in the system `PATH`, then updating its target to the node installation directory you want to use. This is a straightforward approach, and seems to be what people recommend.... until they realize just how much of a pain symlinks are on Windows. This is why it hasn't happened before.

In order to create/modify a symlink, you must be running as an admin, and you must get around Windows UAC (that annoying prompt). **This fork sidesteps that problem entirely: versions are switched with NTFS junctions instead of symlinks, and a junction can be created by a standard user, so no elevation and no UAC prompt are involved** (see [Portable, no-admin installation](#portable-no-admin-installation)). As a result, NVM for Windows maintains a single link that is put in the `PATH` during installation only. Switching to different versions of node is a matter of switching the symlink target. As a result, this utility does **not** require you to run `nvm use x.x.x` every time you open a console window. When you _do_ run `nvm use x.x.x`, the active version of node is automatically updated across all open console windows. It also persists between system reboots, so you only need to use nvm when you want to make a change.

Overall, this project brings together some ideas, a few battle-hardened pieces of other modules, and support for newer versions of node.

NVM for Windows recognizes the "latest" versions using a [list](https://nodejs.org/download/release/index.json) provided by the Node project. Version 1.1.1+ use this list; before it existed, releases were scraped into a standalone data feed, which was used in versions 1.1.0 and prior and is now deprecated.

## Motivation

I needed it, plain and simple. Additionally, it's apparent that [support for multiple versions](https://github.com/nodejs/node-v0.x-archive/issues/8075) is not coming to node core. It was also an excuse to play with Go.

## Why Go? Why not Node?

I chose Go because it is cross-platform, felt like less overhead than Java, has been around longer than most people think. Plus, I wanted to experiment with it. I've been asked why I didn't write it with Node. Trying to write a tool with the tool you're trying to install doesn't make sense to me. As a result, my project requirements for this were simple... something that's not Node. Node will continue to evolve and change. If you need a reminder of that, remember io.js, Ayo, all the breaking changes between 4.x.x and 6.x.x, and the shift to ES Modules in 12+. Change is inevitable in the world of software. JavaScript is extremely dynamic.

## :pray: Thanks

Thanks to everyone who has submitted issues on and off Github, made suggestions, and generally helped make this a better project. Special thanks to

- [@vkbansal](https://github.com/vkbansal), who provided significant early feedback throughout the early releases.
- [@rainabba](https://github.com/rainabba) and [@sullivanpt](https://github.com/sullivanpt) for getting Node v4 support integrated.
- [@s-h-a-d-o-w](https://github.com/s-h-a-d-o-w) who resolved the longstanding space escaping issue in path names ([#355](https://github.com/coreybutler/nvm-windows/pull/355)).

<br/>

![Contributors](https://contrib.rocks/image?repo=coreybutler/nvm-windows)
