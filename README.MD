# OpenCore EFI for AMD Ryzen Hackintosh

## Specification

| **Component**    | **Model**                                  |
| ---------------- | ------------------------------------------ |
| CPU              | AMD Ryzen 7 1700 @ 3.8GHz                  |
| Motherboard      | ASUS B350 Plus                             |
| RAM              | 16GB (2 x 8GB) Corsair Vengeance @ 3000MHz |
| Audio Chipset    | ALC-887                                    |
| GPU              | MSI RX Vega 64                             |
| WiFi & Bluetooth | Fenvi T919 (BCM94360CD)                    |
| OS Disk (NVMe)   | ADATA SX8200 Pro 1TB                       |

**macOS version**: 11.3.1 (20E241) \
**OpenCore version**: 0.6.9

## Table of contents

- [Software Compatibility](#Software-Compatibility)
- [Hardware Compatibility](#Hardware-Compatibility)
- [Installation](#Installation)
- [BIOS Settings](#BIOS-Settings)
- [Sleep Issues](#Sleep-Issues)
- [PAT Patch](#PAT-Patch)
- [Adobe Fix](#Adobe-Fix)
- [Virtualization](#Virtualization)
- [Guides](#Guides)
- [Credits](#Credits)

## Software Compatibility

- Big Sur (11.x)
- Catalina (10.15.x)
- Mojave (10.14.x)
- High Sierra (10.13.x)

## Hardware Compatibility

### Central Processing Unit (CPU)

This EFI is compatible with all Ryzen and Athlon 2xxGE processors with
[**macOS-compatible peripherals**](https://dortania.github.io/Anti-Hackintosh-Buyers-Guide/CPU.html).

_Support for 15h (FX series), 16h (A series) and Threadripper CPUs is not covered here._

### Graphical Processing Unit (GPU)

| **Model**  | **Compatible?**                                                                                                                                       |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Integrated | No                                                                                                                                                    |
| Nvidia     | Partially, under correct [PAT Patch](#PAT-Patch), more details on [Dortania](https://dortania.github.io/GPU-Buyers-Guide/modern-gpus/nvidia-gpu.html) |
| AMD        | Yes                                                                                                                                                   |

For **AMD Navi Series GPUs (RX 5500, RX 5600, RX 5700)** you need to add `agdpmod=pikera` to `boot-args` to fix the black screen issue.

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

| **GPU Series**       | **Model**  |
| -------------------- | ---------- |
| AMD Navi Series      | iMacPro1,1 |
| AMD Polaris Series   | iMacPro1,1 |
| AMD RX Vega Series   | iMacPro1,1 |
| AMD Radeon R5/R7/R9  | MacPro6,1  |
| AMD HD 7000 Series   | MacPro6,1  |
| AMD HD 8000 Series   | MacPro6,1  |
| NVIDIA Kepler Series | iMac14,2   |

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

If an app appears to be not working on your new Hackintosh system, then your best bet would be to apply the [Ryzen patch script](/Resources/ryzen_patch.sh) on it.

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

<sup>1</sup> If you have this option you **MUST** remove `npci=0x2000` from `boot-args` in `config.plist`

**Most of these options may not exist in your firmware, just try to match it as closely as possible. Don't be too concerned if many of these options are not available in your BIOS**

**Before booting macOS remember to update BIOS to latest version**

## Sleep Issues

If you have issues with sleep, firstly you have to map your USB ports. You can read about it [**here**](https://dortania.github.io/OpenCore-Post-Install/usb/). If map does not help, you should try patching USB via SSDT.

In `SSDT-SLEEP.aml` there are patches for \_STA method. Patch as applied to `_SB.PCI0.GPP2.PTXH` and `_SB.PCI0.GP17.XHC0` USB controllers, if you have other addresses of USB controllers you have to edit SSDT for your build. Patch is applied only for macOS, so USB on other systems should work normally.

Sleep in AMD systems is often broken by USB issues, but not always. If USB patching does not help read [**this guide**](https://dortania.github.io/OpenCore-Post-Install/universal/sleep.html) about fixing sleep.

## PAT Patch

| **Shaneee's**                 | **Algrey's**             |
| ----------------------------- | ------------------------ |
| Much better GPU performance   | Worse GPU performance    |
| May not work with NVIDIA GPUs | Compatible with all GPUs |
| HDMI/DP audio may not work    | HDMI/DP audio works      |
| Enabled by default            | Disabled by default      |

To switch to another patch search for `mtrr_update_action` in `config.plist`. Then set `Enabled` to `true` for patch which you want to use. Remember to set `Enabled` to `false` for second PAT patch.

**Don't try to use them both at the same time, it won't work.**

## Adobe Fix

Adobe applications crash on AMD Hackintoshes due to missing intel_fast_memset instructions.
Run [**adobe_patch.sh**](/Resources/adobe_patch.sh) or if you prefer to do it manually follow [**this guide**](https://gist.github.com/mikigal/8e1f804fcd7dbafbded2f236653be7c8) to get it working. Remember to re-run this script after installation of every Adobe app. Remember to run [**ryzen_patch.sh**](/Resources/ryzen_patch.sh) previously!

If Photoshop crashes while opening image from file you have to downgrade it to version 22.0

## Virtualization

Firstly you have to enable `SVM` in your BIOS settings. \
Parallels Desktop (only up to 13.1, newer version require AppleHV) and VirtualBox (it works much worse than Parallels) are only compatible software for virtual machines. There's also VMWare Fusion 10, but it's totally broken on Big Sur, on Catalina it needs [**this workaround**](https://posts.boy.sh/vmware-fusion-catalina) \
Docker also does not work - you have to use Docker Toolbox instead, but it does not have all Docker's features.

On Big Sur (11.0) Parallel's won't start - it will show `Required components are missing from the OS` error due to changed versions number schema. You have to run installer from with `SYSTEM_VERSION_COMPAT=1` parameter. \
Open your Terminal app and run Parallel's installer like this: `SYSTEM_VERSION_COMPAT=1 open /Volumes/Parallels\ Desktop\ 13.1.0/Install.app/`, just replace volume's name to proper for your Parallel's DMG. \
Same problem will exist while trying to start installed Parallels - you can run it every time with the same way as installer or use my launcher (it simply starts Parallels with required parameter) - you can get it [**here**](/Resources/Parallels%20Desktop%20Launcher.app.zip)

Parallels 13.1 support only Windows 10 Anniversary Update (build 1607) and older versions. Newer versions stuck while installing. Also I recommend using Windows 7 - it works much better. Do not use automatical installation feature - it caused some issue for me.

**DO NOT** add too much resources to virtual machines, it causes performance issues independently of host specification. \
I tested lot of VM configurations - the best performance results gives:

- Parallels Desktop 13.1
- 4 CPU cores
- 4GB RAM
- 1GB VRAM
- 3D Acceleration: DirectX 9
- OS: Windows 7 (SP1, build 7601) with disabled Aero theme

With above configuration system is generally responsive, it runs simple games (e. g. The Binding of Isaac: Repentace) smoothly too. All Parallels host-integration features works great.

If guest OS does not see USB device reconnecting it to another port usually solve this issue. \
If [**Coherence Mode**](https://www.parallels.com/blogs/how-to-use-coherence-mode-in-parallels-desktop/) does not work you have to disable guest's antivirus or add these files to it's exclusions list:

- `C:\Program Files (x86)\Parallels\Parallels Tools\Services\coherence.exe`
- `C:\Program Files (x86)\Parallels\Parallels Tools\Services\prl_hook.dll`

## Guides

**If you have any problems with installation or booting your macOS, kernel panics or another system related issue check OC configuration guide**

**If something else does not work properly (for example USB ports, iServices, DRM/Netflix) check Post-Install guide**

- Creating USB installer: [**\*click\***](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/)
- OpenCore configuration: [**\*click\***](https://dortania.github.io/OpenCore-Install-Guide/AMD/zen.html)
- Post-Install: [**\*click\***](https://dortania.github.io/OpenCore-Post-Install/)
- Troubleshooting: [**\*click\***](https://dortania.github.io/OpenCore-Post-Install/)
- ACPI patching: [**\*click\***](https://dortania.github.io/Getting-Started-With-ACPI/)
- USB mapping: [**\*click\***](https://dortania.github.io/OpenCore-Post-Install/usb/)

If you have any other questions or issues, feel free to ask on [**AMD-OSX Discord**](https://discord.gg/EfCYAJW) or [**Forum**](https://forum.amd-osx.com)

## Credits

**Software:**

- [[Bootloader] OpenCore](https://github.com/acidanthera/OpenCorePkg)
- [[Resources] Picker GUI](https://github.com/acidanthera/OcBinaryData/tree/master/Resources)
- [[Patch] AMD_Vanilla](https://github.com/AMD-OSX/AMD_Vanilla)
- [[SSDT] EC-USBX-DESKTOP](https://github.com/dortania/Getting-Started-With-ACPI/blob/master/extra-files/compiled/SSDT-EC-USBX-DESKTOP.aml)
- [[SSDT] SLEEP-PTXH](./OC/ACPI/SSDT-SLEEP-PTXH.aml)
- [[Driver] OpenRuntime](https://github.com/acidanthera/OpenCorePkg)
- [[Driver] OpenCanopy](https://github.com/acidanthera/OpenCorePkg)
- [[Driver] OpenHfsPlus](https://github.com/acidanthera/OpenCorePkg)
- [[Kext] Lilu](https://github.com/acidanthera/Lilu)
- [[Kext] VirtualSMC](https://github.com/acidanthera/VirtualSMC)
- [[Kext] WhateverGreen](https://github.com/acidanthera/WhateverGreen)
- [[Kext] AppleALC](https://github.com/acidanthera/AppleALC)
- [[Kext] RealtekRTL8111](https://github.com/Mieze/RTL8111_driver_for_OS_X)
- [[Kext] AMDRyzenCPUPowerManagement](https://github.com/trulyspinach/SMCAMDProcessor)
- [[Kext] SMCAMDProcessor](https://github.com/trulyspinach/SMCAMDProcessor)
- [[Kext] NVMeFix](https://github.com/acidanthera/NVMeFix)
- [[Kext] RestrictEvents](https://github.com/acidanthera/RestrictEvents)
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
