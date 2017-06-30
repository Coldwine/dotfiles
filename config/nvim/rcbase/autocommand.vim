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

function! <SID>goyo_active()
  if exists('#goyo')
    return
  else
    ALELint
  endif
endfunction

augroup fileSave
  autocmd!
augroup END

autocmd fileSave BufWritePost * call <SID>goyo_active()

function! <SID>auto_goyo()
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

autocmd goyo_markdown BufNewFile,BufRead * call <SID>auto_goyo()

augroup goyo_overwrite
  autocmd!
augroup END

function! <SID>goyo_enter()
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd goyo_overwrite QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
endfunction

function! <SID>goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showmode
  set showcmd
  set scrolloff=5
  execute 'Limelight!'
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

augroup initGoyo
  autocmd!
augroup END

autocmd! initGoyo User GoyoEnter nested call <SID>goyo_enter()
autocmd! initGoyo User GoyoLeave nested call <SID>goyo_leave()
