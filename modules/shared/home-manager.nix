{ pkgs, lib, ... }:

{
  home.file = import ./files.nix { };

  programs = import ./programs.nix { inherit pkgs lib; };
}
