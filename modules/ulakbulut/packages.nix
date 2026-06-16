{ pkgs }:

with pkgs; [
    # General
    fd
    ffmpeg
    gnupg
    jq
    ripgrep
    wget

    # Development
    fzf
    jdk21_headless
    lazygit
    neovim
    nodejs_24
    ollama
    python3
    rustc
    tree-sitter
    uv
    virtualenv

    # Terminal
    tmux
    zsh
    zsh-powerlevel10k
]
