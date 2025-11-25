" Options
let mapleader = ' '

set number
set relativenumber

set mouse=a

set noshowmode

" TODO: Set clipboard to unnamedplus

set breakindent

set undofile

set ignorecase
set smartcase

set signcolumn=yes

set updatetime=250
set timeoutlen=300

set splitright
set splitbelow

set list
set listchars=tab:»\ 
set listchars=trail:·
set listchars=nbsp:␣

set cursorline

set scrolloff=10

set confirm

set sw=4 ts=4 sts=4 et ai

set incsearch
set hlsearch

" tokyonight-night colors
set termguicolors
if empty(glob('~/.vim/colors/tokyonight-night.vim'))
    silent !curl --create-dirs -fLo ~/.vim/colors/tokyonight-night.vim
        \ https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/vim/colors/tokyonight-night.vim
endif

colorscheme tokyonight-night

" Keymaps

nmap <Esc> <cmd>nohlsearch<CR>

nmap <C-h> <C-w><C-h>
nmap <C-j> <C-w><C-j>
nmap <C-k> <C-w><C-k>
nmap <C-l> <C-w><C-l>

" Vim Plug Init - auto install and run :PlugInstall if there are missing plugins

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl --create-dirs -fLo ~/.vim/autoload/plug.vim
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()

Plug 'tpope/vim-surround'

Plug 'tpope/vim-fugitive'

Plug 'scrooloose/syntastic'

Plug 'preservim/nerdtree'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" vim-airline
let g:airline_theme='onedark'

" vim-surround
let g:surround_no_mappings = 0
nmap sd <Plug>Dsurround
nmap sr <Plug>Csurround
nmap sR <Plug>CSurround
nmap sa <Plug>Ysurround
nmap sA <Plug>YSurround
xmap sa <Plug>VSurround
xmap sA <Plug>VgSurround

" vim-fugitive

" vim: sw=4 ts=4 sts=4 et
