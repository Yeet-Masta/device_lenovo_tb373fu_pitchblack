# PitchBlack Recovery device tree for the Lenovo Idea Tab Pro (TB373FU)

PitchBlack Recovery (PBRP, `android-14.0`, TWRP-based) for the TB373FU, the
global/ROW variant of the Xiaoxin Pad Pro 12.7 (2025, TB375FC). MT6897
(Dimensity 8300), GKI 6.1, Virtual A/B, recovery in `vendor_boot`.

Tested on a TB373FU running Project Infinity-X 3.12 (Android 16, 01.11.2026):
boots, touch works, and **`/data` decrypts with the lock-screen PIN** (FBE v2
with metadata encryption, keys in the beanpod/microtrust TEE). ADB sideload,
backups and MTP are built in but not yet tested on the device.

## How it fits on the device

Recovery shares `vendor_boot` with the platform ramdisk that normal boot needs
(first-stage fstab, the 222-module load list, NT36532 touch firmware). Only
this build's recovery ramdisk is used: it is repacked into the ROM's own
`vendor_boot.img`, so the platform ramdisk, dtb and cmdline stay byte-identical
to what the ROM boots with. Kernel modules are not shipped here; first-stage
init loads them from the platform ramdisk in recovery too, including the TEE
driver (`isee-ffa.ko`) and RPMB drivers decryption needs.

## Decryption

`recovery/root` carries the stock beanpod TEE pieces from the vendor
partition: `teei_daemon`, KeyMint 3.0, Gatekeeper, their 17 vendor libraries,
17 trusted apps and VINTF fragments. `init.recovery.microtrust.rc` starts them
on `fs`, and `tb373fu_wait_tee.sh` holds the UI (at most ~15 s) until KeyMint
is up. Other pieces recovery needed to make keystore2 and vold work:

* base `manifest.xml` files on both sides (libvintf ignores the fragment
  folders without them), device-type fragments kept out of `/system`, and
  the HIDL `IServiceManager` declared (keystore2 aborts without it);
* `/etc/cgroups.json` and `/etc/task_profiles.json` (this recovery's `/etc`
  is not a symlink to `/system/etc`; without them logd and init's task
  profiles fail);
* the boot HAL running in the permissive `recovery` domain (as
  `hal_bootctl_default` it cannot open `misc`, never registers, and vold's
  metadata mount waits for it forever).

**Patch levels must match the ROM.** `PLATFORM_VERSION`,
`PLATFORM_SECURITY_PATCH` and `VENDOR_SECURITY_PATCH` in `BoardConfig.mk` are
the installed ROM's (16, 2026-09-01, 2024-10-05). KeyMint binds keys to these;
a recovery reporting a newer level could upgrade keys past what the ROM
accepts. An older level only makes decryption fail. Update them whenever the
ROM's security patch changes, and rebuild.

## Building

```
repo init --depth=1 -u https://github.com/PitchBlackRecoveryProject/manifest_pb -b android-14.0
git clone https://github.com/Yeet-Masta/device_lenovo_tb373fu_pitchblack device/lenovo/TB373FU
mkdir -p .repo/local_manifests
cp device/lenovo/TB373FU/source-patches/local_manifests/tb373fu.xml .repo/local_manifests/
repo sync -c -j8 --force-sync --no-clone-bundle --no-tags
```

Then apply the vold patch (makes vold wait at most 20 s for keystore2 instead
of forever, so a broken TEE leaves `/data` encrypted rather than freezing the
splash screen):

```
git -C system/vold am ../../device/lenovo/TB373FU/source-patches/system_vold/*.patch
```

`tb373fu.xml` restores `external/gflags` (needed by snapuserd), which PBRP's
minimal manifest removes. `vendorsetup.sh` adds version 16 to the CTS version
lists, which the Android 14 build otherwise rejects.

```
export ALLOW_MISSING_DEPENDENCIES=true LC_ALL=C
source build/envsetup.sh
lunch pb_TB373FU-eng
m adbd vendorbootimage
```

## Repacking into the ROM's vendor_boot

Use the `vendor_boot.img` of the ROM you are running (from its OTA, or a
backup) and magiskboot:

```
mkdir pb rom
(cd pb  && magiskboot unpack -n ../out/target/product/TB373FU/vendor_boot.img)
(cd rom && magiskboot unpack -n ../vendor_boot.img)
cp pb/vendor_ramdisk/recovery.cpio rom/vendor_ramdisk/recovery.cpio
(cd rom && magiskboot repack ../vendor_boot.img ../PitchBlack-TB373FU.img)
```

## Flashing

On the slot the ROM is booted from:

```
adb reboot bootloader
fastboot flash vendor_boot PitchBlack-TB373FU.img
fastboot reboot recovery
```

To undo it, flash the ROM's own `vendor_boot.img`. Installing a ROM update
also replaces `vendor_boot`, so re-flash PitchBlack afterwards.

## Logs

```
adb pull /tmp/recovery.log
adb pull /tmp/tb373fu_tee.log
adb shell dmesg > dmesg.txt
adb logcat -d > logcat.txt
```

`tb373fu_tee.log` shows whether the TEE (`vendor.soter.teei.init=INIT_OK`),
KeyMint and Gatekeeper came up.
