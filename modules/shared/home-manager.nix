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
      save = 100000;
      size = 1000;
      append = true;
      share = true;
      extended = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      l = "ls --color=auto -lh";
      ll = "ls --color=auto -lhA";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
      ip = "ip -c";
      wget = "wget -q --show-progress";
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

      export EDITOR="nvim"
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
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-startify
      vim-surround
      vim-fugitive
      syntastic
      nerdtree
    ];
    settings = { ignorecase = true; };
    extraConfig = ''
      "" General
      set number
      set relativenumber

      set mouse=a

      set noshowmode

      set shiftwidth=4
      set tabstop=4
      set softtabstop=4
      set expandtab
      set breakindent
      set autoindent

      set ignorecase
      set smartcase

      set signcolumn=yes

      set updatetime=250
      set timeoutlen=300

      set splitright
      set splitbelow

      set list
      set listchars=tab::»\
      set listchars=trail:·
      set listchars=nbsp:␣

      set cursorline

      set scrolloff=3

      set confirm

      set incsearch
      set hlsearch

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set undofile
      set backupdir=~/.config/vim/backups
      set directory=~/.config/vim/swap

      let mapleader=" "

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" tokyonight-night colors
      if
        silent !curl --create-dirs -fLo ~/.vim/colors/tokyonight-night.vim
          \ https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/vim/colors/tokyonight-night.vim
      endif

      set termguicolors
      colorscheme tokyonight-night

      "" Keymaps

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <leader>bn :bnext<cr>
      nnoremap <leader>bp :bprev<cr>

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/Projects',
        \ '~/Documents',
        \ ]

      let g:airline_theme='onedark'
      let g:airline_powerline_fonts = 1

      let g:surround_no_mappings = 0
      nmap sd <Plug>Dsurround
      nmap sr <Plug>Csurround
      nmap sR <Plug>CSurround
      nmap sa <Plug>Ysurround
      nmap sA <Plug>YSurround
      xmap sa <Plug>VSurround
      xmap sA <Plug>VgSurround
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
