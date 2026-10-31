#
# SPDX-License-Identifier: Apache-2.0
#
# OrangeFox for the Lenovo Idea Tab Pro (TB373FU).
#
# Recovery lives in vendor_boot as the "recovery" ramdisk fragment, next to the
# platform fragment that normal boot needs (first-stage fstab, the 207-module
# load list, touch firmware). Only the recovery fragment comes from this build:
# FOX_REFERENCE_VENDOR_BOOT_IMAGE (vendorsetup.sh) repacks it into a known-good
# LineageOS vendor_boot, so the platform fragment, dtb and cmdline the ROM boots
# with stay byte-identical. Kernel modules are therefore NOT shipped here -
# first-stage init loads them from the platform fragment in recovery too.

DEVICE_PATH := device/lenovo/TB373FU

# Build hacks
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Architecture (recovery is 64-bit only)
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a715

# Platform
TARGET_BOARD_PLATFORM := mt6897
TARGET_BOOTLOADER_BOARD_NAME := mt6897
TARGET_NO_BOOTLOADER := true
BOARD_HAS_MTK_HARDWARE := true

# Kernel: the prebuilt GKI 6.1 from device/lenovo/TB375FC. It ships in boot.img
# with the ROM, never in vendor_boot; it is only here so the build has one.
BOARD_KERNEL_BASE        := 0x40000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_OFFSET      := 0x00000000
BOARD_RAMDISK_OFFSET     := 0x26f00000
BOARD_KERNEL_TAGS_OFFSET := 0x07c80000
BOARD_DTB_OFFSET         := 0x07c80000
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_IMAGE_NAME  := Image.gz
TARGET_PREBUILT_KERNEL   := $(DEVICE_PATH)/prebuilt/Image.gz
TARGET_PREBUILT_DTB      := $(DEVICE_PATH)/prebuilt/dtb.img
BOARD_KERNEL_CMDLINE     := bootopt=64S3,32N2,64N2 firmware_class.path=/vendor/firmware
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION) \
    --kernel_offset  $(BOARD_KERNEL_OFFSET) \
    --ramdisk_offset $(BOARD_RAMDISK_OFFSET) \
    --tags_offset    $(BOARD_KERNEL_TAGS_OFFSET) \
    --dtb_offset     $(BOARD_DTB_OFFSET) \
    --dtb            $(TARGET_PREBUILT_DTB)
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
BOARD_RAMDISK_USE_LZ4 := true

# Recovery in vendor_boot (no recovery partition)
BOARD_USES_RECOVERY_AS_BOOT := false
TARGET_NO_RECOVERY := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true

# Partitions
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_BOOTIMAGE_PARTITION_SIZE        := 67108864
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE  := 8388608
BOARD_DTBOIMG_PARTITION_SIZE          := 8388608
BOARD_SUPER_PARTITION_SIZE   := 9663676416
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_SIZE              := 4827643904
BOARD_MAIN_PARTITION_LIST    := system system_ext system_dlkm vendor vendor_dlkm product odm odm_dlkm
BOARD_USES_METADATA_PARTITION := true
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_COPY_OUT_VENDOR      := vendor
TARGET_COPY_OUT_PRODUCT     := product
TARGET_COPY_OUT_SYSTEM_EXT  := system_ext
TARGET_COPY_OUT_ODM         := odm
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
TARGET_COPY_OUT_ODM_DLKM    := odm_dlkm
TARGET_COPY_OUT_SYSTEM_DLKM := system_dlkm
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE      := erofs
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE  := erofs
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE     := erofs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE      := erofs
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE         := erofs
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODM_DLKMIMAGE_FILE_SYSTEM_TYPE    := erofs
BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs

# AVB
BOARD_AVB_ENABLE := true

# Recovery. Literal path: a lazily expanded $(LOCAL_PATH) here resolves to
# whatever Android.mk was parsed last, silently dropping recovery/root.
TARGET_RECOVERY_DEVICE_DIRS := device/lenovo/TB373FU
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USES_MKE2FS := true
TARGET_OTA_ASSERT_DEVICE := TB373FU,TB375FC

# Keep anti-rollback checks in decryption and OTA metadata happy
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# TWRP
# The panel is natively 2944x1840 landscape, but the tablet's natural
# orientation is portrait (the ROM runs SurfaceFlinger at 270) and the NT36532
# reports touch in that portrait frame. Drawing the portrait UI at 270 lines
# both up, so no RECOVERY_TOUCHSCREEN_* swap/flip is needed.
TW_ROTATION := 270
TW_THEME := portrait_hdpi
TW_FRAMERATE := 60
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := en
TW_USE_TOOLBOX := true
TW_INCLUDE_NTFS_3G := true
TW_INCLUDE_FUSE_EXFAT := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_LPDUMP := true
TW_INCLUDE_LPTOOLS := true
TW_EXCLUDE_APEX := true
TW_NO_HAPTICS := true
TW_USE_LEGACY_BATTERY_SERVICES := true
TW_BATTERY_SYSFS_WAIT_SECONDS := 6
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
TW_BACKUP_EXCLUSIONS := /data/fonts
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true

# Decryption needs the beanpod (MediaTek TEE) keymint/gatekeeper services and
# teei_daemon in recovery; not wired up yet, so /data must be formatted or left
# alone. Sideload, OTG/microSD flashing, image flashing and backups work.
TW_INCLUDE_CRYPTO := false

# OrangeFox
OF_SCREEN_H := 1728
OF_STATUS_H := 80
OF_STATUS_INDENT_LEFT := 48
OF_STATUS_INDENT_RIGHT := 48
OF_ALLOW_DISABLE_NAVBAR := 0
OF_QUICK_BACKUP_LIST := /boot;/vendor_boot;/init_boot;/dtbo;
