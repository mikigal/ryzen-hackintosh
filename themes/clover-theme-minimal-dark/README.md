# minimal-dark clover theme
Dark version of minimal theme for [the Clover UEFI bootloader](http://sourceforge.net/projects/cloverefiboot), based off [clover-theme-minimal by Alex James](https://github.com/al3xtjames/clover-theme-minimal).

![Screenshot of the theme](https://i.imgur.com/noHmZ1o.png)

### Installation
Clone or download the ZIP of this repo to your Clover theme directory (in /EFI/CLOVER/themes, located on the EFI system partition).
Then, edit your Clover config.plist to select the theme.

By default, labels and badges for the boot entries are hidden. If you would like to enable them, you can edit the theme.plist file in this repo by changing the `Label` key to `true` and `Badges`/`Show` key to `true`.

### Credits

- [Evan Purkhiser - original theme](https://github.com/EvanPurkhiser/rEFInd-minimal), which uses [OS icons from SWOriginal](https://www.deviantart.com/sworiginal/art/Lightness-for-burg-181461810). 
- Ukr55 - cursor icon, font image, some of the tool icons.
- [Alex James - clover-minimal-theme](https://github.com/al3xtjames/clover-theme-minimal)
