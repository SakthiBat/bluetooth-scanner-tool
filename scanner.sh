#!/bin/bash

SCAN_FILE="scan_results.txt"
KNOWN_FILE="known_devices.txt"
LOG_FILE="logs/scan.log"

mkdir -p logs

bluetooth_on() {
    echo "[*] Turning Bluetooth ON..."
    sudo systemctl start bluetooth.service
    sudo hciconfig hci0 up
    bluetoothctl power on

}
bluetooth_off() {
    echo "[*] Turning Bluetooth OFF..."
    bluetoothctl power off
}


scan_devices() {
    echo "[*] Scanning nearby Bluetooth devices (10 seconds)..."
    
    bluetoothctl --timeout 10 scan on >/dev/null 2>&1
    
    bluetoothctl devices | tee "$SCAN_FILE"
    echo "$(date) - Scan completed" >> "$LOG_FILE"
}


connected_devices() {
    echo "[*] Connected Devices:"
    bluetoothctl info | grep "Device" || echo "No connected devices"
}

unknown_devices() {
    echo "[*] Unknown Devices:"
    grep -vf $KNOWN_FILE $SCAN_FILE || echo "No unknown devices found"
}

while true; do
    echo "==============================="
    echo "  BLUETOOTH SECURITY SCANNER"
    echo "==============================="
    echo "1. Turn Bluetooth ON"
    echo "2. Turn Bluetooth OFF"
    echo "3. Scan Nearby Devices"
    echo "4. Show Connected Devices"
    echo "5. Show Unknown Devices"
    echo "6. View Scan Logs"
    echo "7. Exit"
    echo "==============================="
    read -p "Enter your choice: " ch

    case $ch in
        1) bluetooth_on ;;
        2) bluetooth_off ;;
        3) scan_devices ;;
        4) connected_devices ;;
        5) unknown_devices ;;
        6) cat $LOG_FILE ;;
        7) exit ;;
        *) echo "Invalid option" ;;
    esac
done
