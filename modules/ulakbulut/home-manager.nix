{ pkgs, config, lib, ... }:

let
  user = "ulakbulut";
in
{
  home = {
    username = user;
    homeDirectory = "/home/${user}";

    file = import ./files.nix { inherit user config pkgs; };

    packages = pkgs.callPackage ./packages.nix { };
    stateVersion = "25.11";
  };

  programs = import ./programs.nix { inherit pkgs lib; };
}
