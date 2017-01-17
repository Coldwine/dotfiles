augroup fileType
  autocmd!
augroup END

autocmd fileType BufNewFile,BufReadPost *.md set filetype=markdown
autocmd fileType BufNewFile,BufReadPost *stylelintrc set filetype=json
autocmd fileType BufNewFile,BufReadPost inspircd.conf set filetype=xml
autocmd fileType BufNewFile,BufReadPost *ctags set filetype=config
autocmd fileType BufNewFile,BufReadPost *thymerc set filetype=ruby
autocmd fileType BufNewFile,BufReadPost mail set tabwidth=76
autocmd fileType FileType help nnoremap <buffer> q :q<cr>
autocmd fileType FileType javascript :iabbrev <buffer> iff if()<left>
autocmd fileType BufReadCmd set nohlsearch

augroup highlightGroups
  autocmd!
augroup END

function! s:goyo_active()
  if exists('#goyo')
    return
  else
    Neomake
  endif
endfunction

augroup fileSave
  autocmd!
augroup END

autocmd fileSave BufWritePost * call s:goyo_active()

function! s:auto_goyo()
  if &filetype ==# 'markdown'
    Goyo
  elseif exists('#goyo')
    let l:bufnr = bufnr('%')
    Goyo
    execute 'b '.l:bufnr
  endif
endfunction

augroup goyo_markdown
  autocmd!
augroup END

autocmd goyo_markdown BufNewFile,BufRead * call s:auto_goyo()

function! s:goyo_enter()
  if has('gui_running')
    set fullscreen
    set background=light
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
endfunction

function! s:goyo_leave()
  if has('gui_running')
    set nofullscreen
    set background=dark
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
endfunction

augroup initGoyo
  autocmd!
augroup END

autocmd initGoyo User GoyoEnter nested call <SID>goyo_enter()
autocmd initGoyo User GoyoLeave nested call <SID>goyo_leave()
autocmd initGoyo User GoyoEnter Limelight
autocmd initGoyo User GoyoLeave Limelight!
