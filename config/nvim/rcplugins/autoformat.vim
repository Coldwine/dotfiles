function! ESLintFix()
  silent execute '!'.nrun#Which('eslint') '--fix %'
  edit! %
  Neomake
endfunction

let g:formatdef_eslint = 'ESLintFix()'
let g:formatters_javascript = ['eslint']

let g:formatdef_stylefmt = '"stylefmt"'
let g:formatters_scss = ['stylefmt']
