#!/bin/bash
# enable tap to click for touchpad
tp_id=$(xinput list | grep TouchPad | awk '{print $6}' | cut -d '=' -f 2)
enable_id=$(xinput list-props 18 | grep libinput | head -n 1 | \
    awk '{print $4}' | cut -d '(' -f 2 | cut -d ')' -f 1)
#echo $tp_id, $enable_id
xinput --set-prop $tp_id $enable_id 1
