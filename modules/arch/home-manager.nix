{ config, pkgs, lib, ... }:

{
  imports = [ ../shared/home-manager.nix ];

  programs.alacritty = {
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

  programs.zsh = {
    envExtra = lib.mkAfter ''
      insert_path $HOME/bin 1
      insert_path $HOME/.local/bin 1
      insert_path $HOME/.cargo/bin 1
      insert_path $HOME/.yarn/bin 1
      insert_path /usr/lib/ccache/bin 1

      export PATH

      export SSH_AUTH_SOCK=$HOME/.1password/agent.sock
    '';
  };


  programs.ssh = {
    matchBlocks = {
      "*" = {
        identityAgent = "~/.1password/agent.sock";
      };
    };
  };
}
