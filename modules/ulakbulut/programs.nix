{ ... }:

let
  name = "Umut Dag";
  email = "umut.dag@ulakhaberlesme.com.tr";
in
{
  alacritty = {
    enable = false;
  };

  git = {
    signing = {
      key = null;
      signByDefault = false;
    };

    settings = {
      user = {
        inherit name email;
      };
    };
  };
}
