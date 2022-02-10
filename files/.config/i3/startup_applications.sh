#!/bin/bash

sleep 5

i3-msg "workspace 1:work"
sleep 1

/usr/bin/alacritty &

sleep 1

i3-msg "workspace 2:comm"
sleep 1

/usr/bin/signal-desktop &
/usr/bin/whatsapp-nativefier &
/usr/bin/teams &

sleep 1

i3-msg "workspace 4:misc"
sleep 1

/usr/bin/spotify &
/usr/bin/discord &
/usr/bin/easyeffects &

i3-msg "workspace 5:mail"
sleep 1

/usr/bin/thunderbird &
/usr/local/bin/prospect-mail &
/usr/bin/megasync &

