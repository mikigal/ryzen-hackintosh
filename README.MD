# OpenCore EFI for AMD Ryzen Hackintosh

## Verified Specification

| **Component**    | **Model**                                  |
| ---------------- | ------------------------------------------ |
| CPU              | AMD Ryzen 7 1700 @ 3.8GHz                  |
| Motherboard      | ASUS B350 Plus                             |
| RAM              | 16GB (2 x 8GB) Corsair Vengeance @ 3000MHz |
| Audio Chipset    | ALC-887                                    |
| GPU              | MSI RX Vega 64                             |
| WiFi & Bluetooth | Fenvi T919 (BCM94360CD)                    |
| OS Disk (NVMe)   | ADATA SX8200 Pro 1TB                       |

**macOS version**: 11.4 (20F71) \
**OpenCore version**: 0.7.0

## Table of contents

- [Software Compatibility](#Software-Compatibility)
- [Hardware Compatibility](#Hardware-Compatibility)
- [Installation](#Installation)
- [BIOS Settings](#BIOS-Settings)
- [PAT Patch](#PAT-Patch)
- [Intel Fast Memset Patch](#Intel-Fast-Memset-Patch)
- [Virtualization](#Virtualization)
- [Guides](#Guides)
- [Credits](#Credits)

## Software Compatibility

- Big Sur (11.x)
- Catalina (10.15.x)
- Mojave (10.14.x)
- High Sierra (10.13.x)

macOS Monterey (12.0) is currently not supported due to missing AMD CPU patches. This repository will be updated for the newest macOS version as soon as possible.

## Hardware Compatibility

### Central Processing Unit (CPU)

This EFI is compatible with all Ryzen and Athlon 2xxGE processors with
[**macOS-compatible peripherals**](https://dortania.github.io/Anti-Hackintosh-Buyers-Guide/).

_Support for 15h (FX series), 16h (A series) and Threadripper CPUs is not covered here._

### Graphical Processing Unit (GPU)

| **Model**  | **Compatible?**        |
| ---------- | -----------------------|
| Integrated | No                     |
| Nvidia     | Partially <sup>1</sup> |
| AMD        | Yes <sup>2</sup>       |

<sup>1</sup> Only Big Sur and older versions, under correct [PAT Patch](#PAT-Patch), more details on [Dortania](https://dortania.github.io/GPU-Buyers-Guide/modern-gpus/nvidia-gpu.html)
<sup>2</sup> Lexa series GPUs are not supported. Older than 7000 series are supported up to High Sierra (10.13), their support is not covered here.

For **AMD Navi 10 Series GPUs (RX 5500, RX 5600, RX 5700)** you need to add `agdpmod=pikera` to `boot-args` to fix the black screen issue.

[PAT Patch made by Shaneee](#PAT-Patch) is used by default. It improves GPU performance but it has a few caveats. Audio passed by HDMI won't work or will be unstable. It also **does not** work with Nvidia GPUs.

### Motherboards

| **Chipset**                  | **Details**                                                         |
| ---------------------------- | ------------------------------------------------------------------- |
| B550, A520                   | Requires _SSDT-CPUR_ to boot. [Details here.](#SSDT-CPUR)           |
| B550, A520, B450, X470, X570 | `SetupVirtualMap` has to be [disabled](#Disabling-SetupVirtualMap). |
| Other                        | Should be compatible out of the box.                                |

#### _SSDT-CPUR_

Follow these steps to properly install _SSDT-CPUR_.

- Download from [here](https://github.com/dortania/Getting-Started-With-ACPI/blob/master/extra-files/compiled/SSDT-CPUR.aml).
- Install it to your `OC/ACPI` directory.
- Add it to your configuration file. Use ProperTree for simplicity.

#### _Disabling SetupVirtualMap_

To disable `SetupVirtualMap` simply go to `Booter -> Quirks -> SetupVirtualMap` in your configuration file and disable it. (Should be `false`).

### Audio

Follow these steps if your audio chipset is different than the one specified in the [Specification](#Specification).

- Go [here](https://github.com/acidanthera/applealc/wiki/supported-codecs) to find your audio chipset codec. (Under _Codec_)
  - If you can't find your codec on the list, then you probably have to use VoodoHDA. This repository does not cover or support the use of VoodoHDA.
- Under _Revisions and layouts_ you'll see bunch of numbers and layout ids.
- Find your `boot-args` settings and look for `alcid=11`.
- Try every layout id (except _0x_ values) one by one until it works.
  - Example: `alcid=10` if `layout 10`

_Caveats_:

- External (USB) audio chipsets should work out of the box.
- Microphone input (3.5mm Jack) won't work properly. Use USB/Bluetooth microphones instead.

### Network

If you experience any issues with your network connection, then your best bet would be to install a different kext, preferably from [here](https://dortania.github.io/OpenCore-Install-Guide/ktext.html#ethernet).

If you use High Sierra and Realtek 8111 Ethernet Card then you should use [this kext](https://bitbucket.org/RehabMan/os-x-realtek-network/downloads/).

## Installation

### Bootable USB

1. Follow [this guide](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/) to create your bootable USB.

2. Clone this repository and copy "BOOT" & "OC" directories to your "EFI" directory on your bootable USB. The structure should look somewhat like this: `EFI -> BOOT, OC`.

### SMBIOS

3. Use [this tool](https://github.com/corpnewt/GenSMBIOS) to generate your unique SMBIOS info.

- SMBIOS has to be unique, you cannot use one present in this repository.

- Run the tool and select `Generate SMBIOS`.
- Select the appropriate model for your hardware using the table below.

| **GPU Series**       | **Model**                      |
| -------------------- | ----------                     |
| AMD Navi Series      | iMacPro1,1 <sup>1</sup>        |
| AMD Polaris Series   | iMacPro1,1 <sup>1</sup>        |
| AMD RX Vega Series   | iMacPro1,1 <sup>1</sup>        |
| AMD Radeon R5/R7/R9  | MacPro6,1                      |
| AMD HD 7000 Series   | MacPro6,1                      |
| AMD HD 8000 Series   | MacPro6,1                      |
| Nvidia Kepler Series | It's complicated <sup>2</sup>  |

<sup>1</sup> For Catalina and newer you can also use MacPro7,1 if you have issues (e. g. broken DRMs)
<sup>2</sup> For Catalina and older use iMac14,2, for Big Sur MacPro7,1. Monterey and newer does not support any Nvidia GPUs.

- Open _config.plist_ and search for `PlatformInfo -> Generic` and replace these values:
  - _MLB_ - Board Serial
  - _SystemSerialNumber_ - Serial
  - _SystemUUID_ - SmUUID
  - _SystemProductName_ - Model
- _ROM_ entry should be set to your [network card's MAC address](https://www.wikihow.com/Find-the-MAC-Address-of-Your-Computer).

### Configuration

5. You should update your BIOS to the latest version and configure it appropriately. See [BIOS Settings](#BIOS-Settings) for details.
6. Remember to verify your hardware and apply appropriate changes to your configuration file. See [Hardware Compatibility](#Hardware-compatibility) for details.
7. That's it!

### Post-Installation

8. Copy your EFI directory onto your main drive EFI partition, you'll be able to boot the system without your bootable USB.
9. Dual boot requires Bootstrap, see [this guide](https://dortania.github.io/OpenCore-Post-Install/multiboot/bootstrap.html) for specific details.
10. Apply [Ryzen patch script](/Resources/ryzen_patch.sh) - it solves MKL (Math Kernel Library) issues and sets correct sleep parameters.

## BIOS Settings

| **Option**            | **Status**           |
| --------------------- | -------------------- |
| SATA Mode             | AHCI                 |
| Above 4G Decoding     | Enabled <sup>1</sup> |
| EHCI/XHCI Hand-off    | Enabled              |
| SVM                   | Enabled              |
| CSM                   | Disabled             |
| Resizable BAR Support | Disabled             |
| Secure Boot           | Disabled             |
| Serial Port           | Disabled             |
| Parallel Port         | Disabled             |

<sup>1</sup> You must also remove `npci=0x2000` from `boot-args` in `config.plist`

**Some of these options may not exist in your firmware, just try to match it as closely as possible.**

**Before booting macOS remember to update BIOS to the latest version.**

## PAT Patch

| **Shaneee's**                 | **Algrey's**             |
| ----------------------------- | ------------------------ |
| Much better GPU performance   | Worse GPU performance    |
| May not work with NVIDIA GPUs | Compatible with all GPUs |
| HDMI/DP audio may not work    | HDMI/DP audio works      |
| Enabled by default            | Disabled by default      |

To switch to another patch look for `mtrr_update_action` in `config.plist`. Then set `Enabled` to `true` for the patch you want to use. Remember to set `Enabled` to `false` on the other PAT patch.

## Intel Fast Memset Patch

Some applications for macOS use `intel_fast_memset` instruction which, obviously, doesn't exist on AMD systems. There's a patch that you can use to easily fix these apps.

Adobe suite requires a [different script](/Resources/adobe_patch.sh) due to greater amount of issues to patch.

## Virtualization

### Prerequisites

- Make sure you have `SVM` enabled in your BIOS settings.

| **Software**      | **Compatibility**                                                              |
| ----------------- | ------------------------------------------------------------------------------ |
| Parallels Desktop | Up to 13.1 unless AppleHV is used.<sup>1</sup> <sup>2</sup>                    |
| VirtualBox        | Drastically decreased performance.                                             |
| VMWare Fusion 10  | Only Catalina, with [this patch](https://posts.boy.sh/vmware-fusion-catalina). |
| Docker            | Only Docker Toolbox, not all features.                                         |

<sup>1</sup> Parallels will not work by default on Big Sur and newer, you need to use `SYSTEM_VERSION_COMPAT=1` environment variable.

<sup>2</sup> Use [this](/Resources/Parallels%20Desktop%20Launcher.app.zip) launcher package to simplify the Parallels installation.

### Resource management

You shouldn't add too much resources to your virtual machines, as it causes performance issues regardless of your hardware.

Use the following configuration for best results.

- Parallels Desktop 13.1
- 4 CPU cores
- 4GB RAM
- 1GB VRAM
- 3D Acceleration: DirectX 9
- OS: Windows 7 (SP1, build 7601) with Aero theme disabled.

## Guides

- Creating USB installer: [**\*click\***](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/)
- OpenCore configuration: [**\*click\***](https://dortania.github.io/OpenCore-Install-Guide/AMD/zen.html)
- Post-Install: [**\*click\***](https://dortania.github.io/OpenCore-Post-Install/)
- Troubleshooting: [**\*click\***](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/troubleshooting.html)
- ACPI patching: [**\*click\***](https://dortania.github.io/Getting-Started-With-ACPI/)
- USB mapping: [**\*click\***](https://dortania.github.io/OpenCore-Post-Install/usb/)

If you have any other questions or issues, feel free to ask on [**AMD-OSX Discord**](https://discord.gg/EfCYAJW) or [**Forum**](https://forum.amd-osx.com)

## Credits

**Software:**

- [[Bootloader] OpenCore](https://github.com/acidanthera/OpenCorePkg)
- [[Resources] Picker GUI](https://github.com/acidanthera/OcBinaryData/tree/master/Resources)
- [[Patch] AMD_Vanilla](https://github.com/AMD-OSX/AMD_Vanilla)
- [[SSDT] EC-USBX-DESKTOP](https://github.com/dortania/Getting-Started-With-ACPI/blob/master/extra-files/compiled/SSDT-EC-USBX-DESKTOP.aml)
- [[SSDT] SLEEP](./OC/ACPI/SSDT-SLEEP.aml)
- [[Driver] OpenRuntime](https://github.com/acidanthera/OpenCorePkg)
- [[Driver] OpenCanopy](https://github.com/acidanthera/OpenCorePkg)
- [[Driver] OpenHfsPlus](https://github.com/acidanthera/OpenCorePkg)
- [[Kext] Lilu](https://github.com/acidanthera/Lilu)
- [[Kext] VirtualSMC](https://github.com/acidanthera/VirtualSMC)
- [[Kext] WhateverGreen](https://github.com/acidanthera/WhateverGreen)
- [[Kext] AppleALC](https://github.com/acidanthera/AppleALC)
- [[Kext] NVMeFix](https://github.com/acidanthera/NVMeFix)
- [[Kext] RestrictEvents](https://github.com/acidanthera/RestrictEvents)
- [[Kext] RealtekRTL8111](https://github.com/Mieze/RTL8111_driver_for_OS_X)
- [[Kext] AMDRyzenCPUPowerManagement](https://github.com/trulyspinach/SMCAMDProcessor)
- [[Kext] SMCAMDProcessor](https://github.com/trulyspinach/SMCAMDProcessor)
- [[Kext] AppleMCEReporterDisabler](https://github.com/AMD-OSX/AMD_Vanilla/blob/opencore/Extra/AppleMCEReporterDisabler.kext.zip)

**People/Organizations:**

- [Apple](https://apple.com) for macOS
- [AMD-OSX Developers](https://github.com/AMD-OSX) for kernel patches for AMD CPUs
- [Acidanthera](https://github.com/acidanthera) for OpenCore and most of used kexts
- [Trulyspinach](https://github.com/trulyspinach) for Ryzen power management and monitoring kexts
- [Mieze](https://github.com/Mieze) for RealtekRTL8111 kext
- [Dortania](https://github.com/dortania) for OpenCore configuration guides
- [XLNC](https://github.com/naveenkrdy) for Adobe patches for AMD CPUs
- [AMD-OSX Community](https://amd-osx.com) for support while making my Hackintosh
- [SocketByte](https://github.com/SocketByte) for README maintenance and being a great friend :)
  <br>

![Screenshot](/screenshot.png?raw=true)
