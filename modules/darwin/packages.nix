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
  obsidian
  openssh
  proton-pass-cli
  ripgrep
  wget

  # Development
  actionlint
  awscli2
  cargo
  ccache
  cmake
  docker
  docker-compose
  fzf
  gh
  jdk21_headless
  lazygit
  ollama
  neovim
  ninja
  nixfmt
  nodejs_24
  pnpm
  postgresql_17
  postgresql17Packages.pgvector
  python3
  rust-analyzer
  rustc
  rustfmt
  tree-sitter
  virtualenv
  watchman
  zed-editor

  # Terminal
  alacritty
  tmux
  zsh-powerlevel10k
]
