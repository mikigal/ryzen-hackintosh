# AMD Ryzen Hackintosh Build

## Specification
| **Component** | **Model** |
| ------------- | --------- |
| CPU | AMD Ryzen 7 1700 @ 3.8GHz |
| Motherboard | ASUS B350 Plus |
| Audio Chipset | ALC-887 |
| GPU | MSI RX Vega 64 |
| RAM | 16GB (2 x 8GB) Corsair Vengeance @ 3200MHz |
| OS Disk (NVMe) | Samsung 960 Evo 250GB |
| Wifi & Bluetooth | Broadcom BCM94331CD |

**macOS version**: 10.14.5 (18F132)  
**Clover version**: r4961  
**Clover theme**: MaterialBox  

## Patches & Kexts
 - [[Patch] AMD_Vanilla](https://github.com/AMD-OSX/AMD_Vanilla)
 - [[Kext] VirtualSMC](https://github.com/acidanthera/VirtualSMC)
 - [[Kext] Lilu](https://github.com/acidanthera/Lilu)
 - [[Kext] WhateverGreen](https://github.com/acidanthera/WhateverGreen)
 - [[Kext] AppleALC](https://github.com/acidanthera/AppleALC)
 - [[Kext] BT4LEContinuityFixup](https://github.com/acidanthera/BT4LEContiunityFixup)
 - [[Kext] AirportBrcmFixup](https://github.com/acidanthera/AirportBrcmFixup)
 - [[Kext] NoVPAJpeg](https://github.com/vulgo/NoVPAJpeg)
 - [[Kext] HibernationFixup](https://github.com/acidanthera/HibernationFixup)
 - [[Kext] RealtekRTL8111](https://bitbucket.org/RehabMan/os-x-realtek-network/downloads/)
 - [[Kext] NullCPUPowerManagement](https://www.tonymacx86.com/resources/nullcpupowermanagement.268/)  

## Not working
 - 32-bit apps (AMD_Vanilla does not support OPEMU, it's not real problem)
 - Hypervisor.framework (Parallels Desktop uses it, you must use VMware Fusion)

![Screenshot](/screenshot.png?raw=true)
