#!/system/bin/bash
#ZHELL:AUTO

mkdir -p /data/adb/modules/GIReborn/logs

while [[ -z $(ls /sdcard) ]]; do
  sleep 5
done

sleep 10

start_main() {
    su -c "bash /data/adb/modules/GIReborn/mask_force_all.sh" &
    echo "Started mask_force_all.sh" >> /data/adb/modules/InformationCarrierDevice/logs/service.log
}

start_main &

echo "Script finished successfully" >> /data/adb/modules/GIReborn/logs/service.log