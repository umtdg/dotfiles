{ pkgs }:

with pkgs; [
  # General Packages
  btop
  # coreutils
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
  docker
  docker-compose
  fzf
  jdk21_headless
  lazygit
  neovim
  nodejs_24
  pnpm
  python3
  rustc
  tree-sitter
  virtualenv
  watchman

  # Terminal
  alacritty
  tmux
  zsh-powerlevel10k
]
