{ username, homeDirectory }:

{ config, pkgs, lib, ... }:

let
  sharedFiles = import ../../modules/shared/files.nix { inherit config pkgs; };
  archConfig = import ../../modules/arch/home-manager.nix { inherit config pkgs lib; };
in
{
  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";

    # No packages — use pacman/yay on Arch
    packages = [];

    file = sharedFiles;
  };

  programs = archConfig.programs;

  manual.manpages.enable = false;
}
