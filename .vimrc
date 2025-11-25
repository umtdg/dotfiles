set encoding=utf-8

" Options
let mapleader = " "

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

" Default indentation for new files
set sw=4 ts=4 sts=4 et ai

set incsearch
set hlsearch

" Keymaps

nnoremap <Esc> <cmd>nohlsearch<CR>

nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" vim: sw=4 ts=4 sts=4 et
