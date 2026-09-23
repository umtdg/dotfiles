{
  user,
  config,
  pkgs,
  ...
}:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome = "${config.users.users.${user}.home}/.local/state";
in
{
  ".config/opencode/.gitignore".source = ./config/opencode/.gitignore;
  ".config/opencode/package-lock.json".source = ./config/opencode/package-lock.json;
  ".config/opencode/opencode.jsonc".source = ./config/opencode/opencode.jsonc;
  ".config/opencode/local.jsonc".source = ./config/opencode/local.jsonc;
  ".config/opencode/command/commit.md".source = ./config/opencode/command/commit.md;
  ".config/opencode/command/learn.md".source = ./config/opencode/command/learn.md;
  ".config/opencode/command/rmslop.md".source = ./config/opencode/command/rmslop.md;
}
