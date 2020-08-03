# OpenCore EFI for AMD Ryzen Hackintosh

## Specification
| **Component** | **Model** |
| ------------- | --------- |
| CPU | AMD Ryzen 7 1700 @ 3.8GHz |
| Motherboard | ASUS B350 Plus |
| RAM | 16GB (2 x 8GB) Corsair Vengeance @ 3000MHz |
| Audio Chipset | ALC-887 |
| GPU | MSI RX Vega 64 |
| WiFi & Bluetooth | Fenvi T919 (BCM94360CD) |
| OS Disk (NVMe) | Samsung 960 Evo 250GB |

**macOS version**: 11.0 Beta 3 (20A5323l)  
**OpenCore version**: 0.6.0  

## Drivers & Kexts
 - [[Bootloader] OpenCore](https://github.com/acidanthera/OpenCorePkg)
 - [[Resources] Picker GUI](https://github.com/acidanthera/OcBinaryData/tree/master/Resources)
 - [[Patch] AMD_Vanilla](https://github.com/AMD-OSX/AMD_Vanilla)
 - [[Driver] OpenRuntime](https://github.com/acidanthera/OpenCorePkg)
 - [[Driver] OpenCanopy](https://github.com/acidanthera/OpenCorePkg)
 - [[Driver] HFSPlus](https://github.com/acidanthera/OcBinaryData/blob/master/Drivers/HfsPlus.efi)
 - [[Kext] Lilu](https://github.com/acidanthera/Lilu)
 - [[Kext] VirtualSMC](https://github.com/acidanthera/VirtualSMC)
 - [[Kext] WhateverGreen](https://github.com/acidanthera/WhateverGreen)
 - [[Kext] AppleALC](https://github.com/acidanthera/AppleALC)
 - [[Kext] RealtekRTL8111](https://github.com/Mieze/RTL8111_driver_for_OS_X)

## Not working
 - 3.5mm Jack microphone (only microphone with USB works)

## How to use
  1. Create directory "EFI" in your EFI partition (e.g. pendrive or hard drive)
  2. Clone this repo and paste directiories "BOOT" and "OC" onto created directory
  3. Download [**GenSMBIOS**](https://github.com/corpnewt/GenSMBIOS) to generate unique SMBIOS information. Run it and select **Generate SMBIOS**, as model select **iMacPro1,1**.
  4. Open config.plist with [**ProperTree**](https://github.com/corpnewt/ProperTree) and go to PlatformInfo > Generic. Set MLB (Board Serial), SystemSerialNumber (Serial) and SystemUUID (SmUUID) to generated values. Change ROM to your network card's MAC address without `:` character. [**How to get MAC Address?**](https://www.wikihow.com/Find-the-MAC-Address-of-Your-Computer)
  5. Make USB installer with [**this guide**](https://dortania.github.io/OpenCore-Desktop-Guide/installer-guide/)
  6. Boot it!  

**You CAN NOT use SMBIOS from this repository, it MUST be unique for every macOS installation**

## Additional guides
**If you have problems with install/boot macOS, kernel panic or another system related issues check OC configuration guide**  
**If something additional does not work (USB ports, iServices, DRM/Netflix) check Post-Install guide**
 - Creating USB installer: [**\*click\***](https://dortania.github.io/OpenCore-Desktop-Guide/installer-guide/)
 - OpenCore configuration: [**\*click\***](https://dortania.github.io/OpenCore-Desktop-Guide/AMD/zen.html)
 - Post-Install: [**\*click\***](https://dortania.github.io/OpenCore-Desktop-Guide/post-install/)
 - Troubleshooting: [**\*click\***](https://dortania.github.io/OpenCore-Desktop-Guide/troubleshooting/troubleshooting.html)

If you can't solve your problems by yourself, feel free to ask on [**AMD-OSX Discord**](https://discord.gg/EfCYAJW) or [**Forum**](https://forum.amd-osx.com)  

![Screenshot](/screenshot.png?raw=true)
