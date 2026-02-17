{ config, pkgs, lib, ... }:

let
  sharedPrograms = import ../shared/home-manager.nix { inherit config pkgs lib; };
in
{
  programs = sharedPrograms // {
    alacritty = lib.recursiveUpdate sharedPrograms.alacritty {
      settings = {
        terminal.shell.program = "/usr/bin/zsh";
        font = {
          normal = { family = "Iosevka Nerd Font"; style = "Regular"; };
          italic = { family = "Iosevka Nerd Font"; style = "Italic"; };
          bold = { family = "Iosevka Nerd Font"; style = "Bold"; };
          size = 12;
        };
      };
    };

    git = lib.recursiveUpdate sharedPrograms.git {
      signing = {
        key = "7ACF523C6B63264D!";
        signByDefault = true;
      };
      settings = {
        merge.tool = "vimdiff";
        diff.wsErrorHighlight = "all";
        gpg.program = "gpg";
        tag.forceSignAnnotated = false;
      };
    };

    zsh = lib.recursiveUpdate sharedPrograms.zsh {
      initContent = lib.mkBefore ''
        if [[ -r "$HOME/.cache/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "$HOME/.cache/p10k-instant-prompt-''${(%):-%n}.zsh";
        fi

        if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fi

        export PATH=$HOME/bin:$HOME/.local/bin:$HOME/.local/share/bin:$PATH
        export PATH=$HOME/.cargo/bin:$HOME/.yarn/bin:$PATH
        # ccache needs to be prepended to be prioritized
        export PATH=/usr/lib/ccache/bin:$PATH

        export EDITOR="nvim"

        # SSH Agent (1Password)
        export SSH_AUTH_SOCK=$HOME/.1password/agent.sock

        # Less colors
        export LESS='-iFNR --use-color -Dd+r$Du+b'
        export LESS_TERMCAP_mb=$'\E[1;31m'
        export LESS_TERMCAP_md=$'\E[1;36m'
        export LESS_TERMCAP_me=$'\E[0m'
        export LESS_TERMCAP_so=$'\E[01;33m'
        export LESS_TERMCAP_se=$'\E[0m'
        export LESS_TERMCAP_us=$'\E[1;32m'
        export LESS_TERMCAP_ue=$'\E[0m'

        export MANPAGER="less -R --use-color -Dd+r -Du+b"

        # Go
        export GOPATH="$HOME/.go"
        export GOBIN="$GOPATH/bin"
        export PATH=$GOBIN:$PATH
      '';
    };

    ssh = lib.recursiveUpdate sharedPrograms.ssh {
      matchBlocks = {
        "*" = lib.hm.dag.entryBefore ["github.com" "gitlab.com" "gitlab.archlinux.org" "aur.archlinux.org"] {
          identityAgent = "~/.1password/agent.sock";
        };
      };
    };
  };
}
