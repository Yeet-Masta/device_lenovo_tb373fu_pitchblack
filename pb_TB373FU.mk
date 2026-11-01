#
# SPDX-License-Identifier: Apache-2.0
#
# PitchBlack Recovery for the Lenovo Idea Tab Pro (TB373FU), the ROW variant
# of the Xiaoxin Pad Pro 12.7 (2025, TB375FC). MT6897, GKI 6.1, recovery in
# vendor_boot.

# AOSP base, 64-bit only (the recovery carries no 32-bit userspace)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# PitchBlack common config
$(call inherit-product, vendor/pb/config/common.mk)

# Device-specific
$(call inherit-product, device/lenovo/TB373FU/device.mk)

PRODUCT_DEVICE := TB373FU
PRODUCT_NAME := pb_TB373FU
PRODUCT_BRAND := Lenovo
PRODUCT_MODEL := TB373FU
PRODUCT_MANUFACTURER := Lenovo
