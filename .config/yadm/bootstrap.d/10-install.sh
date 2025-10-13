#!/usr/bin/env bash

source common.sh

log -i "Installing required packages"
sed '/^#/d;/^\s*$/d' packages.txt | sudo pacman "${pacman_opts[@]}" -
