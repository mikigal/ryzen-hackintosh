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

**macOS version**: 10.15.0 (19A583)  
**Clover version**: r5092  
**Clover theme**: Minimal Dark  

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
 - [[Kext] AppleIntelMCEReporter](https://github.com/AMD-OSX/AMD_Vanilla/blob/master/Extra/AppleMCEReporterDisabler.kext.zip)
 - [[Kext] NullCPUPowerManagement](https://www.tonymacx86.com/resources/nullcpupowermanagement.268/)  

## Not working
 - Hypervisor.framework (Parallels Desktop uses it, VMware Fusion and Xcode iOS emulator works)
 - Microphone

## Remember to generate your own Serial Number before use!  

![Screenshot](/screenshot.png?raw=true)
