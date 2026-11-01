#!/system/bin/sh
# Wait (at most ~15 s) for the beanpod TEE and KeyMint before the recovery UI
# starts, then note the outcome in the kernel log.
i=0
while [ $i -lt 30 ]; do
    if [ "$(getprop vendor.soter.teei.init)" = "INIT_OK" ] &&
       [ "$(getprop init.svc.vendor.keymint-beanpod)" = "running" ]; then
        break
    fi
    sleep 0.5
    i=$((i + 1))
done
# Let KeyMint finish registering with servicemanager.
sleep 1
echo "tb373fu_wait_tee: teei=$(getprop vendor.soter.teei.init)" \
     "keymint=$(getprop init.svc.vendor.keymint-beanpod)" \
     "gatekeeper=$(getprop init.svc.vendor.gatekeeper-beanpod) after $i polls" > /dev/kmsg
exit 0
