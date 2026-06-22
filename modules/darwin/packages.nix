{ pkgs }:

with pkgs;
[
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
  proton-pass-cli
  ripgrep
  wget

  # Development
  ccache
  cmake
  docker
  docker-compose
  fzf
  git-lfs
  jdk21_headless
  lazygit
  ollama
  neovim
  ninja
  nixfmt
  nodejs_24
  pnpm
  python3
  rustup
  tree-sitter
  watchman
  zig
  zls

  # Terminal
  alacritty
  tmux
  zsh-powerlevel10k
]
