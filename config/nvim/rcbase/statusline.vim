scriptencoding utf-8

set laststatus=2
set showtabline=2

let g:lightline = {
      \   'colorscheme': 'seoul256',
      \   'active': {
      \     'left': [ [ 'mode', 'paste'  ],
      \               [ 'fugitive', 'gitgutter', 'filename' ] ],
      \     'right': [ [ 'neomake', 'lineinfo' ],
      \                [ 'percent' ],
      \                [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \   },
      \   'component_function': {
      \     'readonly': 'LightLineFugitive',
      \     'modified': 'LightLineModified',
      \     'fugitive': 'LightLineFugitive',
      \     'filename': 'LightLineFilename',
      \     'fileformat': 'LightLineFileformat',
      \     'filetype': 'LightLineFiletype',
      \     'fileencoding': 'LightLineFileencoding',
      \     'mode': 'LightLineMode',
      \     'gitgutter': 'LightLineSignify',
      \     'neomake': 'neomake#statusline#LoclistStatus',
      \   },
      \   'component_type': {
      \     'neomake': 'error',
      \   },
      \   'separator': { 'left': '', 'right': ''},
      \   'subseparator': { 'left': '|', 'right': '|'}
      \ }

function! LightLineModified()
  return &filetype =~# 'help\|undotree' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &filetype !~? 'help\|undotree' && &readonly ? '' : ''
endfunction

function! LightLineFugitive()
  if &filetype !~? 'undotree' && exists('*fugitive#head')
    let l:branch = fugitive#head()
    return l:branch !=# '' ? ' '.l:branch : ''
  endif
  return ''
endfunction

function! LightLineFilename()
  return ('' !=# LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' !=# expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' !=# LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (&fileencoding !=# '' ? &fileencoding : &encoding) : ''
endfunction

function! LightLineMode()
  let l:fname = expand('%:t')
  return l:fname =~# '__Tagbar__' ? 'Tagbar' :
        \ l:fname =~# 'undotree' ? 'Undotree' :
        \ l:fname =~# 'diffpanel' ? 'Diffpanel' :
        \ winwidth(0) > 60 ? g:lightline#mode() : ''
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'
function! TagbarStatusFunc(fname, ...) abort
  let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

function! LightLineSignify()
  let symbols = ['+', '-', '!']
  let [added, modified, removed] = sy#repo#get_stats()
  let stats = [added, removed, modified]  " reorder
  let hunkline = ''

  for i in range(3)
    if stats[i] > 0
      let hunkline .= printf('%s%s ', symbols[i], stats[i])
    endif
  endfor

  if !empty(hunkline)
    let hunkline = printf('%s', hunkline[:-2])
  endif

  return hunkline
endfunction
