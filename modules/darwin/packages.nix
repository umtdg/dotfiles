{ pkgs }:

with pkgs; [
  # General Packages
  btop
  coreutils
  curl
  dockutil
  fd
  ffmpeg
  gnupg
  iosevka
  jq
  noto-fonts
  noto-fonts-color-emoji
  openssh
  ripgrep
  wget

  # Development
  cargo
  fzf
  lazygit
  neovim
  nodejs_24
  opencode
  python3
  rustc
  virtualenv

  # Terminal
  alacritty
  tmux
  zsh-powerlevel10k
]
