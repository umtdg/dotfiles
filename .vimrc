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
Plug 'rachaeldawn/sweet-dark.vim'
Plug 'arzg/vim-colors-xcode'

" Completion engine
" Needs manual compilation
" Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Fuzzy finder for code and files
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
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

" FastFold
Plug 'Konfekt/FastFold'

" SimpylFold
Plug 'tmhedberg/SimpylFold'

call plug#end()

if vim_plug_just_installed
	:PlugInstall
endif


" GENERAL SETTINGS

let mapleader = ","

set nocompatible " no vi-compatible
set incsearch
set hlsearch
set number
set relativenumber
set splitright

set fillchars+=vert:\
set scrolloff=3
set shell=zsh
set mouse=a
set ls=2 " always show status bar
set wildmode=list:longest
set completeopt-=preview

" move cursor to its old location when re-opening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" allow plugins by file type
filetype plugin indent on

" indentation, tabs and spaces
set autoindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" clear empty spaces at the end of lines on save
autocmd FileType c,cpp,python,bash,sh autocmd BufWritePre <buffer> :%s/\s\+$//e

" colors
syntax on
set t_Co=256

if (has("termguicolors"))
	set termguicolors
endif

" onedark
" let g:onedark_terminal_italics=1
" let g:airline_theme = 'onedark'
" colorscheme onedark

" xcode
let g:signify_sign_add = '┃'
let g:signify_sign_change = '┃'
let g:signify_sign_delete = '•'

let g:airline_theme = 'xcodedark'

let g:xcodedark_emph_types = 1
let g:xcodedark_emph_funcs = 1
let g:xcodedark_emph_idents = 0

colorscheme xcodedark

" highlights
set cursorline
au ColorScheme * highlight Cursorline cterm=bold
au ColorScheme * highlight BadWhitespace ctermbg=red
au FileType c,cpp,python,bash,sh match BadWhitespace /\s\+$/

" GENERAL SHORTCUTS

" clear search results
nnoremap <silent> // :noh<CR>

" tabs
map tt :tabnew
map <M-Right> :tabn<CR>
imap <M-Right> <ESC>:tabn<CR>
map <M-Left> :tabp<CR>
imap <M-Left> <ESC>:tabp<CR>

" buffers
nmap gn :bnext<CR>
nmap gp :bprevious<CR>
nmap gd :bdelete<CR>

" toggle case of word under cursor
nmap <Leader>u mzg~iw`z


" FOLDS

set foldmethod=syntax

inoremap <Leader>z <C-O>za
nnoremap <Leader>z za
onoremap <Leader>z <C-C>za

inoremap <Leader>Z <C-O>zA
nnoremap <Leader>Z zA
onoremap <Leader>Z <C-C>zA

" Sh, Bash, Zsh
au FileType sh,bash let g:sh_fold_enabled=7
au FileType sh,bash let g:is_bash=1
au FileType zsh let g:zsh_fold_enable=1

" Python
au FileType python setlocal foldmethod=indent

" C-family
au FileType c,cpp setlocal foldmethod=syntax

syntax enable


" DIRECTORIES

set directory=~/.vim/dirs/tmp       " directory to place swap files
set backup				            " make backup files
set backupdir=~/.vim/dirs/backups   " backup file directory
set undofile				        " persistent undos - undo after re-open file
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


" PLUGINS

" YouCompleteMe

" let g:ycm_semantic_triggers = {
"            \ 'python': ['re!\w{2}'],
"            \ 'c': ['re!\w{2}'],
"            \ 'cpp': ['re!\w{2}'],
"            \ 'bash': ['re!\w{2}']
"            \ }


" Airline

let g:airline_powerline_fonts = 0
let g:airline#extensions#whitespace#enabled = 0


" Signify

" vcs order
let g:signify_vcs_list = ['git', 'hg']

" colors
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
nmap <Leader>e :Files<CR>

" find tags in current file
nmap <Leader>g :BTag<CR>
nmap <Leader>wg :execute ":BTag " . expand('<cword>')<CR>

" find tags in all files
nmap <Leader>G :Tags<CR>
nmap <Leader>wG :execute ":Tags " . expand('<cword>')<CR>

" find in current file
nmap <Leader>f :BLines<CR>
nmap <Leader>wf :execute ":BLines " . expand('<cword>')<CR>

" find in all files
nmap <Leader>F :Lines<CR>
nmap <Leader>wF :execute ":Lines " . expand('<cword>')<CR>

" find commands
nmap <Leader>c :Commands<CR>

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

nmap mdp :MarkdownPreview<CR>
nmap mds :MarkdownPreviewStop<CR>


" Nerd Tree
nnoremap <Leader>n     :NERDTree<CR>
nnoremap <Leader>nt    :NERDTreeToggle<CR>

let g:NERDTreeWinPos = 'right'


" Syntastic

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

