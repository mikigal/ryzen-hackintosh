# AMD Ryzen Hackintosh Build

## Specification
| **Component** | **Model** |
| ------------- | --------- |
| CPU | AMD Ryzen 7 1700 @ 3.8GHz |
| Motherboard | ASUS B350 Plus |
| RAM | 16GB (2 x 8GB) Corsair Vengeance @ 3000MHz |
| Audio Chipset | ALC-887 |
| GPU | MSI RX Vega 64 |
| WiFi & Bluetooth | Broadcom BCM94331CD |
| OS Disk (NVMe) | Samsung 960 Evo 250GB |

**macOS version**: 10.15.3 (19D76)  
**OpenCore version**: 0.5.5  

## Patches & Kexts
 - [[Patch] AMD_Vanilla](https://github.com/AMD-OSX/AMD_Vanilla)
 - [[Kext] VirtualSMC](https://github.com/acidanthera/VirtualSMC)
 - [[Kext] Lilu](https://github.com/acidanthera/Lilu)
 - [[Kext] WhateverGreen](https://github.com/acidanthera/WhateverGreen)
 - [[Kext] AppleALC](https://github.com/acidanthera/AppleALC)
 - [[Kext] BT4LEContinuityFixup](https://github.com/acidanthera/BT4LEContiunityFixup)
 - [[Kext] AirportBrcmFixup](https://github.com/acidanthera/AirportBrcmFixup)
 - [[Kext] HibernationFixup](https://github.com/acidanthera/HibernationFixup)
 - [[Kext] RealtekRTL8111](https://bitbucket.org/RehabMan/os-x-realtek-network/downloads/)
 - [[Kext] NullCPUPowerManagement](https://cdn.discordapp.com/attachments/263757191608139779/643751774666358794/NullCPUPowerManagement.kext.zip)  

## Not working
 - Hypervisor.framework (Parallels Desktop uses it, VMWare Fusion and Xcode iOS emulator works)
 - Microphone

## How to use
  1. Create directory "EFI" in your EFI partition (e.g. pendrive or hard drive)
  2. Paste directiories "BOOT" and "OC" onto created directory
  3. Download [**macserial**](https://github.com/acidanthera/MacInfoPkg/releases) to generate unique SMBIOS information, generate it with command **macserial --model iMac18,3**. Order of generated values: SystemSerialNumber | MLB
  4. Type **uuidgen** in Terminal (for Windows, use [this website](https://www.uuidgenerator.net/)), to generate SystemUUID for your SMBIOS
  5. Use any plist editor (e.g ProperTree), open config.plist and go to PlatformInfo > Generic. Set MLB, SystemSerialNumber and SystemUUID to generated values.
  6. Boot it!

## You CAN NOT use SMBIOS from this repository, it MUST be unique for every macOS installation

![Screenshot](/screenshot.png?raw=true)
