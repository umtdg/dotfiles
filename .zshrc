# Enable p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    export ZSH="$HOME/.oh-my-zsh"
else
    export ZSH="/usr/share/oh-my-zsh"
fi

# Use p10k as zsh theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# zsh plugins
plugins=(
    git
    fzf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Source oh-my-zsh and p10k
source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# NVM
source /usr/share/nvm/init-nvm.sh

# Get current distro
distro="$(grep '^ID=.*$' /etc/os-release | cut -d'=' -f2 | xargs)"

# Environment variables
# Set in ~/.profile

# Zsh cache directory
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

# Custom aliases

eval $(thefuck --alias)

# Arch Linux specific
if [[ "$distro" == 'arch' ]]; then
    # pacman/yay
    alias yeet="yay -Qq | fzf --multi --preview 'yay -Qi {1}' | xargs -rot yay -Rns"
    alias pls="yay -Slq | fzf --multi --preview 'yay -Sii {1}' | xargs -rot yay -S"
    alias pkgbysize=$'pacman -Qi | grep -E "^(Name|Installed)" | cut -f2 -d":" | paste -d " " - - | awk \'{ print $2 $3,$1 }\' | sort -rh | less'

    alias cdld='cd ~/localdisk/Documents'
    alias cdm="cd $MEGANZ"

    # OpenVPN aliases
    alias ovpnuc='openvpn3 session-start -c ulak'
    alias ovpnud='openvpn3 session-manage -c ulak --disconnect'
    alias ovpnur='openvpn3 session-manage -c ulak --restart'
    alias ovpnl='openvpn3 sessions-list'

    # VPN aliases
    alias vpn='expressvpn'
    alias vpnl='expressvpn list'
    alias vpnc='expressvpn connect'
    alias vpnd='expressvpn disconnect'
fi

# General aliases
alias df='df -h'
alias du='du -h'
alias vi='vim'
alias emacs='vim'
alias ls='ls --color=auto'
alias l='ls -lh --color=auto'
alias ll='ls -lhA --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias wget='wget -q --show-progress'
alias tmux='tmux -u -2'
alias top='btop'
alias ssh_hosts="grep -iP -A1 '^Host\s+' ~/.ssh/config"
alias osinfo='printf "'"%s %s"'" "$(grep "'"^NAME=.*$"'" /etc/os-release | xargs | cut -d"'"="'" -f2)" "$(uname -rm)"'
alias sysinfo='neofetch --off'
alias ps_by_mem="ps -eo pid,rss,comm= | awk '{proc[\$3]+=\$2} END {for (p in proc) {printf \"%-30s %10.2f MB\\n\", p, proc[p]/1024}}' | sort -k2nr | head -20"

ntfs_uuid='C64618AA46189CED'
btrfs_uuid='434d2f2b-0784-460b-aab2-21c80d454d5f'
alias mountssd500="mountntfs /dev/disk/by-uuid/$ntfs_uuid ~/ssd500/ntfs && mountbtrfs /dev/disk/by-uuid/$btrfs_uuid ~/ssd500/btrfs"
alias umountssd500='sudo umount -l ~/ssd500/btrfs ~/ssd500/ntfs'

# Git aliases
gls_preview='echo {} | cut -f 1 -d " " | xargs git show --color=always'
gls_str="git log --pretty=oneline --abbrev-commit | fzf --ansi --preview '$gls_preview'"
alias gls="$gls_str"

# Yadm aliases
alias ya='yadm add'
alias yd='yadm diff'
alias yfa='yadm fetch --all --tags --prune --jobs=10'
alias ypr='yadm pull --rebase'
alias yst='yadm status'
alias ypsup='yadm push --set-upstream origin main'
alias ypsupf='yadm push --set-upstream origin +main'

# NetworkManager aliases
alias nmc='nmcli c'
alias nml='nmcli c show'
alias nms='nmcli -c yes -f in-use,bssid,ssid,bars,security d wifi l --rescan yes'
alias nmccon='nmcli -a d wifi c'
alias nmcup='nmcli c up'
alias nmcdown='nmcli c down'
alias nmcdel='nmcli c delete'

# K8s aliases
alias k8s='kubectl'
alias mk8s='microk8s.kubectl'

# Docker aliases
alias dockup='sudo systemctl start docker.service'
alias dockdown='sudo systemctl stop docker.socket docker.service'
alias dockyeet='docker system prune -fa'
alias dockbuild='docker build -f ./Dockerfile -t'
alias dockpush='docker push'

# ZSH options
setopt autocd
setopt interactivecomments
setopt magicequalsubst
setopt nonomatch
setopt notify
setopt numericglobsort
setopt promptsubst

WORDCHARS=${WORDCHARS// \/}
PROMPT_EOL_MARK=""
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# Completion options
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _match _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History options
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=20000000
setopt share_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt hist_no_functions

# Plugins

# Auto suggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)

# Speed up pasting with auto suggest
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# Syntax highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[path]=underline
ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[command-substitution]=none
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
ZSH_HIGHLIGHT_STYLES[process-substitution]=none
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[assign]=none
ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
ZSH_HIGHLIGHT_STYLES[named-fd]=none
ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout

