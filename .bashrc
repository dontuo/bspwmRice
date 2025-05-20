#!/bin/sh

if [[ !$DISPLAY && "$(tty)" = "/dev/tty1" ]]; then
    startx
else
    exec fish
fi
