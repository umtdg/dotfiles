{ pkgs, lib, ... }:

{
  # Darwin-specific: use nix-managed zsh to avoid desktop launch issues
  alacritty = {
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

  zsh = {
    envExtra = lib.mkAfter ''
      insert_path "$HOME/.pnpm-packages" 1
      insert_path "$HOME/.pnpm-packages/bin" 1
      insert_path "$HOME/.npm-packages/bin" 1

      export PATH
    '';
  };

  ssh = {
    matchBlocks = {
      "*" = {
        identityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      };
    };
  };
}
