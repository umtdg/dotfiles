#!/usr/bin/env bash

source common.sh

log -i "Installing required packages"
sudo pacman "${pacman_opts[@]}" - < (sed -e '/^#/d;/^\s*$/d' packages.txt)
