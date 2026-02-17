{ config, pkgs, lib, home-manager, ... }:

let
  user = "umtdg";
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
  sharedPrograms = import ../shared/home-manager.nix { inherit config pkgs lib; };
in
{
  imports = [
   ./dock
  ];

  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};

    masApps = {
      # "wireguard" = 1451685025;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];
        stateVersion = "23.11";
      };

      programs = sharedPrograms // {
        # Darwin-specific: use nix-managed zsh to avoid desktop launch issues
        alacritty = lib.recursiveUpdate sharedPrograms.alacritty {
          settings = {
            terminal.shell.program = "${pkgs.zsh}/bin/zsh";
            font = {
              normal = { family = "Iosevka"; style = "Regular"; };
              italic = { family = "Iosevka"; style = "Italic"; };
              bold = { family = "Iosevka"; style = "Bold"; };
              size = 14;
            };
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

            export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
            export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
            export PATH=$HOME/.local/share/bin:$PATH

            export EDITOR="nvim"

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
          '';
        };

        ssh = lib.recursiveUpdate sharedPrograms.ssh {
          matchBlocks = {
            "*" = lib.hm.dag.entryBefore ["github.com" "gitlab.com" "gitlab.archlinux.org" "aur.archlinux.org"] {
              identityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
            };
          };
        };
      };

      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock = {
    enable = true;
    username = user;
    entries = [
      { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
      { path = "/Applications/Firefox.app"; }
      { path = "/Applications/Spotify.app"; }
      { path = "/Applications/WhatsApp.app"; }
      { path = "/Applications/Signal.app"; }
      { path = "/Applications/1Password.app"; }
      { path = "/Applications/ExpressVPN.app"; }
      { path = "/Applications/Xcode.app"; }
    ];
  };
}
