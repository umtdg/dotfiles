{ lib, ... }:

let
  name = "Umut Dag";
  email = "umut.dag@ulakhaberlesme.com.tr";
in
{
  alacritty.enable = lib.mkForce false;

  git = {
    signing = lib.mkForce {
      key = null;
      signByDefault = false;
    };

    settings = lib.mkForce {
      user = {
        inherit name email;
      };
    };
  };

  home-manager.enable = true;
}
