let &showbreak='↪ '
let g:loaded_python_provider = 1
set autoindent
set autoread
set autowrite
set backspace=2
set complete=.,w,b,t,kspell
set completeopt+=longest,menuone
set copyindent
set cursorline
set expandtab
set history=500
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set list
set listchars=tab:│\ ,trail:•,extends:❯,precedes:❮
set modelines=2
set mouse=
set nobackup
set noerrorbells
set noshowmode
set noswapfile
set nowrap
set nowritebackup
set nrformats-=octal
set number
set relativenumber
set runtimepath+=~/.fzf
set ruler
set scrolloff=2
set shell=/usr/local/bin/fish
set shiftround
set shiftwidth=2
set showcmd
set showmatch
set smartcase
set splitbelow
set splitright
set tabstop=2
set ttimeout
set ttimeoutlen=10
set undodir=~/.config/nvim/undodir
set undofile
set visualbell
set wildignorecase
set wildmenu
set wildmode=longest:full,full

" Cursor
if exists('$TMUX')
  set clipboard=
  " Different cursor for normal and insert mode
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
else
  set clipboard=unnamed
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
endif
