#!/bin/bash

# Kill existing polybar instances
pkill polybar

# Wait for them to close
while pgrep -x polybar >/dev/null; do sleep 0.2; done

# Launch bar for each monitor
for MON in $(polybar --list-monitors | cut -d':' -f1); do
    MONITOR=$MON polybar -c ~/.config/polybar/test.ini bspwm &
done
