#!/run/current-system/sw/bin/bash
swaymsg "exec firefox"
sleep 2s
swaymsg 'exec emacsclient -c'
sleep 1s
swaymsg "splitv"
swaymsg 'exec foot'
