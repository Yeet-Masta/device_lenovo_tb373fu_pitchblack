# OrangeFox device tree for the Lenovo Idea Tab Pro (TB373FU)

OrangeFox R12 (`fox_16.0`) for the TB373FU, the global/ROW variant of the
Xiaoxin Pad Pro 12.7 (2025, TB375FC). MT6897 (Dimensity 8300), GKI 6.1,
Virtual A/B, with recovery in `vendor_boot`.

Boots and runs (touch, portrait UI at `TW_ROTATION := 270`) on a TB373FU
with Project Infinity-X 3.12 (Android 16). ADB sideload, fastbootd, USB OTG,
microSD, image flashing and backups are built in but not yet tested on the
device. Decrypting `/data` is not supported: it needs MediaTek's beanpod TEE
services running in recovery.

## Why it doesn't bootloop

Recovery shares `vendor_boot` with the platform ramdisk that normal boot needs
(first-stage fstab, the 222-module load list, NT36532 touch firmware). This
tree builds only the recovery ramdisk. `FOX_REFERENCE_VENDOR_BOOT_IMAGE`
(`vendorsetup.sh`) repacks it into a known-good ROM `vendor_boot`, so the
platform ramdisk, dtb and cmdline stay byte-identical to the ROM's.

`prebuilt/vendor_boot-reference.img` is LosSantosPro's LineageOS 23.2
(20260609) `vendor_boot`. To match a different ROM, repack the recovery
ramdisk into that ROM's own `vendor_boot` (see below).

## Building

Sync the [OrangeFox `fox_16.0` manifest](https://gitlab.com/OrangeFox/Manifest),
then clone this repo to `device/lenovo/TB373FU`. Two local-manifest overrides
are needed:

```xml
<!-- OrangeFox's GitLab copies are private; use AOSP's -->
<remove-project name="external/libvpx" />
<remove-project name="external/libwebm" />
<project path="external/libvpx" name="platform/external/libvpx" remote="aosp" revision="refs/tags/android-16.0.0_r1" />
<project path="external/libwebm" name="platform/external/libwebm" remote="aosp" revision="refs/tags/android-16.0.0_r1" />
<!-- foxcli master needs RPC v2 (libfox_protocol_types); fox_16.0 speaks v1 -->
<extend-project name="external/foxcli" revision="288f5579550ebd0d5e6325c1844a65bd3fb42d8c" />
```

```
export FOX_BUILD_DEVICE=TB373FU ALLOW_MISSING_DEPENDENCIES=true LC_ALL=C
source build/envsetup.sh
lunch twrp_TB373FU-bp2a-eng
m adbd vendorbootimage
```

Output: `out/target/product/TB373FU/OrangeFox-R12.0_TB373FU-Unofficial-TB373FU.img`.

### Matching another ROM's vendor_boot

The built image carries the reference image's platform ramdisk. To use the
platform ramdisk of the ROM you're actually running, swap the recovery
ramdisk into that ROM's `vendor_boot.img` with OrangeFox's magiskboot:

```
MB=vendor/recovery/tools/magiskboot
mkdir fox rom
(cd fox && $MB unpack -n ../OrangeFox-R12.0_TB373FU-Unofficial-TB373FU.img)
(cd rom && $MB unpack -n ../vendor_boot.img)
cp fox/vendor_ramdisk/recovery.cpio rom/vendor_ramdisk/recovery.cpio
(cd rom && $MB repack ../vendor_boot.img ../OrangeFox-for-this-rom.img)
```

## Flashing

Flash it on the slot the ROM is booted from, after the ROM has booted once:

```
adb reboot bootloader
fastboot flash vendor_boot OrangeFox-R12.0_TB373FU-Unofficial-TB373FU.img
fastboot reboot recovery
```

To undo it, flash the ROM's own `vendor_boot.img`. Installing a ROM update
also replaces `vendor_boot`, so re-flash OrangeFox afterwards.
