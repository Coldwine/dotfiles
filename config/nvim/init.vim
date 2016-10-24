set shell=/bin/sh

function! s:SourceConfigFilesIn(directory)
  let l:directory_splat = '~/.config/nvim/' . a:directory . '/*.vim'
  for l:config_file in split(glob(l:directory_splat), '\n')
    if filereadable(l:config_file)
      execute 'source' l:config_file
    endif
  endfor
endfunction

function! s:LoadPlugins()
  call plug#begin('~/.config/nvim/plugged')
  source ~/.config/nvim/plugins.vim
  call plug#end()
endfunction

let g:mapleader = "\<space>"
let g:maplocalleader = "\\"

call s:LoadPlugins()
call s:SourceConfigFilesIn('rcbase')
call s:SourceConfigFilesIn('functions')
call s:SourceConfigFilesIn('rcplugins')

runtime macros/matchit.vim
set termguicolors
set background=dark
colorscheme dracula
