{ config, pkgs, lib, ... }:

let
  name = "Umut Dag";
  user = "umtdg";
  email = "umu7d9@gmail.com";
in
{
  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;
    history = {
      append = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 10000;
    };

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      l = "ls --color=auto -lh";
      ll = "ls --color=auto -lhA";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      extraConfig = ''
        # Display red dots while waiting for completion
        COMPLETION_WAITING_DOTS="true"
      '';
    };

    initContent = lib.mkBefore ''
      if [[ -r "$HOME/.cache/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "$HOME/.cache/p10k-instant-prompt-''${(%):-%n}.zsh";
      fi

      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Define variables for directories
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Emacs is my editor
      export EDITOR="vim"

      # Always color ls and group directories
      alias ls='ls --color=auto'
    '';
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];

    settings = {
      user = {
        email = email;
        name = name;
      };
      color = {
        ui = true;
        diff = "always";
      };
      init = {
        defaultBranch = "main";
      };
      url = {
        "git@github.com:" = {
          insteadof = "github:";
        };
        "git@gitlab.com:" = {
          insteadof = "gitlab:";
        };

        "git@github.com:umtdg/" = {
          insteadof = "umtdg:";
        };

        "git@gitlab.archlinux.org:archlinux/" = {
          insteadof = "arch:";
        };
        "git@gitlab.archlinux.org:archlinux/packaging/packages/" = {
          insteadof = "archpkg:";
        };
        "ssh://aur@aur.archlinux.org/" = {
          insteadof = "aur:";
        };
      };
    };
  };

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline vim-airline-themes vim-startify vim-tmux-navigator ];
    settings = { ignorecase = true; };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set nocompatible
      set modelines=0
      set encoding=utf-8
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmenu
      set wildmode=list:longest
      set cursorline
      set ttyfast
      set nowrap
      set ruler
      set backspace=indent,eol,start
      set laststatus=2
      set clipboard=autoselect

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set backupdir=~/.config/vim/backups
      set directory=~/.config/vim/swap

      " Relative line numbers for easy movement
      set relativenumber
      set rnu

      "" Whitespace rules
      set tabstop=8
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set incsearch
      set gdefault

      "" Statusbar
      set nocompatible " Disable vi-compatibility
      set laststatus=2 " Always show the statusline
      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" Paste from clipboard
      nnoremap <Leader>, "+gP

      "" Copy from clipboard
      xnoremap <Leader>. "+y

      "" Move cursor by display lines when wrapping
      nnoremap j gj
      nnoremap k gk

      "" Map leader-q to quit out of window
      nnoremap <leader>q :q<cr>

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <tab> :bnext<cr>
      nnoremap <S-tab> :bprev<cr>

      "" Like a boss, sudo AFTER opening the file to write
      cmap w!! w !sudo tee % >/dev/null

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/Projects',
        \ '~/Documents',
        \ ]

      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1
    '';
  };

  alacritty = {
    enable = true;
    settings = {
      general = {
        import = [
          "~/.config/alacritty/tokyonight_night.toml"
        ];
        live_config_reload = true;
      };

      env.TERM = "xterm-256color";

      # Fix for shell path when launching from desktop
      # When launching from desktop, $SHELL may point to /bin/zsh instead of
      # the Nix-managed shell, causing environment issues
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
      };

      font = let
        family = if pkgs.stdenv.hostPlatform.isDarwin then "Iosevka" else "Iosevka Nerd Font";
        size = if pkgs.stdenv.hostPlatform.isDarwin then 14 else 10;
      in {
        normal = {
          inherit family;
          style = "Regular";
        };
        italic = {
          inherit family;
          style = "Italic";
        };
        bold = {
          inherit family;
          style = "Bold";
        };
        inherit size;
      };

      window = {
        dynamic_title = true;
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };

  ssh = {
    enable = true;
    enableDefaultConfig = false;
    # includes = [
    #   (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
    #     "/home/${user}/.ssh/config_external"
    #   )
    #   (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
    #     "/Users/${user}/.ssh/config_external"
    #   )
    # ];
    matchBlocks = {
      "*" = lib.hm.dag.entryBefore ["github.com" "gitlab.com" "gitlab.archlinux.org" "aur.archlinux.org"] {
        identityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      };
      "github.com" = {
        user = "git";
        identitiesOnly = true;
        identityFile = "~/.ssh/id_github.pub";
      };
      "gitlab.com" = {
        user = "git";
        identitiesOnly = true;
        identityFile = "~/.ssh/id_gitlab.pub";
      };
      "gitlab.archlinux.org" = {
        user = "git";
        identitiesOnly = true;
        identityFile = "~/.ssh/id_arch_gitlab.pub";
      };
      "aur.archlinux.org" = {
        user = "git";
        identitiesOnly = true;
        identityFile = "~/.ssh/id_arch_aur.pub";
      };
      # Example SSH configuration for GitHub
      # "github.com" = {
      #   identitiesOnly = true;
      #   identityFile = [
      #     (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
      #       "/home/${user}/.ssh/id_github"
      #     )
      #     (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
      #       "/Users/${user}/.ssh/id_github"
      #     )
      #   ];
      # };
    };
  };

  tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      {
        plugin = resurrect; # Used by tmux-continuum

        # Use XDG data directory
        # https://github.com/tmux-plugins/tmux-resurrect/issues/348
        extraConfig = ''
          set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];

    terminal = "tmux-256color";
    historyLimit = 50000;
    clock24 = true;
    focusEvents = true;
    keyMode = "vi";
    extraConfig = ''
      set -g terminal-features 'xterm-256color:RGB'
      set -g renumber-windows on

      set -g status-right ' #{?client_prefix,#[reverse]Locked#[noreverse] ,}"#{=21:pane_title}" %H:%M %d-%b-%y'

      # -----------------------------------------------------------------------------
      # Key bindings
      # -----------------------------------------------------------------------------

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      source-file ~/.config/tmux/tokyonight-night.conf
    '';
  };
}
