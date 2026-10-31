#
# SPDX-License-Identifier: Apache-2.0
#
# OrangeFox for the Lenovo Idea Tab Pro (TB373FU), the ROW variant of the
# Xiaoxin Pad Pro 12.7 (2025). MT6897, GKI 6.1, recovery in vendor_boot.

# Inherit from our custom product configuration (base.mk + 64-bit only)
$(call inherit-product, vendor/twrp/config/common.mk)

# Device-specific
$(call inherit-product, device/lenovo/TB373FU/device.mk)

PRODUCT_DEVICE := TB373FU
PRODUCT_NAME := twrp_TB373FU
PRODUCT_BRAND := Lenovo
PRODUCT_MODEL := TB373FU
PRODUCT_MANUFACTURER := Lenovo
