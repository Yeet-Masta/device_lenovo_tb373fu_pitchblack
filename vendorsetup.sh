# PLATFORM_VERSION is 16 because it must equal the ROM's for KeyMint (see
# BoardConfig.mk). The Android 14 CTS makefile rejects versions missing from
# its lists; add 16 the same way vendor/pb/vendorsetup.sh adds 99.87.36.
for f in cts/tests/tests/os/assets/platform_versions.txt \
         cts/tests/tests/os/assets/platform_releases.txt; do
    [ -f "$f" ] && ! grep -qx 16 "$f" && echo 16 >> "$f"
done
