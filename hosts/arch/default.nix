{ username, homeDirectory }:

{ config, pkgs, lib, ... }:

{
  imports = [ ../../modules/arch/home-manager.nix ];

  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";

    # No packages — use pacman/yay on Arch
    packages = [];
  };

  manual.manpages.enable = false;
}
