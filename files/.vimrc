set encoding=utf-8

let vim_plug_just_installed = 0
let vim_plug_path = expand('~/.vim/autoload/plug.vim')

if !filereadable(vim_plug_path)
	echo "Installing Vim plug"
	echo ""
	silent !mkdir -p ~/.vim/autoload
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	let vim_plug_just_installed = 1
endif

if vim_plug_just_installed
	:execute 'source '.fnameescape(vim_plug_path)
endif

call plug#begin("~/.vim/plugged")

" Airline and Airline theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git integration
Plug 'tpope/vim-fugitive'

" Git diff icons
Plug 'mhinz/vim-signify'

" Color scheme
Plug 'joshdick/onedark.vim'

" Completion engine
" Needs manula compilation
Plug 'ycm-core/YouCompleteMe', { 'do': 'python ./install.py --all' }

" Fuzzy finder for code and files
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install-all' }
Plug 'junegunn/fzf.vim'

" Surround
Plug 'tpope/vim-surround'

" Show css colors with the real color
Plug 'lilydjwg/colorizer'

" Incremental search
Plug 'haya14busa/incsearch.vim'

" Linter
Plug 'neomake/neomake'

" Syntax checker
Plug 'scrooloose/syntastic'

" Tagbar
Plug 'preservim/tagbar'

" Auto close parentheses etc.
Plug 'tmsvg/pear-tree'

" Live preview of markdown files
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }

" NerdTree files and folders browser
Plug 'preservim/nerdtree'

" Rust support
Plug 'rust-lang/rust.vim'

call plug#end()

if vim_plug_just_installed
	:PlugInstall
endif

" no vi-compatible
set nocompatible

" allow plugins by file type
filetype plugin indent on

" auto indentation
set autoindent

" always show status bar
set ls=2

" incremental search
set incsearch

" highlighted search results
set hlsearch

" syntax highlight
syntax on

set directory=~/.vim/dirs/tmp		" directory to place swap files
set backup				" make backup files
set backupdir=~/.vim/dirs/backups	" backup file directory
set undofile				" persistent undos - undo after re-open file
set undodir=~/.vim/dirs/undos
set viminfo+=n~/.vim/dirs/viminfo

" create needed directories if not exist
if !isdirectory(&backupdir)
	call mkdir(&backupdir, "p")
endif

if !isdirectory(&directory)
	call mkdir(&directory, "p")
endif

if !isdirectory(&undodir)
	call mkdir(&undodir, "p")
endif

" tabs and spaces handling
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" show line numbers
set nu

" remove ugly vertical lines on window division
set fillchars+=vert:\

" use 256
set t_Co=256

" color scheme
if (has("termguicolors"))
	set termguicolors
endif
colorscheme onedark

" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmode=list:longest

" disable autocompletion preview window
set completeopt-=preview

" tab navigation mappings
map tt :tabnew
map <M-Right> :tabn<CR>
imap <M-Right> <ESC>:tabn<CR>
map <M-Left> :tabp<CR>
imap <M-Left> <ESC>:tabp<CR>

" buffer mappings
nmap gn :bnext<CR>
nmap gp :bprevious<CR>
nmap gd :bdelete<CR>

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3

" clear search results
nnoremap <silent> // :noh<CR>

" clear empty spaces at the end of lines on save of python files
autocmd FileType c,cpp,python autocmd BufWritePre <buffer> :%s/\s\+$//e

" fix problems with uncommon shells (fish, xonsh)
set shell=/bin/zsh

" highlight bad whitespace in python files
highlight BadWhitespace ctermbg=red
au FileType python match BadWhitespace /\s\+$/

" set default vertical split to right
set splitright

" relative line numbers
set relativenumber

" YCM
let g:ycm_semantic_triggers = {
            \ 'python': ['re!\w{2}'],
            \ 'c': ['re!\w{2}'],
            \ 'cpp': ['re!\w{2}'],
            \ }

" Airline
let g:airline_powerline_fonts = 0
let g:airline_theme = 'onedark'
let g:airline#extensions#whitespace#enabled = 0

" Signify

" decide in which order try to guess current vcs
let g:signify_vcs_list = ['git', 'hg']

" colors?
highlight DiffAdd           cterm=bold  ctermbg=none    ctermfg=119 
highlight DiffDelete        cterm=bold  ctermbg=none    ctermfg=167
highlight DiffChange        cterm=bold  ctermbg=none    ctermfg=227
highlight SignifySignAdd    cterm=bold  ctermbg=237     ctermfg=119
highlight SignifySignDelete cterm=bold  ctermbg=237     ctermfg=167
highlight SignifySignChange cterm=bold  ctermbg=237     ctermfg=227

" Neomake

" Run on write
call neomake#configure#automake('nrwi', 500)

" Check as python3 by default
let g:neomake_python_python_maker = neomake#makers#ft#python#python()
let g:neomake_python_flake8_maker = neomake#makers#ft#python#flake8()
let g:neomake_python_python_maker.exe = 'python3 -m py_compile'
let g:neomake_python_flake8_maker.exe = 'python3 -m flake'

" Disable error messages inside the buffer
let g:neomake_virtualtext_current_error = 0

" Fzf

" find files
nmap ,e :Files<CR>

" find tags in current file
nmap ,g :BTag<CR>
nmap ,wg :execute ":BTag " . expand('<cword>')<CR>

" find tags in all files
nmap ,G :Tags<CR>
nmap ,wG :execute ":Tags " . expand('<cword>')<CR>

" find in current file
nmap ,f :BLines<CR>
nmap ,wf :execute ":BLines " . expand('<cword>')<CR>

" find in all files
nmap ,F :Lines<CR>
nmap ,wF :execute ":Lines " . expand('<cword>')<CR>

" find commands
nmap ,c :Commands<CR>

" complete with words from any opened file
let g:context_filetype#same_filetypes = {}
let g:context_filetype#same_filetypes._ = '_'

" Pear tree

" Insert closing parentheses instantly
let g:pear_tree_repeatable_expand = 0

" Markdown preview
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_browser = '/usr/bin/firefox'

" Nerd Tree

nnoremap ,n     :NERDTree<CR>
nnoremap ,nt    :NERDTreeToggle<CR>

" Markdown Preview

nmap mdp :MarkdownPreview<CR>
nmap mds :MarkdownPreviewStop<CR>

" Rust

" Format rust on buffer save
autocmd FileType rust autocmd BufWritePre <buffer> :RustFmt

" Syntastic

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

