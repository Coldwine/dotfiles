" Interface
Plug 'edkolev/tmuxline.vim'
Plug 'itchyny/lightline.vim'
Plug 'zhaocai/GoldenView.Vim'
Plug 'ryanoasis/vim-devicons'
Plug 'mhinz/vim-startify'
Plug 'morhetz/gruvbox'
Plug 'shinchu/lightline-gruvbox.vim'

" Editing and Formatting
Plug 'Chiel92/vim-autoformat'
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'carlitux/deoplete-ternjs'
Plug 'Shougo/neco-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'mbbill/undotree'
Plug 'neomake/neomake'
Plug 'jaawerth/neomake-local-eslint-first'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" Syntax
Plug 'Shougo/context_filetype.vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'dag/vim-fish'
Plug 'hail2u/vim-css3-syntax'
Plug 'othree/es.next.syntax.vim'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'othree/yajs.vim'
Plug 'mxw/vim-jsx'
Plug 'tmux-plugins/vim-tmux'

" Navigation
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'justinmk/vim-sneak'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

" Source Control
Plug 'mhinz/vim-signify'
Plug 'gregsexton/gitv'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Miscellaneous
Plug 'wakatime/vim-wakatime'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-dispatch'
