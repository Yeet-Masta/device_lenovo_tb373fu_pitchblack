#
# OrangeFox build variables for TB373FU.
#
FDEVICE="TB373FU"

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep -w \"$FDEVICE\")
   if [ -n "$chkdev" ]; then
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep -w \"$FDEVICE\")
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
	export FOX_AB_DEVICE=1
	export FOX_VIRTUAL_AB_DEVICE=1
	export FOX_VENDOR_BOOT_RECOVERY=1
	# Repack only our recovery fragment into the known-good LineageOS
	# vendor_boot, keeping its platform fragment (modules, first-stage fstab,
	# touch firmware), dtb and cmdline untouched.
	export FOX_REFERENCE_VENDOR_BOOT_IMAGE="$(pwd)/device/lenovo/TB373FU/prebuilt/vendor_boot-reference.img"
	export FOX_USE_BASH_SHELL=1
	export FOX_USE_NANO_EDITOR=1
	export FOX_USE_TAR_BINARY=1
	export FOX_USE_SED_BINARY=1
	export FOX_USE_XZ_UTILS=1
	export FOX_ENABLE_APP_MANAGER=0
	export FOX_DELETE_AROMAFM=1
	export OF_MAINTAINER="Infinity Builder"
	export FOX_VARIANT="TB373FU"
else
	if [ -z "$FOX_BUILD_DEVICE" -a -z "$BASH_SOURCE" ]; then
		echo "I: This script requires bash. Not processing the $FDEVICE $(basename $0)"
	fi
fi
