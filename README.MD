# OpenCore EFI for AMD Ryzen Hackintosh [![tests](https://github.com/mikigal/ryzen-hackintosh/actions/workflows/tests.yml/badge.svg)](https://github.com/mikigal/ryzen-hackintosh/actions/workflows/tests.yml)

## Verified Specification

| **Component**    | **Model**                                  |
| ---------------- | ------------------------------------------ |
| CPU              | AMD Ryzen 7 1700 @ 3.8GHz                  |
| Motherboard      | ASUS B350 Plus                             |
| RAM              | 16GB (2 x 8GB) Corsair Vengeance @ 3000MHz |
| GPU              | MSI RX Vega 64                             |
| Audio Chipset    | ALC-887                                    |
| Ethernet         | Realtek RTL8111                            |
| WiFi & Bluetooth | Fenvi T919 (BCM94360CD)                    |
| OS Disk (NVMe)   | ADATA SX8200 Pro 1TB                       |

**macOS version**: 13.3.1 (a) (22E772610a) \
**OpenCore version**: 0.9.3

## Table of contents

- [Software Compatibility](#Software-Compatibility)
- [Hardware Compatibility](#Hardware-Compatibility)
- [Installation](#Installation)
- [BIOS Settings](#BIOS-Settings)
- [PAT Patch](#PAT-Patch)
- [MKL and Intel Fast Memset Patch](#MKL-and-Intel-Fast-Memset-Patch)
- [DRMs support](#DRMs-support)
- [Sleep](#Sleep)
- [Virtualization](#Virtualization)
- [Guides](#Guides)
- [Credits](#Credits)

## Software Compatibility

- Ventura (13.x)
- Monterey (12.x)
- Big Sur (11.x)
- Catalina (10.15.x)
- Mojave (10.14.x)
- High Sierra (10.13.x)

**Note about macOS Sonoma**: I don't add support for macOS Sonoma due to many bugs (in OpenCore, kexts and beta of macOS). You can do it yourself by updating OC, kexts and kernel patches manually to it's beta versions. Support will be added after public beta release. Also Broadcome WiFi cards **does not work** for now as Apple removed it's support. Support may be added in future by some kext, but it's not guaranteed.

## Hardware Compatibility

### Central Processing Unit (CPU)

This EFI is compatible with all Ryzen and Athlon 2xxGE processors with
[macOS-compatible peripherals](https://dortania.github.io/Anti-Hackintosh-Buyers-Guide/).

_Support for 15h (FX series), 16h (A series) and Threadripper CPUs is not covered here._

### Graphical Processing Unit (GPU)

| **Model**  | **Compatible?**               |
| ---------- | ----------------------------- |
| Integrated | No                            |
| Nvidia     | Partially <sup>1</sup>        |
| AMD        | Yes <sup>2</sup> <sup>3</sup> |

<sup>1</sup> Support for Nvidia GPUs was dropped in Monterey Beta 7, the only way to get it back is using [OpenCore Legacy Patcher](https://github.com/dortania/OpenCore-Legacy-Patcher). Kepler series under correct [PAT Patch](#PAT-Patch). Others require WebDrivers which work only in High Sierra or are not supported. More details on [Dortania](https://dortania.github.io/GPU-Buyers-Guide/modern-gpus/nvidia-gpu.html).

<sup>2</sup> Some R7 and R9 GPUs require FakeID. More details [here](https://dortania.github.io/Getting-Started-With-ACPI/Universal/spoof.html)

<sup>3</sup> Lexa series GPUs are not supported. Older than 7000 series are supported up to High Sierra (10.13), their support is not covered here.

For **AMD Navi 10 Series GPUs (RX 5500, RX 5600, RX 5700)** you need to add `agdpmod=pikera` to `boot-args` to fix the black screen issue.

[PAT Patch made by Shaneee](#PAT-Patch) is used by default. It improves GPU performance but it has a few caveats. Audio passed by HDMI or DisplayPort won't work or will be unstable. It also **may not** work with Nvidia GPUs.

If you want to control monitor's brightness or HDMI/DP audio volume you need to use [MonitorControl](https://github.com/MonitorControl/MonitorControl) for that.

### Laptops
All laptops with AMD CPUs are not supported due to integrated GPUs incompatbility.

### Motherboards

| **Chipset**                  | **Details**                                                         |
| ---------------------------- | ------------------------------------------------------------------- |
| B550, A520                   | Requires _SSDT-CPUR_ to boot. [Details here.](#SSDT-CPUR)           |
| B550, A520, B450, X470, X570 | `SetupVirtualMap` has to be [disabled](#Disabling-SetupVirtualMap). |
| Other                        | Should be compatible out of the box.                                |

#### _SSDT-CPUR_

Follow these steps to properly install _SSDT-CPUR_.

- Download from [here](https://github.com/naveenkrdy/Misc/blob/master/SSDTs/Compiled/SSDT-CPUR.aml).
- Install it to your `OC/ACPI` directory.
- Add it to your configuration file. Use ProperTree for simplicity.

#### _Disabling SetupVirtualMap_

To disable `SetupVirtualMap` simply go to `Booter -> Quirks -> SetupVirtualMap` in your configuration file and disable it. (Should be `false`).

### Audio

Follow these steps if your audio chipset is different than the one specified in the [Specification](#Specification).

- Go [here](https://github.com/acidanthera/applealc/wiki/supported-codecs) to find your audio chipset codec. (Under _Codec_)
  - If you can't find your codec on the list, then you probably have to use [VoodooHDA](https://sourceforge.net/projects/voodoohda/). This repository does not cover or support the use of VoodooHDA.
- Under _Revisions and layouts_ you'll see bunch of numbers and layout ids.
- Find your `boot-args` settings and look for `alcid=11`.
- Try every layout id (except _0x_ values) one by one until it works.
  - Example: `alcid=10` if `layout 10`

_Caveats_:

- External (USB) audio cards should work out of the box.
- Microphone input (3.5mm Jack) won't work properly. Use USB/Bluetooth microphones instead.
- If you have CPU with integrated GPU (even if you don't use it) your audio may be broken or unstable. You can try using [SpeedKeeper](https://github.com/astrihale/speedkeeper) but it's not guaranteed to fix your problem. The best solution is using external (USB) audio card.

### Network

If you experience any issues with your network connection, then your best bet would be to install a different kext, preferably from [here](https://dortania.github.io/OpenCore-Install-Guide/ktext.html#ethernet).

If you use High Sierra and Realtek 8111 Ethernet Card then you should use [older version of kext](https://github.com/Mieze/RTL8111_driver_for_OS_X/releases/tag/v2.2.2).

If you have issues with network card on Monterey or newer try adding `e1000=0` to `boots-args`.

SmallTree kext does not work on Monterey for now. You can try [AppleIGB kext](https://cdn.discordapp.com/attachments/724618275971137568/879288441278435348/AppleIGB.kext.zip), it works on some systems. If it does not work you have to stay on Big Sur and wait for SmallTree's update.

### WiFi and Bluetooth
Only Apple Airport and Fenvi cards work out of the box. [Here](https://dortania.github.io/Wireless-Buyers-Guide/) you can list of all supported cards and needed kexts for them.

Rembember that AirDrop, Handoff, etc. works only on cards with Broadcom chip.

## Installation

### Bootable USB

1. Follow [this guide](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/) to create your bootable USB.

2. Clone this repository and copy "BOOT" & "OC" directories to your "EFI" directory on your bootable USB. The structure should look somewhat like this: `EFI -> BOOT, OC`.

### Modifying kernel patches
3. Modify Core Count patches to match your CPU's cores amount.

  - Find four `algrey - Force cpuid_cores_per_package` patches under `Kernel -> Patch` in your config.
  - Modify these patches for your CPU physical cores. Change **first pair** of `00` in `Replace` of these patches to `Hex value` from below table.

    - e. g. for Ryzen 7 1700 with 8 Cores three modified patches should look like:
      - B8 **00** 0000 0000 -> B8 **08** 0000 0000
      - BA **00** 0000 0000 -> BA **08** 0000 0000
      - BA **00** 0000 0090 -> BA **08** 0000 0090
      - BA **00** 0000 00 -> BA **08** 0000 00

| **Physical CPU cores** | **Hex value** |
| ---------------------- | ------------- |
| 4 Cores                | `04`          |
| 6 Cores                | `06`          |
| 8 Cores                | `08`          |
| 12 Cores               | `0C`          |
| 16 Cores               | `10`          |
| 24 Cores               | `18`          |
| 32 Cores               | `20`          |

### SMBIOS

4. Use [this tool](https://github.com/corpnewt/GenSMBIOS) to generate your unique SMBIOS info.

- SMBIOS has to be unique, you cannot use one present in this repository.

- Run the tool and select `Generate SMBIOS`.
- Select the appropriate model for your hardware using the table below.
- Go to [Apple Coverage](https://checkcoverage.apple.com/) and paste generated _Serial_. You need "Invalid Serial" or "Purchase Date not Validated" message. If you get something another you have to generate SMBIOS data and check it again.
- Open _config.plist_ and search for `PlatformInfo -> Generic` and replace these values:
  - _SystemProductName_ - Model
  - _MLB_ - Board Serial
  - _SystemSerialNumber_ - Serial
  - _SystemUUID_ - SmUUID
- _ROM_ entry should be set to your [network card's MAC address](https://www.wikihow.com/Find-the-MAC-Address-of-Your-Computer), without separators (e. g. `:`, `-`).

| **GPU Series**       | **Model**               |
| -------------------- | ----------------------- |
| AMD Navi Series      | iMacPro1,1 <sup>1</sup> |
| AMD Vega Series      | iMacPro1,1 <sup>1</sup> |
| AMD Polaris Series   | iMacPro1,1 <sup>1</sup> |
| AMD Radeon R5/R7/R9  | MacPro6,1               |
| AMD HD 8000 Series   | MacPro6,1               |
| AMD HD 7000 Series   | MacPro6,1               |
| Nvidia Kepler Series | MacPro7,1 <sup>2</sup>  |

<sup>1</sup> For Catalina and newer you can also use `MacPro7,1` if you have some issues (e. g. unfixable DRMs).

<sup>2</sup> For Catalina and older use `iMac14,2`.

### Configuration

5. You should update your BIOS to the latest version and configure it appropriately. See [BIOS Settings](#BIOS-Settings) for details.
6. Remember to verify your hardware and apply appropriate changes to your configuration file. See [Hardware Compatibility](#Hardware-compatibility) for details.
7. Map your USB ports with [USBToolBox](https://github.com/USBToolBox/tool). Guide about it is available [here](https://github.com/USBToolBox/tool#usage). You have to do it from Windows.
8. That's it! Now you can boot macOS installer.

### Post-Installation

9. Copy your EFI directory onto your main drive EFI partition, you'll be able to boot the system without your bootable USB.
10. Apply [Ryzen patch script](/Resources/ryzen_patch.sh) - it solves MKL (Math Kernel Library) issues and sets correct sleep parameters.
11. If you have `Unknown` instead of your CPU name in About this Mac go to `PlatformInfo -> Generic -> ProcessorType` in your configuration file. Set it to `3841` if your CPU has 8 or more physical cores, else set it to `1537`.
12. When everything work you can disable verbose mode - then you will see Apple's logo instead of logs while booting. To do it you have to remove `-v debug=0x100 keepsyms=1` from `boot-args` in your configuration file.

### Bootstrap
In general, enabling Bootstrap is not required, but it will protect your OpenCore from being overriden. \
Remember to do not enable Bootstrap on pendrive - do it only after copying OpenCore to your disk's EFI.

13. Go to `Misc -> Boot -> LauncherOption` in your configuration file and set it to `Full`.
14. Reboot your computer.
15. Reboot PC again and go to your BIOS settings. In boot options you will see new boot entry named `OpenCore`. Set BIOS to boot from it, instead of your drive.
16. It's done!

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

<sup>1</sup> If you have this option in BIOS you must also remove `npci=0x2000` from `boot-args` in your configuration file.

**Some of these options may not exist in your firmware, just try to match it as closely as possible.**

**Before booting macOS remember to update BIOS to the latest version.**

## PAT Patch

| **Shaneee's**                 | **Algrey's**             |
| ----------------------------- | ------------------------ |
| Much better GPU performance   | Worse GPU performance    |
| May not work with Nvidia GPUs | Compatible with all GPUs |
| HDMI/DP audio may not work    | HDMI/DP audio works      |
| Enabled by default            | Disabled by default      |

To switch to another patch look for `mtrr_update_action` in `config.plist`. Then set `Enabled` to `true` for the patch you want to use. Remember to set `Enabled` to `false` on the other PAT patch. Do not try to enable both at the same time, trust me, it won't work.

## MKL and Intel Fast Memset Patch

Some applications for macOS use MKL - Math Kernel Library. Unfortunately, it does not work on AMD CPUs natively - we need to patch it with [this script](/Resources/ryzen_patch.sh).

There's also `intel_fast_memset` instruction which, obviously, doesn't exist on AMD systems. It's very common in Adobe software - you can simply fix it by running [this script](/Resources/adobe_patch.sh). Older versions of Adobe software (e. g. up to 22.3.1 for Photoshop) need it's [legacy version](/Resources/adobe_patch_legacy.sh). For details about Adobe patching check thead on [macos86.it](https://www.macos86.it/topic/4822-photoshop-after-effects-cc-2021-premiere-pro-cc-2021-154-amd-hackintosh-fix/).

If you have problems while running script from file, try to copy and paste it's code to Terminal.

## DRMs support
DRMs are fixed by default only for Big Sur and newer versions. For older versions you have to:
 1. Remove `unfairgva=1` from `boot-args` in your configuration file.
 2. Go [here](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Chart.md) to find correct value for your system.
 3. Add parameter from _Mode_ to `boot-args` in your configuration file.
    - If parameter from chart does not work try `shikigva=80` or `shikigva=16` - it's common to work even when chart says something another.
 4. Test DRMs with Netflix in Safari or Apple TV+.

## Sleep
Firstly, check if your sleep works out of the box. If it works, you can skip reading this section.

The most common reason of broken sleep on AMD systems are USB problems. \
You have to map your USB ports. If you have working Windows instance I recommend [this tool](https://github.com/usbtoolbox/tool), otherwise you have to [do it manually](https://dortania.github.io/OpenCore-Post-Install/usb/#macos-and-the-15-port-limit). \
After mapping remember to disable `Kernel -> Quriks -> XhciPortLimit` in your configuration file.

If USB fixes does not help, probably something another is broken. You can read more detailed guide about it on [Dortania](https://dortania.github.io/OpenCore-Post-Install/universal/sleep.html).

## Virtualization

### Prerequisites

- Make sure you have `SVM` enabled in your BIOS settings.

| **Software**      | **Compatibility**                                                                                              |
| ----------------- | -------------------------------------------------------------------------------------------------------------- |
| Parallels Desktop | Up to 13.1 unless AppleHV is used.<sup>1</sup> <sup>2</sup> <sup>3</sup>                                       |
| VirtualBox        | Drastically decreased performance.                                                                             |
| VMWare Fusion 10  | Only Catalina and older, for Catalina with [this patch](https://posts.boy.sh/vmware-fusion-catalina).          |
| Docker            | Only [Docker in VirtualBox](https://github.com/sergeycherepanov/homebrew-docker-virtualbox) or Docker Toolbox. |
| Android Emulator  | Only [Android-x86](https://www.android-x86.org/) with compatible VM software.                                  |
| iOS Emulator      | Works out of the box.                                                                                          |

<sup>1</sup> Parallels will not work by default on Big Sur and newer, you need to use `SYSTEM_VERSION_COMPAT=1` environment variable.

<sup>2</sup> Use [this](/Resources/Parallels%20Desktop%20Launcher.app.zip) launcher package to simplify the Parallels usage.

<sup>3</sup> Only Windows 10 Anniversary Update (build 1607) or older systems work.

### Resource management

You shouldn't add too much resources to your virtual machines, as it causes performance issues regardless of your hardware.

Use the following configuration for best results.

- Parallels Desktop 13.1
- 4 CPU cores
- 4GB - 8GB RAM
- 1GB VRAM
- 3D Acceleration: DirectX 9
- OS: Windows 7 (SP1, build 7601) with Aero theme disabled.

## Guides

- Creating USB installer: [\*click\*](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/)
- OpenCore configuration: [\*click\*](https://dortania.github.io/OpenCore-Install-Guide/AMD/zen.html)
- Post-Install: [\*click\*](https://dortania.github.io/OpenCore-Post-Install/)
- Troubleshooting: [\*click\*](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/troubleshooting.html)
- ACPI patching: [\*click\*](https://dortania.github.io/Getting-Started-With-ACPI/)

If you have any other questions or issues, feel free to ask on [AMD-OSX Discord](https://discord.gg/EfCYAJW) or [Forum](https://forum.amd-osx.com).

## Credits

- [Apple](https://apple.com) for macOS
- [AMD-OSX Developers](https://github.com/AMD-OSX) for kernel patches for AMD CPUs
- [Acidanthera](https://github.com/acidanthera) for OpenCore and most of used kexts
- [Trulyspinach](https://github.com/trulyspinach) for Ryzen power management and monitoring kexts
- [Mieze](https://github.com/Mieze) for RealtekRTL8111 kext
- [DhinakG](https://github.com/USBToolBox) for USBToolBox
- [XLNC](https://github.com/naveenkrdy) for Adobe patches for AMD CPUs and AppleMCEReportedDisabler kext
- [Pavo](https://github.com/Pavo-IM) for research about AppleMCEReportedDisabler in Monterey
- [tomnic](https://www.macos86.it/profile/69-tomnic/) for libfakeintel.dylib used by Adobe patches
- [Dortania](https://github.com/dortania) for OpenCore configuration guides
- [AMD-OSX Community](https://amd-osx.com) for support while making my Hackintosh
- [SocketByte](https://github.com/SocketByte) for README maintenance and being a great friend :)

![Screenshot](/screenshot.png?raw=true)
