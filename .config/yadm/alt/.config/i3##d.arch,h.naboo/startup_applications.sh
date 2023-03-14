#!/bin/bash

sleep 1

# no-gui apps
i3-msg 'exec /usr/bin/copyq'
i3-msg 'exec /usr/bin/megasync'

i3-msg 'workspace 1:work; exec /usr/bin/alacritty' && sleep 1
i3-msg 'exec /usr/bin/spotify' && sleep 1
i3-msg 'exec /usr/bin/thunderbird' && sleep 1
i3-msg 'exec /usr/bin/easyeffects' && sleep 1

