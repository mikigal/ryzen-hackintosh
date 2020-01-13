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

**macOS version**: 10.15.2 (19C57)  
**OpenCore version**: 0.5.3  

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
 - [[Kext] NullCPUPowerManagement](https://www.tonymacx86.com/resources/nullcpupowermanagement.268/)  

## Not working
 - Hypervisor.framework (Parallels Desktop uses it, VirtualBox and Xcode iOS emulator works)
 - Microphone

## Remember to generate your own Serial Number before use!  

## How to use
  1. Create directory "EFI" in your EFI partition (e.g. pendrive or hard drive)
  2. Paste directiories "BOOT" and "OC" into created directory
  3. Boot it!

![Screenshot](/screenshot.png?raw=true)
