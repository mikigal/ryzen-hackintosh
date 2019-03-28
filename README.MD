# AMD Ryzen Hackintosh Build

## Specification
| **Component** | **Model** |
| ------------- | --------- |
| CPU | AMD Ryzen 7 1700 @ 3.4GHz |
| Motherboard | ASUS B350 Plus |
| Audio Chipset | ALC-887 |
| GPU | MSI GTX 1080 Gaming X |
| RAM | 16GB (2 x 8GB) Corsair Vengeance @ 3200MHz |
| OS Disk (NVMe) | Samsung 960 Evo 250GB |
| Wifi & Bluetooth | Broadcom BCM94331CD |

**macOS version**: 10.13.6 (17G5019)  
**Clover version**: r4910  
**Clover theme**: MaterialBox

## Patches & Kexts
 - [[Patch] AMD_Vanilla](https://github.com/AMD-OSX/AMD_Vanilla)
 - [[Patch] Native USB](https://github.com/XLNCs/ryzenusbfix/blob/master/ManualGuide.md)
 - [[Kext] Nvidia WebDrivers](https://www.insanelymac.com/forum/topic/324195-nvidia-web-driver-updates-for-macos-high-sierra-update-feb-28-2019/)
 - [[Kext] FakeSMC](https://bitbucket.org/RehabMan/os-x-fakesmc-kozlek/downloads/)
 - [[Kext] Lilu](https://github.com/acidanthera/Lilu)
 - [[Kext] WhateverGreen](https://github.com/acidanthera/WhateverGreen)
 - [[Kext] AppleALC](https://github.com/acidanthera/AppleALC)
 - [[Kext] BT4LEContinuityFixup](https://github.com/acidanthera/BT4LEContiunityFixup)
 - [[Kext] AirportBrcmFixup](https://github.com/acidanthera/AirportBrcmFixup)
 - [[Kext] RealtekRTL8111](https://bitbucket.org/RehabMan/os-x-realtek-network/downloads/)
 - [[Kext] NullCPUPowerManagement](https://www.tonymacx86.com/resources/nullcpupowermanagement.268/)

## Known Issues
 - Power Management
 - Small GPU issues (Kernel patch issue or WebDrivers problem)
