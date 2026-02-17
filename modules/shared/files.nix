{ pkgs, config, ... }:

{
  ".config/alacritty/tokyonight_night.toml".source = ./config/alacritty/tokyonight_night.toml;

  ".config/tmux/tokyonight-night.conf".source = ./config/tmux/tokyonight-night.conf;

  ".zsh/functions/incognito".source = ./config/zsh/functions/incognito;
}
