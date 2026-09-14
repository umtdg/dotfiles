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

      export ANDROID_HOME="$HOME/Library/Android/sdk"
      insert_path "$ANDROID_HOME/emulator"
      insert_path "$ANDROID_HOME/platform-tools"

      export PATH
    '';
  };

  git = {
    settings = {
      gpg = {
        program = "${pkgs.gnupg}/bin/gpg";
      };

      filter = {
        "lfs" = {
          required = true;
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
        };
      };
    };
  };

  ssh = {
    settings = {
      "pve.umtdg.com" = {
        User = "root";
        PasswordAuthentication = true;
        PreferredAuthentications = [ "password" ];
      };
      "k8s.umtdg.com" = {
        User = "ubuntu";
        IdentitiesOnly = true;
        IdentityFile = "~/.ssh/id_proxmox_vm.pub";
      };
      "wg.umtdg.com" = {
        User = "ubuntu";
        IdentitiesOnly = true;
        IdentityFile = "~/.ssh/id_proxmox_vm.pub";
      };
      "tatooine.umtdg.com" = {
        HostName = "10.9.0.2";
        User = "skywalker";
        IdentitiesOnly = true;
        IdentityFile = "~/.ssh/id_home_tatooine.pub";
      };
    };
  };
}
