{ config, pkgs, lib, home-manager, ... }:

let
  user = "umtdg";
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
      imports = [ ../shared/home-manager.nix ];

      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = import ./files.nix { inherit user config pkgs; };
        stateVersion = "23.11";
      };

      # Darwin-specific: use nix-managed zsh to avoid desktop launch issues
      programs.alacritty = {
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

      programs.zsh = {
        envExtra = lib.mkAfter ''
          insert_path "$HOME/.pnpm-packages" 1
          insert_path "$HOME/.pnpm-packages/bin" 1
          insert_path "$HOME/.npm-packages/bin" 1

          export PATH
        '';
      };

      programs.ssh = {
        matchBlocks = {
          "*" = {
            identityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
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
