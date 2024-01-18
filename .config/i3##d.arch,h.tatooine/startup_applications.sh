#!/bin/bash

sleep 1

# no-gui apps
i3-msg 'exec /usr/bin/megasync'

i3-msg 'exec /usr/bin/alacritty' && sleep 1
i3-msg 'exec /usr/bin/spotify' && sleep 1
i3-msg 'exec /usr/bin/thunderbird' && sleep 1
i3-msg 'exec /usr/bin/easyeffects' && sleep 1

# launch this last in order for tray icon to appear
sleep 1
i3-msg 'exec /usr/bin/copyq'

