nnoremap Q <nop>
nnoremap <leader>so :so $MYVIMRC<cr>
vnoremap <leader>st :sort<cr>
nnoremap <leader>lc :lclose<cr>
nnoremap <leader>sv :tabe $MYVIMRC<cr>
nnoremap <leader>tc :tabclose<cr>
nnoremap <leader>tn :tabe<cr>
nnoremap <leader>to :tabo<cr>
nnoremap <leader>tn :tabnext<cr>
nnoremap <leader>tp :tabprev<cr>
nnoremap <leader>tl :vsplit<cr>:terminal<cr>
nnoremap <leader>w :write<cr>
inoremap jk <esc>
inoremap <esc> <nop>
nnoremap - ddp
nnoremap _ ddkP
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *<c-o>
nnoremap <bs> :set hlsearch! hlsearch?<cr>
nnoremap <leader>bp :bprev<cr>
nnoremap <leader>bn :bnext<cr>
inoremap <left> <nop>
inoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
nnoremap <leader>s <c-w>s
nnoremap <leader>v <c-w>v<c-w>l
nnoremap <leader>vsa :vert sba<cr>
vnoremap < <gv
vnoremap > >gv
nnoremap / /\v
nnoremap :s/ :s/\v
nnoremap ? ?\v
vnoremap / /\v
vnoremap ? ?\v
" Quickstart search
noremap ;; :%s:::g<left><left><left>
noremap ;' :%s:::cg<left><left><left><left>
" Motions
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>
onoremap in{ :<c-u>normal! f{vi{<cr>
onoremap il{ :<c-u>normal! F}vi{<cr>
onoremap in[ :<c-u>normal! f[vi[<cr>
onoremap il] :<c-u>normal! F]vi[<cr>
" Plugins
nnoremap <leader>ff :call Preserve("normal gg=G")<cr>
nnoremap <leader>sw :call StripTrailingWhitespace()<cr>
nnoremap <leader>ft :Autoformat<cr>
nnoremap <silent><c-p> :Files<cr>
nnoremap <leader><enter> :Buffers<cr>
nnoremap <leader>/ :Ag<cr>
nnoremap <leader>b :TagbarToggle<cr>
nnoremap <leader>u :UndotreeToggle<cr>
nnoremap <leader>ga :Git add %:p<cr><cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gc :Gcommit -v -q<cr>
nnoremap <leader>gt :Gcommit -v -q %:p<cr>
nnoremap <leader>gbl :Gblame<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>ge :Gedit<cr>
nnoremap <leader>gr :Gread<cr>
nnoremap <leader>gw :Gwrite<cr><cr>
nnoremap <leader>gl :silent! Glog<cr>:bot copen<cr>
nnoremap <leader>gp :Ggrep<space>
nnoremap <leader>gm :Gmove<space>
nnoremap <leader>gb :Git branch<space>
nnoremap <leader>go :Git checkout<space>
nnoremap <leader>gps :Git push<cr>
nnoremap <leader>gpl :Git pull<cr>
nnoremap <leader>gv :GV<cr>
nnoremap <leader>gvv :GV!<cr>
" Terminal mode
tnoremap jk <c-\><c-n>
tnoremap <c-h> <c-\><c-n><c-w>h
tnoremap <c-j> <c-\><c-n><c-w>j
tnoremap <c-k> <c-\><c-n><c-w>k
tnoremap <c-l> <c-\><c-n><c-w>l
