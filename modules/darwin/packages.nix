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
  claude-code
  cmake
  fzf
  git-lfs
  jdk21_headless
  lazygit
  neovim
  ninja
  nixfmt
  nodejs_24
  ollama
  pnpm
  python3
  rustup
  tree-sitter
  uv
  watchman
  zig
  zls

  # Terminal
  alacritty
  tmux
  zsh-powerlevel10k
]
