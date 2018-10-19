disable_trackpad() {
    ID=$(xinput --list | grep "SynPS/2 Synaptics TouchPad" | grep -o -P 'id=(\d+)' | sed 's/id=//g')
    xinput set-prop $ID "Device Enabled" 0
}
