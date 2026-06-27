#!/bin/bash
DND_STATE=$(swaync-client -D)
if [ "$DND_STATE" = "false" ]; then
    mpv --no-video /usr/share/sounds/freedesktop/stereo/message.oga
fi
