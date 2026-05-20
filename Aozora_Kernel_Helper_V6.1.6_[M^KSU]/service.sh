#!/system/bin/sh

if [ -f "/proc/sys/kernel/sched_lib_name" ]; then
    echo "UnityMain,libunity.so" > /proc/sys/kernel/sched_lib_name
    echo 255 > /proc/sys/kernel/sched_lib_mask_force
fi

until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 5
done

sleep 2

first_tune
