#!/usr/bin/env bash

# colors
export c_default='\033[0m'
export c_blue='\033[1;34m'
export c_magenta='\033[1;35m'
export c_cyan='\033[1;36m'
export c_green='\033[1;32m'
export c_red='\033[1;31m'
export c_yellow='\033[1;33m'

pfx_debug="${c_green}[DEBUG]${c_default}"
pfx_info="${c_cyan}[INFO] ${c_default}"
pfx_warn="${c_yellow}[WARN] ${c_default}"
pfx_error="${c_red}[ERROR]${c_default}"

# Usage: log [OPTIONS...] [MSG]
# Options:
#   -d  --debug             Only print these when $debug is set to true
#   -e  --error             Print an error message
#   -w  --warn,--warning    Print a warning message
#   -i  --info              Print an informative message
#   -t  --timestamp         Add timestamp to each log
function log() {
    msg_pfx=""
    timestamp=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d | --debug) [[ "$verbose" == true ]] && msg_pfx="$pfx_debug"; shift; ;;
            -e | --error) msg_pfx="$pfx_error"; shift; ;;
            -w | --warn | --warning) msg_pfx="$pfx_warn"; shift; ;;
            -i | --info) msg_pfx="$pfx_info"; shift; ;;
            -t | --timestamp) timestamp="$(date '+%F %T')"; shift; ;;
            *) msg="$1"; shift; ;;
        esac
    done

    if [ -n "$msg_pfx" ]; then
        [[ -n "$timestamp" ]] && msg_pfx="${c_blue}[$timestamp]${c_default} $msg_pfx"
        echo -e "$msg_pfx $msg"
    fi
}

export pacman_opts=(
  -S
  --needed
  --noconfirm
)
