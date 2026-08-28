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
  clang-tools
  cmake
  fzf
  gh
  git-lfs
  google-cloud-sdk
  jdk21_headless
  lazygit
  neovim
  ninja
  nixfmt
  nodejs_24
  opencode
  pnpm
  python3
  qemu
  rustup
  tree-sitter
  uv
  watchman
  xorriso
  zig
  zls

  # Terminal
  alacritty
  tmux
  zsh-powerlevel10k
]
