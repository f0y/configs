" Use Vim settings, rather then Vi settings
set nocompatible
set t_Co=256
" Show invisible characters by default
set list
set listchars=tab:▸\ ,trail:·,extends:#,nbsp:·
" Underline the current line, for quick orientation
set cursorline
" Use multiple of shiftwidth when indenting with '<' and '>'
set shiftround
" don't wrap lines
set nowrap
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" 4 spaces for indenting http://vimcasts.org/episodes/tabs-and-spaces/
set shiftwidth=4
set tabstop=4
set softtabstop=4
" Spaces instead of tabs
set expandtab
" Smart tab Insert tabs on the start of a line according to  shiftwidth, not tabstop
set smarttab
" Auto indenting
set nocopyindent
set noautoindent
" Enable paste mode
set paste

" FIXME: При включенном smartindent добавляются табы вместо пробелов
" Имеет смысл для C  подобных языков
set nosmartindent
set nocindent

" Hides buffers instead of closing them
set hidden
" Show the cursor position all the time
set ruler

set history=1000
set undolevels=1000
if v:version >= 730
    set undofile
    set undodir=~/.vim/.undo
endif
" store swap files in one of these directories
set directory=~/.vim/.tmp
" backup files
set nobackup
set nowritebackup
set noswapfile

" smart search (override 'ic' when pattern has uppers)
set smartcase
" Do incremental searches (annoying but handy);
set incsearch
" Search highlighting off
set hlsearch
set showmatch
" set the search scan to wrap lines
set wrapscan
" Set ignorecase on
set ignorecase

" Show (partial) commands
set showcmd
" show line numbers
set number
" TODO: highlight redundant whitespaces and tabs.

" Minimal number of lines to scroll when the cursor gets off the screen
set scrolljump=4
" Keep 4 lines off the edges of the screen when scrolling
set scrolloff=4
" Set 'g' substitute flag on
set gdefault
" TODO: allow tilde (~) to act as an operator -- ~w, etc.
set notildeop

syntax on
" Set filetype stuff to on
filetype on
filetype indent off
filetype plugin on

" TODO: Add completer on ctrl-space

set wildmenu
set wildmode=list:longest

set textwidth=90
"Колоночка, чтобы показывать плюсики для скрытия блоков кода:
set foldcolumn=2

" TODO: add python and java specific comments

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=2048
" Thanks to Steve Losh for this liberating tip
" See http://stevelosh.com/blog/2010/09/coming-home-to-vim
nnoremap / /\v
vnoremap / /\v

" Movement and key bindings
" Disable up/down/left/right keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" Movement by screen line instead of file line
nnoremap j gj
nnoremap k gk
" Map <jj> to <Esc> in insert mode
inoremap jj <ESC>
" Map <F1> to <Esc> in all modes
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
" Make <;> do the same thing as <:>
nnoremap ; :
" mapleader now at <,> instead of <\>
let mapleader = ","
" Turn off that stupid highlight search
nmap <silent> <leader>n :set invhls<CR>:set hls?<CR>
" C-c and C-v - Copy/Paste in global keyboard
vmap <C-C> "+yi
imap <C-V> <esc>"+gPi
" shift-insert like in Xterm
map <S-Insert> <MiddleMouse>
" Map <c-s> to write current buffer.
map <c-s> :w<cr>
imap <c-s> <c-o><c-s>
imap <c-s> <esc><c-s>
" Select all.
map <c-a> ggVG
" Undo in insert mode.
imap <c-z> <c-o>u
" Highlight all instances of the current word under the cursor
nmap <silent> ^ :setl hls<CR>:let @/="<C-r><C-w>"<CR>
" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nnoremap <leader>w <C-w>v<C-w>l
" Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
" yanked stack (also, in visual mode)
nmap <silent> <leader>d "_d
vmap <silent> <leader>d "_d
nnoremap x "_x
vnoremap x "_x
nnoremap X "_X
vnoremap X "_X
" Quickly close the current window
nnoremap <leader>q :q<CR>
" Close all windows
nnoremap <leader>qa :qa<CR>
" Yank/paste to the OS clipboard with ,y and ,p
" FIXME: copy doesn't work
nmap <leader>y "+y
nmap <leader>Y "+yy
nmap <leader>p "+p
nmap <leader>P  "+P
" Sudo to write
cmap w!! w !sudo tee % >/dev/null
" Strip all trailing whitespace from a file, using ,W
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" Folding on space
nnoremap <space> za
vnoremap <space> zf

" Locale settings
" http://habrahabr.ru/blogs/vim/98393/
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
" Text encoding
set termencoding=utf-8
" Возможные кодировки файлов, если файл не в unicode кодировке
set fileencodings=utf-8,cp1251,koi8-r,cp866
" Меню для выбора кодировки
set wcm=<Tab>
menu Encoding.koi8-r :e ++enc=koi8-r ++ff=unix<CR>
menu Encoding.windows-1251 :e ++enc=cp1251 ++ff=dos<CR>
menu Encoding.cp866 :e ++enc=cp866 ++ff=dos<CR>
menu Encoding.utf-8 :e ++enc=utf8 <CR>
menu Encoding.koi8-u :e ++enc=koi8-u ++ff=unix<CR>
map <F8> :emenu Encoding.<TAB>
" Выбор кодировки, в которой сохранять файл ->
set wcm=<Tab>
menu Encoding.Write.utf-8<Tab><S-F7> :set fenc=utf8 <CR>
menu Encoding.Write.windows-1251<Tab><S-F7> :set fenc=cp1251<CR>
menu Encoding.Write.koi8-r<Tab><S-F7> :set fenc=koi8-r<CR>
menu Encoding.Write.cp866<Tab><S-F7> :set fenc=cp866<CR>
map <S-F8> :emenu Encoding.Write.<TAB>
" Support
" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

set shell=/bin/zsh
" cd to the directory containing the file in the buffer
nmap <silent> <leader>cd :lcd %:h<CR>
" TODO: Inspect what is this
nmap <silent> <leader>md :!mkdir -p %:p:h<CR>

" Ringbell off
set novisualbell
set noerrorbells
set t_vb=

" TODO: Передвинуть левее
set statusline=%<%f%h%m%r%=format=%{&fileformat}\ file=%{&fileencoding}\ enc=%{&encoding}\ %b\ 0x%B\ %l,%c%V\ %P

set laststatus=2
" Select when using the mouse
" set selectmode=mouse
" Mouse support
set mouse=
" set mouse=a
" set mousemodel=popup
" set background color
" set background=dark
"flag problematic whitespace (trailing and spaces before tabs)
"Note you get the same by doing let c_space_errors=1 but
"this rule really applys to everything.
" highlight RedundantSpaces term=standout ctermbg=red guibg=red
" match RedundantSpaces /\s\+$\| \+\ze\t/ "\ze sets end of match so only spaces highlighted

if has("gui_running")
    " set guifont=Bitstream\ Vera\ Sans\ Mono\ 12
    set guifont=Droid\ Sans\ Mono\ 12
    " Remove toolbar, left scrollbar and right scrollbar
    set guioptions-=m
    " set guioptions-=T
    " set guioptions-=l
    " set guioptions-=L
    " Load my color scheme
    " colorscheme molokai
    colorscheme xoria256
    " colorscheme wombat
    highlight SpellBad term=underline gui=undercurl guisp=Orange
    hi RedundantSpaces gui=NONE   guifg=#ffffff   guibg=#6e2e2e
:endif
