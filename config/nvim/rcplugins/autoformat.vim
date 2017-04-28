" function! ESLintFix()
"   silent execute '!'.nrun#Which('eslint') '--fix %'
"   edit! %
"   Neomake
" endfunction

" let g:formatdef_eslint = 'ESLintFix()'
" let g:formatters_javascript = ['eslint']
let g:neoformat_enabled_javascript = ['prettiereslint']

let g:neoformat_enabled_scss = ['stylefmt']
function! neoformat#formatters#scss#stylefmt() abort
    return {
        \ 'exe': 'stylefmt',
        \ 'stdin': 1
        \ }
endfunction
