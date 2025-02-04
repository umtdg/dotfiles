# ~/.zprofile

# This function API is accessible to scripts in /etc/profile.d
append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

distro="$(grep '^ID=.*$' /etc/os-release | cut -d'=' -f2 | xargs)"

# PATH
append_path "$HOME/bin"
append_path "$HOME/.local/bin"
append_path "$HOME/.cargo/bin"
append_path "$HOME/.yarn/bin"

# Auxiliary
export EDITOR=nvim
export MANPAGER="less -R --use-color -Dd+r -Du+b"

# ArchLinux specific env variables
if [[ "$distro" == 'arch' ]]; then
    # MEGA directory
    if [[ "$HOST" == 'tatooine' ]]; then
        export MEGANZ="$HOME/localdisk/Documents/mega"
else
    export MEGANZ="$HOME/mega"
    fi

    export COURSES_FILE="$MEGANZ/.courses.json"
    export TODO_FILE="$MEGANZ/todo.json"

    # SSH Agent
    export SSH_AUTH_SOCK=$HOME/.1password/agent.sock
fi

# Less colors
export LESS='-iNRF --use-color -Dd+r$Du+b'
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'

# Go env
export GOPATH="$HOME/.go"
export GOBIN="$GOPATH/bin"
append_path "$GOBIN"

# Export PATH at the end to allow modification in multpile places
export PATH

