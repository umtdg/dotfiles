# ~/.zprofile

# This function API is accessible to scripts in /etc/profile.d
function insert_path() {
    local new_path="$1"
    local prepend="$2"

    case ":$PATH:" in
        *:"$new_path":*) ;;
        *)
            if [ -z "$prepend" ]; then
                PATH="${PATH:+$PATH:}$new_path"
            else
                PATH="$new_path${PATH:+:$PATH}"
            fi
            ;;
    esac
}

distro="$(grep '^ID=.*$' /etc/os-release | cut -d'=' -f2 | xargs)"

# PATH
insert_path "$HOME/bin"
insert_path "$HOME/.local/bin"
insert_path "$HOME/.cargo/bin"
insert_path "$HOME/.yarn/bin"

# ccache needs to be prepended to be prioritized over usual gcc/clang
insert_path "/usr/lib/ccache/bin" 1

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
insert_path "$GOBIN"

# nnn
export NNN_PLUG='c:fzcd;o:fzopen'
export NNN_FIFO='/tmp/nnn.fifo'

BLK="0b" CHR="0b" DIR="0c" EXE="0a" REG="00" HARDLINK="00" SYMLINK="0e" MISSING="00" ORPHAN="09" FIFO="0f" SOCK="0d" OTHER="00"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

# Export PATH at the end to allow modification in multpile places
export PATH

