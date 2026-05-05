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
  neovim
  ninja
  nodejs_24
  pnpm
  python3
  rust-analyzer
  rustc
  rustfmt
  tree-sitter
  virtualenv
  watchman

  # Terminal
  alacritty
  tmux
  zsh-powerlevel10k
]
