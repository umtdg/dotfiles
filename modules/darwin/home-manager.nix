{ pkgs, ... }:

let
  user = "%USER%";
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
  };

  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }: {
      imports = [ ../shared/home-manager.nix ];

      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = import ./files.nix { inherit user config pkgs; };
        stateVersion = "25.11";
      };

      programs = import ./programs.nix { inherit pkgs lib; };

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
