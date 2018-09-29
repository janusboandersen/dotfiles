set nocompatible

"FILE TYPE DETECTION: Enable filetype detection and filetype-specific plugins
filetype plugin on
filetype on

"COMPATIBILITY: 
set background=dark

"ENCODING: Enable UTF-8 encoding
set encoding=utf-8 "The encoding displayed on-screen
set fileencoding=utf-8 "The encoding written to file

"TRAINING WHEELS:
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

"WRAPPED TEXT: long lines
noremap j gj
noremap k gk
noremap 0 g0
noremap $ g$

"FILE SWITCHING: Enable hidden unsaved buffers, to switch files without saving
set hidden
" 
"PREFIX: Set the leader key
let mapleader=","

"AUTOCOMPLETE: Enable tab autocompletion showing options
set wildmenu "enable showing a menu when trying to autocomplete
set path+=** "enable searching filepath recursively
"set wildmode=list:longest

"GUIDES: Show syntax highlighting and line numbers
syntax on "let VIM overwrite and use standards
"syntax enable "keeps current color settings
"set number "line numbers on each line
set ruler "shows <line, character>-location at the bottom of the window

:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

"SEARCH AND MATCHING: Search settings
set hlsearch "Use highlighted search
set incsearch "Start searching already after typing the first character
nmap <silent> <leader>; :set hlsearch!<CR>

"Extended % matching
runtime macros/matchit.vim

"INDENTATION: Control indentation behaviour
"Toggle visual tabs and EOL
nmap <silent> <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬

"Sane defaults
set bs=2 "A more sane backspace mode
set autoindent "copies the indentation level from previous line
set expandtab "Use spaces instead of tabs
set tabstop=2 "Length of a tab character - but only if tab characters are actually inserted
set softtabstop=2 "Ensures that backspace will delete as much as the others put in
set shiftwidth=2 "How much whitespace to add/remove with indent de-indent in normal mode
"set smarttab "mostly for tabs inside body of text

"Let tab and indent settings vary for different filetypes
if has("autcmd")
    filetype on "ensure detection is on
    
    "These languages have strict requirements
    autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab "require hard tabs for makefiles
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab   "require space indentation for yaml markup
    autocmd FileType C setlocal ts=2 sts=2 sw=2 expandtab  "require soft tabs EDE/ASE standard
    autocmd FileType python setlocal ts=4 sts=4 sw=4 noexpandtab textwidth=80 "PEP 8

    "Customisations based on house-style (arbitrary)
    autocmd BufEnter *.c setlocal ts=8 sts=8 sw=8 expandtab   "require soft tabs EDE/ASE standard
    autocmd FileType cpp setlocal ts=2 sts=2 sw=2 expandtab  "require soft tabs EDE/ASE standard
    autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
    autocmd FileType txt setlocal ts=4 sts=4 sw=4 noexpandtab "make tabs in text files for csv and tsv conversion

endif

"PARENS:
noremap <leader>( vaWxi()<Esc>P
noremap <leader>[ vaWxi[]<Esc>P
noremap <leader>{ vaWxi{}<Esc>P
noremap <leader>< viWxi<Char-0x9><Char-0x3c><Char-0x3e><Esc>P

"JOIN LINES WITH TAB
nmap <silent> <leader>j A<Char-0x9><Esc>J

"SHORTCUTS: Nice shorthands
"Shortscuts for line shifts and improved escaping
nmap <C-j> ddp
nmap <C-k> ddkP
inoremap jj <ESC>
"nmap <CR> O <ESC>

"Shortcuts for editing and sourcing the vimrc
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :source $MYVIMRC<CR>
    
"Shortcuts for switching between open buffers
nnoremap <silent> <C-Left> :bp<CR>
nnoremap <silent> <C-Right> :bn<CR>
nnoremap <silent> <C-Down> :bd<CR>
nnoremap <silent> <C-Up> :ls<CR>



"PLUGINS: Settings and Shortcuts related to using plugins:

" ----- AIRLINE -----
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Choose a theme for airline
let g:airline_theme='luna'
"https://github.com/vim-airline/vim-airline/wiki/Screenshots


" ----- NERDTREE -----
" NerdTree toggle
map <silent> <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" ----- EMMET -----
"Leader key for Emmet
"let g:user_emmet_leader_key='<c-e>'



"PLUGINS: Using Vim-Plug
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Airline for some status bars
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" On-demand loading of NerdTree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Emmet-completions
Plug 'mattn/emmet-vim'

" YouCompleteMe for auto-completion features
" Plug 'Valloric/YouCompleteMe'


" Initialize plugin system
call plug#end()
 
" SETUP VERSION 1

" set nocompatible              " be iMproved, required

" syntax enable
" filetype plugin on

" Enable recursive search in the file tree-
" set path+=**
" set wildmenu

" command! MakeTags !ctags -R .

" call plug#begin()
" Plug 'tpope/vim-sensible'
" call plug#end()


"  Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


" SETUP VERSION 2 FOR PYTHON
" https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/

" set nocompatible              " required
" filetype off                  " required

" set the runtime path to include Vundle and initialize
" set rtp+=~/.vim/bundle/Vundle.vim
" call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
" Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
" Plugin 'tmhedberg/SimpylFold'
" Plugin 'vim-scripts/indentpython.vim'
" Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
" call vundle#end()            " required
" filetype plugin indent on    " required

" au BufNewFile,BufRead *.py
"    \ set tabstop=4
"    \ set softtabstop=4
"    \ set shiftwidth=4
"    \ set textwidth=79
"    \ set expandtab
"    \ set autoindent
"    \ set fileformat=unix

" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" set encoding=utf-8

" SETUP VERSION 3 FROM VIMTUTOR


" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2016 Jul 28
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
"if v:progname =~? "evim"
"  finish
"endif

" Get the defaults that most users want.
"source $VIMRUNTIME/defaults.vim

"if has("vms")
"  set nobackup		" do not keep a backup file, use versions instead
"else
"  set backup		" keep a backup file (restore to previous version)
"  if has('persistent_undo')
"    set undofile	" keep an undo file (undo changes after closing)
"  endif
"endif

"if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
"  set hlsearch
"endif

" Only do this part when compiled with support for autocommands.
"if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
"  augroup vimrcEx
"  au!

  " For all text files set 'textwidth' to 78 characters.
"  autocmd FileType text setlocal textwidth=78

"  augroup END

"else

"  set autoindent		" always set autoindenting on

"endif " has("autocmd")

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
"if has('syntax') && has('eval')
"  packadd matchit
"endif
