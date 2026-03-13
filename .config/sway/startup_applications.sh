#!/bin/bash

sleep 1

swaymsg 'exec copyq'

swaymsg 'workspace 2; exec alacritty' && sleep 1
swaymsg 'exec spotify-launcher' && sleep 1
swaymsg 'exec thunderbird' && sleep 1
swaymsg 'exec protonmail-bridge' && sleep 1
swaymsg 'exec easyeffects' && sleep 1
